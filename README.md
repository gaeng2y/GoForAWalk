 # 👟 걷는

산책과 운동을 즐기는 사람들을 위한 iOS 앱입니다.

## 🏗️ 아키텍처

이 프로젝트는 **Tuist**를 활용한 모듈화 아키텍처와 **SwiftUI + TCA(The Composable Architecture)**를 기반으로 개발되었습니다.

### 모듈 구조

```
📦 GoForAWalk
├── 🔄 Shared
│   └── Extension
├── ⚙️ Core  
│   ├── Network
│   └── KeychainStore
├── 🎯 Domain
│   ├── AuthService
│   ├── FeedService
│   └── UserService
└── 🎨 Feature
    ├── SignInFeature
    ├── FeedFeature
    └── ProfileFeature
```

### 레이어 설명

#### 🔄 Shared
모든 레이어에서 공용으로 재사용되는 모듈들이 위치합니다.
- **Extension**: 공통 확장 기능

#### ⚙️ Core
앱의 비즈니스 로직을 포함하지 않는 순수 기능성 모듈들이 위치합니다.
- **Network**: 네트워킹 관련 기능
- **KeychainStore**: 키체인 저장소 관리

#### 🎯 Domain
도메인 로직이 진행되는 레이어로, 비즈니스 서비스들이 위치합니다.
- **AuthService**: 인증 관련 비즈니스 로직
- **FeedService**: 피드 관련 비즈니스 로직
- **UserService**: 사용자 관련 비즈니스 로직

#### 🎨 Feature
사용자의 액션을 처리하고 데이터를 보여주는, 사용자와 직접 맞닿는 레이어입니다.
- **SignInFeature**: 로그인 화면 및 기능
- **FeedFeature**: 피드 화면 및 기능
- **ProfileFeature**: 프로필 화면 및 기능

## 🛠️ 기술 스택

- **Language**: Swift
- **UI Framework**: SwiftUI
- **Architecture**: TCA (The Composable Architecture)
- **Modularization**: Tuist
- **Dependency Management**: Tuist

## 🚀 시작하기

### 요구사항

- **Xcode**: 16.0+
- **iOS**: 18.0+
- **Tuist**: 설치 필요

## 📋 사용 가능한 명령어

### 기본 명령어

| 명령어 | 설명 |
|--------|------|
| `make init` | 프로젝트 이름과 organization을 입력하여 프로젝트 기본 세팅 |
| `make signing` | 프로젝트 Team Signing |
| `make generate` | 외부 디펜던시 fetch 및 프로젝트 generate |
| `make clean` | 전체 xcodeproj, xcworkspace 파일 삭제 |
| `make reset` | tuist clean 후, 전체 xcodeproj, xcworkspace 파일 삭제 |

### 개발 도구

| 명령어 | 설명 |
|--------|------|
| `make module` | 새로운 모듈 생성 |
| `make dependency` | 디펜던시 추가 |

### CI/CD 명령어

| 명령어 | 설명 |
|--------|------|
| `make ci_generate` | CI용 프로젝트 generate (SwiftLint 제외) |
| `make cd_generate` | CD용 프로젝트 generate (SwiftLint 제외) |

## 📝 개발 가이드라인

### TCA 패턴 사용

모든 Feature 모듈은 TCA(The Composable Architecture) 패턴을 따릅니다:

- **State**: 화면의 상태
- **Action**: 사용자 액션 및 시스템 이벤트
- **Reducer**: 상태 변경 로직
- **Environment**: 외부 의존성

### 모듈 간 의존성

- 상위 레이어는 하위 레이어에만 의존할 수 있습니다
- 같은 레이어 내 모듈 간 의존성은 최소화합니다
- Core 레이어는 비즈니스 로직을 포함하지 않습니다

---

## 📞 문의

프로젝트에 대한 질문이나 제안사항이 있으시면 Issues를 통해 연락해주세요.
