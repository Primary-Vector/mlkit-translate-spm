# MLKit Translate SPM

Swift Package Manager wrapper for [Google ML Kit Translate](https://developers.google.com/ml-kit/language/translation) on iOS.

Google distributes ML Kit via CocoaPods only. This package repackages the pre-built binary frameworks as xcframeworks and pulls source dependencies from their official SPM-compatible repos, so you can use ML Kit Translate without CocoaPods.

## Versions

| Framework | Version |
|-----------|---------|
| MLKitTranslate | 8.0.0 |
| MLKitCommon | 14.0.0 |
| MLKitNaturalLanguage | 10.0.0 |

## Installation

Add to your Xcode project: File > Add Package Dependencies

```
https://github.com/Primary-Vector/mlkit-translate-spm.git
```

Or add to `Package.swift`:

```swift
.package(url: "https://github.com/Primary-Vector/mlkit-translate-spm.git", from: "8.0.0")
```

Then add `MLKitTranslateSPM` as a dependency of your target.

## Usage

```swift
import MLKitTranslate

let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .spanish)
let translator = Translator.translator(options: options)
```

The API is identical to the CocoaPods version. See [ML Kit Translate docs](https://developers.google.com/ml-kit/language/translation/ios).

## Updating

When Google releases a new version of ML Kit Translate:

1. Create a throwaway project with a Podfile referencing the new version
2. Run `pod install` to fetch the updated frameworks
3. Convert `.framework` to `.xcframework`:
   ```bash
   for fw in MLKitTranslate MLKitCommon MLKitNaturalLanguage; do
     mkdir -p ${fw}-arm64 ${fw}-x86_64
     lipo "Pods/${fw}/Frameworks/${fw}.framework/${fw}" -thin arm64 -output "${fw}-arm64/${fw}"
     lipo "Pods/${fw}/Frameworks/${fw}.framework/${fw}" -thin x86_64 -output "${fw}-x86_64/${fw}"

     for arch in arm64 x86_64; do
       mkdir -p "${fw}-${arch}/${fw}.framework/Headers" "${fw}-${arch}/${fw}.framework/Modules"
       mv "${fw}-${arch}/${fw}" "${fw}-${arch}/${fw}.framework/"
       cp -r "Pods/${fw}/Frameworks/${fw}.framework/Headers/"* "${fw}-${arch}/${fw}.framework/Headers/" 2>/dev/null
       cp -r "Pods/${fw}/Frameworks/${fw}.framework/Modules/"* "${fw}-${arch}/${fw}.framework/Modules/" 2>/dev/null
       cp "Pods/${fw}/Frameworks/${fw}.framework/Info.plist" "${fw}-${arch}/${fw}.framework/" 2>/dev/null
       find "Pods/${fw}/Frameworks/${fw}.framework" -name "*.bundle" -exec cp -r {} "${fw}-${arch}/${fw}.framework/" \; 2>/dev/null
       cp "Pods/${fw}/Frameworks/${fw}.framework/PrivacyInfo.xcprivacy" "${fw}-${arch}/${fw}.framework/" 2>/dev/null
     done

     xcodebuild -create-xcframework \
       -framework "${fw}-arm64/${fw}.framework" \
       -framework "${fw}-x86_64/${fw}.framework" \
       -output "${fw}.xcframework"

     zip -ry "${fw}.xcframework.zip" "${fw}.xcframework"
     echo "${fw}: $(shasum -a 256 ${fw}.xcframework.zip)"
   done
   ```
4. Create a new GitHub release, upload the zips
5. Update checksums and URLs in `Package.swift`

## Dependencies

Binary (hosted as GitHub release assets):
- MLKitTranslate, MLKitCommon, MLKitNaturalLanguage

Source (resolved via SPM):
- [GoogleDataTransport](https://github.com/google/GoogleDataTransport)
- [GoogleToolboxForMac](https://github.com/google/google-toolbox-for-mac)
- [GoogleUtilities](https://github.com/google/GoogleUtilities)
- [GTMSessionFetcher](https://github.com/google/gtm-session-fetcher)
- [nanopb](https://github.com/nanopb/nanopb)
- [PromisesObjC](https://github.com/google/promises)
- [ZipArchive](https://github.com/ZipArchive/ZipArchive)

## License

The ML Kit binary frameworks are proprietary Google software, subject to the [ML Kit Terms of Service](https://developers.google.com/ml-kit/terms). This repo only repackages them for SPM distribution.
