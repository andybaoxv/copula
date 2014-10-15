To do computations for figures, execute this command in Matlab:
>> run_all_computations
Results of these computations are stored in results/

To make all figures shown in the main text and si text, execute this command in Matlab:
>> run_all_figures
The resulting .eps figures are stored in figures/

To run computations on BNB, do the following:
> qsub -cwd -v LD_LIBRARY_PATH=/opt/hpc/lib64 run_job.sh
Note: the library path needs to be passed explicitly; otherwise stupid BNB can't find matlab. 

- Justin B. Kinney, August 13, 2013
