# Inherit full common Superior stuff
$(call inherit-product, vendor/superior/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Superior LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/superior/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/superior/overlay/dictionaries

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode?=true

$(call inherit-product, vendor/superior/config/telephony.mk)
