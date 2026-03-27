// swift-tools-version: 5.9
import PackageDescription

/// SPM wrapper for Google ML Kit Translate.
///
/// The three MLKit frameworks are pre-built binaries distributed as
/// xcframework archives via GitHub Releases. Source dependencies
/// (GoogleToolboxForMac, GoogleUtilities, etc.) are pulled from their
/// official SPM-compatible repositories.
///
/// To update the MLKit binaries:
///   1. Run `pod install` in a throwaway project to fetch new versions
///   2. Convert .framework → .xcframework (see scripts/)
///   3. Zip, upload to a new GitHub Release, update checksums below
let package = Package(
    name: "MLKitTranslateSPM",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "MLKitTranslateSPM",
            targets: ["MLKitTranslateSPMTarget"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/google/GoogleDataTransport.git", from: "10.1.0"),
        .package(url: "https://github.com/google/GoogleUtilities.git", from: "8.1.0"),
        .package(url: "https://github.com/google/gtm-session-fetcher.git", from: "3.5.0"),
        .package(url: "https://github.com/firebase/nanopb.git", "2.30910.0"..<"2.30911.0"),
        .package(url: "https://github.com/google/promises.git", from: "2.4.0"),
        .package(url: "https://github.com/ZipArchive/ZipArchive.git", from: "2.6.0"),
    ],
    targets: [
        // Umbrella target that links everything together
        .target(
            name: "MLKitTranslateSPMTarget",
            dependencies: [
                "MLKitTranslate",
                "MLKitCommon",
                "MLKitNaturalLanguage",
                .product(name: "GoogleDataTransport", package: "GoogleDataTransport"),
                .product(name: "GULEnvironment", package: "GoogleUtilities"),
                .product(name: "GULLogger", package: "GoogleUtilities"),
                .product(name: "GULUserDefaults", package: "GoogleUtilities"),
                .product(name: "GTMSessionFetcherCore", package: "gtm-session-fetcher"),
                .product(name: "nanopb", package: "nanopb"),
                .product(name: "FBLPromises", package: "promises"),
                .product(name: "ZipArchive", package: "ZipArchive"),
            ],
            path: "Sources"
        ),
        // Binary targets — hosted as GitHub Release assets
        .binaryTarget(
            name: "MLKitTranslate",
            url: "https://github.com/Primary-Vector/mlkit-translate-spm/releases/download/8.0.0/MLKitTranslate.xcframework.zip",
            checksum: "540ebc74febf1129cc445832fe4f5c41ac89e828165a15c7f656c4d3111af50b"
        ),
        .binaryTarget(
            name: "MLKitCommon",
            url: "https://github.com/Primary-Vector/mlkit-translate-spm/releases/download/8.0.0/MLKitCommon.xcframework.zip",
            checksum: "e8fbb5d9abe5669b5d02aee68ba0f7d2906dd181a3456f948cbc53382bb24c40"
        ),
        .binaryTarget(
            name: "MLKitNaturalLanguage",
            url: "https://github.com/Primary-Vector/mlkit-translate-spm/releases/download/8.0.0/MLKitNaturalLanguage.xcframework.zip",
            checksum: "0e6aec4b458b1fbedebd1901d1f7a0a09680a037cf9219f1e5117e0f8160bd55"
        ),
    ]
)
