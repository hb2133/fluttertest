# Tags

이 문서는 이 프로젝트의 WorkDocs 표준 태그 사전이다.

아직 실제 프로젝트 태그는 정의되지 않았다.

규칙:

- 태그는 작업 루트의 `Meta.md`에서만 사용한다.
- `Meta.md`의 `Tags` 값은 이 문서에 정의된 표준 태그 이름과 정확히 일치해야 한다.
- 이 파일에 작업 목록을 수동으로 적지 않는다.
- 작업 간 연결은 각 작업 루트의 `Meta.md`를 기준으로 조회한다.

새 태그는 아래 형식으로 추가한다.

```md
## tag_name
DisplayName: 표시 이름
Aliases: alias-a, alias-b
Description: 이 태그가 담당하는 작업 영역
```

## todo_desktop
DisplayName: Todo Desktop
Aliases: todo, task-manager
Description: Todo Desktop 앱의 기획, 화면, 상태 관리 및 로컬 저장 기능

## flutter_desktop
DisplayName: Flutter Desktop
Aliases: desktop, flutter
Description: Flutter 기반 데스크톱 앱 구현과 플랫폼 UX 작업
