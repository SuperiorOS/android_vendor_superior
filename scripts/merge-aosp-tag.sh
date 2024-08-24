#!/bin/bash
# AOSP tag merge script for WaveOS
# Author: Adithya R (ghostrider_reborn)

# Colors
red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
end=$'\e[0m'

REMOTE="superior"
BRANCH="fourteen"

BLACKLIST="
packages/apps/Updater \
prebuilts/clang/host/linux-x86 \
external/libjpeg-turbo"

# fetch tag from user
read -p "Enter the AOSP tag you wanna merge: " TAG
echo

# verify tag
if ! wget -q --spider https://android.googlesource.com/platform/manifest/+/refs/tags/$TAG; then
    echo "Invalid tag: $TAG!"
    exit 1
fi

# fetch all existing repos
echo "${blu}Fetching list of repos to be merged..."
repo forall -c "if [ \"\$REPO_REMOTE\" = \"$REMOTE\" ]; then echo \$REPO_PATH; fi" > .temp 2> /dev/null

# save current dir
cur_dir=$(pwd)

# initialize some files
for file in failed success unchanged; do
	rm -f $file
	touch $file
done

# main
for path in $(cat .temp); do
	echo

	if [[ $BLACKLIST =~ $path ]]; then
            echo -e "$path is in blacklist, skipping"
            continue
        fi

	if ! grep -q $path manifest/default.xml; then
		echo "${red}$path not found in AOSP manifest! Skipping..."
		continue
	fi

	echo "${blu}Merging ${path}..."
	name=$(grep "path=\"$path\"" manifest/default.xml | sed -e 's/.*name="//' -e 's/".*//')

	cd $path

	if [[ $(git status --porcelain) = *" M "* ]]; then
		# save uncommitted changes that could be important
		git checkout -q -b "staging-$(date -%s)" &> /dev/null
		git commit -a -q -m "Unsaved Work $(date)" &> /dev/null
	fi

	# reset HEAD to our branch
	git checkout -q $BRANCH &> /dev/null
	git fetch -q $REMOTE $BRANCH &> /dev/null
	git reset --hard $REMOTE/$BRANCH &> /dev/null

	git fetch -q https://android.googlesource.com/$name $TAG &> /dev/null
	if git merge --log FETCH_HEAD -q -m "Merge tag '$TAG' of https://android.googlesource.com/$name into $BRANCH" &> /dev/null; then
		if [[ $(git rev-parse HEAD) != $(git rev-parse $REMOTE/$BRANCH) ]] && [[ $(git diff HEAD $REMOTE/$BRANCH) ]]; then
			echo "$path" >> $cur_dir/success
			git commit --amend --no-edit
			echo "${grn}Merging $path succeeded!"
		else
			echo "${end}$path - unchanged"
			echo "$path" >> $cur_dir/unchanged
			git reset --hard $REMOTE/$BRANCH &> /dev/null
		fi
	else
		echo "$path" >> $cur_dir/failed
		echo "${red}$path merging failed!"
	fi

	cd $cur_dir
done

echo -e "$grn \nPushing succeeded repos: $end"
for repo in $(cat success); do
	cd $repo
	echo $repo
	wait
	git push git@github.com:SuperiorOS/$repo -q &> /dev/null
	cd $cur_dir
done

echo -e "$red \nThese repos failed merging: $end"
cat failed

rm -f .temp
echo $end
