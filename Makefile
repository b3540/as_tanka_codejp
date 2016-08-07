TARGET = as_tanka_codejp
CFLAGS = -Wall -Wextra
CFLAGS += -nostdinc -nostdlib -fno-builtin -c

$(TARGET).img: $(TARGET).o
	ld -o $@ $< -T boot.ld -Map $(TARGET).map

$(TARGET).o: $(TARGET).S
	gcc $(CFLAGS) -o $@ $<

run: $(TARGET).img
	qemu-system-i386 -fda $(TARGET).img

clean:
	rm -f *~ *.o *.bin *.dat *.img *.map

.PHONY: run clean
