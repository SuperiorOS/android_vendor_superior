# Copyright (C) 2018-22 The SuperiorOS Project
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
    vendor/superior/prebuilt/common/bin/50-superior.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-superior.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/addon.d/50-superior.sh

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/superior/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/superior/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/backuptool_ab.sh \
    system/bin/backuptool_ab.functions \
    system/bin/backuptool_postinstall.sh

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# Superior-specific init rc file
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/etc/init/init.superior-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.superior-system_ext.rc \
    vendor/superior/prebuilt/common/etc/init/init.superior-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.superior-updater.rc

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Skip boot JAR checks.
SKIP_BOOT_JARS_CHECK := true

# TextClassifier
PRODUCT_PACKAGES += \
    libtextclassifier_annotator_en_model \
    libtextclassifier_annotator_universal_model \
    libtextclassifier_actions_suggestions_universal_model \
    libtextclassifier_lang_id_model

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# Gapps
ifeq ($(BUILD_WITH_GAPPS),true)
$(call inherit-product-if-exists, vendor/gms/products/gms.mk)
endif

# Include Bootanimation
$(call inherit-product, vendor/superior/config/bootanimation.mk)

# Include AOSP audio files
include vendor/superior/config/aosp_audio.mk

# Include Superior audio files
include vendor/superior/config/superior_audio.mk

# Incude Superior Branding
include vendor/superior/config/branding.mk

# Include Superior Packages
include vendor/superior/config/packages.mk

# Include Superior_props
$(call inherit-product, vendor/superior/config/superior_props.mk)

-include $(WORKSPACE)/build_env/image-auto-bits.mk
