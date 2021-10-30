LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := WallpaperPickerGoogleRelease
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := WallpaperPickerGoogleRelease.apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_CLASS := APPS
LOCAL_SYSTEM_EXT_MODULE := true
LOCAL_PRIVILEGED_MODULE := true
LOCAL_OVERRIDES_PACKAGES := WallpaperPicker WallpaperPicker2 WallpaperCropper ThemePicker
LOCAL_OPTIONAL_USES_LIBRARIES := org.apache.http.legacy
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
include $(BUILD_PREBUILT)
