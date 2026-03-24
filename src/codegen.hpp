#pragma once
#include <string>

class genResult {
public:
    std::string code;
    std::string place;

    genResult(std::string c = "", std::string p = "")
        : code(c), place(p) {}
};

class Symbol {
public:
    std::string name;
    std::string addr;
    bool isRef;

    Symbol(std::string n = "", std::string a = "", bool r = false)
        : name(n), addr(a), isRef(r) {}

};

class ParamList;
class FuncSymbol {
public:
    std::string name;
    ParamList* params;
    bool retInt;
};

std::string newTemp();
std::string newLabel();

void enterScope();
void exitScope();
void insert(Symbol sym);
void initTable();
Symbol* lookup(std::string name);

void initFuncTable();
void insertFunction(FuncSymbol sym);
FuncSymbol* lookupFunction(std::string name);
