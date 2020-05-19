
%{
#include <stdlib.h>
void yyerror(char *);

#include "y.tab.h"
%}


%%

[0-9]+ {
            yylval = atoi(yytext);
            return NUMER0;
        }

[+] {return SUM;}

[ \ ] {return DIV;} 

[\(] {return PAROPEN;}

[\)] {return PARCLOSE;}

[*] {return MULT;}

[^] {retunt EXP;}

\n {return EOL;}


[ \t]+ ;

. {yyerror("Error\n");}

%%

int yywrap() {
  return 1;
}

