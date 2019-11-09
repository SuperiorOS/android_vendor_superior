# Copyright (C) 2018-19 Superior OS Project
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

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/superior/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/superior/prebuilt/common/bin/50-superior.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-superior.sh \
    vendor/superior/prebuilt/common/bin/blacklist:$(TARGET_COPY_OUT_SYSTEM)/addon.d/blacklist

# Copy all Superior-specific init rc files
$(foreach f,$(wildcard vendor/superior/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

#Recorder Permissions
PRODUCT_COPY_FILES += \
    vendor/superior/config/permissions/privapp-permissions-recorder.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-recorder.xml \
    vendor/superior/config/permissions/org.pixelexperience.recorder.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/org.pixelexperience.recorder.xml

#Superior Permissions
PRODUCT_COPY_FILES += \
    vendor/superior/config/permissions/privapp-permissions-superior-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-superior.xml \

# Include LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/superior/overlay/dictionaries

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/superior/overlay

# Default ringtone/notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Soulful.ogg \
    ro.config.notification_sound=Pikachu.ogg \
    ro.config.alarm_alert=Helium.ogg

#OmniJaws
PRODUCT_PACKAGES += \
    OmniJaws \
    WeatherIcons

# Device Overlays
DEVICE_PACKAGE_OVERLAYS += \
    vendor/superior/overlay/common

#Telephony
$(call inherit-product, vendor/superior/config/telephony.mk)

# Packages
include vendor/superior/config/packages.mk

#versioning
include vendor/superior/config/version.mk

# Fonts
include vendor/superior/config/fonts.mk

# Sounds
include vendor/superior/config/sounds.mk

# Bootanimation
include vendor/superior/config/bootanimation.mk

# Superior_props
$(call inherit-product, vendor/superior/config/superior_props.mk)
