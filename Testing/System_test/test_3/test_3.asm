NOP ;
LW $1, 0($0);
LW $2, 4($0);
LW $3, 8($0);
LW $4, 12($0);
LW $5, 24($0);
SLL $10, $5, 4;
SRL $11, $5, 4;
SRA $12, $5, 4;
SLLV $13, $5, $2;
SRLV $14, $5, $2;
SRAV $15, $5, $2;
ADD $16, $4, $2;
SUB $17, $16, $2;
AND $18, $17, $16;
OR $19,	$18, $16;
XOR $20, $1, $3;
NOR $21, $1, $3;
SLT $22, $1, $3;
SLT $23, $3, $1;
