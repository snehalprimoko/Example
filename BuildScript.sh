#!/bin/sh

#  BuildScript.sh
#  Example
#


IDENTITY="iPhone Distribution: Natwar Mehta (3FV9VCGV2H)"


PROJECT="example.xcodeproj"
PRODUCT_NAME="example"
WORKSPACE_NAME=$PRODUCT_NAME
SCHEME_NAME=$PRODUCT_NAME
CONFIGURATION="Release"

sed -i '' 's/ProvisioningStyle = .*;/ProvisioningStyle = "Manual";/' ./${PROJECT}/project.pbxproj
sed -i '' 's/DEVELOPMENT_TEAM = .*;/DEVELOPMENT_TEAM = "3FV9VCGV2H";/' ./${PROJECT}/project.pbxproj
sed -i '' 's/PROVISIONING_PROFILE_SPECIFIER = .*;/PROVISIONING_PROFILE_SPECIFIER = "wc-example";/' ./${PROJECT}/project.pbxproj
sed -i '' 's/PROVISIONING_PROFILE = .*;/PROVISIONING_PROFILE = "2944897d-4a3d-446f-8e88-e04ef38c0fb0";/' ./${PROJECT}/project.pbxproj
sed -i '' 's/CODE_SIGN_IDENTITY = .*;/CODE_SIGN_IDENTITY = "iPhone Distribution: Natwar Mehta (3FV9VCGV2H)";/' ./${PROJECT}/project.pbxproj
sed -i '' 's/"CODE_SIGN_IDENTITY.*" = .*;//' ./${PROJECT}/project.pbxproj

# clean the build
/usr/bin/xcodebuild -alltargets clean
rm -rf "./build"

# build the build
/usr/bin/xcodebuild \
-workspace "${WORKSPACE_NAME}.xcworkspace" \
-configuration "${CONFIGURATION}" \
-scheme "${SCHEME_NAME}" \
-archivePath "./build/${PRODUCT_NAME}.xcarchive" \
CONFIGURATION_TEMP_DIR=./build \
CODE_SIGN_IDENTITY="${IDENTITY}" \
archive

#name ipa build accordingly
NAME=${CONFIGURATION}

#export the archive
/usr/bin/xcodebuild \
-exportArchive \
-archivePath "./build/${PRODUCT_NAME}.xcarchive" \
-quiet \
-exportPath "./build/${NAME}" \
-exportOptionsPlist "./exportOptions.plist"

function extract_bundler_version {
PLIST=$1
cat ${PLIST} | perl -ne 'if(/<key>CFBundleVersion<.key>/){$_=<STDIN>; s/<string>(.+)<// && print $1;}'
}
