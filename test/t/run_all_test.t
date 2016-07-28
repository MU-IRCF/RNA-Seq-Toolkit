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

# Modified by Christopher Bottoms

use Test;

plan 70;

my $RELATIVE-TOLERANCE = 0.10;

my @dirs = dir( test => / TestData / );
my @test-match = <XLOC_000024 yes yes>;

die "uneqaul number of tests and directories" if @dirs.elems != @test-match.elems;

diag "running tests for these directories: @dirs[]";
diag "Please be patient; these might take 40 minutes to run.";

my @promises;

# TODO: Make all tests run in parallel
for @dirs.keys -> $index
{
    my $dir        = @dirs[$index]; 
    my $test-match = @test-match[$index];

    diag "Working in $dir";

    # to avoid chdir blunders, only doing directory changes inside the shell
    shell("cd $dir; ./setup_and_test.sh >& test.log");

    my $expected-text = slurp "$dir/expected.txt";
    my $result-text   = qqx { grep $test-match $dir/cuffdiff/gene_exp.diff };
    compare-strings($result-text, $expected-text, "in $dir: ");
}



sub compare-strings ( $result-text, $expected-text, $optional-prefix='' )
{
    for ($result-text.lines() Z $expected-text.lines() ).flat -> $result, $expected
    {

        my @result-fields   = $result.split("\t");
        my @expected-fields = $expected.split("\t");

        is-deeply( @result-fields[0..6, 13], @expected-fields[0..6, 13], $optional-prefix ~ 'String information matches');

        for (@result-fields[7..12] Z @expected-fields[7..12]).flat -> $result-value, $expected-value
        {
            is-approx $result-value.Num, $expected-value.Num, :rel-tol($RELATIVE-TOLERANCE), $optional-prefix ~ "result within relative tolerance of $RELATIVE-TOLERANCE";
        }
    }
}
