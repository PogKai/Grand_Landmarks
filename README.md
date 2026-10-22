# Soy's Grand Landmarks

A planned Kerbal Space Program 1 mod adding dramatic natural landmarks to Kerbin: big canyons, ravines, mountain massifs, natural arches, and rock bridges.

## Status

Pre-alpha scaffolding. The repository has a package layout and development scripts, but there is no playable landmark yet.

## Approach

Combine localized terrain changes for large landforms with custom 3D meshes for arches, overhangs, and detailed cliff sections. Keep the surrounding stock planet recognizable and make the landmarks usable for aircraft, rovers, and EVA exploration.

- Initial target: KSP 1.12.x and stock-size Kerbin.
- Proposed terrain framework: Kopernicus, with Kerbal Konstructs terrain editing evaluated during prototyping.
- Proposed model placement: Kerbal Konstructs.
- Asset creation: Blender and Python, using a tested KSP model export pipeline.
- Custom C# code: only where the prototype demonstrates a need.

Dependencies and supported versions are provisional until tested.

## First milestone

Build one canyon region with branching ravines and a large stone arch. First verify terrain shaping, model placement, collision, and distance transitions; then develop textures and visual detail.

## Documentation

- [Project scope](PROJECT_SCOPE.md): architecture, prototype targets, risks, and acceptance checks
- [Development setup](docs/DEVELOPMENT.md): prerequisites, repository layout, and first-time setup

## Build

From PowerShell 7:

```powershell
pwsh ./tools/check-environment.ps1
pwsh ./tools/build.ps1
pwsh ./tools/deploy.ps1
```

The package is written to `dist/SoysGrandLandmarks-0.1.0-dev.zip`. Generated output and local KSP installations are ignored by Git.

## Next steps

1. Identify the development KSP installation and establish a separate test copy.
2. Validate compatible terrain, placement, and model-export tools.
3. Select and survey an inland Kerbin test site.
4. Build an untextured canyon and arch proof of concept.

## License

Not selected yet. Review code, asset, and dependency licenses before distribution.
