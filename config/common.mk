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

# init file
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/etc/init/superior-system.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/superior-system.rc \
    vendor/superior/prebuilt/common/etc/init/superior-updates.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/superior-updates.rc \
    vendor/superior/prebuilt/common/etc/init/init.openssh.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.openssh.rc

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    Launcher3QuickStep

# Gapps
ifeq ($(SUPERIOR_GAPPS), full)
     $(call inherit-product, vendor/gms/products/gms.mk)
     $(call inherit-product-if-exists, vendor/partner_modules/build/mainline_modules.mk)
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

# Device Overlays
DEVICE_PACKAGE_OVERLAYS += vendor/superior/overlay/common

#Telephony
$(call inherit-product, vendor/superior/config/telephony.mk)

# ThemeOverlays
include packages/overlays/Themes/themes.mk

# Packages
include vendor/superior/config/packages.mk

#versioning
include vendor/superior/config/version.mk

# Bootanimation
include vendor/superior/prebuilt/common/bootanimation/bootanimation.mk

#Audio
include vendor/superior/config/audio.mk

# Superior_props
$(call inherit-product, vendor/superior/config/superior_props.mk)
