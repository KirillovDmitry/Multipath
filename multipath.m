    % ������� ������ �������.
	% � ������� ���������� ������ MATLAB ���������� ����������� ���������� ������������
	% ��� ������ �������� ������������� ��������������� ������� � ������ ��������
	% ���������� ������� �������� ������� ����������������� �������
	
	%matlabpool open local 4  % ������ ���������� �������
	close all; clear variables; clc;
    
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% ������������� ����������
    S    = 12500;                     % ����� ������������� �������
    L    = 10000;                     % ����������� ����
    N    = 1;                         % ����������� ������ �����
		 
    Fs   = 8e3;                       % ������� �������������
    Fc1  =  50000;                    % �� �������, ������ ��� Fs/2
    Fc   =  5000;                     % ������������� �������, ������ ��� Fs/2
    T    = S/Fs;
    t    = 0:1/Fs:T; t(end) = [];
    tay  = [470, 10, 0];              % �������� � ��������
    amp  = [0.8, 0.4, 0];             % ������������� ���������
    faza = [80, 0.2, 0]*pi/180; 	 
    SNR  = 12;                        % ��������� ������/���
    N1   = 110;                       % ����������
    N2   = 100;                        
    N3   = 1000;                       
    range_tay =  400:530;             % �������� ������ �� ��������
    range_amp = 0.1:0.1:1;     		  % �������� ������ �� ���������
    range_phi1 = linspace(0, 2*pi, 10);
    range_phi2 = linspace(0, 2*pi, 50);
    edge = 0;
    
    From   = 1;						  % ��������� �������� ���������� �������������
    To     = 20;                      % ������� �������� ���������� �������������
    Step   = 0.8;					  % ��� ��������� ���������� �������������
    Param  = 'SNR'; % 'a2' 'tay2' 'L' 'S' % �������� �������������
    method = Param;
    Kind   = 'noise';
    Comp   = 0;
    Am 	   = 1;
    Demod  = 0;
    
	% �������� ������������� �� ������ ����������
    XParam = 'Demod'; % 'a2' 'tay2' 'edge' 'S' 'L' 'Comp' 'Am' 'Demod'
    From_m = 0;
    To_m = 0;
    Step_m = 1;
    range_m = From_m:Step_m:To_m;
    
	% ��������� ��������� � ������� ������ ���������������� ����
    [N1, Kind, Param, From, To, Step, Comp, Am] = get_setup(N1, Kind, Param, From, To, Step, Comp, Am);
    
    range = From:Step:To; 				% ������� �������������
    data =  wavread('sound.wav');		% ��������� �������� ������ �� ��������� �����

    Fs = 22050; % ������� �������������
    
	% ������������� ��������, ������������ � �������� �������������
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

    T0 = datestr(clock); str = ['������ �������������: '  T0];
    set(Txt, 'String', str);
    set(handles.WinBar, 'Visible',    'on');

    zz = 0;
    h = waitbar(0,'Please wait...');

	% ���� �������� ������ ����������
    for z = range
        dt = tic;
        zz = zz + 1;
		
		% � ������������ � ��������� ������� ������������ ����������� �������
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
                disp('������ ������ ������')
                pause;
        end
	
		% ���� �� �������� ������ ���������� �������������
        mmm = 0;
        while mmm < length(range_m);
            mmm = mmm + 1;
            xparam = range_m(mmm);

            % � ������������ � ��������� ������� ������������ ����������� �������
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
                    disp('������ ������ ������')
                    pause;
            end
			
			% ���� ���������� �� ����
            parfor mm = 1:N1 % ��� ������������� ���������� ���������� ��������� ��������� �������
            % for mm = 1:N1
				
				% ���������� �������
                t = 0:1/Fs:S/Fs; t(end) = [];
				
				% �������� ��� ��������� ������
                if strcmp('signal', Kind)
                    mas =  wavread('sound.wav', S);
                else
                    mas = randn(1, S);
                end

                s = size(mas);
                if s(1) ~= 1
                    mas = mas';
                end
			
                PowerOfSignal = sum(mas.^2)/S;  % �������� ��������� �������
				
				% ��������� ������������� �������
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

				% ����������� ������������� ������� �� ������� ��
                if Demod == 1 && Am == 1
                    if Comp == 0
                        mas_demod = ssbdemod(mas_window, Fc, Fs);
                    else
                        mas_window = mas_window.*exp(-1i*2*pi*Fc1*t);
                        mas_demod = ssbdemod(real(mas_window), Fc, Fs);
                    end
                end
				
				% ���������� �������� � ��������� ��������� ������������� �������
                if Comp == 0
                    [a, t] = finder(mas_window, range_tay, range_amp, 1, edge, edge);
                    ph = faza(1);
                else
                    [a, t, ph] = finder_complex(mas_window, range_tay, range_amp, range_phi1, range_phi2, 1, edge, edge);
                end
				
				% ��������� ��������� ������������� ������� ������������ � ������ ��� ������� ���� �������������
                T(mm)  = t;
                A(mm)  = a;
                Ph(mm) = ph;

            end
			
			% ��������� ��������� ��� �������� ����
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
        str = sprintf('������ �������������: %s.\n�������������� ���� ��������� ������������� %s. \n�������������� ����� ������������� %f ���.', datestr(T0), datestr(addtodate(datenum(T0), floor(T_predict),'second')), T_predict);
        set(Txt, 'String', str);
        waitbar( zz / length(range))
    end
    disp(str);
    fprintf('��������� �������������: %s.\n',datestr(clock));
    close('Time')
    close(h)
	% ���������� �������� ������ ������������� %
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% ����� ����������� ������������� �� �������
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
        Param_temp = '��������� ������/���';
    end
    
    if strcmp('a2', Param)
        Param_temp = '��������� ���-�������';
    end
    
    if strcmp('tay2', Param)
        Param_temp = '�������� ���-�������';
    end
    
    if strcmp('L', Param)
        Param_temp = '����� ����';
    end
    
    if strcmp('S', Param)
        Param_temp = '����� �������';
    end

    p = figure(Fig1);
    clf

    switch get(L2, 'Value')
        case 1
            switch get(L1, 'Value')
                case 1
                    plot(range, Tay_mean);
                    ylabel('��������', 'FontSize',28, 'FontWeight', 'bold');
                case 2
                    plot(range, Tay_error);
                    ylabel('������ ��������� ��������', 'FontSize',28, 'FontWeight', 'bold');
                case 3
                    plot(range, Tay_std);
                    ylabel('��� ������ ��������� ��������', 'FontSize',28, 'FontWeight', 'bold');
            end
        case 2
            switch get(L1, 'Value')
                case 1
                    plot(range, Amp_mean);
                    ylabel('���������', 'FontSize',28, 'FontWeight', 'bold');
                case 2
                    plot(range, Amp_error);
                    ylabel('������ ��������� ���������', 'FontSize',28, 'FontWeight', 'bold');
                case 3
                    plot(range, Amp_std);
                    ylabel('��� ������ ��������� ���������', 'FontSize',28, 'FontWeight', 'bold');
            end
        case 3
            switch get(L1, 'Value')
                case 1
                    plot(range, Phaza_mean*180/pi);
                    ylabel('����', 'FontSize',28, 'FontWeight', 'bold');
                case 2
                    plot(range, Phaza_error*180/pi);
                    ylabel('������ ��������� ����', 'FontSize',28, 'FontWeight', 'bold');
                case 3
                    plot(range, Phaza_std*180/pi);
                    ylabel('��� ������ ��������� ����', 'FontSize',28, 'FontWeight', 'bold');
            end
            
    end
    
    xlabel(Param_temp, 'FontSize',28, 'FontWeight', 'bold');
    if M(2)>1
        title(XParam,  'FontSize',28, 'FontWeight', 'bold');
        legend(num2str(range_m'));
    end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% ��������������� � ���������� ������� %%%%%%%%%%%

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
%     % ���������� ����� ����������� �������� ������� �� ������ 0.5 ��� ��������� ������ ����������
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
%     % ���������� ������� ������ � ����������� �� ���������� ������������� �������
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
%     % ����� ���������� �������
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

