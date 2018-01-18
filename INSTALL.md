# VirSorter Installation Instructions

VirSorter is a pipeline that detects viral contigs from microbial metagenomes (MMGs) and viral metagenomes (viromes). This pipeline is managed by a Perl script (`virsorter_wraper.pl`), which calls on a suite of other Perl scripts in the `scripts` directory. Thus there's nothing to compile in this repository, but there are some external programs and Perl modules you'll need to download and configure. This file should help you with finding and configuring those externeal dependencies. Oh, and there's a VirSorter database tar ball that you'll need too, but I haven't found the best way to recommend to get that yet.

## External Dependencies

There are a few programs (software) that you need to download and install into your Bash PATH and there are a few Perl modules you'll need in your in your [@INC](https://perlmaven.com/what-is-at-inc).

### Software

The following programs need to be installed in a directory that is in your Bash PATH:

- [HMMER](https://github.com/EddyRivasLab/hmmer)
- [MCL](http://micans.org/mcl/)
- [MetaGene Annotator](http://metagene.nig.ac.jp/metagene/download_mga.html)
- [MUSCLE](http://www.drive5.com/muscle/)
- [NCBI BLAST+](ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/)

### Perl Modules

## VirSorter Database


*Rev DJN 18Jan2018*
