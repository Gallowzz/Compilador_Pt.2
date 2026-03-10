define i32 @max(i32 %a, i32 %b){
entry:
    %cond = icmp sgt i32 %a, %ba
    br i1 %cond, label %if, label %else
if:
    ret i32 %a
else:
    ret i32 %b
}

define i32 @main() {
    %x = alloca i32, align 4
    store i32 10, i32* %x, align 4
    %y = alloca i32, align 4
    store i32 7, i32* %y, align 4

    %x_val = load i32, i32* %x, align 4
    %y_val = load i32, i32* %y, align 4

    %res = call i32 @max(i32 %x_val, i32 %y_val)
    ret i32 %res
}
