#!/bin/bash
                for sub in $(cat $1)
                    do
                            python3 paramspider.py -d $sub --level high --exclude woff,css,png,svg,jpg
                    done
                    echo "Done"