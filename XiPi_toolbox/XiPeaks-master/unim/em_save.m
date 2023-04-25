function [sigIt,  lh] = em_save(sigIt,  lh, sigk, sige, sigk_sdo, sige_sdo, i)   
% 
    sigIt.K(:,:,i+1) = sigk;
    
    sigIt.E(:,i+1) = sige;
    
    sigIt.sdo(:,:,i) = sigk_sdo;
    
    lh(i) = sum(log(sige) + sige_sdo./sige);

end