#!/bin/bash
set -e

## Check for Perl modules...
echo -e "\n Checking for Perl modules"
echo -n " Capture::Tiny .............. "
perl -e 'use Capture::Tiny;';
echo "PASS"

echo -n " Bio::Location::Simple ...... "
perl -e 'use Bio::Location::Simple;';
echo "PASS"

echo -n " Bio::Location::Split ....... "
perl -e 'use Bio::Location::Split;'
echo "PASS"

echo -n " Bio::Seq ................... "
perl -e 'use Bio::Seq;'
echo "PASS"

echo -n " Bio::SeqFeature::Generic ... "
perl -e 'use Bio::SeqFeature::Generic;'
echo "PASS"

echo -n " Bio::SeqIO ................. "
perl -e 'use Bio::SeqIO;'
echo "PASS"
echo; echo;

## Check for the various programs you need installed in your PATH
echo " Checking for software you need to have in your PATH"
echo -n " hmmsearch       -> "
which hmmsearch

echo -n " blastp          -> "
which blastp

echo -n " mga_linux_ia64  -> "
which mga_linux_ia64

echo -n " muscle          -> "
which muscle

echo -n " mcl             -> "
which mcl

echo -e "\n All done, looks good!"; echo; echo;

exit 0;
