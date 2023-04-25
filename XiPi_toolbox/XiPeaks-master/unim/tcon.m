function [x0, lb, ub, ank] = tcon(x0,freq)
% T curve constraints (t curve parameters bounds)
% x0 --- heuristically found t parameters
% odr --- order components as decending peak amplitudes

% order
[~,odr] = sort(x0(1,:),2,'descend');
[~,loc] = min(x0(2,x0(1,:)~=0));

odr = [loc setdiff(odr, loc, 'stable')];

% initial
nk = 15;
ank = sum(x0(1,:)~=0);
lb = zeros(4,nk);      ub = zeros(4,nk);
dltf = freq(2)-freq(1);

% set bounds
lb(1,:)=0.25*x0(1,:); ub(1,:)=x0(1,:);% rou
lb(2,:)=0.7*x0(2,:); ub(2,:)=1.2*x0(2,:);% mu
lb(3,1:ank)=dltf/2;    ub(3,1:ank)=40; % tau
lb(4,1:ank)=0.2;       ub(4,1:ank)=120; % nu

% order
x0 = x0(:,odr);
lb = lb(:,odr);           
ub = ub(:,odr);
end