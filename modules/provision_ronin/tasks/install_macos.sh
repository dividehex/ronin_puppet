#!/usr/bin/env bash

if [[ $EUID != 0 ]] ; then
    echo "installr: Please run this as root, or via sudo."
    exit 1
fi

if [[ -z "${PT_volume}" ]]; then
    echo "Missing volume name"
    exit 1
fi

if [[ -z "${PT_erase}" ]]; then
    echo "Missing erase flag"
    exit 1
fi

SELECTEDVOLUME="${PT_volume}"

THISDIR="/Volumes/install/"
PACKAGESDIR="${THISDIR}packages"
INSTALLMACOSAPP=$(echo "${THISDIR}Install macOS"*.app)
STARTOSINSTALL=$(echo "${THISDIR}Install macOS"*.app/Contents/Resources/startosinstall)

if [ ! -e "$STARTOSINSTALL" ]; then
    echo "Can't find an Install macOS app containing startosinstall in this script's directory!"
    exit 1
fi

echo "****** Welcome to installr! ******"
echo "macOS will be installed from:"
echo "    ${INSTALLMACOSAPP}"
echo "these additional packages will also be installed:"
for PKG in $(/bin/ls -1 "${PACKAGESDIR}"/*.pkg); do
    echo "    ${PKG}"
done
echo

if [[ "${PT_erase}" == true ]]; then
    /usr/sbin/diskutil reformat "/Volumes/${SELECTEDVOLUME}"
fi

echo
echo "Installing macOS to /Volumes/${SELECTEDVOLUME}..."

CMD="\"${STARTOSINSTALL}\" --agreetolicense --volume \"/Volumes/${SELECTEDVOLUME}\""

for ITEM in "${PACKAGESDIR}"/* ; do
    FILENAME="${ITEM##*/}"
    EXTENSION="${FILENAME##*.}"
    if [[ -e ${ITEM} ]]; then
        case ${EXTENSION} in
            pkg ) CMD="${CMD} --installpackage \"${ITEM}\"" ;;
            * ) echo "    ignoring non-package ${ITEM}..." ;;
        esac
    fi
done

# kick off the OS install
echo "${CMD}"
eval "${CMD}" &

exec
