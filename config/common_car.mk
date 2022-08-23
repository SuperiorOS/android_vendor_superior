# Inherit common Superior stuff
$(call inherit-product, vendor/superior/config/common.mk)

# Inherit Superior car device tree
$(call inherit-product, device/superior/car/superior_car.mk)

# Inherit the main AOSP car makefile that turns this into an Automotive build
$(call inherit-product, packages/services/Car/car_product/build/car.mk)
