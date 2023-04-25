function [sigma_components, sigma, gradstep]=stc(s,freq)
% Fit the spectrum with Student t curves given parameters s and frequencies omg
% Input
%       s --- [4*15] the parameter set [rou, mu, tau, nu]
%       freq --- [nf*1] frequency bin
% Output
%       sigma_components --- [nf*ank] reconstructed spectrum with different components
%       sigma --- fitted spectrum
%       gradstep --- [4*15] gradient
% See also SCMOBJ

% Shiang Hu, Jul. 2018

if nargin==1
    freq = 0.3914*(1:204)'; % default frequencies
end
if size(freq,2)~=1, freq=freq'; end

gradstep=zeros(4,15);
nk = size(s,2);
sigma_components = zeros(length(freq),nk);

for i=1:nk
    
    rou = s(1,i); mu = s(2,i); tau = s(3,i); nu = s(4,i);
    
    sigma_components(:,i) =  rou*(1+((freq-mu)/tau).^2).^(-nu);
    
    if nargout>2
        
        disp('Calculating theoretical gradient vector...');
        
        a = ((freq-mu)/tau).^2+1;
        
        gradstep(:,i)=sum([a.^(-nu), 2*rou*nu*(freq-mu)*tau^(-2).*a.^(-nu-1), 2*rou*nu*(freq-mu).^2*tau^(-3).*a.^(-nu-1), -rou*log(a).*a.^(-nu)]);
        
    end
    
 sigma = sum(sigma_components,2);
end