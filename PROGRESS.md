# PROGRESS: For The Masses

## Handoff
Last done: U3.2 CycleClock and Problems services
Next: U3.3
Partial/dirty files: none
Tools: rojo available; stylua, luau-lsp, selene unavailable
Note for next AI: U3.2 complete; surfaced bar values remain server-only.

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
- U2.1: No layout nudges were needed; the planned core places, yards, district pads, and landmarks are separated.
- U2.3: Spawn offset is 22 studs from the Plaza center so it stays inside the 45-stud plaza radius; the inherited Baseplate is hidden and made non-colliding to prevent z-fighting with FTM_Ground.
- U3.1: Kept all 16 explicitly listed residents; the manual check's expected count of 15 conflicts with the roster.

## Blockers
(none yet)

## Manual checks (user, in Studio)
1. STUDIO-UNVERIFIED — Output shows `[FTM][Diagnostics] server ready`.
2. STUDIO-UNVERIFIED — Output shows the client ping reply (`pong`) and no warnings.
3. STUDIO-UNVERIFIED — Walk from the Council Hall to about 80 studs away; its SurfaceGui sign shrinks with the building.

## Phase 2: Greybox city
- [x] U2.1 City data + config
- [x] U2.2 Sign helper, enterable building, props
- [x] U2.3 CityBuilder service
- [x] U2.4 Location toast controller
- [x] U2.5 Final QA and handoff

PHASE 2 COMPLETE

## Manual checks: Phase 2 (user, in Studio)
1. STUDIO-UNVERIFIED — You spawn in a plaza south of the Council Hall; every sign shrinks as you walk away and is readable up close.
2. STUDIO-UNVERIFIED — You can walk through the Council Hall door; inside are a roster board and a treasury window.
3. STUDIO-UNVERIFIED — Walking from the hall along each road reaches five different color-coded districts; a toast shows each district name when you enter.
4. STUDIO-UNVERIFIED — Each district has a gate sign and a notice board; Market Row has a recognizable drain, Hillview a footbridge, Eastside a school.
5. STUDIO-UNVERIFIED — The Records Office is enterable and has a price board, ledgers, a film desk and an audit desk.
6. STUDIO-UNVERIFIED — Two contractor yards exist (fenced, labeled A and B); the plaza has a podium.
7. STUDIO-UNVERIFIED — Output shows `built 5 districts ...` and no warnings.

## Phase 3: Residents, problems, notebook, bars
- [x] U3.1 Data, config, types, net names, AGENTS rules
- [x] U3.2 Cycle clock + problem bars
- [ ] U3.3 Person placeholder + resident spawning
- [ ] U3.4 Notebook service + resident dialogue flow
- [ ] U3.5 Notice board readings
- [ ] U3.6 Client dialogue + resident markers
- [ ] U3.7 Client notebook + board reader
- [ ] U3.8 Dev command, final QA, handoff

## Manual checks: Phase 3 (user, in Studio)
1. Output shows `spawned 15 residents`, no warnings. 15 labeled people stand around the five districts.
2. On spawn you get one hint line about your home district (Market Row for the first player). The notebook button is NOT visible yet.
3. In Market Row, Aling Nena shows a `!`. Press E near her: a dialogue panel appears, the `!` disappears, a notebook button appears, and the notebook has a "Heard" entry.
4. Talk to a resident without a `!` (e.g. Ate Joy): you get a plain line, no new entry.
5. Walk away mid-dialogue: the panel closes.
6. Read the Market Row notice board: it shows "Market Drain" with a percent bar. In the Studio command bar (Server view) run `shared.FTMDev.advance(3)` and read again: the percent is higher and a new Board entry is in the notebook.
7. Visit Hillview's board without talking to anyone there: the footbridge bar is visible and higher than the drain.
8. `shared.FTMDev.advance(20)`, then read boards: bars cap at 100 and show "ERUPTED"; Output logs each eruption once; no errors.
9. In the Client view Explorer, ReplicatedStorage contains no problem values or teach maps.
