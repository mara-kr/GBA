import sys

if (len(sys.argv) < 2):
    print("Usage ./%s <file>", sys.argv[0]);

f = open(sys.argv[1], "r")
outfile = open("outfile.hex", "w")
byte = 0
word = ""
for line in f:
    word += line
    byte += 1
    if (byte == 4):
        outfile.write(word)
        byte = 0
        word = ""

f.close()
outfile.close()
