# ACV-1030 V6355 Programming Guide

Programming reference and working DOS COM demonstration for the ACV-1030 color graphics adapter and its Yamaha V6355 video controller.

By **Retro Erik** - [YouTube: Retro Hardware and Software](https://www.youtube.com/@RetroErik)

![Platform](https://img.shields.io/badge/Platform-ACV--1030-blue)
![Video](https://img.shields.io/badge/Video-Yamaha%20V6355-green)
![License](https://img.shields.io/badge/License-MIT-green)

## Overview

The ACV-1030 is an IBM-compatible CGA adapter with a Yamaha V6355 controller. Hardware testing shows that the card also exposes a hidden 160x200x16 graphics mode when the controller is programmed with the correct register sequence.

| Component | Details |
|-----------|---------|
| **Adapter** | ACV-1030 ISA color graphics adapter |
| **Video chip** | Yamaha V6355 |
| **Standard mode** | 320x200, 4-color CGA mode 4 |
| **Hidden mode** | 160x200, 16-color graphics |
| **Color output** | Fixed IRGB on CGA/TTL; programmable palette on tested composite output |
| **Color buffer** | B800h on the maintained ACV-1030 program |
| **Target** | 16-bit DOS COM program |

This repository is intentionally focused. It contains the maintained demonstration program, the implementation source required to rebuild it, and a prebuilt COM file. Exploratory test programs, private project material, and the complete card manual transcription are not included.

## Quick Start

### Download the demonstration

Download the prebuilt [ACV-1030-COL.COM](bin/ACV-1030-COL.COM) and run it on an ACV-1030-equipped DOS system.

The program is intended for testing with either a CGA/TTL display or a compatible composite display. The tested composite configuration uses NTSC timing.

### Build from source

Install [NASM](https://www.nasm.us/) and run this command from the repository directory:

```bash
nasm -f bin -i src/ src/ACV-1030-COL.ASM -o bin/ACV-1030-COL.COM -l bin/ACV-1030-COL.LST
```

The source targets a DOS COM environment and uses 16-bit instructions. The included COM file was assembled successfully with NASM without errors or warnings.

## ACV-1030-COL.COM - Graphics Mode Demo

Interactive demonstration of the ACV-1030 hidden 160x200x16 graphics mode.

| Key | Function |
|-----|----------|
| **SPACE** | Randomize the composite palette and redraw |
| **N** | Toggle NTSC/PAL timing |
| **W** | Restore the standard 16-color bar screen |
| **A** | Cycle border color |
| **Q** | Draw a random colored circle |
| **D** | Draw the gradient pattern |
| **T** | Draw the test pattern |
| **0** | Set bar width to 10 pixels |
| **1-9** | Set bar width to 1-9 pixels |
| **ESC** | Exit to DOS and restore text mode |

Palette changes are visible on composite output. CGA/TTL continues to show the fixed IRGB interpretation of the 16 pixel indexes.

## Confirmed Hardware Results

Testing was performed on an ACV-1030 card using both relevant display paths:

- Standard CGA mode 4 works at 320x200 with four colors.
- The hidden 160x200x16 graphics mode works on CGA/TTL output with fixed IRGB colors.
- The same hidden mode works on composite output with NTSC timing.
- Composite output responds to the V6355 palette writes used by the program.
- Full `0x3D*` port addresses must be written through `DX`. Immediate `OUT` forms truncate these ports to their low-byte aliases and do not produce the same extended-color behavior.
- Both `B000h` and `B800h` reached the tested framebuffer on this card. The maintained program uses `B800h`, matching the ACV-1030 manual's color/graphics buffer description.

These are hardware observations from one test setup. Card revisions, monitors, timing standards, and output paths may produce different results.

## Key Technical Facts

- **Mode setup:** BIOS mode 4 is established before the V6355-specific configuration.
- **Register 0x67:** Set to `0x18` for the tested 8-bit bus and display configuration.
- **Register 0x65:** Set to `0x01` for 200-line NTSC color timing. `0x09` selects PAL/SECAM timing and displaced the tested composite image.
- **Safe state:** Write `0x80` to `0x3DD` before enabling the hidden mode.
- **Mode unlock:** Write `0x4A` to `0x3D8` through `DX`.
- **Pixel format:** Packed 4-bit indexes, two pixels per byte, with CGA-style interlaced rows.
- **Palette:** 16 entries, 2 bytes per entry, written through the V6355 register-bank interface.
- **Video paths:** CGA/TTL uses fixed IRGB output; composite output uses the tested programmable palette path.

## Source Files

- [src/ACV-1030-COL.ASM](src/ACV-1030-COL.ASM) - maintained program configuration and controls
- [src/ACV-1030-BAR.ASM](src/ACV-1030-BAR.ASM) - implementation included by the color program
- [bin/ACV-1030-COL.COM](bin/ACV-1030-COL.COM) - prebuilt DOS executable

The source is the authoritative reference. The COM file is included for convenient hardware testing.

## Limitations and Safety

The ACV-1030 should be treated as a separate hardware target rather than assumed to behave exactly like the Olivetti Prodest PC1, even though both use V6355-family video hardware.

Improper display-controller programming can produce unstable video. Test on hardware at your own risk. The program is designed to restore text mode when `ESC` is pressed; avoid interrupting it while video registers are being changed.

The full 512-color range has not been mapped systematically on the ACV-1030. The documented results apply to the tested card, monitor, and NTSC composite setup.

## Documentation

The register descriptions were transcribed from the ACV-1030 card manual and combined with original hardware testing. The manual transcription is not included in this repository. This guide summarizes only the information needed to understand and rebuild the example.

## Credits

- **Author:** Dag Erik Hagesaeter (Retro Erik)
- **Hardware testing:** Retro Erik
- **AI-assisted development:** GitHub Copilot and Claude

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

## YouTube

For more retro computing research and hardware testing, visit **Retro Hardware and Software**:

[https://www.youtube.com/@RetroErik](https://www.youtube.com/@RetroErik)
