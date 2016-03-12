#!/bin/bash

###############################################################################
#                            Parameter Check                                  #
###############################################################################
EXPECTED_ARGS=1
if [ $# -ne $EXPECTED_ARGS ]; then
    echo ""
    echo "ERROR          : wrong number of arguments"
    echo "USAGE          : ./2_program_flash.sh <bitstream name>"
    echo "EXAMPLE        : ./2_program_flash.sh    leds"
    echo ""
    echo "AVAILABLE BITSTREAMS:"
    for fullfile in ./bitstreams/*.jic ; do
        filename=$(basename "$fullfile")
        filename="${filename%.*}"
        echo "                       - $filename"
    done
    echo ""
  exit 1
fi

###############################################################################
#                     Check if the required files exist                       #
###############################################################################
jicfile=./bitstreams/$1.jic;

if [ ! -e $jicfile ]; then
    echo ""
    echo "ERROR: Specified JIC file doesn't exist: $jicfile"
    echo ""
    exit 1
fi

###############################################################################
#                             Generate JIC file
###############################################################################
#echo " -----------------------------------------------"
#echo "|  GENERATE JIC FILE"
#echo " -----------------------------------------------"
#echo ""
#
## Copy and process COF file
#cp scripts/sof2jic.cof ./bitstreams/.
#sed -ie "s/BITSTREAM_NAME/$1/g"  ./bitstreams/sof2jic.cof
#
## Convert SOF file to JIC
#quartus_cpf -c ./bitstreams/sof2jic.cof
#
## Cleanup
#rm -rf ./bitstreams/sof2jic.cof*


###############################################################################
#                             Program FLASH                                   #
###############################################################################
echo " -----------------------------------------------"
echo "|  PROGRAM FLASH: $jicfile"
echo " -----------------------------------------------"
echo ""
echo "Note: if failing, try running 'jtagd'"
echo ""

# Copy and process CDF file
cp scripts/chain_with_flash.cdf  ./bitstreams/.
#sed -ie "s/BITSTREAM_NAME/$1/g"  ./bitstreams/chain_with_flash.cdf
sed -ie "s/BITSTREAM_NAME/$1/g"  ./bitstreams/chain_with_flash.cdf

# Program flash
quartus_pgm ./bitstreams/chain_with_flash.cdf

# Cleanup
rm -rf ./bitstreams/chain_with_flash.*
