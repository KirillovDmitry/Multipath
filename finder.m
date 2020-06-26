% скрипт методом авторегрессионного анализа находит значения
% параметров (амплитуда, задержка) многолучевого сигнала
    function [amp, tay] = finder(mas, range_tay, range_amp, amp0, start_l, end_l)

    Pow = zeros(1,length(range_tay));

    t = 0;
    while t<length(range_tay)
        t = t + 1;
        mas_filt = filt(mas, range_tay(t), amp0);

        if end_l == 1
            mas_filt = mas_filt(1:length(mas));
        end

        if start_l == 1
            mas_filt = mas_filt(max(range_tay):end);
        end
        Pow(t) = sum(mas_filt.^2/2);
    end
    [~, ind_tay] = min(Pow);
    tay = range_tay(ind_tay);

    Pow = zeros(1,length(range_amp));
    i_temp = 0;
    for a = range_amp
        i_temp = i_temp + 1;
        mas_filt = filt(mas, tay, a);

        if end_l == 1
            mas_filt = mas_filt(1:length(mas));
        end

        if start_l == 1
            mas_filt = mas_filt(max(range_tay):end);
        end
        Pow(i_temp) = sum(mas_filt.^2/2);
    end

    [~, ind_amp] = min(Pow);
    amp = range_amp(ind_amp);
 

