#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generat
#=========================================================================================================
        cd openwrt
        # 添加的 feeds 应用包优先于自带的 feed 里的 app
        echo "重复的包检测：👇"
        ./scripts/feeds list  | awk '{if(a[$1]){print $1}else{a[$1]++}}'
        echo "重复的包检测：👆"
        ./scripts/feeds list  | awk '{if(a[$1]){print $1}else{a[$1]++}}' | while read pkg_name;do
            # 目录是 / 分隔，feeds/xxx/ 一样就不打印
            find feeds/ -maxdepth 4 -type d -name $pkg_name | \
              awk -F/ 'NR==1{a[$2]=$0};NR==2{if(!a[$2]){for(i in a){if(a[i]){printf "%s/ %s\n",$0,a[i]}}}}' | \
              xargs -r -n2 echo  👉 rsync -av --delete
            find feeds/ -maxdepth 4 -type d -name $pkg_name | \
              awk -F/ 'NR==1{a[$2]=$0};NR==2{if(!a[$2]){for(i in a){if(a[i]){printf "%s/ %s\n",$0,a[i]}}}}' | \
              xargs -r -n2 rsync -av --delete
        done
