function [c,ceq] = othcon(x,k)
% Nonlinear function for fmincon
% Input
%        x --- the parameters
%        k --- current component to fit

th = 1e-2; % threshold for the cosine similarity of different conponents
ceq = [];

x(x<=1e-5) = 0;

[~,sig_comp] = stc(x);
nk = sum(x(1,:)~=0);

if k<=2
    c = th;
    return;   % Xi process
elseif nk>2
    c =  sum(1 - pdist2(sig_comp(:,k)',sig_comp(:,setdiff(2:nk,k))','cosine')) - th;
end