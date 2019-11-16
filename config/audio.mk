AUDIO_PATH := vendor/superior/prebuilt/audio

ALARMS := A_real_hoot Awaken Bounce Bright_morning Cuckoo_clock Drip Early_twilight \
	Flow Full_of_wonder Gallop Gentle_breeze Icicles Jump_start Loose_change Nudge Orbit \
	Rise Rolling_fog Spokes Sunshower Sway Wag

RINGTONES := Beats Copycat Crackle Dance_party Early_bird Flutterby Hey_hey Hotline \
	Leaps_and_bounds Lollipop Lost_and_found Mash_up Monkey_around Romance Rrrring Schools_out \
	Shooting_star Soulful Spaceship Summer_night The_big_adventure Zen Zen_too

UI := Dock Effect_Tick InCallNotification KeypressDelete KeypressInvalid KeypressReturn \
	KeypressSpacebar KeypressStandard Lock Trusted Undock Unlock VideoRecord VideoStop \
	audio_end audio_initiate camera_click

NOTIFICATIONS := Beginning Birdsong Chime Clink Coconuts Duet End_note Flick Gentle_gong Hey \
	Mallet Note Orders_up Ping Pipes Pikachu Popcorn Shopkeeper Sticks_and_stones Strum Trill \
	Tuneup Tweeter Twinkle

PRODUCT_COPY_FILES += $(foreach f,$(ALARMS),\
	$(AUDIO_PATH)/alarms/$(f).ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/alarms/$(f).ogg)

PRODUCT_COPY_FILES += $(foreach f,$(RINGTONES),\
	$(AUDIO_PATH)/ringtones/$(f).ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ringtones/$(f).ogg)

PRODUCT_COPY_FILES += $(foreach f,$(UI),\
	$(AUDIO_PATH)/ui/$(f).ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ui/$(f).ogg)

PRODUCT_COPY_FILES += $(foreach f,$(NOTIFICATIONS),\
	$(AUDIO_PATH)/notifications/$(f).ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/notifications/$(f).ogg)

# Inherit AOSP audio package last so vendor audio overrides AOSP audio
$(call inherit-product, frameworks/base/data/sounds/AudioPackage14.mk)

