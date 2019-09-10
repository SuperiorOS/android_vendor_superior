lunch_others_targets=()
for device in $(cat vendor/superior/superior.devices)
do
    for var in eng user userdebug; do
        lunch_others_targets+=("superior_$device-$var")
    done
done
