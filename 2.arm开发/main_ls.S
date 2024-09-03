	.text
	.syntax unified
	.eabi_attribute	67, "2.09"	@ Tag_conformance
	.cpu	arm7tdmi
	.eabi_attribute	6, 2	@ Tag_CPU_arch
	.eabi_attribute	8, 1	@ Tag_ARM_ISA_use
	.eabi_attribute	9, 1	@ Tag_THUMB_ISA_use
	.eabi_attribute	34, 0	@ Tag_CPU_unaligned_access
	.eabi_attribute	15, 1	@ Tag_ABI_PCS_RW_data
	.eabi_attribute	16, 1	@ Tag_ABI_PCS_RO_data
	.eabi_attribute	17, 2	@ Tag_ABI_PCS_GOT_use
	.eabi_attribute	20, 1	@ Tag_ABI_FP_denormal
	.eabi_attribute	21, 0	@ Tag_ABI_FP_exceptions
	.eabi_attribute	23, 3	@ Tag_ABI_FP_number_model
	.eabi_attribute	24, 1	@ Tag_ABI_align_needed
	.eabi_attribute	25, 1	@ Tag_ABI_align_preserved
	.eabi_attribute	38, 1	@ Tag_ABI_FP_16bit_format
	.eabi_attribute	18, 4	@ Tag_ABI_PCS_wchar_t
	.eabi_attribute	26, 2	@ Tag_ABI_enum_size
	.eabi_attribute	14, 0	@ Tag_ABI_PCS_R9_use
	.file	"main.c"
	.globl	main                            @ -- Begin function main
	.p2align	2
	.type	main,%function
	.code	32                              @ @main
	@写一个 读取目录下文件(类似Linux下 ls命令)
main:
	push {r4,r5,lr}
	ldr r0,[r1,#4] @读取argv参数
	bl opendir      @得到dirp 返回值给了r0
	cmp r0,#0 		@如果等于0就是没取到 走exit退出
	beq .LABEL_EXIT 
	mov r4, r0  @将返回的结果存到r4
	bl readdir 
	cmp r0,#0
	beq .LABEL_CLOSE_DIR

	ldr r5,.format_str_
.LABEL0:
	add r5,pc,r5

.LABEL_LOOP:			@循环
	add r1,r0,#0x13		@因为struct dirent 0x13的位置是d_name 要输出文件的名称
	mov r0,r5 			@传递的时候传r0和r1 类似->printf("%s\n",dirent->d_name)
	bl printf
	mov r0,r4
	bl readdir 
	cmp r0,#0
	bne .LABEL_LOOP 	@不等于空就一直循环

.LABEL_CLOSE_DIR:
	mov r0,r4
	bl closedir

.LABEL_EXIT:
	pop {r4,r5,lr}
	bx lr

.format_str_:
	long .format_str - (.LABEL0 + 0x8) @.LABEL0 + 0x8是为了拿到那个地方的pc寄存器地址，然后用字符串的地址相减 得到"偏移量"，然后使用的时候加上PC就能拿到正确的字符串地址

.format_str:
	.asciz "%s\n"


@@@@@@@@@@@@@@@@@@@@@@@@@@ 等同于以下c代码 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@	int main(int argc,char* argv[]){
@		char* path = argv[1];
@		struct dirent *dirp = opendir(path);
@		if(dirp==NULL)
@			closedir(dirp);
@
@		while((struct dirent *dp = readdir(dirp)) != NULL){
@			printf("%s\n",dp->d_name)
@		}
@	}