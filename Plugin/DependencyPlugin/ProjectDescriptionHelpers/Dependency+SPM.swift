import ProjectDescription

public extension TargetDependency {
    struct SPM {}
}

public extension TargetDependency.SPM {
    static let tca = TargetDependency.external(name: "ComposableArchitecture")
    static let kakaoCommon = TargetDependency.external(name:"KakaoSDKCommon")
    static let kakaoAuth = TargetDependency.external(name:"KakaoSDKAuth")
    static let kakaoUser = TargetDependency.external(name:"KakaoSDKUser")
}

public extension Package {
}
