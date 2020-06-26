	
	% скрипт геренирует многолучевый сигнал
    mas = randn(1, S);
    mas_mult = zeros(1,S+max(tay(1:N)));

    for i_ = 1:N
        mas_mult(tay(i_)+1:tay(i_)+S) = amp(i_)*mas;
    end
    
    sigma2 = 0.5/(10^(SNR/10));
    mas_mult(1:S) = mas_mult(1:S) + mas + sqrt(sigma2)*randn(1, S);
    mas_window = mas_mult(1+ceil(S/2) - ceil(L/2) : L+ceil(S/2) - ceil(L/2));