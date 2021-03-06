%{
/* need this for the call to atof() below */
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int k=1;
struct node
{
   int index;
   char id[300]; 
}list[100];
 
%}

%x C_COMMENT

digit [0-9]
digits [0-9]+

/*RELOP	 " && " | "||" | " < " | " > " | " == " | " + " | " - " | " * " | " / " | " % "*/

%%

"public"|"private"|"static"|"void"|"main"|"if"|"then"|"else"|"printf"|"int"|"boolean"|"extends"|"float"|"double"|"void"|"assert"|"while"|"System"|"out"|"println"|"return"|"this"    							{printf( "A keyword: %s\n", yytext );check("key");}
[a-zA-Z]([a-zA-Z]|[0-9]|_)*        		{printf( "An identifier: %s\n", yytext );check("id");}
[+-]?{digits}(.{digits})?([E][-+]?{digits})?    	{printf("A number: %s\n",yytext);check("num");}
["&&"|"||"|"<"|">"|"=="|"+"|"-"|"*"|"/"|"%"] 	{printf( "A binary operator: %s\n", yytext );check("binary operator");}
[\[|\{|\(|\}|\]|\)]		{printf( "A binary operator: %s\n", yytext );check("binary operator");}
[ \t\n]+         			 	/* eat up whitespace */
"//".*         				 	/* eat  */
"/*"            			 	{ BEGIN(C_COMMENT); }
<C_COMMENT>"*/"				 	{ BEGIN(INITIAL); }
<C_COMMENT>.   				 	{ }
[;]						/*eat*/
[.]						/*eat*/



%%
 check(char typ[])
{
   int pos = Exists(yytext,k);
   if(pos==0)
	{
		list[k-1].index = k;
                strcpy(list[k-1].id,yytext);
                printf("<%s,%s,%d>\n",typ,list[k-1].id,list[k-1].index);
                k++;
	}
   else
	{
		printf("Already Exist -> <%s,%s,%d>\n",typ,yytext,pos);
	}
}

Exists(char arr[],int kount)
{
    int j=0;
    int pos = -1;
    for(j=0;j<kount;j++)
    {
        if(strcmp(arr,list[j].id)==0)
        {
            pos = j;
        }
    }
    return pos+1;
}

main( argc, argv )
    {

            FILE *fr = fopen( "binarySearch.java", "r" );
if(fr==NULL)
{
   printf("Error in openning file!!!");
   return -1;
}
yyin=fr;
    yylex();
int x;
printf("\n***Symbol Table***\n");
	for(x=0;x<k-1;x++)
	{
		printf("<%s,%d>\n",list[x].id,list[x].index);
	}
return 0;
 }
