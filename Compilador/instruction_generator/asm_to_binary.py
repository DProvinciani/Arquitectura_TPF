import dec_to_binary


def rd_rt_shamt(fields):
    rt = dec_to_binary.strdec_to_bin(int((fields[1])[1:-1]), 5)
    rd = dec_to_binary.strdec_to_bin(int((fields[0])[1:-1]), 5)
    shamt = dec_to_binary.strdec_to_bin(int((fields[2])[:-1]), 5)
    return str(rt + rd + shamt)


def rd_rt_rs(fields):
    rs = dec_to_binary.strdec_to_bin(int((fields[2])[1:-1]), 5)
    rt = dec_to_binary.strdec_to_bin(int((fields[1])[1:-1]), 5)
    rd = dec_to_binary.strdec_to_bin(int((fields[0])[1:-1]), 5)
    return str(rs + rt + rd)


def rd_rs_rt(fields):
    rs = dec_to_binary.strdec_to_bin(int((fields[1])[1:-1]), 5)
    rt = dec_to_binary.strdec_to_bin(int((fields[2])[1:-1]), 5)
    rd = dec_to_binary.strdec_to_bin(int((fields[0])[1:-1]), 5)
    return str(rs + rt + rd)


def rs_rt_offset(fields):
    rs = dec_to_binary.strdec_to_bin(int((fields[0])[1:-1]), 5)
    rt = dec_to_binary.strdec_to_bin(int((fields[1])[1:-1]), 5)
    offset = dec_to_binary.strdec_to_bin(int((fields[2])[:-1]), 16)
    return str(rs + rt + offset)


def rt_rs_immediate(fields):
    rt = dec_to_binary.strdec_to_bin(int((fields[0])[1:-1]), 5)
    rs = dec_to_binary.strdec_to_bin(int((fields[1])[1:-1]), 5)
    immediate = dec_to_binary.strdec_to_bin(int((fields[2])[:-1]), 16)
    return str(rs + rt + immediate)


def rt_immediate(fields):
    rt = dec_to_binary.strdec_to_bin(int((fields[0])[1:-1]), 5)
    immediate = dec_to_binary.strdec_to_bin(int((fields[1])[:-1]), 16)
    return str(rt + immediate)


def rt_offset_base(fields):
    base = dec_to_binary.strdec_to_bin(int((fields[1].split("($")[1])[:-2]), 5)
    rt = dec_to_binary.strdec_to_bin(int((fields[0])[1:-1]), 5)
    offset = dec_to_binary.strdec_to_bin(int(fields[1].split("($")[0]), 16)
    return str(base + rt + offset)


def generate_sll(fields):
    opcode = "000000"
    return str(opcode + "00000" + rd_rt_shamt(fields) + "000000")


def generate_srl(fields):
    opcode = "000000"
    return str(opcode + "00000" + rd_rt_shamt(fields) + "000010")


def generate_sra(fields):
    opcode = "000000"
    return str(opcode + "00000" + rd_rt_shamt(fields) + "000011")


def generate_sllv(fields):
    opcode = "000000"
    return str(opcode + rd_rt_rs(fields) + "00000000100")


def generate_srlv(fields):
    opcode = "000000"
    return str(opcode + rd_rt_rs(fields) + "00000000110")


def generate_srav(fields):
    opcode = "000000"
    return str(opcode + rd_rt_rs(fields) + "00000000111")


def generate_jr(fields):  # Chequear que no de error porque fields es una sola palabra
    opcode = "000000"
    rs = dec_to_binary.strdec_to_bin(int((fields[0])[1:-1]), 5)
    return str(opcode + rs + "000000000000000001000")


# Implementar aca JLAR


def generate_add(fields):
    opcode = "000000"
    return str(opcode + rd_rs_rt(fields) + "00000100000")


def generate_sub(fields):
    opcode = "000000"
    return str(opcode + rd_rs_rt(fields) + "00000100010")


def generate_and(fields):
    opcode = "000000"
    return str(opcode + rd_rs_rt(fields) + "00000100100")


def generate_or(fields):
    opcode = "000000"
    return str(opcode + rd_rs_rt(fields) + "00000100101")


def generate_xor(fields):
    opcode = "000000"
    return str(opcode + rd_rs_rt(fields) + "00000100110")


def generate_nor(fields):
    opcode = "000000"
    return str(opcode + rd_rs_rt(fields) + "00000100111")


def generate_slt(fields):
    opcode = "000000"
    return str(opcode + rd_rs_rt(fields) + "00000101010")


def generate_beq(fields):
    opcode = "000100"
    return str(opcode + rs_rt_offset(fields))


def generate_bne(fields):
    opcode = "000101"
    return str(opcode + rs_rt_offset(fields))


def generate_addi(fields):
    opcode = "001000"
    return str(opcode + rt_rs_immediate(fields))


def generate_slti(fields):
    opcode = "001010"
    return str(opcode + rt_rs_immediate(fields))


def generate_andi(fields):
    opcode = "001100"
    return str(opcode + rt_rs_immediate(fields))


def generate_ori(fields):
    opcode = "001101"
    return str(opcode + rt_rs_immediate(fields))


def generate_xori(fields):
    opcode = "001110"
    return str(opcode + rt_rs_immediate(fields))


def generate_lui(fields):
    opcode = "001111"
    return str(opcode + "00000" + rt_immediate(fields))


def generate_lb(fields):
    opcode = "100000"
    return str(opcode + rt_offset_base(fields))


def generate_lh(fields):
    opcode = "100001"
    return str(opcode + rt_offset_base(fields))


def generate_lw(fields):
    opcode = "100011"
    return str(opcode + rt_offset_base(fields))


def generate_lbu(fields):
    opcode = "100100"
    return str(opcode + rt_offset_base(fields))


def generate_lhu(fields):
    opcode = "100101"
    return str(opcode + rt_offset_base(fields))


def generate_lwu(fields):
    opcode = "100111"
    return str(opcode + rt_offset_base(fields))


def generate_sb(fields):
    opcode = "101000"
    return str(opcode + rt_offset_base(fields))


def generate_sh(fields):
    opcode = "101001"
    return str(opcode + rt_offset_base(fields))


def generate_sw(fields):
    opcode = "101011"
    return str(opcode + rt_offset_base(fields))


def generate_j(fields):  # Chequear que no de error porque fields es una sola palabra
    opcode = "000010"
    target = dec_to_binary.strdec_to_bin(int((fields[0])[:-1]), 26)
    return str(opcode + target)


def generate_jal(fields):  # Chequear que no de error porque fields es una sola palabra
    opcode = "000011"
    target = dec_to_binary.strdec_to_bin(int((fields[0])[:-1]), 26)
    return str(opcode + target)
