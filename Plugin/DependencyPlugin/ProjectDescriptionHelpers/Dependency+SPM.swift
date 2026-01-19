import ProjectDescription

public extension TargetDependency {
    struct SPM {}
}

public extension TargetDependency.SPM {
    static let tca = TargetDependency.external(name: "ComposableArchitecture")
    static let kakaoCommon = TargetDependency.external(name:"KakaoSDKCommon")
    static let kakaoAuth = TargetDependency.external(name:"KakaoSDKAuth")
    static let kakaoUser = TargetDependency.external(name:"KakaoSDKUser")
    static let alamofire = TargetDependency.external(name: "Alamofire")
    static let firebaseAnalytics = TargetDependency.external(name: "FirebaseAnalytics")
    static let firebaseCrashlytics = TargetDependency.external(name: "FirebaseCrashlytics")
}

public extension Package {
}
