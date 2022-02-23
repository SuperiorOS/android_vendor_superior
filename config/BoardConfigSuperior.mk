# Recovery
BOARD_USES_FULL_RECOVERY_IMAGE ?= true

include vendor/superior/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include hardware/qcom-caf/common/BoardConfigQcom.mk
endif

include vendor/superior/config/BoardConfigSoong.mk
