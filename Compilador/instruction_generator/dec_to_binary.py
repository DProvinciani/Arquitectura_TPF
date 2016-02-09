def strdec_to_bin(number, width):
    number &= (2 << width - 1) - 1
    format_str = '{:0' + str(width) + 'b}'
    return format_str.format(int(number))
