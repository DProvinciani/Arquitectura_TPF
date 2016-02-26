#!/usr/bin/python
# -*- coding: utf-8 -*-
import wx
import sys
import serial
import threading
from wx._controls_ import TB_FLAT
from utils import instruction_decode
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

        self.data_recived = ""
        self.lists = []
        self.serial = serial.Serial()
        self.serial.timeout = 0.5
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
        self.itemAbout = self.help.Append(wx.ID_ABOUT, "&About", " Show information about MIcomPS")

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
        self.__add_data_recived(event.data.decode('UTF-8', 'replace'))

    def __com_port_thread(self):
        """\
        Thread that handles the incoming traffic. Does the basic input
        transformation (newlines) and generates an SerialRxEvent
        """
        while self.alive.isSet():
            b = self.serial.read(self.serial.inWaiting() or 1)
            if b:
                event = SerialRxEvent(self.GetId(), b)
                self.GetEventHandler().AddPendingEvent(event)

    def __update_fields(self, data):
        data1 = ("ArduinoDice:", str(data))
        data2 = ("10", instruction_decode.get_instruction("00000010000100011010000000100111"), "---", "---", "IF", "ID",
                 "EX")
        i = 0
        for lista in self.lists:
            if i != 11:
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

        self.data_recived = ""

    def __on_port_settings(self, event):
        if event is not None:
            self.__stop_thread()
            self.serial.close()
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
                    ok = True
            else:
                # on startup, dialog aborted
                self.alive.clear()
                ok = True

    def __on_run(self, event):
        char = 2
        char = unichr(char)
        self.serial.write(char.encode('UTF-8', 'replace'))

    def __on_clock(self, event):
        char = 4
        char = unichr(char)
        self.serial.write(char.encode('UTF-8', 'replace'))

    def __on_update_fields(self, event):
        self.__update_fields(self.data_recived)

    def __on_exit(self, event):
        self.__stop_thread()
        self.serial.close()
        self.Destroy()

    def __on_help(self, event):
        message = "No implementado..."
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
