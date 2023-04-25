function [c,ceq] = logcon(x,D)
% log concavity

c = D*log(x);

ceq = [];
end