#!/bin/bash

katana -list $1 -d 18 -jc -kf -aff -ef css,png,svg,ico,woff,gif -cos logout -do -nc -silent | tee $1-katana.txt


echo "Done"