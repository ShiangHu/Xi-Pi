function sig = monofs(s)
% monotonicity fiting the Xi process with Newton Raphson method

lmd = 100;
kpa = 1e6;
nf = length(s);
D3 = diff(eye(nf),3);
D1 = diff(eye(nf),1);

maxIt = 1000;
tmp = zeros(nf,maxIt);

for i=1:maxIt
    if i==1
        sig = s;
    else
        sig = tmp(:,i-1);
    end
    
    V1 = diag(D1*sig>0);
    P = lmd*(D3)'*D3 + kpa*D1'*V1*D1;
    u = 2*P*sig + sig.^(-1) - s./sig.^2;
    H = 2*P - diag(sig.^(-2)) + 2*diag(s./sig.^3);
    tmp(:,i) = sig - pinv(H)*u;
    
    disp(i);
    if sum(abs(u))<1e-4
        break
    end
    
end

sig = tmp(:,i); 
end