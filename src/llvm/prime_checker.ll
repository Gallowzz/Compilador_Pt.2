declare i32 @printf(i8*,...)

define i1 @isPrime(i32 %n) {
entry:
    %cond = icmp sle i32 %n, 1
    br i1 %cond, label %if1_true, label %if1_false
if1_true:
    ret i1 0
if1_false:
    %i_ptr = alloca i32, align 4
    store i32 2, i32* %i_ptr, align 4
    br label %for_begin
for_begin:
    %i_val = load i32, i32* %i_ptr, align 4
    %t0 = mul i32 %i_val, %i_val
    %for_cond = icmp sle i32 %t0, %n
    br i1 %for_cond, label %for_body, label %for_end
for_body:
    %n_mod_i = srem i32 %n, %i_val
    %if_cond = icmp eq i32 %n_mod_i, 0
    br i1 %if_cond, label %if2_true, label %if2_false
if2_true:
    ret i1 0
if2_false:
    %i.inc = add i32 %i_val, 1
    store i32 %i.inc, i32* %i_ptr
    br label %for_begin
for_end:
    ret i1 1
}

define i32 @main() {
entry:
    %x_addr = alloca i32, align 4
    store i32 29, i32* %x_addr, align 4
    %x_val = load i32, i32* %x_addr, align 4
    %res = call i1 @isPrime(i32 %x_val)
    br i1 %res, label %ifmain_true, label %ifmain_false
ifmain_true:
    %str_true = getelementptr inbounds [13 x i8], [13 x i8]* @.isprime_str, i32 0, i32 0
    call i32 (i8*,...) @printf(i8* %str_true, i32 %x_val)
    ret i32 0
ifmain_false:
    %str_false = getelementptr inbounds [17 x i8], [17 x i8]* @.notprime_str, i32 0, i32 0
    call i32 (i8*,...) @printf(i8* %str_false, i32 %x_val)
    ret i32 0
}

@.isprime_str = private constant [13 x i8] c"%d is prime\0A\00"
@.notprime_str = private constant [17 x i8] c"%d is not prime\0A\00"
