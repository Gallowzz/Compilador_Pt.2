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

    Symbol(std::string n = "", std::string a = "")
        : name(n), addr(a) {}

};

std::string newTemp();
std::string newLabel();

void enterScope();
void exitScope();
void insert(Symbol sym);
Symbol* lookup(std::string name);
