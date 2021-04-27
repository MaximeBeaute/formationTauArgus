/* Préparation des microdonnées pour obtenir le fichier plat de données tabulées .tab
Ce fichier sera au format optimal en entrée de Tau-Argus. */

libname Demo "V:\formation-confidentialite\02-Tau-Argus en pratique\02A-Partie demonstration\Donnees demonstration";

/************************************************************************************************************************/
/*											VERSION DONNEES TABULEES													*/
/************************************************************************************************************************/
/* Étape 1 : création de la tabulation */
/* Au préalable, on crée un variable de comptage "un" pour que la fréquence sous Tau-Argus prenne en compte le poids */

proc means data =  demo.Donnees_demo n sum max noprint ;
	var export ;
	class APE dep ;
	output out= ape_dep n=un sum = export max = max_export ;
run;

data ape_dep ; 
	set ape_dep ;
	if ape="" then a21 = "Total";
	if dep="" then dep="Total";
run;

/* Étape 2 : création du fichier plat */
data null;
File "V:\formation-confidentialite\02-Tau-Argus en pratique\02A-Partie demonstration\Donnees demonstration\donnees_demo_tabulees.tab" dsd dlm=';' ;
Set  ape_dep (keep=ape dep un export max_export);
Put ( _all_)(+0);
run;
