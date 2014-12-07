INCLUDE "constants.asm"

SECTION "bank0",HOME
INCBIN "baserom.gbc",$0,$b65

ShowMenuText: ; $b65
	call $02bf
	push hl
MenuReadChar: ; $0b69
	pop hl
	ld a, [hli]
	push hl
	cp $f0
	jp nc, MenuF
	cp $e0
	jp nc, MenuE
	jp MenuRegular
	ret
; 0xb7a

INCBIN "baserom.gbc",$b7a,$b96-$b7a

MenuE:
	ld de, $0ba4
	sub $e0
	ld l, a
	ld h, $0
	add hl, hl
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 0xba4

MenuEPointers:
    dw MenuNothing
    dw $bc7
    dw $bec
    dw MenuNothing
    dw $b7a
    dw $c33
    dw $c17
    dw $c6a
    dw $c42
    dw $c51
    dw MenuNothing
    dw MenuNothing
    dw $bfe
    dw $b7a
    dw MenuLatin ; $ee
    dw MenuNothing

MenuNothing: ; $bc4
    jp MenuReadChar

; $bc7

INCBIN "baserom.gbc",$bc7,$0c8d-$bc7

MenuF: ; c8d
	call $1a0e
	jp MenuReadChar

MenuRegularOld: ; c93
	ld [W_CHAR], a
	ld a, [$dce0]
	ld c, a
	ld a, [$d08b]
	add c
	ld c, a
	ld [$cbf3], a
	swap a
	ld b, a
	and $f
	cp $8
	jr nc, .asm_caf ; 0xca9 $4
	or $90
	jr .asm_cb1 ; 0xcad $2
.asm_caf
	or $80
.asm_cb1
	ld [$d0f7], a
	ld a, b
	and $f0
	ld [$d0f6], a
	ld a, [$dcd1]
	ld e, a
	ld a, [$dcd2]
	ld d, a
	ld a, [W_CHAR]
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld a, l
	ld [$d9c0], a
	ld a, h
	ld [$d9c1], a
	ld a, $4
	ld [$cbf2], a
	ld a, $1
	ld [$cbf5], a
	call $02bf
	ld a, [$d08c]
	ld c, a
	ld a, [$dce0]
	add $4
	ld [$dce0], a
	cp c
	jp c, $0b69
	xor a
	ld [$dce0], a
	jp MenuReadChar

; 0xcfa



INCBIN "baserom.gbc",$cfa,$19ca-$cfa

ShowText:
	ld a, [$ffbc]
	cp $1
	jr z, .asm_19e1 ; 0x19ce $11
	cp $2
	jr z, .asm_19e5 ; 0x19d2 $11
	cp $3
	jr z, .asm_19e9 ; 0x19d6 $11
	cp $4
	jr z, .asm_19ed ; 0x19da $11
	cp $5
	jr z, .asm_19f1 ; 0x19de $11
	ret
.asm_19e1
	ld a, [$ffb6]
	jr .asm_19f6 ; 0x19e3 $11
.asm_19e5
	ld a, [$ffc0]
	jr .asm_19f6 ; 0x19e7 $d
.asm_19e9
	ld a, [$ffc3]
	jr .asm_19f6 ; 0x19eb $9
.asm_19ed
	ld a, [$ffb7]
	jr .asm_19f6 ; 0x19ef $5
.asm_19f1
	ld a, [$dcb5]
	jr .asm_19f6 ; 0x19f4 $0
.asm_19f6
	rst $20
	push hl
	pop hl
	ld a, [hli]
	push hl
	cp $f0
	jp nc, $1a08
	cp $e0
	jp nc, $1b23
	jp $1a2b
	
; 0x1a08

INCBIN "baserom.gbc",$1a08,$3000-$1a08

LatinTiles:
    INCBIN "gfx/tiles.gb"

MenuLatin:
    ld a, 1
    ld [H_LATIN], a
	jp MenuReadChar
    
MenuRegular:
    push af
    ld a, [H_LATIN]
    and a
    jr nz, .latin
.chinese
    pop af
    jp MenuRegularOld
.latin
    pop af
	
	call WriteChar
	;ld a, 0
	;call WriteChar
	
	jp MenuReadChar
    
WriteChar:
	ld [W_CHAR], a
	
	
	ld a, [$dce0]
	ld c, a
	ld a, [$d08b]
	add c
	ld c, a
	ld [$cbf3], a
	swap a
	ld b, a
	and $f
	cp $8
	jr nc, .asm_caf ; 0xca9 $4
	or $90
	jr .asm_cb1 ; 0xcad $2
.asm_caf
	or $80
.asm_cb1
	ld [$d0f7], a
	ld a, b
	and $f0
	ld [$d0f6], a
	
	ld a, [W_CHAR]
    ld h, 0
    ld l, a
	ld de, LatinTiles
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	
	ld a, l
	ld [$d9c0], a
	ld a, h
	ld [$d9c1], a
	ld a, $2
	ld [$cbf2], a
	ld a, $1
	ld [$cbf5], a
	call $02bf
		
	ld a, [$d08c]
	ld c, a
	ld a, [$dce0]
	add $2
	ld [$dce0], a

	ret

NewMenu:
    db $ee
    db "Mons"
    db "Item"
    db "Part"
    db "Dex", $0
    db "Save"
    db $e4


SECTION "bank1",DATA,BANK[$1]
INCBIN "baserom.gbc", $4000,$3fff
    db $1 ; bank

SECTION "bank2",DATA,BANK[$2]
INCBIN "baserom.gbc", $8000,$3fff
    db $2 ; bank

SECTION "bank3",DATA,BANK[$3]
INCBIN "baserom.gbc", $c000,$3fff
    db $3 ; bank

SECTION "bank4",DATA,BANK[$4]
INCBIN "baserom.gbc", $10000,$3fff
    db $4 ; bank

SECTION "bank5",DATA,BANK[$5]
INCBIN "baserom.gbc", $14000,$3fff
    db $5 ; bank

SECTION "bank6",DATA,BANK[$6]
INCBIN "baserom.gbc", $18000,$3fff
    db $6 ; bank

SECTION "bank7",DATA,BANK[$7]
INCBIN "baserom.gbc", $1c000,$3fff
    db $7 ; bank

SECTION "bank8",DATA,BANK[$8]
INCBIN "baserom.gbc", $20000,$3fff
    db $8 ; bank

SECTION "bank9",DATA,BANK[$9]
INCBIN "baserom.gbc", $24000,$3fff
    db $9 ; bank

SECTION "banka",DATA,BANK[$a]
INCBIN "baserom.gbc", $28000,$3fff
    db $a ; bank

SECTION "bankb",DATA,BANK[$b]
INCBIN "baserom.gbc", $2c000,$3fff
    db $b ; bank

SECTION "bankc",DATA,BANK[$c]
INCBIN "baserom.gbc", $30000,$3fff
    db $c ; bank

SECTION "bankd",DATA,BANK[$d]
INCBIN "baserom.gbc", $34000,$3fff
    db $d ; bank

SECTION "banke",DATA,BANK[$e]
INCBIN "baserom.gbc", $38000,$3fff
    db $e ; bank

SECTION "bankf",DATA,BANK[$f]
INCBIN "baserom.gbc", $3c000,$3fff
    db $f ; bank

SECTION "bank10",DATA,BANK[$10]
INCBIN "baserom.gbc", $40000,$3fff
    db $10 ; bank

SECTION "bank11",DATA,BANK[$11]
INCBIN "baserom.gbc", $44000,$3fff
    db $11 ; bank

SECTION "bank12",DATA,BANK[$12]
INCBIN "baserom.gbc", $48000,$3fff
    db $12 ; bank

SECTION "bank13",DATA,BANK[$13]
INCBIN "baserom.gbc", $4c000,$3fff
    db $13 ; bank

SECTION "bank14",DATA,BANK[$14]
INCBIN "baserom.gbc", $50000,$3fff
    db $14 ; bank

SECTION "bank15",DATA,BANK[$15]
INCBIN "baserom.gbc", $54000,$3fff
    db $15 ; bank

SECTION "bank16",DATA,BANK[$16]
INCBIN "baserom.gbc", $58000,$3fff
    db $16 ; bank

SECTION "bank17",DATA,BANK[$17]
INCBIN "baserom.gbc", $5c000,$3fff
    db $17 ; bank

SECTION "bank18",DATA,BANK[$18]
INCBIN "baserom.gbc", $60000,$3fff
    db $18 ; bank

SECTION "bank19",DATA,BANK[$19]
INCBIN "baserom.gbc", $64000,$3fff
    db $19 ; bank

SECTION "bank1a",DATA,BANK[$1a]
INCBIN "baserom.gbc", $68000,$3fff
    db $1a ; bank

SECTION "bank1b",DATA,BANK[$1b]
INCBIN "baserom.gbc", $6c000,$3fff
    db $1b ; bank

SECTION "bank1c",DATA,BANK[$1c]
INCBIN "baserom.gbc", $70000,$3fff
    db $1c ; bank

SECTION "bank1d",DATA,BANK[$1d]
INCBIN "baserom.gbc", $74000,$3fff
    db $1d ; bank

SECTION "bank1e",DATA,BANK[$1e]
INCBIN "baserom.gbc", $78000,$3fff
    db $1e ; bank

SECTION "bank1f",DATA,BANK[$1f]
INCBIN "baserom.gbc", $7c000,$3fff
    db $1f ; bank

SECTION "bank20",DATA,BANK[$20]
INCBIN "baserom.gbc", $80000,$3fff
    db $20 ; bank

SECTION "bank21",DATA,BANK[$21]
INCBIN "baserom.gbc", $84000,$3fff
    db $21 ; bank

SECTION "bank22",DATA,BANK[$22]
INCBIN "baserom.gbc", $88000,$3fff
    db $22 ; bank

SECTION "bank23",DATA,BANK[$23]
INCBIN "baserom.gbc", $8c000,$3fff
    db $23 ; bank

SECTION "bank24",DATA,BANK[$24]
INCBIN "baserom.gbc", $90000,$90130-$90000

; these seem to be pointers for the following bank (25).  menus?
    dw $4162
    dw $4162
    dw $4181
    dw $41b7
    dw $41cb
    dw $41e3
    dw $41ec
    dw $420a
    dw $4208
    dw $42a5
    dw $42bb
    dw $42cb
    dw $42fa
    dw $430e
    dw $432e
    dw $4343
    dw $4355
    dw $438b
    dw $43af
    dw $4404
    dw $4421
    dw $449d
    dw $4509
    dw $453f
    dw $4304
    db $01
    dw NewMenu



INCBIN "baserom.gbc", $90165,$93fff-$90165
    db $24 ; bank

SECTION "bank25",DATA,BANK[$25]
INCBIN "baserom.gbc", $94000,$3fff
    db $25 ; bank

SECTION "bank26",DATA,BANK[$26]
INCBIN "baserom.gbc", $98000,$3fff
    db $26 ; bank

SECTION "bank27",DATA,BANK[$27]
INCBIN "baserom.gbc", $9c000,$3fff
    db $27 ; bank

SECTION "bank28",DATA,BANK[$28]
INCBIN "baserom.gbc", $a0000,$3fff
    db $28 ; bank

SECTION "bank29",DATA,BANK[$29]
INCBIN "baserom.gbc", $a4000,$3fff
    db $29 ; bank

SECTION "bank2a",DATA,BANK[$2a]
INCBIN "baserom.gbc", $a8000,$3fff
    db $2a ; bank

SECTION "bank2b",DATA,BANK[$2b]
INCBIN "baserom.gbc", $ac000,$3fff
    db $2b ; bank

SECTION "bank2c",DATA,BANK[$2c]
INCBIN "baserom.gbc", $b0000,$3fff
    db $2c ; bank

SECTION "bank2d",DATA,BANK[$2d]
INCBIN "baserom.gbc", $b4000,$3fff
    db $2d ; bank

SECTION "bank2e",DATA,BANK[$2e]
INCBIN "baserom.gbc", $b8000,$3fff
    db $2e ; bank

SECTION "bank2f",DATA,BANK[$2f]
INCBIN "baserom.gbc", $bc000,$3fff
    db $2f ; bank

SECTION "bank30",DATA,BANK[$30]
INCBIN "baserom.gbc", $c0000,$3fff
    db $30 ; bank

SECTION "bank31",DATA,BANK[$31]
INCBIN "baserom.gbc", $c4000,$3fff
    db $31 ; bank

SECTION "bank32",DATA,BANK[$32]
INCBIN "baserom.gbc", $c8000,$3fff
    db $32 ; bank

SECTION "bank33",DATA,BANK[$33]
INCBIN "baserom.gbc", $cc000,$3fff
    db $33 ; bank

SECTION "bank34",DATA,BANK[$34]
INCBIN "baserom.gbc", $d0000,$3fff
    db $34 ; bank

SECTION "bank35",DATA,BANK[$35]
INCBIN "baserom.gbc", $d4000,$3fff
    db $35 ; bank

SECTION "bank36",DATA,BANK[$36]
INCBIN "baserom.gbc", $d8000,$3fff
    db $36 ; bank

SECTION "bank37",DATA,BANK[$37]
INCBIN "baserom.gbc", $dc000,$3fff
    db $37 ; bank

SECTION "bank38",DATA,BANK[$38]
INCBIN "baserom.gbc", $e0000,$3fff
    db $38 ; bank

SECTION "bank39",DATA,BANK[$39]
INCBIN "baserom.gbc", $e4000,$3fff
    db $39 ; bank

SECTION "bank3a",DATA,BANK[$3a]
INCBIN "baserom.gbc", $e8000,$3fff
    db $3a ; bank

SECTION "bank3b",DATA,BANK[$3b]
INCBIN "baserom.gbc", $ec000,$3fff
    db $3b ; bank

SECTION "bank3c",DATA,BANK[$3c]
INCBIN "baserom.gbc", $f0000,$3fff
    db $3c ; bank

SECTION "bank3d",DATA,BANK[$3d]
INCBIN "baserom.gbc", $f4000,$3fff
    db $3d ; bank

SECTION "bank3e",DATA,BANK[$3e]
INCBIN "baserom.gbc", $f8000,$3fff
    db $3e ; bank

SECTION "bank3f",DATA,BANK[$3f]
INCBIN "baserom.gbc", $fc000,$3fff
    db $3f ; bank

SECTION "bank40",DATA,BANK[$40]
INCBIN "baserom.gbc", $100000,$3fff
    db $40 ; bank

SECTION "bank41",DATA,BANK[$41]
INCBIN "baserom.gbc", $104000,$3fff
    db $42 ; bank, wrong

SECTION "bank42",DATA,BANK[$42]
INCBIN "baserom.gbc", $108000,$3fff
    db $42 ; bank

SECTION "bank43",DATA,BANK[$43]
INCBIN "baserom.gbc", $10c000,$3fff
    db $43 ; bank

SECTION "bank44",DATA,BANK[$44]
INCBIN "baserom.gbc", $110000,$3fff
    db $44 ; bank

SECTION "bank45",DATA,BANK[$45]
INCBIN "baserom.gbc", $114000,$3fff
    db $45 ; bank

SECTION "bank46",DATA,BANK[$46]
INCBIN "baserom.gbc", $118000,$3fff
    db $46 ; bank

SECTION "bank47",DATA,BANK[$47]
INCBIN "baserom.gbc", $11c000,$3fff
    db $47 ; bank

SECTION "bank48",DATA,BANK[$48]
INCBIN "baserom.gbc", $120000,$3fff
    db $48 ; bank

SECTION "bank49",DATA,BANK[$49]
INCBIN "baserom.gbc", $124000,$3fff
    db $49 ; bank

SECTION "bank4a",DATA,BANK[$4a]
INCBIN "baserom.gbc", $128000,$3fff
    db $4a ; bank

SECTION "bank4b",DATA,BANK[$4b]
INCBIN "baserom.gbc", $12c000,$3fff
    db $4b ; bank

SECTION "bank4c",DATA,BANK[$4c]
INCBIN "baserom.gbc", $130000,$3fff
    db $4c ; bank

SECTION "bank4d",DATA,BANK[$4d]
INCBIN "baserom.gbc", $134000,$3fff
    db $4d ; bank

SECTION "bank4e",DATA,BANK[$4e]
INCBIN "baserom.gbc", $138000,$3fff
    db $4e ; bank

SECTION "bank4f",DATA,BANK[$4f]
INCBIN "baserom.gbc", $13c000,$3fff
    db $4f ; bank

SECTION "bank50",DATA,BANK[$50]
INCBIN "baserom.gbc", $140000,$3fff
    db $50 ; bank

SECTION "bank51",DATA,BANK[$51]
INCBIN "baserom.gbc", $144000,$3fff
    db $51 ; bank

SECTION "bank52",DATA,BANK[$52]
INCBIN "baserom.gbc", $148000,$3fff
    db $52 ; bank

SECTION "bank53",DATA,BANK[$53]
INCBIN "baserom.gbc", $14c000,$3fff
    db $53 ; bank

SECTION "bank54",DATA,BANK[$54]
INCBIN "baserom.gbc", $150000,$3fff
    db $54 ; bank

SECTION "bank55",DATA,BANK[$55]
INCBIN "baserom.gbc", $154000,$3fff
    db $55 ; bank

SECTION "bank56",DATA,BANK[$56]
INCBIN "baserom.gbc", $158000,$3fff
    db $56 ; bank

SECTION "bank57",DATA,BANK[$57]
INCBIN "baserom.gbc", $15c000,$3fff
    db $57 ; bank

SECTION "bank58",DATA,BANK[$58]
INCBIN "baserom.gbc", $160000,$3fff
    db $58 ; bank

SECTION "bank59",DATA,BANK[$59]
INCBIN "baserom.gbc", $164000,$3fff
    db $59 ; bank

SECTION "bank5a",DATA,BANK[$5a]
INCBIN "baserom.gbc", $168000,$3fff
    db $5a ; bank

SECTION "bank5b",DATA,BANK[$5b]
INCBIN "baserom.gbc", $16c000,$3fff
    db $5b ; bank

SECTION "bank5c",DATA,BANK[$5c]
INCBIN "baserom.gbc", $170000,$3fff
    db $5c ; bank

SECTION "bank5d",DATA,BANK[$5d]
INCBIN "baserom.gbc", $174000,$3fff
    db $5d ; bank

SECTION "bank5e",DATA,BANK[$5e]
INCBIN "baserom.gbc", $178000,$3fff
    db $5e ; bank

SECTION "bank5f",DATA,BANK[$5f]
INCBIN "baserom.gbc", $17c000,$3fff
    db $5f ; bank

SECTION "bank60",DATA,BANK[$60]
INCBIN "baserom.gbc", $180000,$3fff
    db $60 ; bank

SECTION "bank61",DATA,BANK[$61]
INCBIN "baserom.gbc", $184000,$3fff
    db $61 ; bank

SECTION "bank62",DATA,BANK[$62]
INCBIN "baserom.gbc", $188000,$3fff
    db $62 ; bank

SECTION "bank63",DATA,BANK[$63]
INCBIN "baserom.gbc", $18c000,$3fff
    db $63 ; bank

SECTION "bank64",DATA,BANK[$64]
INCBIN "baserom.gbc", $190000,$3fff
    db $64 ; bank

SECTION "bank65",DATA,BANK[$65]
INCBIN "baserom.gbc", $194000,$3fff
    db $65 ; bank

SECTION "bank66",DATA,BANK[$66]
INCBIN "baserom.gbc", $198000,$3fff
    db $66 ; bank

SECTION "bank67",DATA,BANK[$67]
INCBIN "baserom.gbc", $19c000,$3fff
    db $67 ; bank

SECTION "bank68",DATA,BANK[$68]
INCBIN "baserom.gbc", $1a0000,$3fff
    db $68 ; bank

SECTION "bank69",DATA,BANK[$69]
INCBIN "baserom.gbc", $1a4000,$3fff
    db $69 ; bank

SECTION "bank6a",DATA,BANK[$6a]
INCBIN "baserom.gbc", $1a8000,$3fff
    db $6a ; bank

SECTION "bank6b",DATA,BANK[$6b]
INCBIN "baserom.gbc", $1ac000,$3fff
    db $6b ; bank

SECTION "bank6c",DATA,BANK[$6c]
INCBIN "baserom.gbc", $1b0000,$3fff
    db $6c ; bank

SECTION "bank6d",DATA,BANK[$6d]
INCBIN "baserom.gbc", $1b4000,$3fff
    db $6d ; bank

SECTION "bank6e",DATA,BANK[$6e]
INCBIN "baserom.gbc", $1b8000,$3fff
    db $6e ; bank

SECTION "bank6f",DATA,BANK[$6f]
INCBIN "baserom.gbc", $1bc000,$3fff
    db $6f ; bank

SECTION "bank70",DATA,BANK[$70]
INCBIN "baserom.gbc", $1c0000,$3fff
    db $70 ; bank

SECTION "bank71",DATA,BANK[$71]
INCBIN "baserom.gbc", $1c4000,$3fff
    db $71 ; bank

SECTION "bank72",DATA,BANK[$72]
INCBIN "baserom.gbc", $1c8000,$3fff
    db $72 ; bank

SECTION "bank73",DATA,BANK[$73]
INCBIN "baserom.gbc", $1cc000,$3fff
    db $73 ; bank

SECTION "bank74",DATA,BANK[$74]
INCBIN "baserom.gbc", $1d0000,$3fff
    db $0

SECTION "bank75",DATA,BANK[$75]
INCBIN "baserom.gbc", $1d4000,$3fff
    db $0

SECTION "bank76",DATA,BANK[$76]
INCBIN "baserom.gbc", $1d8000,$3fff
    db $76 ; bank

SECTION "bank77",DATA,BANK[$77]
INCBIN "baserom.gbc", $1dc000,$3fff
    db $77 ; bank

SECTION "bank78",DATA,BANK[$78]
INCBIN "baserom.gbc", $1e0000,$3fff
    db $78 ; bank

SECTION "bank79",DATA,BANK[$79]
INCBIN "baserom.gbc", $1e4000,$3fff
    db $79 ; bank

SECTION "bank7a",DATA,BANK[$7a]
INCBIN "baserom.gbc", $1e8000,$3fff
    db $7a ; bank

SECTION "bank7b",DATA,BANK[$7b]
INCBIN "baserom.gbc", $1ec000,$3fff
    db $7b ; bank

SECTION "bank7c",DATA,BANK[$7c]
INCBIN "baserom.gbc", $1f0000,$3fff
    db $7c ; bank

SECTION "bank7d",DATA,BANK[$7d]
INCBIN "baserom.gbc", $1f4000,$3fff
    db $7d ; bank

SECTION "bank7e",DATA,BANK[$7e]
INCBIN "baserom.gbc", $1f8000,$3fff
    db $7e ; bank

SECTION "bank7f",DATA,BANK[$7f]
INCBIN "baserom.gbc", $1fc000,$3fff
    db $7f ; bank

