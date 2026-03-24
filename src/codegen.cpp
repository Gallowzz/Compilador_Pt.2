#include "codegen.hpp"
#include <string>
#include <vector>
#include <map>
#include <iostream>
#include "Ast.hpp"

int tempId = 0;
int labelId = 0;

std::string newTemp(){
    tempId += 1;
    return "%t" + std::to_string(tempId);
}

std::string newLabel(){
    labelId += 1;
    return "L" + std::to_string(labelId);
}

std::vector<std::map<std::string, Symbol>> symTable;

void enterScope(){
    symTable.push_back({});
}
void exitScope(){
    symTable.pop_back();
}
void insert(Symbol sym){
    if(symTable.empty()){
        std::cerr << "Debug: Insert into EMPTY table. Initializing...\n";
        initTable();
    }
    std::cerr << "Debug: Inserting '" << sym.name << "' into scope " << (symTable.size()-1) << "\n";
    symTable.back()[sym.name] = sym;
}
void initTable(){
    symTable.push_back({});
}
Symbol* lookup(std::string name){
    if(symTable.empty()){
        return nullptr;
    }
    std::cerr << "Debug: Looking up '" << name << "' in " << symTable.size() << " scopes.\n";
    for (int i = symTable.size()-1; i>=0; i--){
        auto it = symTable[i].find(name);
        if (it != symTable[i].end())
            return &it->second;
    }
    return nullptr;
}

std::map<std::string, FuncSymbol> funcTable;

void insertFunction(FuncSymbol sym){
    std::cerr << "Debug: Inserting '" << sym.name << "' into Function Table \n";
    funcTable[sym.name] = sym;
}
FuncSymbol* lookupFunction(std::string name){
    std::cerr << "Debug: Searching for '" << name << "' in Function Table \n";
    if(funcTable.count(name)){
        return &funcTable[name];
    }
    return nullptr;
}
