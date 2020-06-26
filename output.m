   
	% скрип вывода результатов моделирования в главную форму
	
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
 