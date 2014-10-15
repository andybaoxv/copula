1) Adam sent ccore.R, ccoreTies.R on June 26, 2014
------------------------------------------------
Yi, 

I have been discussing the next steps in applying Ccor with Professor Dy and her student Yale Chang. We are going to start with some feature selection application with our current estimator. Could you please work with Yale on this? 

I am attaching the R codes for our estimator in the two files. (There are two versions: ccore and ccore.p, both give the same value in practice. Personally I prefer ccore.p as it corresponds to the stable theoretical version IF the kernel density estimator does not integral to one. The definition is for continuous random variables. If there are ties in data, the ccore.tie and ccore.tie.p should be used.) Those are codes from last December. I believe there are no changes by Yi since. 

Yale and Yi should talk and solve any questions between. We are meeting every two Thursday 11:30am. Yi should join in next time (July 10th).

Yi, please tell Professor Dy which section of the Machine Learning course in Fall you are trying to join, so that she can inform the registrar to make an exception for you.

I am leaving the day after tomorrow for Taiwan. You all enjoy a great July 4th! 

See you later,

2) Adam sent on July 17, 2014
------------------------------

Here is the summary of this morning's meeting. We should work on
(0) The Ccor with one or both variable discrete. Yi should figure out the exact formula. Right now, just for one variable Y as binary. Get the Ccor code to Yale, and Yale can check if that improves the performance for classification data sets.
(1) Develop nearest-neighbors estimator for Ccor. Then that can be used to estimate Ccor in higher-dimension.
(2) Define the conditional Ccor(X,Y|Z), and develop estimators.
(3) Find examples that can illustrate advantage of Ccor in feature selection. 
The settings we considered are (a) regression, (b) classification, (c) ranking outputs. We think that (a) and (c) are the ones easier to work with Ccor. 
Alternatively, we can develop examples to show (d) stability of the features selected by Ccor. However, as we discussed, the stability under transformation of variables are not unique for Ccor. That is self-equitability. MI and CD2 (which can be estimated with normalized HSIC) are also self-equitable. So need to think about the stability issue more. 
The examples most likely to show Ccor's advantage are where there are different sample sizes. We can create this by starting with a real data set: select the top features. Then artificially drop a big amount, say 90%, of data on the top feature, and see if it can still be selected. (For synthetic data, if we make one feature much stronger than others, dropping 90% of data, it can still be selected by Ccor. But if this one feature is not much stronger than rest, dropping data would bias against selecting it for all measures including Ccor.)

Since we are aiming at the AI-STAT with Oct 24 deadline, we should focus on (3) here. First try the Ccor on some regression data. Then think about how to create examples where Ccor will work better, by finding the examples with mismatched data sizes on different variables. 

Let me know if you have further thoughts. I shall email Yale a working revision of the earlier paper, this evening. 

Best,

3) Yi Li sent ccor01.R on July 24, 2014
-----------------------
亚乐你好，

你可以先用附件里的函数运行y是0/1的情况（x是连续的）。里面ccore01函数是没scale的，ccor01函数是scale的（就是拉伸到0，1之间的）。里面求最大最小值的地方我可能还要再改，不过你可以先用这个算。 这个是R的，Matlab的话我再看看。

李毅


