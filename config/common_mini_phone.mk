# Inherit mini common Superior stuff
$(call inherit-product, vendor/superior/config/common_mini.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

$(call inherit-product, vendor/superior/config/telephony.mk)
