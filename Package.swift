// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SearchAndSort",
    platforms: [.iOS(.v17), .macOS(.v12)],
    
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SearchAndSort",
            targets: ["SearchAndSort"]),
        
            
    ],
    dependencies: [.package(url: "https://github.com/mohammad-nej/MyLogger", .upToNextMajor(from: "1.0.0")),],
        targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SearchAndSort" , dependencies: ["MyLogger"]
          //  ,swiftSettings: [.enableUpcomingFeature("InferSendableFromCaptures")]
        ),
        .testTarget(
            name: "SearchAndSortTests",
            dependencies: ["SearchAndSort"]
          //  ,swiftSettings: [.enableUpcomingFeature("InferSendableFromCaptures")]
        )
        
    ]
    
)
