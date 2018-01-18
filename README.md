# VirSorter

This is **not** the Source code of the VirSorter App, (which is available on [CyVerse](https://de.iplantcollaborative.org/de/)). This is a forked version of the VirSorter repository merely cleaned up a touch to run easier outside of Docker. If you would like to check out the real VirSorter App simply head over to [Big Simon's repo](https://github.com/simroux/VirSorter).

The inspiration for me to fork this repository was to inforporate it into the [Baby Virome pipeline](https://github.com/dnasko/baby_virome), a lightweight and (somewhat) scaleable virome (viral metagenome) analysis pipeline.

The only modifications you'll see in this repository are meant to help the VirSorter code base improve in running time and commandline documentation (I hope). Oh, and to remove all of the Docker-related features and documentation. It's really difficult to run Docker on Linux systems at your instutitution or company because they won't dish out those sweet sweet sudo privileges (even if you have a PhD). And yeah you can run Docker without sudo, but good luck getting your IT department on board with that.

# Publication

* VirSorter: mining viral signal from microbial genomic data
* https://peerj.com/articles/985/
* PubMed 26038737

# Result files
The main output files of VirSorter are:
- VIRSorter_global-phage-signal.csv: Comma-separated table listing the viral predictions from VirSorter (one row per prediction)
- Metrics_files/VIRSorter_affi-contigs.tab: Pipe("|")-delimited table listing the annotation of all predicted ORFs in all contigs. Lines starting with a ">" are "headers", i.e. information about the contig (contig name, number of genes, "c" for circular or "l" for linear). All other lines are information about the genes, with different columns as follows: Gene name, start, stop, length, strand, Hit in the virus protein cluster database, hit score, hit e-value, category of the virus protein cluster (see below), Hit in PFAM, hit score, hit e-value.
The categories of virus clusters represent the range of genomes in which this virus cluster was detected, i.e. 0: hallmark genes found in Caudovirales, 1: non-hallmark gene found in Caudovirales, 2: non-hallmarke gene found exclusively in virome(s), 3: hallmark gene not found in Caudovirales, 4: non-hallmark gene not found in Caudovirales
- Predicted_viral_sequences/: fasta and genbank files of predicted viral sequences
- Fasta_files/: intermediary files, including predicted proteins
- Tab_files/: intermediary files, including results of the search agasint PFAM and the virus database.

# Docker - from DockerHub

* Download the databases required by VirSorter, available as a tarball archive on iMicrobe: http://mirrors.iplantcollaborative.org/browse/iplant/home/shared/imicrobe/VirSorter/virsorter-data.tar.gz
or /iplant/home/shared/imicrobe/VirSorter/virsorter-data.tar.gz through iPlant Discovery Environment
* Untar this package in a directory, e.g. /host/path/to/virsorter-data
* Pull VirSorter from dockerhub: $ docker pull discoenv/virsorter:v1.0.3
* Create a working directory for VirSorter which includes the input fasta file, e.g. /host/path/to/virsorter-run
* Then run VirSorter from docker, mounting the data directory as data, and the run directory as wdir:

    $ docker run -v /host/path/to/virsorter-data:/data -v /host/path/to/virsorter-run:/wdir -w /wdir --rm discoenv/virsorter:v1.0.3 --db 2 --fna /wdir/Input_contigs.fna

After "virsorter:v1.0.3", the options correspond to the ones described in wrapper_phage_contigs_sorter_iPlant.pl (here selecting the database "Viromes" and pointing VirSorter to the file "Input_contigs.fna").


# Docker - building packages from scratch


## Dependencies

Install the following into a "bin" directory:

* HMMER (http://hmmer.janelia.org/)
* MCL (http://micans.org/mcl/)
* Metagene Annotator (http://metagene.nig.ac.jp/metagene/download_mga.html)
* MUSCLE (http://www.drive5.com/muscle/)
* BLAST+ (ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/)


## Data Container

The 12G of dependent data exists as a separate data container 
called "virsorter-data."

This is the Dockerfile for that:

    FROM perl:latest

    MAINTAINER Ken Youens-Clark <kyclark@email.arizona.edu>

    COPY Generic_ref_file.refs /data/

    COPY PFAM_27 /data/PFAM_27

    COPY Phage_gene_catalog /data/Phage_gene_catalog

    COPY Phage_gene_catalog_plus_viromes /data/Phage_gene_catalog_plus_viromes

    COPY VirSorter_Readme.txt /data

    COPY VirSorter_Readme_viromes.txt /data

    VOLUME ["/data"]
  
Then do:

    $ docker build -t kyclark/virsorter-data .
    $ docker create --name virsorter-data kyclark/virsorter-data /bin/true

## Build

    $ docker build -t kyclark/virsorter .

## Run

A sample "run" command to use the current working directory for input/output:

    $ docker run --rm --volumes-from virsorter-data -v $(pwd):/de-app-work \
    -w /de-app-work kyclark/virsorter --fna Mic_1.fna --db 1

# Authors

Simon Roux <roux.8@osu.edu> is the author of Virsorter

Ken Youens-Clark <kyclark@email.arizona.edu> packaged this for Docker/iPlant.
