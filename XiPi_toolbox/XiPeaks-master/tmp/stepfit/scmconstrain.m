function s=scmconstrain(s,oracle)
% constrains for the scm parameters
% Inputs
%          s --- current estimated parameters
% oracle --- true parameters
% Output
%          s --- constrained parameters
if sum(s)>500
    s(s>100,r+1)=oracle(s>500,1); % constrains
end

end