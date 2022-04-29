package dyncall
import "core:c"

when ODIN_OS == .Windows {
	foreign import lib "dyncall_s.lib"
} else {
	foreign import lib "system:dyncall_s"
}

CALL_C_DEFAULT				:: 0
CALL_C_ELLIPSIS				:: 100
CALL_C_ELLIPSIS_VARARGS		:: 101
CALL_C_X86_CDECL			::   1
CALL_C_X86_WIN32_STD		:: 2
CALL_C_X86_WIN32_FAST_MS	:: 3
CALL_C_X86_WIN32_FAST_GNU	:: 4
CALL_C_X86_WIN32_THIS_MS	:: 5
CALL_C_X86_WIN32_THIS_GNU	:: CALL_C_X86_CDECL /* alias - identical to cdecl (w/ this-ptr as 1st arg) */
CALL_C_X64_WIN64			:: 7
CALL_C_X64_SYSV				:: 8
CALL_C_PPC32_DARWIN			:: 9
CALL_C_PPC32_OSX			:: CALL_C_PPC32_DARWIN /* alias */
CALL_C_ARM_ARM_EABI			:: 10
CALL_C_ARM_THUMB_EABI		:: 11
CALL_C_ARM_ARMHF			:: 30
CALL_C_MIPS32_EABI			:: 12
CALL_C_MIPS32_PSPSDK		:: CALL_C_MIPS32_EABI /* alias - deprecated. */
CALL_C_PPC32_SYSV			:: 13
CALL_C_PPC32_LINUX			:: CALL_C_PPC32_SYSV /* alias */
CALL_C_ARM_ARM				:: 14
CALL_C_ARM_THUMB			:: 15
CALL_C_MIPS32_O32			:: 16
CALL_C_MIPS64_N32			:: 17
CALL_C_MIPS64_N64			:: 18
CALL_C_X86_PLAN9			:: 19
CALL_C_SPARC32				:: 20
CALL_C_SPARC64				:: 21
CALL_C_ARM64				:: 22
CALL_C_PPC64				:: 23
CALL_C_PPC64_LINUX			:: CALL_C_PPC64 /* alias */
CALL_SYS_DEFAULT			:: 200
CALL_SYS_X86_INT80H_LINUX	:: 201
CALL_SYS_X86_INT80H_BSD		:: 202
CALL_SYS_X64_SYSCALL_SYSV	:: 204
CALL_SYS_PPC32				:: 210
CALL_SYS_PPC64				:: 211

ERROR_NONE				:: 0
ERROR_UNSUPPORTED_MODE	:: -1

CallVM			:: struct {} // an opaque type
Struct			:: struct {} 

Bool 		:: b32
Char 		:: c.char
Uchar 		:: c.uchar
Short 		:: c.short
Ushort 		:: c.ushort
Int 		:: c.int
Uint 		:: c.uint
Long 		:: c.long
ULong 		:: c.ulong
LongLong 	:: c.longlong
ULongLong 	:: c.ulonglong
Float 		:: c.float
Double 		:: c.double
Pointer 	:: rawptr
String 		:: cstring
Size 		:: c.size_t
SigChar		:: c.char

TRUE			:: true
FALSE			:: false

DEFAULT_ALIGNMENT			:: 0

SIGCHAR_VOID 		:: 'v'
SIGCHAR_BOOL 		:: 'B'
SIGCHAR_CHAR 		:: 'c'
SIGCHAR_UCHAR 		:: 'C'
SIGCHAR_SHORT 		:: 's'
SIGCHAR_USHORT 		:: 'S'
SIGCHAR_INT 		:: 'i'
SIGCHAR_UINT 		:: 'I'
SIGCHAR_LONG 		:: 'j'
SIGCHAR_ULONG 		:: 'J'
SIGCHAR_LONGLONG 	:: 'l'
SIGCHAR_ULONGLONG 	:: 'L'
SIGCHAR_FLOAT 		:: 'f'
SIGCHAR_DOUBLE 		:: 'd'
SIGCHAR_POINTER 	:: 'p'
SIGCHAR_STRING 		:: 'Z' /* in theory same as 'p', but convenient to disambiguate */
SIGCHAR_STRUCT 		:: 'T'
SIGCHAR_ENDARG 		:: ')' /* also works for end struct */

/* calling convention / mode signatures */

SIGCHAR_CC_PREFIX				:: '_'
SIGCHAR_CC_DEFAULT				:: ':'
SIGCHAR_CC_ELLIPSIS				:: 'e'
SIGCHAR_CC_ELLIPSIS_VARARGS		:: '.'
SIGCHAR_CC_CDECL				:: 'c'
SIGCHAR_CC_STDCALL				:: 's'
SIGCHAR_CC_FASTCALL_MS			:: 'F'
SIGCHAR_CC_FASTCALL_GNU			:: 'f'
SIGCHAR_CC_THISCALL_MS			:: '+'
SIGCHAR_CC_THISCALL_GNU			:: '#' /* GNU thiscalls are cdecl, but keep specific sig char for clarity */
SIGCHAR_CC_ARM_ARM				:: 'A'
SIGCHAR_CC_ARM_THUMB			:: 'a'
SIGCHAR_CC_SYSCALL				:: '$'

@(default_calling_convention = "c", link_prefix="dc")
foreign lib {
	NewCallVM		:: proc(size: Size) -> ^CallVM ---
	Free			:: proc(vm: ^CallVM) ---
	Reset			:: proc(vm: ^CallVM) ---

	Mode			:: proc(vm: ^CallVM, mode: Int) ---
	ArgBool			:: proc(vm: ^CallVM, value: Bool) ---
	ArgChar			:: proc(vm: ^CallVM, value: Char) ---
	ArgShort		:: proc(vm: ^CallVM, value: Short) ---
	ArgInt			:: proc(vm: ^CallVM, value: Int) ---
	ArgLong			:: proc(vm: ^CallVM, value: Long) ---
	ArgLongLong		:: proc(vm: ^CallVM, value: LongLong) ---
	ArgFloat		:: proc(vm: ^CallVM, value: Float) ---
	ArgDouble		:: proc(vm: ^CallVM, value: Double) ---
	ArgPointer		:: proc(vm: ^CallVM, value: Pointer) ---
	ArgStruct		:: proc(vm: ^CallVM, s: ^Struct, value: Pointer) ---

	CallVoid		:: proc(vm: ^CallVM, func_ptr: Pointer) ---
	CallBool		:: proc(vm: ^CallVM, func_ptr: Pointer) -> Bool ---
	CallChar		:: proc(vm: ^CallVM, func_ptr: Pointer) -> Char ---
	CallShort		:: proc(vm: ^CallVM, func_ptr: Pointer) -> Short ---
	CallInt			:: proc(vm: ^CallVM, func_ptr: Pointer) -> Int ---
	CallLong		:: proc(vm: ^CallVM, func_ptr: Pointer) -> Long ---
	CallLongLong	:: proc(vm: ^CallVM, func_ptr: Pointer) -> LongLong ---
	CallFloat		:: proc(vm: ^CallVM, func_ptr: Pointer) -> Float ---
	CallDouble		:: proc(vm: ^CallVM, func_ptr: Pointer) -> Double ---
	CallPointer		:: proc(vm: ^CallVM, func_ptr: Pointer) -> Pointer ---
	CallStruct		:: proc(vm: ^CallVM, func_ptr: Pointer, s: ^Struct, return_value: Pointer) ---

	GetError		:: proc(vm: ^CallVM) -> Int ---

	NewStruct		:: proc(field_count: Size, alignment: Int) -> ^Struct ---
	StructField		:: proc(s: ^Struct, type: Int, alignment: Int, array_length: Size) ---
	SubStruct		:: proc(s: ^Struct, field_count: Size, alignment: Int, array_length: Size) ---

	/* Each dcNewStruct or dcSubStruct call must be paired with a dcCloseStruct. */

	CloseStruct		:: proc(s: ^Struct) ---
	StructSize		:: proc(s: ^Struct) -> Size ---
	StructAlignment	:: proc(s: ^Struct) -> Size ---
	FreeStruct		:: proc(s: ^Struct) ---

	DefineStruct 	:: proc(signature: cstring) -> ^Struct ---

	/* helpers */

	/* returns respective mode for callconv sig char (w/o checking if mode exists */	
	/* on current platform), or DC_ERROR_UNSUPPORTED_MODE if char isn't a sigchar */	
	GetModeFromCCSigChar :: proc(sig_char: SigChar) -> Int ---
}