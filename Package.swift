// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CollectionViewPackage",
    platforms: [.iOS(.v14)],
    products: [
        
       .library(name: "CollectionKit",targets: ["CollectionKit"]),
       .library(name: "Resource",targets: ["Resource"]),
       .library(name: "DataStore",targets: ["DataStore"]),
       .library(name: "Networking",targets: ["Networking"]),
       .library(name: "Repository",targets: ["Repository"]),

    ],
    dependencies: [],
    targets: [
       
        .target(name: "Resource",dependencies: []),
        
        .target(name: "Networking",dependencies: []),
        
        .target(name: "DataStore",dependencies: [
            "Networking"
        ]),
        
        .target(name: "Repository",dependencies: [
            "Resource",
            "Networking",
            "DataStore",
        ]),
        
        .target(name: "CollectionKit",dependencies: [
            "Networking",
            "Repository",
            "DataStore",
            "Resource",
        ]),
        
        .testTarget(name: "CollectionViewPackageTests",dependencies: [
            "CollectionKit"
        ]),
    ]
)
