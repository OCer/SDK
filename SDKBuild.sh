#!/bin/sh

#  SDKBuild.sh
#  SDK
#
#  Created by Cer on 2018/11/6.
#  Copyright © 2018 Cer. All rights reserved.

# 要build的target名
TARGET_NAME=${PROJECT_NAME}

# 存放Framework的路径路径
OUTPUT_FOLDER="${SRCROOT}/${PROJECT_NAME}/"
TEST_FOLDER="${SRCROOT}/../SDKTest/SDKTest"
DEMO_FOLDER="${SRCROOT}/../SDKDemo/SDKDemo"

# 编译路径
IPHONE_DIR="build/Release-iphoneos/${TARGET_NAME}.framework"
SIMULATOR_DIR="build/Release-iphonesimulator/${TARGET_NAME}.framework"

# 删除之前的Framework文件
rm -rf "${OUTPUT_FOLDER}/${TARGET_NAME}.framework"
rm -rf "${TEST_FOLDER}/${TARGET_NAME}.framework"
rm -rf "${DEMO_FOLDER}/${TARGET_NAME}.framework"

# 分别编译模拟器和真机的Framework
xcodebuild -configuration "Release" -target "${TARGET_NAME}" -sdk iphoneos clean build
xcodebuild -configuration "Release" -target "${TARGET_NAME}" -sdk iphonesimulator clean build

# 拷贝Framework到目录
cp -R "${IPHONE_DIR}" "${OUTPUT_FOLDER}"

# 合并Framework
lipo -create -output "${IPHONE_DIR}/${TARGET_NAME}" "${SIMULATOR_DIR}/${TARGET_NAME}" "${OUTPUT_FOLDER}/${TARGET_NAME}.framework/${TARGET_NAME}"

# 拷贝Framework到别的工程
cp -R "${OUTPUT_FOLDER}/${TARGET_NAME}.framework" "${TEST_FOLDER}"
cp -R "${OUTPUT_FOLDER}/${TARGET_NAME}.framework" "${DEMO_FOLDER}"

# 删除编译之后生成的无关的配置文件
dir_path="${OUTPUT_FOLDER}/${TARGET_NAME}.framework/"
for file in $(ls ${dir_path})
do
if [[ ${file} =~ ".xcconfig" ]]
then
rm -f "${dir_path}/${file}"
fi
done

# 判断build文件夹是否存在，存在则删除
if [ -d "${SRCROOT}/build" ]
then
rm -rf "${SRCROOT}/build"
fi
