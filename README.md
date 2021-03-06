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

| File                                     | Description                                                                                               |
| ---------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| VIRSorter_global-phage-signal.csv        | Comma-separated table listing the viral predictions from VirSorter (one row per prediction).              |
| Metrics_files/VIRSorter_affi-contigs.tab | Pipe-delimited table listing the annotation of all predicted ORFs in all contigs. **More details below.** |
| Predicted_viral_sequences/               | FASTA and Genbank files of predicted viral sequences.                                                     |
| Fasta_files/                             | Intermediary files, including predicted proteins.                                                         |
| Tab_files/                               | Intermediary files, including results of the search agasint PFAM and the virus database.                  |

**More details on VIRSorter_affi-contigs.tab file:** Lines starting with a ">" are "headers", i.e. information about the contig (contig name, number of genes, "c" for circular or "l" for linear). All other lines are information about the genes, with different columns as follows: Gene name, start, stop, length, strand, Hit in the virus protein cluster database, hit score, hit e-value, category of the virus protein cluster (see below), Hit in PFAM, hit score, hit e-value.

The categories of virus clusters represent the range of genomes in which this virus cluster was detected, i.e. 0: hallmark genes found in Caudovirales, 1: non-hallmark gene found in Caudovirales, 2: non-hallmarke gene found exclusively in virome(s), 3: hallmark gene not found in Caudovirales, 4: non-hallmark gene not found in Caudovirales.

## Dependencies

Check out the [INSTALL.md](https://github.com/dnasko/VirSorter/blob/master/INSTALL.md) file.

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

# Authors

Simon Roux <roux.8@osu.edu> is the author of Virsorter

*Rev DJN 26Jan2018*
