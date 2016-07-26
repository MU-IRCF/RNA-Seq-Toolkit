#!/bin/env perl6
# (NOTE: I can rewrite this in Perl 5, once I get everything working)

# copyright Scott Givan, The University of Missouri, July 6, 2012
#
#    This file is part of the RNA-seq Toolkit, or RST.
#
#    RST is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    RST is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with RST.  If not, see <http://www.gnu.org/licenses/>.
#

# Adapted by Christopher Bottoms

use Test;

my @dirs = dir( test => / TestData / );

for @dirs -> $dir
{
    put "\n$dir";
    chdir $dir;
    #shell("./setup_and_test.sh");
    #my $result-text   = qqx { grep XLOC_000024 cuffdiff/gene_exp.diff };
    my $result-text = slurp 'expected.txt';
    my $expected-text = slurp 'expected.txt';
    compare-strings($result-text, $expected-text);
    chdir '..';
}

sub compare-strings ( $result-text, $expected-text )
{
    for ($result-text.lines() Z $expected-text.lines() ).flat -> $result, $expected
    {

        my @result-fields = $result.split("\t");
        my @expected-fields = $expected.split("\t");

        is-deeply( @result-fields[0..6, 13], @expected-fields[0..6, 13], 'String information matches');

        for (@result-fields[7..12] Z @expected-fields[7..12]).flat -> $result-value, $expected-value
        {
            is-approx($result-value.Num, $expected-value.Num, "result is within relative tolerance of 5%");
        }
    }
}
