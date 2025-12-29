#!/usr/bin/env bats

setup() {
  name="any2fasta"
  bats_require_minimum_version 1.5.0
  dir=$(dirname "$BATS_TEST_FILENAME")
  cd "$dir"
  exe="$dir/../$name -q"
  tab=$'\t'
  FASTA_ID=">NZ_CHER02000075"
}

@test "Script syntax check" {
  run -0 perl -c "$dir/../$name"
}
@test "Version" {
  run -0 $exe -v
  [[ "${lines[0]}" =~ "$name" ]]
}
@test "Help" {
  run -0 $exe -h
  [[ "$output" =~ "USAGE" ]]
}
@test "No parameters" {
  run ! $exe
}
@test "Bad option" {
  run ! $exe -Y
  [[ "$output" =~ "Unknown option" ]]
  [[ ! "$output" =~ "USAGE" ]]
}
@test "Passing a folder" {
  run ! $exe $dir
  [[ "$output" =~ "directory" ]]
}
@test "Empty input" {
  run ! $exe /dev/null
  [[ "$output" =~ "ERROR" ]]
}

@test "Handle FASTA" {
  run -0 $exe test.fna
  [[ "${lines[0]}" =~ "$FASTA_ID" ]]  
}
@test "Handle EMBL" {
  run -0 $exe test.embl
  [[ "${lines[0]}" == ">K02675" ]]  
}
@test "Handle FASTQ" {
  run -0 $exe test.fq
  [[ "${lines[0]}" =~ ">ERR1163317.1" ]]  
}
@test "Handle GENBANK" {
  run -0 $exe test.gbk
  [[ "${lines[0]}" =~ ">NZ_AHMY02000075" ]]  
}
@test "Handle GFF" {
  run -0 $exe test.gff
  [[ "$output" =~ ">BAC_00002" ]]  
}
@test "Handle STOCKHOLM" {
  run -0 $exe test.sth
  [[ "$output" =~ ">O83071/259-312" ]]  
}
@test "Handle CLUSTAL" {
  run -0 $exe test.clw
  [[ "$output" =~ ">gene03" ]]  
}
@test "Handle PDB" {
  run -0 $exe test.pdb
  [[ "$output" =~ ">1EK3-B" ]]  
}

@test "GZIP compression" {
  run -0 $exe test.fna.gz
  [[ "${lines[0]}" =~ "$FASTA_ID" ]]  
}
@test "BZIP2 compression" {
  run -0 $exe test.fna.bz2
  [[ "${lines[0]}" =~ "$FASTA_ID" ]]  
}
@test "XZ compression" {
  skip
  run -0 $exe test.fna.xz
  [[ "${lines[0]}" =~ "$FASTA_ID" ]]  
}
@test "ZSTD compression" {
  skip
  run -0 $exe test.fna.zst
  [[ "${lines[0]}" =~ "$FASTA_ID" ]]  
}
@test "ZIP compression" {
  run -0 $exe test.fna.zip
  [[ "${lines[0]}" =~ "$FASTA_ID" ]]  
}

@test "Test STDIN" {
  run -0 $exe - < test.fna
  [[ "${lines[0]}" =~ "$FASTA_ID" ]]  
}
@test "Test compressed STDIN" {
  run -0 $exe - < test.fna.gz
  [[ "${lines[0]}" =~ "$FASTA_ID" ]]  
}

@test "Test -l lowercase" {
  run -0 $exe -l test.fna
  [[ "${lines[1]}" =~ "aacryantctc" ]]  
}
@test "Test -u uppercase" {
  run -0 $exe -u test.embl
  [[ "${lines[1]}" =~ "AGTCGCTTTTAA" ]]  
}
@test "Test -n deambiguate" {
  run -0 $exe -n test.fna
  [[ "${lines[1]}" =~ "AACNNANTCTC" ]]  
}

@test "GFF with no sequence" {
  run ! $exe -n test.noseq.gff
  [[ "$output" =~ "No sequences found" ]]  
}
@test "Multiple sequence inputs" {
  run $exe test.fna test.embl test.pdb test.sth
  [[ "$output" =~ ">1EK3-B" ]]  
}
@test "Multiple sequence with one bad one" {
  run ! $exe test.fna test.jpg test.pdb test.sth
  [[ "$output" =~ "ERROR" ]]  
}
@test "Allow skipping over bad files" {
  run $exe -k test.fna test.jpg test.embl
  [[ "$output" =~ ">K02675" ]]  
}

@test "Handle EMBL -g" {
  run -0 $exe -g test.embl
  [[ "${lines[0]}" =~ ">K02675.1" ]]  
}
@test "Handle GENBANK -g" {
  run -0 $exe -g test.gbk
  [[ "${lines[0]}" =~ ">NZ_AHMY02000075.1" ]]  
}
