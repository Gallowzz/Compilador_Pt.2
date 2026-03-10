define i32 @add_and_double (i32 %a, i32 %b) {
entry:
    %sum_res = add i32 %a, %b
    %res = mul i32 %sum_res, 2
    ret i32 %res
}

define i32 @main() {
entry:
    %x = alloca i32, align 4
    store i32 3, i32* %x, align 4
    %y = alloca i32, align 4
    store i32 4, i32* %y, align 4

    %x_val = load i32, i32* %x, align 4
    %y_val = load i32, i32* %y, align 4

    %result = call i32 @add_and_double(i32 %x_val, i32 %y_val)
    ret i32 %result
}
