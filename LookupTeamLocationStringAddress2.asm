// This is patched overtop $9B/C5AB - $9B/C5E6
0A          ASL A
0A          ASL A
A8          TAY

// Put 0xA08200 (or whatever the string table address is) into $8D
A9 A0 00    LDA #$00A0
85 8F       STA $8F
A9 00 82    LDA #$8200
85 8D       STA $8D

// load from 0xA08200, y
B7 8D       LDA [$8D],y     // Low short
48          PHA
98          TYA
1A          INC
1A          INC
A8          TAY
B7 8D       LDA [$8D],y     // High short
85 8F       STA $8F
68          PLA
85 8D       STA $8D

5C 19 CD 9E JMP $9ECD19