#!/bin/sh
set -e

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

case "${TARGETED_DEVICE_FAMILY}" in
  1,2)
    TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
    ;;
  1)
    TARGET_DEVICE_ARGS="--target-device iphone"
    ;;
  2)
    TARGET_DEVICE_ARGS="--target-device ipad"
    ;;
  3)
    TARGET_DEVICE_ARGS="--target-device tv"
    ;;
  4)
    TARGET_DEVICE_ARGS="--target-device watch"
    ;;
  *)
    TARGET_DEVICE_ARGS="--target-device mac"
    ;;
esac

install_resource()
{
  if [[ "$1" = /* ]] ; then
    RESOURCE_PATH="$1"
  else
    RESOURCE_PATH="${PODS_ROOT}/$1"
  fi
  if [[ ! -e "$RESOURCE_PATH" ]] ; then
    cat << EOM
error: Resource "$RESOURCE_PATH" not found. Run 'pod install' to update the copy resources script.
EOM
    exit 1
  fi
  case $RESOURCE_PATH in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}"
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}"
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.framework)
      echo "mkdir -p ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av $RESOURCE_PATH ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH"`.mom\""
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd\""
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm\""
      xcrun mapc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE="$RESOURCE_PATH"
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    *)
      echo "$RESOURCE_PATH"
      echo "$RESOURCE_PATH" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "../../../Classes/Resource/1977blowout.png"
  install_resource "../../../Classes/Resource/1977map.png"
  install_resource "../../../Classes/Resource/amaroMap.png"
  install_resource "../../../Classes/Resource/blackboard1024.png"
  install_resource "../../../Classes/Resource/brannanBlowout.png"
  install_resource "../../../Classes/Resource/brannanContrast.png"
  install_resource "../../../Classes/Resource/brannanLuma.png"
  install_resource "../../../Classes/Resource/brannanProcess.png"
  install_resource "../../../Classes/Resource/brannanScreen.png"
  install_resource "../../../Classes/Resource/earlybirdBlowout.png"
  install_resource "../../../Classes/Resource/earlyBirdCurves.png"
  install_resource "../../../Classes/Resource/earlybirdMap.png"
  install_resource "../../../Classes/Resource/earlybirdOverlayMap.png"
  install_resource "../../../Classes/Resource/edgeBurn.png"
  install_resource "../../../Classes/Resource/hefeGradientMap.png"
  install_resource "../../../Classes/Resource/hefeMap.png"
  install_resource "../../../Classes/Resource/hefeMetal.png"
  install_resource "../../../Classes/Resource/hefeSoftLight.png"
  install_resource "../../../Classes/Resource/hudsonBackground.png"
  install_resource "../../../Classes/Resource/hudsonMap.png"
  install_resource "../../../Classes/Resource/inkwellMap.png"
  install_resource "../../../Classes/Resource/kelvinMap.png"
  install_resource "../../../Classes/Resource/lomoMap.png"
  install_resource "../../../Classes/Resource/moon-map.png"
  install_resource "../../../Classes/Resource/nashvilleMap.png"
  install_resource "../../../Classes/Resource/old-fashion-screen.png"
  install_resource "../../../Classes/Resource/overlayMap.png"
  install_resource "../../../Classes/Resource/riseMap.png"
  install_resource "../../../Classes/Resource/sierraMap.png"
  install_resource "../../../Classes/Resource/sierraVignette.png"
  install_resource "../../../Classes/Resource/softLight.png"
  install_resource "../../../Classes/Resource/sutroCurves.png"
  install_resource "../../../Classes/Resource/sutroEdgeBurn.png"
  install_resource "../../../Classes/Resource/sutroMetal.png"
  install_resource "../../../Classes/Resource/toasterColorShift.png"
  install_resource "../../../Classes/Resource/toasterCurves.png"
  install_resource "../../../Classes/Resource/toasterMetal.png"
  install_resource "../../../Classes/Resource/toasterOverlayMapWarm.png"
  install_resource "../../../Classes/Resource/toasterSoftLight.png"
  install_resource "../../../Classes/Resource/valenciaGradientMap.png"
  install_resource "../../../Classes/Resource/valenciaMap.png"
  install_resource "../../../Classes/Resource/vignetteMap.png"
  install_resource "../../../Classes/Resource/waldenMap.png"
  install_resource "../../../Classes/Resource/xproMap.png"
  install_resource "../../../Classes/Resource/clarendon-curve.acv"
  install_resource "../../../Classes/Resource/crema-curve.acv"
  install_resource "../../../Classes/Resource/fresh.acv"
  install_resource "../../../Classes/Resource/gray-curve.acv"
  install_resource "../../../Classes/Resource/gringham-curve.acv"
  install_resource "../../../Classes/Resource/lark-curve.acv"
  install_resource "../../../Classes/Resource/metalic-curve.acv"
  install_resource "../../../Classes/Resource/nashville-curve.acv"
  install_resource "../../../Classes/Resource/old-fashion.acv"
  install_resource "../../../Classes/Resource/sierra-curve.acv"
  install_resource "GPUImage/framework/Resources/lookup.png"
  install_resource "GPUImage/framework/Resources/lookup_amatorka.png"
  install_resource "GPUImage/framework/Resources/lookup_miss_etikate.png"
  install_resource "GPUImage/framework/Resources/lookup_soft_elegance_1.png"
  install_resource "GPUImage/framework/Resources/lookup_soft_elegance_2.png"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "../../../Classes/Resource/1977blowout.png"
  install_resource "../../../Classes/Resource/1977map.png"
  install_resource "../../../Classes/Resource/amaroMap.png"
  install_resource "../../../Classes/Resource/blackboard1024.png"
  install_resource "../../../Classes/Resource/brannanBlowout.png"
  install_resource "../../../Classes/Resource/brannanContrast.png"
  install_resource "../../../Classes/Resource/brannanLuma.png"
  install_resource "../../../Classes/Resource/brannanProcess.png"
  install_resource "../../../Classes/Resource/brannanScreen.png"
  install_resource "../../../Classes/Resource/earlybirdBlowout.png"
  install_resource "../../../Classes/Resource/earlyBirdCurves.png"
  install_resource "../../../Classes/Resource/earlybirdMap.png"
  install_resource "../../../Classes/Resource/earlybirdOverlayMap.png"
  install_resource "../../../Classes/Resource/edgeBurn.png"
  install_resource "../../../Classes/Resource/hefeGradientMap.png"
  install_resource "../../../Classes/Resource/hefeMap.png"
  install_resource "../../../Classes/Resource/hefeMetal.png"
  install_resource "../../../Classes/Resource/hefeSoftLight.png"
  install_resource "../../../Classes/Resource/hudsonBackground.png"
  install_resource "../../../Classes/Resource/hudsonMap.png"
  install_resource "../../../Classes/Resource/inkwellMap.png"
  install_resource "../../../Classes/Resource/kelvinMap.png"
  install_resource "../../../Classes/Resource/lomoMap.png"
  install_resource "../../../Classes/Resource/moon-map.png"
  install_resource "../../../Classes/Resource/nashvilleMap.png"
  install_resource "../../../Classes/Resource/old-fashion-screen.png"
  install_resource "../../../Classes/Resource/overlayMap.png"
  install_resource "../../../Classes/Resource/riseMap.png"
  install_resource "../../../Classes/Resource/sierraMap.png"
  install_resource "../../../Classes/Resource/sierraVignette.png"
  install_resource "../../../Classes/Resource/softLight.png"
  install_resource "../../../Classes/Resource/sutroCurves.png"
  install_resource "../../../Classes/Resource/sutroEdgeBurn.png"
  install_resource "../../../Classes/Resource/sutroMetal.png"
  install_resource "../../../Classes/Resource/toasterColorShift.png"
  install_resource "../../../Classes/Resource/toasterCurves.png"
  install_resource "../../../Classes/Resource/toasterMetal.png"
  install_resource "../../../Classes/Resource/toasterOverlayMapWarm.png"
  install_resource "../../../Classes/Resource/toasterSoftLight.png"
  install_resource "../../../Classes/Resource/valenciaGradientMap.png"
  install_resource "../../../Classes/Resource/valenciaMap.png"
  install_resource "../../../Classes/Resource/vignetteMap.png"
  install_resource "../../../Classes/Resource/waldenMap.png"
  install_resource "../../../Classes/Resource/xproMap.png"
  install_resource "../../../Classes/Resource/clarendon-curve.acv"
  install_resource "../../../Classes/Resource/crema-curve.acv"
  install_resource "../../../Classes/Resource/fresh.acv"
  install_resource "../../../Classes/Resource/gray-curve.acv"
  install_resource "../../../Classes/Resource/gringham-curve.acv"
  install_resource "../../../Classes/Resource/lark-curve.acv"
  install_resource "../../../Classes/Resource/metalic-curve.acv"
  install_resource "../../../Classes/Resource/nashville-curve.acv"
  install_resource "../../../Classes/Resource/old-fashion.acv"
  install_resource "../../../Classes/Resource/sierra-curve.acv"
  install_resource "GPUImage/framework/Resources/lookup.png"
  install_resource "GPUImage/framework/Resources/lookup_amatorka.png"
  install_resource "GPUImage/framework/Resources/lookup_miss_etikate.png"
  install_resource "GPUImage/framework/Resources/lookup_soft_elegance_1.png"
  install_resource "GPUImage/framework/Resources/lookup_soft_elegance_2.png"
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "$XCASSET_FILES" ]
then
  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "${PODS_ROOT}*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
