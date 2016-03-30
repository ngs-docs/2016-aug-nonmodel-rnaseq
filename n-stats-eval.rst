Assembly statistics and evaluation
##################################

So, we now have an assembly of our reads in ``rna-assembly.fa``.  Let's
take a look at this file -- ::

  head rna-assembly.fa

This is a FASTA file with complex (and not, on the face of it, very
informative!) sequence headers, and a bunch of sequences.  There are
three things you might want to do with this assembly - check its
quality, annotate it, and search it.  Below we're going to check its
quality; other workshops do (will) cover annotation and search.

Applying transrate
------------------

::
   
   cd
   curl -O -L https://bintray.com/artifact/download/blahah/generic/transrate-1.0.2-linux-x86_64.tar.gz
   tar xzf transrate-1.0.2-linux-x86_64.tar.gz
   export PATH=~/transrate-1.0.2-linux-x86_64:$PATH

   transrate --assembly=/mnt/work/rna-assembly.fa

This should give you output like this::
   
   [ INFO] 2016-03-30 13:38:11 : n seqs                           62
   [ INFO] 2016-03-30 13:38:11 : smallest                        206
   [ INFO] 2016-03-30 13:38:11 : largest                        4441
   [ INFO] 2016-03-30 13:38:11 : n bases                       81132
   [ INFO] 2016-03-30 13:38:11 : mean len                    1308.58
   [ INFO] 2016-03-30 13:38:11 : n under 200                       0
   [ INFO] 2016-03-30 13:38:11 : n over 1k                        37
   [ INFO] 2016-03-30 13:38:11 : n over 10k                        0
   [ INFO] 2016-03-30 13:38:11 : n with orf                       41
   [ INFO] 2016-03-30 13:38:11 : mean orf percent              64.76
   [ INFO] 2016-03-30 13:38:11 : n90                             841
   [ INFO] 2016-03-30 13:38:11 : n70                            1563
   [ INFO] 2016-03-30 13:38:11 : n50                            1606
   [ INFO] 2016-03-30 13:38:11 : n30                            2070
   [ INFO] 2016-03-30 13:38:11 : n10                            3417
   [ INFO] 2016-03-30 13:38:11 : gc                             0.46
   [ INFO] 2016-03-30 13:38:11 : gc skew                       -0.04
   [ INFO] 2016-03-30 13:38:11 : at skew                       -0.05
   [ INFO] 2016-03-30 13:38:11 : cpg ratio                      1.88
   [ INFO] 2016-03-30 13:38:11 : bases n                           0
   [ INFO] 2016-03-30 13:38:11 : proportion n                    0.0
   [ INFO] 2016-03-30 13:38:11 : linguistic complexity          0.23

...which is pretty useful basic stats.

Note: don't use n50 to characterize your transcriptome, as with transcripts
you are not necessarily aiming for the longest contigs, and isoforms will
mess up your statistics in any case.

::
   
   transrate --assembly=/mnt/work/rna-assembly.fa --left=/mnt/work/left.fq --right=/mnt/work/right.fq --output=/mnt/work/transrate_reads

::

   [ INFO] 2016-03-30 13:43:11 : -----------------------------------
   [ INFO] 2016-03-30 13:43:11 : TRANSRATE OPTIMAL SCORE       0.036
   [ INFO] 2016-03-30 13:43:11 : TRANSRATE OPTIMAL CUTOFF     0.1589
   [ INFO] 2016-03-30 13:43:11 : good contigs                     27
   [ INFO] 2016-03-30 13:43:11 : p good contigs                 0.44


::

   transrate --install-deps ref


    transrate --assembly=/mnt/work/rna-assembly.fa --reference=/mnt/work/rna-assembly-nodn.fa --output=/mnt/work/assembly-compare

    transrate --reference=/mnt/work/rna-assembly.fa --assembly=/mnt/work/rna-assembly-nodn.fa --output=/mnt/work/assembly-compare
    
