# Inherit common Superior stuff
$(call inherit-product, vendor/superior/config/common.mk)

# Inherit Superior atv device tree
$(call inherit-product, device/superior/atv/superior_atv.mk)

# AOSP packages
PRODUCT_PACKAGES += \
    LeanbackIME

# Superior packages
PRODUCT_PACKAGES += \
    LineageCustomizer

PRODUCT_PACKAGE_OVERLAYS += vendor/superior/overlay/tv
