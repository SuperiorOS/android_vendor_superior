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

#Superior OS Versioning :
SUPERIOR_MOD_VERSION = Fourteen-Alpha

ifndef SUPERIOR_BUILD_TYPE
    SUPERIOR_BUILD_TYPE := COMMUNITY
endif

# Test Build Tag
ifeq ($(SUPERIOR_TEST),true)
    SUPERIOR_BUILD_TYPE := DEVELOPER
endif

CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
SUPERIOR_BUILD_DATE_UTC := $(shell date -u '+%Y%m%d-%H%M')
BUILD_DATE_TIME := $(shell date -u '+%Y%m%d%H%M')

ifeq ($(SUPERIOR_OFFICIAL), true)
   LIST = $(shell cat vendor/superior/superior.devices)
    ifeq ($(filter $(CURRENT_DEVICE), $(LIST)), $(CURRENT_DEVICE))
      IS_OFFICIAL=true
      SUPERIOR_BUILD_TYPE := RELEASE

#include vendor/superior-priv/keys.mk
PRODUCT_PACKAGES += \
    Updater

    endif
    ifneq ($(IS_OFFICIAL), true)
       SUPERIOR_BUILD_TYPE := COMMUNITY
       $(error Device is not official "$(CURRENT_DEVICE)")
    endif
endif

ifeq ($(BUILD_WITH_GAPPS),true)
SUPERIOR_EDITION := GAPPS
else
SUPERIOR_EDITION := Vanilla
endif

ifeq ($(SUPERIOR_EDITION), GAPPS)
SUPERIOR_VERSION := SuperiorOS-$(SUPERIOR_MOD_VERSION)-$(CURRENT_DEVICE)-$(SUPERIOR_EDITION)-$(SUPERIOR_BUILD_TYPE)-$(SUPERIOR_BUILD_DATE_UTC)
SUPERIOR_FINGERPRINT := SuperiorOS/$(SUPERIOR_MOD_VERSION)/$(PLATFORM_VERSION)/$(SUPERIOR_BUILD_DATE_UTC)
SUPERIOR_DISPLAY_VERSION := SuperiorOS-$(SUPERIOR_MOD_VERSION)-$(SUPERIOR_BUILD_TYPE)
else
SUPERIOR_VERSION := SuperiorOS-$(SUPERIOR_MOD_VERSION)-$(CURRENT_DEVICE)-$(SUPERIOR_BUILD_TYPE)-$(SUPERIOR_BUILD_DATE_UTC)
SUPERIOR_FINGERPRINT := SuperiorOS/$(SUPERIOR_MOD_VERSION)/$(PLATFORM_VERSION)/$(SUPERIOR_BUILD_DATE_UTC)
SUPERIOR_DISPLAY_VERSION := SuperiorOS-$(SUPERIOR_MOD_VERSION)-$(SUPERIOR_BUILD_TYPE)
endif

TARGET_PRODUCT_SHORT := $(subst superior_,,$(SUPERIOR_BUILD))

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
  ro.superior.version=$(SUPERIOR_VERSION) \
  ro.superior.releasetype=$(SUPERIOR_BUILD_TYPE) \
  ro.modversion=$(SUPERIOR_MOD_VERSION) \
  ro.superior.display.version=$(SUPERIOR_DISPLAY_VERSION) \
  ro.superior.fingerprint=$(SUPERIOR_FINGERPRINT) \
  ro.build.datetime=$(BUILD_DATE_TIME) \
  ro.superior.edition=$(SUPERIOR_EDITION)

