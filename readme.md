# Apple II Quicksort implementation as a tribute to Charles Antony Richard Hoare

Dedicated to Charles Antony Richard Hoare, who invented QuickSort algorithm 60 years ago.

It is written in assembly language only (Merlin).
It :

* generates 4096 pseudo random 16 bits unsigned integers at memory address $2000
* sorts these values, using a non recursive version of Hoare's algorithm
* checks order

This archive contains a disk image : use it with Applewin or your favourite Apple II emulator, and type brun qs.

## Credits

* Charles Antony Richard Hoare

## Usage

This archive contains a disk image to be used it with Applewin or your favourite Apple II emulator.

* Boot qs.do image disk
* type brun qs

## Making

* First implemented and tested on Delphi (see pascal code Quicksort.pas)
* Then implemented in 6502 assembly, using Merlin32, Visual Studio Code.

## Performance

On a standard Apple //c : about 20 seconds (I guess a bubble sort in BASIC would take much longer.)
On a modern PC, compiled with Delphi : 0,3 ms

## Requirements to compile and run

Here is my configuration:

* Visual Studio Code with 2 extensions :

-> [Merlin32 : 6502 code hightliting](marketplace.visualstudio.com/items?itemName=olivier-guinart.merlin32)

-> [Code-runner :  running batch file with right-clic in VS Code.](marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)

* [Merlin32 cross compiler](brutaldeluxe.fr/products/crossdevtools/merlin)

* [Applewin : Apple IIe emulator](github.com/AppleWin/AppleWin)

* [Applecommander ; disk image utility](applecommander.sourceforge.net)

* [Ciderpress ; disk image utility](a2ciderpress.com)

Note :
DoMerlin.bat puts all things together. It needs a path to Merlin32 directory, to Applewin, and to Applecommander.
DoMerlin.bat is to be placed in project directory.
It compile source (*.s) with Merlin32, copy 6502 binary to a disk image (containg ProDOS), and launch Applewin with this disk in S1,D1.

qsA2.s is ready to be compiled on a genuine Apple II, with Merlin 8.
It can be imported in a disk image using Ciderpress, then used on an Apple II (IIc in my case).
I use [Floppy emu](www.bigmessowires.com/floppy-emu).
See "Merlin32 to apple II Merlin 8.txt" to know how to convert a Merin32 source to a Merlin 8 compatible source.

## Todo

* Port to DHGR with Mouse Graphics Toolkit, for fancier look
* Optimize code
* Implement recursive version, with a managed stack
* Compare performance with other languages (Pascal, BASIC, c65...) and algorithms
