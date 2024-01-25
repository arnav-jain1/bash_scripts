#! /bin/bash

# Get the basename from the first arguement
BASE=$(basename "$1"); 
# If it is a directory call it with -r
if [[ -d $1 ]]; then 
    zip -r "${BASE}".zip "$1"
# Otherwise call it without
else 
    zip "${BASE}".zip "$1" 
fi 
