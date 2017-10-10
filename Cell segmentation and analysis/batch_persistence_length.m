clear all
for xylose = [ 4  8  12 15 20 ]
    load(['frames' num2str(xylose) 'X0M_bEG300_recheck'])
    persistence_length
    disp(['xylose ' num2str(xylose) ' mM'])
    disp(avgcos)
    plot(avgcos, 'color',[rand rand rand])
    hold on
    clear frame
end