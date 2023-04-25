	processor	6502
	org	$0810

	lda #$00
	tax
	tay
	jsr $1000
	sei
	lda #$7f
	sta $dc0d
	sta $dd0d
	lda #$01
	sta $d01a
	lda #$1b
	ldx #$08
	ldy #$14
	sta $d011
	stx $d016
	sty $d018
	lda #<irq
	ldx #>irq
	ldy #$7e
	sta $0314
	stx $0315
	sty $d012
	lda $dc0d
	lda $dd0d
	asl $d019
	cli

	sta $d020
	sta $d021    ; set border and screen colour to black

	tax

copyloop:
	lda $3f40,x  ; copy colours to screen RAM
	sta $0400,x
	lda $4040,x
	sta $0500,x
	lda $4140,x
	sta $0600,x
	lda $4240,x
	sta $0700,x
	lda $4328,x  ; copy colours to colour RAM
	sta $d800,x
	lda $4428,x
	sta $d800,x
	lda $4528,x
	sta $d800,x
	lda $4628,x
	sta $d800,x
	dex
	bne copyloop

	lda #$3b     ; bitmap mode
	ldx #$18     ; multi-colour mode
	ldy #$18     ; screen at $0400, bitmap at $2000
	sta $d011
	stx $d016
	sty $d018

loop:
	jmp loop

irq:
	jsr $1003
	asl $d019
	jmp    $ea81

	org $1000-$7e
	incbin "clocks.sid"
	org  $1FFE
	incbin "dad.kla"
