DATA ape_dep_export;
	INFILE "V:\formation-confidentialite\02-Tau-Argus en pratique\02A-Partie demonstration\Donnees demonstration\ape_dep_export.sbs" 
	firstobs=1 dlm=',' dsd missover;
	/* pour les variables caractères */
	length 
			APE $6 
			DEP $5 
			FLAG $1		; 
	input APE DEP EXPORT  FREQ FLAG DOMINANCE ;
run;

