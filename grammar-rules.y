conditional_module_body:	cc_block
cc_block:	*(cc_const | cc_if_block | logical_line)
cc_const:	LINE_START "#" "const" cc_var_lhs "=" cc_expression cc_eol
cc_var_lhs:	name
cc_eol:	[single_quote *non_line_termination_character] LINE_END
cc_if_block:	cc_if	cc_block *cc_elseif_block [cc_else_block] cc_endif
cc_if:	LINE_START "#" "if" cc_expression "then" cc_eol
cc_elseif_block:	cc_elseif cc_block
cc_elseif:	LINE_START "#" "elseif" cc_expression "then" cc_eol
cc_else_block:	cc_else cc_block
cc_else:	LINE_START "#" "else" cc_eol
cc_endif:	LINE_START "#" ("endif" | ("end" "if")) cc_eol
WS:	1*(WSC | line_continuation)
special-token:	"," / "." / "!" / "#" / "&" / "(" / ")" / "*" / "+" / "-" / "/" / ":" / "
NO_WS:	<no whitespace characters allowed here>
NO_LINE_CONTINUATION:	<a line_continuation is not allowed here>
EOL:	[WS] LINE_END | single_quote comment_body
EOS:	*(EOL | ":")
single_quote:	%x0027
comment_body:	*(line_continuation | non_line_termination_character) LINE_END
INTEGER:	integer_literal ["%" | "&" | "^"]
integer_literal:	decimal_literal | octal_literal | hex_literal
decimal_literal:	1*decimal_digit
octal_literal:	"&" [%x004F | %x006F] 1*octal_digit
hex_literal:	"&" (%x0048 | %x0068) 1*hex_digit
octal_digit:	"0" | "1" | "2" | "3" | "4" | "5" | "6" | "7"
decimal_digit:	octal_digit | "8" | "9"
hex_digit:	decimal_digit | %x0041_0046 | %x0061_0066
FLOAT:	(floating_point_literal [floating_point_type_suffix] ) | (decimal_literal floating_point_type_suffix)
floating_point_literal:	(integer_digits exponent) | (integer_digits "." [fractional_digits] [exponent]) | ( "." fractional_digits [exponent])
integer_digits:	decimal_literal
fractional_digits:	decimal_literal
exponent:	exponent_letter [sign] decimal_literal
exponent_letter:	%x0044 | %x0045 | %x0064 | %x0065
sign:	"+" | "-"
floating_point_type_suffix:	"!" | "#" | "@"
DATE:	"#" *WSC [date_or_time *WSC] "#"
date_or_time:	(date_value 1*WSC time_value) | date_value | time_value
date_value:	left_date_value date_separator middle_date_value [date_separator right_date_value]
left_date_value:	decimal_literal | month_name
middle_date_value:	decimal_literal | month_name
right_date_value:	decimal_literal | month_name
date-separator:	1*WSC / (*WSC ("/" / "-" / ",") *WSC)
month_name:	English_month_name | English_month_abbreviation
English_month_name:	"january" | "february" | "march" | "april" | "may" | "june" | "august" | "september" | "october" | "november" | "december"
English_month_abbreviation:	"jan" | "feb" | "mar" | "apr" | "jun" | "jul" | "aug" | "sep" | "oct" | "nov" | "dec"
time_value:	(hour_value ampm) | (hour_value time_separator minute_value [time_separator second_value] [ampm])
hour_value:	decimal_literal
minute_value:	decimal_literal
second_value:	decimal_literal
time_separator:	*WSC (":" | ".") *WSC
ampm:	*WSC ("am" | "pm" | "a" | "p")
STRING:	double_quote *string_character (double_quote | line_continuation | LINE_END)
double_quote:	%x0022
string_character:	NO_LINE_CONTINUATION ((double_quote double_quote) | non_line_termination_character)
lex_identifier:	Latin_identifier | codepage_identifier | Japanese_identifier | Korean_identifier | simplified_Chinese_identifier | traditional_Chinese_identifier
Latin_identifier:	first_Latin_identifier_character *subsequent_Latin_identifier_character
first_Latin_identifier_character:	(%x0041_005A | %x0061_007A)
subsequent_Latin_identifier_character:	first_Latin_identifier_character | DIGIT |%x5F
Japanese_identifier:	first_Japanese_identifier_character *subsequent_Japanese_identifier_character
first_Japanese_identifier_character:	(first_Latin_identifier_character | CP932_initial_character)
subsequent_Japanese_identifier_character:	(subsequent_Latin_identifier_character | CP932_subsequent_character)
CP932_initial_character:	< character ranges specified in Section 3.3.5.1.1>
CP932_subsequent_character:	< character ranges specified in Section 3.3.5.1.1>
Korean_identifier:	first_Korean_identifier_character *subsequent Korean _identifier_character
first_Korean_identifier_character:	(first_Latin_identifier_character | CP949_initial_character )
subsequent_Korean_identifier_character:	(subsequent_Latin_identifier_character | CP949_subsequent_character)
CP949_initial_character:	< character ranges specified in Section 3.3.5.1.2>
CP949_subsequent_character:	< character ranges specified in Section 3.3.5.1.2>
simplified_Chinese_identifier:	first_sChinese_identifier_character *subsequent_sChinese_identifier_character
first_sChinese_identifier_character:	(first_Latin_identifier_character | CP936_initial_character)
subsequent_sChinese_identifier_character:	(subsequent_Latin_identifier_character | CP936_subsequent_character)
CP936_initial_character:	< character ranges specified in Section 3.3.5.1.3>
CP936_subsequent_character:	< character ranges specified in Section 3.3.5.1.3>
traditional_Chinese_identifier:	first_tChinese_identifier_character *subsequent_tChinese_identifier_character
first_tChinese_identifier_character:	(first_Latin_identifier_character | CP950_initial_character)
subsequent_tChinese_identifier_character:	(subsequent_Latin_identifier_character | CP950_subsequent_character)
CP950_initial_character:	< character ranges specified in Section 3.3.5.1.4>
CP950_subsequent_character:	< character ranges specified in Section 3.3.5.1.4>
codepage_identifier:	(first_Latin_identifier_character | CP2_character) *(subsequent_Latin_identifier_character | CP2_character)
CP2_character:	<any Unicode character that has a mapping to the character range %x80_FF in a Microsoft Windows supported code page>
reserved_identifier:	Statement_keyword | marker_keyword | operator_identifier | special_form | reserved_name | literal_identifier | rem_keyword | reserved_for_implementation_use | future_reserved
IDENTIFIER:	<any lex_identifier that is not a reserved_identifier>
Statement_keyword:	"Call" | "Case" |"Close" | "Const"| "Declare" | "DefBool" | "DefByte" | "DefCur" | "DefDate" | "DefDbl" | "DefInt" | "DefLng" | "DefLngLng" | "DefLngPtr" | "DefObj" | "DefSng" | "DefStr" | "DefVar" | "Dim" | "Do" | "Else" | "ElseIf" | "End" | "EndIf" | "Enum" | "Erase" | "Event" | "Exit" | "For" | "Friend" | "Function" | "Get" | "Global" | "GoSub" | "GoTo" | "If" | "Implements"| "Input" | "Let" | "Lock" | "Loop" | "LSet" | "Next" | "On" | "Open" | "Option" | "Print" | "Private" | "Public" | "Put" | "RaiseEvent" | "ReDim" | "Resume" | "Return" | "RSet" | "Seek" | "Select" | "Set" | "Static" | "Stop" | "Sub" | "Type" | "Unlock" | "Wend" | "While" | "With" | "Write"
rem_keyword:	"Rem"
marker_keyword:	"Any" / "As"/ "ByRef" / "ByVal "/"Case" / "Each" / "Else" /"In"/ "New" / "Shared" / "Until" / "WithEvents" / "Write" / "Optional" / "ParamArray" / "Preserve" / "Spc" / "Tab" / "Then" / "To"
operator_identifier:	"AddressOf" | "And" | "Eqv" | "Imp" | "Is" | "Like" | "New" | "Mod" | "Not" | "Or" | "TypeOf" | "Xor"
reserved_name:	"Abs" | "CBool" | "CByte" | "CCur" | "CDate" | "CDbl" | "CDec" | "CInt" | "CLng" | "CLngLng" | "CLngPtr" | "CSng" | "CStr" | "CVar" | "CVErr" | "Date" | "Debug" | "DoEvents" | "Fix" | "Int" | "Len" | "LenB" | "Me" | "PSet" | "Scale" | "Sgn" | "String"
special_form:	"Array" | "Circle" | "Input" | "InputB" | "LBound" | "Scale" | "UBound"
reserved_type_identifier:	"Boolean" | "Byte" | "Currency" | "Date" | "Double" | "Integer" | "Long" | "LongLong" | "LongPtr" | "Single" | "String" | "Variant"
literal_identifier:	boolean_literal_identifier | object_literal_identifier | variant_literal_identifier
boolean_literal_identifier:	"true" | "false"
object_literal_identifier:	"nothing"
variant_literal_identifier:	"empty" | "null"
reserved_for_implementation_use:	"Attribute" | "LINEINPUT" | "VB_Base" | "VB_Control" | "VB_Creatable" | "VB_Customizable" | "VB_Description" | "VB_Exposed" | "VB_Ext_KEY " | "VB_GlobalNameSpace" | "VB_HelpID" | "VB_Invoke_Func" | "VB_Invoke_Property " | "VB_Invoke_PropertyPut" | "VB_Invoke_PropertyPutRefVB_MemberFlags" | "VB_Name" | "VB_PredeclaredId" | "VB_ProcData" | "VB_TemplateDerived" | "VB_UserMemId" | "VB_VarDescription" | "VB_VarHelpID" | "VB_VarMemberFlags" | "VB_VarProcData " | "VB_VarUserMemId"
future_reserved:	"CDecl" | "Decimal" | "DefDec"
FOREIGN_NAME:	"[" foreign_identifier "]"
foreign_identifier:	1*non_line_termination_character
BUILTIN_TYPE:	reserved_type_identifier | ("[" reserved_type_identifier "]") | "object" | "[object]"
TYPED_NAME:	IDENTIFIER type_suffix
type_suffix:	"%" | "&" | "^" | "!" | "#" | "@" | "$"
module_body_logical_structure:	*extended_line
extended_line:	*(line_continuation | non_line_termination_character) line_terminator
line_continuation:	*WSC underscore *WSC line_terminator
WSC:	(tab_character | eom_character |space_character | DBCS_whitespace | most_Unicode_class_Zs)
tab_character:	%x0009
eom_character:	%x0019
space_character:	%x0020
underscore:	%x005F
DBCS_whitespace:	%x3000
most_Unicode_class_Zs:	<all members of Unicode class Zs which are not CP2_characters>
module_body_lines:	*logical_line
logical_line:	LINE_START *extended_line LINE_END
procedural_module:	LINE_START procedural_module_header EOS LINE_START procedural_module_body
class_module:	LINE_START class_module_header LINE_START class_module_body
procedural_module_header:	attribute "VB_Name" attr_eq quoted_identifier attr_end
class_module_header:	1*class_attr
class_attr:	attribute "VB_Name" attr_eq quoted_identifier attr_end | attribute "VB_GlobalNameSpace" attr_eq "False" attr_end | attribute "VB_Creatable" attr_eq "False" attr_end | attribute "VB_PredeclaredId" attr_eq boolean_literal_identifier attr_end | attribute "VB_Exposed" attr_eq boolean_literal_identifier attr_end | attribute "VB_Customizable" attr_eq boolean_literal_identifier attr_end
attribute:	LINE_START "Attribute"
attr_eq:	"="
attr_end:	LINE_END
quoted_identifier:	double_quote NO_WS IDENTIFIER NO_WS double_quote
procedural_module_body:	LINE_START procedural_module_declaration_section LINE_START procedural_module_code_section
class_module_body:	LINE_START class_module_declaration_section LINE_START class_module_code_section
unrestricted_name:	name | reserved_identifier
name:	untyped_name | TYPED_NAME
untyped_name:	IDENTIFIER | FOREIGN_NAME
procedural_module_declaration_section:	[*(procedural_module_directive_element EOS) def_directive] *( procedural_module_declaration_element EOS)
class_module_declaration_section:	[*(class_module_directive_element EOS) def_directive] *(class_module_declaration_element EOS)
procedural_module_directive_element:	common_option_directive | option_private_directive | def_directive
procedural_module_declaration_element:	common_module_declaration_element | global_variable_declaration | public_const_declaration | public_type_declaration | public_external_procedure_declaration | global_enum_declaration | common_option_directive | option_private_directive
class_module_directive_element:	common_option_directive | def_directive | implements_directive
class_module_declaration_element:	common_module_declaration_element | event_declaration | common_option_directive | implements_directive
common_option_directive:	option_compare_directive | option_base_directive | option_explicit_directive | rem_statement
option_compare_directive:	"Option" "Compare" ( "Binary" | "Text")
option_base_directive:	"Option" "Base" INTEGER
option_explicit_directive:	"Option" "Explicit"
option_private_directive:	"Option" "Private" "Module"
def_directive:	def_type letter_spec *( "," letter_spec)
letter_spec:	single_letter | universal_letter_range | letter_range
single_letter:	IDENTIFIER
universal-letter-range:	upper-case-A "-" upper-case-Z
upper_case_A:	IDENTIFIER
upper_case_Z:	IDENTIFIER
letter-range:	first-letter "-" last-letter
first_letter:	IDENTIFIER
last_letter:	IDENTIFIER
def_type:	"DefBool" | "DefByte" | "DefCur" | "DefDate" | "DefDbl" | "DefInt" | "DefLng" | "DefLngLng" | "DefLngPtr" | "DefObj" | "DefSng" | "DefStr" | "DefVar"
common_module_declaration_element:	module_variable_declaration common_module_declaration_element =| private_const_declaration common_module_declaration_element =| private_type_declaration common_module_declaration_element =| enum_declaration common_module_declaration_element =| private_external_procedure_declaration
module_variable_declaration:	public_variable_declaration | private_variable_declaration
global_variable_declaration:	"Global" variable_declaration_list
public_variable_declaration:	"Public" ["Shared"] module_variable_declaration_list
private_variable_declaration:	("Private" | "Dim") [ "Shared"] module_variable_declaration_list
module_variable_declaration_list:	(withevents_variable_dcl | variable_dcl) *( "," (withevents_variable_dcl | variable_dcl) )
variable_declaration_list:	variable_dcl *( "," variable_dcl )
variable_dcl:	typed_variable_dcl | untyped_variable_dcl
typed_variable_dcl:	TYPED_NAME [array_dim]
untyped_variable_dcl:	IDENTIFIER [array_clause | as_clause]
array_clause:	array_dim [as_clause]
as_clause:	as_auto_object | as_type
withevents_variable_dcl:	"withevents" IDENTIFIER "as" class_type_name
class_type_name:	defined_type_expression
array_dim:	"(" [bounds_list] ")"
bounds_list:	dim_spec *("," dim_spec)
dim_spec:	[lower_bound] upper_bound
lower_bound:	constant_expression "to"
upper_bound:	constant_expression
as_auto_object:	"as" "new" class_type_name
as_type:	"as" type_spec
type_spec:	fixed_length_string_spec | type_expression
fixed_length_string_spec:	"string" "*" string_length
string_length:	constant_name | INTEGER
constant_name:	simple_name_expression
public_const_declaration:	("Global" | "Public") module_const_declaration
private_const_declaration:	["Private"] module_const_declaration
module_const_declaration:	const_declaration
const_declaration:	"Const" const_item_list
const_item_list:	const_item *[ "," const_item]
const_item:	typed_name_const_item | untyped_name_const_item
typed_name_const_item:	TYPED_NAME "=" constant_expression
untyped_name_const_item:	IDENTIFIER [const_as_clause] "=" constant_expression
const_as_clause:	"as" BUILTIN_TYPE
public_type_declaration:	["global" | "public"] udt_declaration
private_type_declaration:	"private" udt_declaration
udt_declaration:	"type" untyped_name EOS udt_member_list EOS "end" "type"
udt_member_list:	udt_element *[EOS udt_element]
udt_element:	rem_statement | udt_member
udt_member:	reserved_name_member_dcl | untyped_name_member_dcl
untyped_name_member_dcl:	IDENTIFIER optional_array_clause
reserved_name_member_dcl:	reserved_member_name as_clause
optional_array_clause:	[array_dim] as_clause
reserved_member_name:	statement_keyword | marker_keyword | operator_identifier | special_form | reserved_name | literal_identifier | reserved_for_implementation_use | future_reserved
enum_declaration:	public_enum_declaration | private_enum_declaration
global_enum_declaration:	"global" enum_declaration
public_enum_declaration:	["public"] enum_declaration
private_enum_declaration:	"private" enum_declaration
enum_declaration:	"enum" untyped_name EOS member_list EOS "end" "enum"
member_list:	enum_element *[EOS enum_element]
enum_element:	rem_statement | enum_member
enum_member:	untyped_name [ "=" constant_expression]
public_external_procedure_declaration:	["public"] external_proc_dcl
private_external_procedure_declaration:	"private" external_proc_dcl
external_proc_dcl:	"declare" ["ptrsafe"] (external_sub | external_function)
external_sub:	"sub" subroutine_name lib_info [procedure_parameters]
external_function:	"function" function_name lib_info [procedure_parameters] [function_type]
lib_info:	lib_clause [alias_clause]
lib_clause:	"lib" STRING
alias_clause:	"alias" STRING
implements_directive:	"Implements" class_type_name
event_declaration:	["Public"] "Event" IDENTIFIER [event_parameter_list]
event_parameter_list:	"(" [positional_parameters] ")"
procedural_module_code_section:	*( LINE_START procedural_module_code_element LINE_END) class_module_code_section
procedural_module_code_element:	common_module_code_element
class_module_code_element:	common_module_code_element | implements_directive
common_module_code_element:	rem_statement |procedure_declaration
procedure_declaration:	subroutine_declaration | function_declaration | property_get_declaration | property_LHS_declaration
subroutine_declaration:	procedure_scope [initial_static] "sub" subroutine_name [procedure_parameters] [trailing_static] EOS [procedure_body EOS] [end_label] "end" "sub" procedure_tail
function_declaration:	procedure_scope [initial_static] "function" function_name [procedure_parameters] [function_type] [trailing_static] EOS [procedure_body EOS]
property_get_declaration:	procedure_scope [initial_static] "Property" "Get" function_name [procedure_parameters] [function_type] [trailing_static] EOS [procedure_body EOS] [end_label] "end" "property" procedure_tail
property_lhs_declaration:	procedure_scope [initial_static] "Property" ("Let" | "Set")
end_label:	statement_label_definition
procedure_tail:	[WS] LINE_END | single_quote comment_body | ":" rem_statement
procedure_scope:	["global" | "public" | "private" | "friend"]
initial_static:	"static"
trailing_static:	"static"
subroutine_name:	IDENTIFIER | prefixed_name
function_name:	TYPED_NAME | subroutine_name
prefixed_name:	event_handler_name | implemented_name | lifecycle_handler_name
function_type:	"as" type_expression [array_designator]
array_designator:	"(" ")"
procedure_parameters:	"(" [parameter_list] ")"
property_parameters:	"(" [parameter_list ","] value_param ")"
parameter_list:	(positional_parameters "," optional_parameters ) | (positional_parameters ["," param_array]) | optional_parameters | param_array
positional_parameters:	positional_param *("," positional_param)
optional_parameters:	optional_param *("," optional_param)
value_param:	positional_param
positional_param:	[parameter_mechanism] param_dcl
optional_param:	optional_prefix param_dcl [default_value]
param_array:	"paramarray" IDENTIFIER "(" ")" ["as" ("variant" | "[variant]")]
param_dcl:	untyped_name_param_dcl | typed_name_param_dcl
untyped_name_param_dcl:	IDENTIFIER [parameter_type]
typed_name_param_dcl:	TYPED_NAME [array_designator]
optional_prefix:	("optional" [parameter_mechanism]) | ([parameter_mechanism] ("optional"))
parameter_mechanism:	"byval" | " byref"
parameter_type:	[array_designator] "as" (type_expression | "Any")
default_value:	"=" constant_expression
event_handler_name:	IDENTIFIER
implemented_name:	IDENTIFIER
lifecycle_handler_name:	"Class_Initialize" | "Class_Terminate"
procedure_body:	statement_block
statement_block:	*(block_statement EOS)
block_statement:	statement_label_definition | rem_statement | statement
statement:	control_statement | data_manipulation_statement | error_handling_statement | file_statement
statement_label_definition:	LINE_START ((identifier_statement_label ":") | (line_number_label [":"] ))
statement_label:	identifier_statement_label | line_number_label
statement_label_list:	statement_label ["," statement_label]
identifier_statement_label:	IDENTIFIER
line_number_label:	INTEGER
rem_statement:	"Rem" comment_body
control_statement:	if_statement | control_statement_except_multiline_if
control_statement_except_multiline_if:	call_statement | while_statement | for_statement | exit_for_statement | do_statement | exit_do_statement | single_line_if_statement | select_case_statement |stop_statement | goto_statement | on_goto_statement | gosub_statement | return_statement | on_gosub_statement |for_each_statement | exit_sub_statement | exit_function_statement | exit_property_statement | raiseevent_statement | with_statement
call_statement:	"Call" (simple_name_expression | member_access_expression | index_expression | with_expression)
call_statement =| (simple_name_expression | member_access_expression | with_expression) argument_list:	
while_statement:	"While" boolean_expression EOS statement_block "Wend"
for_statement:	simple_for_statement | explicit_for_statement
simple_for_statement:	for_clause EOS statement_block "Next"
explicit_for_statement:	for_clause EOS statement_block ("Next" | (nested_for_statement ",")) bound_variable_expression
nested_for_statement:	explicit_for_statement | explicit_for_each_statement
for_clause:	"For" bound_variable_expression "=" start_value "To" end_value [step_clause]
start_value:	expression
end_value:	expression
step_clause:	"Step" step_increment
step_increment:	expression
for_each_statement:	simple_for_each_statement | explicit_for_each_statement
simple_for_each_statement:	for_each_clause EOS statement_block "Next"
explicit_for_each_statement:	for_each_clause EOS statement_block ("Next" | (nested_for_statement ",")) bound_variable_expression
for_each_clause:	"For" "Each" bound_variable_expression "In" collection
collection:	expression
exit_for_statement:	"Exit" "For"
do_statement:	"Do" [condition_clause] EOS statement_block "Loop" [condition_clause]
condition_clause:	while_clause | until_clause
while_clause:	"While" boolean_expression
until_clause:	"Until" boolean_expression
exit_do_statement:	"Exit" "Do"
if_statement:	LINE_START "If" boolean_expression "Then" EOL statement_block *[else_if_block] [else_block] LINE_START (("End" "If") | "EndIf")
else_if_block:	LINE_START "ElseIf" boolean_expression "Then" EOL LINE_START statement_block
else_if_block =| "ElseIf" boolean_expression "Then" statement_block:	
else_block:	LINE_START "Else" statement_block
single_line_if_statement:	if_with_non_empty_then | if_with_empty_then
if_with_non_empty_then:	"If" boolean_expression "Then" list_or_label [single_line_else_clause]
if_with_empty_then:	"If" boolean_expression "Then" single_line_else_clause
single_line_else_clause:	"Else" [list_or_label]
list_or_label:	(statement_label *[":" [same_line_statement]]) | ([":"] same_line_statement *[":" [same_line_statement]])
same_line_statement:	file_statement | error_handling_statement | data_manipulation_statement | control_statement_except_multiline_if
select_case_statement:	"Select" "Case" WS select_expression EOS *[case_clause] [case_else_clause] "End" "Select"
case_clause:	"Case" range_clause ["," range_clause] EOS statement_block
case_else_clause:	"Case" "Else" EOS statement_block
range_clause:	expression
range_clause =| start_value "To" end_value:	
range_clause =| ["Is"] comparison_operator expression:	
start_value:	expression
end_value:	expression
select_expression:	expression
comparison_operator:	"=" | ("<" ">" ) | (">" "<") | "<" | ">" | (">" "=") | ("=" ">") | ("<" "=") | ("=" "<")
stop_statement:	"Stop"
goto_statement:	(("Go" "To") | "GoTo") statement_label
on_goto_statement:	"On" expression "GoTo" statement_label_list
gosub_statement:	(("Go" "Sub") | "GoSub") statement_label
return_statement:	"Return"
on_gosub_statement:	"On" expression "GoSub" statement_label_list
exit_sub_statement:	"Exit" "Sub"
exit_function_statement:	"Exit" "Function"
exit_property_statement:	"Exit" "Property"
raiseevent_statement:	"RaiseEvent" IDENTIFIER ["(" event_argument_list ")"]
event_argument_list:	[event_argument *("," event_argument)]
event_argument:	expression
with_statement:	"With" expression EOS statement_block "End" "With"
Data_manipulation_statement:	local_variable_declaration | static_variable_declaration | local_const_declaration | redim_statement | mid_statement |rset_statement | lset_statement | let_statement | set_statement
local_variable_declaration:	("Dim" ["Shared"] variable_declaration_list)
static_variable_declaration:	"Static" variable_declaration_list
local_const_declaration:	const_declaration
redim_statement:	"Redim" ["Preserve"] redim_declaration_list
redim_declaration_list:	redim_variable_dcl *("," redim_variable_dcl)
redim_variable_dcl:	redim_typed_variable_dcl | redim_untyped_dcl
redim_typed_variable_dcl:	TYPED_NAME dynamic_array_dim
redim_untyped_dcl:	untyped_name dynamic_array_clause
dynamic_array_dim:	"(" dynamic_bounds_list ")"
dynamic_bounds_list:	dynamic_dim_spec *[ "," dynamic_dim_spec ]
dynamic_dim_spec:	[dynamic_lower_bound] dynamic_upper_bound
dynamic_lower_bound:	integer_expression "to"
dynamic_upper_bound:	integer_expression
dynamic_array_clause:	dynamic_array_dim [as_clause]
erase_statement:	"Erase" erase_list
erase_list:	erase_element *[ "," erase_element]
erase_element:	l_expression
mid_statement:	mode_specifier "(" string_argument "," start ["," length] ")" "=" expression
mode_specifier:	("Mid" | "MidB" | "Mid$" | "MidB$")
string_argument:	bound_variable_expression
start:	integer_expression
length:	integer_expression
lset_statement:	"LSet" bound_variable_expression "=" expression
rset_statement:	"RSet" bound_variable_expression "=" expression
let_statement:	["Let"] l_expression "=" expression
set_statement:	"Set" l_expression "=" expression
error_handling_statement:	on_error_statement | resume_statement | error_statement
on_error_statement:	"On" "Error" error_behavior
error_behavior:	("Resume" "Next") | ("Goto" statement_label)
resume_statement:	"Resume" [("Next" | statement_label)]
error_statement:	"Error" error_number
error_number:	integer_expression
file_statement:	open_statement | close_statement | seek_statement | lock_statement | unlock_statement | line_input_statement | width_statement | write_statement | input_statement | put_statement | get_statement
open_statement:	"Open" path_name [mode_clause] [access_clause] [lock] "As" file_number [len_clause]
path_name:	expression
mode_clause:	"For" mode
mode:	"Append" | "Binary" | "Input" | "Output" | "Random"
access_clause:	"Access" access
access:	"Read" | "Write" | ("Read" "Write")
lock:	"Shared" | ("Lock" "Read") | ("Lock" "Write") | ("Lock" "Read" "Write")
len_clause:	"Len"
rec_length:	expression
file_number:	marked_file_number | unmarked_file_number
marked_file_number:	"#" expression
unmarked_file_number:	expression
close_statement:	"Reset" | ("Close" [file_number_list])
file_number_list:	file_number *[ "," file_number]
seek_statement:	"Seek" file_number "," position
position:	expression
lock_statement:	"Lock" file_number [ "," record_range]
record_range:	start_record_number | ([start_record_number] "To" end_record_number)
start_record_number:	expression
end_record_number:	expression
unlock_statement:	"Unlock" file_number [ "," record_range]
line_input_statement:	"Line" "Input" marked_file_number "," variable_name
variable_name:	variable_expression
width_statement:	"Width" marked_file_number "," line_width
line_width:	expression
print_statement:	"Print" marked_file_number "," [output_list]
output_list:	*output_item
output_item:	[output_clause] [char_position]
output_clause:	(spc_clause | tab_clause | output_expression)
char_position:	( "
output_expression:	expression
spc_clause:	"Spc" "(" spc_number ")"
spc_number:	expression
tab_clause:	"Tab" [tab_number_clause]
tab_number_clause:	"(" tab_number ")"
tab_number:	expression
write_statement:	"Write" marked_file_number "," [output_list]
input_statement:	"Input" marked_file_number "," input_list
input_list:	input_variable *[ "," input_variable]
input_variable:	bound_variable_expression
put_statement:	"Put" file_number ","[record_number] "," data
record_number:	expression
data:	expression
get_statement:	"Get" file_number "," [record_number] "," variable
variable:	variable_expression
expression:	value_expression | l_expression
value_expression:	literal_expression | parenthesized_expression | typeof_is_expression | new_expression | operator_expression
l_expression:	simple_name_expression | instance_expression | member_access_expression | index_expression | dictionary_access_expression | with_expression
literal_expression:	INTEGER | FLOAT | DATE | STRING | (literal_identifier [type_suffix])
parenthesized_expression:	"(" expression ")"
typeof_is_expression:	"typeof" expression "is" type_expression
new_expression:	"new" type_expression
operator_expression:	arithmetic_operator | concatenation_operator | relational_operator | like_operator | is_operator | logical_operator
arithmetic_operator:	unary_minus_operator | addition_operator | subtraction_operator | multiplication_operator | division_operator | integer_division_operator | modulo_operator | exponentiation_operator
unary-minus-operator:	"-" expression
addition_operator:	expression "+" expression
subtraction-operator:	expression "-" expression
multiplication_operator:	expression "*" expression
division_operator:	expression "/" expression
integer_division_operator:	expression "\" expression
modulo_operator:	expression "mod" expression
exponentiation_operator:	expression "^" expression
concatenation_operator:	expression "&" expression
relational_operator:	equality_operator | inequality_operator | less_than_operator | greater_than_operator | less_than_equal_operator | greater_than_equal_operator
equality_operator:	expression "=" expression
inequality_operator:	expression ( "<"">" | ">""<" ) expression
less_than_operator:	expression "<" expression
greater_than_operator:	expression ">" expression
less_than_equal_operator:	expression ( "<""=" | "=""<" ) expression
greater_than_equal_operator:	expression ( ">""=" | "="">" ) expression
like_operator:	expression "like" like_pattern_expression
like_pattern_expression:	expression
like_pattern_string:	*like_pattern_element
like_pattern_element:	like_pattern_char | "?" | "#" | "*" | like_pattern_charlist
like_pattern_char:	<Any character except "?", "#", "*" and "[" >
like-pattern-charlist:	"[" ["!"] ["-"] *like-pattern-charlist-element ["-"] "]"
like_pattern_charlist_element:	like_pattern_charlist_char | like_pattern_charlist_range
like-pattern-charlist-range:	like-pattern-charlist-char "-" like-pattern-charlist-char
like-pattern-charlist-char:	<Any character except "-" and "]">
is_operator:	expression "is" expression
logical_operator:	not_operator | and_operator | or_operator | xor_operator | imp_operator | eqv_operator
not_operator:	"not" expression
and_operator:	expression "and" expression
or_operator:	expression "or" expression
xor_operator:	expression "xor" expression
eqv_operator:	expression "eqv" expression
imp_operator:	expression "imp" expression
simple_name_expression:	name
instance_expression:	"me"
member_access_expression:	l_expression NO_WS "." unrestricted_name
member_access_expression =| l_expression LINE_CONTINUATION "." unrestricted_name:	
index_expression:	l_expression "(" argument_list ")"
argument_list:	[positional_or_named_argument_list]
positional_or_named_argument_list:	*(positional_argument ",") required_positional_argument
positional_or_named_argument_list =| *(positional_argument ",") named_argument_list:	
positional_argument:	[argument_expression]
required_positional_argument:	argument_expression
named_argument_list:	named_argument *("," named_argument)
named_argument:	unrestricted_name ":""=" argument_expression
argument_expression:	["byval"] expression
argument_expression =| addressof_expression:	
dictionary_access_expression:	l_expression NO_WS "!" NO_WS unrestricted_name
dictionary_access_expression =| l_expression LINE_CONTINUATION "!" NO_WS unrestricted_name:	
dictionary_access_expression =| l_expression LINE_CONTINUATION "!" LINE_CONTINUATION unrestricted_name:	
with_expression:	with_member_access_expression | with_dictionary_access_expression
with_member_access_expression:	"." unrestricted_name
with_dictionary_access_expression:	"!" unrestricted_name
constant_expression:	expression
cc_expression:	expression
boolean_expression:	expression
integer_expression:	expression
variable_expression:	l_expression
bound_variable_expression:	l_expression
type_expression:	BUILTIN_TYPE | defined_type_expression
defined_type_expression:	simple_name_expression | member_access_expression
addressof_expression:	"addressof" procedure_pointer_expression
procedure_pointer_expression:	simple_name_expression | member_access_expression
module_body_physical_structure:	*source_line [non_terminated_line]
source_line:	*non_line_termination_character line_terminator
non_terminated_line:	*non_line_termination_character
line_terminator:	(%x000D %x000A) | %x000D | %x000A | %x2028 | %x2029
non_line_termination_character:	<any character other than %x000D | %x000A | %x2028 | %x2029>
