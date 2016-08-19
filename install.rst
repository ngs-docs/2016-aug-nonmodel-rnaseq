Installation of base image
==========================

1. Boot a recent Ubuntu on Amazon (wily 15.10 image or later)

2. Log in as user 'ubuntu'.

3. Run::

  sudo apt-get -y update && \
  sudo apt-get -y install r-base python3-matplotlib libzmq3-dev python3.5-dev \
     texlive-latex-extra texlive-latex-recommended python3-virtualenv \
     trimmomatic fastqc python-pip python-dev \
     bowtie samtools zlib1g-dev ncurses-dev

  sudo pip install -U setuptools khmer==2.0 jupyter jupyter_client ipython pandas

and done!
