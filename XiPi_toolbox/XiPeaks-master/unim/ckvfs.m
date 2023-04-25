function sig = ckvfs(s)
% concave fiting the Xi process with Newton Raphson method

lmd = 100;
kpa = 1e6;
nf = length(s);
D3 = diff(eye(nf),3);
D2 = diff(eye(nf),2);

maxIt = 1000;
tmp = zeros(nf,maxIt);

for i=1:maxIt
    if i==1
        sig = s;
    else
        sig = abs(tmp(:,i-1)); sig(sig==0) = eps;
    end
    
    V2 = diag(D2*sig>0);
    u = 2*0.01*eye(nf)*sig + 2*lmd*(D3)'*D3*sig + 2*kpa*D2'*V2*D2*log(sig)./sig + sig.^(-1) - s./sig.^2;
    H = 2*0.01*eye(nf) + 2*lmd*(D3)'*D3 + 2*kpa*D2'*V2*D2*diag((1 - log(sig))./sig.^2) - diag(sig.^(-2)) + 2*diag(s./sig.^3);
    
    tmp(:,i) = sig - pinv(H)*u;
    
    disp(i);
    if sum(abs(u))<1e-4
        break
    end
    
end

sig = tmp(:,i); 
end