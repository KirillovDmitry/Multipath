   
	% ����� ������ ����������� ������������� � ������� �����
	
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
 