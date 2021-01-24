include vendor/superior/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/superior/config/BoardConfigQcom.mk
endif

# Gapps
ifeq ($(WITH_GAPPS), true)
    include vendor/gapps/products/board.mk
endif

include vendor/superior/config/BoardConfigSoong.mk
