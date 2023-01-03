#!/bin/bash

HEADER="
#################################################################################
### - the script serves as a generator of the 'oscam.srvid' file
### - based on data parsing from website: http://en.KingOfSat.net/pack-XXXXXX.php
### - script written by s3n0, 2021-03-02: https://github.com/s3n0
#################################################################################
"

#################################################################################

create_srvid_file()
{
    # INPUT ARGUMENTS:
    #    $1 = the URL of the package list of channels with their data, on a specific http://en.KingOfSat.net/pack-XXXXX.php website (see below)
    #    $2 = CAIDs (separated by comma) what is necessary for the provider
    #
    # EXAMPLE:      create_srvid_file "skylink" "0D96,0624"
    #
    # NOTE:         "${1^}" provides the first-character-upper string = "Provider"     "${1^^}" provides the upper-case string = "PROVIDER"     "${1}" provides the string = "provider"     "${1,,}" provides the lower-case string = "provider"
    
    URL="http://en.kingofsat.net/pack-${1,,}.php"
    
    if wget -q -O /tmp/kos.html --no-check-certificate "$URL" > /dev/null 2>&1; then
        echo "URL download successful:   ${URL}"
        
        awk -F '>' -v CAIDS="${2}" -v PROVIDER="${1^^}" -e '
            BEGIN { CHNAME = "invalid" }
            /<i>|class="A3"/ { CHNAME = substr($2,1,length($2) - 3) }
            /class="s">[0-9]+/ {
                SID = substr($2,1,length($2) - 4)
                if (CHNAME == "invalid") next
                printf "%s:%04X|%s|%s\n", CAIDS, SID, PROVIDER, CHNAME
                CHNAME = "invalid"
              }' /tmp/kos.html > "/tmp/oscam__${1,,}.srvid"
        
        echo -e "The new file was created:  /tmp/oscam__${1,,}.srvid\n"
        rm -f /tmp/kos.html
    else
        echo "URL download failed !!! URL:  ${URL}"
    fi
}

#################################################################################

echo "$HEADER"

#OSCAM_SRVID="/tmp/oscam_-_merged-kingofsat.srvid"
OSCAM_SRVID="oscam.srvid"

### create temporary ".srvid" files:
create_srvid_file "skylink" "0D96,0624,FFFE"
create_srvid_file "antiksat" "0B00"
create_srvid_file "orangesk" "0B00,0609"            # some channels are shared to the AntikSat provider (package), so this one "orangesk" package is also needed for "antiksat" (as the CAID=0B00)
create_srvid_file "upc" "0D02,0D97,0B02,1815"
create_srvid_file "skygermany" "1833,1834,1702,1722,09C4,09AF"

#create_srvid_file "focussat" "0B02"
#create_srvid_file "digitv" "1802,1880"
#create_srvid_file "mtv" "0B00,0D00"
#create_srvid_file "canaldigitalnordic" "0B00"
#create_srvid_file "bbc" "0B00"
#create_srvid_file "skydigital" "0963"
#create_srvid_file "skyitalia" "0919,093B,09CD"
#create_srvid_file "dolcetv" "092F"
#create_srvid_file "hellohd" "0BAA,0000"

### merge all generated ".srvid" files into one file + move this new file to the Oscam config-dir:
echo "$HEADER" > $OSCAM_SRVID
echo -e "### File creation date: $(date '+%Y-%m-%d')\n" >> $OSCAM_SRVID
cat /tmp/oscam__* >> $OSCAM_SRVID
rm -f /tmp/oscam__*
[ -f "$OSCAM_SRVID" ] && echo "All generated '.srvid' files have been merged into one and moved to the directory:  ${OSCAM_SRVID}"

