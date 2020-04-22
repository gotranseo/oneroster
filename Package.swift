// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "OneRoster",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "OneRoster", targets: ["OneRoster"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
    ],
    targets: [
        .target(name: "OneRoster", dependencies: [
            .product(name: "Vapor", package: "vapor"),
        ]),
        .testTarget(name: "OneRosterTests", dependencies: [
            .target(name: "OneRoster")
        ])
    ]
)
