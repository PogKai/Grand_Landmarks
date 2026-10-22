# Development setup

## Supported baseline

- Kerbal Space Program 1.12.5 on a separate development copy
- Kopernicus release-1.12.1-251 for planetary terrain changes
- Kerbal Konstructs 1.12.3.0 for placed static meshes
- KittopiaTech release-1.8.1-1 for in-game Kopernicus inspection and editing
- Blender 3.6.22 LTS for source meshes and collision meshes
- `io_object_mu` for Blender-to-KSP `.mu` export
- Python 3.10 or newer for repeatable terrain and asset processing
- Git LFS for large binary source and game assets
- PowerShell 7 for repository scripts

Dependency versions are deliberately not pinned until the first end-to-end prototype passes.
Record the exact working versions in this document when that happens.

## First-time setup

1. Clone this repository and run `git lfs install` once for your user account.
2. Make a clean copy of KSP 1.12.5 for development. Never point the project at a valued save.
3. Install Kopernicus and its declared dependencies into that copy, preferably through CKAN.
4. Install Kerbal Konstructs and its declared dependencies into the same copy.
5. Install Blender, then install and validate the `io_object_mu` add-on with one test cube.
6. Copy `.env.example` to `.env` and set `KSP_ROOT` to the development KSP folder.
7. Run `pwsh ./tools/check-environment.ps1`.
8. Run `pwsh ./tools/build.ps1` to create an installable ZIP in `dist/`.

To install the portable authoring tools and Python packages automatically, run:

```powershell
pwsh ./tools/install-authoring-tools.ps1
```

This installs everything under ignored repository-local directories. It does not modify an
existing Blender installation. Blender 3.6.22 is intentionally pinned until `io_object_mu` is
validated end to end; changing Blender versions also changes its Python and add-on APIs.

Deploy the current package to the `.env` test installation with:

```powershell
pwsh ./tools/deploy.ps1
```

The current development instance is KSP 1.12.5 at `C:\Users\Sawyer\Desktop\KSP_win64`.
Kopernicus and KittopiaTech are managed through CKAN. The existing Kerbal Konstructs and
ModuleManager installations are currently unmanaged and must not be overwritten casually.

Do not commit KSP binaries, dependency DLLs, logs, saves, downloaded mods, or `.env`.

## Repository layout

| Path | Purpose |
| --- | --- |
| `GameData/SoysGrandLandmarks/` | Exact files shipped inside a KSP installation |
| `assets/models/` | Editable Blender sources; exported `.mu` files go under `GameData` |
| `assets/textures/` | High-resolution texture sources |
| `assets/terrain/` | Source heightmaps, masks, and terrain inputs |
| `config/examples/` | Drafts and disabled configuration examples |
| `docs/` | Setup, design decisions, test plans, and release notes |
| `tools/` | Reproducible validation, generation, and packaging scripts |
| `build/`, `dist/` | Generated output; never committed |

## Asset conventions

- Use metres for modeled scale and apply transforms before export.
- Give render and collision meshes distinct, descriptive names.
- Keep source filenames lowercase with underscores; keep the runtime folder name exactly
  `SoysGrandLandmarks`.
- Keep generation parameters and seeds beside generated terrain inputs.
- Commit binary assets through Git LFS, not ordinary Git objects.
- Place textures read directly from configuration under `PluginData` when they should not be
  loaded eagerly by KSP.

## Prototype workflow

1. Select and record a test site's latitude, longitude, and baseline elevation.
2. Generate a coarse terrain mask and heightmap under `assets/terrain`.
3. Promote tested runtime textures and configuration into `GameData/SoysGrandLandmarks`.
4. Export one untextured arch and a separate simplified collider from Blender.
5. Build, install into the disposable KSP copy, and run the acceptance checks in
   `PROJECT_SCOPE.md`.
6. Record exact dependency and tool versions after the pipeline works end to end.

## References

- [Kopernicus](https://github.com/Kopernicus/Kopernicus)
- [Kerbal Konstructs](https://github.com/GER-Space/Kerbal-Konstructs)
- [Blender KSP `.mu` add-on](https://github.com/taniwha/io_object_mu)
- [CKAN](https://github.com/KSP-CKAN/CKAN)

