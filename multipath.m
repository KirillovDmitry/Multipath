    % главный скрипт проекта.
	% с помощью встроенных средст MATLAB реализован графический интерсфейс пользователя
	% для задачи рассчета многолучевого распространения сигнала и оценки качества
	% устранения влияния побочных каналов авторегрессионным методом
	
	%matlabpool open local 4  % запуск нескольких потоков
	close all; clear variables; clc;
    
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% инициализация переменных
    S    = 12500;                     % длина генерируемого массива
    L    = 10000;                     % вырезаемого окна
    N    = 1;                         % колличество эховых лучей
		 
    Fs   = 8e3;                       % частота дискретизации
    Fc1  =  50000;                    % ВЧ частота, больше чем Fs/2
    Fc   =  5000;                     % промежуточная частота, меньше чем Fs/2
    T    = S/Fs;
    t    = 0:1/Fs:T; t(end) = [];
    tay  = [470, 10, 0];              % задержка в отсчетах
    amp  = [0.8, 0.4, 0];             % относительная амплитуда
    faza = [80, 0.2, 0]*pi/180; 	 
    SNR  = 12;                        % отношение сигнал/шум
    N1   = 110;                       % усреднение
    N2   = 100;                        
    N3   = 1000;                       
    range_tay =  400:530;             % диапазон поиска по задержке
    range_amp = 0.1:0.1:1;     		  % диапазон поиска по амплитуде
    range_phi1 = linspace(0, 2*pi, 10);
    range_phi2 = linspace(0, 2*pi, 50);
    edge = 0;
    
    From   = 1;						  % начальное значение переменной моделирования
    To     = 20;                      % конечно значение переменной моделирования
    Step   = 0.8;					  % шаг изменения переменной моделирования
    Param  = 'SNR'; % 'a2' 'tay2' 'L' 'S' % параметр моделирования
    method = Param;
    Kind   = 'noise';
    Comp   = 0;
    Am 	   = 1;
    Demod  = 0;
    
	% параметр моделирования по второй координате
    XParam = 'Demod'; % 'a2' 'tay2' 'edge' 'S' 'L' 'Comp' 'Am' 'Demod'
    From_m = 0;
    To_m = 0;
    Step_m = 1;
    range_m = From_m:Step_m:To_m;
    
	% варьируем параметры с помощью вызова вспомогательного окна
    [N1, Kind, Param, From, To, Step, Comp, Am] = get_setup(N1, Kind, Param, From, To, Step, Comp, Am);
    
    range = From:Step:To; 				% дипазон моделирования
    data =  wavread('sound.wav');		% загружаем исходные данные из звукового файла

    Fs = 22050; % частота семплирования
    
	% инициализация массивов, используемых в процессе моделирования
	Tay = zeros(1,N2);
	T = zeros(1, N1);
	A = zeros(1, N1);
	Ph = zeros(1, N1);
	Tay_mean = zeros(length(range_m),length(range));
	Tay_error = zeros(length(range_m),length(range));
	Tay_std = zeros(length(range_m),length(range));
	Amp_mean = zeros(length(range_m),length(range));
	Amp_error = zeros(length(range_m),length(range));
	Amp_std = zeros(length(range_m),length(range));
	Phaza_mean = zeros(length(range_m),length(range));
	Phaza_error = zeros(length(range_m),length(range));
	Phaza_std = zeros(length(range_m),length(range));
	M = size(range_m);

	%% main gui
    TStart = tic;   dT = 0;
    screenSize = get(0,'ScreenSize');
    pointsPerPixel = 1;
    width = 500*pointsPerPixel;    height = 100*pointsPerPixel;
    pos = [screenSize(3)/2-width/2 screenSize(4)/2+height/1 width height];
    handles.WinBar = figure('MenuBar', 'None',...
        'BusyAction', 'queue',...
        'WindowStyle','normal',...
        'Interruptible', 'off', ...
        'DockControls', 'off', ...
        'Name', 'Time',...
        'NumberTitle', 'Off', ...
        'Visible','off',...
        'Position',pos);
    Txt = uicontrol('Style', 'Text',...
        'Position', [50, 15, 400, 70]);

    T0 = datestr(clock); str = ['начало моделирования: '  T0];
    set(Txt, 'String', str);
    set(handles.WinBar, 'Visible',    'on');

    zz = 0;
    h = waitbar(0,'Please wait...');

	% цикл вариации первой переменной
    for z = range
        dt = tic;
        zz = zz + 1;
		
		% в соответствии с выбранным методом генерируется необходимый массива
        switch Param
            case 'SNR'
                SNR = range(zz);
            case 'a2'
                amp(1) = range(zz);
            case 'tay2'
                tay(1) = range(zz);
            case 'S'
                S = range(zz);
            case 'L'
                L = range(zz);
            otherwise
                disp('ошибка выбора метода')
                pause;
        end
	
		% цикл по вариации второй переменной моделирования
        mmm = 0;
        while mmm < length(range_m);
            mmm = mmm + 1;
            xparam = range_m(mmm);

            % в соответствии с выбранным методом генерируется необходимый массива
			switch XParam
                case 'SNR'
                    SNR = range_m(mmm);
                case 'a2'
                    amp(1) = range_m(mmm);
                case 'tay2'
                    tay(1) = range_m(mmm);
                case 'edge'
                    edge = range_m(mmm);
                case 'S'
                    S = range_m(mmm);
                case 'L'
                    L = range_m(mmm);
                case 'Comp'
                    Comp = range_m(mmm);
                case 'Am'
                    Am = range_m(mmm);
                case 'Demod'
                    Demod = range_m(mmm);
                otherwise
                    disp('ошибка выбора метода')
                    pause;
            end
			
			% цикл усреднения по шуму
            parfor mm = 1:N1 % для параллельного вычисления необходимо запустить несколько потоков
            % for mm = 1:N1
				
				% переменная времени
                t = 0:1/Fs:S/Fs; t(end) = [];
				
				% загрузка или генерация данных
                if strcmp('signal', Kind)
                    mas =  wavread('sound.wav', S);
                else
                    mas = randn(1, S);
                end

                s = size(mas);
                if s(1) ~= 1
                    mas = mas';
                end
			
                PowerOfSignal = sum(mas.^2)/S;  % мощность исходного сигнала
				
				% генерация многолучевого сигнала
                if Comp == 0

                    mas_mult = zeros(1,S+max(tay(1:N)));
                    if Am == 1
                        mas_am = ssbmod(mas, Fc, Fs, 0);
                    else
                        mas_am = mas;
                    end

                    for i_ = 1:N
                        mas_mult(tay(i_)+1:tay(i_)+S) = amp(i_)*mas_am;
                    end
                    sigma2 = PowerOfSignal/(10^(SNR/10));
                    mas_mult(1:S) = mas_mult(1:S) + mas_am + sqrt(sigma2)*randn(1, S);
                    mas_window = mas_mult(1+ceil(S/2) - ceil(L/2) : L+ceil(S/2) - ceil(L/2));

                else

                    mas_mult = zeros(1,S+max(tay(1:N)));
                    if Am == 1
                        mas_am = ssbmod(mas, Fc, Fs, 0);
                    else
                        mas_am = mas;
                    end
                    mas = mas_am.*exp(1i*2*pi*Fc1*t);
                    for i_ = 1:N
                        mas_mult(tay(i_)+1:tay(i_)+S) = amp(i_)*mas*exp(1i*faza(i_));
                    end
                    sigma2 = PowerOfSignal/(10^(SNR/10));
                    mas_mult(1:S) = mas_mult(1:S) + mas+ sqrt(sigma2)/2*randn(1, S)+1i*sqrt(sigma2)/2*randn(1, S);
                    mas_window = mas_mult(1+ceil(S/2) - ceil(L/2) : L+ceil(S/2) - ceil(L/2));

                end

				% демодуляция многолучевого сигнала на нулевую ПЧ
                if Demod == 1 && Am == 1
                    if Comp == 0
                        mas_demod = ssbdemod(mas_window, Fc, Fs);
                    else
                        mas_window = mas_window.*exp(-1i*2*pi*Fc1*t);
                        mas_demod = ssbdemod(real(mas_window), Fc, Fs);
                    end
                end
				
				% нахождение задержки и амплитуды компонент многолучевого сигнала
                if Comp == 0
                    [a, t] = finder(mas_window, range_tay, range_amp, 1, edge, edge);
                    ph = faza(1);
                else
                    [a, t, ph] = finder_complex(mas_window, range_tay, range_amp, range_phi1, range_phi2, 1, edge, edge);
                end
				
				% найденные параметры многолучевого сигнала записываются в массив для каждого шага моделиривания
                T(mm)  = t;
                A(mm)  = a;
                Ph(mm) = ph;

            end
			
			% усреднеям результат при вариации шума
            Tay_mean(mmm, zz) = mean(T);
            Tay_error(mmm, zz)  = Tay_mean(mmm, zz) - tay(1);
            Tay_std(mmm, zz)     = std(T);

            Amp_mean(mmm, zz) = mean(A);
            Amp_error(mmm, zz)  = Amp_mean(mmm, zz) - amp(1);
            Amp_std(mmm, zz)     = std(A);

            Phaza_mean(mmm, zz) = mean(Ph);
            Phaza_error(mmm, zz)  = Phaza_mean(mmm, zz) - faza(1);
            Phaza_std(mmm, zz)    = std(Ph);

        end

        dT = dT + toc(dt);
        T_predict = dT*length(range)/zz;
        str = sprintf('Начало моделирования: %s.\nПредполагаемая дата окончания моделирования %s. \nПредполагаемое время моделирования %f сек.', datestr(T0), datestr(addtodate(datenum(T0), floor(T_predict),'second')), T_predict);
        set(Txt, 'String', str);
        waitbar( zz / length(range))
    end
    disp(str);
    fprintf('Окончание моделирования: %s.\n',datestr(clock));
    close('Time')
    close(h)
	% завершение основных циклов моделирования %
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% вывод результатов моделирования на графики
    Fig1 = figure('Name', 'FAR',...
        'NumberTitle', 'Off',...
        'Position', [200 50 1000 750] );

    Fig2= figure('MenuBar', 'None',...
        'Name', 'Tune',...
        'NumberTitle', 'Off',...
        'Position', [20 180 145 350]);

    List1 = {'Value', 'Error', 'Sko'};
    List2 = {'tay', 'amp', 'faza'};

    L2 =  uicontrol('Style', 'PopupMenu',   'String', List2, 'Position', [10, 317, 130, 30]);
    L1 =  uicontrol('Style', 'PopupMenu',   'String', List1, 'Position', [10, 295, 130, 30]);
    p1 =  uicontrol('Style', 'PushButton',  'String', 'plot', 'Tag', 'plot','Position', [10, 20, 130, 20], 'CallBack', 'output');
    p2 =  uicontrol('Style', 'PushButton',  'String', 'close', 'Tag', 'close','Position', [10, 0, 130, 20], 'CallBack', 'close all');
    
	 
    if strcmp('SNR', Param)
        Param_temp = 'Отношение сигнал/шум';
    end
    
    if strcmp('a2', Param)
        Param_temp = 'Амплитуда эхо-сигнала';
    end
    
    if strcmp('tay2', Param)
        Param_temp = 'Задержка эхо-сигнала';
    end
    
    if strcmp('L', Param)
        Param_temp = 'Длина окна';
    end
    
    if strcmp('S', Param)
        Param_temp = 'Длина сигнала';
    end

    p = figure(Fig1);
    clf

    switch get(L2, 'Value')
        case 1
            switch get(L1, 'Value')
                case 1
                    plot(range, Tay_mean);
                    ylabel('Задержка', 'FontSize',28, 'FontWeight', 'bold');
                case 2
                    plot(range, Tay_error);
                    ylabel('Ошибка измерения задержки', 'FontSize',28, 'FontWeight', 'bold');
                case 3
                    plot(range, Tay_std);
                    ylabel('СКО ошибки измерения задержки', 'FontSize',28, 'FontWeight', 'bold');
            end
        case 2
            switch get(L1, 'Value')
                case 1
                    plot(range, Amp_mean);
                    ylabel('Амплитуда', 'FontSize',28, 'FontWeight', 'bold');
                case 2
                    plot(range, Amp_error);
                    ylabel('Ошибка измерения амплитуды', 'FontSize',28, 'FontWeight', 'bold');
                case 3
                    plot(range, Amp_std);
                    ylabel('СКО ошибки измерения амплитуды', 'FontSize',28, 'FontWeight', 'bold');
            end
        case 3
            switch get(L1, 'Value')
                case 1
                    plot(range, Phaza_mean*180/pi);
                    ylabel('Фаза', 'FontSize',28, 'FontWeight', 'bold');
                case 2
                    plot(range, Phaza_error*180/pi);
                    ylabel('Ошибка измерения фазы', 'FontSize',28, 'FontWeight', 'bold');
                case 3
                    plot(range, Phaza_std*180/pi);
                    ylabel('СКО ошибки измерения фазы', 'FontSize',28, 'FontWeight', 'bold');
            end
            
    end
    
    xlabel(Param_temp, 'FontSize',28, 'FontWeight', 'bold');
    if M(2)>1
        title(XParam,  'FontSize',28, 'FontWeight', 'bold');
        legend(num2str(range_m'));
    end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% вспомогательные и отладочные скрипты %%%%%%%%%%%

%     % start item
% 	 setup;
% 	 generate;
% 	 mas_filt = filt(mas_window, tay(1), amp(1));
% 
% 	 figure(1)
% 	 plot(mas_filt)
% 	 hold on
% 	 plot(mas(1+ceil(S/2) - ceil(L/2) : L+ceil(S/2) - ceil(L/2)+30), 'r')
% 
% 	 ERR = (mas_filt(1:L) - mas(1+ceil(S/2) - ceil(L/2) : L+ceil(S/2) - ceil(L/2)));
% 	 figure(2)
% 	 plot(ERR.^2/2, 'r')
% 	
%     % определяем время переходного процесса фильтра по уровню 0.5 при вариациях разных параметров
%          setup;
%          Tay = zeros(1,N2);
%          for ii = 1:N2
%              amp(1) = range(ii);
%              T = zeros(1,N1);
%              for i = 1:N1
%     
% 			   mas = randn(1, S);
% 			   mas_mult = zeros(1,S+max(tay(1:N)));
% 			   for i_ = 1:N
% 				   mas_mult(tay(i_)+1:tay(i_)+S) = amp(i_)*mas;
% 			   end
% 			   mas_mult(1:S) = mas_mult(1:S) + mas + SNR*randn(1, S);
% 				   mas_window = mas_mult(1+ceil(S/2) - ceil(L/2) : L+ceil(S/2) - ceil(L/2));
%     
% 			   mas_filt = filt(mas_window, tay(1), amp(1));
% 			   ERR = (mas_filt(1:L) - mas(1+ceil(S/2) - ceil(L/2) : L+ceil(S/2) - ceil(L/2)));
% 			   ERR = ERR.^2/2;
%     
%                M = max(ERR);
%                m = -10;
%                j = L;
%                while m<M/2
%                    m = ERR(j);
%                    j = j - 1;
%                end
%                T(i) = j;
%              end
%              Tay(ii) = mean(T);
%          end
%     
%          figure(3)
%          plot(Tay, 'r')
% 	
% 	
%     % определяем энергию ошибки в зависимости от расстройки характеристик фильтра
% 	
%              setup;
%              generate;
%              POW = zeros(1,N2);
%              for ii = 1:N2
%                  amp_temp = range(ii);
%                  %tay_temp = range(ii);
%                  Pow = zeros(1,N1);
%                  for i = 1:N1
%                      generate;
%                      mas_filt = filt(mas_window, tay(1), amp_temp);
%                      ERR = (mas_filt(1:L) - mas(1+ceil(S/2) - ceil(L/2) : L+ceil(S/2) - ceil(L/2)));
%                      ERR = ERR(tay(1)*10:end);
%                      ERR = ERR.^2/2;
%                      Pow(i) = sum(ERR);
%                  end
%                  POW(ii) = mean(Pow);
%              end
%              figure(4)
%              plot(range, POW);
% 	
%     % поиск параметров сигнала
%              setup;
%              generate;
%              range_tay = 1:30;
%              range_amp = 0.2:0.02:1;
%              amp0 = 0.8;
%              start_l = 1;
%              end_l = 1;
%     
%              T = zeros(1,N1);
%              A = zeros(1,N1);
%              for i = 1:N1
%                  generate;
%                  [a t] = finder(mas_window, range_tay, range_amp, amp0, start_l, end_l);
%                  T(i) = t;
%                  A(i) = a;
%              end
%              figure(2)
%              plot( T,'r')
%              figure(3)
%              plot( A,'g');

