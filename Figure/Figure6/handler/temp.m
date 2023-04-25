plot(log10(freq),log10(wakeSpt),'linewidth',3,'lineStyle',':','color','#0E6BF8')
hold on
plot(log10(freq),log10(n2Spt),'linewidth',3,'lineStyle',':','color','#13F267')
plot(log10(freq),log10(remSpt),'linewidth',3,'lineStyle',':','color','#EA501C')

plot(log10(freq),log10(wake_psd_x),'linewidth',3,'color','#0E6BF8')
hold on
plot(log10(freq),log10(n2_psd_x),'linewidth',3,'color','#13F267')
plot(log10(freq),log10(rem_psd_x),'linewidth',3,'color','#EA501C')
legend('Wake','N2','REM','ξ-π fit - Wake','ξ-π fit - N2','ξ-π fit - REM')