# GoForAWalk Project Instructions

## TCA Architecture Discussion

This project uses The Composable Architecture (TCA) with Tuist for modular architecture.

When answering questions about architecture, design patterns, or implementation decisions, always reference and follow the panel discussion format defined in:

@.claude/tca_prompt.txt

This prompt simulates a panel discussion between:
- **Brandon** (TCA Expert): The Composable Architecture, Point-Free style, state management, reducers, effects, dependency injection
- **Chris** (Swift Expert): Swift language, type system, compiler, ABI, performance, concurrency
- **Pedro** (Tuist Expert): Modular architecture, Xcode project management, build systems, CI pipelines

## Project Structure

- **Tuist-based modular architecture**
- **TCA for state management**
- **Interface/Sources separation pattern** for feature modules
- **Swift 6 with Strict Concurrency Checking**

## Key Conventions

### Feature Module Pattern
```
Projects/Feature/[FeatureName]/
├── Interface/
│   ├── [FeatureName].swift      # Protocol/Interface definition
│   └── [FeatureName]View.swift  # SwiftUI View
├── Sources/
│   └── [FeatureName].swift      # Live implementation
└── Project.swift
```

### TCA Reducer Pattern
```swift
@Reducer
public struct SomeFeature: @unchecked Sendable {
    @ObservableState
    public struct State: Equatable { ... }

    public enum Action {
        case someAction
        case delegate(Delegate)

        public enum Delegate { ... }
    }

    let reduce: (inout State, Action) -> Effect<Action>

    public init(reduce: @escaping (inout State, Action) -> Effect<Action>) {
        self.reduce = reduce
    }

    public var body: some ReducerOf<Self> {
        Reduce(reduce)
    }
}

// Live implementation in Sources/
extension SomeFeature {
    static func live(client: SomeClient) -> Self {
        Self { state, action in
            // Implementation
        }
    }
}
```

### Dependency Injection
- All features are registered in `DependencyInjection` module
- Use `@Dependency` for injecting clients and child features
- Follow the `DependencyKey` pattern for registration

## Swift 6 Concurrency

- Use `@unchecked Sendable` for TCA Features (they manage their own thread safety)
- Use `nonisolated(unsafe)` for static properties with non-Sendable types
- Use `SendableWrapper` pattern for capturing closures in Tasks
- Wrap UI operations in `MainActor.run { }` when needed
