import ProjectDescription
import ProjectDescriptionHelpers

let configurations: [CustomConfiguration] = [
    .debug(name: "Debug", settings: [String: SettingValue](), xcconfig: .relativeToRoot("Configurations/Base/Configurations/Debug.xcconfig")),
    .debug(name: "Release", settings: [String: SettingValue](), xcconfig: .relativeToRoot("Configurations/Base/Configurations/Release.xcconfig")),
]

func targets() -> [Target] {
    var targets: [Target] = []
    targets += Target.makeAppTargets(name: "App", dependencies: ["uFeatures"], testDependencies: [])
    targets += Target.makeFrameworkTargets(name: "uCore", dependencies: [], targets: Set([.framework, .tests]))    
    targets += Target.makeFrameworkTargets(name: "uFeatures", dependencies: ["uCore"], targets: Set([.framework, .tests]))    
    return targets
}

let project = Project(name: "GiphyProj",
                      organizationName: "jhoney.lopes",
                      packages: [],
                      settings: Settings(configurations: configurations),
                      targets: targets())
