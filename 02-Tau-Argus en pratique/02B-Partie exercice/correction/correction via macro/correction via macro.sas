/* V:\Formations-Stats\Formation Tau-Argus\Formation Tau-Argus\02-Tau-Argus en pratique\02B-Partie exercice\correction\correction via macro */


option mprint;
filename tauargus "V:\Formations-Stats\Formation Tau-Argus\Formation Tau-Argus\03-Programmer avec Tau-Argus\03B-Partie exercice SAS"; /* répertoire où se trouve la macro */
%include tauargus (Macro_Tau_Argus);

/************************************************/
/*					questions 1 et 2			*/
/************************************************/

libname exo "V:\Formations-Stats\Formation Tau-Argus\Formation Tau-Argus\02-Tau-Argus en pratique\02B-Partie exercice";

data exo.donnees_entreprises_usa_macro ;
	set exo.donnees_exercice ;
	mois=substr(mois_de_vente,1,3);
	if mois in("jan" "feb" "mar") then trim="T1";
	if mois in("apr" "may" "jun") then trim="T2";
	if mois in("jul" "aug" "sep") then trim="T3";
	if mois in("oct" "nov" "dec") then trim="T4";
	if produit in ("Produit1" "Produit2" "Produit3") then p2="P1-3";
	if produit in ("Produit4" "Produit5" "Produit6") then p2="P4-6";
	if produit in ("Produit7" "Produit8" "Produit9") then p2="P7-9";
run;

%TAU_ARGUS (
	tabsas			=	donnees_entreprises_usa_macro,
	library			=	V:\Formations-Stats\Formation Tau-Argus\Formation Tau-Argus\02-Tau-Argus en pratique\02B-Partie exercice,
	tabulation_1	=	etat produit ventes_part,
	tabulation_2	=	etat mois_de_vente ventes_commerces,
	tabulation_3	=	mois produit freq,
	hierarchical_var=	mois produit,
	hierarchy_1		=	p2 produit,
	hierarchy_2		=	trim mois,
	weight_var		=	poids_ent,
	TauArgus_exe	=	Y:\Logiciels\TauArgus\TauArgus4.1.7b4\TauArgus.exe,
	TauArgus_version=	opensource);

/************************************************/
/*					question 5					*/
/************************************************/
%TAU_ARGUS (
	tabsas			=	donnees_entreprises_usa_macro,
	library			=	V:\Formations-Stats\Formation Tau-Argus\Formation Tau-Argus\02-Tau-Argus en pratique\02B-Partie exercice,
	tabulation_1	=	etat produit ventes_part,
	tabulation_2	=	etat mois_de_vente ventes_part,
	tabulation_3	=	mois produit ventes_part,
	hierarchical_var=	mois produit,
	hierarchy_1		=	p2 produit,
	hierarchy_2		=	trim mois,
	weight_var		=	poids_ent,
	TauArgus_exe	=	Y:\Logiciels\TauArgus\TauArgus4.1.7b4\TauArgus.exe,
	TauArgus_version=	opensource);
