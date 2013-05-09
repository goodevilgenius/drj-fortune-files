#!/bin/sh

DIR="${HOME}/.fortune/files"
FILE="quotes-$(date +%Y-%m)"

[ ! -d "$DIR" ] && mkdir -p "$DIR"

if [ -f "${DIR}/${FILE}" ]
    then
    echo "%" >> ${DIR}/${FILE}
fi

while read line
do
	echo "${line}"
done | fmt -w 2500 >> "${DIR}/${FILE}"

if [ -n "$1" ]
then
	echo -n "     -- " >> "${DIR}/${FILE}"
	echo "$@" >> "${DIR}/${FILE}"
fi

