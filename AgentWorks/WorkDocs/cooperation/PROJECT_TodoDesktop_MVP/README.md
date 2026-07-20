# Todo Desktop MVP

## Summary
- Flutter를 처음 사용하는 사용자가 구조와 상태 흐름을 익힐 수 있는 로컬 전용 할 일 관리 데스크톱 앱을 만든다.

## Background
- 제품명은 `Todo Desktop`이다.
- 서버, 계정, 동기화 없이 단일 사용자 로컬 앱으로 시작한다.

## Scope
- 할 일 추가, 수정, 삭제, 완료 전환
- 우선순위, 메모, 검색, 상태 필터
- 로컬 JSON 저장과 재실행 시 복원
- 960x640 이상을 기준으로 한 데스크톱 반응형 UI

## References
- `AgentWorks/docs/project-rules/architecture/`
- `AgentWorks/docs/project-rules/platform/FLUTTER_PLATFORM_PROFILE_DESKTOP_V2.md`

## Current Status
- MVP 구현 완료. 정적 분석 및 테스트 통과.
- Visual Studio C++ 데스크톱 toolchain을 설치하고 Windows release 빌드를 완료했다.
