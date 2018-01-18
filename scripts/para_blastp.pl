#!/usr/bin/perl

# MANUAL FOR para_phmmer.pl

=pod

=head1 NAME

para_phmmer.pl -- embarasingly parallel pHMMER

=head1 SYNOPSIS

 para_phmmer.pl --query=/Path/to/infile.fasta --db=/Path/to/db --out=/Path/to/output.tab [--evalue=1e-3] [--threads=4]
                     [--help] [--manual]

=head1 DESCRIPTION

=head1 OPTIONS

=over 3

=item B<-q, --query>=FILENAME

Input peptide query file in FASTA format. (Required) 

=item B<-d, --d>=FILENAME

Input peptide subject DB file in FASTA format. (Required)

=item B<-o, --out>=FILENAME

Path to output tab file. (Required)

=item B<-e, --evalue>=INT

E-value. (Default = 10)

=item B<-t, --threads>=INT

Number of CPUs to use. (Default = 1)

=item B<-h, --help>

Displays the usage message.  (Optional) 

=item B<-m, --manual>

Displays full manual.  (Optional) 

=back

=head1 DEPENDENCIES

Requires the following Perl libraries.



=head1 AUTHOR

Written by Daniel Nasko, 
Center for Bioinformatics and Computational Biology, University of Maryland.

=head1 REPORTING BUGS

Report bugs to dnasko@umiacs.umd.edu

=head1 COPYRIGHT

Copyright 2017 Daniel Nasko.  
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.  
This is free software: you are free to change and redistribute it.  
There is NO WARRANTY, to the extent permitted by law.  

=cut


use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Pod::Usage;
use threads;
use FindBin;
use Cwd 'abs_path';
my $script_working_dir = $FindBin::Bin;

#ARGUMENTS WITH NO DEFAULT
my($query,$db,$out,$help,$manual);
my $threads = 1;
my $evalue = 10;
my @THREADS;

GetOptions (	
				"q|query=s"	=>	\$query,
                                "d|db=s"        =>      \$db,
                                "o|out=s"       =>      \$out,
                                "e|evalue=s"    =>      \$evalue,
                                "t|threads=i"   =>      \$threads,
             			"h|help"	=>	\$help,
				"m|manual"	=>	\$manual);

# VALIDATE ARGS
pod2usage(-verbose => 2)  if ($manual);
pod2usage( {-exitval => 0, -verbose => 2, -output => \*STDERR} )  if ($help);
pod2usage( -msg  => "\n\n ERROR!  Required arguments --query not found.\n\n", -exitval => 2, -verbose => 1)  if (! $query );
pod2usage( -msg  => "\n\n ERROR!  Required arguments --db not found.\n\n", -exitval => 2, -verbose => 1)     if (! $db );
pod2usage( -msg  => "\n\n ERROR!  Required arguments --out not found.\n\n", -exitval => 2, -verbose => 1)    if (! $out );

my $program = "phmmer";
my $splitby = 2; ## How many threads should each split get?
my @chars = ("A".."Z", "a".."z");
my $rand_string;
$rand_string .= $chars[rand @chars] for 1..8;
print STDERR "OUTFILE --> " . $out . " <--\n\n";
my $outdir=dirname($out);
my $tmp_dir = $outdir . "/$program" . "_tmp_" . $rand_string;

## Check that phmmer in installed on this machine and in PATH
my $PROG = `which $program`; unless ($PROG =~ m/$program/) { die "\n\n ERROR: External dependency '$program' not installed in system PATH\n\n";}
my $date = `date`;
print STDERR " Using $threads threads\n";
print STDERR " Using this pHMMER: $PROG Beginning: $date\n";

## If only 1 thread is selected, just run the program as-is...
if ($threads == 1) {
    print `$program --cpu 1 -o $out.txt --tblout $out.tab -E $evalue $query $db`;
}
else {
    print `mkdir -p $tmp_dir`;
    print `chmod 700 $tmp_dir`;
    my %CoreDist = distribute_cores($threads, $splitby);
    my $nfiles = keys %CoreDist;
    my $seqs = count_seqs($query);
    my $seqs_per_thread = seqs_per_thread($seqs, $nfiles);
    $nfiles = split_multifasta($query, $tmp_dir, "split", $seqs_per_thread, $threads);
    print `mkdir -p $tmp_dir/result_splits`;
    for (my $i=1; $i<=$nfiles; $i++) {
	my $phmmer_exe = "$program --cpu $splitby -o $tmp_dir/result_splits/split.$i.txt --tblout $tmp_dir/result_splits/split.$i.tab -E $evalue $tmp_dir/split-$i.fsa $db";
	push (@THREADS, threads->create('task',"$phmmer_exe"));
    }
    foreach my $thread (@THREADS) {
	$thread->join();
    }
    print `cat $tmp_dir/result_splits/*.txt > $out.txt`;
    print `cat $tmp_dir/result_splits/*.tab > $out.tab`;
    print `rm -rf $tmp_dir`;
}
$date = `date`;
print STDERR "\n Parallel pHMMER complete: $date\n";

exit 0;

sub task
{
    system( @_ );
}

sub count_seqs
{
    my $q = $_[0];
    my $s = 0;
    open(IN,"<$q") || die "\n Cannot open the file: $q\n";
    while(<IN>) {
	chomp;
	if ($_ =~ m/^>/) { $s++; }
    }
    close(IN);
    return $s;
}

sub split_multifasta
{
    my $q       = $_[0];
    my $working = $_[1];
    my $prefix  = $_[2];
    my $spt     = $_[3];
    my $nfiles  = $_[4];
    my $j=0;
    my $fileNumber=1;
    print `mkdir -p $working`;
    open(IN,"<$q") || die "\n Cannot open the file: $q\n";
    open (OUT, "> $working/$prefix-$fileNumber.fsa") or die "Error! Cannot create output file: $working/$prefix-$fileNumber.fsa\n";
    while(<IN>) {
        chomp;
        if ($_ =~ /^>/) { $j++; }
        if ($j > $spt && $fileNumber < $nfiles) { #if time for new output file                                                                                                                                                           
            close(OUT);
            $fileNumber++;
            open (OUT, "> $working/$prefix-$fileNumber.fsa") or die "Error! Cannot create output file: $working/$prefix-$fileNumber.fsa\n";
            $j=1;
        }
        print OUT $_ . "\n";
    }
    close(IN);
    close(OUT);
    return $fileNumber;
}

sub seqs_per_thread
{
    my $s = $_[0];
    my $t = $_[1];
    my $seqs_per_file = $s / $t;
    if ($seqs_per_file =~ m/\./) {
        $seqs_per_file =~ s/\..*//;
        $seqs_per_file++;
    }
    return $seqs_per_file;
}

sub distribute_cores
{
    my $t = $_[0];
    my $by = $_[1];
    my %Hash;
    my $nsplits = calc_splits($t, $by);
    my $file=1;
    for (my $i=1; $i<=$t; $i++){
        $Hash{$file}++;
        if ($file==$nsplits) { $file = 0;}
        $file++;
    }
    return %Hash;
}

sub calc_splits
{
    my $t = $_[0];
    my $by = $_[1];
    my $n = roundup($t/$by);
    return $n;
}

sub roundup {
    my $n = shift;
    return(($n == int($n)) ? $n : int($n + 1))
}
