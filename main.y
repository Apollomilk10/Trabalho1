%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void yyerror(char *c);
int yylex(void);

MULTC = 1;

%}

%token NUMERO SUM DIV PAROPEN PARCLOSE MULT EXP EOL
%left SUM
%left DIV
%left PAROPEN
%left PARCLOSE
%left MULT
%left EXP

%%
EXPRESSAO:
	PAROPEN EXPRESSAO PARCLOSE {		//se fechou os parenteses
		$$ = $2;
	} 
	| PAROPEN NUMERO PARCLOSE {		//se fechou os parenteses	
		$$ = $2;
	} 

	| NUMERO SUM EXPRESSAO {
		printf("LDMFD R13!, {R0}\n");
		printf("LDMFD R13!, {R1}\n");
		printf("ADD R0, R0, R1\n");
		printf("STMFD R13!, {R0}\n");
		$$ = $1+$3;
	}

	| NUMERO MULT EXPRESSAO {
		if($1 > 0 && $3 > 0) {
			printf("LDMFD R13!, {R1}\n");
			printf("LDMFD R13!, {R2}\n");
			printf("MOV R0, #0\n");
			printf("LOOP%d\n", mult_counter);
			printf("ADD R0, R0, R2\n");
			printf("SUBS R1, R1, #1\n");
			printf("BNE LOOP%d\n", mult_counter);
			printf("STMFD R13!, {R0}\n");
		} else if($1 < 0 && $3 > 0){
			printf("LDMFD R13!, {R1}\n");
			printf("LDMFD R13!, {R2}\n");
			printf("MOV R0, #0\n");
			printf("LOOP%d\n", mult_counter);
			printf("ADD R0, R0, R2\n");
			printf("SUBS R1, R1, #1\n");
			printf("BNE LOOP%d\n", mult_counter);
			printf("STMFD R13!, {R0}\n");		
		} else if($1 > 0 && $3 < 0){
			printf("LDMFD R13!, {R1}\n");
			printf("LDMFD R13!, {R2}\n");
			printf("MOV R0, #0\n");
			printf("LOOP%d\n", mult_counter);
			printf("ADD R0, R0, R1\n");
			printf("SUBS R2, R2, #1\n");
			printf("BNE LOOP%d\n", mult_counter);
			printf("STMFD R13!, {R0}\n");		
		} else {
			printf("LDMFD R13!, {R1}\n");
			printf("LDMFD R13!, {R2}\n");
			printf("MOV R4, #0\n");
			printf("SUB R1, R4, R1\n");
			printf("SUB R2, R4, R2\n");
			printf("MOV R0, #0\n");
			printf("CMP R1, #0\n");
			printf("BEQ ZERO%d\n", mult_counter);
			printf("CMP R2, #0\n");
			printf("BEQ ZERO%d\n", mult_counter);
			printf("LOOP%d\n", mult_counter);
			printf("ADD R0, R0, R2\n");
			printf("SUBS R1, R1, #1\n");
			printf("BNE LOOP%d\n", mult_counter);
			printf("ZERO%d\n", mult_counter);
			printf("STMFD R13!, {R0}\n");
		}
		$$ = $1*$3;
		MULTC++;
	}

%%

void yyerror(char *c){
}

int main(){

	yyparse();
	return 0;
