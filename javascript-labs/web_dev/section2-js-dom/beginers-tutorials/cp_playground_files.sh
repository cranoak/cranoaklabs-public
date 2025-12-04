#!/usr/bin/bash
FILE_NAME=$1
#echo $FILE_NAME
#for i in $(ll $FILE_NAME*|awk '{ print $9}'):
# for i in $(ll jsplaygroud*|awk '{ print $9}'):
for i in $(ll jsplaygroud*|awk '{ print $9}'):
do
# no break file into file_name and file_extenstion
echo "file $i"  
FILE_TYPE=$(echo $i|awk -F. '{print $2}')
echo $i has $FILE_TYPE file type.
# 
#echo " copying $i to $FILE_NAME.$FILE_TYPE"
cp $i $FILE_NAME.$FILE_TYPE
done