#!/bin/bash
echo "Katana Started...!"

katana -list $1 -d 18 -jc -kf -aff -ef css,png,svg,ico,woff,gif -cos logout -do -nc -silent | tee $1-katana.txt

echo "Katana Done...!"

echo "gau Started...!"

cat $1 | gau --subs --providers wayback,commoncrawl,otx,urlscan --o gau-res.txt

cat gau-res.txt | sort -u | tee $1-gau.txt

echo "gau Done...!"

echo "paramspider Started...!"
                    for sub in $(cat $1)
                    do
                            python3 ParamSpider/paramspider.py -d $sub --level high --exclude woff,css,png,svg,jpg
                    done

echo "paramspider Done...!"

touch All-Parameters.txt

cat $1-katana.txt $1-gau.txt >> All-parameters.txt

cat ParamSpider/output/* >> All-parameters.txt

echo "Finished...!"