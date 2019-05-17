[![Build Status](https://travis-ci.org/tseemann/any2fasta.svg?branch=master)](https://travis-ci.org/tseemann/any2fasta) 
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![Don't judge me](https://img.shields.io/badge/Language-Perl_5-steelblue.svg)

# any2fasta

Convert various sequence formats to FASTA

## Motivation

You may wonder why this tool even exists.  Well, I tried to do the right
thing and use established tools like `readseq` and `seqret` from EMBOSS, but
they both mangled IDs containing `|` or `.` characters, and
there is no way to fix this behaviour.  This resulted in inconsitences
between my `.gbk` and `.fna` versions of files in my pipelines.

Then you may wonder why I didn't use Bioperl or Biopython. Well they are
heavyweight libraries, and actually very slow at parsing Genbank files.
This script uses only core Perl modules, has no other dependencies, and
runs very quickly.

It supports the following input formats:

1. Genbank flat file, typically `.gb`, `.gbk`, `.gbff` (starts with `LOCUS`)
2. EMBL flat file, typically `.embl`, (starts with `ID`)
3. GFF with sequence, typically `.gff`, `.gff3` (starts with `##gff`)
4. FASTA DNA, typically `.fasta`, `.fa`, `.fna`, `.ffn` (starts with `>`)
5. FASTQ DNA, typically `.fastq`, `.fq` (starts with `@`)
6. CLUSTAL alignments, typically `.clw`, `.clu` (starts with `CLUSTAL` or `MUSCLE`)
7. STOCKHOLM alignments, typically `.sth` (starts with `# STOCKHOLM`)
8. GFA assembly graph, typically `.gfa` (starts with `^[A-Z]\t`)

Files may be compressed with:

1. gzip, typically `.gz`
2. bzip2, typically `.bz2`
3. zip, typically `.zip`

## Installation

`any2fasta` has no dependencies except [Perl 5.10](https://www.perl.org/)
or higher. It only uses core modules, so no CPAN needed.

### Direct script download
```
% cd /usr/local/bin  # choose a folder in your $PATH
% wget https://raw.githubusercontent.com/tseemann/any2fasta/master/any2fasta
% chmod +x any2fasta
```
### Homebrew
```
% brew install brewsci/bio/any2fasta
```
### Conda
```
% conda install -c bioconda any2fasta
```
### Github
```
% git clone https://github.com/tseemann/any2fasta.git
% cp any2fasta/any2fasta /usr/local/bin # choose a folder in your $PATH
```

## Test Installation

```
% ./any2fasta -v
any2fasta 0.2.2

% ./any2fasta -h
NAME
  any2fasta 0.4.2
SYNOPSIS
  Convert various sequence formats into FASTA
USAGE
  any2fasta [options] file.{gb,fa,fq,gff,gfa,clw,sth}[.gz,bz2,zip] > output.fasta
OPTIONS
  -h       Print this help
  -v       Print version and exit
  -q       No output while running, only errors
  -n       Replace ambiguous IUPAC letters with 'N'
  -l       Lowercase the sequence
  -u       Uppercase the sequence
END
```

## Examples
```
% any2fasta ref.gbk > ref.fna

% any2fasta in.fasta > out.fasta  # should behave like "cat"

% any2fasta prokka.gff > prokka.fna  # only if GFF has FASTA appended

% any2fasta - < file.gb > file.fasta  # '-' means stdin

% anyfasta genes.gff.gz > genes.ffn  # automatically decompresses

% any2fasta 1.gb 2.fa.gz 3.gff.bz2 - > out.fa  # multiple files and stdin

% any2fasta R1.fq.gz | bzip2 > R1.fa.bz2  # 'seqtk seq -A' is much faster

% any2fasta -q 23S.clw > 23S.aln  # gaps '-' will be preserved

% any2fasta pfam4321.sth > pfam4321.aln  # '.' gaps will become '-'
```

## Options

* `-n` replaces any characters that aren't A,C,G,T with N (gaps preserved)
* `-l` will lowercase all the letters
* `-u` will uppercase all the letters
* `-q` will prevent logging messages being printed

## Issues

Submit feedback to the [Issue Tracker](https://github.com/tseemann/any2fasta/issues)

## License

[GPL v3](https://raw.githubusercontent.com/tseemann/any2fasta/master/LICENSE)

## Author

[Torsten Seemann](http://tseemann.github.io/)
