#!/bin/bash

HEADER="
######################################################################################
### - the script serves as a generator of the 'oscam.srvid' file
### - based on data parsing from website: https://www.lyngsat.com/packages/XXXXXX.html
### - script written by s3n0, 2021-03-13: https://github.com/s3n0
######################################################################################
"

######################################################################################

create_srvid_file()
{
    # INPUT ARGUMENTS:
    #    $1 = the package name, on a specific https://www.lyngsat.com/packages/XXXXXX.html website (see below)
    #    $2 = CAIDs (separated by comma) what is necessary for the provider
    #    $3 = DVB provider name
    #
    # EXAMPLE:     create_srvid_file "Sky-Deutschland" "1833,1834,1702,1722,09C4,09AF" "SKY DE"
    #
    # NOTE:        "${1^}" provides the string with only first upper character = "Provider"     "${1^^}" provides the upper-case string = "PROVIDER"     "${1}" provides the string = "provider"     "${1,,}" provides the lower-case string = "provider"
    
    URL="https://www.lyngsat.com/packages/${1}.html"
    
    if wget -q -O /tmp/los.html --no-check-certificate "${URL}" > /dev/null 2>&1; then
        echo "URL download successful:  ${URL}"
    else
        echo "URL download FAILED:  ${URL}"
        exit 1
    fi
    
    CHN_MATCH='<font face="Arial"><font size='
    SID_MATCH='<td align="center" bgcolor="#[0-9a-f]+"><font face="Verdana" size=[0-9]+>[0-9 ]+</td>'
    
    LIST=$(cat /tmp/los.html | grep -E -e "${CHN_MATCH}" -e "${SID_MATCH}")
    rm -f /tmp/los.html
    
    LIST_LEN=$(printf "%s" "$LIST" | grep -c "^")
    if (( $LIST_LEN % 2 )); then            # testing whether the number of lines in the $LIST variable is even (must be even)
        echo -e "ERROR !\nThe SID + CAID list from the web page is not complete (number of lines is odd, but an even number is required).\nThe script will be aborted !"
        exit 1
    fi
    
    # Example of the $LIST variable content:
    #
    # <td align="center" bgcolor="#ffcc99"><font face="Verdana" size=1> 2417</td>
    # <td bgcolor="#ffcc99"><font face="Arial"><font size=2><b><a href="https://www.lyngsat.com/tvchannels/pt/Porto-Canal.html">Porto Canal</a></b></td>
    # <td align="center" bgcolor="#ffcc99"><font face="Verdana" size=1> 2418</td>
    # <td bgcolor="#ffcc99"><font face="Arial"><font size=2><b><a href="https://www.lyngsat.com/tvchannels/us/ESPN-2-Africa.html">ESPN 2 Africa</a></b></td>
    # <td align="center" bgcolor="#ffcc99"><font face="Verdana" size=1> 2420</td>
    # <td bgcolor="#ffcc99"><font face="Arial"><font size=2><b><a href="https://www.lyngsat.com/tvchannels/ao/Blast.html">Blast</a></b></td>
    # ....
    
    RESULT=""
    
    while IFS= read -r LINE; do
        SIDHEX=""
        CHN=""
        # ServiceID at the odd $LINE:
        SID=$(echo $LINE | cut -d '>' -f 3 | cut -d '<' -f 1)
        SIDHEX=$(printf "%04X" $SID)        # converting a decimal value to hexadecimal
        # CHANNEL-name at the even $LINE:
        IFS= read -r LINE
        CHN=$(echo $LINE | grep -oE 'html">.*' | cut -d '>' -f 2 | cut -d '<' -f 1)
        # write a new entry - if both variables are not empty:
        [ -n "$SIDHEX" -a -n "$CHN" ] && RESULT="${RESULT}${2}:${SIDHEX}|${3}|${CHN}\n"         # [ -n "$SIDHEX" -a -n "$CHN" ] && RESULT="${RESULT}CAID1,CAID2:${SIDHEX}|PROVIDER|${CHN}\n"
    done <<< "$LIST"   # the '.srvid' file format is, for example :   "CAID1,CAID2,CAID3:SID|PROVIDER-NAME|CHANNEL-NAME"
    
    # write $RESULT to a temporary file (also taking into account newline codes)
    echo -e "$RESULT" > "/tmp/oscam__${1}.srvid"
}

######################################################################################

echo "$HEADER"

#OSCAM_SRVID="/tmp/oscam_-_merged-kingofsat.srvid"
OSCAM_SRVID="oscam.srvid"

### create temporary ".srvid" files:
create_srvid_file "Skylink" "0D96,0624" "Skylink"
create_srvid_file "Antik-Sat" "0B00" "AntikSAT"
create_srvid_file "Orange-Slovensko" "0B00,0609" "Orange SK"                 # some channels are shared to the AntikSat provider (package), so this one "orangesk" package is also needed for "antiksat" (as the CAID=0B00)
create_srvid_file "Sky-Deutschland" "1833,1834,1702,1722,09C4,09AF" "SKY DE"

### merge all generated ".srvid" files into one file + write this new file to the Oscam config-dir:
echo "$HEADER" > $OSCAM_SRVID
echo -e "### File creation date: $(date '+%Y-%m-%d')\n" >> $OSCAM_SRVID
cat /tmp/oscam__* >> $OSCAM_SRVID
rm -f /tmp/oscam__*
[ -f "$OSCAM_SRVID" ] && echo "Path to the generated 'oscam.srvid' file:  ${OSCAM_SRVID}"

