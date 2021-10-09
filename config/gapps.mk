# Gapps
ifeq ($(BUILD_WITH_GAPPS),true)
$(call inherit-product, vendor/gapps/gms_full.mk)

# Common Overlay
DEVICE_PACKAGE_OVERLAYS += \
    vendor/superior/overlay-gapps/common

# Exclude RRO Enforcement
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS +=  \
    vendor/superior/overlay-gapps

$(call inherit-product, vendor/superior/config/rro_overlays.mk)
endif
