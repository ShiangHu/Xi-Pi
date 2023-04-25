function [lhsm, grad, sigma, aic, bic]=scmobj(psd,freq,s,lmd)
% create the SCM objective function to utilize opt toolbox
% fisher scoring algorithm to fit single channel spetrum components model
% generate the approximation of information matrix and the score equation
% Input
%         freq ---- frequency bins, predictors
%         psd ---- power spectrum density for a single channel (in log scale)
%         s ---- [4*15] model parameters [rou, mu, tau, nu], peak amplitude,
%         position, peak half width, peak exponent
%         lmd ---- positive scalar, regularization paramater for L1 norm components
%         amplitudes
% Output
%         lhsm --- negative log likelihood
%         grad --- gradient vector
%         sigma --- fitted spectrum
%         abic --- Akaike/Bayesian information criteria

% Shiang Hu, Jul. 2018

if nargin==3, lmd=0; end
nf = length(freq);
% nk=15; % max # of components
ns = 26;  % # of segments
nw = 3.5; % # of slepian windows
sigma = zeros(nf,1);
grad=[];%zeros(4,nk,nf);
s (s<=1e-6)=0;

% spectrum reconstruction with maximum 15 components
% fmincon requires the objective function to be written in the scalar form
for f=1:nf
    omg = freq(f);
    sigma(f) = stc(s(:,1),omg)+stc(s(:,2),omg)+stc(s(:,3),omg)+stc(s(:,4),omg)+stc(s(:,5),omg)+...
        stc(s(:,6),omg)+stc(s(:,7),omg)+stc(s(:,8),omg)+stc(s(:,9),omg)+stc(s(:,10),omg)+...
        stc(s(:,11),omg)+stc(s(:,12),omg)+stc(s(:,13),omg)+stc(s(:,14),omg)+stc(s(:,15),omg);
    %     for j=1:nk
    %             [~,g]=stc(s(:,j),omg);
    %             grad (:,j,f)=g;
    %     end
end

% nk = sum(s(1,:)~=0);
% if nk>2
%     [~,sig_comp] = stc(s); % exculde Xi process
%     p = 1- pdist(sig_comp(:,2:nk)','cosine'); % orthogonalities
% else
%     p=0;
% end

p = 0;

sigma(sigma==0) =  eps;
lhsm = sum(log(sigma)+psd./sigma) + lmd*sum(abs(p));
aic = lhsm+2*sum(s(:)~=0);
bic = lhsm+log(nf*ns*nw*2)*sum(s(:)~=0);
% grad=mean(reshape(grad,[4*nk,nf]),2); grad(isnan(grad(:))|grad(:)==204)=0;
end