function [stats, statnames] = helper_evaluate_statistics(xs,ys)
    % Containers
    stats = [];
    statnames = {};

    % MIC Reshef
    % Need to do this weirdness because MIC glitches a fraction of the time
    statnames{1} = 'MIC (Reshef)';
    a = statistic_mic_reshef(xs,ys);
    k = 0;
    while numel(a) ~= 1;
        k = k+1;
        disp(['MIC glitch number ' num2str(k) '. Trying again...'])
        a = statistic_mic_reshef(xs,ys);
    end
    stats(1) = a;
    
    % MIC (and I_MIC) Albanese
    alpha = 0.6;
    c = 15;
    statnames{2} = 'MIC (Albanese)';
    statnames{3} = 'MI (MIC Albanese)';
    [stats(2), stats(3)] = statistic_mic_albanese(xs,ys,alpha,c);
    
    % MI Kraskov with various k
    statnames{4} = 'MI (Kraskov k=1)';
    stats(4) = statistic_mi_kraskov(xs,ys,1);
    
    statnames{5} = 'MI (Kraskov k=6)';
    stats(5) = statistic_mi_kraskov(xs,ys,6);
    
    statnames{6} = 'MI (Kraskov k=20)';
    stats(6) = statistic_mi_kraskov(xs,ys,20);
    
    % R^2
    statnames{7} = 'R^2';
    stats(7) = statistic_sqcorr(xs,ys);
    
    % dCor
    statnames{8} = 'dCor';
    stats(8) = statistic_dcor(xs,ys);
    
    % Hoeffding's D
    statnames{9} = ['Hoeffding''', 's D'];
    stats(9) = statistic_hoeffding(xs,ys);
    
    % Make stats a column vector
    stats = stats(:);
end