// void LookupPlayerIndexForPlayerWithProfile() 9DC973
// Preconditions:	Acc is to a player index N going from 0 to 5.
//					Choice of home or away team is in $91. 0 means home, 2 means away
//					There is an array in system memory at 9DC9A2, called OrderOfProfileImagesForThisTeam
//						Each element is one byte.
//						Each element is a number from 0 to 5.
//						The first element determines which player gets their profile image displayed first, etc.
//
// Postconditions: $A5 contains the index of the Nth player on the team who gets a profile image.

$9D/C973 A8          TAY                     A:0005 X:000A Y:0400 P:envmxdizc

$9D/C974 A9 9D 00    LDA #$009D              A:0005 X:000A Y:0005 P:envmxdizc
$9D/C977 85 8F       STA $8F    [$00:008F]   A:009D X:000A Y:0005 P:envmxdizc
$9D/C979 A9 A2 C9    LDA #$C9A2              A:009D X:000A Y:0005 P:envmxdizc
$9D/C97C 85 8D       STA $8D    [$00:008D]   A:C9A2 X:000A Y:0005 P:eNvmxdizc	// $8D-$8F = 9DC9A2 hardcoded
$9D/C97E B7 8D       LDA [$8D],y[$9D:C9A7]   A:C9A2 X:000A Y:0005 P:eNvmxdizc	// 
$9D/C980 29 FF 00    AND #$00FF              A:8500 X:000A Y:0005 P:eNvmxdizc	// 
$9D/C983 48          PHA                     A:0000 X:000A Y:0005 P:envmxdiZc	// Load OrderOfProfileImagesForThisTeam[N] and push on stack.

$9D/C984 A4 91       LDY $91    [$00:0091]   A:0000 X:000A Y:0005 P:envmxdiZc	
$9D/C986 A9 9C 00    LDA #$009C              A:0000 X:000A Y:0000 P:envmxdiZc
$9D/C989 85 8F       STA $8F    [$00:008F]   A:009C X:000A Y:0000 P:envmxdizc
$9D/C98B B9 DC 1C    LDA $1CDC,y[$9F:1CDC]   A:009C X:000A Y:0000 P:envmxdizc
$9D/C98E 85 8D       STA $8D    [$00:008D]   A:C2DB X:000A Y:0000 P:eNvmxdizc	// $8D-$8F = "main table" for the current team.

$9D/C990 A0 0C 00    LDY #$000C              A:C2DB X:000A Y:0000 P:eNvmxdizc
$9D/C993 18          CLC                     A:C2DB X:000A Y:000C P:envmxdizc
$9D/C994 77 8D       ADC [$8D],y[$9C:C2E7]   A:C2DB X:000A Y:000C P:envmxdizc	// 
$9D/C996 85 8D       STA $8D    [$00:008D]   A:C2F0 X:000A Y:000C P:eNvmxdizc	// $8D-$8F += WhichPlayersHaveProfileImagesSeekOffset, 
																				//		which always is the 12th byte of "main table" data.
																				
																				// SeekOffset is the offset, within main table data, of
																				// a six-element array. 
																				// That array is 01 12 11 07 03 0C, for Montreal.
																				// The values in this array are 1-indexed, not 0-indexed :S
																				// This array is the set of players that have profile images.

$9D/C998 7A          PLY                     A:C2F0 X:000A Y:000C P:eNvmxdizc	// Pull OrderOfProfileImagesForThisTeam[N]
$9D/C999 B7 8D       LDA [$8D],y[$9C:C2F0]   A:C2F0 X:000A Y:0000 P:envmxdiZc	// Use it to select within the six-element array above.
$9D/C99B 29 FF 00    AND #$00FF              A:1201 X:000A Y:0000 P:envmxdizc

$9D/C99E 3A          DEC A                   A:0001 X:000A Y:0000 P:envmxdizc
$9D/C99F 85 A5       STA $A5    [$00:00A5]   A:0000 X:000A Y:0000 P:envmxdiZc	// Store the 0-indexed result in $A5.
$9D/C9A1 6B          RTL                     A:0000 X:000A Y:0000 P:envmxdiZc

///////////////////////////////////////////////////////////////////////////////////////////////

// void LoadTeamProfileImagesForPlayerCard() ?-9DC9A8

$9D/C9A8 85 A5       STA $A5    [$00:00A5]   A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9AA AF 74 34 7E LDA $7E3474[$7E:3474]   A:0000 X:0490 Y:0000 P:envmxdiZc

$9D/C9AE F0 03       BEQ $03    [$C9B3]      A:0000 X:0490 Y:0000 P:envmxdiZc

$9D/C9B0 4C 9F CB    JMP $CB9F  [$9D:CB9F]   A:0000 X:0490 Y:0000 P:envmxdiZc

$9D/C9B3 5A          PHY                     A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9B4 DA          PHX                     A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9B5 A5 91       LDA $91    [$00:0091]   A:0000 X:0490 Y:0000 P:envmxdiZc

$9D/C9B7 F0 08       BEQ $08    [$C9C1]      A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9B9 A9 00 24    LDA #$2400              A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9BC 8D 87 1E    STA $1E87  [$9F:1E87]   A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9BF 80 06       BRA $06    [$C9C7]      A:0000 X:0490 Y:0000 P:envmxdiZc

$9D/C9C1 A9 00 34    LDA #$3400              A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9C4 8D 87 1E    STA $1E87  [$9F:1E87]   A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9C7 A5 A5       LDA $A5    [$00:00A5]   A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9C9 A4 91       LDY $91    [$00:0091]   A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9CB 85 A5       STA $A5    [$00:00A5]   A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9CD B9 98 1C    LDA $1C98,y[$9F:1C98]   A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9D0 A2 1A 00    LDX #$001A              A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9D3 22 4C 8F 80 JSL $808F4C[$80:8F4C]   A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9D7 18          CLC                     A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9D8 65 A5       ADC $A5    [$00:00A5]   A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9DA 0A          ASL A                   A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9DB 0A          ASL A                   A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9DC AA          TAX                     A:0000 X:0490 Y:0000 P:envmxdiZc

$9D/C9DD BF 53 CD 9D LDA $9DCD53,x[$9D:D1E3] A:0000 X:0490 Y:0000 P:envmxdiZc	// DecompressActual src = e.g., 970490
$9D/C9E1 85 0C       STA $0C    [$00:000C]   A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9E3 BF 55 CD 9D LDA $9DCD55,x[$9D:D1E5] A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9E7 85 0E       STA $0E    [$00:000E]   A:0000 X:0490 Y:0000 P:envmxdiZc

$9D/C9E9 A9 7F 00    LDA #$007F              A:0000 X:0490 Y:0000 P:envmxdiZc	// DecompressActual1 dest = 7F0000
$9D/C9EC 85 12       STA $12    [$00:0012]   A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9EE A9 00 00    LDA #$0000              A:0000 X:0490 Y:0000 P:envmxdiZc
$9D/C9F1 85 10       STA $10    [$00:0010]   A:0000 X:0490 Y:0000 P:envmxdiZc

$9D/C9F3 22 73 C3 80 JSL $80C373[$80:C373]   A:8000 X:0480 Y:0000 P:envmxdiZc	// call DecompressActual1()
$9D/C9F7 86 00       STX $00    [$00:0000]   A:8000 X:0480 Y:0000 P:envmxdiZc
$9D/C9F9 A5 91       LDA $91    [$00:0091]   A:8000 X:0480 Y:0000 P:envmxdiZc
$9D/C9FB F0 0B       BEQ $0B    [$CA08]      A:0000 X:0480 Y:0000 P:envmxdiZc

$9D/CA08 A9 00 6F    LDA #$6F00              A:0000 X:0480 Y:0000 P:envmxdiZc
$9D/CA0B 85 10       STA $10    [$00:0010]   A:6F00 X:0480 Y:0000 P:envmxdizc	// DecompressActual2 dst = 7F6F00

$9D/CA0D 8F 70 34 7E STA $7E3470[$7E:3470]   A:6F00 X:0480 Y:0000 P:envmxdizc

$9D/CA11 A9 7F 00    LDA #$007F              A:6F00 X:0480 Y:0000 P:envmxdizc	// DecompressActual2 src = 7F0000
$9D/CA14 85 0E       STA $0E    [$00:000E]   A:007F X:0480 Y:0000 P:envmxdizc
$9D/CA16 A9 00 00    LDA #$0000              A:007F X:0480 Y:0000 P:envmxdizc
$9D/CA19 85 0C       STA $0C    [$00:000C]   A:0000 X:0480 Y:0000 P:envmxdiZc

$9D/CA1B 22 C2 85 9B JSL $9B85C2[$9B:85C2]   A:0000 X:0480 Y:0000 P:envmxdiZc	// Call DecompressActual2()

$9D/CA1F 22 1C CB 9D JSL $9DCB1C[$9D:CB1C]   A:C0C0 X:0000 Y:0490 P:eNvmxdizc
$9D/CA23 D0 31       BNE $31    [$CA56]      A:0000 X:0000 Y:0002 P:envmxdiZC
$9D/CA25 A9 92 00    LDA #$0092              A:0000 X:0000 Y:0002 P:envmxdiZC
$9D/CA28 85 0E       STA $0E    [$00:000E]   A:0092 X:0000 Y:0002 P:envmxdizC
$9D/CA2A A9 B0 FF    LDA #$FFB0              A:0092 X:0000 Y:0002 P:envmxdizC
$9D/CA2D 85 0C       STA $0C    [$00:000C]   A:FFB0 X:0000 Y:0002 P:eNvmxdizC
$9D/CA2F A9 7E 00    LDA #$007E              A:FFB0 X:0000 Y:0002 P:eNvmxdizC
$9D/CA32 85 12       STA $12    [$00:0012]   A:007E X:0000 Y:0002 P:envmxdizC
$9D/CA34 A9 F4 37    LDA #$37F4              A:007E X:0000 Y:0002 P:envmxdizC
$9D/CA37 85 10       STA $10    [$00:0010]   A:37F4 X:0000 Y:0002 P:envmxdizC
$9D/CA39 A9 20 00    LDA #$0020              A:37F4 X:0000 Y:0002 P:envmxdizC
$9D/CA3C 85 24       STA $24    [$00:0024]   A:0020 X:0000 Y:0002 P:envmxdizC
$9D/CA3E AF D2 35 7E LDA $7E35D2[$7E:35D2]   A:0020 X:0000 Y:0002 P:envmxdizC
$9D/CA42 18          CLC                     A:0372 X:0000 Y:0002 P:envmxdizC
$9D/CA43 6D 87 1E    ADC $1E87  [$9F:1E87]   A:0372 X:0000 Y:0002 P:envmxdizc
$9D/CA46 A4 91       LDY $91    [$00:0091]   A:3772 X:0000 Y:0002 P:envmxdizc
$9D/CA48 F0 04       BEQ $04    [$CA4E]      A:3772 X:0000 Y:0000 P:envmxdiZc
$9D/CA4E FA          PLX                     A:3772 X:0000 Y:0000 P:envmxdiZc
$9D/CA4F 7A          PLY                     A:3772 X:000D Y:0000 P:envmxdizc
$9D/CA50 22 2D 8E 80 JSL $808E2D[$80:8E2D]   A:3772 X:000D Y:0004 P:envmxdizc
$9D/CA54 80 2F       BRA $2F    [$CA85]      A:FFFE X:0000 Y:000C P:envmxdiZc

$9D/CA85 A4 91       LDY $91    [$00:0091]   A:FFFE X:0000 Y:000C P:envmxdiZc
$9D/CA87 B9 98 1C    LDA $1C98,y[$9F:1C98]   A:FFFE X:0000 Y:0000 P:envmxdiZc
$9D/CA8A 0A          ASL A                   A:000B X:0000 Y:0000 P:envmxdizc
$9D/CA8B 0A          ASL A                   A:0016 X:0000 Y:0000 P:envmxdizc
$9D/CA8C 18          CLC                     A:002C X:0000 Y:0000 P:envmxdizc
$9D/CA8D 69 B3 D8    ADC #$D8B3              A:002C X:0000 Y:0000 P:envmxdizc
$9D/CA90 85 8D       STA $8D    [$00:008D]   A:D8DF X:0000 Y:0000 P:eNvmxdizc
$9D/CA92 A9 9D 00    LDA #$009D              A:D8DF X:0000 Y:0000 P:eNvmxdizc
$9D/CA95 85 8F       STA $8F    [$00:008F]   A:009D X:0000 Y:0000 P:envmxdizc
$9D/CA97 A7 8D       LDA [$8D]  [$9D:D8DF]   A:009D X:0000 Y:0000 P:envmxdizc
$9D/CA99 85 0C       STA $0C    [$00:000C]   A:EB9C X:0000 Y:0000 P:eNvmxdizc
$9D/CA9B E6 8D       INC $8D    [$00:008D]   A:EB9C X:0000 Y:0000 P:eNvmxdizc
$9D/CA9D E6 8D       INC $8D    [$00:008D]   A:EB9C X:0000 Y:0000 P:eNvmxdizc
$9D/CA9F A7 8D       LDA [$8D]  [$9D:D8E1]   A:EB9C X:0000 Y:0000 P:eNvmxdizc
$9D/CAA1 85 0E       STA $0E    [$00:000E]   A:009A X:0000 Y:0000 P:envmxdizc
$9D/CAA3 A5 91       LDA $91    [$00:0091]   A:009A X:0000 Y:0000 P:envmxdizc
$9D/CAA5 F0 05       BEQ $05    [$CAAC]      A:0000 X:0000 Y:0000 P:envmxdiZc
$9D/CAAC A0 50 00    LDY #$0050              A:0000 X:0000 Y:0000 P:envmxdiZc
$9D/CAAF A2 10 00    LDX #$0010              A:0000 X:0000 Y:0050 P:envmxdizc
$9D/CAB2 22 BD E0 9D JSL $9DE0BD[$9D:E0BD]   A:0000 X:0010 Y:0050 P:envmxdizc
$9D/CAB6 6B          RTL                     A:6000 X:00C0 Y:0020 P:envmxdiZc
$9D/C21A A9 7F 00    LDA #$007F              A:6000 X:00C0 Y:0020 P:envmxdiZc
$9D/C21D 85 0E       STA $0E    [$00:000E]   A:007F X:00C0 Y:0020 P:envmxdizc
$9D/C21F AF 70 34 7E LDA $7E3470[$7E:3470]   A:007F X:00C0 Y:0020 P:envmxdizc
$9D/C223 85 0C       STA $0C    [$00:000C]   A:6F00 X:00C0 Y:0020 P:envmxdizc
$9D/C225 AF D2 35 7E LDA $7E35D2[$7E:35D2]   A:6F00 X:00C0 Y:0020 P:envmxdizc
$9D/C229 0A          ASL A                   A:0372 X:00C0 Y:0020 P:envmxdizc
$9D/C22A 0A          ASL A                   A:06E4 X:00C0 Y:0020 P:envmxdizc
$9D/C22B 0A          ASL A                   A:0DC8 X:00C0 Y:0020 P:envmxdizc
$9D/C22C 0A          ASL A                   A:1B90 X:00C0 Y:0020 P:envmxdizc
$9D/C22D 18          CLC                     A:3720 X:00C0 Y:0020 P:envmxdizc

$9D/C22E 69 00 20    ADC #$2000              A:3720 X:00C0 Y:0020 P:envmxdizc
$9D/C231 A8          TAY                     A:5720 X:00C0 Y:0020 P:envmxdizc
$9D/C232 A2 00 06    LDX #$0600              A:5720 X:00C0 Y:5720 P:envmxdizc
$9D/C235 22 83 85 80 JSL $808583[$80:8583]   A:5720 X:0600 Y:5720 P:envmxdizc
$9D/C239 22 1F 89 80 JSL $80891F[$80:891F]   A:5720 X:0600 Y:5720 P:envmxdizc
$9D/C23D A9 7F 00    LDA #$007F              A:F600 X:0278 Y:5A20 P:eNvmxdizc
$9D/C240 85 0E       STA $0E    [$00:000E]   A:007F X:0278 Y:5A20 P:envmxdizc
$9D/C242 AF 72 34 7E LDA $7E3472[$7E:3472]   A:007F X:0278 Y:5A20 P:envmxdizc
$9D/C246 85 0C       STA $0C    [$00:000C]   A:0000 X:0278 Y:5A20 P:envmxdiZc
$9D/C248 AF D2 35 7E LDA $7E35D2[$7E:35D2]   A:0000 X:0278 Y:5A20 P:envmxdiZc
$9D/C24C 0A          ASL A                   A:0372 X:0278 Y:5A20 P:envmxdizc
$9D/C24D 0A          ASL A                   A:06E4 X:0278 Y:5A20 P:envmxdizc
$9D/C24E 0A          ASL A                   A:0DC8 X:0278 Y:5A20 P:envmxdizc
$9D/C24F 0A          ASL A                   A:1B90 X:0278 Y:5A20 P:envmxdizc
$9D/C250 18          CLC                     A:3720 X:0278 Y:5A20 P:envmxdizc
$9D/C251 69 00 23    ADC #$2300              A:3720 X:0278 Y:5A20 P:envmxdizc
$9D/C254 A8          TAY                     A:5A20 X:0278 Y:5A20 P:envmxdizc
$9D/C255 A2 00 06    LDX #$0600              A:5A20 X:0278 Y:5A20 P:envmxdizc
$9D/C258 22 1F 89 80 JSL $80891F[$80:891F]   A:5A20 X:0600 Y:5A20 P:envmxdizc
$9D/C25C 22 23 D9 9D JSL $9DD923[$9D:D923]   A:F600 X:0280 Y:5D20 P:eNvmxdizc
$9D/C260 A9 7F 00    LDA #$007F              A:F800 X:0288 Y:0400 P:eNvmxdizc
$9D/C263 85 0E       STA $0E    [$00:000E]   A:007F X:0288 Y:0400 P:envmxdizc

$9D/C265 A9 80 77    LDA #$7780              A:007F X:0288 Y:0400 P:envmxdizc
$9D/C268 85 0C       STA $0C    [$00:000C]   A:7780 X:0288 Y:0400 P:envmxdizc
$9D/C26A A9 00 04    LDA #$0400              A:7780 X:0288 Y:0400 P:envmxdizc
$9D/C26D 8D 9C 07    STA $079C  [$9F:079C]   A:0400 X:0288 Y:0400 P:envmxdizc
$9D/C270 A2 0C 00    LDX #$000C              A:0400 X:0288 Y:0400 P:envmxdizc
$9D/C273 A0 04 00    LDY #$0004              A:0400 X:000C Y:0400 P:envmxdizc
$9D/C276 22 DF 8A 80 JSL $808ADF[$80:8ADF]   A:0400 X:000C Y:0004 P:envmxdizc
$9D/C27A 80 04       BRA $04    [$C280]      A:000B X:02C0 Y:056C P:envmxdiZc
$9D/C280 22 DE C2 9D JSL $9DC2DE[$9D:C2DE]   A:000B X:02C0 Y:056C P:envmxdiZc
$9D/C284 22 83 85 80 JSL $808583[$80:8583]   A:7C00 X:00F0 Y:056C P:envmxdizc
$9D/C288 22 DE AF 80 JSL $80AFDE[$80:AFDE]   A:7C00 X:00F0 Y:056C P:envmxdizc
$9D/C28C A9 68 35    LDA #$3568              A:2101 X:2100 Y:2320 P:eNvmxdizC
$9D/C28F 8F 00 75 7F STA $7F7500[$7F:7500]   A:3568 X:2100 Y:2320 P:envmxdizC
$9D/C293 22 D4 E0 9D JSL $9DE0D4[$9D:E0D4]   A:3568 X:2100 Y:2320 P:envmxdizC
$9D/C297 6B          RTL                     A:0200 X:0100 Y:0000 P:envmxdizc

///////////////////////////////////////////////////////////////////////////////////////////////
void DecompressFB30()		80BBB3

///////////////////////////////////////////////////////////////////////////////////////////////

void DecompressActual1()	80C373
///
// Preconditions:	$0C-$0E stores a pointer to compressed data.
//						The caller looks this up based on whichever player we are loading.
//						The compressed data is expected to start with a header containing the compression type.
//						The compression type is one of four choices: FB10, FB46, FB30, FB7A.
//						In practice, the profile images are all of compression type FB30.
//
//					$10-$12 stores a pointer to where the decompressed result should be written.
//						In practice, this is always 7F0000 for profile images.
//
// Postconditions: Decompressed result is written to the requested location.
//
// This function is used for a lot more than just decompressing profile images. It gets called on startup, too, for team logos.
//				 
$80/C373 08          PHP                     A:0000 X:0478 Y:0000 P:envmxdiZc
$80/C374 8B          PHB                     A:0000 X:0478 Y:0000 P:envmxdiZc
$80/C375 C2 30       REP #$30                A:0000 X:0478 Y:0000 P:envmxdiZc
$80/C377 22 9A 85 80 JSL $80859A[$80:859A]   A:0000 X:0478 Y:0000 P:envmxdiZc

$80/C37B A5 11       LDA $11    [$00:0011]   A:0000 X:0478 Y:0000 P:envmxdiZC
$80/C37D 8D 82 21    STA $2182  [$9F:2182]   A:7F00 X:0478 Y:0000 P:envmxdizC
$80/C380 A5 10       LDA $10    [$00:0010]   A:7F00 X:0478 Y:0000 P:envmxdizC
$80/C382 8D 81 21    STA $2181  [$9F:2181]   A:0000 X:0478 Y:0000 P:envmxdiZC	// Set up output register based on $10-$12

$80/C385 A5 0D       LDA $0D    [$00:000D]   A:0000 X:0478 Y:0000 P:envmxdiZC
$80/C387 48          PHA                     A:9A86 X:0478 Y:0000 P:eNvmxdizC
$80/C388 AB          PLB                     A:9A86 X:0478 Y:0000 P:eNvmxdizC
$80/C389 AB          PLB                     A:9A86 X:0478 Y:0000 P:eNvmxdizC	// Set data bank to $0D.

$80/C38A A4 0C       LDY $0C    [$00:000C]   A:9A86 X:0478 Y:0000 P:eNvmxdizC
$80/C38C B9 03 00    LDA $0003,y[$9A:8631]   A:9A86 X:0478 Y:862E P:eNvmxdizC
$80/C38F EB          XBA                     A:8004 X:0478 Y:862E P:eNvmxdizC
$80/C390 48          PHA                     A:0480 X:0478 Y:862E P:eNvmxdizC

$80/C391 B9 00 00    LDA $0000,y[$9A:862E]   A:0480 X:0478 Y:862E P:eNvmxdizC	// Load the compression type from the header.
																				//		This is FB30 for profile images.
$80/C394 C8          INY                     A:FB30 X:0478 Y:862E P:eNvmxdizC
$80/C395 C8          INY                     A:FB30 X:0478 Y:862F P:eNvmxdizC

$80/C396 C9 10 FB    CMP #$FB10              A:FB30 X:0478 Y:8630 P:eNvmxdizC	// Choose different routines for the different compression types
$80/C399 D0 05       BNE $05    [$C3A0]      A:FB30 X:0478 Y:8630 P:envmxdizC
...

$80/C3A0 C9 46 FB    CMP #$FB46              A:FB30 X:0478 Y:8630 P:envmxdizC
$80/C3A3 D0 05       BNE $05    [$C3AA]      A:FB30 X:0478 Y:8630 P:eNvmxdizc
...

$80/C3AA C9 30 FB    CMP #$FB30              A:FB30 X:0478 Y:8630 P:eNvmxdizc	// Check for ProfileImageCompressionType
$80/C3AD D0 05       BNE $05    [$C3B4]      A:FB30 X:0478 Y:8630 P:envmxdiZC
$80/C3AF 20 B3 BB    JSR $BBB3  [$80:BBB3]   A:FB30 X:0478 Y:8630 P:envmxdiZC	// Call DecompressFB30()
$80/C3B2 80 11       BRA $11    [$C3C5]      A:8300 X:0008 Y:0000 P:eNvmXdizc	// goto DoneDecompression

$80/C3B4 C9 7A FB    CMP #$FB7A              A:8300 X:0480 Y:0000 P:envmxdiZc	// Last type to check
$80/C3B7 D0 05       BNE $05    [$C3BE]      A:8300 X:0480 Y:0000 P:envmxdiZc	// Fall through to InvalidCompressionType if this one isn't it either.
$80/C3B9 20 F3 C2    JSR $C2F3  [$80:C2F3]   A:8300 X:0480 Y:0000 P:envmxdiZc
$80/C3BC 80 07       BRA $07    [$C3C5]      A:8300 X:0480 Y:0000 P:envmxdiZc

InvalidCompressionType:
$80/C3BE FA          PLX                     A:8300 X:0480 Y:0000 P:envmxdiZc	// Returns an error code if we couldn't make sense of the compression type.
$80/C3BF A2 01 00    LDX #$0001              A:8300 X:0480 Y:0000 P:envmxdiZc
$80/C3C2 AB          PLB                     A:8300 X:0480 Y:0000 P:envmxdiZc
$80/C3C3 28          PLP                     A:8300 X:0480 Y:0000 P:envmxdiZc
$80/C3C4 6B          RTL                     A:8300 X:0480 Y:0000 P:envmxdiZc

DoneDecompression:
$80/C3C5 C2 30       REP #$30                A:8300 X:0008 Y:0000 P:eNvmXdizc
$80/C3C7 FA          PLX                     A:8300 X:0008 Y:0000 P:eNvmxdizc
$80/C3C8 AB          PLB                     A:8300 X:0480 Y:0000 P:envmxdizc
$80/C3C9 28          PLP                     A:8300 X:0480 Y:0000 P:eNvmxdizc
$80/C3CA 6B          RTL                     A:8300 X:0480 Y:0000 P:envmxdiZc

///////////////////////////////////////////////////////////////////////////////////////////////

void DecompressActual2()	9B85C2
// Preconditions: 
//					$00 contains an arg.
//					$0C-$0E = Stores a pointer to decompressed data (e.g., 7F0000)
//					$10-$12 = Dest pointer (E.g., 7F6F00, 7F6900, 7F6300, 7F5D00, 7F5700, 7F5100, for home
											      7F4B00, 7F4500, 7F3F00, 7F3900, 7F3300, 7F2D00, for away)
//
// Postconditions: The decompressed bytes are transferred to a different location in system memory.
//				   Scrambles $00.
//				   Scrambles $04.
//				   Scrambles $06.
//				   Scrambles $14.
//				   Scrambles $16.

$9B/85C2 A6 00       LDX $00    [$00:0000]   A:0000 X:000A Y:0000 P:envmxdiZc	// This seems pointless but oh well.

$9B/85C4 8B          PHB                     A:0000 X:0480 Y:0000 P:envmxdizc	// Back up the data bank reg.

$9B/85C5 E2 20       SEP #$20                A:0000 X:0480 Y:0000 P:envmxdizc
$9B/85C7 A5 0E       LDA $0E    [$00:000E]   A:0000 X:0480 Y:0000 P:envMxdizc
$9B/85C9 48          PHA                     A:007F X:0480 Y:0000 P:envMxdizc	
$9B/85CA C2 20       REP #$20                A:007F X:0480 Y:0000 P:envMxdizc
$9B/85CC AB          PLB                     A:007F X:0480 Y:0000 P:envmxdizc	// Set the data bank to the high byte of the source pointer.

$9B/85CD 64 04       STZ $04    [$00:0004]   A:007F X:0480 Y:0000 P:envmxdizc	// Set $04 = 0
$9B/85CF A9 FE FF    LDA #$FFFE              A:007F X:0480 Y:0000 P:envmxdizc	// Set $06 = -1
$9B/85D2 85 06       STA $06    [$00:0006]   A:FFFE X:0480 Y:0000 P:eNvmxdizc

$9B/85D4 A5 00       LDA $00    [$00:0000]   A:FFFE X:0480 Y:0000 P:eNvmxdizc
$9B/85D6 4A          LSR A                   A:0480 X:0480 Y:0000 P:envmxdizc
$9B/85D7 4A          LSR A                   A:0240 X:0480 Y:0000 P:envmxdizc	
$9B/85D8 85 00       STA $00    [$00:0000]   A:0120 X:0480 Y:0000 P:envmxdizc	// $00 /= 4

$9B/85DA 80 0C       BRA $0C    [$85E8]      A:0120 X:0480 Y:0000 P:envmxdizc

$9B/85DC 8A          TXA                     A:0000 X:0080 Y:0000 P:envmxdiZc
$9B/85DD 4A          LSR A                   A:0080 X:0080 Y:0000 P:envmxdizc
$9B/85DE 4A          LSR A                   A:0040 X:0080 Y:0000 P:envmxdizc
$9B/85DF 4A          LSR A                   A:0020 X:0080 Y:0000 P:envmxdizc
$9B/85E0 4A          LSR A                   A:0010 X:0080 Y:0000 P:envmxdizc
$9B/85E1 F0 54       BEQ $54    [$8637]      A:0008 X:0080 Y:0000 P:envmxdizc
$9B/85E3 AA          TAX                     A:0008 X:0080 Y:0000 P:envmxdizc
$9B/85E4 C8          INY                     A:0008 X:0008 Y:0000 P:envmxdizc
$9B/85E5 C8          INY                     A:0008 X:0008 Y:0001 P:envmxdizc
$9B/85E6 80 0C       BRA $0C    [$85F4]      A:0008 X:0008 Y:0002 P:envmxdizc

$9B/85E8 A2 80 00    LDX #$0080              A:0120 X:0480 Y:0000 P:envmxdizc
$9B/85EB 64 14       STZ $14    [$00:0014]   A:0120 X:0080 Y:0000 P:envmxdizc
$9B/85ED 64 16       STZ $16    [$00:0016]   A:0120 X:0080 Y:0000 P:envmxdizc
$9B/85EF A5 04       LDA $04    [$00:0004]   A:0120 X:0080 Y:0000 P:envmxdizc
$9B/85F1 0A          ASL A                   A:0000 X:0080 Y:0000 P:envmxdiZc
$9B/85F2 0A          ASL A                   A:0000 X:0080 Y:0000 P:envmxdiZc
$9B/85F3 A8          TAY                     A:0000 X:0080 Y:0000 P:envmxdiZc

$9B/85F4 B1 0C       LDA ($0C),y[$7F:0000]   A:0000 X:0080 Y:0000 P:envmxdiZc
$9B/85F6 F0 E4       BEQ $E4    [$85DC]      A:0000 X:0080 Y:0000 P:envmxdiZc

$9B/85F8 EB          XBA                     A:0B00 X:0008 Y:004A P:envmxdizc
$9B/85F9 A8          TAY                     A:000B X:0008 Y:004A P:envmxdizc

$9B/85FA 98          TYA                     A:000B X:0008 Y:000B P:envmxdizc
$9B/85FB 0A          ASL A                   A:000B X:0008 Y:000B P:envmxdizc
$9B/85FC 90 05       BCC $05    [$8603]      A:0016 X:0008 Y:000B P:envmxdizc
$9B/8603 0A          ASL A                   A:0016 X:0008 Y:000B P:envmxdizc
$9B/8604 90 05       BCC $05    [$860B]      A:002C X:0008 Y:000B P:envmxdizc
$9B/860B 0A          ASL A                   A:002C X:0008 Y:000B P:envmxdizc
$9B/860C 90 05       BCC $05    [$8613]      A:0058 X:0008 Y:000B P:envmxdizc

$9B/860E A8          TAY                     A:8000 X:0001 Y:6000 P:eNvmxdizC
$9B/860F 8A          TXA                     A:8000 X:0001 Y:8000 P:eNvmxdizC
$9B/8610 04 17       TSB $17    [$00:0017]   A:0001 X:0001 Y:8000 P:envmxdizC
$9B/8612 98          TYA                     A:0001 X:0001 Y:8000 P:envmxdiZC

$9B/8613 0A          ASL A                   A:0058 X:0008 Y:000B P:envmxdizc
$9B/8614 90 05       BCC $05    [$861B]      A:00B0 X:0008 Y:000B P:envmxdizc
$9B/861B A8          TAY                     A:00B0 X:0008 Y:000B P:envmxdizc
$9B/861C 8A          TXA                     A:00B0 X:0008 Y:00B0 P:envmxdizc
$9B/861D 4A          LSR A                   A:0008 X:0008 Y:00B0 P:envmxdizc
$9B/861E AA          TAX                     A:0004 X:0008 Y:00B0 P:envmxdizc
$9B/861F E0 10 00    CPX #$0010              A:0004 X:0004 Y:00B0 P:envmxdizc
$9B/8622 B0 D6       BCS $D6    [$85FA]      A:0004 X:0004 Y:00B0 P:eNvmxdizc
$9B/8624 E0 00 00    CPX #$0000              A:0004 X:0004 Y:00B0 P:eNvmxdizc
$9B/8627 F0 0E       BEQ $0E    [$8637]      A:0004 X:0004 Y:00B0 P:envmxdizC
$9B/8629 E0 08 00    CPX #$0008              A:0004 X:0004 Y:00B0 P:envmxdizC
$9B/862C 90 CC       BCC $CC    [$85FA]      A:0004 X:0004 Y:00B0 P:eNvmxdizc

$9B/862E A5 04       LDA $04    [$00:0004]   A:0008 X:0008 Y:0000 P:envmxdiZC
$9B/8630 0A          ASL A                   A:001D X:0008 Y:0000 P:envmxdizC
$9B/8631 0A          ASL A                   A:003A X:0008 Y:0000 P:envmxdizc
$9B/8632 A8          TAY                     A:0074 X:0008 Y:0000 P:envmxdizc
$9B/8633 C8          INY                     A:0074 X:0008 Y:0074 P:envmxdizc
$9B/8634 C8          INY                     A:0074 X:0008 Y:0075 P:envmxdizc
$9B/8635 80 BD       BRA $BD    [$85F4]      A:0074 X:0008 Y:0076 P:envmxdizc

$9B/8637 A5 06       LDA $06    [$00:0006]   A:0000 X:0008 Y:0012 P:envmxdiZC
$9B/8639 1A          INC A                   A:0006 X:0008 Y:0012 P:envmxdizC
$9B/863A 1A          INC A                   A:0007 X:0008 Y:0012 P:envmxdizC
$9B/863B A8          TAY                     A:0008 X:0008 Y:0012 P:envmxdizC
$9B/863C 29 10 00    AND #$0010              A:0008 X:0008 Y:0008 P:envmxdizC
$9B/863F F0 06       BEQ $06    [$8647]      A:0000 X:0008 Y:0008 P:envmxdiZC
$9B/8647 84 06       STY $06    [$00:0006]   A:0000 X:0008 Y:0008 P:envmxdiZC
$9B/8649 A5 16       LDA $16    [$00:0016]   A:0000 X:0008 Y:0008 P:envmxdiZC
$9B/864B 91 10       STA ($10),y[$7F:6F08]   A:0000 X:0008 Y:0008 P:envmxdiZC
$9B/864D 98          TYA                     A:0000 X:0008 Y:0008 P:envmxdiZC
$9B/864E 18          CLC                     A:0008 X:0008 Y:0008 P:envmxdizC
$9B/864F 69 10 00    ADC #$0010              A:0008 X:0008 Y:0008 P:envmxdizc
$9B/8652 A8          TAY                     A:0018 X:0008 Y:0008 P:envmxdizc
$9B/8653 A5 14       LDA $14    [$00:0014]   A:0018 X:0008 Y:0018 P:envmxdizc
$9B/8655 91 10       STA ($10),y[$7F:6F18]   A:0000 X:0008 Y:0018 P:envmxdiZc
$9B/8657 E6 04       INC $04    [$00:0004]   A:0000 X:0008 Y:0018 P:envmxdiZc
$9B/8659 C6 00       DEC $00    [$00:0000]   A:0000 X:0008 Y:0018 P:envmxdizc
$9B/865B 10 8B       BPL $8B    [$85E8]      A:0000 X:0008 Y:0018 P:envmxdizc
...

///////////////////////////////////////////////////////////////////////////////////////////////

$9D/C99F 85 A5       STA $A5    [$00:00A5]   // Store an argument used by LoadTeamProfileImages.

///////////////////////////////////////////////////////////////////////////////////////////////

// void LoadTeamProfileImagesForGameSetup() 9DCC42
// Preconditions: Choice of home or away team is in $91. 0 means home, 2 means away
//		  Current teams choices are stored at 0x9F1C98 and 0x9f1C9A for home and away respectively.
//
// Postconditions: 
//		  Six players on a team have their decompressed profile images stored in system memory at the appropriate location.
//        Doesn't do VRAM transfer.
// 
// This function is called twice when loading the GAME SETUP screen, once per team.
// Scrambles $0C-$0E.
// Scrambles $10-$12.
//
$9D/CC42 A5 A5       LDA $A5    [$00:00A5]  
$9D/CC44 48          PHA                    // Politely back up $A5 because LookupPlayerIndexForPlayerWithProfile is going to scramble it.

$9D/CC45 A2 0A 00    LDX #$000A				// OffsetCounter=10. This gets used to index in an array of 2-byte elements.

ForEachProfileImagePlayerOnTeam:
$9D/CC48 DA          PHX                     
$9D/CC49 8A          TXA                     
$9D/CC4A 4A          LSR A                   // Divide OffsetCounter by 2 to get a [0-5] player index, used as an argument to the function below
$9D/CC4B 22 73 C9 9D JSL $9DC973[$9D:C973]   // Call LookupPlayerIndexForPlayerWithProfile().
											 //		Translates the [0-5] index to PlayerIndexOnTeam.
											 //     Sets $A5 to PlayerIndexOnTeam.

$9D/CC4F A6 91       LDX $91    [$00:0091]   // Load the choice of HomeOrAway. 0 == home, 2 == away					     
$9D/CC51 BD 98 1C    LDA $1C98,x[$9F:1C98]   // Load the index of CurrentTeam. 

					     // Current selection for home team is stored at 0x9F1C98					     
					     // Current selection for visitor team is stored at 0x9F1C9A

					     // Each possible value of CurrentTeam is one of the below
					     // 00 - Anaheim
					     // 01 - Boston
					     // 02 - Buffalo
					     // 03 - Calgary
					     // 04 - Chicago
					     // 05 - Dallas
					     // 06 - Detroit
					     // 07 - Edmonton
					     // 08 - Florida
					     // 09 - Hartford
					     // 0A - LA
					     // 0B - Montreal
					     // 0C - New Jersey
					     // 0D - New York Islanders
					     // 0E - New York Rangers
					     // 0F - Ottawa
					     // 10 - Philidelphia
					     // 11 - Pittsburg
					     // 12 - Quebec
					     // 13 - San Jose
					     // 14 - St Louis
					     // 15 - Tampa Bay
					     // 16 - Toronto
					     // 17 - Vancouver
					     // 18 - Washington
					     // 19 - Winnepeg
					     // 1A - All Stars East
					     // 1B - All Stars West

$9D/CC54 9F 6C 34 7E STA $7E346C,x[$7E:346C] // Stash the CurrentTeamIndex in the appropriate slot for home versus away

$9D/CC58 A2 1A 00    LDX #$001A              // Set X = 26
$9D/CC5B 22 4C 8F 80 JSL $808F4C[$80:8F4C]   // Call MultiplyAWithX() to set 
											 //		Acc = CurrentTeam * 26
$9D/CC5F 18          CLC                     
$9D/CC60 65 A5       ADC $A5    [$00:00A5]   //     Acc = GlobalPlayerIndex.
											 // GlobalPlayerIndex goes from 0 to about 800, a numerical ID for which player.
											 // Starting from the first player in Anaheim, to the last player of ASW.

$9D/CC62 0A          ASL A                   // X = GlobalPlayerIndex * 4
$9D/CC63 0A          ASL A				     // These are getting into pretty high numbers but fortunately 4 bytes is enough. :)
$9D/CC64 AA          TAX    
											 // There is a giant array stored at 9DCD53.
											 // There are like 800 elements, one per GlobalPlayerIndex.
											 // Each element is 4 bytes.
											 // Each element is a long pointer.
											 // Each element is pointer to compressed data (i.e., data with the header 30 FB...)
$9D/CC65 BF 53 CD 9D LDA $9DCD53,x[$9D:D16F]
$9D/CC69 85 0C       STA $0C    [$00:000C]                 
$9D/CC6B BF 55 CD 9D LDA $9DCD55,x[$9D:D1CD] 
$9D/CC6F 85 0E       STA $0E    [$00:000E]   // $0C-$0E stores a long pointer to compressed data.

$9D/CC71 A9 7F 00    LDA #$007F              
$9D/CC74 85 12       STA $12    [$00:0012]   
$9D/CC76 A9 00 00    LDA #$0000              
$9D/CC79 85 10       STA $10    [$00:0010]   // $10-$12 stores 7F0000.

$9D/CC7B 22 73 C3 80 JSL $80C373[$80:C373]   // Call DecompressActual1().

$9D/CC7F 86 00       STX $00    [$00:0000]   
$9D/CC81 A3 01       LDA $01,s  [$00:1FF6]   // Load OffsetCounter from before to use as an array element index
$9D/CC83 AA          TAX                     

$9D/CC84 A5 91       LDA $91    [$00:0091]   
$9D/CC86 F0 05       BEQ $05    [$CC8D]      
$9D/CC88 A9 00 2D    LDA #$2D00              
$9D/CC8B 80 03       BRA $03    [$CC90]      
$9D/CC8D A9 00 51    LDA #$5100              
$9D/CC90 18          CLC					Acc = 5100 for Home. 2D00 for Away.

$9D/CC91 7F AE CC 9D ADC $9DCCAE,x[$9D:CCAE]	// $9DCCAE is an array of pre-computed increments
												// 0000, 0600, 0C00, 1200, 1800
												// so that we don't have to do that sorta multiplication at runtime.
												// Call the array Times600.

												// PointerLow = 2D00 + Times600[PlayerIndex]	for Home, or
												                5100 + Times600[PlayerIndex]	for Away

$9D/CC95 85 10       STA $10    [$00:0010]		// $12 already contains 7F as high word.

$9D/CC97 A9 7F 00    LDA #$007F					
$9D/CC9A 85 0E       STA $0E    [$00:000E]				
$9D/CC9C A9 00 00    LDA #$0000              
$9D/CC9F 85 0C       STA $0C    [$00:000C]		// $0C-$0E = 7F0000
												// $10     = PointerLow

$9D/CCA1 22 C2 85 9B JSL $9B85C2[$9B:85C2]   // Call DecompressActual2()

$9D/CCA5 FA          PLX                     // Pull OffsetCounter
$9D/CCA6 CA          DEX                     // OffsetCounter -= 2
$9D/CCA7 CA          DEX                     

$9D/CCA8 10 9E       BPL $9E    [$CC48]      // if OffsetCounter > 0, goto ForEachProfileImagePlayerOnTeam

Done:
$9D/CCAA 68          PLA                     
$9D/CCAB 85 A5       STA $A5    [$00:00A5]   
$9D/CCAD 6B          RTL					// Restore $A5 and return
