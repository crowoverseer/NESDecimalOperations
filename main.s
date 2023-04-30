.include "header.inc"
.include "constants.inc"
.import int16ToDecimal
.import int8ToDecimal

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  RTI
.endproc

.import reset_handler

NUMBER = $0300

.export main
.proc main
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR

  LDA #12
  STA NUMBER
  JSR int16ToDecimal

  LDA #$29  ; green color
  STA PPUDATA
  LDA #%0001110
  STA PPUMASK
forever:
  JMP forever
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.res 8192
