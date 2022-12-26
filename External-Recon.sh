#!/usr/bin/env bash
#crt.sh https://crt.sh
#subfinder https://github.com/projectdiscovery/subfinder
#assetfinder https://github.com/tomnomnom/assetfinder
#gau https://github.com/lc/gau
#subbrute https://github.com/blechschmidt/massdns/blob/master/scripts/subbrute.py
#dnsgen https://github.com/ProjectAnte/dnsgen
#massdns https://github.com/blechschmidt/massdns
#httpx https://github.com/projectdiscovery/httpx
#subfinder subs-sub
#gau subs-sub
#dnsgen subs-sub
#massdns subs-sub
#httpx subs-sub
#BGPVIEW asn & cidr ---> https://bgpview.io

####check line 39,44,51,81####
echo "getting subdomains from crt.sh...!"
 curl -sk "https://crt.sh/?q=%.$1&output=json" | jq -r '.[].name_value' | sort -u > $1-1subs.txt

echo "Step 1 finished!!"
#go-lang
echo "getting subdomains from subfinder...!"
 subfinder -d $1 -silent >> $1-1subs.txt

echo "Step 2 finished!!"
#go-lang
 echo "getting subdomains from assetfinder...!"
 assetfinder --subs-only $1 >> $1-1subs.txt

# echo "Step 3 finished!!"
#go-lang
echo "getting subdomains from gau...!"
  gau --subs $1 | cut -d / -f3 | sort -u >> $1-1subs.txt

echo "Step 4 finished!!"

echo "getting subdomains with subbrute...!"
 python3 subbrute.py wordlist.txt $1 >> $1-1subs.txt

echo "Step 5 finished!!"
#go-lang
echo "getting subdomains from dnsgen...!"
 echo $1 | dnsgen -w wordlist.txt - >> $1-1subs.txt

echo "Step 6 finished!!"
#go-lang
echo "checking subdomains with massdns...!"
 cat $1-1subs.txt | sort -u | massdns -r resolvers.txt -t A -o S > $1-2mass.txt
 cat $1-2mass.txt | awk '{print $1}' | sed 's/.$//' > $1-3clear-mass.txt

echo "Step 7 finished!!"
#go-lang
echo "checking subdomains from httpx...!"
 cat $1-3clear-mass.txt | httpx -silent -no-color | cut -c 9- > $1-4up-subs.txt

echo "Step 8 finished!!"
#go-lang
echo "getting subdomains from subfinder...!"
 subfinder -dL $1-4up-subs.txt -silent > $1-5subs-subdomain.txt

echo "Step 9 finished!!"
#go-lang
echo "getting subdomains from gau...!"
         for sub in $(cat $1-5subs-subdomain.txt)
         do
                  gau --subs $sub | cut -d / -f3 | sort -u >> $1-5subs-subdomain.txt
         done

echo "Step 10 finished!!"
#go-lang
echo "getting subdomains from dnsgen...!"
   for sub in $(cat $1-5subs-subdomain.txt)
         do
                      echo $sub | dnsgen - >> $1-5subs-subdomain.txt
         done

echo "Step 11 finished!!"
#go-lang chage
echo "checking subdomains with massdns...!"
 cat $1-5subs-subdomain.txt | sort -u | massdns -r resolvers.txt -t A -o S > $1-6end-mass.txt
 cat $1-6end-mass.txt | awk '{print $1}' | sed 's/.$//' > $1-7end-clear-mass.txt

echo "Step 12 finished!!"
#go-lang
echo "checking subdomains from httpx...!"
 cat $1-7end-clear-mass.txt | httpx -silent -no-color | cut -c 9- >> $1-4up-subs.txt

echo "Step 13 finished!!"

echo "Checking AS Number&CIDR!"
      for IP in $(dig +short $1);
      do
          curl -s https://api.bgpview.io/ip/$IP | jq -r ".data.prefixes[]" > $1-ASNumberandinfo.txt
      done
echo "Step 14 finished!!"





echo "DONE!!!"





echo "Created by X.E.R.O"
