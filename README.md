# Normalitásvizsgálat

A Github repository az alábbi fájlrendszert tartalmazza:
### 1. Matlab replikáló kód: 
  - Normalitástesztek implementációja
  - Normalitásvizsgálathoz szükséges függvények
  - Replikáló kód
### 2. Output xlsx file-ok:
  - Szimulált minták a 20 eloszlásra és a 4 kevert eloszlásra ('d...xlsx')
    - (d1 - d20) file-ok a 20 eloszlást tartalmazzák. 
    - (d21 - d24) file-ok a kevert eloszlásokat tartalmazzák az alábbi sorrendben:
      * d21: 5%-ban kevert, N(0,9) eloszlással
      * d22: 5%-ban kevert, N(3, 1) eloszlással
      * d23: 10%-ban kevert, N(0,9) eloszlással
      * d24: 10%-ban kevert, N(3,1) eloszlással
    - (A 'd...xlsx' file-okban az eloszlások sorrendje a testDistributions.mat és a contaminatedDist, simulatedDistributions Matlab file-ok alapján ellenőrizhető).
  - Szimulált minták alapján képzett négy csoport ('g...xlsx').
  - Szimulált kritikus értékek. A kritikus értékek 1-10 sorai az n = 10, 20, 30, ..., 100-as elemszámú mintára vonatkoznak. Minden elemszámra m = 50 000 darab $\mathcal{N}(0,1)$ eloszlású minta volt szimulálva, ami összesen 500 000 minta. Az eredmények az oszlopok szerint az alábbi tesztekhez tartoznak:
    - Shapiro-Wilk teszt
    - Shapiro-Francia teszt
    - Anderson-Darling teszt
    - Cramér-von Mises teszt
    - Kolmogorov-Smirnov-teszt
    - D'Agostino-Pearson teszt
    - Vasicek teszt
    - Khí-négyzet teszt
    - (A simulatedCriticalValues.mat és a criticalValue Matlab függvény segítségével ellenőrizhető a sorrend.
  - A tesztek statisztikai ereje az elemszám függvényében eloszlásonként ('p...xlsx').
    - Az oszlopok az elemszám változását mutatják n = 10, 20, 30, ..., 100-ig.
    - Az sorokban az egyes normalitástesztek találhatóak a kritikus értékek táblázattal egyező sorrendben (1. Shapiro-Wilk teszt, utolsó a Khí-négyzet teszt).
    - (A sorrend a normalityTests.mat file alapján ellenőrizhető.)
  - A tesztek statisztikai ereje az elemszám függvényében eloszláscsoportonként ('pgroup...xlsx').
