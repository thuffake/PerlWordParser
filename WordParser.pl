#!/usr/bin/perl
use strict;
use warnings;

use constant false => 0;
use constant true  => 1;

my @words;
my @words1;
my @words2;
my @wordcheck;
my $wordcheck=0;
my $word;
my $printword;
my $wordfreq;
my $bodoc1 = false;
my $bodoc2 = false;
my $bowordcheck = false;

print "Must include file type in document name, example, 'doc1.txt' \n";
print "Please type name of first document and press enter: \n"; #doc must exist in script directory
my $doc1 = <>;
print "Please type name of second document and press enter: \n"; #doc must exist in script directory
my $doc2 = <>;

print "Parsing...";

open (MYFILE, $doc1);          #opens file to parse, must exist already
while (<MYFILE>) {
     for $word (split) {
       #; <-- This semicolon is making the trouble, remove it, and the error message appears
       push (@words1, $word);
       push (@words, $word);
     }
 }
 close (MYFILE);
 
open (MYFILE, $doc2);          #opens file to parse, must exist already
while (<MYFILE>) {
     for $word (split) {
       push (@words2, $word);
       push (@words, $word);
     }
 }
 close (MYFILE);
 
foreach (@words) {
   $_ = lc ($_);                # Lowercases word in array
   $_ =~ s/[[:punct:]]//g;      # removes punctuation 
  }
@words = sort @words;           #sorts array alphabetically
 
 foreach (@words1) {
   $_ = lc ($_);                # Lowercases word in array
   $_ =~ s/[[:punct:]]//g;      # removes punctuation 
  } 
@words1 = sort @words1;         #sorts array alphabetically

 foreach (@words2) {
   $_ = lc ($_);                # Lowercases word in array
   $_ =~ s/[[:punct:]]//g;      # removes punctuation 
  } 
@words2 = sort @words2;         #sorts array alphabetically 

 open (MYFILE,'>index.txt');    #prints inverted index to file. > erases contents of file >> appends contents to file
 
 foreach (@words) {
   my $temp = $_;
   
   foreach (@words) {
    if ($temp eq $_) {          #Word Frequency 
      $wordfreq++;
    }
   } 
    
   foreach (@words1) {
    if ($temp eq $_) {          #docId check
      $bodoc1 = true;
    } 
   }
   
   foreach (@words2) {
    if ($temp eq $_) {          #docId check
      $bodoc2 = true;
    } 
   }
    
  foreach (@wordcheck) {        #checks if word has been outputted to index
   if ($temp eq $_) {
    $bowordcheck = true;
   }
  }
  
  if ($bowordcheck == false) {
  print MYFILE "$temp tf=";     #print contents of array to document, seperated by a line. 
   if ($wordfreq != 0) {
    print MYFILE "$wordfreq ";
   }
   if ($bodoc1 == true && $bodoc2 == true) {
    print MYFILE "docID=1,2\n";
   }
   if ($bodoc1 == true && $bodoc2 == false) {
    print MYFILE "docID=1\n";
   }
   if ($bodoc1 == false && $bodoc2 == true) {
    print MYFILE "docID=2\n";
   } 
  }
  
 push (@wordcheck, $temp);
 $wordfreq = 0;
 $bowordcheck = false;
 $bodoc1 = false;
 $bodoc2 = false;
}
 
 
 close (MYFILE);                #closes document. 
 
 print "Parsing complete. \nType a word and press enter to search for it in index, otherwise, type exit.\n";
 
 $word = <>;
 $word =~ s/^\s*(.*?)\s*$/$1/;
 $word = lc ($word);    
 my $check = false;
 
 while ($word ne "exit") {
  foreach (@words) {             #searches array of all words 
    if ($word eq $_) {
      $check = true;
      last;
    } 
   }
   if ($check == true){
    print "The term $word is in the index.\n";
   } else {
    print "The term $word is not in the index\n";
   }
  print "If you would like to search for a term again, type word and press enter, otherwise, type exit\n";
  $word = <>;
  $word =~ s/^\s*(.*?)\s*$/$1/;
  $word = lc ($word);
  $check = false;
 }