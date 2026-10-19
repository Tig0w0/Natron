# Natron UI readability audit — 2026-10-19

## Objective
Improve the personal Windows 10 Natron 2.5 compositor for CG-pass compositing and roto, without reducing viewer/graph workspace, touching image processing, or breaking the installed Natron binary.

## Reference principles
- [W3C WCAG 2.2 — text contrast](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum): 4.5:1 for normal text, 3:1 for larger text.
- [W3C WCAG 2.2 — non-text contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast): 3:1 for meaningful control boundaries/states.
- [W3C WCAG 2.2 — target size](https://www.w3.org/WAI/standards-guidelines/wcag/new-in-22/): generally 24×24 CSS px or adequate spacing, with exceptions for essential dense interfaces.
- [Microsoft Fluent 2 typography](https://fluent2.microsoft.design/typography): Segoe UI and scannable hierarchy; balanced against Natron's dense professional layout.
- [Nielsen Norman Group heuristics](https://www.nngroup.com/articles/ten-usability-heuristics/): consistency, visibility, minimalism, expert efficiency.

WCAG originates from web accessibility; these requirements are used here as practical design checks for the desktop UI, not as a claim of official WCAG certification.

## Applied to installed Natron
- User preferences: `Segoe UI`, `13px`, external `Natron-Readable-Dark.qss`.
- Improved ordinary text contrast, tab labels, buttons, menu colors, input outlines, focus indicators, selected states, gray scrollbars and panel outlines.
- Screenshot-checked the app's main Viewer, Project Settings properties panel, Node Graph and timeline after restart.
- Tested 12 explicitly defined foreground/background or border/background token pairs with `check_contrast.py`: **12 passed** (11.22:1 main text; 3.46:1 button border; 5.39:1 input border). Other states are not covered by this sample.
- App opens, is responsive, and the inspected panels had no observed font clipping or major geometry failure.

## Known unresolved defect
**Project Settings → Project Paths → built-in disabled OCIO row remains black-on-dark in installed 2.5 binary.** Approximate theme background `#222930` makes black text ~1.43:1. The custom paint delegate at `Gui/KnobGuiTable.cpp` explicitly sets `pen.setColor(Qt::black)` when `Qt::ItemIsEnabled` is absent. QSS foreground selectors cannot override its painter call.

Source fix committed on fork branch `ui/readability-audit-2026-10-19`: use palette text color, slightly reduced opacity for disabled entries. It **has not been compiled, deployed or runtime-verified**. Installing it will require a full Natron Windows build and regression checks (project path tables, disabled/selected cells, editing on dark and light themes). This PC currently has no CMake/MSVC/Ninja build toolchain on PATH; do not overwrite the working stock install.

## Not yet evaluated
- Real 4K multi-layer EXR AOV images, frame sequences and OCIO color transforms.
- RotoPaint controls, Curve Editor under a real animated shape, Python editor, dialogs and all tooltips.
- Keyboard-only navigation / screen reader access / Windows DPI variants.
- Dense ~20px toolbar icon hit areas (compare WCAG 2.2 target-size guidance, with dense expert-app exceptions).
- Native bitmap icons and hard-coded OpenGL/Qt paints require deeper UI code changes.

These are **unverified**, not automatically considered passed.

## Paths and recovery
- Active theme: `C:\Users\504-03\AppData\Local\NatronThemes\Natron-Readable-Dark.qss`
- Original QSS backup: `C:\Users\504-03\AppData\Local\NatronThemes\backup\mainstyle.original.qss`
- Pre-audit theme backup: `backup\readable-dark-overrides.pre-audit.qss`
- Restore script: `restore-original.ps1` (run then restart Natron; registry values revert to original absent state).
- Apply script: `apply-readable-dark.ps1`
- Sanity check: `check_contrast.py`
- Fork: [Tig0w0/Natron — UI readability branch](https://github.com/Tig0w0/Natron/tree/ui/readability-audit-2026-10-19)
- Committed source patch: [KnobGuiTable.cpp](https://github.com/Tig0w0/Natron/blob/ui/readability-audit-2026-10-19/Gui/KnobGuiTable.cpp)
- Portable QSS: [Natron-Readable-Dark.qss](https://github.com/Tig0w0/Natron/blob/ui/readability-audit-2026-10-19/ui-themes/Natron-Readable-Dark.qss)

## Scope and stop rule
Completed the low-risk font/QSS pass and visual checks on accessible stock UI surfaces. Source-level display defect isolated and patched in GitHub, but **not fixed in the running binary**. A claim that all Natron UI defects are gone would be inaccurate; continue evaluation as workflows expose new surfaces.
