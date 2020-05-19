%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void yyerror(char *c);
int yylex(void);

%}

%token NUMERO SUM DIV PAROPEN PARCLOSE MULT EXP EOL
%left SUM
%left DIV
%left PAROPEN
%left PARCLOSE
%left MULT
%left EXP

%%

%%

void yyerror(char *c){
}

int main(){

	yyparse();
	return 0;