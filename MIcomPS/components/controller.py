import wx
import sys
import glob
import serial
from utils import instruction_decode


class Controller:
    def __init__(self):
        self.lists = []
        self.ser = None

    def scan_ports(self):
        if sys.platform.startswith('win'):
            ports = ['COM%s' % (i + 1) for i in range(256)]
        elif sys.platform.startswith('linux') or sys.platform.startswith('cygwin'):
            # this excludes your current terminal "/dev/tty"
            ports = glob.glob('/dev/tty[A-Za-z]*')
        elif sys.platform.startswith('darwin'):
            ports = glob.glob('/dev/tty.*')
        else:
            raise EnvironmentError('Unsupported platform')

        result = []
        for port in ports:
            try:
                s = serial.Serial(port)
                s.close()
                result.append(port)
            except (OSError, serial.SerialException):
                pass
        return result

    def connect_to_serial_port(self, port):
        self.ser = serial.Serial(port, 19200, timeout=0)

    def set_lists(self, lists):
        self.lists = lists

    def send_event(self, event):
        if event == "clock":
            #self.ser.write("00110000")
            self.update_fields()
        elif event == "run":
            #self.ser.write("01110000")
            self.update_fields()

    def update_fields(self):
        #data1 = ("WireNameClk", str(self.ser.readline()))
        data1 = ("WireNameClk", "00000010000100011010000000100111")
        data2 = ("10", instruction_decode.get_instruction("00000010000100011010000000100111"), "---", "---", "IF", "ID", "EX")
        i = 0
        for lista in self.lists:
            if i != 10:
                if lista.GetItemCount() > 0:
                    lista.DeleteAllItems()
                index = lista.InsertStringItem(sys.maxint, data1[0])
                lista.SetStringItem(index, 1, data1[1])
                lista.SetColumnWidth(0, wx.LIST_AUTOSIZE)
                lista.SetColumnWidth(1, wx.LIST_AUTOSIZE)
            else:
                if lista.GetItemCount() > 0:
                    lista.DeleteAllItems()
                index = lista.InsertStringItem(sys.maxint, data2[0])
                lista.SetStringItem(index, 1, data2[1])
                lista.SetStringItem(index, 2, data2[2])
                lista.SetStringItem(index, 3, data2[3])
                lista.SetStringItem(index, 4, data2[4])
                lista.SetStringItem(index, 5, data2[5])
                lista.SetStringItem(index, 6, data2[6])
                lista.SetColumnWidth(0, 50)
                lista.SetColumnWidth(1, wx.LIST_AUTOSIZE)
                lista.SetColumnWidth(2, 50)
                lista.SetColumnWidth(3, 50)
                lista.SetColumnWidth(4, 50)
                lista.SetColumnWidth(5, 50)
                lista.SetColumnWidth(6, 50)
            i += 1
