#!/bin/bash
# Description:
# Allwinner compile tools usage
# We follow below step:
#
# To sun8i & linux-3.x developer:
#------------------------------------------------------------------------------------------------
# Using origin buildroot compile once, then not compile with reusable.
#	Arch			Kernel				Out Dir
#	sun8i			Linux-3.x			out/${chip}
#------------------------------------------------------------------------------------------------
#
# To mostly developer(sun50i|linux-4.x): using tools/build/mkcommon.sh
#------------------------------------------------------------------------------------------------
#	Kernel			Linux-3.x			Linux-4.x
#	Toolchain		origin				linaro-5.3
#	Toolchain Dir		external-toolchain		gcc-linaro-5.3.1-2016.05
#	Def Rootfs		target_${ARCH}.tar.xz		target-${ARCH}-linaro-5.3.tar.xz
#	Out Dir			out/${chip}			out/${chip}-linaro-5.3
#
# To self design rootfs developer: using ${buildroot}/build/mkcommon.sh
#------------------------------------------------------------------------------------------------
#	Kernel			Linux-3.x			Linux-4.x
#	buildroot		origin				buildroot-201611
#	Out Dir			out/${chip}			out/${chip}-linaro-5.3
#
# As self design rootfs developer, if not manager buildroot, please reference to buildroot manual
#

BOARD_CONFIG_DIR=device/config/chips/
BOARD_CONFIG_FILE=device/.BoardConfig.mk

function build_lunch()
{
       TARGET_BOARD_PATH_ARRAY=( $(find $BOARD_CONFIG_DIR -name "BoardConfig-a133*.mk" | sort) )
       TARGET_BOARD_ARRAY=( $(find $BOARD_CONFIG_DIR -name "BoardConfig-a133*.mk" |  sed 's#.*/##' | sort) )
       echo "======you are building a133 android======"
       echo "${TARGET_BOARD_ARRAY[@]}" |xargs -n 1 | sed "=" | sed "N;s/\n/. /"

       while true; do
           read -p "which board would you like (1-${#TARGET_BOARD_ARRAY[@]}): " INDEX
           if [[ "$INDEX" =~ ^[0-9]+$ ]] && ((INDEX >= 1 && INDEX <= ${#TARGET_BOARD_ARRAY[@]})); then
               INDEX=$(($INDEX - 1))
               BUILD_TARGET_BOARD="${TARGET_BOARD_PATH_ARRAY[$INDEX]}"

               break
           else
               echo "Invalid input. Please enter a number between 1 and ${#TARGET_BOARD_ARRAY[@]}."
           fi
       done

       cp -f $BUILD_TARGET_BOARD $BOARD_CONFIG_FILE

       echo -e "build target board configuration: $BUILD_TARGET_BOARD\n"
       #select partition table
       source $BOARD_CONFIG_FILE
       echo "you board is ${DTS_NAME}"

       source $BOARD_CONFIG_FILE
       # autoconfig
       build/mkcommon.sh autoconfig  -o bsp -n default -i a133 -b c3 -k linux-4.9
}


function build()
{
    source $BOARD_CONFIG_FILE
    # 尝试执行一个需要root权限的命令，这里以修改系统时间为例（date命令设置时间需要root权限）
    sudo date
    if [ $? -ne 0 ]; then
        #echo "执行需要root权限的命令失败，可能当前用户无root权限，尝试使用sudo重新执行..."
        sudo date
        if [ $? -ne 0 ]; then
            echo "即使使用sudo也无法成功执行，可能存在其他问题，请检查。"
            exit 1
        else
            echo "通过sudo成功获取root权限并执行了命令。"
        fi
    else
        echo "当前用户已具备root权限，可顺利执行相关命令。"
    fi

    if [ -z "$@" ] ; then
        echo "start build all"

        # uboot
        cd brandy/brandy-2.0 && ./build.sh -p sun50iw10p1 && cd -
        if [ $? -eq 0 ]; then
            echo "Build uboot ok!"
        else
            echo "Build uboot failed!"
            exit 1
        fi
        # kernel & rootfs & other
        build/mkcommon.sh
        if [ $? -eq 0 ]; then
            echo "Build common ok!"
        else
            echo "Build common failed!"
            exit 1
        fi
        # pack
        build/mkcommon.sh pack
    else
        build/mkcommon.sh $@
    fi



}

if [ x"$1" == "xlunch" ] ;then
    build_lunch && exit 0
else
    build $@ && exit 0
fi

# get help info 
# build/mkcommon.sh -h

