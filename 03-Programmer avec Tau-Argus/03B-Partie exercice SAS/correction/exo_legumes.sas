%let lib = U:\Documents\formationTauArgus\03-Programmer avec Tau-Argus\03B-Partie exercice SAS; /* Ma librairie de travail où se trouve la base de données légumes */
%let pathTauArgus = V:\Formations-Stats\Formation Tau-Argus\Formation Tau-Argus\03-Programmer avec Tau-Argus\03B-Partie exercice SAS\TauArgus.exe;
option mprint;
libname legumes "&lib";
filename tauargus "&lib"; /* répertoire où se trouve la macro */
%include tauargus (Macro_Tau_Argus);

/*  Q1  */
%TAU_ARGUS(
TauArgus_exe = &pathTauArgus,
TauArgus_version = opensource,
library = &lib,
tabsas = legumes,
tabulation_1 = pays a21 tomates);

/* Q2 */
%TAU_ARGUS(
TauArgus_exe = &pathTauArgus,
TauArgus_version = opensource,
library = &lib,
tabsas = legumes,
tabulation_1 = pays a21 tomates,
primary_secret_rules = DOM P FREQ,
dom_k = 80,
p_p = 20,
frequency = 11);

/* Q3 */
%TAU_ARGUS(
TauArgus_exe = &pathTauArgus,
TauArgus_version = opensource,
library = &lib,
tabsas = legumes,
tabulation_1 = pays a21 FREQ);

/* Q4 */
%TAU_ARGUS(
library = &lib,
tabsas = legumes,
tabulation_1 = pays a21 tomates,
tabulation_2 = cj a21 tomates);

/* Q5 */
%TAU_ARGUS(
TauArgus_exe = &pathTauArgus,
TauArgus_version = opensource,
library = &lib,
tabsas = legumes,
tabulation_1 = a88 tomates,
hierarchical_var = a88,
hierarchy_1 = a10 a21 a88);
