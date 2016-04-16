%option noyywrap nodefault
    /*** Definition section ***/
%{
	#include "heading.h"
	#include "tok.h"
	int yyerror(char *s);
	int yylineno = 1;

	#define MAX_STR_CONST 512
  char string_buf[MAX_STR_CONST];
  char *string_buf_ptr;
%}

Call 						Call
Close 					Close
Const 					Const
Declare 				Declare
DefBool 				Defbool
DefByte 				Defbyte
DefCur 					Defcur
DefDate 				Defdate
DefDbl 					Defdbl
DefInt 					Defint
DefLng 					Deflng
DefLngLng 			Deflnglng
DefLngPtr 			Deflngptr
DefObj 					Defobj
DefSng 					Defsng
DefStr 					Defstr
DefVar 					Defvar
Dim 						Dim
Do 							Do
Else 						Else
ElseIf 					Elseif
End 						End
EndIf 					Endif
Enum 						Enum
Erase 					Erase
Event 					Event
Exit 						Exit
For 						For
Friend 					Friend
Function 				Function
Get 						Get
Global 					Global
GoSub 					Gosub
GoTo 						Goto
If 							If
Implements 			Implements
Input 					Input
Let 						Let
Lock 						Lock
Loop 						Loop
LSet 						Lset
Next 						Next
On 							On
Open 						Open
Option 					Option
Print 					Print
Private 				Private
Public 					Public
Put 						Put
RaiseEvent 			Raiseevent
ReDim 					Redim
Resume 					Resume
Return 					Return
RSet 						Rset
Seek 						Seek
Select 					Select
Set 						Set
Static 					Static
Stop 						Stop
Sub 						Sub
Type 						Type
Unlock 					Unlock
Wend 						Wend
While 					While
With 						With
Write 					Write
Rem 						Rem
Any 						Any
As 							As
ByRef  					Byref 
ByVal 					Byval
Case 						Case
Each 						Each
In 							In
New 						New
Shared 					Shared
Until 					Until
WithEvents 			Withevents
Optional 				Optional
ParamArray 			Paramarray
Preserve 				Preserve
Spc 						Spc
Then 						Then
To 							To
AddressOf 			Addressof
And 						And
Eqv 						Eqv
Imp 						Imp
Is 							Is
Like 						Like
Mod 						Mod
Not 						Not
Or 							Or
TypeOf  				Typeof 
Xor 						Xor
Abs 						Abs
CBool 					Cbool
CByte 					Cbyte
CCur 						Ccur
CDate 					Cdate
CDbl 						Cdbl
CDec 						Cdec
CInt 						Cint
CLng 						Clng
CLngLng 				Clnglng
CLngPtr 				Clngptr
CSng 						Csng
CStr 						Cstr
CVar 						Cvar
CVErr 					Cverr
Date 						Date
Debug 					Debug
DoEvents 				Doevents
Fix 						Fix
Int 						Int
Len 						Len
LenB 						Lenb
Me 							Me
PSet 						Pset
Scale 					Scale
Sgn 						Sgn
String 					String
Array 					Array
Circle 					Circle
InputB 					Inputb
LBound 					Lbound
UBound 					Ubound
Boolean 				Boolean
Byte 						Byte
Currency 				Currency
Double 					Double
Integer 				Integer
Long 						Long
LongLong 				LongLong
LongPtr 				LongPtr
Single 					Single
Variant 				Variant
True  					True 
False 					False
Nothing 				Nothing
Empty  					Empty 
Null 						Null
Attribute 					Attribute
LINEINPUT  					Lineinput 
VB_Base 					Vb_base
VB_Control 					Vb_Control
VB_Creatable 				Vb_creatable
VB_Customizable 			Vb_customizable
VB_Description 				Vb_description
VB_Exposed 					VB_exposed
VB_Ext_KEY  				Vb_ext_key 
VB_GlobalNameSpace 			Vb_globalnameSpace
VB_HelpID 					Vb_helpid
VB_Invoke_Func 				Vb_invoke_func
VB_Invoke_Property  		Vb_invoke_property 
VB_Invoke_PropertyPut 		Vb_invoke_propertyput
VB_Invoke_PropertyPutRef 	Vb_invoke_propertyputref
VB_MemberFlags 				VB_MemberFlags
VB_Name 					Vb_name
VB_PredeclaredId 			Vb_predeclaredid
VB_ProcData 				Vb_procdata
VB_TemplateDerived 			Vb_templatederived
VB_UserMemId 				Vb_usermemid
VB_VarDescription 			Vb_vardescription
VB_VarHelpID 				Vb_varhelpid
VB_VarMemberFlags 			Vb_varmemberflags
VB_VarProcData  			Vb_varprocdata 
VB_VarUserMemId 			Vb_varusermemid
CDecl 						Cdecl
Decimal 					Decimal
DefDec 						Defdec
Object 						Object
Identifier 					Identifier
Alias 						Alias
Lib 						Lib
Base 						Base
Explicit 					Explicit
Module 						Module
Compare 					Compare
Binary 						Binary
Text 						Text
Ptrsafe 					Ptrsafe
Class_Initialize 			Class_initialize
Class_Terminate 			Class_terminate

/*** Special Characters ***/
Comma 			\,
Period 			\.
Exclamation 	\! 
Sharp 			\#
Percent 		\%
At 				\@
Dollar 			\$
Amp 			\&
Left_Par 		\( 
Right_Par 		\)
Left_Bra 		\[
Right_Bra 		\]
Ast 			\*
Plus 			\+
Score 			\-
Slash 			\/
Colon 			\:
Semi_Colon 		\;
Less_Than 		\<
Equal 			\=
More_Than 		\> 
Question 		\?
Back_Slash 		\\
Cone 			\^
Single_Quote 	\'
Double_Quote 	\"
Tab 			\x0009
Eom 			\x0019
Space 			\x0020
Underscore		\x005F
DBCSWhitespace 	\x3000

/*** Unicode Characters ***/
CR 				\x000D
Control 	\x000A
LS 				\x2028
PS 				\x2029

/*Data type value*/
octaldigit [0-7]
decimaldigit [0-9]
decimalliteral {decimaldigit}+
integerliteral {decimalliteral}

Token 			token

whitespace \s
toProper .

/* La captura de un token tipo string es compleja. Ver http://flex.sourceforge.net/manual/Start-Conditions.html */
%x str

%%
    /*** Rules sections ***/
[ \t\n]         ;
		/*** Max Code ***/
\"      string_buf_ptr = string_buf; BEGIN(str);
     
<str>\"	{	/* saw closing quote - all done */
        	BEGIN(INITIAL);
            *string_buf_ptr = '\0';
            /* return string constant token type and
             * value to parser
             */
            yylval.s= string_buf;
            return STRING;
        }
     
<str>\n {
            /* error - unterminated string constant */
            /* generate error message */
            yyerror("String no terminada");
        }
     
<str>\\[0-7]{1,3} {
                 /* octal escape sequence */
                 int result;
                 (void) sscanf( yytext + 1, "%o", &result );
                 if ( result > 0xff )
                         /* error, constant is out-of-bounds */
                    yyerror("Caracter octal fuera de rango");
                 *string_buf_ptr++ = result;
                 }
     
<str>\\[0-9]+ {
                 /* generate error - bad escape sequence; something
                  * like '\48' or '\0777777'
                  */
                  yyerror("Secuencia de escape ilegal");
              }
     
<str>\\n  *string_buf_ptr++ = '\n';
<str>\\t  *string_buf_ptr++ = '\t';
<str>\\r  *string_buf_ptr++ = '\r';
<str>\\b  *string_buf_ptr++ = '\b';
<str>\\f  *string_buf_ptr++ = '\f';
     
<str>\\(.|\n)  *string_buf_ptr++ = yytext[1];
     
<str>[^\\\n\"]+        {
                 char *yptr = yytext;
                 while ( *yptr )
                         *string_buf_ptr++ = *yptr++;
                 }
		/***Max's Code***/
{whitespace} {}
{toProper}  {}

{Token} { return TOKEN; }

{Call} { return Call;}

{Close} { return Close; }

{Const} { return Const; }

{Declare} { return Declare; }

{DefBool} { return DefBool; }

{DefByte} { return DefByte; }

{DefCur} { return DefCur; }

{DefDate} { return DefDate; }

{DefDbl} { return DefDbl; }

{DefInt} { return DefInt; }

{DefLng} { return DefLng; }

{DefLngLng} { return DefLngLng; }

{DefLngPtr} { return DefLngPtr; }

{DefObj} { return DefObj; }

{DefSng} { return DefSng; }

{DefStr} { return DefStr; }

{DefVar} { return DefVar; }

{Dim} { return Dim; }

{Do} { return Do; }

{Else} { return Else; }

{ElseIf} { return ElseIf; }

{End} { return End; }

{EndIf} { return EndIf; }

{Enum} { return Enum; }

{Erase} { return Erase; }

{Event} { return Event; }

{Exit} { return Exit; }

{For} { return For; }

{Friend} { return Friend; }

{Function} { return Function; }

{Get} { return Get; }

{Global} { return Global; }

{GoSub} { return GoSub; }

{GoTo} { return GoTo; }

{If} { return If; }

{Implements} { return Implements; }

{Input} { return Input; }

{Let} { return Let; }

{Lock} { return Lock; }

{Loop} { return Loop; }

{LSet} { return LSet; }

{Next} { return Next; }

{On} { return On; }

{Open} { return Open; }

{Option} { return Option; }

{Print} { return Print; }

{Private} { return Private; }

{Public} { return Public; }

{Put} { return Put; }

{RaiseEvent} { return RaiseEvent; }

{ReDim} { return ReDim; }

{Resume} { return Resume; }

{Return} { return Return; }

{RSet} { return RSet; }

{Seek} { return Seek; }

{Select} { return Select; }

{Set} { return Set; }

{Static} { return Static; }

{Stop} { return Stop; }

{Sub} { return Sub; }

{Type} { return Type; }

{Unlock} { return Unlock; }

{Wend} { return Wend; }

{While} { return While; }

{With} { return With; }

{Write} { return Write; }

{Rem} { return Rem; }

{Any} { return Any; }

{As} { return As; }

{ByRef} { return ByRef; }

{ByVal} { return ByVal; }

{Case} { return Case; }

{Each} { return Each; }

{In} { return In; }

{New} { return New; }

{Shared} { return Shared; }

{Until} { return Until; }

{WithEvents} { return WithEvents; }

{Optional} { return Optional; }

{ParamArray} { return ParamArray; }

{Preserve} { return Preserve; }

{Spc} { return Spc; }

{Then} { return Then; }

{To} { return To; }

{AddressOf} { return AddressOf; }

{And} { return And; }

{Eqv} { return Eqv; }

{Imp} { return Imp; }

{Is} { return Is; }

{Like} { return Like; }

{Mod} { return Mod; }

{Not} { return Not; }

{Or} { return Or; }

{TypeOf} { return TypeOf; }

{Xor} { return Xor; }

{Abs} { return Abs; }

{CBool} { return CBool; }

{CByte} { return CByte; }

{CCur} { return CCur; }

{CDate} { return CDate; }

{CDbl} { return CDbl; }

{CDec} { return CDec; }

{CInt} { return CInt; }

{CLng} { return CLng; }

{CLngLng} { return CLngLng; }

{CLngPtr} { return CLngPtr; }

{CSng} { return CSng; }

{CStr} { return CStr; }

{CVar} { return CVar; }

{CVErr} { return CVErr; }

{Date} { return Date; }

{Debug} { return Debug; }

{DoEvents} { return DoEvents; }

{Fix} { return Fix; }

{Int} { return Int; }

{Len} { return Len; }

{LenB} { return LenB; }

{Me} { return Me; }

{PSet} { return PSet; }

{Scale} { return Scale; }

{Sgn} { return Sgn; }

{String} { return String; }

{Array} { return Array; }

{Circle} { return Circle; }

{InputB} { return InputB; }

{LBound} { return LBound; }

{UBound} { return UBound; }

{Boolean} { return Boolean; }

{Byte} { return Byte; }

{Currency} { return Currency; }

{Double} { return Double; }

{Integer} { return Integer; }

{Long} { return Long; }

{LongLong} { return LongLong; }

{LongPtr} { return LongPtr; }

{Single} { return Single; }

{Variant} { return Variant; }

{True} { return True; }

{False} { return False; }

{Nothing} { return Nothing; }

{Empty} { return Empty; }

{Null} { return Null; }

{Attribute} { return Attribute; }

{LINEINPUT} { return LINEINPUT; }

{VB_Base} { return VB_Base; }

{VB_Control} { return VB_Control; }

{VB_Creatable} { return VB_Creatable; }

{VB_Customizable} { return VB_Customizable; }

{VB_Description} { return VB_Description; }

{VB_Exposed} { return VB_Exposed; }

{VB_Ext_KEY} { return VB_Ext_KEY; }

{VB_GlobalNameSpace} { return VB_GlobalNameSpace; }

{VB_HelpID} { return VB_HelpID; }

{VB_Invoke_Func} { return VB_Invoke_Func; }

{VB_Invoke_Property} { return VB_Invoke_Property; }

{VB_Invoke_PropertyPut} { return VB_Invoke_PropertyPut; }

{VB_MemberFlags} { return VB_MemberFlags; } 

{VB_Name} { return VB_Name; }

{VB_PredeclaredId} { return VB_PredeclaredId; }

{VB_ProcData} { return VB_ProcData; }

{VB_TemplateDerived} { return VB_TemplateDerived; }

{VB_UserMemId} { return VB_UserMemId; }

{VB_VarDescription} { return VB_VarDescription; }

{VB_VarHelpID} { return VB_VarHelpID; }

{VB_VarMemberFlags} { return VB_VarMemberFlags; }

{VB_VarProcData} { return VB_VarProcData; }

{VB_VarUserMemId} { return VB_VarUserMemId; }

{CDecl} { return CDecl; }

{Decimal} { return Decimal; }

{DefDec} { return DefDec; }

{Object} { return Object; }

{Identifier} { yylval.s = yytext; return Identifier; }

{Alias} { return Alias; }

{Lib} { return Lib; }

{Base} { return Base; }

{Explicit} { return Explicit; }

{Module} { return Module; }

{Compare} { return Compare; }

{Binary} { return Binary; }

{Text} { return Text; }

{Ptrsafe} { return Ptrsafe; }

{Class_Initialize} { return Class_Initialize; }

{Class_Terminate} { return Class_Terminate; }

{Comma} { return Comma; }

{Period} { return Period; }

{Exclamation} { return Exclamation; }

{Sharp} { return Sharp; }

{Percent} { return Percent; }

{At} { return At; }

{Dollar} { return Dollar; }

{Amp} { return Amp; }

{Left_Par} { return Left_Par; }

{Right_Par} { return Right_Par; }

{Left_Bra} { return Left_Bra; }

{Right_Bra} { return Right_Bra; }

{Ast} { return Ast; }

{Plus} {  return Plus;  }

{Score} { return Score; }

{Slash} { return Slash; }

{Colon} { return Colon; }

{Semi_Colon} { return Semi_Colon; }

{Less_Than} { return Less_Than; }

{Equal} { return Equal; }

{More_Than} { return More_Than; }

{Question} { return Question; }

{Back_Slash} { return Back_Slash; }

{Cone} { return Cone; }

{Single_Quote} { return Single_Quote; }

{Double_Quote} { return Double_Quote; }

{Tab} { return Tab; }

{Eom} { return Eom; }

{Space} { return Space; }

{Underscore} { return Underscore; }

{DBCSWhitespace} { return DBCSWhitespace; }

{CR} { return CR; }

{Control} { return Control; }

{LS} { return LS; }

{PS} { return PS; }
{integerliteral} { yylval.d = atoi(yytext); return IntegerLiteral;}

[ \t]		{}
[\n]		{ yylineno++;}
.		{ std::cerr << "SCANNER "; yyerror(""); exit(1);	}

%%
    /*** C Code section ***/