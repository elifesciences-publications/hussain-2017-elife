for i = 1:500
    X(i).moviename = 'simulation';
    X(i).condition = 'random_simulation';
    X(i).id = i;
    X(i).ML_frame = [0 randi(20)];
    X(i).life = 8;
    X(i).distance = rand*10 + 2;
    X(i).MSD = rand;
    X(i).Rsq = 0.95;
    X(i).linefit = rand(10,2);
    X(i).dispdistratio = rand;
    X(i).MSD_timestep = [1:8];
    X(i).MSD_D = rand;
    X(i).MSD_V = 0.025;
    X(i).MSD_alpha = 0.6;
    X(i).Rsq_log_log_MSD = 0.9;
    X(i).mag = 1;
    X(i).theta = 180*rand - 90;
    X(i).pos = [rand*100*0.0645 rand*100*0.0645];
    X(i).avg = [rand*100*0.0645 rand*100*0.0645];
    X(i).Rsq = 1;
    X(i).incell = 1;
    X(i).life = 10;
end

    