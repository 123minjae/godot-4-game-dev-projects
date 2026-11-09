# Godot 4 Game Development Projects — 실습 저장소

『고도 엔진 4 게임 개발 프로젝트 제2판』(Chris Bradfield, Packt 2023 / 원제 *Godot 4 Game Development Projects, 2nd Edition*)의 예제를 따라 만들며 Godot 4를 익히는 저장소입니다.
Unity 경험을 바탕으로 Godot의 노드·시그널·물리·UI 구조를 챕터별 프로젝트로 학습하고, 각 장이 끝나면 **Playground** 단계에서 플레이하며 아쉬운 부분을 직접 고쳐 봅니다.

## 환경

| 항목 | 내용 |
|---|---|
| 엔진 | Godot 4.7.2 (책 기준은 4.0 — API 차이는 공식 문서 기준으로 수정) |
| 언어 | GDScript |
| 렌더러 | Forward+ |
| 에셋 | 책 공식 저장소 제공 에셋 (아래 크레딧 참고) |

## 저장소 구조

레포 하나에 챕터별 Godot 프로젝트가 폴더로 들어 있습니다. 각 폴더를 Godot 프로젝트 매니저에서 **Import** 하면 바로 열립니다.

```
.
├── coin-dash/      2장 Coin Dash
├── space-rocks/    3장 Space Rocks
└── (이후 챕터 추가 예정)
```

`.godot/` 캐시와 `export_presets.cfg`는 커밋하지 않고, `.import` 파일은 커밋합니다.

## 진행 현황

| 장 | 프로젝트 | 주제 | 책 구현 | Playground |
|---|---|---|---|---|
| 2 | Coin Dash | 2D 기초 — Area2D, 시그널, Tween, HUD | ✅ | ✅ |
| 3 | Space Rocks | 2D 물리 — RigidBody2D, 상태 머신, Path2D, 파티클 | ✅ | ✅ |
| 4 | Jungle Jump | 2D 플랫포머 — CharacterBody2D, TileMap | ⬜ | ⬜ |
| 5 | 3D Minigolf | 3D 기초 | ⬜ | ⬜ |
| 6 | Infinite Flyer | 3D 무한 러너 | ⬜ | ⬜ |

## 작업 방식

커밋 이력을 보면 **책을 따라 만든 부분**과 **직접 추가한 부분**이 구분되도록 브랜치를 나눕니다.

- `feat/<Chapter_Name>` — 책 내용을 소제목 단위로 커밋하며 구현. 챕터가 끝나면 PR로 `main`에 머지하고, 공식 예제 코드와 diff를 돌려 누락을 확인합니다.
- `feat/<Chapter_Name>_Playground` — 완성본을 플레이하며 거슬리는 부분, 책이 다루지 않은 기능, 공식 코드 대조에서 나온 수정 사항을 반영. 역시 PR로 `main`에 머지합니다.
- `main`에는 직접 커밋하지 않습니다.

### 챕터별 Playground에서 추가한 것

**2장 Coin Dash**
- 입력 액션(`move_*`)으로 WASD + 화살표 동시 지원
- `grab_focus()`로 시작 버튼을 키보드(Space)로 누를 수 있게
- 레벨 클리어 시 HUD 타이머 즉시 갱신, `new_game()`에서 HUD 초기화 보강

**3장 Space Rocks**
- 일시정지 버그 수정 — 책 설정(Main = Always)은 자식 전체에 상속되어 적·타이머가 안 멈추던 것을, Main은 Pausable / HUD만 Always로 뒤집고 P키 입력을 HUD 시그널로 Main에 전달하도록 변경
- 무적 상태에서 회전이 안 되던 문제 — 콜라이더 비활성화 시 관성(Inertia)이 0이 되는 것이 원인. 자동 계산값(452)을 명시해 해결
- 레벨업 시 목숨 +1 (최대 3). `set_lives` 세터가 증가/감소를 구분하도록 해 목숨이 늘 때는 무적이 걸리지 않게
- 새 게임 시작 시 남아 있던 적·총알 제거, EnemyTimer 정지
- 총알이 적을 관통하던 것 수정 (`_on_area_entered`에 `queue_free()` 누락)
- 적이 화면 밖에 있을 때는 사격하지 않도록 `VisibleOnScreenNotifier2D` 추가
- 적·플레이어가 스폰 직후 (0,0)에 한 프레임 보이던 것 수정
- 시작 화면에서 우주선 숨김, 시작 시 실드 초기화
- 플레이어 화면 wrap에 반지름 여유 추가
- 엔진음 루프 설정(Loop + 오프셋), 클리핑 방지를 위해 볼륨 조정. 루프 접합부의 미세한 끊김은 에셋 꼬리 페이드아웃이 원인으로 확인했으나 에셋 수정은 범위 밖으로 두고 마무리

## 실행

1. Godot 4.7 이상 설치
2. 프로젝트 매니저 → **Import** → 원하는 챕터 폴더의 `project.godot` 선택
3. F5로 실행

## 참고 자료

- 책 공식 예제 코드: https://github.com/PacktPublishing/Godot-4-Game-Development-Projects-Second-Edition (정오표 `ERRATA.md` 포함)
- Godot 공식 문서: https://docs.godotengine.org/en/stable/

## 크레딧

게임 에셋은 책 공식 저장소에서 제공하는 것을 사용했습니다. 각 프로젝트의 `assets/attributions.txt`에 원작자 표기가 있습니다.
- Space Rocks: *Flying Saucers* by [surt](https://opengameart.org/users/surt), *Funky Gameplay* by Eric Matyas ([soundimage.org](https://soundimage.org))
