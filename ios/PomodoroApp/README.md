# PomodoroApp (SwiftUI Sample Skeleton)

이 샘플은 아래 3가지 핵심 요구사항을 충족하는 최소 구조입니다.

1. 뽀모도로 타이머
2. 세션 기록 저장
3. 저장된 기록 조회(오늘 통계 포함)

## 폴더 구조

```text
ios/PomodoroApp
├─ Domain
│  ├─ Models
│  └─ Repositories
├─ Services
└─ Presentation
   ├─ Timer
   └─ History
```

## 빠른 시작

이 저장소는 Xcode 프로젝트 파일을 포함하지 않고, 도메인/뷰모델/서비스 설계 예시를 제공합니다.
실제 앱으로 실행하려면 Xcode에서 iOS App(SwiftUI) 프로젝트를 생성한 뒤, 본 폴더의 Swift 파일들을 추가하세요.

## 개선 사항 (v2)

- RootView에서 ViewModel을 매 렌더링마다 재생성하지 않도록 `AppContainer` + `@StateObject`로 생명주기를 고정했습니다.
- 타이머가 00:00에 즉시 종료 상태로 전환되도록 `TimerEngine` 종료 타이밍을 보정했습니다.
- 세션 저장 실패를 무시하지 않고 사용자에게 오류 메시지를 노출하도록 에러 처리를 추가했습니다.

## 개선 사항 (v3)

- 저장소 기본 구현을 `JSONFileSessionRepository`로 교체해 앱 재실행 후에도 세션 기록이 유지되도록 했습니다.
- 기록 화면에 기간 필터(오늘/7일/30일)와 빈 상태 메시지를 추가했습니다.
- 기록 조회 에러를 사용자에게 보여줄 수 있도록 `HistoryViewModel`에 오류 상태를 추가했습니다.

## 개선 사항 (v4)

- 설정 탭을 추가해 집중/짧은휴식/긴휴식 시간을 앱에서 바로 조정할 수 있게 했습니다.
- `UserDefaultsSettingsStore`를 추가해 사용자 설정을 로컬에 저장하도록 했습니다.
- 저장된 설정이 `TimerViewModel`에 즉시 반영되도록 연결했습니다.
