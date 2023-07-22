# Copyright (C) 2018-22 Superior OS Project
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

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/superior/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    Launcher3QuickStep

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= true
TARGET_PIXEL_FACE_UNLOCK_SUPPORTED ?= false
ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    FaceUnlockService
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face_unlock_service.enabled=$(TARGET_FACE_UNLOCK_SUPPORTED)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
else ifeq ($(TARGET_PIXEL_FACE_UNLOCK_SUPPORTED),true)
    PRODUCT_PACKAGES += \
        SettingsGoogleFutureFaceEnroll
endif

# Gapps
ifeq ($(BUILD_WITH_GAPPS),true)
    $(call inherit-product, vendor/gapps/common/common-vendor.mk)
endif

# Superior Permissions
PRODUCT_COPY_FILES += \
    vendor/superior/config/permissions/privapp-permissions-superior-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-superior.xml \
    vendor/superior/config/permissions/privapp-permissions-superior-system_ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-superior-system_ext.xml \
    vendor/superior/config/permissions/privapp-permissions-superior.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-superior.xml

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

ifeq ($(TARGET_DISABLE_GRALLOC2_P010_SUPPORT), true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.gralloc.disablep010?=true
endif

# Device Overlays
DEVICE_PACKAGE_OVERLAYS += vendor/superior/overlay/common

#Telephony
$(call inherit-product, vendor/superior/config/telephony.mk)

# ThemeOverlays
include packages/overlays/Themes/themes.mk

# Packages
include vendor/superior/config/packages.mk
include vendor/prebuilts/prebuilts.mk

#versioning
include vendor/superior/config/version.mk

# Superior_props
$(call inherit-product, vendor/superior/config/superior_props.mk)
