# PROGRESS: For The Masses

## Handoff
Last done: U2.2 Sign helper, enterable building, props
Next: U2.3 CityBuilder service
Partial/dirty files: none
Tools: rojo available; stylua, luau-lsp, selene unavailable
Note for next AI: Phase 1 patch complete; Studio checks STUDIO-UNVERIFIED (no connected place).

## Phase 1: Scaffold
- [x] U1.1 Baseline, Rojo tree check, tooling config
- [x] U1.2 docs/DESIGN.md, AGENTS.md, README
- [x] U1.3 Shared foundation (Config, Types, Log, Net)
- [x] U1.4 Server bootstrap + Diagnostics service
- [x] U1.5 Client bootstrap + Diagnostics controller
- [x] U1.6 Visual registry + placeholder building + DevSandbox
- [x] U1.7 Final QA and handoff
- [x] U1.8 Fix sign scaling (world-size signs)

PHASE 1 COMPLETE

## Decisions
- Kept the existing Workspace Baseplate and Lighting setup; the requested tree and project name are corrected without discarding useful place configuration.
- Used the supplied Appendix A and B text verbatim with the required end sentinels.
- Net.onEvent dispatches by RunService context so the public API name works for both server handlers and client callbacks; missing client remotes have a bounded 5-second wait.
- VisualRegistry checks override builders before prefix placeholders; DevSandbox only creates its ground when no BasePart named Baseplate exists.
- Mounted the building sign above the door as a non-colliding part with a welded, world-sized SurfaceGui at 50 pixels per stud.
- No layout nudges were needed; the planned core places, yards, district pads, and landmarks are separated.

## Blockers
(none yet)

## Manual checks (user, in Studio)
1. STUDIO-UNVERIFIED — Output shows `[FTM][Diagnostics] server ready`.
2. STUDIO-UNVERIFIED — Output shows the client ping reply (`pong`) and no warnings.
3. STUDIO-UNVERIFIED — Walk from the Council Hall to about 80 studs away; its SurfaceGui sign shrinks with the building.

## Phase 2: Greybox city
- [x] U2.1 City data + config
- [x] U2.2 Sign helper, enterable building, props
- [ ] U2.3 CityBuilder service
- [ ] U2.4 Location toast controller
- [ ] U2.5 Final QA and handoff

## Manual checks: Phase 2 (user, in Studio)
1. You spawn in a plaza south of the Council Hall; every sign shrinks as you walk away and is readable up close.
2. You can walk through the Council Hall door; inside are a roster board and a treasury window.
3. Walking from the hall along each road reaches five different color-coded districts; a toast shows each district name when you enter.
4. Each district has a gate sign and a notice board; Market Row has a recognizable drain, Hillview a footbridge, Eastside a school.
5. The Records Office is enterable and has a price board, ledgers, a film desk and an audit desk.
6. Two contractor yards exist (fenced, labeled A and B); the plaza has a podium.
7. Output shows `built 5 districts ...` and no warnings.
