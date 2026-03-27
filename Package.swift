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
        .package(url: "https://github.com/google/google-toolbox-for-mac.git", from: "6.0.0"),
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
                .product(name: "GTMLogger", package: "google-toolbox-for-mac"),
                .product(name: "GTMNSData_zlib", package: "google-toolbox-for-mac"),
                .product(name: "GTMStringEncoding", package: "google-toolbox-for-mac"),
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
            checksum: "b7a3c9923d591bdc4ea49bec5b0e4a4f8d21e9fe0b2e18fcd3ef0f77f68d0b77"
        ),
        .binaryTarget(
            name: "MLKitCommon",
            url: "https://github.com/Primary-Vector/mlkit-translate-spm/releases/download/8.0.0/MLKitCommon.xcframework.zip",
            checksum: "485dd882b2d4d15d4c82cf4ece8b8a1cf4713a2af8f2cfd25eee771987891f9e"
        ),
        .binaryTarget(
            name: "MLKitNaturalLanguage",
            url: "https://github.com/Primary-Vector/mlkit-translate-spm/releases/download/8.0.0/MLKitNaturalLanguage.xcframework.zip",
            checksum: "ede7bcdbcea2cb9cfb44cb791a2ec3f1a859a4dfdaa3f044c38fe41178d0a571"
        ),
    ]
)
