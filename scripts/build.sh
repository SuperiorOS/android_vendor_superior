#!/usr/bin/env bash
# SuperiorOS build helper script

# red = errors, cyan = warnings, green = confirmations, blue = informational
# plain for generic text, bold for titles, reset flag at each end of line
# plain blue should not be used for readability reasons - use plain cyan instead
CLR_RST=$(tput sgr0)                        ## reset flag
CLR_RED=$CLR_RST$(tput setaf 1)             #  red, plain
CLR_GRN=$CLR_RST$(tput setaf 2)             #  green, plain
CLR_BLU=$CLR_RST$(tput setaf 4)             #  blue, plain
CLR_CYA=$CLR_RST$(tput setaf 6)             #  cyan, plain
CLR_BLD=$(tput bold)                        ## bold flag
CLR_BLD_RED=$CLR_RST$CLR_BLD$(tput setaf 1) #  red, bold
CLR_BLD_GRN=$CLR_RST$CLR_BLD$(tput setaf 2) #  green, bold
CLR_BLD_BLU=$CLR_RST$CLR_BLD$(tput setaf 4) #  blue, bold
CLR_BLD_CYA=$CLR_RST$CLR_BLD$(tput setaf 6) #  cyan, bold

# Set defaults
BUILD_TYPE="user"

function checkExit () {
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "${CLR_BLD_RED}Build failed!${CLR_RST}"
        echo -e ""
        exit $EXIT_CODE
    fi
}

# Output usage help
function showHelpAndExit {
        echo -e "${CLR_BLD_BLU}Usage: $0 <device> [options]${CLR_RST}"
        echo -e ""
        echo -e "${CLR_BLD_BLU}Options:${CLR_RST}"
        echo -e "${CLR_BLD_BLU}  -h, --help            Display this help message${CLR_RST}"
        echo -e "${CLR_BLD_BLU}  -c, --clean           Wipe the tree before building${CLR_RST}"
        echo -e "${CLR_BLD_BLU}  -i, --installclean    Dirty build - Use 'installclean'${CLR_RST}"
        echo -e "${CLR_BLD_BLU}  -r, --repo-sync       Sync before building${CLR_RST}"
        echo -e "${CLR_BLD_BLU}  -t, --build-type      Specify build type${CLR_RST}"
        echo -e "${CLR_BLD_BLU}  -j, --jobs            Specify jobs/threads to use${CLR_RST}"
        echo -e "${CLR_BLD_BLU}  -m, --module          Build a specific module${CLR_RST}"
        echo -e "${CLR_BLD_BLU}  -s, --sign-keys       Specify path to sign key mappings${CLR_RST}"
        echo -e "${CLR_BLD_BLU}  -p, --pwfile          Specify path to sign key password file${CLR_RST}"
        echo -e "${CLR_BLD_BLU}  -d, --delta           Generate a delta ota from the specified target_files zip${CLR_RST}"
        echo -e "${CLR_BLD_BLU}  -z, --imgzip          Generate fastboot flashable image zip from signed target_files${CLR_RST}"
        echo -e "${CLR_BLD_BLU}  -n, --version         Specify build minor version (number)${CLR_RST}"
        exit 1
}

# Setup getopt.
long_opts="help,clean,installclean,repo-sync,build-type:,jobs:,module:,sign-keys:,pwfile:,delta:,imgzip"
getopt_cmd=$(getopt -o hcirt:j:m:s:p:d:z --long "$long_opts" \
            -n $(basename $0) -- "$@") || \
            { echo -e "${CLR_BLD_RED}\nError: Getopt failed. Extra args\n${CLR_RST}"; showHelpAndExit; exit 1;}

eval set -- "$getopt_cmd"

while true; do
    case "$1" in
        -h|--help|h|help) showHelpAndExit;;
        -c|--clean|c|clean) FLAG_CLEAN_BUILD=y;;
        -i|--installclean|i|installclean) FLAG_INSTALLCLEAN_BUILD=y;;
        -r|--repo-sync|r|repo-sync) FLAG_SYNC=y;;
        -t|--build-type|t|build-type) BUILD_TYPE="$2"; shift;;
        -j|--jobs|j|jobs) JOBS="$2"; shift;;
        -m|--module|m|module) MODULES+=("$2"); echo $2; shift;;
        -s|--sign-keys|s|sign-keys) KEY_MAPPINGS="$2"; shift;;
        -p|--pwfile|p|pwfile) PWFILE="$2"; shift;;
        -d|--delta|d|delta) DELTA_TARGET_FILES="$2"; shift;;
        -z|--imgzip|img|imgzip) FLAG_IMG_ZIP=y;;
        --) shift; break;;
    esac
    shift
done

# Mandatory argument
if [ $# -eq 0 ]; then
    echo -e "${CLR_BLD_RED}Error: No device specified${CLR_RST}"
    showHelpAndExit
fi
export DEVICE="$1"; shift

# Make sure we are running on 64-bit before carrying on with anything
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
if [ "$ARCH" != "64" ]; then
        echo -e "${CLR_BLD_RED}error: unsupported arch (expected: 64, found: $ARCH)${CLR_RST}"
        exit 1
fi

# Set up paths
cd $(dirname $0)
DIR_ROOT=$(pwd)

# Make sure everything looks sane so far
if [ ! -d "$DIR_ROOT/vendor/superior" ]; then
        echo -e "${CLR_BLD_RED}error: insane root directory ($DIR_ROOT)${CLR_RST}"
        exit 1
fi

# Initializationizing!
echo -e "${CLR_BLD_BLU}Setting up the environment${CLR_RST}"
echo -e ""
. build/envsetup.sh
echo -e ""

# Use the thread count specified by user
CMD=""
if [ $JOBS ]; then
  CMD+="-j$JOBS"
fi

# Pick the default thread count (allow overrides from the environment)
if [ -z "$JOBS" ]; then
        if [ "$(uname -s)" = 'Darwin' ]; then
                JOBS=$(sysctl -n machdep.cpu.core_count)
        else
                JOBS=$(cat /proc/cpuinfo | grep '^processor' | wc -l)
        fi

        CMD+="-j$JOBS"
fi

# Sync up, if asked to
if [ "$FLAG_SYNC" = 'y' ]; then
        echo -e "${CLR_BLD_BLU}Downloading the latest source files${CLR_RST}"
        echo -e ""
        repo sync -j"$JOBS" -c --current-branch --no-tags
fi

# Check the starting time (of the real build process)
TIME_START=$(date +%s.%N)

# Friendly logging to tell the user everything is working fine is always nice
echo -e "${CLR_BLD_GRN}Building SuperiorOS for $DEVICE${CLR_RST}"
echo -e "${CLR_GRN}Start time: $(date)${CLR_RST}"
echo -e ""

# Lunch-time!
echo -e "${CLR_BLD_BLU}Lunching $DEVICE${CLR_RST}"
echo -e ""
lunch "superior_$DEVICE-ap1a-$BUILD_TYPE"
SUPERIOR_VERSION="$(get_build_var SUPERIOR_VERSION)"
checkExit
echo -e ""

# Prep for a clean build, if requested so
if [ "$FLAG_CLEAN_BUILD" = 'y' ]; then
        echo -e "${CLR_BLD_BLU}Cleaning output files left from old builds${CLR_RST}"
        echo -e ""
        m clobber "$CMD"
fi

# Perform installclean, if requested so
if [ "$FLAG_INSTALLCLEAN_BUILD" = 'y' ]; then
	echo -e "${CLR_BLD_BLU}Cleaning compiled image files left from old builds${CLR_RST}"
	echo -e ""
	m installclean "$CMD"
fi

# Build away!
echo -e "${CLR_BLD_BLU}Starting compilation${CLR_RST}"
echo -e ""

# Build a specific module(s)
if [ "${MODULES}" ]; then
    m ${MODULES[@]} "$CMD"
    checkExit

# Build signed rom package if specified
elif [ "${KEY_MAPPINGS}" ]; then
    # Set sign key password file if specified
    if [ "${PWFILE}" ]; then
        export ANDROID_PW_FILE=$PWFILE
    fi

    # Make target-files-package
    m otatools target-files-package "$CMD"

    checkExit

    echo -e "${CLR_BLD_BLU}Signing target files apks${CLR_RST}"
    sign_target_files_apks -o -d $KEY_MAPPINGS \
        --extra_apks AdServicesApk.apk=$KEY_MAPPINGS/releasekey \
        --extra_apks HalfSheetUX.apk=$KEY_MAPPINGS/releasekey \
        --extra_apks OsuLogin.apk=$KEY_MAPPINGS/releasekey \
        --extra_apks SafetyCenterResources.apk=$KEY_MAPPINGS/releasekey \
        --extra_apks ServiceConnectivityResources.apk=$KEY_MAPPINGS/releasekey \
        --extra_apks ServiceUwbResources.apk=$KEY_MAPPINGS/releasekey \
        --extra_apks ServiceWifiResources.apk=$KEY_MAPPINGS/releasekey \
        --extra_apks WifiDialog.apk=$KEY_MAPPINGS/releasekey \
        --extra_apks com.android.adbd.apex=$KEY_MAPPINGS/com.android.adbd \
        --extra_apks com.android.adservices.apex=$KEY_MAPPINGS/com.android.adservices \
        --extra_apks com.android.adservices.api.apex=$KEY_MAPPINGS/com.android.adservices.api \
        --extra_apks com.android.appsearch.apex=$KEY_MAPPINGS/com.android.appsearch \
        --extra_apks com.android.art.apex=$KEY_MAPPINGS/com.android.art \
        --extra_apks com.android.bluetooth.apex=$KEY_MAPPINGS/com.android.bluetooth \
        --extra_apks com.android.btservices.apex=$KEY_MAPPINGS/com.android.btservices \
        --extra_apks com.android.cellbroadcast.apex=$KEY_MAPPINGS/com.android.cellbroadcast \
        --extra_apks com.android.compos.apex=$KEY_MAPPINGS/com.android.compos \
        --extra_apks com.android.configinfrastructure.apex=$KEY_MAPPINGS/com.android.configinfrastructure \
        --extra_apks com.android.connectivity.resources.apex=$KEY_MAPPINGS/com.android.connectivity.resources \
        --extra_apks com.android.conscrypt.apex=$KEY_MAPPINGS/com.android.conscrypt \
        --extra_apks com.android.devicelock.apex=$KEY_MAPPINGS/com.android.devicelock \
        --extra_apks com.android.extservices.apex=$KEY_MAPPINGS/com.android.extservices \
        --extra_apks com.android.graphics.pdf.apex=$KEY_MAPPINGS/com.android.graphics.pdf \
        --extra_apks com.android.hardware.biometrics.face.virtual.apex=$KEY_MAPPINGS/com.android.hardware.biometrics.face.virtual \
        --extra_apks com.android.hardware.biometrics.fingerprint.virtual.apex=$KEY_MAPPINGS/com.android.hardware.biometrics.fingerprint.virtual \
        --extra_apks com.android.hardware.boot.apex=$KEY_MAPPINGS/com.android.hardware.boot \
        --extra_apks com.android.hardware.cas.apex=$KEY_MAPPINGS/com.android.hardware.cas \
        --extra_apks com.android.hardware.wifi.apex=$KEY_MAPPINGS/com.android.hardware.wifi \
        --extra_apks com.android.healthfitness.apex=$KEY_MAPPINGS/com.android.healthfitness \
        --extra_apks com.android.hotspot2.osulogin.apex=$KEY_MAPPINGS/com.android.hotspot2.osulogin \
        --extra_apks com.android.i18n.apex=$KEY_MAPPINGS/com.android.i18n \
        --extra_apks com.android.ipsec.apex=$KEY_MAPPINGS/com.android.ipsec \
        --extra_apks com.android.media.apex=$KEY_MAPPINGS/com.android.media \
        --extra_apks com.android.media.swcodec.apex=$KEY_MAPPINGS/com.android.media.swcodec \
        --extra_apks com.android.mediaprovider.apex=$KEY_MAPPINGS/com.android.mediaprovider \
        --extra_apks com.android.nearby.halfsheet.apex=$KEY_MAPPINGS/com.android.nearby.halfsheet \
        --extra_apks com.android.networkstack.tethering.apex=$KEY_MAPPINGS/com.android.networkstack.tethering \
        --extra_apks com.android.neuralnetworks.apex=$KEY_MAPPINGS/com.android.neuralnetworks \
        --extra_apks com.android.ondevicepersonalization.apex=$KEY_MAPPINGS/com.android.ondevicepersonalization \
        --extra_apks com.android.os.statsd.apex=$KEY_MAPPINGS/com.android.os.statsd \
        --extra_apks com.android.permission.apex=$KEY_MAPPINGS/com.android.permission \
        --extra_apks com.android.resolv.apex=$KEY_MAPPINGS/com.android.resolv \
        --extra_apks com.android.rkpd.apex=$KEY_MAPPINGS/com.android.rkpd \
        --extra_apks com.android.runtime.apex=$KEY_MAPPINGS/com.android.runtime \
        --extra_apks com.android.safetycenter.resources.apex=$KEY_MAPPINGS/com.android.safetycenter.resources \
        --extra_apks com.android.scheduling.apex=$KEY_MAPPINGS/com.android.scheduling \
        --extra_apks com.android.sdkext.apex=$KEY_MAPPINGS/com.android.sdkext \
        --extra_apks com.android.support.apexer.apex=$KEY_MAPPINGS/com.android.support.apexer \
        --extra_apks com.android.telephony.apex=$KEY_MAPPINGS/com.android.telephony \
        --extra_apks com.android.telephonymodules.apex=$KEY_MAPPINGS/com.android.telephonymodules \
        --extra_apks com.android.tethering.apex=$KEY_MAPPINGS/com.android.tethering \
        --extra_apks com.android.tzdata.apex=$KEY_MAPPINGS/com.android.tzdata \
        --extra_apks com.android.uwb.apex=$KEY_MAPPINGS/com.android.uwb \
        --extra_apks com.android.uwb.resources.apex=$KEY_MAPPINGS/com.android.uwb.resources \
        --extra_apks com.android.virt.apex=$KEY_MAPPINGS/com.android.virt \
        --extra_apks com.android.vndk.current.apex=$KEY_MAPPINGS/com.android.vndk.current \
        --extra_apks com.android.vndk.current.on_vendor.apex=$KEY_MAPPINGS/com.android.vndk.current.on_vendor \
        --extra_apks com.android.wifi.apex=$KEY_MAPPINGS/com.android.wifi \
        --extra_apks com.android.wifi.dialog.apex=$KEY_MAPPINGS/com.android.wifi.dialog \
        --extra_apks com.android.wifi.resources.apex=$KEY_MAPPINGS/com.android.wifi.resources \
        --extra_apks com.google.pixel.camera.hal.apex=$KEY_MAPPINGS/com.google.pixel.camera.hal \
        --extra_apks com.google.pixel.vibrator.hal.apex=$KEY_MAPPINGS/com.google.pixel.vibrator.hal \
        --extra_apks com.qorvo.uwb.apex=$KEY_MAPPINGS/com.qorvo.uwb \
        --extra_apex_payload_key com.android.adbd.apex=$KEY_MAPPINGS/com.android.adbd.pem \
        --extra_apex_payload_key com.android.adservices.apex=$KEY_MAPPINGS/com.android.adservices.pem \
        --extra_apex_payload_key com.android.adservices.api.apex=$KEY_MAPPINGS/com.android.adservices.api.pem \
        --extra_apex_payload_key com.android.appsearch.apex=$KEY_MAPPINGS/com.android.appsearch.pem \
        --extra_apex_payload_key com.android.art.apex=$KEY_MAPPINGS/com.android.art.pem \
        --extra_apex_payload_key com.android.bluetooth.apex=$KEY_MAPPINGS/com.android.bluetooth.pem \
        --extra_apex_payload_key com.android.btservices.apex=$KEY_MAPPINGS/com.android.btservices.pem \
        --extra_apex_payload_key com.android.cellbroadcast.apex=$KEY_MAPPINGS/com.android.cellbroadcast.pem \
        --extra_apex_payload_key com.android.compos.apex=$KEY_MAPPINGS/com.android.compos.pem \
        --extra_apex_payload_key com.android.configinfrastructure.apex=$KEY_MAPPINGS/com.android.configinfrastructure.pem \
        --extra_apex_payload_key com.android.connectivity.resources.apex=$KEY_MAPPINGS/com.android.connectivity.resources.pem \
        --extra_apex_payload_key com.android.conscrypt.apex=$KEY_MAPPINGS/com.android.conscrypt.pem \
        --extra_apex_payload_key com.android.devicelock.apex=$KEY_MAPPINGS/com.android.devicelock.pem \
        --extra_apex_payload_key com.android.extservices.apex=$KEY_MAPPINGS/com.android.extservices.pem \
        --extra_apex_payload_key com.android.graphics.pdf.apex=$KEY_MAPPINGS/com.android.graphics.pdf.pem \
        --extra_apex_payload_key com.android.hardware.biometrics.face.virtual.apex=$KEY_MAPPINGS/com.android.hardware.biometrics.face.virtual.pem \
        --extra_apex_payload_key com.android.hardware.biometrics.fingerprint.virtual.apex=$KEY_MAPPINGS/com.android.hardware.biometrics.fingerprint.virtual.pem \
        --extra_apex_payload_key com.android.hardware.boot.apex=$KEY_MAPPINGS/com.android.hardware.boot.pem \
        --extra_apex_payload_key com.android.hardware.cas.apex=$KEY_MAPPINGS/com.android.hardware.cas.pem \
        --extra_apex_payload_key com.android.hardware.wifi.apex=$KEY_MAPPINGS/com.android.hardware.wifi.pem \
        --extra_apex_payload_key com.android.healthfitness.apex=$KEY_MAPPINGS/com.android.healthfitness.pem \
        --extra_apex_payload_key com.android.hotspot2.osulogin.apex=$KEY_MAPPINGS/com.android.hotspot2.osulogin.pem \
        --extra_apex_payload_key com.android.i18n.apex=$KEY_MAPPINGS/com.android.i18n.pem \
        --extra_apex_payload_key com.android.ipsec.apex=$KEY_MAPPINGS/com.android.ipsec.pem \
        --extra_apex_payload_key com.android.media.apex=$KEY_MAPPINGS/com.android.media.pem \
        --extra_apex_payload_key com.android.media.swcodec.apex=$KEY_MAPPINGS/com.android.media.swcodec.pem \
        --extra_apex_payload_key com.android.mediaprovider.apex=$KEY_MAPPINGS/com.android.mediaprovider.pem \
        --extra_apex_payload_key com.android.nearby.halfsheet.apex=$KEY_MAPPINGS/com.android.nearby.halfsheet.pem \
        --extra_apex_payload_key com.android.networkstack.tethering.apex=$KEY_MAPPINGS/com.android.networkstack.tethering.pem \
        --extra_apex_payload_key com.android.neuralnetworks.apex=$KEY_MAPPINGS/com.android.neuralnetworks.pem \
        --extra_apex_payload_key com.android.ondevicepersonalization.apex=$KEY_MAPPINGS/com.android.ondevicepersonalization.pem \
        --extra_apex_payload_key com.android.os.statsd.apex=$KEY_MAPPINGS/com.android.os.statsd.pem \
        --extra_apex_payload_key com.android.permission.apex=$KEY_MAPPINGS/com.android.permission.pem \
        --extra_apex_payload_key com.android.resolv.apex=$KEY_MAPPINGS/com.android.resolv.pem \
        --extra_apex_payload_key com.android.rkpd.apex=$KEY_MAPPINGS/com.android.rkpd.pem \
        --extra_apex_payload_key com.android.runtime.apex=$KEY_MAPPINGS/com.android.runtime.pem \
        --extra_apex_payload_key com.android.safetycenter.resources.apex=$KEY_MAPPINGS/com.android.safetycenter.resources.pem \
        --extra_apex_payload_key com.android.scheduling.apex=$KEY_MAPPINGS/com.android.scheduling.pem \
        --extra_apex_payload_key com.android.sdkext.apex=$KEY_MAPPINGS/com.android.sdkext.pem \
        --extra_apex_payload_key com.android.support.apexer.apex=$KEY_MAPPINGS/com.android.support.apexer.pem \
        --extra_apex_payload_key com.android.telephony.apex=$KEY_MAPPINGS/com.android.telephony.pem \
        --extra_apex_payload_key com.android.telephonymodules.apex=$KEY_MAPPINGS/com.android.telephonymodules.pem \
        --extra_apex_payload_key com.android.tethering.apex=$KEY_MAPPINGS/com.android.tethering.pem \
        --extra_apex_payload_key com.android.tzdata.apex=$KEY_MAPPINGS/com.android.tzdata.pem \
        --extra_apex_payload_key com.android.uwb.apex=$KEY_MAPPINGS/com.android.uwb.pem \
        --extra_apex_payload_key com.android.uwb.resources.apex=$KEY_MAPPINGS/com.android.uwb.resources.pem \
        --extra_apex_payload_key com.android.virt.apex=$KEY_MAPPINGS/com.android.virt.pem \
        --extra_apex_payload_key com.android.vndk.current.apex=$KEY_MAPPINGS/com.android.vndk.current.pem \
        --extra_apex_payload_key com.android.vndk.current.on_vendor.apex=$KEY_MAPPINGS/com.android.vndk.current.on_vendor.pem \
        --extra_apex_payload_key com.android.wifi.apex=$KEY_MAPPINGS/com.android.wifi.pem \
        --extra_apex_payload_key com.android.wifi.dialog.apex=$KEY_MAPPINGS/com.android.wifi.dialog.pem \
        --extra_apex_payload_key com.android.wifi.resources.apex=$KEY_MAPPINGS/com.android.wifi.resources.pem \
        --extra_apex_payload_key com.google.pixel.camera.hal.apex=$KEY_MAPPINGS/com.google.pixel.camera.hal.pem \
        --extra_apex_payload_key com.google.pixel.vibrator.hal.apex=$KEY_MAPPINGS/com.google.pixel.vibrator.hal.pem \
        --extra_apex_payload_key com.qorvo.uwb.apex=$KEY_MAPPINGS/com.qorvo.uwb.pem \
        "$OUT"/obj/PACKAGING/target_files_intermediates/superior_$DEVICE-target_files.zip \
        $SUPERIOR_VERSION-signed-target_files.zip

    checkExit

    if [ -z "${DELTA_TARGET_FILES}" ]; then
        echo -e "${CLR_BLD_BLU}Generating signed install package${CLR_RST}"
        ota_from_target_files -k $KEY_MAPPINGS/releasekey \
            $SUPERIOR_VERSION-signed-target_files.zip \
            $SUPERIOR_VERSION-signed-fullota.zip

        checkExit
    fi

    if [ "$DELTA_TARGET_FILES" ]; then
        # die if base target doesn't exist
        if [ ! -f "$DELTA_TARGET_FILES" ]; then
                echo -e "${CLR_BLD_RED}Delta error: base target files don't exist ($DELTA_TARGET_FILES)${CLR_RST}"
                exit 1
        fi
        ota_from_target_files -k $KEY_MAPPINGS/releasekey \
            --incremental_from $DELTA_TARGET_FILES \
            $SUPERIOR_VERSION-signed-target_files.zip \
            $SUPERIOR_VERSION-delta.zip
        checkExit
    fi

    if [ "$FLAG_IMG_ZIP" = 'y' ]; then
        echo -e "${CLR_BLD_BLU}Generating signed fastboot package${CLR_RST}"
        img_from_target_files \
            $SUPERIOR_VERSION-signed-target_files.zip \
            $SUPERIOR_VERSION-signed-image.zip
        checkExit
    fi
# Build rom package
elif [ "$FLAG_IMG_ZIP" = 'y' ]; then
    m otatools target-files-package "$CMD"

    checkExit

    echo -e "${CLR_BLD_BLU}Generating install package${CLR_RST}"
    ota_from_target_files \
        "$OUT"/obj/PACKAGING/target_files_intermediates/superior_$DEVICE-target_files.zip \
        $SUPERIOR_VERSION.zip

    checkExit

    echo -e "${CLR_BLD_BLU}Generating fastboot package${CLR_RST}"
    img_from_target_files \
        "$OUT"/obj/PACKAGING/target_files_intermediates/superior_$DEVICE-target_files.zip \
        $SUPERIOR_VERSION-image.zip

    checkExit

else
    m bacon "$CMD"

    checkExit
fi
echo -e ""

# Check the finishing time
TIME_END=$(date +%s.%N)

# Log those times at the end as a fun fact of the day
echo -e "${CLR_BLD_GRN}Total time elapsed:${CLR_RST} ${CLR_GRN}$(echo "($TIME_END - $TIME_START) / 60" | bc) minutes ($(echo "$TIME_END - $TIME_START" | bc) seconds)${CLR_RST}"
echo -e ""

exit 0
