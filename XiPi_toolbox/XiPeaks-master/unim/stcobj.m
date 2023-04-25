function f = stcobj(par,pks_real,freq)
pks_up = stc(par,freq);
f = sum(log(pks_up) + pks_real./pks_up);
end