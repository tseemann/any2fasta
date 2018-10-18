---
title: 'any2fasta: convert various sequence and alignment formats to FASTA'
tags:
  - bioinformatics
  - genomics
  - file format conversion
authors:
 - name: Torsten Seemann
   orcid: 0000-0001-6046-610X
   affiliation: "1, 2"
affiliations:
 - name: Melbourne Bioinformatics, The University of Melbourne, Parkville, Australia.
   index: 1
 - name: Doherty Applied Microbial Genomics, Department of Microbiology and Immunology, The University of Melbourne, Parkville, Australia.
   index: 2
date: 18 October 2018
bibliography: paper.bib
---

# Summary

FASTA is a simple and pervasive plain text file format for storing 
genetic sequence data [@pearson1988fasta]. There exist many other
richer formats for storing sequences and associated annotations 
and meta-data, such as the 
Genbank and EMBL flat files (http://www.insdc.org/documents/feature-table).
These formats often need to be converted to FASTA for use in 
downstream software that only handles the FASTA format.
Common tools for converting for format conversion are
EMBOSS `seqret` [@rice2000emboss] and `readseq` [@gilbert2003readseq].
Unfortunately these tools mangle sequence identifiers containing
characters such as `|` and `.` and offer no way to fix the behaviour.
Custom scripts using the Bioperl [@stajich2002bioperl] 
or Biopython [@cock2009biopython] libraries are available,
but these are heavyweight solutions for a relatively simple problem.

Here we present a new software tool called `any2fasta` written
as a single Perl script with no dependencies. It can read the
Genbank, EMBL, GFF, FASTA, FASTQ and GFA sequence formats, 
as well as the CLUSTAL and STOCKHOLM sequence alignment formats. 
The input files can be of mixed type, and may be compressed with
`gzip`, `bzip2` or `zip`. `any2fasta` is fast because it only
parses those parts of the input files needed to extract the 
sequence and its identifier.

# Acknowledgements

This work was supported by a National Health and Medical
Research Council of Australia Project Grant (ID 1149991).

# References

