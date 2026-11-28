# Aerobody C v2 (faceted, flat-panel redesign of tail C)
Built 2026-11-28 with the SolidWorks connector. Original C files are untouched (Aero body\Solid and \Shelled).

## Goal
Make C as flat-paneled as possible for carbon fiber paneling, and cut drag. Only curved pieces left: the
nose cap (plan R160 + side R150 x2, about the first 250 mm) and the R30 tail tip.

## Variants (each adds ONE change, so CFD isolates the effect)
| Variant | What changed | Solid vol m3 | Wetted m2 | Shell mass* kg |
| C (original) | baseline, fillets R400/R2000/R1000/R2000/R3000 | 2.564 | 14.362 | 22.54 |
| v2A Faceted | every big fillet replaced by flat facets, kinks <=14 deg, same side profile | 2.565 | 14.371 | 22.52 |
| v2B Faceted_LowLift | v2A + side profile for less downforce: bottom tail kick 4.5->2.5 deg, top drop starts x=2000 (9.8 deg) | 2.478 | 14.218 | 21.72 |
| v2C Faceted_LowLift_LongTaper | v2B + max width ends at x=1600 (was 1997), plan taper 16.8->14.7 deg | 2.341 | 13.582 | 21.71 |
*Shell mass at placeholder density 1000 kg/m3, 5 mm wall. Use for comparison only.

Curved outer side-wall area: C about 1.13 m2, v2 about 0.10 m2 (nose cap + tail tip only).
All variants keep: width 1600, height 650 (clearance 150, top 800, still PLACEHOLDERS), plan tip x=4950.

## Plan (top view, Sketch1, half outline z>0, mirrored corners independent)
Nose facets: tip (0,0) R160 -> (784.13,612.54) 38 deg -> (1076.464,742.696) 24 deg -> (1401.451,800) 10 deg
v2A/v2B: flat to (1997.019,800) -> 8.4 deg entry facet to (2590.582,712.35) -> 16.8 deg taper to (4950,0) R30
v2C:     flat to (1600,800)     -> 7.35 deg entry facet to (2195.064,723.196) -> 14.7 deg taper to (4950,0) R30

## Side profile (front plane, Sketch2, keep_inside cut)
v2A: (0,150) R150, (0,450) R150, (1255.921,763.655), (1551.451,800), (2101.451,800), (2499.002,768.799),
     (4950,381.685), (4950,359.158), (2301.451,150)  [top 14 -> 7 -> 0 -> -4.5 -> -9 deg, bottom kick 4.5 deg]
v2B/v2C: (0,150) R150, (0,450) R150, (1255.921,763.655), (1551.451,800), (1800,800), (2197.056,765.81),
     (4950,288.165), (4950,265.638), (2301.451,150)  [top -4.9 -> -9.8 deg, bottom kick 2.5 deg]

## Build (same as original C)
Solid: Sketch1 > TopView_Extrude (800) > Sketch2 > SideProfile_Cut
Shelled: Sketch1 > TopView_Extrude > Shell1 (5 mm, +y/-y open) > Sketch2 > SideProfile_Cut
All sketches fully defined, x/y per corner from origin, verified with a set_dimension round trip.

## Files
Solid\Aerobody_C_v2A_Faceted.SLDPRT, Aerobody_C_v2B_Faceted_LowLift.SLDPRT, Aerobody_C_v2C_Faceted_LowLift_LongTaper.SLDPRT
Shelled\ same names + _Shelled
Screenshots\ iso/top/side views + C_original_iso.png
CFD geometry (STEP + x_t of SOLIDS): Aero body\CFD\05_Geometry\C_v2\

## Open items / cautions
- Chamfer-strip variant was dropped for now: at the tail the wall is only ~43 mm tall so 40-60 mm chamfers collapse,
  and their benefit only shows in crosswind. Revisit in the yaw round.
- v2C is narrower behind x=1600 and v2B/v2C are lower at the tail (tail top y 288 vs 382): check roll cage/driver/battery fit.
- Sharp kinks can cost some drag vs fillets; CFD decides. Next: medium-mesh Fluent runs, same settings as A/B/C study.
