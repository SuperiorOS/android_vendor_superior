for combo in $(curl -s https://raw.githubusercontent.com/SuperiorOS/android_vendor_superior/pie/superior.devices | sed -e 's/#.*$//' | awk '{printf "superior_%s-%s\n", $1, $2}')
do
    add_lunch_combo $combo
done
