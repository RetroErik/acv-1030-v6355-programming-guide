; ============================================================================
; ACV-1030-COL.ASM - ACV-1030 160x200x16 color program
; Target: ACV-1030 ISA video card / V6355, DOS COM
;
; This is the working ACV-1030 version of the color-bar program.
; It is based on the proven NTSC initialization variant and is intended to
; remain as a usable demonstration program, not only as a hardware test.
;
; Validated on the ACV-1030:
;   - 160x200 graphics mode with 16 IRGB colors
;   - Color output on CGA/TTL
;   - Color output on composite video
;   - No vertical screen displacement with NTSC timing
;   - Interactive drawing controls and bar-width controls work
;
; ACV-1030 initialization:
;   - Register 0x65 = 0x01: 200 lines, NTSC, color monitor, CRT
;   - Mode port 0x3D8 = 0x4A: graphics, video enabled, 16-color mode
;   - Full 0x3D* ports are accessed through DX
;   - 0x80 is written to 0x3DD before mode unlock
;   - Video memory is accessed at B800h
;
; Differences from the Olivetti PC1 colorbar.asm:
;   - The PC1 version uses PAL timing (register 0x65 = 0x09); this version
;     uses NTSC timing (0x01) so the ACV-1030 composite output is in color.
;   - The PC1 version uses short port aliases (D8/DD/DE/D9); this version uses
;     full 3D8/3D9/3DD/3DE port addresses with DX-based OUT instructions.
;   - The PC1 version uses B000h for hidden-mode video memory; this card uses
;     B800h for its color/graphics buffer.
;   - The PC1 palette-RAM procedure works on the ACV-1030 composite path. The
;     CGA/TTL path bypasses those palette values and remains fixed IRGB.
;
; Controls:
;   SPACE - Randomize the programmable composite palette and redraw. On
;           CGA/TTL, the fixed IRGB colors remain unchanged.
;   N     - Toggle PAL/NTSC timing. On composite output, PAL removes the
;           colors; on CGA/TTL, colors remain but the picture moves downward.
;   W     - Restore the standard 16-color bar screen
;   A     - Cycle border color
;   Q     - Draw a random circle
;   T     - Draw the test pattern
;   D     - Draw the gradient pattern
;   0     - Set bar width to 10 pixels
;   1-9   - Set bar width to 1-9 pixels
;   ESC   - Exit to DOS
;
; Build:
;   nasm -f bin -i src/ -o bin/ACV-1030-COL.COM -l bin/ACV-1030-COL.LST src/ACV-1030-COL.ASM
;
; The implementation is shared with ACV-1030-BAR.ASM so the validated behavior
; remains synchronized with the exploratory source without duplicating it.
; ============================================================================

%define ACV_COMPLIANT_UNLOCK 1
%define ACV_NTSC 1
%define ACV_RUNTIME_TV_TOGGLE 1
%include "ACV-1030-BAR.ASM"
