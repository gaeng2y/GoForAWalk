import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.CameraService.rawValue,
    targets: [
        .interface(
            module: .domain(.CameraService),
            dependencies: [
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .implements(
            module: .domain(.CameraService),
            dependencies: [
                .domain(target: .CameraService, type: .interface),
                .core(target: .Camera, type: .interface),
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .testing(
            module: .domain(
                .CameraService
            ),
            dependencies: [
                .domain(
                    target: .CameraService,
                    type: .interface
                )
            ]
        ),
        .tests(
            module: .domain(
                .CameraService
            ),
            dependencies: [
                .domain(
                    target: .CameraService
                )
            ]
        )
    ]
)
