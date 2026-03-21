%language "C++"
%require "3.2"

%define api.value.type variant
%define parse.error verbose
%define api.namespace {ExprParser}
%define api.parser.class {Parser}

%parse-param {ExprParser::Lexer& lexer}
%parse-param {Expr*& ast}

%token KW_INT "int"
%token KW_VOID "void"
%token KW_IF "if"
%token KW_ELSE "else"
%token KW_WHILE "while"
%token KW_PRINT "print"
%token KW_DEF "def"
%token KW_RETURN "return"
%token KW_REF "ref"

%token OP_PLUS "+"
%token OP_MIN "-"
%token OP_MULT "*"
%token OP_DIV "/"
%token OP_MOD "%"
%token OP_EQ "=="
%token OP_NEQ "!="
%token OP_LESS "<"
%token OP_GREAT ">"
%token OP_LEQ "<="
%token OP_GEQ ">="
%token OP_AND "&&"
%token OP_OR "||"
%token OP_NOT "!"
%token OP_ASSIGN "="

%token SEMICOLON ";"
%token COMA ","
%token LPAREN "("
%token RPAREN ")"
%token LBRACKET "{"
%token RBRACKET "}"
%token <long> NUMBER "number"
%token <std::string> IDENTIFIER "identifier"

%right "!"
%left "*" "/" "%"
%left "+" "-"
%left "==" "!=" "<" ">" "<=" ">="
%left "&&" "||"
%right "="

%nterm <Expr*> expr
%nterm <Expr*> comparison
%nterm <Expr*> term
%nterm <Expr*> factor
%nterm <Expr*> unary
%nterm <Expr*> primary

%code requires {
#include "ExprAstParser.hpp"

namespace ExprParser {
    class Lexer;
}
}

%code {
#include <string>
#include <iostream>
#include "Lexer.hpp"

void ExprParser::Parser::error(const std::string &msg) {
    std::cerr << "Parse error: " << msg << std::endl;
}

#define yylex(p) lexer.nextToken(p)
}

%%

input:
      expr { ast = $1; }
;

expr:
      comparison { $$ = $1; }
;

comparison:
      comparison "<" term { $$ = new LessExpr($1, $3); }
    | comparison ">" term { $$ = new GreatExpr($1, $3); }
    | comparison "<=" term { $$ = new LeqExpr($1, $3); }
    | comparison ">=" term { $$ = new GeqExpr($1, $3); }
    | term { $$ = $1; }
;

term:
      term "+" factor { $$ = new AddExpr($1, $3); }
    | term "-" factor { $$ = new SubExpr($1, $3); }
    | factor          { $$ = $1; }
;

factor:
      factor "*" unary { $$ = new MultExpr($1, $3); }
    | factor "/" unary { $$ = new DivExpr($1, $3); }
    | factor "%" unary { $$ = new ModExpr($1, $3); }
    | unary            { $$ = $1; }
;

unary:
      "!" unary   { $$ = new NotExpr($2); }
    | "-" unary   { $$ = new NegExpr($2); }
    | primary     { $$ = $1; }
;

primary:
      "(" expr ")"     { $$ = $2; }
    | NUMBER           { $$ = new NumberVal($1); }
    | IDENTIFIER       { $$ = new IdVal($1); }
;
