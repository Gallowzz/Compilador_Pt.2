%language "C++"
%require "3.2"

%define api.value.type variant
%define parse.error verbose
%define api.namespace {ExprParser}
%define api.parser.class {Parser}

%parse-param {ExprParser::Lexer& lexer}
%parse-param {Expr*& ast}

%token OP_PLUS "+"
%token OP_MULT "*"
%token OPEN_PAR "("
%token CLOSE_PAR ")"
%token <long> NUMBER "number"
%token <std::string> IDENTIFIER "identifier"

%nterm <Expr*> expr
%nterm <Expr*> term
%nterm <Expr*> factor

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
      expr OP_PLUS term { $$ = new AddExpr($1, $3); }
    | term          { $$ = $1; }
;

term:
      term OP_MULT factor { $$ = new MultExpr($1, $3); }
    | factor          { $$ = $1; }
;

factor:
      OPEN_PAR expr CLOSE_PAR { $$ = $2; }
    | NUMBER                  { $$ = new NumberVal($1); }
;
