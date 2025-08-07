import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Core.Camera.rawValue,
    targets: [
        .interface(
            module: .core(
                .Camera
            )
        ),
        .implements(
            module: .core(
                .Camera
            ),
            dependencies: [
                .core(
                    target: .Camera,
                    type: .interface
                )
            ]
        ),
        .testing(
            module: .core(
                .Camera
            ),
            dependencies: [
                .core(
                    target: .Camera,
                    type: .interface
                )
            ]
        ),
        .tests(
            module: .core(
                .Camera
            ),
            dependencies: [
                .core(
                    target: .Camera
                )
            ]
        )
    ]
)
