# ACV-1030 V6355 Programming Guide

Research notes and a working DOS COM example for the ACV-1030 color graphics adapter and its Yamaha V6355 video controller.

This repository is intentionally focused. It contains the maintained 160x200x16 color program and the minimum source needed to rebuild it. Exploratory test programs, private project material, and the complete card manual transcription remain outside this repository.

## Confirmed hardware results

Testing was performed on an ACV-1030 card with both relevant display paths:

- Standard CGA mode 4 works at 320x200 with four colors.
- The hidden 160x200x16 graphics mode works on CGA/TTL output with fixed IRGB colors.
- The same hidden mode works on composite output with NTSC timing.
- Composite output responds to the V6355 palette writes used by the program.
- CGA/TTL output continues to show the fixed IRGB interpretation of the pixel indexes.
- Full port addresses must be written through `DX`; immediate `OUT` forms truncate `0x3D8`-`0x3DE` to their low-byte aliases and do not produce the same extended-color behavior.
- Both `B000h` and `B800h` reached the tested framebuffer on this card. The maintained program uses `B800h`, matching the ACV-1030 manual's color/graphics buffer description.

These results are hardware observations from one test setup. Card revisions, monitors, timing standards, and output paths may produce different results.

## Included files

- `src/ACV-1030-COL.ASM` - maintained program configuration and controls
- `src/ACV-1030-BAR.ASM` - implementation included by the color program
- `bin/ACV-1030-COL.COM` - prebuilt DOS executable

The source is the authoritative reference. The COM file is included for convenient hardware testing.

## Controls

- `SPACE` - randomize the composite palette and redraw
- `N` - toggle NTSC/PAL timing
- `W` - restore the standard 16-color bar screen
- `A` - cycle border color
- `Q` - draw a random circle
- `T` - draw the test pattern
- `D` - draw the gradient pattern
- `0` - set bar width to 10 pixels
- `1` through `9` - set bar width to 1 through 9 pixels
- `ESC` - exit to DOS

The palette changes are visible on composite output. CGA/TTL remains fixed IRGB.

## Building

Install NASM and run from this repository directory:

```text
nasm -f bin -i src/ src/ACV-1030-COL.ASM -o bin/ACV-1030-COL.COM -l bin/ACV-1030-COL.LST
```

The program targets a DOS COM environment and uses 16-bit instructions. The prebuilt binary was assembled successfully with NASM without errors or warnings.

## Hardware setup

The program is intended for an ACV-1030 card connected to either a CGA/TTL display or a compatible composite display. The tested composite configuration uses NTSC timing.

The initialization relies on these ACV-1030-specific details:

- BIOS mode 4 establishes CGA timing and the framebuffer.
- Register `0x67` is set to `0x18`.
- Register `0x65` is set to `0x01` for 200-line NTSC color timing.
- `0x80` is written to `0x3DD` before the hidden-mode unlock.
- `0x4A` is written to `0x3D8` using `DX`.
- The framebuffer is accessed through segment `B800h`.

Improper display-controller programming can produce unstable video. Test on hardware at your own risk and make sure the program can restore text mode before interrupting it.

## Source and manual references

The register descriptions were transcribed from the ACV-1030 card manual and combined with original hardware testing. The manual transcription is not included here. This repository summarizes only the information needed to understand and rebuild the example.

## License

The original source in this repository is released under the MIT License. See [LICENSE](LICENSE).
