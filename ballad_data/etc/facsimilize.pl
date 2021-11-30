#!/usr/bin/perl -CS -l

=encoding utf8

=head1 facsimilize.pl

Fix the facsimile markup.

=cut

use 5.014;
use utf8;
use strict;
use warnings;

use version; our $VERSION = qv(0.0_1);

use Data::Dumper; $Data::Dumper::Indent = 1;

binmode(STDIN, ':encoding(utf-8)');
binmode(STDOUT, ':encoding(utf-8)');

#  ------------------------------------- 

use File::Basename;
use File::Copy;
use XML::LibXML;
use XML::LibXML::XPathContext;
use XML::LibXSLT;

#  ------------------------------------- 

my $xslt = XML::LibXSLT->new();
my $tei2mods = XML::LibXML->load_xml(location => 'etc/tei2mods.xsl');
my $tx = $xslt->parse_stylesheet($tei2mods);

foreach my $filename (<data/*.xml>) {
  next if($filename =~ m/\.MODS\.xml$/);
  my $basename = basename($filename, '.xml');
  my $dom = XML::LibXML->load_xml(location => $filename);
  my $xpc = XML::LibXML::XPathContext->new($dom);
  $xpc->registerNs('tei', 'http://www.tei-c.org/ns/1.0');
  
  my @nodes = $xpc->findnodes('//tei:pb[@facs]');
  foreach my $node (@nodes) {
    my $f = $node->getAttribute('facs');    
    $f =~ m/_(\d+)\.png$/;
    my $n = $1;
    print "$filename - $basename.FACSIMILE_${n}.png";
    copy("facs/$f", "data/$basename.FACS_${n}.png");
  }
  
  my $mods = $tx->transform($dom, filename => "'${basename}.xml'");
  $tx->output_file($mods, "data/${basename}.MODS.xml");
}
