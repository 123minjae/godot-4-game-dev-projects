# Godot 4 Game Development Projects — 실습 저장소

『고도 엔진 4 게임 개발 프로젝트 제2판』(Chris Bradfield, Packt 2023 / 원제 *Godot 4 Game Development Projects, 2nd Edition*)의 예제를 따라 만들며 Godot 4를 익히는 저장소입니다.
Unity 경험을 바탕으로 Godot의 노드·시그널·물리·UI 구조를 챕터별 프로젝트로 학습하고, 각 장이 끝나면 **Playground** 단계에서 플레이하며 아쉬운 부분을 직접 고쳐 봅니다.

## 환경

| 항목 | 내용 |
|---|---|
| 엔진 | Godot 4.7.2 (책 기준은 4.0 — API 차이는 공식 문서 기준으로 수정) |
| 언어 | GDScript |
| 렌더러 | Forward+ |
| 3D 물리 | Jolt Physics (4.6부터 새 프로젝트 기본값) |
| 에셋 | 책 공식 저장소 제공 에셋 (아래 크레딧 참고) |

## 저장소 구조

레포 하나에 챕터별 Godot 프로젝트가 폴더로 들어 있습니다. 각 폴더를 Godot 프로젝트 매니저에서 **Import** 하면 바로 열립니다.

```
.
├── coin-dash/      2장 Coin Dash
├── space-rocks/    3장 Space Rocks
├── jungle-jump/    4장 Jungle Jump
├── 3d-minigolf/    5장 3D Minigolf
└── infinite-flyer/ 6장 Infinite Flyer
```

`.godot/` 캐시와 `export_presets.cfg`는 커밋하지 않고, `.import` 파일은 커밋합니다.

## 진행 현황

| 장 | 프로젝트 | 주제 | 책 구현 | Playground |
|---|---|---|---|---|
| 2 | Coin Dash | 2D 기초 — Area2D, 시그널, Tween, HUD | ✅ | ✅ |
| 3 | Space Rocks | 2D 물리 — RigidBody2D, 상태 머신, Path2D, 파티클 | ✅ | ✅ |
| 4 | Jungle Jump | 2D 플랫포머 — CharacterBody2D, TileMapLayer, 씬 전환 | ✅ | ✅ |
| 5 | 3D Minigolf | 3D 기초 — GridMap, RigidBody3D, 짐벌 카메라, 상속 씬 | ✅ | ➖ |
| 6 | Infinite Flyer | 3D 무한 러너 — CharacterBody3D 비행, 청크 무한 생성, 트라이메시 충돌, CPUParticles3D | ✅ | ✅ |

➖ 짧은 챕터라 Playground는 생략

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

**4장 Jungle Jump**
- 책의 TileMap(4.0)을 4.3+의 `TileMapLayer` 노드 여러 개로 치환해 구현
- `ScreenFade` Autoload(CanvasLayer + ColorRect + Tween)로 씬 전환 페이드
- 타이틀 화면: Parallax2D autoscroll 배경, "Press Space" 문구 SINE 알파 깜빡임
- `MovingPlatform`에 `@tool` + `_draw()`로 에디터에서 이동 범위 기즈모 표시
- 적: RayCast2D로 낭떠러지 감지, `is_on_wall()`/`get_wall_normal()`로 벽에서 방향 전환
- 공식 코드 대조 누락 수정: 마지막 레벨 뒤 `restart()`, 사망 시 `died.emit()`

**5장 3D Minigolf**
- Playground 생략. 남은 개선 후보는 조준 시작 방향, 가끔 공이 튀는 현상(GridMap 옥턴트 경계로 추정)

**6장 Infinite Flyer**
- 타이틀 화면 시작 버튼을 `grab_focus()`로 Space 입력 지원
- 청크 생성 기준선을 한 청크 앞당겨 항상 2개가 깔려 있게 (앞쪽 지형이 끊겨 보이던 문제)
- 링 점수 판정 수정 — 공식 코드는 3D 거리로 재서 비행기 길이 때문에 200점이 사실상 불가능했음. 링 평면(XY) 거리로 바꾸고, 움직이는 링은 실제 위치(`CollisionShape3D`) 기준으로 판정
- 레벨 4 이상에서 링이 레벨 0으로 돌아가던 문제를 `match`의 와일드카드(`_`) 분기로 처리 — 좌우/상하 이동 링이 반반 확률로 등장
- 가운데 건물 대신 장애물 3종 추가: 컨테이너 벽(위로 넘기), 육교+광고판(아래로 지나가기), 전봇대(좌우 회피). 링과 z 칸이 겹치지 않게 배치
- 부스트: Space로 가속(`lerpf`로 부드럽게), 부스트 중 연료 2배 소모, 꼬리 연기 파티클
- 파티클 꼬리에 점이 남던 문제 — Particle Billboard 모드에서 Keep Scale이 꺼져 있으면 비활성 입자(크기 0)가 원래 크기로 그려지는 것이 원인. Keep Scale을 켜서 해결 (엔진 소스로 확인)
- 링 개수·높이, 연료 소모량 등 밸런스 조정

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
- Jungle Jump: 사운드 by [revampedpro](http://opengameart.org/users/revampedpro)
- Infinite Flyer: 장애물 모델(컨테이너 벽·육교·전봇대)은 Claude로 생성한 로우폴리 OBJ
