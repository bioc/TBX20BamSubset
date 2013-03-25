#!/bin/sh

#
# Downloads chr19 sequence for the mm9 version of M. musculus (mouse) from
# UCSC.

BASE_CHRS="chr19"

CHRS_TO_INDEX=$BASE_CHRS

## Download chromosome sequence
UCSC_MM9_BASE=ftp://hgdownload.cse.ucsc.edu/goldenPath/mm9/chromosomes

## Use either curl or wget
get() {
	file=$1
	if ! wget --version >/dev/null 2>/dev/null ; then
		if ! curl --version >/dev/null 2>/dev/null ; then
			echo "Please install wget or curl somewhere in your PATH"
			exit 1
		fi
		curl -o `basename $1` $1
		return $?
	else
		wget $1
		return $?
	fi
}

## Check for bowtie-build
BOWTIE_BUILD_EXE=./bowtie-build
if [ ! -x "$BOWTIE_BUILD_EXE" ] ; then
	if ! which bowtie-build ; then
		echo "Could not find bowtie-build in current directory or in PATH"
		exit 1
	else
		BOWTIE_BUILD_EXE=`which bowtie-build`
	fi
fi

## Build the bowtie index
INPUTS=
for c in $CHRS_TO_INDEX ; do
	if [ ! -f ${c}.fa ] ; then
		F=${c}.fa.gz
		get ${UCSC_MM9_BASE}/$F || (echo "Error getting $F" && exit 1)
		gunzip $F || (echo "Error unzipping $F" && exit 1)
	fi
	[ -n "$INPUTS" ] && INPUTS=$INPUTS,${c}.fa
	[ -z "$INPUTS" ] && INPUTS=${c}.fa
done

cat chr*fa > mm9.fa
rm chr*fa
bowtie-build mm9.fa mm9
