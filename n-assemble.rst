Running the actual assembly
===========================

Now we'll assemble all of these reads into a transcriptome, using
`the Trinity de novo transcriptome assembler <http://trinityrnaseq.github.io/>`__.

We've already installed the prerequisites (see :doc:`install`); 
now, install Trinity v2.2.0 itself::

   cd 
   curl -L https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.2.0.tar.gz > trinity.tar.gz
   tar xzf trinity.tar.gz
   mv trinityrnaseq* trinity/

   cd trinity
   make

Go into the work directory, and prepare the data::

   cd /mnt/work
   for i in *.dn.fq.gz
   do
      split-paired-reads.py $i
   done

   cat *.1 > left.fq
   cat *.2 > right.fq

Now, run the Trinity assembler::

   ~/trinity/Trinity --left left.fq --right right.fq --seqType fq --max_memory 10G --bypass_java_version_check

This will give you an output file ``trinity_out_dir/Trinity.fasta``.

Let's copy that to a safe place, where we'll work with it moving forward::

  cp trinity_out_dir/Trinity.fasta rna-assembly.fa

----

Next: :doc:`n-stats-eval`
