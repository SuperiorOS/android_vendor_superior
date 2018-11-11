# Copyright (C) 2018 Project dotOS
# Copyright (C) 2018 Superior OS Project
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
SUPERIOR_MOD_VERSION = Meteor

ifndef SUPERIOR_BUILD_TYPE
    SUPERIOR_BUILD_TYPE := UNOFFICIAL
endif

# Test Build Tag
ifeq ($(SUPERIOR_TEST),true)
    SUPERIOR_BUILD_TYPE := DEVELOPER
endif

CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
DATE := $(shell date -u +%Y%m%d)
CUSTOM_BUILD_DATE := $(DATE)-$(shell date -u +%H%M)

ifeq ($(SUPERIOR_OFFICIAL), true)
   LIST = $(shell curl -s https://raw.githubusercontent.com/SuperiorOS/android_vendor_superior/pie/superior.devices)
   FOUND_DEVICE =  $(filter $(CURRENT_DEVICE), $(LIST))
    ifeq ($(FOUND_DEVICE),$(CURRENT_DEVICE))
      IS_OFFICIAL=true
      SUPERIOR_BUILD_TYPE := OFFICIAL
      
    endif
    ifneq ($(IS_OFFICIAL), true)
       SUPERIOR_BUILD_TYPE := UNOFFICIAL
       $(error Device is not official "$(FOUND)")
    endif
endif

TARGET_PRODUCT_SHORT := $(subst superior_,,$(CUSTOM_BUILD))

SUPERIOR_VERSION := SuperiorOS-$(SUPERIOR_MOD_VERSION)-$(CURRENT_DEVICE)-$(SUPERIOR_BUILD_TYPE)-$(CUSTOM_BUILD_DATE)

SUPERIOR_FINGERPRINT := SuperiorOS/$(SUPERIOR_MOD_VERSION)/$(PLATFORM_VERSION)/$(TARGET_PRODUCT_SHORT)/$(CUSTOM_BUILD_DATE)

PRODUCT_GENERIC_PROPERTIES += \
  ro.superior.version=$(SUPERIOR_VERSION) \
  ro.superior.releasetype=$(SUPERIOR_BUILD_TYPE) \
  ro.modversion=$(SUPERIOR_MOD_VERSION)

SUPERIOR_DISPLAY_VERSION := SuperiorOS-$(SUPERIOR_MOD_VERSION)-$(SUPERIOR_BUILD_TYPE)

PRODUCT_GENERIC_PROPERTIES += \
  ro.superior.display.version=$(SUPERIOR_DISPLAY_VERSION)\
  ro.superior.fingerprint=$(SUPERIOR_FINGERPRINT)
