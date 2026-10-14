# FOR THE MASSES (FTM): Design (compact). Section IDs are stable; prompts cite them.

## D1 Pitch and tone
Round-based political mind game on Roblox. Players are city councilors in a fictional city. All names, places and parties are fictional; never real politicians, parties or flags. Tone: grounded, dark humor; consequences are shown, not lectured. A round ends when the masses elect a mayor.

## D2 Pillars
- No faction pick. Alignment emerges from choices; nobody sees a corrupt/honest label. Players deduce from evidence.
- The masses (NPC residents) decide the election, never the players. Players persuade.
- The game is walked, not menu-clicked: information lives in places and items (notice boards, ledgers, notebook, camera). UI starts nearly empty and unlocks gradually.
- Every campaign type is available to everyone; the difference is how much is real underneath.
- Rounds differ: crisis season, outgoing mayor's secret, restless districts, treasury tightness.
- No pay-to-win. Money never buys budget, trust or hidden information.

## D3 Round flow
About 10 councilor seats (players; empty seats filled by NPC councilors). Time unit is the "cycle" (about 120 s, Config.CycleSeconds). No in-game days.
Phases: Opening (no survey) -> Race (survey starts when the outgoing mayor announces he will not run; trigger = collective trust threshold, with a time fallback) -> Election (called by a trigger) -> Epilogue (reveal + highlights).
Election triggers: mayor steps down or is exposed; unrest boils over (uprising); runaway survey leader; crisis; hard time cap. A minimum time floor applies. Players can try to speed up or stall it.
Ending: the elected mayor wins; top councilors get honorable mentions (best project, best expose, best bluff...). The epilogue reveals ground truth: real spend per project, the mayor's secret, group opinions, highlight clips.

## D4 Map
Small walkable city: central Council Hall plus 5 districts (30-60 s walk between). Places: Council Hall (treasury window, roster board), Records Office (public price board, ledgers, camera film, audits), Contractor Yards (2+), Plaza (podium for press conferences and town halls), a notice board per district. Vehicles only shorten walks (status asset).

## D5 Problems and breaking point
Problems are learned by talking to residents ("the market floods when it rains"), not from mission cards. Each district problem has a breaking-point bar, readable at the district notice board. The bar starts rising when the problem surfaces and keeps rising after someone claims it; only real project phase progress pushes it down. At 100% the district erupts: the claimant is named culprit and the claim is forfeited. Each councilor has a home district; what you know depends on whom you have talked to.

## D6 Projects and money
Councilors never receive free money; they request budget.
- Claim: max 2 active claims, refundable deposit, a lease (fund a phase within N cycles or file a limited public extension). A stalled claim can be freed only by a confirmed audit or by the bar hitting 100%.
- Quote: haggle with contractors in person. Each contractor has a hidden true cost (affected by crisis/material prices), greed and patience; about 3 counter-offers, then they walk away for a while; they remember fair/unfair dealing. A cheap quote means corner-cutting, so a crisis can knock a phase back. Padding: a contractor can quote high and rebate the gap.
- Signatures: walk the district; residents sign if they care and do not distrust you; the count caps project size.
- Treasury: releases funds in installments, one per phase, on request for any valid claimed project; it NEVER verifies the site. The request is capped by signatures and by closeness to the public price board (the board shifts with crisis, so it is not a lie detector). The ledger is public: it shows releases, not what was actually paid.
- Project: 3-8 phases, visibly built on site. Only the sponsor can pay a phase. Completed projects give stable trust and may give small benefits.
- Corrupt moves: delay, ghost project, padded quote, fake a sudden phase jump under scrutiny. Skimmed money converts into influence (campaigns, handouts, allies, protection, laundering) and status assets.

## D7 Investigation
Tools: site visits (workers, materials, signboard); records office (ledger vs price board); witnesses (can be bribed, may conflict); watching a contractor yard; formal audit (stand at the desk about 1 cycle, partial answer, one active audit per player, a wrong accusation costs standing); camera (limited film, about 6; must stand at the site; timestamped; immutable); shared case file (evidence items); press conference at the plaza (slideshow built from filed evidence; presenter = top contributor; it hurts a rival's support but never removes them). Evidence persists even if the accused leaves.

## D8 Trust and survey
Resident groups per district bloc (vendors, workers, families, teachers/students, elders). Two hidden standings per councilor per group: Stable trust (real finished work, permanent, cannot be smeared away) and Unstable trust (campaigns, handouts, rumors, ads; fast, fragile, decays, collapses on exposure or when a group notices a stalled project). Unstable can partly harden into stable if the work is later finished. Players never see these numbers.
Public survey: ranking with percentages and a margin of error; blends both standings, stable weighted heavier; per-group weighted by size; has lag and noise. It is a strong forecast, not the decider.
Election result = group opinions + turnout (ignored or angry groups may stay home) + late events + endorsements (including the outgoing mayor) + late deciders. Failed accusations and debunked rumors cost the accuser.

## D9 Campaign tools (all players)
Town halls, door-to-door, endorsements, debates, press, handouts, paid ads, staged events, rumors. They cost money that competes with projects.

## D10 Chat and meetings
No global chat; proximity chat only. Emergency meeting: 2 per player per round, shared cooldown of about 3 cycles, none in the opening cycles, mandatory attendance, needs a motion (demand progress report / audit / censure ...), the same motion on the same target is not repeatable, max 3 min or ends early by majority, the economy clock keeps running, a failed motion costs standing.

## D11 Round variables and events
Crisis season (flood etc.); outgoing mayor secret (honest / corrupt / compromised); restless, loyal and undecided groups; treasury tightness; random events (leaked document, surprise endorsement).
Uprising: when a district bar hits 100%, a witness (e.g. a teacher) emerges; corrupt players may try to discredit them, honest players may shield them; the outcome shifts the masses.
Director: if nobody is dishonest by midterm, offers get juicier; baseline non-player corruption always exists (padded contractors, the mayor's secret, an odd old ledger).

## D12 Population and leaving
Empty seats are NPC councilors (some secretly corrupt; endorsers only, cannot win). On disconnect: short grace, then the seat becomes an NPC that keeps their claims at a basic pace; evidence stays usable; their unstable trust fades. Late join only before the survey starts. Too few players means a snap election.

## D13 Lobby and parties
The lobby is a walkable plaza with the same art as the city. Queue by registering at a campaign office; waiting room; bulletin board with a vague crisis hint; wardrobe; practice area; private server desk; delegation desk (party cap 2-3 in public servers). After a round: back to the plaza and the winner's inauguration. Spectators are delayed and see no hidden info.

## D14 Highlights
A silent tracker records key moments all round (exposures, phase jumps, uprising, vote) to build clips for the epilogue.

## D15 Monetization (later)
Cosmetics (outfits, office/vehicle skins, podium, slide themes), victory vanity, private servers, cosmetic pass. Never sell: budget, trust, meetings, claims, camera film, audit speed, hidden-info reveals, paid revives, paid random gameplay items.

## D16 Art rule
Placeholder art only for now: default Roblox rigs with role labels, boxes with big signs, district color coding. All visuals come from the Visual Registry so art can be swapped later. Building signs must be world-sized: use a SurfaceGui on a sign part or a BillboardGui sized in Scale with MaxDistance; never use pixel-sized (Offset) BillboardGuis.

## D17 Open decisions (defaults used until changed)
Bars readable only at notice boards. NPC councilors are endorsers only. Lobby is per-server. Survey appears at the mayor's announcement.
<!-- END OF DESIGN -->
