#!/bin/bash

cat $1 | gau --subs --providers wayback,commoncrawl,otx,urlscan --o gau-res.txt

cat gau-res.txt | sort -u | tee $1-gau.txt

echo "Done"