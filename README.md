A personal implementation of a CPU with the MIPS instruction set, written in VHDL. 

It is based on the architecture presented in *Computer Organization and Design*, by Patterson and Hennessy, with some personal tweaks.

The main component is CPU.vhd. It can accept and send data with the outside world with its ports, although there are more ports than necessary (for ease of implementation). I might fix this in the future as, right now, they are too many compared to a real FPGA's IOBs and thus prevent proper mapping.

As of now, only Behavioural tests pass, while Post-Route testing won't function properly even with the port count decreased. Regardless of that, more Behavioural tests are required.

Some implementation choices:
Read/Write hazards are handled by waiting until WriteBack has occurred. WriteBack and Reading must occur in different cycles if they act on the same registers. Beq instructions reset following instructions if the condition is met. There are still several instructions missing, I'll add more in the future. Maybe.

Any and all suggestions/critiques/comments are more than welcome!