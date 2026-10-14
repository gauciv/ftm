# AGENTS.md: For The Masses (FTM)
Read this and PROGRESS.md first, every session. Read docs/DESIGN.md only for the sections your prompt cites (e.g. D5, D6). Prompts are re-pasteable: state lives in PROGRESS.md and git, never in chat.

## Stack
Roblox + Rojo. Luau only, `.luau` files, `--!strict` at the top of every file. No Wally/npm packages. Tools (rojo, stylua, luau-lsp, selene) may or may not exist: check with `command -v`; never download or install.

## Layout
- src/shared -> ReplicatedStorage.Shared (modules): Config, Types, Log, Net/, Registry/, Data/
- src/server -> ServerScriptService.Server (init.server.luau = bootstrap; Services/ auto-loaded)
- src/client -> StarterPlayer.StarterPlayerScripts.Client (init.client.luau = bootstrap; Controllers/ auto-loaded)
- A service/controller is a ModuleScript returning { Name, Init?, Start? }. Init must not yield or call other services; Start may yield. Add features as new files; do not edit the bootstrap.

## Rules
- Server authoritative for money, trust, claims, project phases, evidence, votes. Clients only display and request. Validate every remote argument (type, range, ownership).
- Never replicate hidden values (true contractor costs, trust numbers, alignment, actual spend) to clients. Send only what the player may perceive.
- Data-driven: content (problems, contractors, residents, districts, crises, motions) goes in shared/Data tables; tunables in Config. No magic numbers in logic.
- All visible objects are created through VisualRegistry.build(key, params). Placeholders live in Registry/Placeholders; every placeholder has attributes FTMKey and FTMLabel and a readable, world-sized sign (SurfaceGui on a sign part, or BillboardGui sized in Scale with MaxDistance). Never use pixel-sized (Offset) BillboardGuis for building signs. Real art later replaces entries via Registry/Overrides.
- Style: task.wait/task.spawn/task.delay (never wait/spawn/delay); game:GetService; typed exports; no globals; no deprecated APIs; StyLua formatting. PascalCase modules/services, camelCase locals/functions, UPPER_SNAKE constants. No emojis in code or logs. Log via Log module with [FTM][Tag].
- Glossary: Councilor = player seat; Cycle = budget cycle (about 120 s); District = map area and resident group; Claim = sponsoring a problem; Project = funded phases; Stable/Unstable trust; Survey; Case file; Evidence; Motion.

## Process
- Conventional Commits, small commits, no tags/remotes/push. Update the PROGRESS.md Handoff block after every item.
- Studio verification: edit files, never scripts inside Studio. If Studio MCP tools (e.g. BloxForge) are available, after Rojo syncs: playtest, read Output, screenshot UI changes. Otherwise mark the item STUDIO-UNVERIFIED under Manual checks.
<!-- END OF AGENTS -->
