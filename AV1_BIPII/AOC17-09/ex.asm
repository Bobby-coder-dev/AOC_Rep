#if (A>=B) {
#   A = A + 1 // BLOCO 1
#}
# BLOCO 2

.data
    A : 1
    B : 0
.text
INIT:
    LD A
    SUB B
    BLT FIM
THEN:
    LD A
    ADDI I
    STO A
FIM:
    HLT
