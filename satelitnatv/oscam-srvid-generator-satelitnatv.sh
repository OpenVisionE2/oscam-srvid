#!/bin/bash

HEADER="
#################################################################################
###     shell-script written by s3n0, 2021-03-02, https://github.com/s3n0     ###
#################################################################################
###  shell-script to parse data from the web page https://www.satelitnatv.sk  ###
###         and then generate the 'oscam.srvid' file from parsed data         ###
#################################################################################
###  !!! the mentioned web-site www.satelitnatv.sk unfortunately provides !!! ###
###  !!!    only DVB-services from Slovakia and the Czech Republic        !!! ###
#################################################################################
"

#################################################################################

create_srvid_file() 
{
    # INPUT ARGUMENTS:
    #    $1 = the URL of the package list of channels with their data, on a specific website (http://www.satelitnatv.sk/PROVIDER-NAME)
    #    $2 = provider name (that exact name will be inserted into the '.srvid' output file)
    #    $3 = CAIDs (separated by comma) what is necessary for the provider
    
    if wget -q -O /tmp/satelitnatv.html --no-check-certificate "${1}" > /dev/null 2>&1; then
        echo "URL download successful:  ${1}"
    else
        echo "URL download FAILED:  ${1}"
        exit 1
    fi
    
    sed -i 's/<tr>/\n/g' /tmp/satelitnatv.html                                                                                      # change all "<tr>" TAGs to new-line characters
    LIST=$(sed -n 's/.*<strong><a href=\/.*\/?id=[0-9]\{4\}\([0-9]*\)>\(.*\)<\/a><\/strong>.*/\1 \2/p' /tmp/satelitnatv.html)       # one line example, from the $LIST variable:    14129 Markiza HD
    
    FILE_NAME=`echo "${1##*.sk}" | tr -d "/"`                           # FILE_NAME=`echo "${1}" | cut -d "/" -f 4`
    FILE_OUTPUT="/tmp/oscam__${FILE_NAME}.srvid"
    rm -f $FILE_OUTPUT
    
    while IFS= read -r LINE; do
        SRN=$(echo "$LINE" | cut -d " " -f 2-)
        SID=$(echo "$LINE" | cut -d " " -f -1 | awk '{print $1 + 0}')   # awk '{print $1 + 0}'   ----   removing the zeros at the beginning (on the left) of the string variable
        SIDHEX=$(printf "%04X" $SID)                                    # converting a decimal value to hexadecimal
        echo "${3}:${SIDHEX}|${2}|${SRN}" >> $FILE_OUTPUT
    done <<< "$LIST"
    
    if [ -f "$FILE_OUTPUT" ]; then
        echo -e "The new file was created: ${FILE_OUTPUT}\n"
        rm -f /tmp/satelitnatv.html
    else
        echo "ERROR ! File was not created: ${FILE_OUTPUT}"
        echo -e "Function arguments:\n${1} ${2} ${3}\n"
    fi
}

#################################################################################

echo "$HEADER"

#OSCAM_SRVID="/tmp/oscam_-_merged-kingofsat.srvid"
OSCAM_SRVID="oscam.srvid"

### create temporary ".srvid" files

create_srvid_file "https://www.satelitnatv.sk/frekvencie/skylink-sk-19e/" "Skylink" "0D96,0624,FFFE"
create_srvid_file "https://www.satelitnatv.sk/frekvencie/freesat-sk/" "FreeSAT" "0D97,0653,0B02"
create_srvid_file "https://www.satelitnatv.sk/frekvencie/antik-sat-sk/" "AntikSAT" "0B00"

#create_srvid_file "https://www.satelitnatv.sk/skylink-programy-frekvencie-parametre/" "Skylink" "0D96,0624"
#create_srvid_file "https://www.satelitnatv.sk/antik-sat/" "Antiksat" "0B00"
#create_srvid_file "https://www.satelitnatv.sk/freesat-by-upc-direct/" "FreeSAT" "0D97,0653,0B02"

### merge all generated ".srvid" files into one file + write this new file to the Oscam config-dir:
echo "$HEADER" > $OSCAM_SRVID
echo -e "### File creation date: $(date '+%Y-%m-%d')\n" >> $OSCAM_SRVID
cat /tmp/oscam__* >> $OSCAM_SRVID
rm -f /tmp/oscam__*
[ -f "$OSCAM_SRVID" ] && echo "All generated '.srvid' files have been merged into one and moved to the directory:  ${OSCAM_SRVID}"

