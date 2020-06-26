% авторегрессионый фильтр
function mas_out = filt(mas_in, tay, k)

N = length(mas_in);
mas1 = zeros(1, N+tay);
mas_out = zeros(1, N+tay);
mas1(1:N) = mas_in;
mas_out(1:tay) = mas1(1:tay);

for i = tay+1 : tay+N
    mas_out(i) = mas1(i)-k* mas_out(i-tay);
end