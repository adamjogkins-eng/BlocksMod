name: Build Voidstrap Dylib

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch: # Allows manual trigger

jobs:
  build:
    runs-on: macos-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Setup Xcode
        # Ensures the latest iOS SDK is available
        run: sudo xcode-select -s /Applications/Xcode.app

      - name: Compile Optimized Dylib
        run: |
          xcrun -sdk iphoneos clang++ -dynamiclib -arch arm64 \
          -miphoneos-version-min=14.0 \
          -framework UIKit \
          -framework Foundation \
          -framework CoreGraphics \
          -framework QuartzCore \
          Optimize.mm -o Voidstrap.dylib
          
      - name: Check Build Output
        run: ls -lh Voidstrap.dylib

      - name: Upload Build Artifact
        uses: actions/upload-artifact@v4
        with:
          name: Voidstrap-Mobile-Dylib
          path: Voidstrap.dylib
