#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import wx
import sys
import time
import serial
import string
import binascii
import threading

import errno

from utils import binary_to_dec
from utils import instruction_decode
from wx._controls_ import TB_FLAT
from components import serial_config_dialog
from wx.lib.mixins.listctrl import ListCtrlAutoWidthMixin

SERIALRX = wx.NewEventType()
# bind to serial data receive events
EVT_SERIALRX = wx.PyEventBinder(SERIALRX, 0)


class SerialRxEvent(wx.PyCommandEvent):
    eventType = SERIALRX

    def __init__(self, windowID, data):
        wx.PyCommandEvent.__init__(self, self.eventType, windowID)
        self.data = data

    def Clone(self):
        self.__class__(self.GetId(), self.data)


class AutoWidthListCtrl(wx.ListCtrl, ListCtrlAutoWidthMixin):
    def __init__(self, parent):
        wx.ListCtrl.__init__(self, parent, -1, style=wx.LC_REPORT)
        ListCtrlAutoWidthMixin.__init__(self)


class MicompsFrame(wx.Frame):
    def __init__(self, *args, **kwds):
        wx.Frame.__init__(self, *args, **kwds)

        self.data_recived = ''
        self.registers_tuples = []
        self.step1_input_tuples = []
        self.step1_output_tuples = []
        self.step2_input_tuples = []
        self.step2_output_tuples = []
        self.step3_input_tuples = []
        self.step3_output_tuples = []
        self.step4_input_tuples = []
        self.step4_output_tuples = []
        self.step5_input_tuples = []
        self.step5_output_tuples = []
        self.instructions_list = []
        self.pipeline_tuples = []

        self.lists = []
        self.serial = serial.Serial()
        self.serial.timeout = 0
        self.thread = None
        self.alive = threading.Event()

        self.__make_bars()
        self.__make_main_section()
        self.__set_properties()
        self.__do_layout()
        self.__set_events()

        self.__on_port_settings(None)  # call setup dialog on startup, opens port
        if not self.alive.isSet():
            self.Close()

    def __make_bars(self):
        self.file = wx.Menu()
        self.help = wx.Menu()

        self.itemPortSettings = self.file.Append(wx.ID_ANY, "&Port Settings\tCtrl+Alt+S",
                                                 " Configuration of serial port")
        self.file.AppendSeparator()
        self.itemRun = self.file.Append(wx.ID_ANY, "&Run\tCtrl+Shift+F5", " Execute all the instructions")
        self.itemClock = self.file.Append(wx.ID_ANY, "&Clock\tCtrl+F5", " Execute the next instruction")
        self.itemUpdateFields = self.file.Append(wx.ID_ANY, "&Update Fields\tF5", " Update the fields values")
        self.file.AppendSeparator()
        self.itemExit = self.file.Append(wx.ID_EXIT, "&Exit\tCtrl+Q", " Close the program")
        self.itemHelp = self.help.Append(wx.ID_HELP_CONTENTS, "&Help\tF1", " Show help contents")
        self.itemAbout = self.help.Append(wx.ID_ABOUT, "&About\tCtrl+A", " Show information about MIcomPS")

        self.main_frame_menubar = wx.MenuBar()
        self.main_frame_menubar.Append(self.file, "&File")
        self.main_frame_menubar.Append(self.help, "&Help")
        self.SetMenuBar(self.main_frame_menubar)

        self.main_frame_toolbar = wx.ToolBar(self, wx.ID_ANY, style=wx.TB_HORIZONTAL | TB_FLAT)
        self.button_port_settings = wx.Button(self.main_frame_toolbar, wx.ID_ANY, "PORT SETTINGS", pos=(-1, -1),
                                              size=(100, -1))
        self.button_clock = wx.Button(self.main_frame_toolbar, wx.ID_ANY, "CLOCK", pos=(-1, -1), size=(-1, -1))
        self.button_run = wx.Button(self.main_frame_toolbar, wx.ID_ANY, "RUN", pos=(-1, -1), size=(-1, -1))
        self.button_update_fields = wx.Button(self.main_frame_toolbar, wx.ID_ANY, "UPDATE FIELDS", pos=(-1, -1),
                                              size=(100, -1))
        self.main_frame_toolbar.AddControl(self.button_port_settings)
        self.main_frame_toolbar.AddSeparator()
        self.main_frame_toolbar.AddControl(self.button_clock)
        self.main_frame_toolbar.AddControl(self.button_run)
        self.main_frame_toolbar.AddSeparator()
        self.main_frame_toolbar.AddControl(self.button_update_fields)
        self.main_frame_toolbar.Realize()
        self.SetToolBar(self.main_frame_toolbar)

        self.main_frame_statusbar = self.CreateStatusBar(1)

    def __make_main_section(self):
        self.main_notebook = wx.Notebook(self, wx.ID_ANY)

        self.panel_registers_bank = wx.Panel(self.main_notebook, wx.ID_ANY)
        self.panel_step1 = wx.Panel(self.main_notebook, wx.ID_ANY)
        self.panel_step2 = wx.Panel(self.main_notebook, wx.ID_ANY)
        self.panel_step3 = wx.Panel(self.main_notebook, wx.ID_ANY)
        self.panel_step4 = wx.Panel(self.main_notebook, wx.ID_ANY)
        self.panel_step5 = wx.Panel(self.main_notebook, wx.ID_ANY)
        self.panel_pipeline = wx.Panel(self.main_notebook, wx.ID_ANY)

        self.panel_left_step1 = wx.Panel(self.panel_step1, wx.ID_ANY)
        self.panel_right_step1 = wx.Panel(self.panel_step1, wx.ID_ANY)
        self.panel_left_step2 = wx.Panel(self.panel_step2, wx.ID_ANY)
        self.panel_right_step2 = wx.Panel(self.panel_step2, wx.ID_ANY)
        self.panel_left_step3 = wx.Panel(self.panel_step3, wx.ID_ANY)
        self.panel_right_step3 = wx.Panel(self.panel_step3, wx.ID_ANY)
        self.panel_left_step4 = wx.Panel(self.panel_step4, wx.ID_ANY)
        self.panel_right_step4 = wx.Panel(self.panel_step4, wx.ID_ANY)
        self.panel_left_step5 = wx.Panel(self.panel_step5, wx.ID_ANY)
        self.panel_right_step5 = wx.Panel(self.panel_step5, wx.ID_ANY)

        self.__make_titles()
        self.__make_lists()

    def __make_titles(self):
        self.label_title_registers_bank = wx.StaticText(self.panel_registers_bank, wx.ID_ANY,
                                                        "REGISTERS BANK LIVE STATUS", style=wx.ALIGN_CENTER)
        self.label_title_left_step1 = wx.StaticText(self.panel_left_step1, wx.ID_ANY, "INPUTS",
                                                    style=wx.ALIGN_CENTER)
        self.label_title_right_step1 = wx.StaticText(self.panel_right_step1, wx.ID_ANY, "OUTPUTS",
                                                     style=wx.ALIGN_CENTER)
        self.label_title_left_step2 = wx.StaticText(self.panel_left_step2, wx.ID_ANY, "INPUTS",
                                                    style=wx.ALIGN_CENTER)
        self.label_title_right_step2 = wx.StaticText(self.panel_right_step2, wx.ID_ANY, "OUTPUTS",
                                                     style=wx.ALIGN_CENTER)
        self.label_title_left_step3 = wx.StaticText(self.panel_left_step3, wx.ID_ANY, "INPUTS",
                                                    style=wx.ALIGN_CENTER)
        self.label_title_right_step3 = wx.StaticText(self.panel_right_step3, wx.ID_ANY, "OUTPUTS",
                                                     style=wx.ALIGN_CENTER)
        self.label_title_left_step4 = wx.StaticText(self.panel_left_step4, wx.ID_ANY, "INPUTS",
                                                    style=wx.ALIGN_CENTER)
        self.label_title_right_step4 = wx.StaticText(self.panel_right_step4, wx.ID_ANY, "OUTPUTS",
                                                     style=wx.ALIGN_CENTER)
        self.label_title_left_step5 = wx.StaticText(self.panel_left_step5, wx.ID_ANY, "INPUTS",
                                                    style=wx.ALIGN_CENTER)
        self.label_title_right_step5 = wx.StaticText(self.panel_right_step5, wx.ID_ANY, "OUTPUTS",
                                                     style=wx.ALIGN_CENTER)
        self.label_title_pipeline = wx.StaticText(self.panel_pipeline, wx.ID_ANY, "PIPELINE LIVE STATUS",
                                                  style=wx.ALIGN_CENTER)

    def __make_lists(self):
        self.list_registers = AutoWidthListCtrl(self.panel_registers_bank)
        self.list_registers.InsertColumn(wx.ID_ANY, 'Nro.', width=-1)
        self.list_registers.InsertColumn(wx.ID_ANY, 'Value', width=-1)

        self.list_inputs_step1 = AutoWidthListCtrl(self.panel_left_step1)
        self.list_inputs_step1.InsertColumn(wx.ID_ANY, 'Name', width=-1)
        self.list_inputs_step1.InsertColumn(wx.ID_ANY, 'Value', width=-1)
        self.list_outputs_step1 = AutoWidthListCtrl(self.panel_right_step1)
        self.list_outputs_step1.InsertColumn(wx.ID_ANY, 'Name', width=-1)
        self.list_outputs_step1.InsertColumn(wx.ID_ANY, 'Value', width=-1)

        self.list_inputs_step2 = AutoWidthListCtrl(self.panel_left_step2)
        self.list_inputs_step2.InsertColumn(wx.ID_ANY, 'Name', width=-1)
        self.list_inputs_step2.InsertColumn(wx.ID_ANY, 'Value', width=-1)
        self.list_outputs_step2 = AutoWidthListCtrl(self.panel_right_step2)
        self.list_outputs_step2.InsertColumn(wx.ID_ANY, 'Name', width=-1)
        self.list_outputs_step2.InsertColumn(wx.ID_ANY, 'Value', width=-1)

        self.list_inputs_step3 = AutoWidthListCtrl(self.panel_left_step3)
        self.list_inputs_step3.InsertColumn(wx.ID_ANY, 'Name', width=-1)
        self.list_inputs_step3.InsertColumn(wx.ID_ANY, 'Value', width=-1)
        self.list_outputs_step3 = AutoWidthListCtrl(self.panel_right_step3)
        self.list_outputs_step3.InsertColumn(wx.ID_ANY, 'Name', width=-1)
        self.list_outputs_step3.InsertColumn(wx.ID_ANY, 'Value', width=-1)

        self.list_inputs_step4 = AutoWidthListCtrl(self.panel_left_step4)
        self.list_inputs_step4.InsertColumn(wx.ID_ANY, 'Name', width=-1)
        self.list_inputs_step4.InsertColumn(wx.ID_ANY, 'Value', width=-1)
        self.list_outputs_step4 = AutoWidthListCtrl(self.panel_right_step4)
        self.list_outputs_step4.InsertColumn(wx.ID_ANY, 'Name', width=-1)
        self.list_outputs_step4.InsertColumn(wx.ID_ANY, 'Value', width=-1)

        self.list_inputs_step5 = AutoWidthListCtrl(self.panel_left_step5)
        self.list_inputs_step5.InsertColumn(wx.ID_ANY, 'Name', width=-1)
        self.list_inputs_step5.InsertColumn(wx.ID_ANY, 'Value', width=-1)
        self.list_outputs_step5 = AutoWidthListCtrl(self.panel_right_step5)
        self.list_outputs_step5.InsertColumn(wx.ID_ANY, 'Name', width=-1)
        self.list_outputs_step5.InsertColumn(wx.ID_ANY, 'Value', width=-1)

        self.list_pipeline = AutoWidthListCtrl(self.panel_pipeline)
        self.list_pipeline.InsertColumn(wx.ID_ANY, 'Nro.', width=-1)
        self.list_pipeline.InsertColumn(wx.ID_ANY, 'Assembly Codes', width=-1)
        self.list_pipeline.InsertColumn(wx.ID_ANY, 'Step', width=-1)
        self.list_pipeline.InsertColumn(wx.ID_ANY, 'Step', width=-1)
        self.list_pipeline.InsertColumn(wx.ID_ANY, 'Step', width=-1)
        self.list_pipeline.InsertColumn(wx.ID_ANY, 'Step', width=-1)
        self.list_pipeline.InsertColumn(wx.ID_ANY, 'Step', width=-1)

        self.lists = [self.list_registers, self.list_inputs_step1, self.list_outputs_step1,
                      self.list_inputs_step2, self.list_outputs_step2, self.list_inputs_step3,
                      self.list_outputs_step3, self.list_inputs_step4, self.list_outputs_step4,
                      self.list_inputs_step5, self.list_outputs_step5, self.list_pipeline]

    def __set_properties(self):
        self.SetTitle("MIcomPS")
        self.SetSize((700, 500))
        self.main_frame_statusbar.SetStatusWidths([-1])
        self.main_frame_statusbar.SetStatusText("Disconnected", 0)

    def __do_layout(self):
        sizer_registers_bank = wx.BoxSizer(wx.VERTICAL)
        sizer_step1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_left_step1 = wx.BoxSizer(wx.VERTICAL)
        sizer_right_step1 = wx.BoxSizer(wx.VERTICAL)
        sizer_step2 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_left_step2 = wx.BoxSizer(wx.VERTICAL)
        sizer_right_step2 = wx.BoxSizer(wx.VERTICAL)
        sizer_step3 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_left_step3 = wx.BoxSizer(wx.VERTICAL)
        sizer_right_step3 = wx.BoxSizer(wx.VERTICAL)
        sizer_step4 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_left_step4 = wx.BoxSizer(wx.VERTICAL)
        sizer_right_step4 = wx.BoxSizer(wx.VERTICAL)
        sizer_step5 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_left_step5 = wx.BoxSizer(wx.VERTICAL)
        sizer_right_step5 = wx.BoxSizer(wx.VERTICAL)
        sizer_pipeline = wx.BoxSizer(wx.VERTICAL)

        sizer_registers_bank.Add(self.label_title_registers_bank, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_registers_bank.Add(self.list_registers, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_registers_bank.SetSizer(sizer_registers_bank)

        sizer_left_step1.Add(self.label_title_left_step1, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_left_step1.Add(self.list_inputs_step1, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_left_step1.SetSizer(sizer_left_step1)
        sizer_step1.Add(self.panel_left_step1, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        sizer_right_step1.Add(self.label_title_right_step1, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_right_step1.Add(self.list_outputs_step1, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_right_step1.SetSizer(sizer_right_step1)
        sizer_step1.Add(self.panel_right_step1, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        self.panel_step1.SetSizer(sizer_step1)

        sizer_left_step2.Add(self.label_title_left_step2, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_left_step2.Add(self.list_inputs_step2, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_left_step2.SetSizer(sizer_left_step2)
        sizer_step2.Add(self.panel_left_step2, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        sizer_right_step2.Add(self.label_title_right_step2, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_right_step2.Add(self.list_outputs_step2, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_right_step2.SetSizer(sizer_right_step2)
        sizer_step2.Add(self.panel_right_step2, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        self.panel_step2.SetSizer(sizer_step2)

        sizer_left_step3.Add(self.label_title_left_step3, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_left_step3.Add(self.list_inputs_step3, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_left_step3.SetSizer(sizer_left_step3)
        sizer_step3.Add(self.panel_left_step3, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        sizer_right_step3.Add(self.label_title_right_step3, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_right_step3.Add(self.list_outputs_step3, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_right_step3.SetSizer(sizer_right_step3)
        sizer_step3.Add(self.panel_right_step3, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        self.panel_step3.SetSizer(sizer_step3)

        sizer_left_step4.Add(self.label_title_left_step4, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_left_step4.Add(self.list_inputs_step4, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_left_step4.SetSizer(sizer_left_step4)
        sizer_step4.Add(self.panel_left_step4, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        sizer_right_step4.Add(self.label_title_right_step4, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_right_step4.Add(self.list_outputs_step4, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_right_step4.SetSizer(sizer_right_step4)
        sizer_step4.Add(self.panel_right_step4, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        self.panel_step4.SetSizer(sizer_step4)

        sizer_left_step5.Add(self.label_title_left_step5, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_left_step5.Add(self.list_inputs_step5, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_left_step5.SetSizer(sizer_left_step5)
        sizer_step5.Add(self.panel_left_step5, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        sizer_right_step5.Add(self.label_title_right_step5, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_right_step5.Add(self.list_outputs_step5, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_right_step5.SetSizer(sizer_right_step5)
        sizer_step5.Add(self.panel_right_step5, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        self.panel_step5.SetSizer(sizer_step5)

        sizer_pipeline.Add(self.label_title_pipeline, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_pipeline.Add(self.list_pipeline, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_pipeline.SetSizer(sizer_pipeline)

        self.main_notebook.AddPage(self.panel_registers_bank, "Registers Bank")
        self.main_notebook.AddPage(self.panel_step1, "Step 1 - IF")
        self.main_notebook.AddPage(self.panel_step2, "Step 2 - ID")
        self.main_notebook.AddPage(self.panel_step3, "Step 3 - EX")
        self.main_notebook.AddPage(self.panel_step4, "Step 4 - MEM")
        self.main_notebook.AddPage(self.panel_step5, "Step 5 - WB")
        self.main_notebook.AddPage(self.panel_pipeline, "Pipeline")

        main_sizer = wx.BoxSizer(wx.VERTICAL)
        main_sizer.Add(self.main_notebook, 1, wx.ALL | wx.CENTER | wx.EXPAND, 5)

        self.SetSizer(main_sizer)
        self.Layout()

    def __set_events(self):
        self.Bind(wx.EVT_MENU, self.__on_port_settings, self.itemPortSettings)
        self.Bind(wx.EVT_MENU, self.__on_run, self.itemRun)
        self.Bind(wx.EVT_MENU, self.__on_clock, self.itemClock)
        self.Bind(wx.EVT_MENU, self.__on_update_fields, self.itemUpdateFields)
        self.Bind(wx.EVT_MENU, self.__on_exit, self.itemExit)
        self.Bind(wx.EVT_MENU, self.__on_help, self.itemHelp)
        self.Bind(wx.EVT_MENU, self.__on_about, self.itemAbout)
        self.Bind(wx.EVT_BUTTON, self.__on_port_settings, self.button_port_settings)
        self.Bind(wx.EVT_BUTTON, self.__on_clock, self.button_clock)
        self.Bind(wx.EVT_BUTTON, self.__on_run, self.button_run)
        self.Bind(wx.EVT_BUTTON, self.__on_update_fields, self.button_update_fields)
        self.Bind(EVT_SERIALRX, self.__on_serial_read)

    def __start_thread(self):
        """Start the receiver thread"""
        self.thread = threading.Thread(target=self.__com_port_thread)
        self.thread.setDaemon(1)
        self.alive.set()
        self.thread.start()
        self.serial.rts = True
        self.serial.dtr = True

    def __stop_thread(self):
        """Stop the receiver thread, wait until it's finished."""
        if self.thread is not None:
            self.alive.clear()  # clear alive event for thread
            self.thread.join()  # wait until thread has finished
            self.thread = None

    def __add_data_recived(self, text):
        self.data_recived += text

    def __on_serial_read(self, event):
        """Handle input from the serial port."""
        self.__add_data_recived(event.data)  # str(event.data)

    def __com_port_thread(self):
        """\
        Thread that handles the incoming traffic. Does the basic input
        transformation (newlines) and generates an SerialRxEvent
        """
        while self.alive.isSet():
            b = self.serial.read(1)  # (self.serial.inWaiting() or 1)
            if b:
                if not os.path.exists(os.path.dirname("log/byte_recived_log")):
                    try:
                        os.makedirs(os.path.dirname("log/byte_recived_log"))
                    except OSError as exc:
                        if exc.errno != errno.EEXIST:
                            raise

                log = open("log/byte_recived_log", 'a+')
                log.write(binascii.b2a_hex(b) + "\n")
                log.close()
                event = SerialRxEvent(self.GetId(), binascii.b2a_hex(b))
                self.GetEventHandler().AddPendingEvent(event)

    def __hex2bin(self, str):
        bin = ["0000", "0001", "0010", "0011",
               "0100", "0101", "0110", "0111",
               "1000", "1001", "1010", "1011",
               "1100", "1101", "1110", "1111"]
        res = ""
        for i in range(len(str)):
            res += bin[string.atoi(str[i], base=16)]
        return res

    def __update_fields(self, data):

        if not os.path.exists(os.path.dirname("log/data_recived_log")):
            try:
                os.makedirs(os.path.dirname("log/data_recived_log"))
            except OSError as exc:
                if exc.errno != errno.EEXIST:
                    raise

        log = open("log/data_recived_log", 'a+')
        log.write(data + "\n")
        log.close()

        while data.__len__() < 456:
            time.sleep(0.1)

        data_bin = self.__hex2bin(str(data))
        self.__parse_data(data_bin)
        i = 0
        for lista in self.lists:
            if i < 11:
                if lista.GetItemCount() > 0:
                    lista.DeleteAllItems()

                lista_tuplas = []
                if i == 0: lista_tuplas = self.registers_tuples
                elif i == 1: lista_tuplas = self.step1_input_tuples
                elif i == 2: lista_tuplas = self.step1_output_tuples
                elif i == 3: lista_tuplas = self.step2_input_tuples
                elif i == 4: lista_tuplas = self.step2_output_tuples
                elif i == 5: lista_tuplas = self.step3_input_tuples
                elif i == 6: lista_tuplas = self.step3_output_tuples
                elif i == 7: lista_tuplas = self.step4_input_tuples
                elif i == 8: lista_tuplas = self.step4_output_tuples
                elif i == 9: lista_tuplas = self.step5_input_tuples
                elif i == 10: lista_tuplas = self.step5_output_tuples

                for tupla in lista_tuplas:
                    index = lista.InsertStringItem(sys.maxint, tupla[0])
                    lista.SetStringItem(index, 1, tupla[1])
                    lista.SetColumnWidth(0, wx.LIST_AUTOSIZE)
                    lista.SetColumnWidth(1, wx.LIST_AUTOSIZE)
            else:
                if lista.GetItemCount() > 0:
                    lista.DeleteAllItems()

                lista_tuplas = self.pipeline_tuples

                for tupla in lista_tuplas:
                    index = lista.InsertStringItem(sys.maxint, tupla[0])
                    lista.SetStringItem(index, 1, tupla[1])
                    lista.SetStringItem(index, 2, tupla[2])
                    lista.SetStringItem(index, 3, tupla[3])
                    lista.SetStringItem(index, 4, tupla[4])
                    lista.SetStringItem(index, 5, tupla[5])
                    lista.SetStringItem(index, 6, tupla[6])
                    lista.SetColumnWidth(0, 50)
                    lista.SetColumnWidth(1, wx.LIST_AUTOSIZE)
                    lista.SetColumnWidth(2, wx.LIST_AUTOSIZE)
                    lista.SetColumnWidth(3, wx.LIST_AUTOSIZE)
                    lista.SetColumnWidth(4, wx.LIST_AUTOSIZE)
                    lista.SetColumnWidth(5, wx.LIST_AUTOSIZE)
                    lista.SetColumnWidth(6, wx.LIST_AUTOSIZE)
            i += 1

        self.data_recived = ''

    def __parse_data(self, data):
        self.registers_tuples = []
        self.registers_tuples = [
            ("Reg 0", binary_to_dec.strbin_to_dec(str(data[0:32]))),
            ("Reg 1", binary_to_dec.strbin_to_dec(str(data[32:64]))),
            ("Reg 2", binary_to_dec.strbin_to_dec(str(data[64:96]))),
            ("Reg 3", binary_to_dec.strbin_to_dec(str(data[96:128]))),
            ("Reg 4", binary_to_dec.strbin_to_dec(str(data[128:160]))),
            ("Reg 5", binary_to_dec.strbin_to_dec(str(data[160:192]))),
            ("Reg 6", binary_to_dec.strbin_to_dec(str(data[192:224]))),
            ("Reg 7", binary_to_dec.strbin_to_dec(str(data[224:256]))),
            ("Reg 8", binary_to_dec.strbin_to_dec(str(data[256:288]))),
            ("Reg 9", binary_to_dec.strbin_to_dec(str(data[288:320]))),
            ("Reg 10", binary_to_dec.strbin_to_dec(str(data[320:352]))),
            ("Reg 11", binary_to_dec.strbin_to_dec(str(data[352:384]))),
            ("Reg 12", binary_to_dec.strbin_to_dec(str(data[384:416]))),
            ("Reg 13", binary_to_dec.strbin_to_dec(str(data[416:448]))),
            ("Reg 14", binary_to_dec.strbin_to_dec(str(data[448:480]))),
            ("Reg 15", binary_to_dec.strbin_to_dec(str(data[480:512]))),
            ("Reg 16", binary_to_dec.strbin_to_dec(str(data[512:544]))),
            ("Reg 17", binary_to_dec.strbin_to_dec(str(data[544:576]))),
            ("Reg 18", binary_to_dec.strbin_to_dec(str(data[576:608]))),
            ("Reg 19", binary_to_dec.strbin_to_dec(str(data[608:640]))),
            ("Reg 20", binary_to_dec.strbin_to_dec(str(data[640:672]))),
            ("Reg 21", binary_to_dec.strbin_to_dec(str(data[672:704]))),
            ("Reg 22", binary_to_dec.strbin_to_dec(str(data[704:736]))),
            ("Reg 23", binary_to_dec.strbin_to_dec(str(data[736:768]))),
            ("Reg 24", binary_to_dec.strbin_to_dec(str(data[768:800]))),
            ("Reg 25", binary_to_dec.strbin_to_dec(str(data[800:832]))),
            ("Reg 26", binary_to_dec.strbin_to_dec(str(data[832:864]))),
            ("Reg 27", binary_to_dec.strbin_to_dec(str(data[864:896]))),
            ("Reg 28", binary_to_dec.strbin_to_dec(str(data[896:928]))),
            ("Reg 29", binary_to_dec.strbin_to_dec(str(data[928:960]))),
            ("Reg 30", binary_to_dec.strbin_to_dec(str(data[960:992]))),
            ("Reg 31", binary_to_dec.strbin_to_dec(str(data[992:1024])))
        ]
        self.step1_input_tuples = []
        self.step1_input_tuples = [
            ("PC", binary_to_dec.strbin_to_udec(str(data[1024:1056])))
        ]
        self.step1_output_tuples = []
        self.step1_output_tuples = [
            ("Instruccion", str(data[1056:1088])),
            ("Instruccion", instruction_decode.get_instruction(str(data[1056:1088])))
        ]
        self.step2_input_tuples = []
        self.step2_input_tuples = [
            ("PC+4", binary_to_dec.strbin_to_udec(str(data[1088:1120]))),
            ("Instruccion", str(data[1120:1152])),
            ("Instruccion", instruction_decode.get_instruction(str(data[1120:1152]))),
            ("Write data", binary_to_dec.strbin_to_dec(str(data[1152:1184])))
        ]
        self.step2_output_tuples = []
        self.step2_output_tuples = [
            ("Reg data 1", binary_to_dec.strbin_to_dec(str(data[1224:1256]))),
            ("Reg data 2", binary_to_dec.strbin_to_dec(str(data[1256:1288]))),
            ("Sign extend (signed)", binary_to_dec.strbin_to_dec(str(data[1288:1320]))),
            ("Sign extend (unsigned)", binary_to_dec.strbin_to_dec(str(data[1288:1320]))),
            ("RS", binary_to_dec.strbin_to_udec(str(data[1320:1328])[3:])),
            ("RT", binary_to_dec.strbin_to_udec(str(data[1328:1336])[3:])),
            ("RD", binary_to_dec.strbin_to_udec(str(data[1336:1344])[3:])),
            ("PC jump", binary_to_dec.strbin_to_udec(str(data[1344:1376]))),
            ("PC branch", binary_to_dec.strbin_to_udec(str(data[1376:1408])))
        ]
        self.step3_input_tuples = []
        self.step3_input_tuples = [
            ("PC incrementado", binary_to_dec.strbin_to_udec(str(data[1408:1440]))),
            ("Reg data 1", binary_to_dec.strbin_to_dec(str(data[1440:1472]))),
            ("Reg data 2", binary_to_dec.strbin_to_dec(str(data[1472:1504]))),
            ("Sign extend (signed)", binary_to_dec.strbin_to_dec(str(data[1504:1536]))),
            ("Sign extend (unsigned)", binary_to_dec.strbin_to_udec(str(data[1504:1536]))),
            ("RT", binary_to_dec.strbin_to_udec(str(data[1536:1544])[3:])),
            ("RD", binary_to_dec.strbin_to_udec(str(data[1544:1552])[3:]))
        ]
        self.step3_output_tuples = []
        self.step3_output_tuples = [
            ("Zero signal", str(data[1552:1560])[7:]),
            ("ALU result (signed)", binary_to_dec.strbin_to_dec(str(data[1560:1592]))),
            ("ALU result (unsigned)", binary_to_dec.strbin_to_udec(str(data[1560:1592]))),
            ("ALU result (binary)", str(data[1560:1592])),
            ("Reg data 2", binary_to_dec.strbin_to_dec(str(data[1592:1624]))),
            ("RT o RD", binary_to_dec.strbin_to_udec(str(data[1624:1632])[3:]))
        ]
        self.step4_input_tuples = []
        self.step4_input_tuples = [
            ("ALU result", binary_to_dec.strbin_to_udec(str(data[1632:1664]))),
            ("Reg data 2", binary_to_dec.strbin_to_dec(str(data[1664:1696])))
        ]
        self.step4_output_tuples = []
        self.step4_output_tuples = [
            ("Read data (signed)", binary_to_dec.strbin_to_dec(str(data[1696:1728]))),
            ("Read data (unsigned)", binary_to_dec.strbin_to_udec(str(data[1696:1728]))),
            ("Read data (binary)", str(data[1696:1728]))
        ]
        self.step5_input_tuples = []
        self.step5_input_tuples = [
            ("Read memory data", binary_to_dec.strbin_to_dec(str(data[1728:1760]))),
            ("ALU result", binary_to_dec.strbin_to_dec(str(data[1760:1792])))
        ]
        self.step5_output_tuples = []
        self.step5_output_tuples = [
            ("Write data", binary_to_dec.strbin_to_dec(str(data[1792:]))),
            ("Write register addr", binary_to_dec.strbin_to_udec(str(data[1184:1192])[3:])),
            ("ALU result", binary_to_dec.strbin_to_dec(str(data[1192:1224])))
        ]
        self.pipeline_tuples = []
        self.instructions_list.append(str(data[1056:1088]))
        for i in range(0, self.instructions_list.__len__(), 1):
            if (self.instructions_list.__len__() - i) > 4:
                self.pipeline_tuples.append((str(i + 1),
                                             instruction_decode.get_instruction(self.instructions_list[i]),
                                             "IF", "ID", "EX", "MEM", "WB"))
            elif (self.instructions_list.__len__() - i) == 4:
                self.pipeline_tuples.append((str(i + 1),
                                             instruction_decode.get_instruction(self.instructions_list[i]),
                                             "---", "IF", "ID", "EX", "MEM"))
            elif (self.instructions_list.__len__() - i) == 3:
                self.pipeline_tuples.append((str(i + 1),
                                             instruction_decode.get_instruction(self.instructions_list[i]),
                                             "---", "---", "IF", "ID", "EX"))
            elif (self.instructions_list.__len__() - i) == 2:
                self.pipeline_tuples.append((str(i + 1),
                                             instruction_decode.get_instruction(self.instructions_list[i]),
                                             "---", "---", "---", "IF", "ID"))
            elif (self.instructions_list.__len__() - i) == 1:
                self.pipeline_tuples.append((str(i + 1),
                                             instruction_decode.get_instruction(self.instructions_list[i]),
                                             "---", "---", "---", "---", "IF"))

    def __on_port_settings(self, event):
        if event is not None:
            self.__stop_thread()
            self.serial.close()
            self.main_frame_statusbar.SetStatusText("Disconnected", 0)
        ok = False
        while not ok:
            with serial_config_dialog.SerialConfigDialog(self, -1, "",
                                                         show=serial_config_dialog.SHOW_BAUDRATE | serial_config_dialog.SHOW_FORMAT | serial_config_dialog.SHOW_FLOW,
                                                         serial=self.serial) as dialog_serial_cfg:
                dialog_serial_cfg.CenterOnParent()
                result = dialog_serial_cfg.ShowModal()

            if result == wx.ID_OK or event is not None:
                try:
                    self.serial.open()
                except serial.SerialException as e:
                    with wx.MessageDialog(self, str(e), "Serial Port Error", wx.OK | wx.ICON_ERROR) as dlg:
                        dlg.ShowModal()
                else:
                    self.__start_thread()
                    self.SetTitle(
                        "Serial Terminal on %s [%s,%s,%s,%s%s%s]" % (self.serial.portstr, self.serial.baudrate,
                                                                     self.serial.bytesize, self.serial.parity,
                                                                     self.serial.stopbits,
                                                                     ' RTS/CTS' if self.serial.rtscts else '',
                                                                     ' Xon/Xoff' if self.serial.xonxoff else '',))
                    self.main_frame_statusbar.SetStatusText("Connected", 0)
                    ok = True
            else:
                # on startup, dialog aborted
                self.main_frame_statusbar.SetStatusText("Connected", 0)
                self.alive.clear()
                ok = True

    def __on_run(self, event):
        char = 1
        char = unichr(char)
        self.serial.write(char.encode('UTF-8', 'replace'))

    def __on_clock(self, event):
        char = 2
        char = unichr(char)
        self.serial.write(char.encode('UTF-8', 'replace'))

    def __on_update_fields(self, event):
        self.__update_fields(self.data_recived)

    def __on_exit(self, event):
        self.__stop_thread()
        self.serial.close()
        self.Destroy()

    def __on_help(self, event):
        message = """FUNCIONALIDADES

- CLOCK: Indicar a la placa que ejecute la siguiente instruccion del programa.
- RUN: Indicar a la placa que ejecute todas las instrucciones del programa.
- UPDATE FIELDS: Refrescar los datos desplegados por la interfaz a los valores actuales.


ATAJOS:

- Port settings: Ctrl+Alt+S
- Run: Ctrl+Shift+F5
- Clock: Ctrl+F5
- Update fields: F5
- Exit: Ctrl+Q
- Help: F1
- About: Ctrl+A"""
        dlg = wx.MessageDialog(self, message, "Ayuda", wx.OK)
        dlg.ShowModal()
        dlg.Destroy()

    def __on_about(self, event):
        message = """Simulador de microprocesador MIPS.
        Autores:
                Andres Serjoy - poche002@gmail.com
                Aurelio Remonda - aurelioremonda@gmail.com
                Diego Provinciani - diegoprovinciani@gmail.com"""
        dlg = wx.MessageDialog(self, message, "Acerca de MIcomPS", wx.OK)
        dlg.ShowModal()
        dlg.Destroy()


class Micomps_UI(wx.App):
    def __init__(self):
        wx.App.__init__(self)
        self.main_frame = MicompsFrame(None, wx.ID_ANY, "")
        self.SetTopWindow(self.main_frame)
        self.main_frame.Show()
