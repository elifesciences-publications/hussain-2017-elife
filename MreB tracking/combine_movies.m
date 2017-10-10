all_pairs=struct([]);
parfor movie = 1:28
    pair_inmovie = load(['pairs_inmovie' num2str(movie)])
    all_pairs = [all_pairs pair_inmovie];
    disp([num2str(movie) ' done'])
end

save('combined_knockoutpairs', 'all_pairs')