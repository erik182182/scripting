#! /bin/bash

while getopts d:n: flag
do
    case "${flag}" in
        d) directory=${OPTARG};;
        n) name=${OPTARG};;
    esac
done


tar -cvf ${name}.tar $directory
gzip ${name}.tar

encoded=$( base64 ${name}.tar.gz )
echo $encoded

echo '#! /bin/bash' > name.sh
l1="path=\"$(pwd)/\""
echo $l1 >> name.sh
echo "while getopts o: flag" >> name.sh
echo "do" >> name.sh
l2="    case \"\${flag}\" in"
echo $l2 >> name.sh
l3="        o) path=\"\${OPTARG}\";;"
echo $l3 >> name.sh
echo "    esac" >> name.sh
echo "done" >> name.sh
firstLine="encoded=\"${encoded}\""
echo $firstLine >> name.sh
nextLine2="base64 -d <<- EOF >\${path}result.tar.gz"
nextLine3=" \${encoded}" 
nextLine4="EOF"
nextLine5="gunzip \${path}result.tar.gz"
l4="cd \${path}"
nextLine6="tar -xvf result.tar"
nextLine7="rm result.tar"
echo $nextLine2 >> name.sh
echo $nextLine3 >> name.sh
echo $nextLine4 >> name.sh
echo $nextLine5 >> name.sh
echo $nextLine6 >> name.sh
echo $nextLine7 >> name.sh

chmod a+x name.sh


