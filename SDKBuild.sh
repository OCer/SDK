#!/bin/sh

#  SDKBuild.sh
#  SDK
#
#  Created by Cer on 2018/11/6.
#  Copyright © 2018 Cer. All rights reserved.


# 要build的target名
TARGET_NAME="${PROJECT_NAME}" # 如果和target名不一致，需要修改为正确的target名
CONFIG="Release" # "Release" "${CONFIGURATION}" "Debug" 编译模式，使用Release即可

# 项目里存放Framework的路径
OUTPUT_FOLDER="${SRCROOT}/${PROJECT_NAME}/"
TEST_FOLDER="${SRCROOT}/../SDKTest/SDKTest"
DEMO_FOLDER="${SRCROOT}/../SDKDemo/SDKDemo"

# ---------- 以上配置是可以修改的，下面的配置则不需要改 ----------

# 编译时存放framework的路径
IPHONE_DIR="build/${CONFIG}-iphoneos/${TARGET_NAME}.framework"
SIMULATOR_DIR="build/${CONFIG}-iphonesimulator/${TARGET_NAME}.framework"

# 定义函数，用来清除编译产生的文件
function removeBuild ()
{
# 判断build文件夹是否存在，存在则删除
if [ -d "${SRCROOT}/build" ]
then
rm -rf "${SRCROOT}/build"
fi
}

removeBuild # 编译前先删除之前留下来的，防止干扰

# 分别编译模拟器和真机的Framework
xcodebuild -configuration "${CONFIG}" -target "${TARGET_NAME}" -sdk iphoneos clean build
xcodebuild -configuration "${CONFIG}" -target "${TARGET_NAME}" -sdk iphonesimulator clean build

# 判断IPHONE_DIR和SIMULATOR_DIR是否存在，存在就是编译成功
if [[ -d "${IPHONE_DIR}" && -d "${SIMULATOR_DIR}" ]]
then
# 删除之前的Framework文件
rm -rf "${OUTPUT_FOLDER}/${TARGET_NAME}.framework"
rm -rf "${TEST_FOLDER}/${TARGET_NAME}.framework"
rm -rf "${DEMO_FOLDER}/${TARGET_NAME}.framework"

# 拷贝Framework到目录
cp -R "${IPHONE_DIR}" "${OUTPUT_FOLDER}"

# 合并Framework
lipo -create "${IPHONE_DIR}/${TARGET_NAME}" "${SIMULATOR_DIR}/${TARGET_NAME}" -output "${OUTPUT_FOLDER}/${TARGET_NAME}.framework/${TARGET_NAME}"

# 删除编译之后生成的无关的配置文件
DIR_PATH="${OUTPUT_FOLDER}/${TARGET_NAME}.framework"
for FILE in $(ls "${DIR_PATH}"|tr " " "?") # 解决名字带空格的问题
do
if [[ "${FILE}" =~ ".xcconfig" ]]
then
rm -f "${DIR_PATH}/${FILE}"
fi
done

# 拷贝Framework到别的工程
cp -R "${OUTPUT_FOLDER}/${TARGET_NAME}.framework" "${TEST_FOLDER}"
cp -R "${OUTPUT_FOLDER}/${TARGET_NAME}.framework" "${DEMO_FOLDER}"

fi

removeBuild
