% в конечном итоге использована встроенная функция
function mas_out = delay(mas_in, tay)
	mas_out = circshift(mas_in,tay);
