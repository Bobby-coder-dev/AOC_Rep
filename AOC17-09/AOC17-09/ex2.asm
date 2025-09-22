# if (A>B) {
#    A = A + 1 //BLOCO 1
#} else {
#   B = B + 1; //BLOCO 2
#}
#//BLOCO 3

.data
    A : 0
    B : 0
.text

INIT:
    LD A
    SUB B
    BLE ELSE
THEN:
    LD A
    ADDI 1
    STO A
ELSE: 
    LD B
    ADDI 1
    STO B
FIM:
    HLT
