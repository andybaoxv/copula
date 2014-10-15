function [stat, stat2] = statistic_mic_minerva(xs,ys,alpha,c)
    minestats = mine_jbk(xs(:)',ys(:)',alpha,c);
    stat = minestats.mic;
    stat2 = minestats.mi;
end