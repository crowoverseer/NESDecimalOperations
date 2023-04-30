;; gets the numbers from $0300, $0301 address
;; using $0302-$0306 addresses to compute, so clearing it
;; stores everything into $0307-$030B ; 5 decimal numbers

.export int16ToDecimal
.proc int16ToDecimal
NUMBER = $0300                  ; 2 bytes. Binary source number
VALUE = $0302                   ; 2 bytes. Temporary division step value
MOD10 = $0304                   ; 2 bytes. Mod of current step division
CHR_COUNT = $0306               ; adress for counting of resulting chars;
MAX_CHARS = 5                   ; maximum possigle charactes; Needed for zero filling
RESULT = $0307                  ; 5 bytes for result

.segment "CODE"
  lda #0
  sta CHR_COUNT
  lda NUMBER                    ; initialize value to be the number to convert
  sta VALUE
  lda NUMBER + 1
  sta VALUE + 1
int16ToDecimal:
  lda #0                        ; initialize the remainder to zero
  sta MOD10
  sta MOD10 + 1

  ldx #16
  clc
divloop:
  rol VALUE                     ; rotate quotient and remainder
  rol VALUE + 1
  rol MOD10
  rol MOD10 + 1

  sec                           ; a, y = dividend, divisor
  lda MOD10
  sbc #10
  tay                           ; save low byte in Y
  lda MOD10 + 1
  sbc #0
  bcc ignore_result             ; branch if divident < divisor
  sty MOD10
  sta MOD10 + 1

ignore_result:
  dex
  bne divloop
  rol VALUE ; shift in the last bit of the quotient
  rol VALUE + 1

  lda MOD10 ; a now contain the character
  ldy CHR_COUNT
  sta RESULT, y
  inc CHR_COUNT

  lda VALUE; if value != 0, the continue dividing
  ora VALUE + 1
  bne int16ToDecimal ; branch if value not zero

  ;; fill other values with 0
zero_loop:
  cpy MAX_CHARS
  beq return
  sta RESULT, y                 ; a contains zero
  iny
  jmp zero_loop
return:
  rts
.endproc
