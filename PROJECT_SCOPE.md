# KSP Grand Landmarks: Initial Project Scope

Status: planning proposal. No implementation or in-game validation has been completed.

## Goal

Create a collection of dramatic, handcrafted natural landmark regions for Kerbal Space Program 1, beginning with Kerbin. Candidate formations include grand canyons, branching ravines, mountain massifs, natural arches, rock bridges, spires, and overhangs.

The landmarks should support low-altitude flight, rover travel, landing, and EVA exploration. Preserve the recognizable stock planet outside the selected regions.

Initial assumptions are KSP 1.12.x and stock-size Kerbin. Exact dependency versions, locations, performance targets, and compatibility claims must be established through testing.

## Technical concept

Use a hybrid of planetary terrain deformation and custom static meshes.

KSP's PQS terrain system produces the planetary surface. Kopernicus exposes terrain modifiers, including heightmaps that add or subtract elevation. Kerbal Konstructs places static objects and also provides local terrain editing facilities. These are existing foundations for the project rather than a reason to build a new terrain engine immediately. See sources [1], [2], and [3].

A height-based surface has one elevation at a given surface location. It can form a valley or ridge, but cannot represent both an arch roof and the empty space beneath it. Arches and overhangs therefore require separate geometry.

Placing a canyon-shaped model on top of the surface does not remove the original terrain or its collision. The underlying terrain must be lowered wherever aircraft, rovers, or Kerbals need to pass.

## Landmark construction

| Landmark | Proposed construction | Relative difficulty |
| --- | --- | --- |
| Huge canyon | Branching terrain excavation with selected detailed cliff meshes | Moderate to high |
| Mountain massif | Terrain elevation, ridges, erosion patterns, and foothills | Moderate |
| Broad ravine | Local terrain deformation with a blended perimeter | Moderate |
| Narrow slot canyon | Terrain excavation and modeled walls where subdivision is insufficient | High |
| Natural arch or rock bridge | Custom mesh with collision that preserves its opening | Moderate |
| Overhang or shallow cave | Custom mesh integrated into a prepared terrain recess | High |
| Extensive cave network | Separate geometry with substantial terrain and collision integration | Very high; defer |

## Implementation options

| Route | Benefits | Tradeoffs |
| --- | --- | --- |
| Kerbal Konstructs terrain editing and statics | Fast route to a complete experimental site | Must verify terrain controls, resolution, and distance behavior at the intended scale |
| Kopernicus terrain plus Kerbal Konstructs models | Separate control of planetary terrain and detailed objects | Additional dependencies and compatibility work |
| Custom terrain and object plugin | Full control over generation and loading behavior | Much larger engineering and maintenance burden |

The preferred starting architecture is Kopernicus for terrain and Kerbal Konstructs for models. A simpler Kerbal Konstructs-only prototype remains worth evaluating before committing. Introduce custom C# code only for a demonstrated limitation.

Choose one owner for each terrain operation so overlapping modifiers do not unintentionally reshape the same region twice. Validate modifier ordering and edge blending in the prototype.

## Terrain workflow

1. Survey a suitable inland region, including elevation, slopes, and surrounding terrain.
2. Define a winding canyon centerline, widths, depths, tributaries, and transition boundaries.
3. Generate localized height data and masks with Python.
4. Apply the terrain modification using the selected framework.
5. Check resolution and collision in KSP before adding fine detail.
6. Adjust the shape and transition zone until it meets the surrounding terrain naturally.

Keep generation parameters and seeds alongside source assets so changes are reproducible. A detailed heightmap does not guarantee equally detailed in-game geometry: the terrain subdivision must also support the intended shapes.

## Model and material workflow

Use Blender to create arches, rock bridges, cliff sections, spires, and talus slopes. Procedural scripts can generate irregular cross-sections, layered rock, fractures, and variations; visual review is still needed to avoid repetitive or artificially noisy results.

Build a small reusable material set, while giving major landmarks distinctive silhouettes. Create simplified collision geometry separately from render geometry. An arch's collider must leave the opening clear.

Export a small test asset before producing a large asset collection. Validate scale, axes, normals, materials, and collision through the full Blender-to-KSP pipeline.

Concept images may guide appearance, but are not game-ready meshes or collision assets.

## Tools and automation

| Tool | Role | Work that can be automated or assisted |
| --- | --- | --- |
| Blender | Meshes, UVs, materials, and simplified collision geometry | Python-driven mesh generation, variants, processing, and export |
| Python | Terrain and asset processing | Heightmaps, masks, canyon paths, erosion approximations, previews, and validation |
| Kopernicus | Terrain modification | Configuration authoring and troubleshooting; custom modifiers if required |
| Kerbal Konstructs | Model placement and candidate local terrain editing | Model and placement configs, coordinates, orientation, scale, and grouping |
| Blender KSP .mu add-on | Direct KSP model export | Scripted batch export after validating a compatible version |
| Unity and PartTools | Alternative model/material/collider export workflow | Project preparation and export scripting |
| C# compiler and .NET tooling | Optional plugin development | Diagnostics, custom terrain behavior, or loading features |
| Git | Version control | Track source, configs, generation parameters, and build scripts |
| Separate KSP test installation | Runtime verification | Log analysis and diagnostic instrumentation, paired with flight and ground testing |

The Blender .mu add-on supports KSP model import/export and scripted batch export [4][5]. Newer Blender versions have reported compatibility issues [6][7], so pin a tested combination rather than assuming the latest version works.

A documented KSP 1.12 PartTools workflow uses Unity 2019.4.18f1 [8]. Treat this as an alternative export route and verify availability, licensing, and compatibility before setup.

Code, configs, procedural assets, build scripts, and log analysis can be produced through automation. Visual quality, collision behavior, performance, and flight experience still require actual in-game verification. No installed toolchain has been verified yet.

## First prototype: Grand Canyon and Stone Bridge

Build one complete region that exercises the main technical requirements.

| Feature | Proposed target |
| --- | --- |
| Canyon length | Approximately 10-20 km |
| Canyon depth | Approximately 300-800 m, subject to site elevation |
| Tributaries | A few branching ravines |
| Arch | One large stone arch with roughly 150-300 m of clear opening |
| Visual identity | Layered cliffs and a few distinctive spires |
| Surface access | Traversable areas for rovers and EVA |
| Boundary | Smooth transition to stock terrain |

These are design targets, not confirmed engine limits. Choose an inland site with enough elevation to avoid accidentally cutting into the ocean.

### Phase 1: Toolchain and site selection

- Identify the exact KSP version and establish a separate test installation.
- Validate dependency versions and a minimal model export.
- Select and survey the candidate site.
- Establish baseline performance measurements on a repeatable test route.

### Phase 2: Untextured proof of concept

- Deform a simple canyon into the actual terrain.
- Add one untextured arch with working collision.
- Verify scale, placement, passage clearance, terrain transitions, and reload behavior.
- Decide whether existing frameworks are sufficient before writing a custom plugin.

### Phase 3: Visual development

- Refine the canyon path and tributaries.
- Add rock materials, selected cliff details, and spires.
- Improve terrain-to-mesh blending and distance appearance.
- Optimize geometry and collision based on measurements.

### Phase 4: Validation and packaging

- Complete flight, rover, EVA, and reload tests.
- Test declared graphics settings and mod combinations.
- Produce an installable package, dependency list, and release documentation.

## Main risks and mitigations

| Risk | Implication | Planned response |
| --- | --- | --- |
| Terrain subdivision | Narrow ravines may disappear or change shape at lower detail | Test several terrain settings; use meshes selectively where needed |
| Mesh/terrain seams | Floating edges, gaps, and color mismatches break the illusion | Design overlap and transition zones; inspect from ground and air |
| Collision mismatch | Invisible walls or pass-through surfaces | Build and test simplified colliders independently |
| Distance transitions | Visible popping or missing landmarks | Test approach/departure and tune the selected loading and detail systems |
| Distant planet representation | Surface edits may not match the orbital view | Verify scaled-space behavior and explicitly address discrepancies |
| Planet curvature | Large flat meshes do not fit Kerbin | Curve or divide large mesh regions appropriately |
| Terrain and visual mods | Other modifications can move or obscure landmarks | Start with stock-size Kerbin; test and document supported combinations |
| Existing landed craft | Terrain edits may bury or suspend vessels | Develop in a separate save and document affected regions before release |
| Export compatibility | Materials or colliders may fail despite valid-looking source assets | Pin tools after a successful end-to-end test |

## Prototype acceptance checks

- Fly through the canyon and arch at representative aircraft speeds.
- Drive a rover across terrain/model transitions.
- Walk and land on intended accessible surfaces, including the bridge.
- Confirm that openings have no invisible collision barriers.
- Save and reload near the landmark and repeat scene transitions.
- Approach from orbit and inspect near/far terrain transitions.
- Repeat key checks at multiple terrain-quality settings.
- Compare frame time and memory against the baseline on the same route and craft.
- Inspect logs for recurring exceptions and loading errors.

Numerical performance budgets should be set after baseline measurement. Do not claim compatibility or performance targets before these checks pass.

## Scope boundaries

The first milestone is one region, not a planet-wide overhaul. Extensive underground cave networks, custom water systems, dynamic erosion, procedural landmarks across every planet, and a new terrain engine are outside the initial scope.

Later regions can reuse the tested pipeline for additional canyons, mountain ranges, and arch fields. Other celestial bodies are a possible later expansion.

## Effort estimate

Planning estimate only: several focused development sessions for a basic proof of concept, a few weeks of iteration for one polished region, and substantially longer for a varied landmark pack. Toolchain setup, terrain subdivision, collision, and distance behavior are the largest early uncertainties. Reassess after the prototype works in-game.

## Open decisions

- Final mod name and license.
- Exact KSP and dependency versions.
- Terrain framework choice after initial experimentation.
- Blender/exporter version pairing and whether Unity is needed.
- Landmark coordinates and final dimensions.
- Visual style and texture budgets.
- Supported visual mods and terrain-quality settings.
- Whether a custom plugin is necessary.

## Sources

These references support the initial feasibility assessment. They do not establish that this project's proposed combination has been tested.

1. [Kopernicus: VertexHeightMap documentation](https://kopernicuswiki.github.io/wiki/content/PQSMods/VertexHeightMap.html)
2. [Kerbal Konstructs source and overview](https://github.com/GER-Space/Kerbal-Konstructs)
3. [Kerbal Konstructs Continued: terrain editing and static placement](https://forum.kerbalspaceprogram.com/topic/204210-ksp-18-kerbal-konstructs-continued/)
4. [Blender KSP .mu import/export add-on](https://github.com/taniwha/io_object_mu)
5. [Scripted .mu batch export](https://github.com/taniwha/io_object_mu/blob/master/mass-export.py)
6. [Blender 5.1.1 compatibility report](https://github.com/taniwha/io_object_mu/issues/95)
7. [Blender 5.0 compatibility report](https://github.com/taniwha/io_object_mu/issues/93)
8. [Documented Unity 2019.4.18f1 and PartTools workflow for KSP 1.12](https://forum.kerbalspaceprogram.com/topic/231843-unity-2019418f1-parttools-for-ksp-112-in-a-docker-container-no-local-install/)
