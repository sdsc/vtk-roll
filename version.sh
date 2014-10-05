#!/bin/sh

DESC=`git describe --match 'v*' 2>/dev/null | sed "s/v\([0-9\.]*\)-*\([0-9]*\)-*\([0-9a-z]*\)/\1 \2 \3/"`

if [ -z "${DESC}" ]
then
    # Try to support using the tagged downloads
    DESC=`pwd | grep -oe 'perftest-.\+' | sed 's/perftest-//g'`
    LOCAL_REV="-github_archive"
fi

VERSION=`echo ${DESC} | awk '{ print $1 }' | tr "." " "`
COMMIT=`echo ${DESC} | awk '{ print $2 }'`
HASH=`echo ${DESC} | awk '{ print $3}'`
VERSION_MAJ=`echo ${VERSION} | awk '{ print $1 }'`
VERSION_MIN=`echo ${VERSION} | awk '{ print $2 }'`
VERSION_REV=${COMMIT}
VERSION_HASH=${HASH}
if [ -z "${VERSION_REV}" ]; then
    VERSION_REV="0"
fi

#Allow local revision identifiers
#mimicing backports this is "-<identifier>"
if [ -e localversion ]; then
    LOCAL_REV=$(cat localversion)
    if [ -n "${LOCAL_REV}" ];
    then
        LOCAL_REV="-${LOCAL_REV}"
    fi
fi

while getopts "vmnrh" opt; do
    case $opt in
	v)
	   # Major.Minor Version
	   echo "${VERSION_MAJ}.${VERSION_MIN}"
	   exit 0
	   ;;
        m)
            # Major Version
            echo "${VERSION_MAJ}"
            exit 0
            ;;
        n)
            # Minor Version
            echo "${VERSION_MIN}"
            exit 0
            ;;
        r)
            # Revision Version
            echo "${VERSION_REV}"
            exit 0
            ;;
	h)
	    # Revision Hash
	    echo "${VERSION_REV}.${VERSION_HASH}"
	    exit 0
	    ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

VERSION="${VERSION_MAJ}.${VERSION_MIN}.${VERSION_REV}${LOCAL_REV}"

echo $VERSION
