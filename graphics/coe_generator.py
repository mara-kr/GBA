print "memory_initialization_radix=16;"
print "memory_initialization_vector="

for i in range(1024/2):
    if 32 <= i and i < 40:
        print "440044,"
    else:
        print "40004,"

for i in range(1024/2):
    print "0,"

for i in range(512/2):
    print "50005,"

for i in range(512/2):
    print "0,"

for i in range(1024/2):
    print "0,"

for i in range(1024/2):
    if 128 <= i and i < 384 and 4 <= i&15 and i&15 < 12:
        print("60006,")
    else:
        print "0,"

for i in range(1024/2):
    print "0,"

for i in range(1024/2):
    print "20042004,"

for i in range(1024/2):
    print "0,"

#
#
#
#
for i in range(4*32/2/2):
    print "00000000,"

for i in range(32/2/2):
    print "11111111,"

for i in range(5*32/2/2): #4
    print "00000000,"

for i in range(64/2/2): #5
    print "02020202,"
for i in range(62/2/2): #6
    print "03030303,"
print "03030303;"
