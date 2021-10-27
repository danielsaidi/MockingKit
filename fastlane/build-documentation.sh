#!/bin/sh

rm -rf Docs
mkdir -p Docs

xcodebuild docbuild \
    -scheme MockingKit \
    -destination generic/platform=iOS \

echo "Copying documentation archive..."

find ~/Library/Developer/Xcode/DerivedData \
    -name "MockingKit.doccarchive" \
    -exec cp -R {} Docs \;

cd Docs

echo "Compressing documentation archive..."

zip -r \
    MockingKit.doccarchive.zip \
    MockingKit.doccarchive

rm -rf MockingKit.doccarchive

cd ..
