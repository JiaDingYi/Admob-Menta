
#!/bin/bash

echo "Start Build..."

FRAMEWORK_NAME="$1"
WORKSPACE_NAME="AdmobDemo"
SCHEME_NAME="$1"
CONFIGURATION='Release'

cd ..
# 获取当前脚本路径
SHELL_DIR=`pwd`
# 工程路径
PROJECT_DIR="${SHELL_DIR}/Example"
# 编译过程的中间产物
BUILD_ROOT="${PROJECT_DIR}/BuildRoot"
TARGET_DIR="${SHELL_DIR}/Build"

# 确保输出目录存在
rm -rf "$TARGET_DIR"
mkdir -p "${TARGET_DIR}"

# 构建设备和模拟器版本
SDKS=("iphoneos" "iphonesimulator" "iphonesimulator")
ARCHS=("arm64" "x86_64" "arm64")
for index in ${!SDKS[*]}; do
  sdk=${SDKS[$index]}
  arch=${ARCHS[$index]}
  outputPath=${TARGET_DIR}/$index
  xcodebuild clean build -workspace "${PROJECT_DIR}/${WORKSPACE_NAME}.xcworkspace" -scheme "${SCHEME_NAME}"  -configuration "${CONFIGURATION}" -sdk ${sdk} ONLY_ACTIVE_ARCH=NO BUILD_DIR=${outputPath} BUILD_ROOT="${BUILD_ROOT}" -arch "${arch}" || exit 1
done

lipo -create ${TARGET_DIR}/1/${CONFIGURATION}-iphonesimulator/${FRAMEWORK_NAME}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME} ${TARGET_DIR}/2/${CONFIGURATION}-iphonesimulator/${FRAMEWORK_NAME}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME} -output ${TARGET_DIR}/${FRAMEWORK_NAME}

mv -f ${TARGET_DIR}/${FRAMEWORK_NAME} ${TARGET_DIR}/1/${CONFIGURATION}-iphonesimulator/${FRAMEWORK_NAME}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}

xcodebuild -create-xcframework \
    -framework "${TARGET_DIR}/0/${CONFIGURATION}-iphoneos/${FRAMEWORK_NAME}/${FRAMEWORK_NAME}.framework" \
    -framework "${TARGET_DIR}/1/${CONFIGURATION}-iphonesimulator/${FRAMEWORK_NAME}/${FRAMEWORK_NAME}.framework" \
    -output "${TARGET_DIR}/${FRAMEWORK_NAME}/${FRAMEWORK_NAME}.xcframework"

if [ "${FRAMEWORK_NAME}" == "MentaVlionGlobal" ]; then
    cp -r "${SHELL_DIR}/Menta-Global/Assets/Resource" "${TARGET_DIR}/${FRAMEWORK_NAME}"
fi
