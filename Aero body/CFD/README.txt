AEROBODY CFD - START HERE
=========================

OPEN THE BRIEF: 00_BRIEF\Aerobody_CFD_Brief.html  (double-click, opens in your browser)

Result: Tail C (single taper) Cd 0.0988, Tail B 0.0991, Tail A (Kamm) 0.1211.
B and C ~18% less drag than A (~150 W at 22 m/s). Recommendation: C (tie on drag, simpler to build).

00_BRIEF            the brief, results CSV, charts
01_Images_Fluent    15 Ansys Fluent images (A/B/C x 5 views)
02_Results_Data     solved case+data files, Cd history per iteration
03_Meshes           6 meshes
04_Setup_and_Batch  setup cases + 4_DOUBLE_CLICK_TO_RUN_CFD_BATCH.bat
05_Geometry         car bodies + air boxes (SolidWorks, STEP, Parasolid)
06_Logs             Fluent transcripts
07_Setup_Tools      connector installer + 3_DOUBLE_CLICK_TO_KILL_STUCK_FLUENT.bat
99_Archive_scratch  tests and temp files

Before opening Fluent next time: run 07_Setup_Tools\3_DOUBLE_CLICK_TO_KILL_STUCK_FLUENT.bat
(a background Fluent may still hold the Student license; it also locks the few loose .trn files here).
