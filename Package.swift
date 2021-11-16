// swift-tools-version:5.5
//===----------------------------------------------------------------------===//
//
// This source file is part of the OneRoster open source project
//
// Copyright (c) 2021 the OneRoster project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import PackageDescription

let package = Package(
    name: "OneRoster",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .library(name: "OneRoster", targets: ["OneRoster"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.52.1"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "OneRoster", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Logging", package: "swift-log"),
        ]),
        .testTarget(name: "OneRosterTests", dependencies: [
            .target(name: "OneRoster"),
            .product(name: "XCTVapor", package: "vapor"),
        ]),
    ]
)
