/* Pr�paration des microdonn�es pour obtenir le fichier plat .asc
Ce fichier sera au format optimal en entr�e de Tau-Argus. */

libname Demo "V:\formation-confidentialite\02-Tau-Argus en pratique\02A-Partie demonstration\Donnees demonstration";

/************************************************************************************************************************/
/*											VERSION MICRODONNEES														*/
/************************************************************************************************************************/


/* �tape 1 : conversion en caract�re (si ce n'est d�j� fait) des variables qu'on agr�ge dans les tableaux et des autres
�ventuelles variables num�riques (ici, la variable de pond�ration) */

data microDonnees;
	set demo.Donnees_demo;
	poids 		= 	put(poids_Sondage, 6.1);	
	exportt 	= 	put(export, 10.1);
run;

/* �tape 2 : cr�ation du fichier plat */
filename asc "V:\formation-confidentialite\02-Tau-Argus en pratique\02A-Partie demonstration\Donnees demonstration\Donnees_demo.asc";
data _NULL_;
	set microdonnees;
	file asc;
	/* On d�crit la structure du fichier avec le nombre de caract�res d�sir�s pour 
	chaque variable (avec au moins un espace entre chaque variable) */
	put 
		treff			 1-4 
		APE			 	 6-11 
		dep 			13-14 
		poids 			16-21
		exportt			23-32 ;
run;
