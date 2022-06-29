#!/bin/bash

SCHEDULER_MESSAGES="$(dirname $0)/SCHEDULER_MESSAGES"

IN_MSG=`cat`

# Scheduler Messages
if [[ "${IN_MSG}" =~ 00000000\-0000\-0000\-0000\-[0-9]{12} ]]; then
    message=${BASH_REMATCH[0]}
    echo "Scheduler Message detected: ${message}"
    if [[ -f $SCHEDULER_MESSAGES ]]; then
        while read l
        do
            if [[ $l =~ $message ]]; then
                echo $l
            fi
        done < $SCHEDULER_MESSAGES
    else
        echo "Scheduler Messages are not available. Copy them into ${SCHEDULER_MESSAGES}."
    fi
# Certificate Blob
elif [[ "${IN_MSG}" =~ \<SiteSigningCert\>(.+)\<\/SiteSigningCert\> ]]; then
    cert_encoded=${BASH_REMATCH[1]}
    echo "Certificate Blob detected"
    echo $cert_encoded | xxd -r -p | openssl x509 -text -noout
else
    # nothing to do
    echo "Nothing detected."
fi
