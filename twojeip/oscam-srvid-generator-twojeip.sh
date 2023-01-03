#!/bin/bash

HEADER="
#################################################################################
### script is designed to download and replace the 'oscam.srvid' file
### as the '.srvid' generator is used the online web-page: HTTP://KOS.TWOJEIP.NET
### script written by s3n0, 2021-02-17: https://github.com/s3n0
#################################################################################
"

#################################################################################

echo "$HEADER"

URL="http://kos.twojeip.net/download.php?download[]=pack-abscbn&download[]=pack-akta&download[]=pack-austriasat&download[]=pack-bis&download[]=pack-boom&download[]=pack-bulsatcom&download[]=pack-canaldigitaal&download[]=pack-canaldigitalnordic&download[]=pack-canalsat&download[]=pack-multicanal&download[]=pack-cslink&download[]=pack-ncplus&download[]=pack-polsat&download[]=pack-dsmart&download[]=pack-digitalb&download[]=pack-digitalplusa&download[]=pack-digitalplush&download[]=pack-digiturk&download[]=pack-dmc&download[]=pack-dolcetv&download[]=pack-focussat&download[]=pack-fransat&download[]=pack-hdplus&download[]=pack-hellohd&download[]=pack-kabeld&download[]=pack-kabelkiosk&download[]=pack-cplus26e&download[]=pack-maxtv&download[]=pack-mediaset&download[]=pack-meo&download[]=pack-mobistar&download[]=pack-mtv&download[]=pack-mcafrica&download[]=pack-mytv&download[]=pack-orange&download[]=pack-orangepl&download[]=pack-orbit&download[]=pack-showtime&download[]=pack-orfdigital&download[]=pack-ote&download[]=pack-platformadv&download[]=pack-platformahd&download[]=pack-raduga&download[]=pack-rai&download[]=pack-digitv&download[]=pack-satellitebg&download[]=pack-skygermany&download[]=pack-skydigital&download[]=pack-skyitalia&download[]=pack-skylink&download[]=pack-ssr&download[]=pack-telesat&download[]=pack-tvnakarte&download[]=pack-tivusat&download[]=pack-totaltv&download[]=pack-tring&download[]=pack-tvvlaanderen&download[]=pack-tvp&download[]=pack-upc&download[]=pack-viasat&download[]=pack-visiontv&download[]=pack-vivacom&download[]=pack-nos"

echo -e "Downloading file...\n- from: ${URL}\n- to: oscam.srvid"
if wget --spider "${URL}" 2>/dev/null; then          # check the existence of an online file or web-page
    wget -q -O "oscam.srvid" "${URL}"
    echo "...done !"
else
    echo "...ERROR - online URL ${URL} does not exist !"
    exit 1
fi

