%language "C++"
%require "3.2"

%define api.value.type variant
%define parse.error verbose
%define api.namespace {AstParser}
%define api.parser.class {Parser}

%parse-param {AstParser::Lexer& lexer}
%parse-param {ProgramNode*& ast}

%token KW_INT "int"
%token KW_VOID "void"
%token KW_IF "if"
%token KW_ELSE "else"
%token KW_WHILE "while"
%token KW_PRINT "print"
%token KW_DEF "def"
%token KW_RETURN "return"
%token KW_REF "ref"

%token OP_ARROW "->"
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

%nterm <ProgramNode*> program
%nterm <StmtList*> global
%nterm <Stmt*> declaration
%nterm <Stmt*> varDecl
%nterm <Stmt*> funcDecl
%nterm <ParamList*> paramList
%nterm <Param*> param

%nterm <Stmt*> stmt
%nterm <Stmt*> assignment
%nterm <Stmt*> ifStmt
%nterm <Stmt*> whileStmt
%nterm <Stmt*> printStmt
%nterm <Stmt*> returnStmt
%nterm <Stmt*> exprStmt
%nterm <Stmt*> block
%nterm <StmtList*> stmtList

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
%nterm <ArgList*> argList

%code requires {
#include "Ast.hpp"

namespace AstParser {
    class Lexer;
}
}

%code {
#include <string>
#include <iostream>
#include "Lexer.hpp"

void AstParser::Parser::error(const std::string &msg) {
    std::cerr << "Parse error: " << msg << std::endl;
}

#define yylex(p) lexer.nextToken(p)
}

%%

input:
      program { ast = $1; }
;

program:
      global { $$ = new ProgramNode($1); }
;

global:
      /* empty */        { $$ = nullptr; }
    | global declaration { $$ = new StmtList($2, $1); }
;

declaration:
      varDecl   { $$ = $1; }
    | funcDecl  { $$ = $1; }
;

varDecl:
      "int" IDENTIFIER "=" expr ";" { $$ = new VarDecl($2,$4); }
    | "int" IDENTIFIER ";"          { $$ = new VarDecl($2,nullptr); }
;

funcDecl:
      "def" IDENTIFIER "(" paramList ")" "->" "int" block   { $$ = new FuncDecl($2,$4,true,$8); }
    | "def" IDENTIFIER "(" paramList ")" "->" "void" block  { $$ = new FuncDecl($2,$4,false,$8); }
    | "def" IDENTIFIER "("  ")" "->" "int" block            { $$ = new FuncDecl($2,nullptr,true,$7); }
    | "def" IDENTIFIER "("  ")" "->" "void" block           { $$ = new FuncDecl($2,nullptr,false,$7); }
;

paramList:
      paramList "," param { $$ = new ParamList($3, $1); }
    | param               { $$ = new ParamList($1, nullptr); }
;

param:
      "int" "ref" IDENTIFIER { $$ = new Param($3, true); }
    | "int" IDENTIFIER       { $$ = new Param($2, false); }
;

// Statments
stmt:
      varDecl    { $$ = $1; }
    | assignment { $$ = $1; }
    | ifStmt     { $$ = $1; }
    | whileStmt  { $$ = $1; }
    | printStmt  { $$ = $1; }
    | returnStmt { $$ = $1; }
    | exprStmt   { $$ = $1; }
    | block      { $$ = $1; }
;

assignment:
    IDENTIFIER "=" expr ";"  { $$ = new AssignStmt($1,$3); }
;

ifStmt:
      "if" "(" expr ")" stmt                  { $$ = new IfStmt($3,$5,nullptr); }
    | "if" "(" expr ")" stmt "else" stmt      { $$ = new IfStmt($3,$5,$7); }
;

whileStmt:
    "while" "(" expr ")" stmt { $$ = new WhileStmt($3,$5); }
;

printStmt:
    "print" "(" expr ")" ";" { $$ = new PrintStmt($3); }
;

returnStmt:
      "return" expr ";" { $$ = new ReturnStmt($2); }
    | "return" ";"      { $$ = new ReturnStmt(nullptr); }
;

exprStmt:
    expr ";" { $$ = new ExprStmt($1); }
    // | funcCall ";" { $$ = new ExprStmt($1); }
;

block:
    "{" stmtList "}" { $$ = new Block($2); }
;

stmtList:
      /* Empty Block */  { $$ = nullptr; }
    | stmtList stmt      { $$ = new StmtList($2, $1); }
;

// Expressions
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
      comparison "<" term  { $$ = new LessExpr($1, $3); }
    | comparison ">" term  { $$ = new GreatExpr($1, $3); }
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
      IDENTIFIER "(" ")"          { $$ = new FuncCall($1, nullptr); }
    | IDENTIFIER "(" argList ")"  { $$ = new FuncCall($1, $3); }
;

argList:
      argList "," expr   { $$ = new ArgList($3, $1); }
    | expr               { $$ = new ArgList($1, nullptr); }
;
