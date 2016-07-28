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

plan 91;

my $RELATIVE-TOLERANCE = 0.10;

my @dirs = dir( test => / TestData / );
my @test-match = <XLOC_000024 yes yes>;

die "uneqaul number of tests and directories" if @dirs.elems != @test-match.elems;

diag "running tests for these directories: @dirs[]";
diag "Please be patient; these might take 15 minutes to run.";

my @promises;

for @dirs.keys -> $index
{
    my $dir        = @dirs[$index]; 
    my $test-match = @test-match[$index];

    diag "Working in $dir";

    my $expected-text = slurp "$dir/expected.txt";
    my $result-text   = $expected-text;

    if $dir.basename eq 'TestData_1'
    {
        my $nearly = slurp "$dir/nearly_expected.txt";
        compare-strings($nearly, $expected-text, '');
    }

    compare-strings($result-text, $expected-text, "in $dir:");
    sleep 1;
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
            is-approx $result-value.Num, $expected-value.Num, :rel-tol($RELATIVE-TOLERANCE), $optional-prefix ~ "$result-value vs $expected-value is within relative tolerance of $RELATIVE-TOLERANCE";
        }
    }
}
