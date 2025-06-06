# 🍜 NoodleTimer - 라면 타이머 앱
> **팀 정보**: 개인 프로젝트
> 
>**프로젝트 기간**: 2025.04 ~ 2025.05 (4주)
> 

## 🍜 서비스 소개

사용자가 라면을 끓일 때 필요한 정확한 조리 시간을 자동으로 설정해주는 Flutter 앱입니다. 

선택한 라면에 맞는 최적의 조리 시간이 설정되며, 타이머가 종료되면 알림을 통해 조리 완료를 알려줍니다. 

이 앱을 통해 매번 라면 끓이기 시간을 걱정할 필요 없이, 간편하고 정확하게 라면을 완성할 수 있습니다.

## 🍜 주요 기능
- **맞춤 타이머**: 라면별 최적화된 조리 시간 제공
- **한글 초성 검색**: 한글 초성 추출로 빠른 라면 검색 (ㅅㄹㅁ → 신라면)
- **조리 기록 관리**: Firebase 기반 CRUD 및 조리 내역 재실행 기능
- **인증 시스템**: Firebase Auth 기반 회원가입/로그인/로그아웃/계정삭제
- **실시간 데이터 동기화**: Firestore 기반 실시간 데이터 연동
  
|스플래시+회원가입 | 로그인+온보딩 | 홈+타이머 |
|---|---|---|
| <img src="https://github.com/user-attachments/assets/5a03b405-c6e3-494c-b74e-ee4ba9251fc4" width="280" height="520"> | <img src="https://github.com/user-attachments/assets/d346f492-33e4-4dfb-bc1e-0781fcf91c0c" width="280" height="520"> | <img src="https://github.com/user-attachments/assets/85ac16b3-c4b4-47f8-8216-b56e02700fd0" width="280" height="520"> |

| 검색+상세정보 | 조리내역+재실행 | 조리내역+삭제 |
|---|---|---|
| <img src="https://github.com/user-attachments/assets/0e8bb458-cb5f-42fc-a5fc-4cb92bf6511f" width="280" height="520"> | <img src="https://github.com/user-attachments/assets/c6fd2c16-83d3-482b-99eb-bf0e45d67e53" width="280" height="520"> | <img src="https://github.com/user-attachments/assets/46a64b0d-a9ed-4592-9b14-043a5f3f8a91" width="280" height="520"> |

## 🍜 개발 환경 및 라이브러리

| 분야 | 기술 | 버전 | 사용 목적 |
| --- | --- | --- | --- |
| **Frontend** | Flutter | 3.24.0 | 크로스 플랫폼 UI 프레임워크 |
|  | Dart | 3.7.2 | 애플리케이션 개발 언어 |
| **Backend** | Firebase Auth | 4.17.3 | 사용자 인증 및 계정 관리 |
|  | Cloud Firestore | 4.17.5 | 실시간 NoSQL 데이터베이스 |
| **State Management** | Riverpod | 2.5.1 | 상태 관리 및 의존성 주입 |
|  | Shared Preferences | 2.5.3 | 로컬 설정 저장 |
| **Utility** | Intl | 0.18.1 | 국제화 및 날짜 포맷팅 |
| **Testing** | Flutter Test | - | 단위 테스트 프레임워크 |
|  | Mockito | 5.0.16 | 의존성 모킹 |

## 🍜 프레임워크 및 아키텍처

> **Clean Architecture**

- **Data Layer**: Repository 구현체, DTO, 외부 데이터 소스 연동
- **Domain Layer**: 비즈니스 로직, Entity, UseCase, Repository 인터페이스
- **Presentation Layer**: UI 로직, ViewModel, State 관리

> **MVVM + Riverpod**

- Presentation, Domain, Data 전반의 상태 관리를 Riverpod으로 구현
- ViewModel에서 바뀌는 데이터에 따라 UI가 반응하도록 Reactive Programming 구현
- 의존성 주입을 통한 테스트 가능한 코드 작성

> **프로젝트 구조**

```
lib/
├── core/                # 핵심 설정
│   ├── di/              # 의존성 주입
│   ├── exceptions/      # 예외 처리
│   └── logger/          # 로그 시스템
|
├── data/                # 데이터 계층
│   ├── repository/      # Repository 구현체
│   ├── dto/             # 데이터 전송 객체
│   └── utils/           # 데이터 유틸리티
|
├── domain/              # 도메인 계층
│   ├── entity/          # 엔티티
│   ├── repository/      # Repository 인터페이스
│   └── usecase/         # UseCase
|
└── presentation/        # 프레젠테이션 계층
    ├── screen/          # 화면 UI
    ├── viewmodel/       # 상태 관리
    ├── state/           # 상태 클래스
    └── widget/          # 재사용 컴포넌트
```

---
## 🍜 개발 과정에서 해결한 문제들

> **Firestore 문서 삭제 불일치 해결**

**문제**: UI에서는 삭제되지만 Firestore에는 데이터가 남아있어 앱 재실행 시 다시 나타나는 현상

**원인**: `ramenId`(라면 고유 ID)와 `documentId`(Firestore 문서 ID)를 혼용하여 잘못된 ID로 삭제 시도

**해결**: CookHistoryEntity에 실제 Firestore 문서 ID 필드 추가 및 삭제 로직 수정

```dart
class CookHistoryEntity {
  final String? id;  // Firestore documentId 추가
  final int ramenId; // 라면 고유 ID와 분리
}

// Before: 잘못된 ID 사용
await _db.collection('users').doc(uid).collection('cookHistories')
    .doc(ramenId) // 라면 ID를 문서 ID로 잘못 사용
    .delete();

// After: 실제 문서 ID 사용
await _db.collection('users').doc(uid).collection('cookHistories')
    .doc(historyId) // 실제 Firestore 문서 ID 사용
    .delete();
```

**결과**: 데이터 일관성 확보, 조리내역 삭제 기능 정상 작동

---

> **이미지 로딩 뒤섞임 현상 해결**

**문제**: 브랜드 탭 변경 시 이전 브랜드의 이미지가 잠깐 보이는 시각적 혼란 발생

**원인**: Flutter 위젯 재사용 메커니즘으로 인해 동일한 StatefulWidget 인스턴스에서 다른 데이터 표시

**해결**: ValueKey를 활용하여 각 라면별 고유한 위젯 인스턴스 생성

```dart
// Before: 위젯 재사용으로 인한 문제
return RamenCard(ramen: ramen);

// After: 고유 키로 위젯 분리
return RamenCard(
  key: ValueKey('ramen_${ramen.id}'),  // 라면별 고유 키 설정
  ramen: ramen,
);
```

**결과**: 브랜드 변경 시 부드러운 UI 전환, 이미지 뒤섞임 문제 해결

---

> **StateNotifier dispose 후 예외 해결**

**문제**: 온보딩 화면에서 면발 취향 선택 후 `Bad state: Tried to use NoodlePreferenceViewModel after 'dispose' was called` 예외 발생

**원인**: 비동기 Firestore 업데이트 중 화면 전환으로 StateNotifier가 dispose된 후 상태 업데이트 시도

**해결**: StateNotifier의 `mounted` 속성을 활용한 dispose 상태 체크 추가

```dart
// Before: dispose 후 상태 업데이트 시도
Future updateNoodlePreference(NoodlePreference preference) async {
  await _firestoreService.updateUserNoodlePreference(_userId, preference);
  state = state.copyWith(status: const AsyncValue.data(null)); // 예외 발생
}

// After: mounted 체크로 안전한 상태 업데이트
Future updateNoodlePreference(NoodlePreference preference) async {
  await _firestoreService.updateUserNoodlePreference(_userId, preference);
  
  if (!mounted) return; // dispose 상태 체크
  state = state.copyWith(status: const AsyncValue.data(null));
}
```

**결과**: dispose 후 상태 업데이트 예외 완전 해결, 화면 전환 시 안정적인 동작

---
