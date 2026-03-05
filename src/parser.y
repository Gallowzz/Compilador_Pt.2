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

%nterm <AstNode*> program
%nterm <Stmt*> declaration
%nterm <Stmt*> funcDecl
%nterm <AstNode*> paramList
%nterm <AstNode*> param

%nterm <Stmt*> statement
%nterm <Stmt*> varDecl
%nterm <Stmt*> assignment
%nterm <Stmt*> ifStmt
%nterm <Stmt*> whileStmt
%nterm <Stmt*> printStmt
%nterm <Stmt*> returnStmt
%nterm <Stmt*> exprStmt
%nterm <Stmt*> block
%nterm <Stmt*> stmtList

%nterm <Expr*> expr
%nterm <Expr*> logicalOr
%nterm <Expr*> logicalAnd
%nterm <Expr*> equality
%nterm <Expr*> comparison
%nterm <Expr*> term
%nterm <Expr*> factor
%nterm <Expr*> unary
%nterm <Expr*> primary
%nterm <Expr*> funcCall
%nterm <Expr*> argList

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
    program { ast = $1; }
;


program:
      /* empty */ { $$ = new ProgramNode(); }
    | program declaration { $$ = $1; }
;

declaration:
      varDecl  { $$ = $1; }
    | funcDecl { $$ = $1; }
;

varDecl:
      "int" IDENTIFIER "=" expr ";" { $$ = new VarDeclNode($2,$4); }
    | "int" IDENTIFIER ";"          { $$ = new VarDeclNode($2,nullptr); }
;

funcDecl:
      "def" IDENTIFIER "(" paramList ")" "->" "int" block   { $$ = new FuncDeclNode($2,$4,true,$7); }
    | "def" IDENTIFIER "(" paramList ")" "->" "void" block  { $$ = new FuncDeclNode($2,$4,false,$7); }
    | "def" IDENTIFIER "("  ")" "->" "int" block            { $$ = new FuncDeclNode($2,nullptr,true,$7); }
    | "def" IDENTIFIER "("  ")" "->" "void" block           { $$ = new FuncDeclNode($2,nullptr,false,$6); }
;

paramList:
      paramList "," param { $$ = $1; }
    | param               { $$ = new ParamListNode($1); }
;

param:
      "int" "ref" IDENTIFIER { $$ = new ParamNode($3, true); }
    | "int" IDENTIFIER       { $$ = new ParamNode($2, false); }
;


statement:
      varDecl
    | assignment
    | ifStmt
    | whileStmt
    | printStmt
    | returnStmt
    | exprStmt
    | block
;

assignment:
    IDENTIFIER "=" expr ";"  { $$ = new AssignStmt($1,$3); }
;

ifStmt:
      "if" "(" expr ")" statement "else" statement { $$ = new IfStmt($3,$5,$7); }
    | "if" "(" expr ")" statement                  { $$ = new IfStmt($3,$5,nullptr); }
;

whileStmt:
    "while" "(" expr ")" statement { $$ = new WhileStmt($3,$5); }
;

printStmt:
    "print" "(" expr ")" ";" { $$ = new PrintStmt($3); }
;

returnStmt:
      "return" expr ";" { $$ = new ReturnStmt($2); }
    | "return" ";"      { $$ = new ReturnStmt(nullptr); }
;

exprStmt:
    funcCall ";" { $$ = new ExprStmt($1); }
;

block:
    "{" stmtList "}" { $$ = $2; }
;

stmtList:
      /* empty */        { $$ = new BlockNode(); }
    | stmtList statement { $1->addStmt($2); $$ = $1}
;

expr:
      logicalOr { $$ = $1; }
;

logicalOr:
      logicalOr "||" logicalAnd { $$ = new OrExpr($1, $3); }
    | logicalAnd { $$ = $1; }
;

logicalAnd:
    logicalAnd "&&" equality { $$ = new AndExpr($1, $3); }
  | equality { $$ = $1; }
;

equality:
    equality "==" comparison { $$ = new EqExpr($1, $3); }
  | equality "!=" comparison { $$ = new NeqExpr($1, $3); }
  | comparison { $$ = $1; }
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
    | funcCall         { $$ = $1; }
;

funcCall:
      IDENTIFIER "(" ")"         { $$ = new FuncCallExpr($1, nullptr); }
    | IDENTIFIER "(" argList ")" { $$ = new FuncCallExpr($1, $3); }
;

argList:
      argList "," expr { $$ = new ArgListExpr($1,$3); }
    | expr             { $$ = new ArgListExpr($1, nullptr); }
;
