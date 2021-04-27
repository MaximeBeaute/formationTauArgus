
/************************************************************************************************/
/*							Chargement de la macro sous sas										*/
/************************************************************************************************/
option mprint;
filename tauargus "U:\tests macro pour intranet"; /* r�pertoire o� se trouve la macro */
%include tauargus (Macro_Tau_Argus);

/************************************************************************************************/
/*					Le cas simple : appliquer le secret sur un tableau simple					*/
/************************************************************************************************/
%TAU_ARGUS (
TauArgus_exe			=	U:\tau-argus 4.1.6\TauArgus.exe,
TauArgus_version		=	opensource,
solver					=	modular,
tabsas					=	legumes,
library					=	U:\tests macro pour intranet,
tabulation_1			=	a21 pays tomates);

/************************************************************************************************/
/*					Le cas simple : appliquer des r�gles de secret primaire diff�rentes			*/
/************************************************************************************************/
%TAU_ARGUS (
TauArgus_exe			=	U:\tau-argus 4.1.6\TauArgus.exe,
TauArgus_version		=	opensource,
solver					=	modular /*ou optimal*/,
tabsas					=	legumes,
library					=	U:\tests macro pour intranet,
tabulation_1			=	a21 pays tomates,
primary_secret_rules	=	DOM P FREQ,
dom_k					=	80,
p_p						=	20,
frequency				=	11);
	
/************************************************************************************************/
/*					Le cas simple : appliquer le secret sur un tableau de comptage				*/
/************************************************************************************************/
%TAU_ARGUS (
TauArgus_exe		=	U:\tau-argus 4.1.6\TauArgus.exe,
TauArgus_version	=	opensource,
solver				=	modular,
tabsas				=	legumes,
library				=	U:\tests macro pour intranet,
tabulation_1		=	a21 pays freq);

/************************************************************************************************/
/*					Le cas simple : appliquer le secret sur deux tableaux li�s					*/
/************************************************************************************************/
%TAU_ARGUS (
TauArgus_exe		=	U:\tau-argus 4.1.6\TauArgus.exe,
TauArgus_version	=	opensource,
/*pour cet exemple, Modular ne fonctione pas. On se contentera du solver hypercube (pas besoin de le
pr�ciser dans les param�tres, il y est par d�faut*/
tabsas				=	legumes,
library				=	U:\tests macro pour intranet,
tabulation_1		=	a21 pays tomates,
tabulation_2		=	a21 cj tomates);

/************************************************************************************************/
/*	Le cas simple : appliquer le secret sur un tableau ventilant une variable "hi�rarchique"	*/
/************************************************************************************************/
%TAU_ARGUS (
TauArgus_exe		=	U:\tau-argus 4.1.6\TauArgus.exe,
TauArgus_version	=	opensource,
solver				=	modular,
tabsas				=	legumes,
library				=	U:\tests macro pour intranet,
tabulation_1		=	a88 tomates,
hierarchy_1			=	a10 a21 a88,
hierarchical_var	=	a88);

/************************************************************************************************/
/*		Le cas complexe : appliquer le secret � un tableau contenant des cases n�gatives		*/
/************************************************************************************************/
option mprint;
filename tauneg "U:\tests macro pour intranet"; /* r�pertoire o� se trouve la macro */
%include tauneg (Macro_Tau_Argus_negatives);

%TAU_ARGUS_NEGATIVES (
TauArgus_exe		=	U:\tau-argus 4.1.6\TauArgus.exe,
TauArgus_version	=	opensource,
library				=	U:\tests macro pour intranet,
tabsas				=	legumes,
tabulation_1		=	nuts3 type_distrib pizzas,
tabulation_2		=	a88 nuts0 pizzas) ;

/************************************************************************************************/
/* Le cas complexe : appliquer le secret � des tableaux li�s par une variable mais pas au m�me 	*/
/* niveaux d'agr�gation																			*/
/************************************************************************************************/
libname legumes "U:\tests macro pour intranet";

data legumes.legumes2;
	set legumes.legumes ;
	radis_round = round(radis,1);
run;

%TAU_ARGUS (
TauArgus_exe		=	U:\tau-argus 4.1.6\TauArgus.exe,
TauArgus_version	=	opensource,
library				=	U:\tests macro pour intranet,
tabsas				=	legumes2,
tabulation_1		=	nuts3 type_distrib radis_round,
tabulation_2		=	nuts2 a88 radis_round,
hierarchical_var	=	nuts2 nuts3,
hierarchy_1			=	nuts0 nuts1 nuts2 nuts3,
hierarchy_2			=	nuts0 nuts1 nuts2 ,
solver				=	,
outputtype			=	5) ;

/* ATTENTION - j'ai pu observer un bug lors de l'ex�cution de l'�tape pr�c�dente, l'output du batch �tant parfois incomplet (le fichier .rda cens� 
accompagn� la tabulation_2 n'�tant pas g�n�r�, ce qui n'est pas normal) et parfois complet. Bien v�rifier dans le r�pertoire TEMPORARY FILES MACRO,
qu'un fichier ".rda" accompagne bien chaque tabulation. SI ce n'est pas le cas, refaire tourner l'�tape.*/

%macro change_rda (library, tabulation,vardep, vararr);
	/* cette �tape data permet de convertir la tabulation (ici "nuts2 a88 radis") en une version qui correspond au
	nom de la table sas associ�, sans espace entre les variables ("nuts2_a88_radis").*/
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
library		=	U:\tests macro pour intranet,
tabulation	=	nuts2 a88 radis_round,
vardep		=	nuts2,
vararr		=	nuts3);

%TAU_ARGUS (
TauArgus_exe		=	U:\tau-argus 4.1.6\TauArgus.exe,
TauArgus_version	=	opensource,
solver				=	modular,
library				=	U:\tests macro pour intranet,
input				=	tabledata,
tabulation_1		=	nuts3 type_distrib radis_round,
tabulation_2		=	nuts2 a88 radis_round) ;


/************************************************************************************************/
/* Le cas complexe : des tabulations li�es non par les variables de ventilations mais par les 	*/
/* variables de r�ponse.																		*/
/************************************************************************************************/

/* solution 1 - on fait le secret sur un tableau, on appliquera le masque ainsi r�cup�r� aux trois tableaux. */
%TAU_ARGUS (
TauArgus_exe		=	U:\tau-argus 4.1.6\TauArgus.exe,
TauArgus_version	=	opensource,
solver				=	modular,
tabsas				=	legumes, 
library				=	U:\tests macro pour intranet,
tabulation_1		=	a88 cj legumes_rouges,
apriori_creation	=	yes);

/* solution 2 - on transforme les trois tableaux en un seul avec une variable suppl�mentaire pour renseigner sur le type de l�gume. */
libname legumes "U:\tests macro pour intranet";

data legumes.legumes2 ;
	set legumes.legumes (in	=	leg_r	rename	=	(legumes_rouges	=	quantite))
		legumes.legumes (in	=	salad	rename	=	(salades	=	quantite));
	if leg_r	=	1 then type_leg	=	"legumes_rouges";
	if salad	=	1 then type_leg	=	"salades";
run;

proc sort 	data	=	legumes.legumes2 ; by ident ; run;

%TAU_ARGUS (
TauArgus_exe		=	U:\tau-argus 4.1.6\TauArgus.exe,
TauArgus_version	=	opensource,
solver				=	modular,
tabsas				=	legumes2, 
library				=	U:\tests macro pour intranet,
tabulation_1		=	a88 cj type_leg quantite,
holding_var			=	ident );
