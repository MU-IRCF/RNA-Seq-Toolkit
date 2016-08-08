#!/bin/bash
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

module load samtools-1.3
module load cufflinks-2.2.1
module load TopHat-2.1.1
module load bowtie2-2.2.9

if [ -d ../.git ]
then
    t/refresh_test_dirs.sh
else
    echo "With no git repository found, these tests may only work once"
fi

# run each test in t/ (-e '' makes it use each test's own shebang for execution)
prove -e 'perl6' t/*.t6 |& tee t/test_results.log
