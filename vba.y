    /*** Definition section ***/
%{
  #include "heading.h"
  int yyerror(char *s);
  int yylex(void);
%}

%union {
  char *s;
  char c;
  double d;
  float f;
  int i;
}
  /*** Reserved keywords ***/
%token Call
%token Close
%token Const
%token Declare
%token DefBool
%token DefByte
%token DefCur
%token DefDate
%token DefDbl
%token DefInt
%token DefLng
%token DefLngLng
%token DefLngPtr
%token DefObj
%token DefSng
%token DefStr
%token DefVar
%token Dim
%token Do
%token Else
%token ElseIf
%token End
%token EndIf
%token Enum
%token Erase
%token Event
%token Exit
%token For
%token Friend
%token Function
%token Get
%token Global
%token GoSub
%token GoTo
%token If
%token Implements
%token Input
%token Let
%token Lock
%token Loop
%token LSet
%token Next
%token On
%token Open
%token Option
%token Print
%token Private
%token Public
%token Put
%token RaiseEvent
%token ReDim
%token Resume
%token Return
%token RSet
%token Seek
%token Select
%token Set
%token Static
%token Stop
%token Sub
%token Type
%token Unlock
%token Wend
%token While
%token With
%token Write
%token Rem
%token Any
%token As
%token ByRef 
%token ByVal
%token Case
%token Each
%token In
%token New
%token Shared
%token Until
%token WithEvents
%token Optional
%token ParamArray
%token Preserve
%token Spc
%token Then
%token To
%token AddressOf
%token And
%token Eqv
%token Imp
%token Is
%token Like
%token Mod
%token Not
%token Or
%token TypeOf 
%token Xor
%token Abs
%token CBool
%token CByte
%token CCur
%token CDate
%token CDbl
%token CDec
%token CInt
%token CLng
%token CLngLng
%token CLngPtr
%token CSng
%token CStr
%token CVar
%token CVErr
%token Date
%token Debug
%token DoEvents
%token Fix
%token Int
%token Len
%token LenB
%token Me
%token PSet
%token Scale
%token Sgn
%token String
%token Array
%token Circle
%token InputB
%token LBound
%token UBound
%token Boolean
%token Byte
%token Currency
%token Double
%token Integer
%token Long
%token LongLong
%token LongPtr
%token Single
%token Variant
%token True 
%token False
%token Nothing
%token Empty 
%token Null
%token Attribute
%token LINEINPUT 
%token VB_Base
%token VB_Control
%token VB_Creatable
%token VB_Customizable
%token VB_Description
%token VB_Exposed
%token VB_Ext_KEY 
%token VB_GlobalNameSpace
%token VB_HelpID
%token VB_Invoke_Func
%token VB_Invoke_Property 
%token VB_Invoke_PropertyPut
%token VB_Invoke_PropertyPutRef
%token VB_MemberFlags
%token VB_Name
%token VB_PredeclaredId
%token VB_ProcData
%token VB_TemplateDerived
%token VB_UserMemId
%token VB_VarDescription
%token VB_VarHelpID
%token VB_VarMemberFlags
%token VB_VarProcData 
%token VB_VarUserMemId
%token CDecl
%token Decimal
%token DefDec
%token Object
%token <s> Identifier
%token Alias
%token Lib
%token Base
%token Explicit
%token Module
%token Compare
%token Binary
%token Text
%token Ptrsafe
%token Class_Initialize 
%token Class_Terminate
%token Mids
%token MidBs
%token Step
%token Access
%token Reset
%token Error
%token Go
%token Line
%token Property
%token Width
%token Random
%token Goto
%token Typeof
%token Mid
%token MidB
%token Redim
%token Byval
%token Output
%token Append
%token Addressof
%token Read

/*Caracteres especiales*/
%token Comma 
%token Period 
%token Exclamation 
%token Sharp 
%token Percent
%token At
%token Dollar
%token Amp 
%token Left_Par 
%token Right_Par 
%token Left_Bra
%token Right_Bra
%token Ast 
%token Plus 
%token Score 
%token Slash 
%token Colon 
%token Semi_Colon 
%token Less_Than 
%token Equal 
%token More_Than 
%token Question 
%token Back_Slash 
%token Cone
%token Single_Quote
%token Double_Quote
%token Tab
%token Eom
%token Space
%token Underscore
%token DBCSWhitespace
%token ClassZs

  /*** Unicode Characters ***/
%token CR
%token Control
%token LS
%token PS

/*** Data type value ***/
%token <d> IntegerLiteral
%token <f> FLOAT 
%token DATE 
%token <s> STRING 

%token TOKEN

/*** Data type ***/
%type <i> INTEGER
%type <s> Expression ExpVar IdenVar ValueExpression LiteralExpression ArithmeticOperator
%type <s> OperatorExpression UnaryMinusOperator AdditionOperator SubtractionOperator
%type <s> MultiplicationOperator DivisionOperator IntegerDivisionOperator ModuloOperator
%type <s> ExponentiationOperator

%start FinalExpression

%%
    /*** Rules sections ***/
ProceduralModule : ProceduralModuleHeader EOS ProceduralModuleBody
;

ClassModule : ClassModuleHeader ClassModuleBody
;

ProceduralModuleHeader : Attribute VB_Name Equal QuotedIdentifier EOL
;

ClassModuleHeader : ClassAttr
| ClassAttr ClassModuleHeader
;

ClassAttr : Attribute VB_Name Equal QuotedIdentifier AttrEnd 
| Attribute VB_GlobalNameSpace Equal False AttrEnd 
| Attribute VB_Creatable Equal False AttrEnd 
| Attribute VB_PredeclaredId Equal BooleanLiteralIdentifier AttrEnd 
| Attribute VB_Exposed Equal BooleanLiteralIdentifier AttrEnd 
| Attribute VB_Customizable Equal BooleanLiteralIdentifier AttrEnd
;

AttrEnd : LineTerminator
;

QuotedIdentifier : Double_Quote Identifier Double_Quote
;

ProceduralModuleBody : ProceduralModuleDeclarationSection ProceduralModuleCodeSection
;

ClassModuleBody : ClassModuleDeclarationSection ClassModuleCodeSection
;

UnrestrictedName : Name 
| ReservedIdentifier
;

Name : UntypedName 
| TypedName
;

UntypedName : Identifier
;

ProceduralModuleDeclarationSection : ProceduralModuleDeclarationElement EOS
| ProceduralModuleDeclarationSection ProceduralModuleDeclarationElement EOS
| DefDirective ProceduralModuleDeclarationElement EOS
| ProceduralModuleDeclarationSection DefDirective ProceduralModuleDeclarationElement EOS
;

ClassModuleDeclarationSection : ClassModuleDeclarationElement EOS
| ClassModuleDeclarationSection ClassModuleDeclarationElement EOS
| ClassModuleDirectiveElement EOS DefDirective ClassModuleDeclarationSection
;

ProceduralModuleDirectiveElement : CommonOptionDirective 
| OptionPrivateDirective 
| DefDirective
;

ProceduralModuleDeclarationElement : CommonModuleDeclarationElement 
| GlobalVariableDeclaration 
| PublicConstDeclaration 
| PublicTypeDeclaration 
| PublicExternalProcedureDeclaration 
| GlobalEnumDeclaration 
| CommonOptionDirective 
| OptionPrivateDirective
;

ClassModuleDirectiveElement : CommonOptionDirective 
| DefDirective 
| ImplementsDirective
;

ClassModuleDeclarationElement : CommonModuleDeclarationElement 
| EventDeclaration 
| CommonOptionDirective 
| ImplementsDirective
;

CommonOptionDirective : OptionCompareDirective 
| OptionBaseDirective 
| OptionExplicitDirective 
| RemStatement
;

OptionCompareDirective : Option Compare Binary
| Option Compare Text
;

OptionBaseDirective : Option Base Integer
;

OptionExplicitDirective : Option Explicit
;

OptionPrivateDirective : Option Private Module
;

DefDirective : DefType LetterSpec 
| DefDirective Comma LetterSpec
;

LetterSpec : SingleLetter 
| UniversalLetterRange 
| LetterRange
;

SingleLetter : Identifier
;

UniversalLetterRange : UpperCaseA Score UpperCaseZ
;

UpperCaseA : Identifier
;

UpperCaseZ : Identifier
;

LetterRange : FirstLetter Score LastLetter
;

FirstLetter : Identifier
;

LastLetter : Identifier
;

DefType : DefBool
| DefByte
| DefCur
| DefDate
| DefDbl
| DefInt
| DefLng
| DefLngLng
| DefLngPtr
| DefObj
| DefSng
| DefStr
| DefVar
;

CommonModuleDeclarationElement : ModuleVariableDeclaration CommonModuleDeclarationElement Equal
| PrivateConstDeclaration CommonModuleDeclarationElement Equal
| PrivateTypeDeclaration CommonModuleDeclarationElement Equal
| EnumDeclaration CommonModuleDeclarationElement Equal
| PrivateExternalProcedureDeclaration
;

ModuleVariableDeclaration : PublicVariableDeclaration 
| PrivateVariableDeclaration
;

GlobalVariableDeclaration : Global VariableDeclarationList {fprintf(yyout, "Variable global\n");}
;

PublicVariableDeclaration : Public ModuleVariableDeclarationList {fprintf(yyout, "Variable publica\n");}
| Public Shared ModuleVariableDeclarationList {fprintf(yyout, "Variable publica\n");}
;

PrivateVariableDeclaration : Private ModuleVariableDeclarationList {fprintf(yyout, "Variable privada\n");}
| Dim ModuleVariableDeclarationList {fprintf(yyout, "Variable privada\n");}
| Private Shared ModuleVariableDeclarationList {fprintf(yyout, "Variable privada\n");}
| Dim Shared ModuleVariableDeclarationList {fprintf(yyout, "Variable privada\n");}
;

ModuleVariableDeclarationList : WithEventsVariableDcl Comma WithEventsVariableDcl  
| WithEventsVariableDcl Comma VariableDcl
| VariableDcl Comma WithEventsVariableDcl
| VariableDcl Comma VariableDcl 
| ModuleVariableDeclarationList Comma WithEventsVariableDcl
| ModuleVariableDeclarationList Comma VariableDcl 
;

VariableDeclarationList : VariableDcl 
| VariableDeclarationList Comma VariableDcl
;

VariableDcl : TypedVariableDcl 
| UntypedVariableDcl
;

TypedVariableDcl : TypedName 
| TypedName ArrayDim
;

UntypedVariableDcl : Identifier ArrayClause
| Identifier AsClause
;

ArrayClause : ArrayDim
| ArrayDim AsClause
;

AsClause : AsAutoObject 
| AsType
;

WithEventsVariableDcl : WithEvents Identifier As ClassTypeName
;

ClassTypeName : DefinedTypeExpression
;

ArrayDim : Left_Par Right_Par
| Left_Par BoundsList Right_Par
;

BoundsList : DimSpec
| BoundsList Comma DimSpec 
;

DimSpec : UpperBound
| LowerBound UpperBound
;

LowerBound : ConstantExpression To
;

UpperBound : ConstantExpression
;

AsAutoObject : As New ClassTypeName
;

AsType : As TypeSpec
;

TypeSpec : FixedLengthStringSpec 
| TypeExpression
;

FixedLengthStringSpec : String Ast StringLength
;

StringLength : ConstantName 
| Integer
;

ConstantName : SimpleNameExpression
;

PublicConstDeclaration : Global ModuleConstDeclaration
| Public ModuleConstDeclaration
;

PrivateConstDeclaration : ModuleConstDeclaration
| Private ModuleConstDeclaration
;

ModuleConstDeclaration : ConstDeclaration
;

ConstDeclaration : Const ConstItemList
;

ConstItemList : ConstItem
| ConstItemList Comma ConstItem 
;

ConstItem : TypedNameConstItem 
| UntypedNameConstItem
;

TypedNameConstItem : TypedName Equal ConstantExpression
;

UntypedNameConstItem : Identifier Equal ConstantExpression
| Identifier ConstAsClause Equal ConstantExpression
;

ConstAsClause : As BuiltinType
;

PublicTypeDeclaration : UdtDeclaration
| Global UdtDeclaration
| Public UdtDeclaration
;

PrivateTypeDeclaration : Private UdtDeclaration
;

UdtDeclaration : Type UntypedName EOS UdtMemberList EOS End Type
;

UdtMemberList : UdtElement 
| UdtMemberList UdtElement EOS UdtElement
;

UdtElement : RemStatement 
| UdtMember
;

UdtMember : ReservedNameMemberDcl 
| UntypedNameMemberDcl
;

UntypedNameMemberDcl : Identifier OptionalArrayClause
;

ReservedNameMemberDcl : ReservedMemberName AsClause
;

OptionalArrayClause : AsClause
| ArrayDim AsClause
;

ReservedMemberName : StatementKeyword 
| MarkerKeyword 
| OperatorIdentifier 
| SpecialForm 
| ReservedName 
| LiteralIdentifier 
| ReservedForImplementationUse 
| FutureReserved
;

EnumDeclaration : PublicEnumDeclaration 
| PrivateEnumDeclaration
;

GlobalEnumDeclaration : Global EnumDeclaration
;

PublicEnumDeclaration : EnumDeclaration
| Public EnumDeclaration
;

PrivateEnumDeclaration : Private EnumDeclaration
;

EnumDeclaration : Enum UntypedName EOS MemberList EOS End Enum
;

MemberList : EnumElement 
| MemberList EOS EnumElement
;

EnumElement : RemStatement 
| EnumMember
;

EnumMember : UntypedName 
| UntypedName Equal ConstantExpression
;

PublicExternalProcedureDeclaration : ExternalProcDcl
| Public ExternalProcDcl
;

PrivateExternalProcedureDeclaration : Private ExternalProcDcl
;

ExternalProcDcl : Declare ExternalFunction
| Declare ExternalSub
| Declare Ptrsafe ExternalSub
| Declare Ptrsafe ExternalFunction
;

ExternalSub : Sub SubroutineName LibInfo
| Sub SubroutineName LibInfo ProcedureParameters
;

ExternalFunction : Function FunctionName LibInfo 
| Function FunctionName LibInfo ProcedureParameters
| Function FunctionName LibInfo FunctionType
| Function FunctionName LibInfo ProcedureParameters FunctionType
;

LibInfo : LibClause 
| LibClause AliasClause
;

LibClause : Lib String
;

AliasClause : Alias String
;

ImplementsDirective : Implements ClassTypeName
;

EventDeclaration : Event Identifier
| Public Event Identifier
| Event Identifier EventParameterList
| Public Event Identifier EventParameterList 
;

EventParameterList : Left_Par Right_Par
| Left_Par PositionalParameters Right_Par
;

ProceduralModuleCodeSection : ProceduralModuleCodeElement
| ProceduralModuleCodeSection ProceduralModuleCodeElement
;

ClassModuleCodeSection : ClassModuleCodeElement
| ClassModuleCodeSection ClassModuleCodeElement
;

ProceduralModuleCodeElement : CommonModuleCodeElement
;

ClassModuleCodeElement : CommonModuleCodeElement 
| ImplementsDirective
;

CommonModuleCodeElement : RemStatement 
| ProcedureDeclaration
;

ProcedureDeclaration : SubroutineDeclaration 
| FunctionDeclaration 
| PropertyGetDeclaration 
| PropertyLHSDeclaration
;

SubroutineDeclaration : ProcedureScope Sub SubroutineName EOS End Sub ProcedureTail
| ProcedureScope InitialStatic Sub SubroutineName EOS End Sub ProcedureTail
| ProcedureScope Sub SubroutineName ProcedureParameters EOS End Sub ProcedureTail
| ProcedureScope Sub SubroutineName TrailingStatic EOS End Sub ProcedureTail
| ProcedureScope Sub SubroutineName EOS ProcedureBody EOS End Sub ProcedureTail
| ProcedureScope Sub SubroutineName EOS EndLabel End Sub ProcedureTail
| ProcedureScope InitialStatic Sub SubroutineName ProcedureParameters EOS End Sub ProcedureTail
| ProcedureScope InitialStatic Sub SubroutineName TrailingStatic EOS End Sub ProcedureTail
| ProcedureScope InitialStatic Sub SubroutineName EOS ProcedureBody EOS End Sub ProcedureTail
| ProcedureScope InitialStatic Sub SubroutineName EOS EndLabel End Sub ProcedureTail
| ProcedureScope Sub SubroutineName ProcedureParameters TrailingStatic EOS End Sub ProcedureTail
| ProcedureScope Sub SubroutineName ProcedureParameters EOS ProcedureBody EOS End Sub ProcedureTail
| ProcedureScope Sub SubroutineName ProcedureParameters EOS EndLabel End Sub ProcedureTail
| ProcedureScope Sub SubroutineName TrailingStatic EOS ProcedureBody EOS End Sub ProcedureTail
| ProcedureScope Sub SubroutineName TrailingStatic EOS EndLabel End Sub ProcedureTail
| ProcedureScope Sub SubroutineName EOS ProcedureBody EOS EndLabel End Sub ProcedureTail
| ProcedureScope InitialStatic Sub SubroutineName ProcedureParameters TrailingStatic EOS End Sub ProcedureTail
| ProcedureScope InitialStatic Sub SubroutineName ProcedureParameters EOS ProcedureBody EOS End Sub ProcedureTail
| ProcedureScope InitialStatic Sub SubroutineName ProcedureParameters EOS EndLabel End Sub ProcedureTail
| ProcedureScope Sub SubroutineName ProcedureParameters TrailingStatic EOS ProcedureBody EOS End Sub ProcedureTail
| ProcedureScope Sub SubroutineName ProcedureParameters TrailingStatic EOS EndLabel End Sub ProcedureTail
| ProcedureScope Sub SubroutineName TrailingStatic EOS ProcedureBody EOS EndLabel End Sub ProcedureTail
| ProcedureScope InitialStatic Sub SubroutineName ProcedureParameters TrailingStatic EOS ProcedureBody EOS EndLabel End Sub ProcedureTail
;

FunctionDeclaration : ProcedureScope Function FunctionName EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName FunctionType EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName TrailingStatic EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName EOS ProcedureBody EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName EOS EndLabel End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters FunctionType EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters TrailingStatic EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters EOS ProcedureBody EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters EOS EndLabel End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName FunctionType TrailingStatic EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName FunctionType EOS ProcedureBody EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName FunctionType EOS EndLabel End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName TrailingStatic EOS ProcedureBody EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName TrailingStatic EOS EndLabel End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName EOS ProcedureBody EOS EndLabel End Function ProcedureTail
| ProcedureScope Function FunctionName ProcedureParameters FunctionType TrailingStatic EOS End Function ProcedureTail
| ProcedureScope Function FunctionName ProcedureParameters FunctionType EOS ProcedureBody EOS End Function ProcedureTail
| ProcedureScope Function FunctionName ProcedureParameters FunctionType EOS EndLabel End Function ProcedureTail
| ProcedureScope Function FunctionName ProcedureParameters TrailingStatic EOS ProcedureBody EOS End Function ProcedureTail
| ProcedureScope Function FunctionName ProcedureParameters TrailingStatic EOS EndLabel End Function ProcedureTail
| ProcedureScope Function FunctionName TrailingStatic EOS ProcedureBody EOS EndLabel End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters FunctionType TrailingStatic EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters FunctionType EOS ProcedureBody EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters FunctionType EOS EndLabel End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters TrailingStatic EOS ProcedureBody EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters TrailingStatic EOS EndLabel End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName FunctionType TrailingStatic EOS ProcedureBody EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName FunctionType TrailingStatic EOS EndLabel End Function ProcedureTail
| ProcedureScope Function FunctionName ProcedureParameters FunctionType TrailingStatic EOS ProcedureBody EOS End Function ProcedureTail
| ProcedureScope Function FunctionName ProcedureParameters FunctionType TrailingStatic EOS EndLabel End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters FunctionType TrailingStatic EOS ProcedureBody EOS End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters FunctionType TrailingStatic EOS EndLabel End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters FunctionType EOS ProcedureBody EOS EndLabel End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters TrailingStatic EOS ProcedureBody EOS EndLabel End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName FunctionType TrailingStatic EOS ProcedureBody EOS EndLabel End Function ProcedureTail
| ProcedureScope Function FunctionName ProcedureParameters FunctionType TrailingStatic EOS ProcedureBody EOS EndLabel End Function ProcedureTail
| ProcedureScope InitialStatic Function FunctionName ProcedureParameters FunctionType TrailingStatic EOS ProcedureBody EOS EndLabel End Function ProcedureTail
;

PropertyGetDeclaration : ProcedureScope Property Get FunctionName EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName FunctionType EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName TrailingStatic EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters FunctionType EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters TrailingStatic EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName FunctionType TrailingStatic EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName FunctionType EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName FunctionType EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName TrailingStatic EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName TrailingStatic EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName EOS ProcedureBody EOS EndLabel End Property ProcedureTail
| ProcedureScope Property Get FunctionName ProcedureParameters FunctionType TrailingStatic EOS End Property ProcedureTail
| ProcedureScope Property Get FunctionName ProcedureParameters FunctionType EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope Property Get FunctionName ProcedureParameters FunctionType EOS EndLabel End Property ProcedureTail
| ProcedureScope Property Get FunctionName ProcedureParameters TrailingStatic EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope Property Get FunctionName ProcedureParameters TrailingStatic EOS EndLabel End Property ProcedureTail
| ProcedureScope Property Get FunctionName TrailingStatic EOS ProcedureBody EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters FunctionType TrailingStatic EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters FunctionType EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters FunctionType EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters TrailingStatic EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters TrailingStatic EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName FunctionType TrailingStatic EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName FunctionType TrailingStatic EOS EndLabel End Property ProcedureTail
| ProcedureScope Property Get FunctionName ProcedureParameters FunctionType TrailingStatic EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope Property Get FunctionName ProcedureParameters FunctionType TrailingStatic EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters FunctionType TrailingStatic EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters FunctionType TrailingStatic EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters FunctionType EOS ProcedureBody EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters TrailingStatic EOS ProcedureBody EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName FunctionType TrailingStatic EOS ProcedureBody EOS EndLabel End Property ProcedureTail
| ProcedureScope Property Get FunctionName ProcedureParameters FunctionType TrailingStatic EOS ProcedureBody EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Get FunctionName ProcedureParameters FunctionType TrailingStatic EOS ProcedureBody EOS EndLabel End Property ProcedureTail
;

PropertyLHSDeclaration : ProcedureScope Property Let SubroutineName PropertyParameters EOS End Property ProcedureTail
| ProcedureScope Property Set SubroutineName PropertyParameters EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Let SubroutineName PropertyParameters EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Set SubroutineName PropertyParameters EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Let SubroutineName PropertyParameters TrailingStatic EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Set SubroutineName PropertyParameters TrailingStatic EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Let SubroutineName PropertyParameters EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Set SubroutineName PropertyParameters EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Let SubroutineName PropertyParameters EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Set SubroutineName PropertyParameters EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Let SubroutineName PropertyParameters TrailingStatic EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Set SubroutineName PropertyParameters TrailingStatic EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Let SubroutineName PropertyParameters TrailingStatic EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Set SubroutineName PropertyParameters TrailingStatic EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Let SubroutineName PropertyParameters EOS ProcedureBody EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Set SubroutineName PropertyParameters EOS ProcedureBody EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Let SubroutineName PropertyParameters TrailingStatic EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Set SubroutineName PropertyParameters TrailingStatic EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope InitialStatic Property Let SubroutineName PropertyParameters TrailingStatic EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Set SubroutineName PropertyParameters TrailingStatic EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Let SubroutineName PropertyParameters EOS ProcedureBody EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Set SubroutineName PropertyParameters EOS ProcedureBody EOS EndLabel End Property ProcedureTail
| ProcedureScope Property Let SubroutineName PropertyParameters TrailingStatic EOS End Property ProcedureTail
| ProcedureScope Property Set SubroutineName PropertyParameters TrailingStatic EOS End Property ProcedureTail
| ProcedureScope Property Let SubroutineName PropertyParameters TrailingStatic EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope Property Set SubroutineName PropertyParameters TrailingStatic EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope Property Let SubroutineName PropertyParameters TrailingStatic EOS EndLabel End Property ProcedureTail 
| ProcedureScope Property Set SubroutineName PropertyParameters TrailingStatic EOS EndLabel End Property ProcedureTail 
| ProcedureScope Property Let SubroutineName PropertyParameters TrailingStatic EOS ProcedureBody EOS EndLabel End Property ProcedureTail
| ProcedureScope Property Set SubroutineName PropertyParameters TrailingStatic EOS ProcedureBody EOS EndLabel End Property ProcedureTail
| ProcedureScope Property Let SubroutineName PropertyParameters EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope Property Set SubroutineName PropertyParameters EOS ProcedureBody EOS End Property ProcedureTail
| ProcedureScope Property Let SubroutineName PropertyParameters EOS ProcedureBody EOS EndLabel End Property ProcedureTail
| ProcedureScope Property Set SubroutineName PropertyParameters EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Let SubroutineName PropertyParameters TrailingStatic EOS ProcedureBody EOS EndLabel End Property ProcedureTail
| ProcedureScope InitialStatic Property Set SubroutineName PropertyParameters TrailingStatic EOS ProcedureBody EOS EndLabel End Property ProcedureTail
;

EndLabel : StatementLabelDefinition
;

ProcedureTail : WS 
| Single_Quote CommentBody 
| Colon RemStatement
;

CommentBody : LineContinuation
| CommentBody LineContinuation
;

ProcedureScope : Global 
| Public 
| Private 
| Friend
;

InitialStatic : Static
;

TrailingStatic : Static
;

SubroutineName : Identifier 
| PrefixedName
;

FunctionName : TypedName 
| SubroutineName
;

PrefixedName : EventHandlerName 
| ImplementedName 
| LifecycleHandlerName
;

FunctionType : As TypeExpression 
| As TypeExpression ArrayDesignator
;

ArrayDesignator : Left_Par Right_Par
;

ProcedureParameters : Left_Par ParameterList Right_Par
;

PropertyParameters : Left_Par ValueParam Right_Par
| Left_Par ParameterList Comma ValueParam Right_Par
;

ParameterList : PositionalParameters Comma OptionalParameters 
| PositionalParameters 
| PositionalParameters Comma ParamArray
| OptionalParameters 
| ParamArray
;

PositionalParameters : PositionalParam 
| PositionalParameters Comma PositionalParam 
;

OptionalParameters : OptionalParam
| OptionalParameters OptionalParam
;

ValueParam : PositionalParam
;

PositionalParam : ParamDcl
| ParameterMechanism ParamDcl
;

OptionalParam : OptionalPrefix ParamDcl
| OptionalPrefix ParamDcl DefaultValue
;

Paramarray : ParamArray Identifier Left_Par Right_Par
| ParamArray Identifier Left_Par Right_Par As Variant
;

ParamDcl : UntypedNameParamDcl 
| TypedNameParamDcl
;

UntypedNameParamDcl : Identifier 
| Identifier ParameterType

TypedNameParamDcl : TypedName
| TypedName ArrayDesignator
;

OptionalPrefix : Optional ParameterMechanism 
| ParameterMechanism Optional
;

ParameterMechanism : Byval 
| ByRef
;

ParameterType : As TypeExpression 
| As Any
| ArrayDesignator As TypeExpression
| ArrayDesignator As Any 
;

DefaultValue : Equal ConstantExpression
;

EventHandlerName : Identifier
;

ImplementedName : Identifier

LifecycleHandlerName : Class_Initialize 
| Class_Terminate
;

ProcedureBody : StatementBlock
;

StatementBlock : BlockStatement EOS
| StatementBlock BlockStatement EOS
;

BlockStatement : StatementLabelDefinition 
| RemStatement 
| Statement
;

Statement : ControlStatement 
| DataManipulationStatement 
| ErrorHandlingStatement 
| FileStatement
;

StatementLabelDefinition : IdentifierStatementLabel Colon 
| LineNumberLabel  
| LineNumberLabel Colon
;

StatementLabel : IdentifierStatementLabel 
| LineNumberLabel
;

StatementLabelList : StatementLabel 
| StatementLabelList Comma StatementLabel
;

IdentifierStatementLabel : Identifier
;

LineNumberLabel : Integer
;

RemStatement : Rem CommentBody
;

ControlStatement : IfStatement 
| ControlStatementExceptMultilineIf
;

ControlStatementExceptMultilineIf : CallStatement 
| WhileStatement 
| ForStatement 
| ExitForStatement 
| DoStatement 
| ExitDoStatement 
| SingleLineIfStatement 
| SelectCaseStatement 
| StopStatement 
| GotoStatement 
| OnGotoStatement 
| GosubStatement 
| ReturnStatement 
| OnGosubStatement 
| ForEachStatement 
| ExitSubStatement 
| ExitFunctionStatement 
| ExitPropertyStatement 
| RaiseeventStatement 
| WithStatement
;

CallStatement : Call SimpleNameExpression 
| Call MemberAccessExpression 
| Call IndexExpression 
| Call WithExpression
| CallStatement ArgumentList
;

WhileStatement : While BooleanExpression EOS StatementBlock Wend
;

ForStatement : SimpleForStatement 
| ExplicitForStatement
;

SimpleForStatement : ForClause EOS StatementBlock Next
;

ExplicitForStatement : ForClause EOS StatementBlock Next BoundVariableExpression
| ForClause EOS StatementBlock NestedForStatement Comma BoundVariableExpression
;

NestedForStatement : ExplicitForStatement 
| ExplicitForEachStatement
;

ForClause : For BoundVariableExpression Equal StartValue To EndValue 
| For BoundVariableExpression Equal StartValue To EndValue StepClause
;

StartValue : Expression
;

EndValue : Expression
;

StepClause : Step StepIncrement
;

StepIncrement : Expression
;

ForEachStatement : SimpleForEachStatement 
| ExplicitForEachStatement
;

SimpleForEachStatement : ForEachClause EOS StatementBlock Next
;

ExplicitForEachStatement : ForEachClause EOS StatementBlock Next BoundVariableExpression
| ForEachClause EOS StatementBlock NestedForStatement Comma BoundVariableExpression
;

ForEachClause : For Each BoundVariableExpression In Collection
;

Collection : Expression
;

ExitForStatement : Exit For
;

DoStatement : Do EOS StatementBlock Loop
| Do ConditionClause EOS StatementBlock Loop
| Do EOS StatementBlock Loop ConditionClause
| Do ConditionClause EOS StatementBlock Loop ConditionClause
;

ConditionClause : WhileClause 
| UntilClause
;

WhileClause : While BooleanExpression
;

UntilClause : Until BooleanExpression
;

ExitDoStatement : Exit Do
;

IfStatement : If BooleanExpression Then EOL StatementBlock End If
| If BooleanExpression Then EOL StatementBlock EndIf
| If BooleanExpression Then EOL StatementBlock ElseIfBlock End If
| If BooleanExpression Then EOL StatementBlock ElseIfBlock EndIf
| If BooleanExpression Then EOL StatementBlock ElseBlock End If
| If BooleanExpression Then EOL StatementBlock ElseBlock EndIf
| If BooleanExpression Then EOL StatementBlock ElseIfBlock ElseBlock End If
| If BooleanExpression Then EOL StatementBlock ElseIfBlock ElseBlock EndIf
| IfStatement ElseIfBlock ElseBlock End If
| IfStatement ElseIfBlock ElseBlock EndIf
;

ElseIfBlock : ElseIf BooleanExpression Then EOL StatementBlock
| ElseIf BooleanExpression Then StatementBlock
;

ElseBlock : Else StatementBlock
;

SingleLineIfStatement : IfWithNonEmptyThen 
| IfWithEmptyThen
;

IfWithNonEmptyThen : If BooleanExpression Then ListOrLabel
| If BooleanExpression Then ListOrLabel SingleLineElseClause
;

IfWithEmptyThen : If BooleanExpression Then SingleLineElseClause
;

SingleLineElseClause : Else 
| Else ListOrLabel
;

ListOrLabel : StatementLabel 
| StatementLabel Colon
| StatementLabel Colon SameLineStatement
| ListOrLabel StatementLabel Colon
| ListOrLabel StatementLabel Colon SameLineStatement
| SameLineStatement
| Colon SameLineStatement
| SameLineStatement Colon
| SameLineStatement SameLineStatement
| ListOrLabel Colon SameLineStatement 
;

SameLineStatement : FileStatement 
| ErrorHandlingStatement 
| DataManipulationStatement 
| ControlStatementExceptMultilineIf
;

SelectCaseStatement : Select Case WS SelectExpression EOS End Select
| Select Case WS SelectExpression EOS
| Select Case WS SelectExpression EOS CaseClause End Select
| Select Case WS SelectExpression EOS CaseElseClause End Select
| Select Case WS SelectExpression EOS CaseClause CaseElseClause End Select 
| SelectCaseStatement CaseClause End Select
| SelectCaseStatement CaseClause CaseElseClause End Select
;

CaseClause : Case RangeClause EOS StatementBlock
| Case RangeClause Comma RangeClause EOS StatementBlock
;

CaseElseClause : Case Else EOS StatementBlock
;

RangeClause : Expression
| StartValue To EndValue
| Is ComparisonOperator Expression
;

StartValue : Expression
;

EndValue : Expression
;

SelectExpression : Expression
;

ComparisonOperator : Equal 
| Less_Than More_Than  
| More_Than Less_Than 
| Less_Than
| More_Than 
| More_Than Equal 
| Equal More_Than 
| Less_Than Equal 
| Equal Less_Than
;

StopStatement : Stop
;

GotoStatement : Go To StatementLabel
| GoTo StatementLabel
;

OnGotoStatement : On Expression GoTo StatementLabelList
;

GosubStatement : Go Sub StatementLabel
| GoSub StatementLabel
;

ReturnStatement : Return
;

OnGosubStatement : On Expression GoSub StatementLabelList
;

ExitSubStatement : Exit Sub
;

ExitFunctionStatement : Exit Function
;

ExitPropertyStatement : Exit Property
;

RaiseeventStatement : RaiseEvent Identifier
| RaiseEvent Identifier Left_Par EventArgumentList Right_Par
;

EventArgumentList : EventArgument 
| EventArgumentList Comma EventArgument
;

EventArgument : Expression
;

WithStatement : With Expression EOS StatementBlock End With
;

DataManipulationStatement : LocalVariableDeclaration 
| StaticVariableDeclaration 
| LocalConstDeclaration 
| RedimStatement 
| MidStatement 
| RsetStatement 
| LsetStatement 
| LetStatement 
| SetStatement
;

LocalVariableDeclaration : Dim VariableDeclarationList
| Dim Shared VariableDeclarationList
;

StaticVariableDeclaration : Static VariableDeclarationList
;

LocalConstDeclaration : ConstDeclaration
;

RedimStatement : Redim RedimDeclarationList
| Redim Preserve RedimDeclarationList
;

RedimDeclarationList : RedimVariableDcl 
| RedimDeclarationList Comma RedimVariableDcl
;

RedimVariableDcl : RedimTypedVariableDcl 
| RedimUntypedDcl
;

RedimTypedVariableDcl : TypedName DynamicArrayDim
;

RedimUntypedDcl : UntypedName DynamicArrayClause
;

DynamicArrayDim : Left_Par DynamicBoundsList Right_Par
;

DynamicBoundsList : DynamicDimSpec 
| DynamicBoundsList Comma DynamicDimSpec
;

DynamicDimSpec : DynamicUpperBound
| DynamicLowerBound DynamicUpperBound
;

DynamicLowerBound : IntegerExpression To
;

DynamicUpperBound : IntegerExpression
;

DynamicArrayClause : DynamicArrayDim 
| DynamicArrayDim AsClause
;

EraseStatement : Erase EraseList
;

EraseList : EraseElement
| EraseList Comma EraseElement
;

EraseElement : LExpression
;

MidStatement : ModeSpecifier Left_Par StringArgument Comma Start Right_Par Equal Expression
| ModeSpecifier Left_Par StringArgument Comma Start Comma Length Right_Par Equal Expression
;

ModeSpecifier : Mid 
| MidB
| Mids
| MidBs
;

StringArgument : BoundVariableExpression
;

Start : IntegerExpression
;

Length : IntegerExpression
;

LsetStatement : LSet BoundVariableExpression Equal Expression
;

RsetStatement : RSet BoundVariableExpression Equal Expression
;

LetStatement : Let LExpression Equal Expression
;

SetStatement : Set LExpression Equal Expression
;

ErrorHandlingStatement : OnErrorStatement 
| ResumeStatement 
| ErrorStatement
;

OnErrorStatement : On Error ErrorBehavior
;

ErrorBehavior : Resume Next
| Goto StatementLabel
;

ResumeStatement : Resume
| Resume Next
| Resume StatementLabel
;

ErrorStatement : Error ErrorNumber
;

ErrorNumber : IntegerExpression
;

FileStatement : OpenStatement 
| CloseStatement 
| SeekStatement 
| LockStatement 
| UnlockStatement 
| LineInputStatement 
| WidthStatement 
| WriteStatement 
| InputStatement 
| PutStatement 
| GetStatement
;

OpenStatement : Open PathName As FileNumber
| Open PathName ModeClause As FileNumber
| Open PathName ModeClause AccessClause As FileNumber
| Open PathName ModeClause lock As FileNumber
| Open PathName ModeClause As FileNumber LenClause  
| Open PathName ModeClause AccessClause lock As FileNumber
| Open PathName ModeClause AccessClause As FileNumber LenClause
| Open PathName ModeClause lock As FileNumber LenClause
| Open PathName AccessClause As FileNumber
| Open PathName AccessClause lock As FileNumber
| Open PathName AccessClause As FileNumber LenClause
| Open PathName AccessClause lock As FileNumber LenClause
| Open PathName lock As FileNumber
| Open PathName lock As FileNumber LenClause
| Open PathName As FileNumber LenClause
| Open PathName ModeClause AccessClause lock As FileNumber LenClause
;

PathName : Expression
;

ModeClause : For Mode
;

Mode : Append 
| Binary
| Input 
| Output 
| Random
;

AccessClause : Access access
;

access : Read 
| Write
| Read Write
;

lock : Shared
| Lock Read
| Lock Write 
| Lock Read Write
;

LenClause : Len Equal RecLength
;

RecLength : Expression
;

FileNumber : MarkedFileNumber 
| UnmarkedFileNumber
;

MarkedFileNumber : Sharp Expression
;

UnmarkedFileNumber : Expression
;

CloseStatement : Reset 
| Close 
| Close FileNumberList
;

FileNumberList : FileNumber
| FileNumberList Comma FileNumber
;

SeekStatement : Seek FileNumber Comma Position
;

Position : Expression
;

LockStatement : Lock FileNumber 
| Lock FileNumber Comma RecordRange
;

RecordRange : StartRecordNumber 
| To EndRecordNumber
| StartRecordNumber To EndRecordNumber
;

StartRecordNumber : Expression
;

EndRecordNumber : Expression
;

UnlockStatement : Unlock FileNumber
| Unlock FileNumber Comma RecordRange
;

LineInputStatement : Line Input MarkedFileNumber Comma VariableName
;

VariableName : VariableExpression
;

WidthStatement : Width MarkedFileNumber Comma LineWidth
;

LineWidth : Expression
;

PrintStatement : Print MarkedFileNumber Comma
| Print MarkedFileNumber Comma Outputlist
;

Outputlist : OutputItem
| Outputlist OutputItem
;

OutputItem : OutputClause
| CharPosition
| OutputClause CharPosition
;

OutputClause : SpcClause 
| TabClause 
| OutputExpression
;

CharPosition : Semi_Colon 
| Comma 
;

OutputExpression : Expression
;

SpcClause : Spc Left_Par SpcNumber Right_Par
;

SpcNumber : Expression
;

TabClause : Tab
| Tab TabNumberClause
;

TabNumberClause : Left_Par TabNumber Right_Par
;

TabNumber : Expression
;

WriteStatement : Write MarkedFileNumber Comma
| Write MarkedFileNumber Comma Outputlist
;

InputStatement : Input MarkedFileNumber Comma InputList
;

InputList : InputVariable
| InputList : InputVariable Comma InputVariable
;

InputVariable : BoundVariableExpression
;

PutStatement : Put FileNumber Comma data
| Put FileNumber Comma RecordNumber Comma data
;

RecordNumber : Expression
;

data : Expression
;

GetStatement : Get FileNumber Comma Variable
| Get FileNumber Comma RecordNumber Comma Variable
;

Variable : VariableExpression
;

FinalExpression: Expression { }
;

Expression : ValueExpression {}
| LExpression
;

ValueExpression : LiteralExpression {}
| ParenthesizedExpression 
| TypeofIsExpression 
| NewExpression 
| OperatorExpression {}
;

LExpression : SimpleNameExpression 
| InstanceExpression 
| MemberAccessExpression 
| IndexExpression 
| DictionaryAccessExpression 
| WithExpression
;

LiteralExpression : INTEGER 
{ 
}
| FLOAT 
| DATE 
| STRING 
| LiteralIdentifier
| LiteralIdentifier TypeSuffix
;

ParenthesizedExpression : Left_Par Expression Right_Par
;

TypeofIsExpression : Typeof Expression Is TypeExpression
;

NewExpression : New TypeExpression
;

OperatorExpression : ArithmeticOperator { }
| ConcatenationOperator 
| RelationalOperator 
| LikeOperator 
| IsOperator 
| LogicalOperator
;

ArithmeticOperator : UnaryMinusOperator {}
| AdditionOperator { }
| SubtractionOperator {}
| MultiplicationOperator {}
| DivisionOperator {}
| IntegerDivisionOperator {}
| ModuloOperator {}
| ExponentiationOperator {}
;

UnaryMinusOperator : Score Expression { }
;

AdditionOperator : Expression Plus Expression {}
;

SubtractionOperator : Expression Score Expression {}
;

MultiplicationOperator : Expression Ast Expression {}
;

DivisionOperator : Expression Slash Expression { }
;

IntegerDivisionOperator : Expression Back_Slash Expression { 
}
;

ModuloOperator : Expression Mod Expression { }
;

ExponentiationOperator : Expression Cone Expression { 
}
;

ConcatenationOperator : Expression Amp Expression
;

RelationalOperator : EqualityOperator 
| InequalityOperator 
| LessThanOperator 
| GreaterThanOperator 
| LessThanEqualOperator 
| GreaterThanEqualOperator
;

EqualityOperator : Expression Equal Expression
;

InequalityOperator : Expression Less_Than More_Than Expression
| Expression More_Than Less_Than Expression
;

LessThanOperator : Expression Less_Than Expression
;

GreaterThanOperator : Expression More_Than Expression
;

LessThanEqualOperator : Expression Less_Than Equal Expression
| Expression Equal Less_Than Expression
;

GreaterThanEqualOperator : Expression More_Than Equal Expression
| Expression Equal More_Than Expression
;

LikeOperator : Expression Like LikePatternExpression
;

LikePatternExpression : Expression
;

LikePatternString : LikePatternElement
| LikePatternString LikePatternElement
;

LikePatternElement : LikePatternChar 
| Question 
| Sharp 
| Ast 
| LikePatternCharlist
;

LikePatternChar : 
;

LikePatternCharlist : Left_Bra LikePatternCharlistElement Right_Bra
| Left_Bra Exclamation LikePatternCharlistElement Right_Bra
| Left_Bra LikePatternCharlistElement Score Right_Bra
| Left_Bra Score LikePatternCharlistElement Right_Bra
| Left_Bra Exclamation Score LikePatternCharlistElement Right_Bra
| Left_Bra Exclamation LikePatternCharlistElement Score Right_Bra
| Left_Bra Score LikePatternCharlistElement Score Right_Bra
| Left_Bra Exclamation Score LikePatternCharlistElement Score Right_Bra
;

LikePatternCharlistElement : LikePatternCharlistChar 
| LikePatternCharlistRange
;

LikePatternCharlistRange : LikePatternCharlistChar Score LikePatternCharlistChar
;

LikePatternCharlistChar : 
;

IsOperator : Expression Is Expression
;

LogicalOperator : NotOperator 
| AndOperator 
| OrOperator 
| XorOperator 
| ImpOperator 
| EqvOperator
;

NotOperator : Not Expression
;

AndOperator : Expression And Expression
;

OrOperator : Expression Or Expression
;

XorOperator : Expression Xor Expression
;

EqvOperator : Expression Eqv Expression
;

ImpOperator : Expression Imp Expression
;

SimpleNameExpression : Name
;

InstanceExpression : Me
;

MemberAccessExpression : LExpression Period UnrestrictedName
| LExpression LineContinuation Period UnrestrictedName
;

IndexExpression : LExpression Left_Par ArgumentList Right_Par
;

ArgumentList : PositionalOrNamedArgumentList
;

PositionalOrNamedArgumentList : PositionalArgument Comma
| PositionalOrNamedArgumentList RequiredPositionalArgument
| PositionalOrNamedArgumentList NamedArgumentList
;

PositionalArgument : ArgumentExpression
;

RequiredPositionalArgument : ArgumentExpression
;

NamedArgumentList : NamedArgument 
| NamedArgumentList Comma NamedArgument
;

NamedArgument : UnrestrictedName Colon Equal ArgumentExpression
;

ArgumentExpression : Byval Expression
| AddressofExpression
;

DictionaryAccessExpression : LExpression Exclamation UnrestrictedName
| LExpression LineContinuation Exclamation UnrestrictedName
| LExpression LineContinuation Exclamation LineContinuation UnrestrictedName
;

WithExpression : WithMemberAccessExpression 
| WithDictionaryAccessExpression
;

WithMemberAccessExpression : Period UnrestrictedName
;

WithDictionaryAccessExpression : Exclamation UnrestrictedName
;

ConstantExpression : Expression
;

CcExpression : Expression
;

BooleanExpression : Expression
;

IntegerExpression : Expression
;

VariableExpression : LExpression
;

BoundVariableExpression : LExpression
;

TypeExpression : BuiltinType 
| DefinedTypeExpression
;

DefinedTypeExpression : SimpleNameExpression 
| MemberAccessExpression
;

AddressofExpression : Addressof ProcedurePointerExpression
;

ProcedurePointerExpression : SimpleNameExpression 
| MemberAccessExpression
;

ModuleBodyLogicalStructure : ExtendedLine
| ModuleBodyLogicalStructure ExtendedLine
;

ExtendedLine : LineContinuation LineTerminator
| NonLineTerminationCharacter LineTerminator
| ExtendedLine LineContinuation LineTerminator
| ExtendedLine NonLineTerminationCharacter LineTerminator
;

LineContinuation : WSC Underscore WSC LineTerminator
;

EOS : EOL
| Colon
| EOS EOL
| EOS Colon
;

WS : WSC
| LineContinuation
| WSC WS
| LineContinuation WS
;

EOL : WS
;

WSC : Tab 
| Eom
| Space 
| DBCSWhitespace 
| ClassZs
;

LineTerminator : CR Control 
| CR
| Control
| LS
| PS
;

ReservedIdentifier : StatementKeyword 
| MarkerKeyword 
| OperatorIdentifier 
| SpecialForm 
| ReservedName 
| LiteralIdentifier 
| RemKeyword 
| ReservedForImplementationUse 
| FutureReserved

StatementKeyword : Call
| Case 
| Close 
| Const
| Declare 
| DefBool 
| DefByte 
| DefCur 
| DefDate 
| DefDbl 
| DefInt 
| DefLng 
| DefLngLng 
| DefLngPtr 
| DefObj 
| DefSng 
| DefStr 
| DefVar 
| Dim 
| Do 
| Else 
| ElseIf 
| End 
| EndIf 
| Enum 
| Erase 
| Event 
| Exit 
| For 
| Friend 
| Function 
| Get 
| Global 
| GoSub 
| GoTo 
| If 
| Implements
| Input 
| Let 
| Lock 
| Loop 
| LSet 
| Next 
| On 
| Open 
| Option 
| Print 
| Private 
| Public 
| Put 
| RaiseEvent 
| ReDim 
| Resume 
| Return 
| RSet 
| Seek 
| Select 
| Set 
| Static 
| Stop 
| Sub 
| Type 
| Unlock 
| Wend 
| While 
| With 
| Write
;

MarkerKeyword : Any
| As
| ByRef 
| ByVal
| Case
| Each
| In
| New
| Shared
| Until
| WithEvents
| Optional
| ParamArray
| Preserve
| Spc
| Then
| To
;

OperatorIdentifier : AddressOf
| And
| Eqv
| Imp
| Is
| Like
| Mod
| Not
| Or
| TypeOf 
| Xor
;

SpecialForm : Array
| Circle 
| Input
| InputB 
| LBound 
| Scale
| UBound
;

ReservedName : Abs
| CBool
| CByte
| CCur
| CDate
| CDbl
| CDec
| CInt
| CLng
| CLngLng
| CLngPtr
| CSng
| CStr
| CVar
| CVErr
| Date
| Debug
| DoEvents
| Fix
| Int
| Len
| LenB
| Me
| PSet
| Scale
| Sgn
| String
;

LiteralIdentifier : BooleanLiteralIdentifier 
| ObjectLiteralIdentifier 
| VariantLiteralIdentifier 
;

BooleanLiteralIdentifier: True
| False
;

ObjectLiteralIdentifier : Nothing
;

VariantLiteralIdentifier : Empty 
| Null
;

RemKeyword : Rem
;

ReservedForImplementationUse : Attribute 
| LINEINPUT
| VB_Base
| VB_Control
| VB_Creatable
| VB_Customizable
| VB_Description
| VB_Exposed
| VB_Ext_KEY 
| VB_GlobalNameSpace
| VB_HelpID
| VB_Invoke_Func
| VB_Invoke_Property 
| VB_Invoke_PropertyPut
| VB_Invoke_PropertyPutRef
| VB_MemberFlags
| VB_Name
| VB_PredeclaredId
| VB_ProcData
| VB_TemplateDerived
| VB_UserMemId
| VB_VarDescription
| VB_VarHelpID
| VB_VarMemberFlags
| VB_VarProcData 
| VB_VarUserMemId
;

FutureReserved : CDecl 
| Decimal 
| DefDec
;

TypedName : Identifier 
|Identifier TypeSuffix
;

TypeSuffix : Percent
| Amp 
| Cone 
| Exclamation
| Sharp
| At
| Dollar
;

BuiltinType : ReservedTypeIdentifier 
| Left_Bra ReservedTypeIdentifier Right_Bra 
| Object 
| Left_Bra Object Right_Bra
;

ReservedTypeIdentifier : Boolean
| Byte
| Currency
| Date
| Double
| Integer
| Long
| LongLong
| LongPtr
| Single
| String
| Variant
;

NonLineTerminationCharacter :
;

REGLA : TOKEN {}
| REGLA TOKEN {}
;

ExpVar : Expression
;

IdenVar : Identifier
;

INTEGER : IntegerLiteral {$$ = $1;}
;
%%