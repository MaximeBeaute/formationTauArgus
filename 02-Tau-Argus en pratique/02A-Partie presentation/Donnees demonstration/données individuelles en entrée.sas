/* Préparation des microdonnées pour obtenir le fichier plat .asc
Ce fichier sera au format optimal en entrée de Tau-Argus. */

libname Demo "V:\formation-confidentialite\02-Tau-Argus en pratique\02A-Partie demonstration\Donnees demonstration";

/************************************************************************************************************************/
/*											VERSION MICRODONNEES														*/
/************************************************************************************************************************/


/* Étape 1 : conversion en caractère (si ce n'est déjà fait) des variables qu'on agrège dans les tableaux et des autres
éventuelles variables numériques (ici, la variable de pondération) */

data microDonnees;
	set demo.Donnees_demo;
	poids 		= 	put(poids_Sondage, 6.1);	
	exportt 	= 	put(export, 10.1);
run;

/* Étape 2 : création du fichier plat */
filename asc "V:\formation-confidentialite\02-Tau-Argus en pratique\02A-Partie demonstration\Donnees demonstration\Donnees_demo.asc";
data _NULL_;
	set microdonnees;
	file asc;
	/* On décrit la structure du fichier avec le nombre de caractères désirés pour 
	chaque variable (avec au moins un espace entre chaque variable) */
	put 
		treff			 1-4 
		APE			 	 6-11 
		dep 			13-14 
		poids 			16-21
		exportt			23-32 ;
run;
