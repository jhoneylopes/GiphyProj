import ProjectDescription

public enum uFeatureTarget {
    case framework
    case tests    
}

extension Target {
    public static func makeAppTargets(name: String,
                                      dependencies: [String] = [],
                                      testDependencies: [String] = []) -> [Target] {

        let targetDependencies: [TargetDependency] = dependencies.map({ .target(name: $0) })
        return [
            Target(name: name,
                   platform: .iOS,
                   product: .app,
                   bundleId: "jhoney.lopes.\(name)",
                infoPlist: .file(path: "Projects/\(name)/Resources/App.plist"),
                sources: ["Projects/\(name)/Sources/**/*.swift"],
                resources: ["Projects/\(name)/Resources/**/*"],
                dependencies: targetDependencies  + [.cocoapods(path: ".")]),
            Target(name: "\(name)Tests",
                platform: .iOS,
                product: .unitTests,
                bundleId: "jhoney.lopes.\(name)Tests",
                infoPlist: .default,
                sources: ["Projects/\(name)/Tests/**/*.swift"],
                dependencies: [
                    .target(name: name),
                    .xctest,
                    ] + testDependencies.map({ .target(name: $0) })),
        ]
    }

    public static func makeFrameworkTargets(name: String,
                                            dependencies: [String] = [],
                                            testDependencies: [String] = [],
                                            targets: Set<uFeatureTarget> = Set([.framework, .tests]),
                                            sdks: [String] = [],
                                            dependsOnXCTest: Bool = false) -> [Target] {
        
        // Target dependencies
        var targetDependencies: [TargetDependency] = dependencies.map { .target(name: $0) }
        targetDependencies.append(contentsOf: sdks.map { .sdk(name: $0) })
        if dependsOnXCTest {
            targetDependencies.append(.xctest)
        }

        // Targets
        var projectTargets: [Target] = []
        if targets.contains(.framework) {
            projectTargets.append(Target(name: name,
                                         platform: .iOS,
                                         product: .framework,
                                         bundleId: "jhoney.lopes.\(name)",
                infoPlist: .default,
                sources: ["Projects/\(name)/Sources/**/*.swift"],
                dependencies: targetDependencies))
        }        
        if targets.contains(.tests) {
            projectTargets.append(Target(name: "\(name)Tests",
                platform: .iOS,
                product: .unitTests,
                bundleId: "jhoney.lopes.\(name)Tests",
                infoPlist: .default,
                sources: ["Projects/\(name)/Tests/**/*.swift"],
                dependencies: [
                    .target(name: "\(name)"),
                    .xctest,
                    ] + targetDependencies))
        }       
        return projectTargets
    }
}
