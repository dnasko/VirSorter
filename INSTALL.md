# VirSorter Installation Instructions

VirSorter is a pipeline that detects viral contigs from microbial metagenomes (MMGs) and viral metagenomes (viromes). This pipeline is managed by a Perl script (`virsorter_wraper.pl`), which calls on a suite of other Perl scripts in the `scripts` directory. Thus there's nothing to compile in this repository, but there are some external programs and Perl modules you'll need to download and configure. This file should help you with finding and configuring those externeal dependencies. Oh, and there's a VirSorter database tar ball that you'll need too, but I haven't found the best way to recommend to get that yet.

If you think everything is installed in your PATH, go ahead and try running the `check_requirements.sh` BASH script. It will go through all of the required Perl modules and software you should have in your PATH and let you know if anything is missing.

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

- Capture::Tiny
- Bio::Location::Simple
- Bio::Location::Split
- Bio::Seq
- Bio::SeqFeature::Generic
- Bio::SeqIO

You can install these modules pretty easy with cpanm (cpan minus), if it's installed:

```bash
cpanm Capture::Tiny
cpanm Bio::Perl
```

## VirSorter Database

Working on how this will be distributed. It's a pretty big TAR ball (3.7 GB).

*Rev DJN 25Jan2018*
