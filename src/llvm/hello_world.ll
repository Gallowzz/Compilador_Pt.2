declare i32 @printf(i8* ,...)
declare void @exit(i32)

; Define is for function implementations
define i32 @main() {
entry:
    ; Local Values
    %str_ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i32 0, i32 0
    %call = call i32 (i8*, ...) @printf(i8* %str_ptr)
    ret i32 0
}

; Global Value
; [15 x i8] is an array of size 15 and type i8
; \0A is equivalent to newline [\n] in hexadecimal
; \00 is equivalent to the null character (null terminated string) all C lib functions expect this
@.str = private constant [15 x i8] c"Hello, World!\0A\00" ; constant is for variables
