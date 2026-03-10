define i32 @sum_to_n(i32 %n){
entry:
    %i_ptr = alloca i32, align 4
    store i32 1, i32* %i_ptr, align 4
    %sum_ptr = alloca i32, align 4
    store i32 0, i32* %sum_ptr, align 4
while_cond:
    %i = load i32, i32* %i_ptr, align 4
    %cond = icmp sle i32 %i, %n
    br i1 %cond, label %while_true, %while_false
while_true:

while_false:
}
