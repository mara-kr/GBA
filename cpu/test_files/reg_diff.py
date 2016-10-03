from argparse import ArgumentParser
import subprocess
import os

REG_NAMES = ['r0', 'r1', 'r2', 'r3', 'r4', 'r5', 'r6', 'r7', 'r8',
             'r9', 'r10', 'r11', 'r12', 'sp', 'lr', 'pc', 'cpsr']

VCS_DIFF_FILE = "vcs_diff_file.outdiff"
QEMU_DIFF_FILE = "qemu_diff_file.outdiff"


def parseArgs():
    parser = ArgumentParser(description="Diff VCS & QEMU register dumps")
    parser.add_argument("--vcs", action="store", required=True,
                        type=str, dest="vcs_file",
                        help="VCS output file")
    parser.add_argument("--qemu", action="store", required=True,
                        type=str, dest="qemu_file",
                        help="QEMU GDB output file")
    parser.add_argument("--dir", action="store", required=True,
                        type=str, dest="work_dir",
                        help="Work directory")
    args = parser.parse_args()
    return (args.vcs_file, args.qemu_file, args.work_dir)


def get_regs(f):
    regs = []
    for i in xrange(17):
        line = f.readline()
        if (len(line) == 0 or line[0]=='$'): # EOF
            return None
        line = line.split()
        val = int(line[1], 16)
        # CPSR[27:8] are reserved
        if (i == 16):
            val = val & int('0xF00000FF', 16)
        regs.append(hex(val))
    f.readline() # Line to ignore after every reg set
    return regs


def get_reg_diff(f):
    reg_diff = []
    old_regs = get_regs(f)
    for i in xrange(len(old_regs)): # Print initial set values
        if (int(old_regs[i], 16) != 0):
            print("%s: %s\n" %(REG_NAMES[i], old_regs[i]));

    new_regs = get_regs(f)
    while (new_regs != None):
        assert(len(old_regs) == len(new_regs))
        for i in xrange(len(old_regs)):
            if (old_regs[i] != new_regs[i] and i != 15): #r15=pc
                reg_diff.append([REG_NAMES[i], new_regs[i]])
        old_regs = new_regs
        new_regs = get_regs(f)
    return reg_diff


def compare_diffs(vcs_diff, qemu_diff, vcs_file, qemu_file):
    vcs_diff_f = open(vcs_file, "w")
    for x in vcs_diff:
        vcs_diff_f.write("%4s: %-.10s\n" % (x[0], x[1]))
    vcs_diff_f.close()

    qemu_diff_f = open(qemu_file, "w")
    for x in qemu_diff:
        qemu_diff_f.write("%4s: %-.10s\n" % (x[0], x[1]))
    qemu_diff_f.close()

    subprocess.call(["diff", '-y','-W 60', vcs_file, qemu_file])


if __name__=="__main__":
    (vcs_file, qemu_file, work_dir) = parseArgs()

    vcs_diff_file = work_dir + VCS_DIFF_FILE
    qemu_diff_file = work_dir + QEMU_DIFF_FILE

    vcs_f = open(vcs_file, "r")
    qemu_f = open(qemu_file, "r")

    while(True):
        toks = vcs_f.readline().split()
        if (len(toks) > 0 and toks[0] == "Start"):
            break

    print("VCS initial: (<)")
    vcs_diff = get_reg_diff(vcs_f)
    qemu_f.readline() # Ignore 0x0 in ?? () line
    print("QEMU initial: (>)")
    qemu_diff = get_reg_diff(qemu_f)

    vcs_f.close()
    qemu_f.close()

    compare_diffs(vcs_diff, qemu_diff, vcs_diff_file, qemu_diff_file);
