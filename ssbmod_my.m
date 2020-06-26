% функция модуляция сигнала с подавленной несущей и одной боковой полосой
function y = ssbmod_my(x, Fc, Fs, ini_phase)
	wid = size(x,1);
	if(wid ==1)
		x = x(:);
	end
	t = (0:1/Fs:((size(x,1)-1)/Fs))';
	y = (x-1i*imag(hilbert(x))) .* exp(2 * pi*1i * Fc * t + ini_phase);    
	
	if(wid == 1)
		y = y';
	end

wid = size(x,1);
if(wid ==1)
    x = x(:);
end

y = complex( x .* exp(1i * ini_phase) );    

if(wid == 1)
    y = y';
end
