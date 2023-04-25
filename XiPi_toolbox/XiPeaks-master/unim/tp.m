function par = tp(psd, freq, extrem)
% Estimate T curve papameters


fma = extrem.fma;
fmi = extrem.fmi;
dltf = freq(2)-freq(1); % freq resolution

% rou
[~,maxloc]=min(abs(freq-fma));
rou =psd(maxloc);

% mu
mu =freq(maxloc);

% tau (peak half)
tmp=abs(psd-0.5*rou)<0.08*rou;
tau=min(abs(freq(tmp)-mu));  
if isempty(tau), tau=dltf/2; end

% nu
[~,minloc]=min(abs(freq-fmi)); 
a=psd(minloc); 
if a<=0, a=eps; end

%error
nu =1.2*(log(a)-log(rou))/log((tau^2)/(tau^2+(freq(minloc)-mu)^2));

par = [rou; mu; tau; nu];
end