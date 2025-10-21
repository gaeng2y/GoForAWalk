import ProjectDescription

public struct AppVersion {
    public static let marketing = "1.0.0"
    public static let build = "6"
    public static let displayName = "걷는"

    public static var infoPlist: [String: Plist.Value] {
        [
            "CFBundleShortVersionString": "\(marketing)",
            "CFBundleVersion": "\(build)"
        ]
    }

    public static var buildSettings: SettingsDictionary {
        [
            "MARKETING_VERSION": SettingValue(stringLiteral: marketing),
            "CURRENT_PROJECT_VERSION": SettingValue(stringLiteral: build)
        ]
    }
}