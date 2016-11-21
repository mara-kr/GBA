import sys

if (len(sys.argv) < 2):
    print("Usage: ./%s <file>" % sys.argv[0]);
    exit()

f = open(sys.argv[1], "r")
outfile = open("outfile.hex", "w")
byte = 0
word = ""
for line in f:
    line = line.strip("\n")
    word = line + word
    byte += 1
    if (byte == 4):
        outfile.write(word + "\n")
        byte = 0
        word = ""

f.close()
outfile.close()
