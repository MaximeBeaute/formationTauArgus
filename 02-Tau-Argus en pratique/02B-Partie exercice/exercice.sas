/*** Acc�s aux donn�es SAS et cr�ation des microdonn�es pour l'entr�e dans Tau-Argus ***/

/* Pr�paration des microdonn�es pour obtenir le fichier plat .asc
Ce fichier sera au format optimal en entr�e de Tau-Argus. ***/

libname prod "\\HNAS-AUS2\Espert\IDEP\Mes documents\Workspace\Exercice d'application Tau Argus";

/************************************************************************************************************************/
/************************************************************************************************************************/
/************************************************************************************************************************/
/*											VERSION MICRO DONNEES														*/
/************************************************************************************************************************/
/************************************************************************************************************************/
/************************************************************************************************************************/

/** �tape 1 : conversion en caract�re (si ce n'est d�j� fait) des variables qu'on agr�ge dans les tableaux et des autres
�ventuelles variables num�riques (ici, la variable de pond�ration) **/

/* Au pr�alable, on v�rifie la longueur max des variables num�riques */
proc means data = prod.donnees_entreprises_usa max ;
proc means data = prod.donnees_entreprises_usa max ;
	var Ventes_Part Ventes_Commerces Total_Ventes poids_ent ;
run;
data microDonnees;
	set prod.donnees_entreprises_usa;

	/* afin d'�viter les soucis avec le fichier de hi�rarchie, on fait en sorte que toutes les modalit�s aient la m�me longueur*/
	mois=substr(mois_de_vente,1,3);

	/* Poids entier � 2 chiffre */
	poids 			= 	put(poids_ent, 2.);

	/* Trois variables enti�res � 6 chiffres max */
	Ventes_Partt 		= 	put(Ventes_Part, 6.0);
	Ventes_Commercess 	= 	put(Ventes_Commerces, 6.0);
	Total_Ventess 		= 	put(Total_Ventes, 6.0);
run;

/** �tape 2 : cr�ation du fichier plat **/
filename asc "\\HNAS-AUS2\Espert\IDEP\Mes documents\Workspace\Exercice d'application Tau Argus\microdonnees_entreprises_usa.asc";
data _NULL_;
	set microdonnees;
	file asc;
	/* On d�crit la structure du fichier avec le nombre de caract�res d�sir�s pour 
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

