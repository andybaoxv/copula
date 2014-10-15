function stat = statistic_mi_kraskov(xs,ys,k)
    stat = max(helper_MIhigherdim([xs(:), ys(:)]', k),0)*log2(exp(1));
end