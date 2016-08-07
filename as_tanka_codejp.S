	.code16

	.text

	movw	$0x0003, %ax
	int	$0x10

	movb	$0x0f, %bl
	movw	$6, %cx
	movw	$0x07c0, %ax
	movw	%ax, %es
	movw	$msg_codejp2016, %bp
	movw	$0x1301, %ax
	int	$0x10

end:
	jmp	end

	.data
msg_codejp2016:
	.ascii	"CodeJP"
	.byte	0
