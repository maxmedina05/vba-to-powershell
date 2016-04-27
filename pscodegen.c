#include "pscodegen.h"

/* symbol table */
/* hash a symbol */
static unsigned
symhash(char *sym)
{
    unsigned int hash = 0;
    unsigned c;
    while(c = *sym++) hash = hash * 9 ^ c;
    return hash;
}
struct symbol *
lookup(char *sym)
{
    struct symbol *sp = &symtab[symhash(sym) % NHASH];
    int scount = NHASH; /* how many have we looked at */
    while(--scount >= 0)
    {
        if(sp->name && !strcmp(sp->name, sym))
        {
            return sp;
        }
        if(!sp->name)   /* new entry */
        {
            sp->name = strdup(sym);
            sp->value = 0;
            sp->func = NULL;
            sp->syms = NULL;
            return sp;
        }
        if(++sp >= symtab + NHASH) sp = symtab; /* try the next entry */
    }
    yyerror("symbol table overflow\n");
    abort(); /* tried them all, table is full */
}

struct ast *
newast(int nodetype, struct ast *l, struct ast *r)
{
    struct ast *a = malloc(sizeof(struct ast));
    if(!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = nodetype;
    a->l = l;
    a->r = r;
    return a;
}
struct ast *
newnum(double d)
{
    struct numval *a = malloc(sizeof(struct numval));
    if(!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = 'K';
    a->number = d;
    return (struct ast *)a;
}

struct ast *newisop(){
    struct IsOperator *a = malloc(sizeof(struct IsOperator));
    if(!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = IS_OP;
    return (struct ast *)a;    
}

struct ast *
newstring(char *s)
{
    int len = strlen(s);
    struct strval *a = malloc(sizeof(struct strval));
    if(!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = TYPE_STRING;
    a->string = (char*)malloc(sizeof(char*)*len+1);
    strcpy(a->string, s);
    return (struct ast *)a;
}

struct ast *
newcmp(int cmptype, struct ast *l, struct ast *r)
{
    struct ast *a = malloc(sizeof(struct ast));
    if(!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = '0' + cmptype;
    a->l = l;
    a->r = r;
    return a;
}
struct ast *
newfunc(int functype, struct ast *l)
{
    struct fncall *a = malloc(sizeof(struct fncall));
    if(!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = 'F';
    a->l = l;
    a->functype = functype;
    return (struct ast *)a;
}
struct ast *
newcall(struct symbol *s, struct ast *l)
{
    struct ufncall *a = malloc(sizeof(struct ufncall));
    if(!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = 'C';
    a->l = l;
    a->s = s;
    return (struct ast *)a;
}

struct ast *newvbafn(struct symbol *s, struct ast *l, struct ast *stmt){
    struct vbafn *a = malloc(sizeof(struct vbafn));
    if(!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = VBA_FUNCTION;
    a->l = l;
    a->s = s;
    a->stmt = stmt;
    return (struct ast *)a;   
}

struct ast *
newref(struct symbol *s)
{
    struct symref *a = malloc(sizeof(struct symref));
    if(!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = 'N';
    a->s = s;
    return (struct ast *)a;
}
struct ast *
newasgn(struct symbol *s, struct ast *v)
{
    struct symasgn *a = malloc(sizeof(struct symasgn));
    if(!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = '=';
    a->s = s;
    a->v = v;
    return (struct ast *)a;
}
struct ast *newflow(int nodetype, struct ast *cond, struct ast *tl, struct ast *el)
{
    struct flow *a = malloc(sizeof(struct flow));
    if(!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = nodetype;
    a->cond = cond;
    a->tl = tl;
    a->el = el;
    return (struct ast *)a;
}

/* free a tree of ASTs */
void
treefree(struct ast *a)
{
    switch(a->nodetype)
    {
    /* two subtrees */
    case '+':
    case '-':
    case '*':
    case '/':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    ARGUMENT_LIST:
    case 'L':
    case TO_OP:
        treefree(a->r);
    /* one subtree */
    case '|':
    case 'M':
    case 'C':
    case 'F':
        treefree(a->l);
    /* no subtree */
    case IS_OP:
    case 'K':
    case 'N':
        break;
    case '=':
        free( ((struct symasgn *)a)->v);
        break;
    /* up to three subtrees */
    case 'I':
    case 'W':
        free( ((struct flow *)a)->cond);
        if( ((struct flow *)a)->tl) treefree( ((struct flow *)a)->tl);
        if( ((struct flow *)a)->el) treefree( ((struct flow *)a)->el);
        break;
    case 'A':
    case 'D':
        if(((struct declaration*)a)->exp) free(((struct declaration*)a)->exp);
    break;
    case CASE_EXPRESSION:
        if(((struct casecon *)a)->exp) treefree( ((struct casecon *)a)->exp);
        if( ((struct casecon *)a)->stmts) treefree( ((struct casecon *)a)->stmts);        
        break;
    case SELECT_CASE:
        if(((struct selcase *)a)->caseexp) treefree( ((struct selcase *)a)->caseexp);
        break;
    case TYPE_STRING:
        free(((struct strval *)a)->string);
    break;
    case VBA_FUNCTION:
        if(((struct vbafn *)a)->l) treefree(((struct vbafn *)a)->l);
        if(((struct vbafn *)a)->stmt) treefree(((struct vbafn *)a)->stmt);
    break;
    default:
        fprintf(stderr, "internal error: free bad node %c\n", a->nodetype);
    }
    free(a); /* always free the node itself */
}
struct symlist *
newsymlist(struct symbol *sym, struct symlist *next)
{
    struct symlist *sl = malloc(sizeof(struct symlist));
    if(!sl)
    {
        yyerror("out of space");
        exit(0);
    }
    sl->sym = sym;
    sl->next = next;
    return sl;
}
/* free a list of symbols */
void
symlistfree(struct symlist *sl)
{
    struct symlist *nsl;
    while(sl)
    {
        nsl = sl->next;
        free(sl);
        sl = nsl;
    }
}

static double callbuiltin(struct fncall *);
static double calluser(struct ufncall *);

double
eval(struct ast *a)
{
    double v;
    if(!a)
    {
        yyerror("internal error, null eval");
        return 0.0;
    }
    switch(a->nodetype)
    {
    /* constant */
    case 'K':
        v = ((struct numval *)a)->number;
        break;
    /* name reference */
    case 'N':
        v = ((struct symref *)a)->s->value;
        break;
    /* assignment */
    case '=':
        v = ((struct symasgn *)a)->s->value =
                eval(((struct symasgn *)a)->v);

        break;
    /* expressions */
    case '+':
        v = eval(a->l) + eval(a->r);
        break;
    case '-':
        v = eval(a->l) - eval(a->r);
        break;
    case '*':
        v = eval(a->l) * eval(a->r);
        break;
    case '/':
        v = eval(a->l) / eval(a->r);
        break;
    case '|':
        v = fabs(eval(a->l));
        break;
    case 'M':
        v = -eval(a->l);
        break;
    /* comparisons */
    case '1':
        v = (eval(a->l) > eval(a->r)) ? 1 : 0;
        break;
    case '2':
        v = (eval(a->l) < eval(a->r)) ? 1 : 0;
        break;
    case '3':
        v = (eval(a->l) != eval(a->r)) ? 1 : 0;
        break;
    case '4':
        v = (eval(a->l) == eval(a->r)) ? 1 : 0;
        break;
    case '5':
        v = (eval(a->l) >= eval(a->r)) ? 1 : 0;
        break;
    case '6':
        v = (eval(a->l) <= eval(a->r)) ? 1 : 0;
        break;
    /* control flow */
    /* null expressions allowed in the grammar, so check for them */
    /* if/then/else */
    case 'I':
        if( eval( ((struct flow *)a)->cond) != 0)
        {
            //check the condition
            if( ((struct flow *)a)->tl)
            {
                //the true branch
                v = eval( ((struct flow *)a)->tl);
            }
            else
                v = 0.0; /* a default value */
        }
        else
        {
            if( ((struct flow *)a)->el)
            {
                //the false branch
                v = eval(((struct flow *)a)->el);
            }
            else
                v = 0.0; /* a default value */
        }
        break;
    /* while/do */
    case 'W':
        v = 0.0; /* a default value */
        if( ((struct flow *)a)->tl)
        {
            while( eval(((struct flow *)a)->cond) != 0) //evaluate the condition
                v = eval(((struct flow *)a)->tl);
            //evaluate the target statements
        }
        break; /* value of last statement is value of while/do */
    /* list of statements */
    case ARGUMENT_LIST:
    case 'L':
        eval(a->l);
        v = eval(a->r);
        break;
    case 'F':
        v = callbuiltin((struct fncall *)a);
        break;
    case 'C':
        v = calluser((struct ufncall *)a);
        break;
    case 'A':
    case 'D':
    case IS_OP:
    case TO_OP:
    case VBA_FUNCTION:
    break;
    default:
        fprintf(stderr, "internal error: bad node %c\n", a->nodetype);
    }
    return v;
}

static double
callbuiltin(struct fncall *f)
{
    enum bifs functype = f->functype;
    double v = eval(f->l);
    switch(functype)
    {
    case B_sqrt:
       // return sqrt(v);
    case B_exp:
        //return exp(v);
    case B_log:
        //return log(v);
        break;
    case B_print:
        fprintf(stderr, "= %4.4g\n", v);
        return v;
    default:
        yyerror("Unknown built-in function %d", functype);
        return 0.0;
    }
}

/* define a function */
void
dodef(struct symbol *name, struct symlist *syms, struct ast *func)
{
    if(name->syms) symlistfree(name->syms);
    if(name->func) treefree(name->func);
    name->syms = syms;
    name->func = func;
}

static double
calluser(struct ufncall *f)
{
    struct symbol *fn = f->s; /* function name */
    struct symlist *sl; /* dummy arguments */
    struct ast *args = f->l; /* actual arguments */
    double *oldval, *newval; /* saved arg values */
    double v;
    int nargs;
    int i;
    if(!fn->func)
    {
        yyerror("call to undefined function", fn->name);
        return 0;
    }
    /* count the arguments */
    sl = fn->syms;
    for(nargs = 0; sl; sl = sl->next)
        nargs++;
    /* prepare to save them */
    oldval = (double *)malloc(nargs * sizeof(double));
    newval = (double *)malloc(nargs * sizeof(double));
    if(!oldval || !newval)
    {
        yyerror("Out of space in %s", fn->name);
        return 0.0;
    }
    /* evaluate the arguments */
    for(i = 0; i < nargs; i++)
    {
        if(!args)
        {
            yyerror("too few args in call to %s", fn->name);
            free(oldval);
            free(newval);
            return 0.0;
        }
        if(args->nodetype == 'L')   /* if this is a list node */
        {
            newval[i] = eval(args->l);
            args = args->r;
        }
        else     /* if it's the end of the list */
        {
            newval[i] = eval(args);
            args = NULL;
        }
    }
    /* save old values of dummies, assign new ones */
    sl = fn->syms;
    for(i = 0; i < nargs; i++)
    {
        struct symbol *s = sl->sym;
        oldval[i] = s->value;
        s->value = newval[i];
        sl = sl->next;
    }
    free(newval);
    /* evaluate the function */
    v = eval(fn->func);
    /* put the real values of the dummies back */
    sl = fn->syms;
    for(i = 0; i < nargs; i++)
    {
        struct symbol *s = sl->sym;
        s->value = oldval[i];
        sl = sl->next;
    }
    free(oldval);
    return v;
}

struct ast *newDecl(int nodetype, int dt, struct symbol *s, struct ast *e){
    struct declaration *a = malloc(sizeof(struct declaration));
    if(!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = nodetype;
    a->type = dt;
    a->var = s;
    a->exp = e;
    return (struct ast *)a;    
}

double genCode(struct ast *a, FILE* fout)
{
    //fprintf(stderr, "Nodetype: %d\n", a->nodetype);
    double v = 0;
    if(!a)
    {
        yyerror("internal error, null eval");
        return 0;
    }
    switch(a->nodetype)
    {
    /* constant */
    case 'K':
        v = ((struct numval *)a)->number;
        fprintf(fout, "%d ", (int)v);
        break;
    /* name reference */
    case 'N':
        v = ((struct symref *)a)->s->value;
        fprintf(fout, "$%s ", ((struct symref *)a)->s->name);
        break;
    case 'A':
        fprintf(fout, "$%s ", ((struct declaration *)a)->var->name);
    break;
    /* declaration */
    case 'D':
        //fprintf(fout, "$%s ", ((struct declaration *)a)->var->name);
        printDeclaractionStmt(fout, a);
        break;
    /* assignment */
    case '=':
        //v = ((struct symasgn *)a)->s->value = eval(((struct symasgn *)a)->v);
        fprintf(fout, "$%s = ", ((struct symasgn *)a)->s->name);
        genCode(((struct symasgn *)a)->v, fout);
        break;
    /* expressions */
    case '+':
        //v = eval(a->l) + eval(a->r);
        genCode(a->l, fout);
        fprintf(fout, "+ ");
        genCode(a->r, fout);
        break;
    case '-':
        //v = eval(a->l) - eval(a->r);
        genCode(a->l, fout);
        fprintf(fout, "- ");
        genCode(a->r, fout);
        break;
    case '*':
        //v = eval(a->l) * eval(a->r);
        genCode(a->l, fout);
        fprintf(fout, "* ");
        genCode(a->r, fout);
        break;
    case '/':
        //v = eval(a->l) / eval(a->r);
        genCode(a->l, fout);
        fprintf(fout, "/ ");
        genCode(a->r, fout);
        break;
    case '|':
        //v = fabs(eval(a->l));
        break;
    case 'M':
        //v = -eval(a->l);
        break;
    /* comparisons */
        /*
            ">"  := 1 
            "<"  := 2 
            "<>" := 3
            "==" := 4
            ">=" := 5
            "<=" := 6
         */
    case '1':
        //v = (eval(a->l) > eval(a->r)) ? 1 : 0;
        genCode(a->l, fout);
        fprintf(fout, "-gt ");
        genCode(a->r, fout);
        break;
    case '2':
        //v = (eval(a->l) < eval(a->r)) ? 1 : 0;
        genCode(a->l, fout);
        fprintf(fout, "-lt ");
        genCode(a->r, fout);
        break;
    case '3':
        //v = (eval(a->l) != eval(a->r)) ? 1 : 0;
        genCode(a->l, fout);
        fprintf(fout, "-ne ");
        genCode(a->r, fout);
        break;
    case '4':
        //v = (eval(a->l) == eval(a->r)) ? 1 : 0;
        genCode(a->l, fout);
        fprintf(fout, "-eq ");
        genCode(a->r, fout);
        break;
    case '5':
        //v = (eval(a->l) >= eval(a->r)) ? 1 : 0;
        genCode(a->l, fout);
        fprintf(fout, "-ge ");
        genCode(a->r, fout);
        break;
    case '6':
        //v = (eval(a->l) <= eval(a->r)) ? 1 : 0;
        genCode(a->l, fout);
        fprintf(fout, "-le ");
        genCode(a->r, fout);
        break;
    /* control flow */
    /* null expressions allowed in the grammar, so check for them */
    /* if/then/else */
    case 'I':
        fprintf(fout, "If (");
        genCode(((struct flow *)a)->cond, fout);
        fprintf(fout, ") {\n");
        genCode(((struct flow *)a)->tl, fout);
        fprintf(fout, "\n }\n");

        if(((struct flow *)a)->el){
            fprintf(fout, "Else {\n");
            genCode(((struct flow *)a)->el, fout);
            fprintf(fout, "\n }\n");
        }
        break;
    /* while/do */
    case 'W':
        fprintf(fout, "while (");
        genCode(((struct flow *)a)->cond, fout);
        fprintf(fout, ") {\n");
        genCode(((struct flow *)a)->tl, fout);
        fprintf(fout, "\n }\n");
        break; /* value of last statement is value of while/do */
    /* list of statements */
    case ARGUMENT_LIST:
    genCode(a->l, fout);
    fprintf(fout, ",");
    genCode(a->r, fout);
    break;
    case 'L':
        genCode(a->l, fout);
        genCode(a->r, fout);
        break;
    case 'F':
       // v = callbuiltin((struct fncall *)a);
        break;
    case 'C':
        //v = calluser((struct ufncall *)a);
        break;
    case IS_OP:
        fprintf(fout, "$_ ");

    break;

    case TO_OP:
        fprintf(fout, "$_ -In ");
        genCode(a->l, fout);
        fprintf(fout, "..");
        genCode(a->r, fout);
    break;

    case SELECT_CASE:
        // fprintf(stderr, "SELECT CASE\n");
        fprintf(fout, "switch ($%s) { \n", ((struct selcase *)a)->s->name);
        genCode(((struct selcase *)a)->caseexp, fout);
        fprintf(fout, "}");
    break;

    case CASE_EXPRESSION:
         //fprintf(stderr, "CASE_EXPRESSION\n");
        fprintf(fout, "{ ");
        genCode(((struct casecon *)a)->exp, fout);
        fprintf(fout, "} ");
        fprintf(fout, "{ ");
        genCode(((struct casecon *)a)->stmts, fout);
        fprintf(fout, "}\n");
    break;

    case TYPE_STRING:
        fprintf(fout, "%s ", ((struct strval *)a)->string);
    break;

    case VBA_FUNCTION:
        //fprintf(stderr, "%s\n", "FUNCTION");
        fprintf(fout, "function %s( ", ((struct vbafn *)a)->s->name );
        if(((struct vbafn *)a)->l) genCode(((struct vbafn *)a)->l ,fout);
        fprintf(fout, ") { \n");
        if(((struct vbafn *)a)->stmt) genCode(((struct vbafn *)a)->stmt ,fout);

        fprintf(fout, "\nreturn $%s", ((struct vbafn *)a)->s->name);
        fprintf(fout, "\n}\n");
    break;

    default:
        fprintf(stderr, "internal error: bad node %c\n", a->nodetype);
    }
    return v;
}

void printDeclaractionStmt(FILE *fout, struct ast *a){
 struct declaration * decl = ((struct declaration *)a);
 
 fprintf(fout, "%s$%s ",getTypeName(decl->type), decl->var->name); 
 if(decl->exp != NULL){
    fprintf(fout, "= ");
    genCode(decl->exp, fout);
 }
}

char *getTypeName(int datatype){
    switch(datatype){
        case TYPE_INTEGER: return "[int]";
        case TYPE_DOUBLE: return "[Double]";
        case TYPE_STRING: return "[String]";                
        default: return "";
    }
    
    return "";
}

struct ast *newcase(int nodetype, struct ast *exp, struct ast *stl){
    struct casecon *a = malloc(sizeof(struct casecon));
    if(!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = nodetype;
    a->exp = exp;
    a->stmts = stl;
    return (struct ast *)a;    
}

struct ast *newselcase(int nodetype, struct symbol *s, struct ast *cexps){
    struct selcase *a = malloc(sizeof(struct selcase));
    if(!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = nodetype;
    a->s = s;
    a->caseexp = cexps;
    return (struct ast *)a;    
}