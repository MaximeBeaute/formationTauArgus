
/************************************************************************************************/
/*							Chargement de la macro sous sas										*/
/************************************************************************************************/
option mprint;
filename tauargus "U:\Mes documents\Workspace\legumes"; /* répertoire où se trouve la macro */
%include tauargus (Macro_Tau_Argus);

/************************************************************************************************/
/*					Le cas simple : appliquer le secret sur un tableau simple					*/
/************************************************************************************************/
%TAU_ARGUS (
tabsas			=	legumes,
library			=	U:\Mes documents\Workspace\legumes,
tabulation_1	=	a21 pays tomates);

/************************************************************************************************/
/*					Le cas simple : appliquer des règles de secret primaire différentes			*/
/************************************************************************************************/
%TAU_ARGUS (
tabsas					=	legumes,
library					=	U:\Mes documents\Workspace\legumes,
tabulation_1			=	a21 pays tomates,
primary_secret_rules	=	DOM P FREQ,
dom_k					=	80,
p_p						=	20,
frequency				=	11);
	
/************************************************************************************************/
/*					Le cas simple : appliquer le secret sur un tableau de comptage				*/
/************************************************************************************************/
%TAU_ARGUS (
tabsas			=	legumes,
library			=	U:\Mes documents\Workspace\legumes,
tabulation_1	=	a21 pays freq);

/************************************************************************************************/
/*					Le cas simple : appliquer le secret sur deux tableaux liés					*/
/************************************************************************************************/
%TAU_ARGUS (
tabsas			=	legumes,
library			=	U:\Mes documents\Workspace\legumes,
tabulation_1	=	a21 pays tomates,
tabulation_2	=	a21 cj tomates);

/************************************************************************************************/
/*	Le cas simple : appliquer le secret sur un tableau ventilant une variable "hiérarchique"	*/
/************************************************************************************************/
%TAU_ARGUS (
tabsas				=	legumes,
library				=	U:\Mes documents\Workspace\legumes,
tabulation_1		=	a88 tomates,
hierarchy_1			=	a10 a21 a88,
hierarchical_var	=	a88,
synthesis			=	yes);
/************************************************************************************************/
/*		Le cas complexe : appliquer le secret à un tableau contenant des cases négatives		*/
/************************************************************************************************/
option mprint;
filename tauneg "U:\Mes documents\Workspace\legumes"; /* répertoire où se trouve la macro */
%include tauneg (Macro_Tau_Argus_negatives);

%TAU_ARGUS_NEGATIVES (
library				=	U:\Mes documents\Workspace\legumes,
tabsas				=	legumes,
tabulation_1		=	nuts3 type_distrib pizzas,
tabulation_2		=	a88 nuts0 pizzas) ;

/************************************************************************************************/
/* Le cas complexe : appliquer le secret à des tableaux liés par une variable mais pas au même 	*/
/* niveaux d'agrégation																			*/
/************************************************************************************************/
libname legumes "U:\Mes documents\Workspace\legumes";

data legumes.legumes2;
	set legumes.legumes ;
	radis_round = round(radis,1);
run;

%TAU_ARGUS (
library				=	U:\Mes documents\Workspace\legumes,
tabsas				=	legumes2,
tabulation_1		=	nuts3 type_distrib radis_round,
tabulation_2		=	nuts2 a88 radis_round,
hierarchical_var	=	nuts2 nuts3,
hierarchy_1			=	nuts0 nuts1 nuts2 nuts3,
hierarchy_2			=	nuts0 nuts1 nuts2 ,
solver				=	,
outputtype			=	5) ;

%macro change_rda (library, tabulation,vardep, vararr);
	/* cette étape data permet de convertir la tabulation (ici "nuts2 a88 radis") en une version qui correspond au
	nom de la table sas associé, sans espace entre les variables ("nuts2_a88_radis").*/
	data _null_ ; 
		call symput ("output_name",compress(tranwrd(tranwrd(trim(tranwrd("&tabulation","_","*"))," ","_"),"*",""))) ; 
	run ; 
	proc import datafile	=	"&library.\TEMPORARY FILES MACRO\&output_name..rda" 
				out			=	rda
				dbms		=	dlm replace; 
				delimiter	=	'**'; 
				getnames	=	no; 
	RUN;

	data rda ;
		set rda ;
		if var1	=	"&vardep" then var1	=	"&vararr";
	run;

	data _null_ ; 
		call symput ("output_name2",tranwrd("&output_name","&vardep","&vararr")) ; 
	run ; 

	data _null_ ;
		File "&library.\TEMPORARY FILES MACRO\&output_name2..rda" dlm="" lrecl=200;
		set rda;
		Put (_all_)(+0);
	run;
 
	option noxwait xsync;
	X copy "&library.\TEMPORARY FILES MACRO\&output_name..tab"	"&library.\TEMPORARY FILES MACRO\&output_name2..tab";
%mend;
%change_rda (	
library		=	U:\Mes documents\Workspace\legumes,
tabulation	=	nuts2 a88 radis_round,
vardep		=	nuts2,
vararr		=	nuts3);

%TAU_ARGUS (
library				=	U:\Mes documents\Workspace\legumes,
input				=	tabledata,
tabulation_1		=	nuts3 type_distrib radis_round,
tabulation_2		=	nuts3 a88 radis_round) ;


/************************************************************************************************/
/* Le cas complexe : des tabulations liées non par les variables de ventilations mais par les 	*/
/* variables de réponse.																		*/
/************************************************************************************************/

/* solution 1 - on fait le secret sur un tableau, on appliquera le masque ainsi récupéré aux trois tableaux. */
%TAU_ARGUS (
tabsas				=	legumes, 
library				=	U:\Mes documents\Workspace\legumes,
tabulation_1		=	a88 cj legumes_rouges,
apriori_creation	=	yes);

/* solution 2 - on transforme les trois tableaux en un seul avec une variable supplémentaire pour renseigner sur le type de légume. */
libname legumes "U:\Mes documents\Workspace\legumes";

data legumes.legumes2 ;
	set legumes.legumes (in	=	leg_r	rename	=	(legumes_rouges	=	quantite))
		legumes.legumes (in	=	salad	rename	=	(salades	=	quantite));
	if leg_r	=	1 then type_leg	=	"legumes_rouges";
	if salad	=	1 then type_leg	=	"salades";
run;

proc sort 	data	=	legumes.legumes2 ; by ident ; run;

%TAU_ARGUS (
tabsas				=	legumes2, 
library				=	U:\Mes documents\Workspace\legumes,
tabulation_1		=	a88 cj type_leg quantite,
holding_var			=	ident );
