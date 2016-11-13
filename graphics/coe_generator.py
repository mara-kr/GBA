print "memory_initialization_radix=16;"
print "memory_initialization_vector="

for i in range(1024):
    print "4,"

for i in range(1024):
    print "0,"

for i in range(512):
    print "5,"

for i in range(512):
    print "0,"

for i in range(1024):
    print "0,"

for i in range(1024):
    if 256 <= i and i < 768 and 8 <= i&31 and i&31 < 24:
        print("6,")
    else:
        print "0,"

for i in range(1024):
    print "0,"

for i in range(1024):
    print "2004,"

for i in range(1024):
    print "0,"

#
#
#
#
for i in range(4*32/2):
    print "0000,"

for i in range(32/2):
    print "1111,"

for i in range(5*32/2): #4
    print "0000,"

for i in range(64/2): #5
    print "0202,"
for i in range(62/2): #6
    print "0303,"
print "0303;"
