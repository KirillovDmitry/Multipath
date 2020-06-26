% функция демодуляция сигнала с одной боковой полосы
function z = ssbdemod_my(y, Fc, Fs, ini_phase)
	wid = size(y,1);
	if(wid ==1)
		y = y(:);
	end
	
	y = real(y);
	t = (0 : 1/Fs :(size(y,1)-1)/Fs)';
	z = y .* exp(-2*pi * Fc*1i * t + ini_phase);
	
	f1 = Fs - rem(2*Fc, Fs);
	f2 = rem(2*Fc, Fs);
	fc_temp =  min(Fs - rem(2*Fc, Fs),  rem(2*Fc, Fs));
	if Fc*2/Fs<1
		[num,den] = butter(5,Fc*2/Fs);
		z = filtfilt(num, den, z) *2;
	elseif fc_temp/Fs<1 && fc_temp/Fs>0
		if f1<f2
			[num,den] = butter(5,f1/Fs);
			z = filtfilt(num, den, z) *2;
		else
			[num,den] = butter(5,f2/Fs);
			z = filtfilt(num, den, z) *2;
		end  
	else
		[num,den] = butter(5, 0.78);
		z = filtfilt(num, den, z) *1;
	end
	
	if(wid == 1)
		z = z';
	end

wid = size(y,1);
if(wid ==1)
    y = y(:);
end
