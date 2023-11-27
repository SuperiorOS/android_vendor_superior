# Copyright (C) 2018-23 The SuperiorOS Project
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

# Required packages
PRODUCT_PACKAGES += \
    Aperture \
    DocumentsUI \
    Etar \
    GameSpace \
    LatinIME \
    Launcher3QuickStep \
    messaging \
    Stk \
    ThemePicker \
    ThemesStub

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += \
    vendor/superior/overlay \
    vendor/superior/overlay/no-rro

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/superior/overlay/common \
    vendor/superior/overlay/no-rro

# Include Superior LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/superior/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/superior/overlay/dictionaries

# Charger
PRODUCT_PACKAGES += \
    charger_res_images \
    product_charger_res_images \
    product_charger_res_images_vendor

# Extra tools in Superior
PRODUCT_PACKAGES += \
    curl \
    getcap \
    setcap

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# World APN list
PRODUCT_PACKAGES += \
    apns-conf.xml

# Sensitive Phone Numbers list
PRODUCT_COPY_FILES += \
    vendor/prebuilts/common/etc/sensitive_pn.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sensitive_pn.xml
