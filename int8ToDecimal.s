;; gets the number from $0300
;; using $0301-$0303 addresses to compute, leaves garbage
;; stores everything into $0307-030A ; 3 decimal numbers

.export int8ToDecimal
.proc int8ToDecimal
NUMBER = $0300                  ; Binary number for converion
VALUE = $0301                   ; Temporary value of division step
MOD10 = $0302                   ; Mod of current division step
CHR_COUNT = $0303               ; Counter of resulting decimal chars
MAX_CHARS = 3                   ; Maximum possible characters. Needed foe zero filling
RESULT = $0307                  ; 3 bytes for result

.segment "CODE"
  lda #0
  sta CHR_COUNT
  lda NUMBER                    ; initialize value to be the number to covert
  sta VALUE
int8ToDecimal:
  lda #0                        ; initialize the remainder to zero
  sta MOD10

  ldx #8
  clc
divloop:
  rol VALUE                     ; rotate quotient and remainder
  rol MOD10

  sec                           ; a, y = dividend, divisor
  lda MOD10
  sbc #10
  tay                           ; save low byte in Y
  bcc ignore_result             ; branch if divident < divisor
  sty MOD10
ignore_result:
  dex
  bne divloop
  rol VALUE ; shift in the last bit of the quotient

  lda MOD10 ; a now contain the character
  ldy CHR_COUNT
  sta RESULT, y; write char into result
  inc CHR_COUNT

  lda VALUE; if value != 0, the continue dividing
  bne int8ToDecimal ; branch if value not zero

  ;; fill other values with 0
zero_loop:
  cpy MAX_CHARS
  beq return
  sta RESULT, y                 ; A contains zero
  iny
  jmp zero_loop
return:
  rts
.endproc
