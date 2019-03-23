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


ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif


ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.dun.override=0
endif

# Required packages
PRODUCT_PACKAGES += \
    Contacts \
    BluetoothExt \
    Dialer \
    ExactCalculator \
    LatinIME \
    messaging \
    Music \
    PixelThemesStub2019 \
    SafetyHubPrebuilt \
    Superiorwalls \
    StitchImage \
    Stk \
    ThemePicker \
    ViaBrowser \
    OmniStyle \
    Custom-Fonts

# Switch themes
PRODUCT_PACKAGES += \
    Stock \
    OnePlus \
    Narrow \
    Contained \
    Telegram \
    Retro \
    MD2 \
    Stockish

# Extra tools in Lineage
PRODUCT_PACKAGES += \
    7z \
    awk \
    bash \
    bzip2 \
    curl \
    getcap \
    htop \
    lib7z \
    libsepol \
    pigz \
    powertop \
    setcap \
    unrar \
    unzip \
    vim \
    wget \
    zip

# exFAT tools
 PRODUCT_PACKAGES += \
    fsck.exfat \
    mkfs.exfat

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# init file
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/etc/init.local.rc:system/etc/init/init.superior.rc

# APN
PRODUCT_PACKAGES += \
    apns-conf.xml

# Offline charger
PRODUCT_PACKAGES += \
    charger_res_images \
    product_charger_res_images

# Cutout control overlay
PRODUCT_PACKAGES += \
    NoCutoutOverlay

# Launchers

ifeq ($(TARGET_LAUNCHER),lawnchair)
include vendor/superior/prebuilt/app/Lawnchair/lawnchair.mk
else ifeq ($(TARGET_LAUNCHER),oplauncher)
include vendor/superior/prebuilt/app/OPlauncher/OPLauncher2.mk
else
     $(warning TARGET_LAUNCHER is invalid or undefined, building Launcher3 as default launcher)

PRODUCT_PACKAGES += \
    Launcher3QuickStep
endif
