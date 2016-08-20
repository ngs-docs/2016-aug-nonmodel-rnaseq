Quantification and Differential Expression of RNAseq with salmon
==========================================

Salmon is one of a breed of new, very fast RNAseq counting packages.
Like Kallisto and Sailfish, Salmon counts fragments without doing
up-front read mapping.  Salmon can be used with edgeR and others
to do differential expression analysis.

Salmon preprint: http://biorxiv.org/content/early/2015/06/27/021592

Salmon Web site: https://combine-lab.github.io/salmon/

Intro blog post: http://robpatro.com/blog/?p=248

A (very recent) blog post evaluating and comparing: https://cgatoxford.wordpress.com/2016/08/17/why-you-should-stop-using-featurecounts-htseq-or-cufflinks2-and-start-using-kallisto-salmon-or-sailfish/

Installation
------------

Download and unpack salmon, and add it to your path::

   cd
   curl -L -O https://github.com/COMBINE-lab/salmon/releases/download/v0.7.0/Salmon-0.7.0_linux_x86_64.tar.gz
   tar xzf Salmon-0.7.0_linux_x86_64.tar.gz
   export PATH=$PATH:$HOME/SalmonBeta-0.7.0_linux_x86_64/bin

Getting the data
----------------

Do::

   sudo chmod a+rwxt /mnt
   mkdir /mnt/data
   cd /mnt/data/
   curl -O https://s3.amazonaws.com/public.ged.msu.edu/nema-subset.tar.gz
   tar xzf nema-subset.tar.gz

(This is data from `Tulin et al., 2013
<http://www.evodevojournal.com/content/4/1/16>`__ that was processed
and assembled with `the khmer protocols steps 1-3
<http://khmer-protocols.readthedocs.org/en/ctb/mrnaseq/index.html>`__
-- basically, what we did in :doc:`n-quality`, but for the entire data set.)

Make a directory to work in::

   mkdir /mnt/quant

Copy in the transcriptome from the snapshot::

   cd /mnt/quant
   cp /mnt/data/nema.fa .

Index it with salmon::

   salmon index --index nema_index --transcripts nema.fa --type quasi   

Link the reads in that we downloaded::

   ln -fs /mnt/data/*.fq .

Now, quantify the reads against the reference using Salmon::

   for i in *.1.fq
   do
      BASE=$(basename $i .1.fq)
      salmon quant -i nema_index --libType IU \
             -1 $BASE.1.fq -2 $BASE.2.fq -o $BASE.quant;
   done

(Note that ``--libType`` must come *before* the read files!)

This will create a bunch of directories named something like
``0Hour_ATCACG_L002001.quant``, containing a bunch of files.  Take a look
at what files there are::

   find 0Hour_ATCACG_L002001.quant -type f

You should see::

   0Hour_ATCACG_L002001.quant/lib_format_counts.json
   0Hour_ATCACG_L002001.quant/cmd_info.json
   0Hour_ATCACG_L002001.quant/libParams/flenDist.txt
   0Hour_ATCACG_L002001.quant/aux_info/observed_bias.gz
   0Hour_ATCACG_L002001.quant/aux_info/observed_bias_3p.gz
   0Hour_ATCACG_L002001.quant/aux_info/expected_bias.gz
   0Hour_ATCACG_L002001.quant/aux_info/fld.gz
   0Hour_ATCACG_L002001.quant/aux_info/meta_info.json
   0Hour_ATCACG_L002001.quant/logs/salmon_quant.log
   0Hour_ATCACG_L002001.quant/quant.sf

The two most interesting files are ``lib_format_counts.json`` and ``quant.sf``.
The latter contains the counts; the former contains the log information
from running things.  Take a look at the counts metadata -- ::

   less 0Hour_ATCACG_L002001.quant/lib_format_counts.json

and see what you think it means... (Use 'q' to quit out of less.)

You might also be interested in the log file -- ::

   less 0Hour_ATCACG_L002001.quant/logs/salmon_quant.log

A few notes --

* what number should you be looking at?
* check out `the LIBTYPE docs <https://salmon.readthedocs.io/en/latest/salmon.html#what-s-this-libtype>`__

So, what should you pay attention to here? Let's list them out...

Working with the counts
-----------------------

Now, the ``quant.sf`` files actually contain the relevant information about
expression -- take a look::

   head -20 0Hour_ATCACG_L002001.quant/quant.sf

The first column contains the transcript names, and the
fifth column is what edgeR etc will want - the "raw counts".
However, they're not in a convenient location / format for edgeR to use;
let's fix that.

Download the ``gather-counts.py`` script::

   curl -L -O https://github.com/ngs-docs/2016-aug-nonmodel-rnaseq/raw/master/files/gather-counts.py

and run it::

   python ./gather-counts.py

This will give you a bunch of .counts files, processed from the quant.sf files
and named for the directory they are in.

Now, run an edgeR script (`nema.salmon.R
<https://github.com/ngs-docs/2016-aug-nonmodel-rnaseq/blob/master/files/nema.salmon.R>`__)
that loads all this in and calculates a few plots -- ::

   curl -O -L https://raw.githubusercontent.com/ngs-docs/2015-nov-adv-rna/master/files/nema.salmon.R
   Rscript nema.salmon.R

These will produce two plots, nema-edgeR-MDS.pdf and nema-edgeR-MA-plot.pdf.
Try downloading them to your computer using either MobaXTerm or CyberDuck.

----

You can see the plot outputs for the whole data set (all the reads) here:

* `nema-edgeR-MDS.pdf <https://github.com/ngs-docs/2015-nov-adv-rna/blob/master/files/nema-edgeR-MDS.pdf>`__
* `nema-edgeR-MA-plot.pdf <https://github.com/ngs-docs/2015-nov-adv-rna/blob/master/files/nema-edgeR-MA-plot.pdf>`__ (0 vs 6 hour)

A challenge exercise
--------------------

Download the entire counts data set::

  mkdir /mnt/fullquant
  cd /mnt/fullquant
  curl -L -O https://github.com/ngs-docs/2015-nov-adv-rna/raw/master/files/nema-counts.tar.gz
  tar xzf nema-counts.tar.gz

and run edgeR differential expression etc on it, as above.

Then, create an MA plot comparing 6 Hour vs 12 Hour.

----

`Return to agenda <AGENDA.md>`__
