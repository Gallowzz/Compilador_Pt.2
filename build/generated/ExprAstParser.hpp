/* /home/darky/projects/comp2_clase/build/generated/ExprAstParser.hpp.  Generated automatically by treecc */
#ifndef __yy__home_darky_projects_comp2_clase_build_generated_ExprAstParser_hpp
#define __yy__home_darky_projects_comp2_clase_build_generated_ExprAstParser_hpp
#line 3 "/home/darky/projects/comp2_clase/src/ast.tc"

#include <iostream>
#include <string>

using stdstring = std::string;
#line 11 "/home/darky/projects/comp2_clase/build/generated/ExprAstParser.hpp"

#include <new>

const int AstNode_kind = 1;
const int Expr_kind = 2;
const int BinaryExpr_kind = 3;
const int NumberVal_kind = 6;
const int AddExpr_kind = 4;
const int MultExpr_kind = 5;

class AstNode;
class Expr;
class BinaryExpr;
class NumberVal;
class AddExpr;
class MultExpr;

class YYNODESTATE
{
public:

	YYNODESTATE();
	virtual ~YYNODESTATE();

#line 1 "cpp_skel.h"
private:

	struct YYNODESTATE_block *blocks__;
	struct YYNODESTATE_push *push_stack__;
	int used__;
#line 42 "/home/darky/projects/comp2_clase/build/generated/ExprAstParser.hpp"
private:

	static YYNODESTATE *state__;

public:

	static YYNODESTATE *getState()
		{
			if(state__) return state__;
			state__ = new YYNODESTATE();
			return state__;
		}

public:

	void *alloc(size_t);
	void dealloc(void *, size_t);
	int push();
	void pop();
	void clear();
	virtual void failed();
	virtual const char *currFilename() const;
	virtual long currLinenum() const;

};

class AstNode
{
protected:

	int kind__;
	const char *filename__;
	long linenum__;

public:

	int getKind() const { return kind__; }
	const char *getFilename() const { return filename__; }
	long getLinenum() const { return linenum__; }
	void setFilename(const char *filename) { filename__ = filename; }
	void setLinenum(long linenum) { linenum__ = linenum; }

	void *operator new(size_t);
	void operator delete(void *, size_t);

protected:

	AstNode();

public:

	int line;
	int column;

	virtual stdstring toString() = 0;
	virtual int evaluate() = 0;

	virtual int isA(int kind) const;
	virtual const char *getKindName() const;

protected:

	virtual ~AstNode();

};

class Expr : public AstNode
{
protected:

	Expr();

public:

	virtual stdstring toString() = 0;
	virtual int evaluate() = 0;

	virtual int isA(int kind) const;
	virtual const char *getKindName() const;

protected:

	virtual ~Expr();

};

class BinaryExpr : public Expr
{
protected:

	BinaryExpr(Expr * expr1, Expr * expr2);

public:

	Expr * expr1;
	Expr * expr2;

	virtual stdstring toString() = 0;
	virtual int evaluate() = 0;

	virtual int isA(int kind) const;
	virtual const char *getKindName() const;

protected:

	virtual ~BinaryExpr();

};

class NumberVal : public Expr
{
public:

	NumberVal(long value);

public:

	long value;

	virtual stdstring toString();
	virtual int evaluate();

	virtual int isA(int kind) const;
	virtual const char *getKindName() const;

protected:

	virtual ~NumberVal();

};

class AddExpr : public BinaryExpr
{
public:

	AddExpr(Expr * expr1, Expr * expr2);

public:

	virtual stdstring toString();
	virtual int evaluate();

	virtual int isA(int kind) const;
	virtual const char *getKindName() const;

protected:

	virtual ~AddExpr();

};

class MultExpr : public BinaryExpr
{
public:

	MultExpr(Expr * expr1, Expr * expr2);

public:

	virtual stdstring toString();
	virtual int evaluate();

	virtual int isA(int kind) const;
	virtual const char *getKindName() const;

protected:

	virtual ~MultExpr();

};



#endif
