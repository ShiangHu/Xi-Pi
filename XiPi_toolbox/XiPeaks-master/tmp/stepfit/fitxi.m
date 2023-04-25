function [b, k, x] = fitxi(psd,freq)
% Fit Xi-procss with Xi = exp(b)./(k+freq.^x)
% Input
%         psd --- nf*1, power spectrum density
%        freq --- nf*1, frequencies
% Output
%        b --- intercept
%        k --- knee parameter
%        x --- slope
% Reference: Voytek 2018, parameterizing the neural power spectrum

% Shiang Hu, Jul. 2018

[fma,fmi] = pkextrem(freq,psd,max(psd),1);  % return Xi if i=1
fmi=50;
[~,idxma] = min(abs(freq-fma));
[~,idxmi] = min(abs(freq-fmi));

b = log(psd(idxma));

% solve the transcondental function fmi^x - fma^x = psd(fma)/psd(fmi)-1;
t1 = freq(idxmi); t2 = freq(idxma); c = psd(idxma)/psd(idxmi)-1;
options.Display = 'none';
x=fmincon(@(x)abs(t1^x-t2^x-c),1,[],[],[],[],[],[],[],options);

k = 1 - t2^x;

freq_mod=freq; 

% freq_mod(freq>fmi)=freq_mod(freq>fmi).^2;
Xi = psd(idxma)./(k+freq_mod.^x);

% figure, plot(freq,[psd, Xi, psd-Xi],'linewidth',2); legend({'Real','Xi','Real-Xi'});
% xlim([0.3914 80]);ylim([0 max(psd)]);xlabel('F'),ylabel('PSD'); set(gca,'fontsize',12)
end