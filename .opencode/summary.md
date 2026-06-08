## Goal
- Complete Stage 5 Visual Reconstruction: transform Home, Roadmap, Challenges, and Navigation from dashboard/cards/lists into an organic, dynamic, premium adventure flow with circular nodes, zigzag connections, minimal status strip, emoji-driven challenges, and cohesive visual identity.

## Constraints & Preferences
- NOT a rectangle-heavy UI: minimize boxes, borders, dividers — use circles, organic shapes, soft glow, negative space
- NOT a Duolingo clone: inspiration in clarity/flow/progression, NOT visual copying
- Premium emotional feel: SAGEN must feel alive, progressive, adventurous — not like a technical dashboard
- Performance for Moto E20 / Android 5+ / low RAM: no blur, no heavy shaders, no infinite gradient animations, no excessive particles
- Use const, RepaintBoundary, context.select, LayoutBuilder, CustomPaint where efficient
- 5-color max rotation across all stages (blue, cyan, green, purple, deep blue) — no rainbow chaos
- Circular nodes only (44dp) — no rectangular cards for lessons; chests are larger circles (38dp)
- StatusStrip: NO containers, NO capsules, NO borders — just icon + number + minimal glow
- Existing Provider architecture, theme_constants.dart, energy/streak/learning providers must remain stable
- No new features, no feature creep — this is visual/UX reconstruction of existing functionality
- NavigationShell icons must be `_rounded` (filled), never `_outlined`; audit all screens for icon consistency
- ChallengesScreen must use real DailyChallengeProvider data, NOT hardcoded list; emojis, difficulty, visual rewards, interactivity

## Progress
### Done
- **StatusStrip** (`lib/widgets/home/status_strip.dart`): Minimal strip — streak (fire icon + number + color), gems (GemWidget 16px + number), energy (bolt icon + number). Zero containers, zero borders, zero capsule backgrounds. Streak inactive = grey, active = orange/red. Gems use diamond PNG. Energy ≤5 red, ≤20 warning, >20 blue.
- **PremiumHeader** (`lib/widgets/home/premium_header.dart`): Rewritten — removed all capsule badges. Now purely: Sage avatar (44dp, Hero tag 'sage_onboarding'), dynamic greeting (Buenos días/tardes/noches), current stage title, level indicator. Gradient background, no hard borders, no shadow boxes.
- **RoadmapWidget** (`lib/widgets/home/roadmap_widget.dart`): Complete reconstruction — circular nodes (44dp, 38dp for chests) replacing rectangular cards. Zigzag alternation (even index left, odd index right). Curved Bezier connection lines via CustomPaint (_RoadmapPainter). 5-color rotation (_nodeColors: blue, cyan, green, purple, deep blue). Compact stage headers (36dp icon circle + title + mini progress). _MiniProgress widget (28dp circular bar with percentage). Chest nodes every 5th lesson with gold gradient. Locked state with lock icon + helper text. _RoadmapPainter uses cubicTo Bezier paths from right-of-left-node to left-of-right-node through midpoint. shouldRepaint only on completedCount/stageWidth change.
- **HomeScreen** (`lib/screens/home_screen.dart`): Rewritten layout — removed _StreakDashboardCard, _EnergyDashboardCard, _StatsRow, _StatsButton entirely. Removed _DailyChallengeTile. Added StatusStrip below PremiumHeader. Added _HomeQuote (italics, streak-aware motivational phrase). Added persistent _BottomCta bar (elevated "Continuar aprendiendo" button + optional gem restore button when energy depleted). Removed old capsule-based statistics section.
- **ChallengesScreen** (`lib/screens/challenges_screen.dart`): Rebuilt — replaced hardcoded 24 _ChallengeDef list with real DailyChallengeProvider connection. Uses type emojis (_typeEmojis map), chest emojis (_chestEmojis), dynamic progress bars, difficulty-based chest colors (bronze/silver/gold), completion state with line-through + gem reward display. Header shows countdown timer until refresh and gem counter linked to ShopScreen. No more mutable _progress state — state comes from provider.
- **NavigationShell** (`lib/screens/navigation_shell.dart`): Fixed icon inconsistency — `inventory_2_outlined` → `emoji_events_rounded` (trophy), `person_outline_rounded` → `person_rounded` (filled).
- **LanguageProvider** (`lib/providers/language_provider.dart`): Fixed critical bug — `_userExplicit` was `final` and never updated after `setLanguage()`, causing `MaterialApp` to receive `locale: null` on language toggle and fall back to system locale (Spanish). Changed to non-final, set `_userExplicit = true` in `setLanguage()`.
- **Onboarding polish (previous session)**: PageView.builder + _pageCache, SageEmotion precache, page transitions 280ms easeOutCubic, Opacity→FadeTransition, RepaintBoundary outside AnimatedBuilder in loading+streak screens, Future.delayed removed from question_flow, emotion arc corrected (step8 calm→curious, step12 excited→thinking, step14 happy→excitedWave), disabled button alpha 0.06→0.12, Hero transition Sage→home, 27 provider tests, 0 analyze issues, 105/105 tests passing.

### In Progress
- (none)

### Blocked
- (none)

## Key Decisions
- **Circular zigzag over timeline**: Alternating left/right circles with Bezier curves chosen over vertical timeline — creates organic "path" feel, avoids rectangular cards entirely, makes progression visually directional. Custom _RoadmapPainter calculates node positions mathematically (known padding, rowHeight, nodeRadius) rather than using GlobalKey post-frame measurement — zero layout overhead, pure math.
- **5-color rotation over per-stage uniqueness**: Limits cognitive load and visual chaos. Colors cycle across stages. Within a stage, the same accent color varies opacity for states (completed=full, unlocked=0.12bg+0.6border, locked=grey). Chest nodes override with gold gradient regardless of stage color.
- **StatusStrip over capsule badges**: Complete elimination of container backgrounds reduces visual weight ~40%. Hotter streak colors with active/inactive states provide sufficient affordance without box borders. Removes ~50 lines of Container/decoration code.
- **BottomCta bar over floating FAB**: Persistent bar at screen bottom with "Continuar aprendiendo" is more discoverable than floating action button, keeps thumb-reachable zone on large phones. Optional energy restore button shown only when depleted — reduces visual noise when not needed.
- **Stage headers compact (56dp)**: Icon circle (36dp) + two-line text + right-aligned mini progress. Enough for identity, minimal for scrolling. No expand/collapse — roadmap is a scroll-through experience, not an accordion.
- **Chest node every 5th lesson**: Creates reward anticipation nodes in the progression. Different visual (larger circle, gold gradient, glow) breaks monotony of same-shape nodes. Marks "milestone" lessons without additional UI.
- **Challenges with emojis + chest tiers**: Each challenge type maps to an emoji for instant recognition. Chest tiers (bronze/silver/gold) communicate difficulty/value at a glance. Progress bars with chest-colored fill give clear completion tracking. Countdown timer creates urgency/anticipation.

## Next Steps
1. Audit remaining outlined icons across all screens (~20+ files) and migrate to rounded/filled variants
2. Remove dead code: settings.dart `_showDeleteConfirmation` stub
3. Unify card typography across Home, Profile, Settings to match normalized pattern (16px w700 / 13px 0.65 / 12px 0.5)
4. Fix lesson_screen.dart: reduce 8 AnimationControllers → 2, remove AnimatedBuilder wrapping body, simplify shake/glow/XP animations
5. Test on Moto E20: verify roadmap scroll performance with 50+ nodes, verify StatusStrip rendering, verify ChallengesScreen responsiveness

## Relevant Files
- **NEW** `lib/widgets/home/status_strip.dart`: Minimal status strip — streak/gems/energy with zero containers
- `lib/widgets/home/premium_header.dart`: Rewritten — Sage + greeting + stage title + level, no more capsule badges
- `lib/widgets/home/roadmap_widget.dart`: Complete rewrite — circular nodes, zigzag, CustomPaint Bezier curves, 5-color rotation, _MiniProgress, _LockedFade, _NodeCircle, _RoadmapPainter
- `lib/screens/home_screen.dart`: Rewritten layout — StatusStrip, _HomeQuote, _BottomCta, removed dashboard cards/stats/challenge tile
- `lib/screens/challenges_screen.dart`: Rebuilt — connected to DailyChallengeProvider, emojis, chest tiers, progress bars, timer header
- `lib/screens/navigation_shell.dart`: Icons fixed to `_rounded` filled variants (trophy + person)
- `lib/config/theme_constants.dart`: AppMotion durations, PremiumColors, AppSpacing, AppRadius, streakOrange, warning colors used by new designs
- `lib/providers/daily_challenge_provider.dart`: Used directly by new ChallengesScreen (no longer by HomeScreen)
- `lib/providers/onboarding/onboarding_provider.dart`: Emotion arc corrected (previous session)
- `lib/widgets/common/sage_emotion_widget.dart`: Opacity→FadeTransition (previous session)
- `lib/screens/lesson_screen.dart`: 8 AnimationControllers — pending reduction to 2
- `lib/screens/settings_screen.dart`: `_showDeleteConfirmation` stub — pending removal or implementation
