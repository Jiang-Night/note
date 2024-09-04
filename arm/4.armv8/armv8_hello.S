	.text
	.file	"main.c"
	.globl	main                            // -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   // @main
	.cfi_startproc
// %bb.0:
	stp	x29, x30, [sp, #-16]!           // 将x29(当前帧指针寄存器) x30(返回地址寄存器)压入栈中，同时将栈指针 (sp) 减小 16 字节
	.cfi_def_cfa_offset 16
	mov	x29, sp							// 当前栈指针sp存入到x29中
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x0, .L.str					//加载 printf 要打印的字符串的高位地址到x0寄存器
	add	x0, x0, :lo12:.L.str			//将字符串地址的低位添加到x0中，最终得到完整的字符串地址
	bl	printf							//调用printf函数 并且x0作为参数传递
	mov	w0, wzr							//将x0寄存器的低32位清0 表示返回值为0
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16             // 恢复x29和x30 并且sp+16 平衡栈
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        // -- End function
	.type	.L.str,@object                  // @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"hello arm\n"
	.size	.L.str, 11

	.ident	"Android (12027248, +pgo, +bolt, +lto, +mlgo, based on r522817) clang version 18.0.1 (https://android.googlesource.com/toolchain/llvm-project d8003a456d14a3deb8054cdaa529ffbf02d9b262)"
	.section	".note.GNU-stack","",@progbits
