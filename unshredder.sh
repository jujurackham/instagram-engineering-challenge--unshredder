#!/bin/bash
# Instagram Engineering Challenge :
#       The Unshredder
#   Julien Lerouge, 29/12/2012
if [ $# -ne 1 ]
then
    echo "Usage: ./unshredder.sh [Shredded image filename]"
else
    if [ -f $1 ]
    then
        matlab -nodesktop -nosplash -r "unshred('$1');"
    else
        echo "File doesn't exist"
    fi
fi
