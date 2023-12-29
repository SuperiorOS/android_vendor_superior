# vars for use by utils
# the following are already defined in build/make:
# empty space comma newline pound backslash
colon := $(empty):$(empty)
underscore := $(empty)_$(empty)

# $(call add-radio-file-sha1-checked,path,sha1)
define add-radio-file-sha1-checked
  $(eval path := $(LOCAL_PATH)/$(1))
  $(eval sha1 := $(shell sha1sum "$(path)" | cut -d" " -f 1))
  $(if $(filter $(sha1),$(2)),
    $(call add-radio-file,$(1)),
    $(error $(path) SHA1 mismatch ($(sha1) != $(2))))
endef
