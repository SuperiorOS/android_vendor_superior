# Google Overlays
PRODUCT_PACKAGES += \
    CaptivePortalLoginOverlay \
    CellBroadcastServiceOverlay \
    GoogleConfigOverlay \
    GooglePermissionControllerOverlay \
    GoogleWebViewOverlay \
    ManagedProvisioningPixelOverlay \
    ManagedProvisioningPixelOverlay \
    PixelConfigOverlay2018 \
    PixelConfigOverlay2019 \
    PixelConfigOverlay2019Midyear \
    PixelConfigOverlayCommon \
    PixelSetupWizardOverlayAosp \
    PixelTetheringOverlay \
    SettingsGoogleOverlayAosp

ifeq ($(TARGET_INCLUDE_LIVE_WALLPAPERS),true)
PRODUCT_PACKAGES += \
    PixelLiveWallpapersOverlay
endif
