#!/bin/bash
echo "Katana Started...!"

cat subdomains.txt | httpx | katana -d 18 -jc -kf -aff -ef css,png,svg,ico,woff,gif -cos logout -do -nc -silent | tee katana.txt

echo "Katana Done...!"

echo "gau Started...!"

cat subdomains.txt | gau --subs --providers wayback,commoncrawl,otx,urlscan --o gau-res.txt

cat gau-res.txt | sort -u | tee gau.txt

echo "gau Done...!"

echo "paramspider Started...!"
                    for sub in $(cat subdomains.txt)
                    do
                            python3 ParamSpider/paramspider.py -d $sub --level high --exclude woff,css,png,svg,jpg
                    done

echo "paramspider Done...!"

touch All-Parameters.txt

cat katana.txt gau.txt >> All-parameters.txt

cat output/* >> All-parameters.txt

echo "Finished...!"
