// swift-tools-version: 5.9
import PackageDescription

/// SPM wrapper for Google ML Kit Translate.
///
/// The three MLKit frameworks are pre-built binaries distributed as
/// xcframework archives via GitHub Releases. Source dependencies
/// are pulled from official repos or vendored (GoogleToolboxForMac).
///
/// GoogleToolboxForMac is vendored because upstream v6's GTMDefines
/// target is broken in Xcode (headers-only ObjC target produces no .o).
let package = Package(
    name: "MLKitTranslateSPM",
    platforms: [.iOS(.v18)],
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
                "GTMLogger",
                "GTMNSData_zlib",
                "GTMStringEncoding",
                .product(name: "GoogleDataTransport", package: "GoogleDataTransport"),
                .product(name: "GULEnvironment", package: "GoogleUtilities"),
                .product(name: "GULLogger", package: "GoogleUtilities"),
                .product(name: "GULUserDefaults", package: "GoogleUtilities"),
                .product(name: "GTMSessionFetcherCore", package: "gtm-session-fetcher"),
                .product(name: "nanopb", package: "nanopb"),
                .product(name: "FBLPromises", package: "promises"),
                .product(name: "ZipArchive", package: "ZipArchive"),
            ],
            path: "Sources",
            resources: [
                .copy("MLKitTranslate_resource.bundle"),
            ]
        ),
        // Vendored GoogleToolboxForMac (upstream v6 SPM is broken in Xcode)
        .target(
            name: "GTMDefines",
            path: "VendoredSources/GTM/Defines",
            publicHeadersPath: "Public"
        ),
        .target(
            name: "GTMLogger",
            dependencies: ["GTMDefines"],
            path: "VendoredSources/GTM/Logger",
            exclude: ["GTMLogger+ASL.m", "GTMLoggerRingBufferWriter.m", "Resources"],
            publicHeadersPath: "Public/Foundation"
        ),
        .target(
            name: "GTMNSData_zlib",
            dependencies: ["GTMDefines"],
            path: "VendoredSources/GTM/NSData_zlib",
            publicHeadersPath: "Public/Foundation",
            linkerSettings: [.linkedLibrary("z")]
        ),
        .target(
            name: "GTMStringEncoding",
            dependencies: ["GTMDefines"],
            path: "VendoredSources/GTM/StringEncoding",
            publicHeadersPath: "Public/Foundation"
        ),
        // Binary targets — hosted as GitHub Release assets
        .binaryTarget(
            name: "MLKitTranslate",
            url: "https://github.com/Primary-Vector/mlkit-translate-spm/releases/download/8.0.4/MLKitTranslate.xcframework.zip",
            checksum: "651de5eae436f6a688a7485df45a64ba21e424042ff713b8d06003deeef94975"
        ),
        .binaryTarget(
            name: "MLKitCommon",
            url: "https://github.com/Primary-Vector/mlkit-translate-spm/releases/download/8.0.4/MLKitCommon.xcframework.zip",
            checksum: "f90d1568131acdf4942d81fd8e4532b0d578bc4816ce0abec11e03a125474a24"
        ),
        .binaryTarget(
            name: "MLKitNaturalLanguage",
            url: "https://github.com/Primary-Vector/mlkit-translate-spm/releases/download/8.0.4/MLKitNaturalLanguage.xcframework.zip",
            checksum: "6656ffd6af88c49c1f6c7b7792ea0c0d90fdbddd9fb4979aa069fda27df910ea"
        ),
    ]
)
