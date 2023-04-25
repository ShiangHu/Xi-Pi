function XiPi = xp_plot(XiPi,channel,varargin)
    i = 0;
    input = inputParser();
    input.addParameter('save_trg', '.',@ischar);
    input.addParameter('scale', 'natural',@ischar);
    input.parse(varargin{:});
    scale = input.Results.scale;
    saveTrg = input.Results.save_trg;
    
    freq = XiPi.freq;
    for i = channel
        gca = figure(i);
        if strcmp(scale,'natural')
            currentSpec = XiPi.spectra(i,:);
        else
            currentSpec = log10(XiPi.spectra(i,:));
        end
        plot(freq,currentSpec,'LineWidth',1.5,'DisplayName','Original')  % original
        hold on
        currentXi = XiPi.separate.xi(i,:);
        plot(freq,currentXi,'LineWidth',1.5,'DisplayName','AO fitting')  % xi
        currentPi = XiPi.separate.pi.("spectra_" + num2str(i));
        for j = 1 : size(currentPi,1)    % pi
            plot(freq,currentPi(j,:),'LineWidth',1.5,'DisplayName',['PO_',num2str(j),'fitting'])
        end
        title(['Separation result : ','Channel',num2str(i),])
        xlabel('freq/Hz')
        if strcmp(scale,'natural')
            ylabel('power')
        else
            ylabel('Log10(power)')
        end
        legend
        saveas(gca, [saveTrg,'/channel_',num2str(i),'.jpg'])
        close
    end

    
    % notify
    disp('success!')
    
    % write history
    insertLoc = length(fieldnames(XiPi.history)) + 1;
    XiPi.history.("history_" + num2str(insertLoc)) = 'plot results';
end
