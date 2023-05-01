#!/bin/bash

HEADER="
#################################################################################
### - the script serves as a generator of the 'oscam.srvid' file
### - based on data parsing from website: http://en.KingOfSat.net/pack-XXXXXX.php
### - script written by s3n0, 2021-03-02: https://github.com/s3n0
### - script improved by Persian Prince, https://github.com/persianpros for OV
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
create_srvid_file "a1bg" "0B00"
create_srvid_file "add" "0604"
create_srvid_file "akta" "0500,0B00"
create_srvid_file "allente" "0000"
create_srvid_file "antiksat" "0B00"
create_srvid_file "arabesque" "0500"
create_srvid_file "arddigital" "FFFE"
create_srvid_file "austriasat" "0D05"
create_srvid_file "austriasatmagyar" "0D05"
create_srvid_file "bbc" "0000"
create_srvid_file "bein" "0500"
create_srvid_file "bigbangtv" "4347"
create_srvid_file "bis" "0500,0100"
create_srvid_file "boobles" "0000"
create_srvid_file "bulsatcom" "0604,5501,5581"
create_srvid_file "canaldigitaal" "0100,0622"
create_srvid_file "canal" "0000"
create_srvid_file "cosmote" "0000"
create_srvid_file "dsmart" "092B"
create_srvid_file "digitv" "1802,1880"
create_srvid_file "digitalb" "0B00"
create_srvid_file "digiturk" "0D00,0664"
# Movistar+ - Start #
create_srvid_file "digitalplusa" "0100,1810"
create_srvid_file "digitalplush" "1810"
# Movistar+ - End #
create_srvid_file "directone" "0000"
create_srvid_file "direct2home" "0000"
create_srvid_file "dolcetv" "092F"
create_srvid_file "focussat" "0B02"
create_srvid_file "fotelka" "0604"
create_srvid_file "fransat" "0500"
create_srvid_file "freesat" "0000"

create_srvid_file "hdplus" "1830"
create_srvid_file "hellohd" "0BAA"
create_srvid_file "kabeld" "1834,1722,09C7"
create_srvid_file "kabelkiosk" "0B00,09AF"
create_srvid_file "maxtv" "0500"
create_srvid_file "mcafrica" "1800"
create_srvid_file "mediaset" "1803"
create_srvid_file "meo" "0100"
create_srvid_file "mobistar" "0500"
create_srvid_file "mtv" "0B00,0D00"
create_srvid_file "multicanal" "1802"
create_srvid_file "mytv" "1800"
create_srvid_file "ncplus" "0100,0B01"
create_srvid_file "nos" "1802"
create_srvid_file "orange" "0500"
create_srvid_file "orangepl" "0500"
create_srvid_file "orbit" "0100,0668"
create_srvid_file "orfdigital" "0D05,0D95"
create_srvid_file "ote" "099E"
create_srvid_file "platformadv" "4AE1"
create_srvid_file "platformahd" "4AE1"
create_srvid_file "polsat" "1803,1861"
create_srvid_file "raduga" "0652"
create_srvid_file "rai" "0100"
create_srvid_file "satellitebg" "0D06,0D96,0B01,0624"
create_srvid_file "showtime" "0100,0668"
create_srvid_file "skydigital" "0963"
create_srvid_file "skygermany" "1833,1834,1702,1722,09C4,09AF"
create_srvid_file "skyitalia" "0919,093B,09CD"
create_srvid_file "skylink" "0D03,0D70,0D96,0624"
create_srvid_file "ssr" "0500"
create_srvid_file "telesat" "0100"
create_srvid_file "tivusat" "183D"
create_srvid_file "totaltv" "091F"
create_srvid_file "tring" "0BAA"
create_srvid_file "tvnakarte" "0B00"
create_srvid_file "tvp" "09B2"
create_srvid_file "tvvlaandoscam  find CaIDeren" "0100,0500"
create_srvid_file "upc" "0D02,1815,0D97,0653"
create_srvid_file "viasat" "090F,093E"
create_srvid_file "visiontv" "0931"
create_srvid_file "vivacom" "09BD"

### merge all generated ".srvid" files into one file + move this new file to the Oscam config-dir:
echo "$HEADER" > $OSCAM_SRVID
echo -e "### File creation date: $(date '+%Y-%m-%d')\n" >> $OSCAM_SRVID
cat /tmp/oscam__* >> $OSCAM_SRVID
rm -f /tmp/oscam__*
[ -f "$OSCAM_SRVID" ] && echo "All generated '.srvid' files have been merged into one and moved to the directory:  ${OSCAM_SRVID}"

