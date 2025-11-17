#!/bin/bash 

#
# https://www.flawlessrhetoric.com/Using-libpst-to-convert-PST-to-MBOX,-and-understanding-Thunderbird%27s-folder-structure
#

out=$(basename $1)
out=${out%.*}
mkdir $out

#readpst -M -b -e -o export_folder pst_archive.pst
readpst  -u -o $out $1
#tree -apsDC .

find $out -type d | grep -v '^'"$out"'$' | tac | xargs -d '\n' -I{} mv {} {}.sbd
find $out -name mbox -type f | xargs -d '\n' -I{} echo '"{}" "{}"' | sed -e 's/\.sbd\/mbox"$/"/' | xargs -L 1 mv
find $out -empty -type d | xargs -d '\n' rmdir
find $out -type d | egrep '*.sbd' | sed 's/.\{4\}$//' | xargs -d '\n' touch
tree -apsDC .

