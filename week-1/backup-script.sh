#!/bin/bash

SOURCE_DIRECTORY=$1
COMPRESSION_FORMAT=$2
OUTPUT_FILE=$3

exec 2>>error.log

case $COMPRESSION_FORMAT in
bzip )
  TAR_ARGS="-cPjf"
  OUTPUT_FILE_EXTENSION="tar.bz2"
  ;;
gzip )
  TAR_ARGS="-cPzf"
  OUTPUT_FILE_EXTENSION="tar.gz"
  ;;
none )
  TAR_ARGS="-cPf"
  OUTPUT_FILE_EXTENSION="tar"
  ;;
* )
  echo "Specified compression format [${COMPRESSION_FORMAT}] is unsupported."
  echo "Use one of the following [none, bzip, gzip]"
  ;;
esac

if [[ -v TAR_ARGS ]]
then
  tar $TAR_ARGS "${OUTPUT_FILE}.${OUTPUT_FILE_EXTENSION}" "$SOURCE_DIRECTORY"
	openssl enc -aes-256-cbc -salt -in "${OUTPUT_FILE}.${OUTPUT_FILE_EXTENSION}" -out "${OUTPUT_FILE}.enc" 
	rm "${OUTPUT_FILE}.${OUTPUT_FILE_EXTENSION}"
fi