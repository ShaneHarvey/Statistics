import PackageDescription

let package = Package(
    name: "SwiftPerformance",
    dependencies: [
        .Package(url: "https://github.com/OpenKitten/MongoKitten.git", majorVersion: 4)
    ]
)
