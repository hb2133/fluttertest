# Task

## Context
- Todo Desktop의 첫 실행 가능한 MVP를 기획하고 구현한다.

## Current Understanding
- route 하나의 `TodoBasePanel`을 사용한다.
- 탐색, 도구 모음, 목록, 상세 편집을 각각 Section으로 분리한다.
- 상태 전이는 `TodoController`, 파일 저장은 Panel Action이 담당한다.

## Observed Issues
- 기존 저장소에는 bootstrap 파일의 미커밋 변경이 있으므로 이를 보존한다.

## Decision Notes
- 첫 버전은 외부 패키지를 추가하지 않고 OS별 사용자 데이터 폴더의 JSON 파일을 사용한다.
- 마감일과 알림은 시간대 및 OS 권한 복잡도를 줄이기 위해 후속 버전으로 미룬다.

## Implementation Notes
- `TodoPanel`과 navigation, toolbar, list, editor Section을 구현했다.
- `TodoController`가 생성, 수정, 삭제, 완료, 필터, 검색 상태 전이를 담당한다.
- `TodoStorageAction`이 OS별 사용자 데이터 경로에 JSON을 저장한다.
- 1024dp 미만에서는 탐색 영역을 숨겨 편집 공간을 확보한다.
- `Ctrl+N` 단축키와 삭제 2단계 확인을 제공한다.

## Result
- `flutter analyze`: 통과
- `flutter test`: 2개 테스트 통과
- `flutter build windows --release`: 통과
- 산출물: `build/windows/x64/runner/Release/fluttertest.exe`

## History Index
- 아직 분리된 이력이 없다.
