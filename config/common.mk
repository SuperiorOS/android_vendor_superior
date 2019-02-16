# Copyright (C) 2018 Project dotOS
# Copyright (C) 2018 Superior OS
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


PRODUCT_BRAND ?= SuperiorOS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

include vendor/superior/config/version.mk

# init file
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/etc/init.superior.rc:system/etc/init/init.superior.rc

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/superior/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/superior/prebuilt/common/bin/50-base.sh:system/addon.d/50-base.sh \

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/superior/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/superior/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif

# priv-app permissions
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/etc/permissions/privapp-permissions-superior.xml:system/etc/permissions/privapp-permissions-superior.xml

# Device Overlays
DEVICE_PACKAGE_OVERLAYS += \
    vendor/superior/overlay/common

# EXT4/F2FS format script
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/bin/format.sh:install/bin/format.sh

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/superior/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Markup libs
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/lib/libsketchology_native.so:system/lib/libsketchology_native.so \
    vendor/superior/prebuilt/common/lib64/libsketchology_native.so:system/lib64/libsketchology_native.so

# Pixel sysconfig
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/etc/sysconfig/pixel.xml:system/etc/sysconfig/pixel.xml

# init.d support
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner

# superiorOS-specific init file
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/etc/init.local.rc:root/init.superior.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/superior/prebuilt/common/media/LMspeed_508.emd:system/media/LMspeed_508.emd \
    vendor/superior/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Fix Dialer
PRODUCT_COPY_FILES +=  \
    vendor/superior/prebuilt/common/etc/sysconfig/dialer_experience.xml:system/etc/sysconfig/dialer_experience.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Latin IME lib - gesture typing
ifeq ($(TARGET_ARCH), $(filter $(TARGET_ARCH), arm64))
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/lib64/libjni_latinimegoogle.so:system/lib64/libjni_latinimegoogle.so \
    vendor/superior/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so
else
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so
endif

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Media
PRODUCT_GENERIC_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# Clean cache
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/bin/clean_cache.sh:system/bin/clean_cache.sh

# Recommend using the non debug dexpreopter
USE_DEX2OAT_DEBUG ?= false

# CAF
# Telephony packages
PRODUCT_PACKAGES += \
    ims-ext-common \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

# Weather
PRODUCT_COPY_FILES +=  \
    vendor/superior/prebuilt/common/etc/sysconfig/org.pixelexperience.weather.client.xml:system/etc/sysconfig/org.pixelexperience.weather.client.xml \
    vendor/superior/prebuilt/common/etc/permissions/org.pixelexperience.weather.client.xml:system/etc/default-permissions/org.pixelexperience.weather.client.xml

PRODUCT_PROPERTY_OVERRIDES += \
    org.pixelexperience.weather.revision=2

# Lawnchair
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/etc/sysconfig/lawnchair-hiddenapi-package-whitelist.xml:system/etc/sysconfig/lawnchair-hiddenapi-package-whitelist.xml

# Cutout control overlays
PRODUCT_PACKAGES += \
    HideCutout \
    StatusBarStock

# Default ringtone/notification/alarm sounds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.ringtone=Pubg.ogg,Pubg_Remix.ogg \
    ro.config.notification_sound=Pikachu.ogg \
    ro.config.alarm_alert=Helium.ogg

# Bootanimation
include vendor/superior/config/bootanimation.mk

#Telephony
$(call inherit-product, vendor/superior/config/telephony.mk)

# Some Apps
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/priv-app/MatchmakerPrebuilt.apk:system/priv-app/MatchmakerPrebuilt/MatchmakerPrebuilt.apk \
    vendor/superior/prebuilt/common/apk/MarkupGoogle.apk:system/app/MarkupGoogle/MarkupGoogle.apk \
    vendor/superior/prebuilt/common/apk/WellbeingPrebuilt.apk:system/app/WellbeingPrebuilt/WellbeingPrebuilt.apk

# Packages
include vendor/superior/config/packages.mk

# Fonts
include vendor/superior/config/fonts.mk

# Sounds
include vendor/superior/config/sounds.mk

# Superior_props
$(call inherit-product, vendor/superior/config/superior_props.mk)

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.adb.secure=1
endif

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
