# Safetynet
TARGET_FORCE_BUILD_FINGERPRINT := google/crosshatch/crosshatch:11/RQ1A.201205.003/6906706:user/release-keys

include vendor/superior/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/superior/config/BoardConfigQcom.mk
endif

include vendor/superior/config/BoardConfigSoong.mk
