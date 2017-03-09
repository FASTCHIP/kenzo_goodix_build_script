#!/bin/bash
cd ../nitrogen
#git revert --abort
echo "git revert --abort"
cd device/xiaomi/msm8956-common/
git revert --abort
cd ../../../
cd kernel/xiaomi/msm8956
git revert --abort
cd ../../../
cd vendor/xiaomi/
git revert --abort
cd ../../
# Updating sources
echo "Updating sources"
repo sync
# Revert fpc commits
echo "Revert fpc commits"
cd device/xiaomi/msm8956-common/
git revert -n bdcdc21de374d8f49e65c6302fe26840d75e9d08
cd ../../../
cd kernel/xiaomi/msm8956
git revert -n  fdbcea8acf83da159c1684c1c8697049d20aea4f
cd ../../../
cd vendor/xiaomi/
git revert -n 926fd45e9b53af937b321a04dba46d1643a72787
cd ../../
echo "Build firmware"
export USE_PREBUILT_CHROMIUM=1
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache/kenzo
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4000m"
out/host/linux-x86/bin/jack-admin start-server
#export EXPERIMENTAL_USE_JAVA8=1
# Colorize and add text parameters
red=$(tput setaf 1) # red
grn=$(tput setaf 2) # green
cya=$(tput setaf 6) # cyan
txtbld=$(tput bold) # Bold
bldred=${txtbld}$(tput setaf 1) # red 
bldgrn=${txtbld}$(tput setaf 2) # green
bldblu=${txtbld}$(tput setaf 4) # blue
bldcya=${txtbld}$(tput setaf 6) # cyan
txtrst=$(tput sgr0) # Reset
# setup environment
echo -e "${bldblu}Setting up environment ${txtrst}"
# set ccache due to your disk space,set it at your own risk
/usr/bin/ccache -M 50G
source build/envsetup.sh
#breakfast kenzo
echo -e ""
echo -e "${bldblu}Starting compilation ${txtrst}"
# get time of startup
res1=$(date +%s.%N)
#brunch kenzo
lunch nitrogen_kenzo-userdebug
make -j2  otapackage
#make -j* - Use your value. Depends on the number of cores and RAM
#make -j 6 bootimage
# finished? get elapsed time
res2=$(date +%s.%N)
out/host/linux-x86/bin/jack-admin kill-server
echo -e "\n${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"
