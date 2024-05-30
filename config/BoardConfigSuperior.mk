# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0

# Recovery
BOARD_USES_FULL_RECOVERY_IMAGE ?= true

include vendor/superior/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
    include hardware/qcom-caf/common/BoardConfigQcom.mk
endif

include vendor/superior/config/BoardConfigSoong.mk
