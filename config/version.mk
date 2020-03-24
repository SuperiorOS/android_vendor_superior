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

#Superior OS Versioning :
SUPERIOR_MOD_VERSION = Phoenix

ifndef SUPERIOR_BUILD_TYPE
    SUPERIOR_BUILD_TYPE := UNOFFICIAL
endif

# Test Build Tag
ifeq ($(SUPERIOR_TEST),true)
    SUPERIOR_BUILD_TYPE := DEVELOPER
endif

CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
SUPERIOR_DATE_YEAR := $(shell date -u +%Y)
SUPERIOR_DATE_MONTH := $(shell date -u +%m)
SUPERIOR_DATE_DAY := $(shell date -u +%d)
SUPERIOR_DATE_HOUR := $(shell date -u +%H)
SUPERIOR_DATE_MINUTE := $(shell date -u +%M)
SUPERIOR_BUILD_DATE_UTC := $(shell date -d '$(SUPERIOR_DATE_YEAR)-$(SUPERIOR_DATE_MONTH)-$(SUPERIOR_DATE_DAY) $(SUPERIOR_DATE_HOUR):$(SUPERIOR_DATE_MINUTE) UTC' +%s)
CUSTOM_BUILD_DATE := $(SUPERIOR_DATE_YEAR)$(SUPERIOR_DATE_MONTH)$(SUPERIOR_DATE_DAY)-$(SUPERIOR_DATE_HOUR)$(SUPERIOR_DATE_MINUTE)

ifeq ($(SUPERIOR_OFFICIAL), true)
   LIST = $(shell cat vendor/superior/superior.devices)
    ifeq ($(filter $(CURRENT_DEVICE), $(LIST)), $(CURRENT_DEVICE))
      IS_OFFICIAL=true
      SUPERIOR_BUILD_TYPE := OFFICIAL

PRODUCT_PACKAGES += \
    Updater

    endif
    ifneq ($(IS_OFFICIAL), true)
       SUPERIOR_BUILD_TYPE := UNOFFICIAL
       $(error Device is not official "$(CURRENT_DEVICE)")
    endif
endif

TARGET_PRODUCT_SHORT := $(subst superior_,,$(SUPERIOR_BUILD))

SUPERIOR_VERSION := SuperiorOS-$(SUPERIOR_MOD_VERSION)-$(CURRENT_DEVICE)-$(SUPERIOR_BUILD_TYPE)-$(CUSTOM_BUILD_DATE)

SUPERIOR_FINGERPRINT := SuperiorOS/$(SUPERIOR_MOD_VERSION)/$(PLATFORM_VERSION)/$(TARGET_PRODUCT_SHORT)/$(CUSTOM_BUILD_DATE)

SUPERIOR_DISPLAY_VERSION := SuperiorOS-$(SUPERIOR_MOD_VERSION)-$(SUPERIOR_BUILD_TYPE)

CUSTOM_PROPERTIES += \
  ro.superior.version=$(SUPERIOR_VERSION) \
  ro.superior.releasetype=$(SUPERIOR_BUILD_TYPE) \
  ro.modversion=$(SUPERIOR_MOD_VERSION) \
  ro.superior.display.version=$(SUPERIOR_DISPLAY_VERSION) \
  ro.superior.fingerprint=$(SUPERIOR_FINGERPRINT)
