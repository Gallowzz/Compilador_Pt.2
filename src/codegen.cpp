#include "codegen.hpp"
#include <vector>
#include <map>

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
        initTable();
    }
    symTable.back()[sym.name] = sym;
}
void initTable(){
    symTable.push_back({});
}
Symbol* lookup(std::string name){
    for (int i = symTable.size()-1; i>=0; i--){
        auto it = symTable[i].find(name);
        if (it != symTable[i].end())
            return &it->second;
    }
    return nullptr;
}
