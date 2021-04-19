#!/bin/bash
set -eo pipefail
rm -Rf /tmp/GoogleDriv* >/dev/null

echo "Downloading Google Drive..."
curl -o /tmp/GoogleDrive.dmg https://dl.google.com/drive-file-stream/GoogleDrive.dmg

echo "Mounting DMG"
hdiutil detach /Volumes/Install\ Google\ Drive/ 2>/dev/null || true
hdiutil attach /tmp/GoogleDrive.dmg 

echo "Extracting Package"
pkgutil --expand /Volumes/Install\ Google\ Drive/GoogleDrive.pkg /tmp/GoogleDrive

echo "Replacing search string with AMD cpu"
sed -i '' "s/includes('intel')/includes('amd')/" /tmp/GoogleDrive/Distribution

echo "Flattening Package as GoogleDrive-AMD.pkg"
pkgutil --flatten /tmp/GoogleDrive /tmp/GoogleDrive-AMD.pkg

echo "Unmounting DMG"
hdiutil detach /Volumes/Install\ Google\ Drive/

echo "Installing modified Package"
sudo installer -verbose -pkg /tmp/GoogleDrive-AMD.pkg -target /

echo "Cleaning up"
rm -Rf /tmp/GoogleDriv*

echo "Done"