#!/usr/bin/bash
FILE_NAME=$1
echo $FILE_NAME
for i in $(ll js*|awk '{ print $9}'):
do
# no break file into file_name and file_extenstion
echo "readying file $1"
FILE_TYPE=$(cat $1|awk -F. '{print $2}')
echo " copying $1 to $FILE_NAME.$FILE_TYPE"
echo cp $1 $FILE_NAME.$FILE_TYPE
done