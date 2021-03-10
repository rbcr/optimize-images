#!/bin/bash
timestamp=$(date +%y%m%d%H%M%S)
quality=${quality:-100}

while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
   fi
  shift
done

for i in images/*.jpg; 
    do 
        i="${i//images\//''}"
        if [ $i != "*.jpg" ];
		then
            fileInfo=(${i//./ })
            basename=${fileInfo[0]}        
            len=(${#fileInfo[@]} - 1)
            for (( c=1; c<($len-1); c++ ))
            do
                basename+=".${fileInfo[$c]}"
            done
            extension=${fileInfo[${#fileInfo[@]} - 1]}
            newName="${basename}_${timestamp}.${extension}"
            cp "images/$i" output/$newName
            responseJPG=$(jpegoptim -m$quality -p "output/$newName")
            cat << EOF >> logs/compression_jpg.log
JPG | $i | $quality% | $responseJPG
EOF
		fi       
done

for i in images/*.png; 
    do
        i="${i//images\//''}"
        if [ $i != "*.png" ];
		then
            fileInfo=(${i//./ })
            basename=${fileInfo[0]};
            len=(${#fileInfo[@]} - 1)
            for (( c=1; c<($len-1); c++ ))
            do
                basename+=".${fileInfo[$c]}"
            done
            extension=${fileInfo[${#fileInfo[@]} - 1]}
            newName="${basename}_${timestamp}.${extension}"
            cp "images/$i" output/$newName
            responsePNG=$(optipng -quiet -fix --strip "all" -log logs/compresion_png.log output/$newName)
		fi       
done