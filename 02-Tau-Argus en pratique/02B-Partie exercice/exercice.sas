/*** Accès aux données SAS et création des microdonnées pour l'entrée dans Tau-Argus ***/

/* Préparation des microdonnées pour obtenir le fichier plat .asc
Ce fichier sera au format optimal en entrée de Tau-Argus. ***/

libname prod "\\HNAS-AUS2\Espert\IDEP\Mes documents\Workspace\Exercice d'application Tau Argus";

/************************************************************************************************************************/
/************************************************************************************************************************/
/************************************************************************************************************************/
/*											VERSION MICRO DONNEES														*/
/************************************************************************************************************************/
/************************************************************************************************************************/
/************************************************************************************************************************/

/** Étape 1 : conversion en caractère (si ce n'est déjà fait) des variables qu'on agrège dans les tableaux et des autres
éventuelles variables numériques (ici, la variable de pondération) **/

/* Au préalable, on vérifie la longueur max des variables numériques */
proc means data = prod.donnees_entreprises_usa max ;
proc means data = prod.donnees_entreprises_usa max ;
	var Ventes_Part Ventes_Commerces Total_Ventes poids_ent ;
run;
data microDonnees;
	set prod.donnees_entreprises_usa;

	/* afin d'éviter les soucis avec le fichier de hiérarchie, on fait en sorte que toutes les modalités aient la même longueur*/
	mois=substr(mois_de_vente,1,3);

	/* Poids entier à 2 chiffre */
	poids 			= 	put(poids_ent, 2.);

	/* Trois variables entières à 6 chiffres max */
	Ventes_Partt 		= 	put(Ventes_Part, 6.0);
	Ventes_Commercess 	= 	put(Ventes_Commerces, 6.0);
	Total_Ventess 		= 	put(Total_Ventes, 6.0);
run;

/** Étape 2 : création du fichier plat **/
filename asc "\\HNAS-AUS2\Espert\IDEP\Mes documents\Workspace\Exercice d'application Tau Argus\microdonnees_entreprises_usa.asc";
data _NULL_;
	set microdonnees;
	file asc;
	/* On décrit la structure du fichier avec le nombre de caractères désirés pour 
	chaque variable (avec au moins un espace entre chaque variable) */
	put 
		etat 				1-2 		
		Produit 			4-11 		
		mois 				13-15 		
		Poids 				17-18
		Ventes_Partt 		20-25
		Ventes_Commercess 	27-32 
		Total_Ventess 		34-39 ;
run;

