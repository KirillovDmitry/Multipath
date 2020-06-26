
% скрипт методом авторегрессионного анализа находит значения
% параметров (амплитуда, задержка) комплексного многолучевого сигнала
function [amp, tay, phi] = finder_complex(mas, range_tay, range_amp, range_phi1, range_phi2, amp0, start_l, end_l)
	Pow = zeros(length(range_tay),length(range_phi1));
    t1 = 0;
    while t1<length(range_tay)
        t1 = t1 + 1;
        t2 = 0;
        for phi0 = range_phi1
            t2 = t2 + 1;
            mas_filt = filt(mas, range_tay(t1), amp0*exp(1j*phi0));

            if end_l == 1
                mas_filt = mas_filt(1:length(mas));
            end

            if start_l == 1
                mas_filt = mas_filt(max(range_tay):end);
            end
            Pow(t1,t2) = norm(mas_filt.^2/2);
        end
    end


    [min_Pow, ind_tay] = min(Pow);
    [~, ind_phi] = min(min_Pow);
    
    tay = range_tay(ind_tay(ind_phi)); 
    
    Pow = zeros(length(range_amp),length(range_phi2));
    t1 = 0;
    for amp0 = range_amp
        t1 = t1 + 1;
        t2 = 0;
        for phi0 = range_phi2
            t2 = t2 + 1;
            mas_filt = filt(mas, tay, amp0*exp(1j*phi0));
            
            if end_l == 1
                mas_filt = mas_filt(1:length(mas));
            end

            if start_l == 1
                mas_filt = mas_filt(max(range_tay):end);
            end
            Pow(t1,t2) = norm(mas_filt.^2/2);
        end
    end
    
    [min_Pow, ind_amp] = min(Pow);
    [~, ind_phi] = min(min_Pow);
    
    amp = range_amp(ind_amp(ind_phi));
    phi2 =  range_phi2(ind_phi);
    phi = phi2;




    