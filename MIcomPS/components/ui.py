#!/usr/bin/python
# -*- coding: utf-8 -*-

import wx
import serial
from wx.lib.mixins.listctrl import ListCtrlAutoWidthMixin
from wx._controls_ import TB_HORIZONTAL, TB_HORZ_TEXT, TB_FLAT


class AutoWidthListCtrl(wx.ListCtrl, ListCtrlAutoWidthMixin):
    def __init__(self, parent):
        wx.ListCtrl.__init__(self, parent, -1, style=wx.LC_REPORT)
        ListCtrlAutoWidthMixin.__init__(self)


class MicompsFrame(wx.Frame):
    def __init__(self, control, *args, **kwds):
        wx.Frame.__init__(self, *args, **kwds)

        self.port = ""
        self.lists = []
        self.observer = control

        self.__make_bars()
        self.__make_main_section()
        self.__set_properties()
        self.__do_layout()
        self.__set_events()

    def __make_bars(self):
        self.file = wx.Menu()
        self.help = wx.Menu()

        self.itemRun = self.file.Append(wx.ID_ANY, "&Run\tCtrl+Shift+F5", " Ejecutar todo el programa")
        self.itemClock = self.file.Append(wx.ID_ANY, "&Clock\tCtrl+F5", " Ejecutar siguiente instruccion")
        self.file.AppendSeparator()
        self.itemExit = self.file.Append(wx.ID_EXIT, "&Salir\tCtrl+Q", " Cerrar el programa")
        self.itemHelp = self.help.Append(wx.ID_HELP_CONTENTS, "&Ayuda\tF1", " Abrir la ayuda del programa")
        self.itemAbout = self.help.Append(wx.ID_ABOUT, "&Acerca de", " Informacion acerca del programa")

        self.main_frame_menubar = wx.MenuBar()
        self.main_frame_menubar.Append(self.file, "&File")
        self.main_frame_menubar.Append(self.help, "&Help")
        self.SetMenuBar(self.main_frame_menubar)

        self.main_frame_toolbar = wx.ToolBar(self, wx.ID_ANY, style=wx.TB_HORIZONTAL | TB_FLAT)
        self.combo_ports = wx.ComboBox(self.main_frame_toolbar, wx.ID_ANY, "Port", pos=(-1, -1), size=(-1, -1),
                                       choices=self.observer.scan_ports(), style=wx.CB_DROPDOWN)
        self.button_connect = wx.Button(self.main_frame_toolbar, wx.ID_ANY, "CONNECT", pos=(-1, -1), size=(-1, -1))
        self.button_clock = wx.Button(self.main_frame_toolbar, wx.ID_ANY, "CLOCK", pos=(-1, -1), size=(-1, -1))
        self.button_run = wx.Button(self.main_frame_toolbar, wx.ID_ANY, "RUN", pos=(-1, -1), size=(-1, -1))
        self.main_frame_toolbar.AddControl(self.combo_ports)
        self.main_frame_toolbar.AddControl(self.button_connect)
        self.main_frame_toolbar.AddSeparator()
        self.main_frame_toolbar.AddControl(self.button_clock)
        self.main_frame_toolbar.AddControl(self.button_run)
        self.main_frame_toolbar.Realize()
        self.SetToolBar(self.main_frame_toolbar)

        self.main_frame_statusbar = self.CreateStatusBar(1)

    def __make_main_section(self):
        self.main_notebook = wx.Notebook(self, wx.ID_ANY)

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
        self.observer.set_lists(self.lists)

    def __make_titles(self):
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

        self.lists = [self.list_inputs_step1, self.list_outputs_step1, self.list_inputs_step2,
                      self.list_outputs_step2, self.list_inputs_step3, self.list_outputs_step3,
                      self.list_inputs_step4, self.list_outputs_step4, self.list_inputs_step5,
                      self.list_outputs_step5, self.list_pipeline]

    def __set_properties(self):
        self.SetTitle("MIcomPS")
        self.SetSize((700, 500))
        self.main_frame_statusbar.SetStatusWidths([-1])
        self.main_frame_statusbar.SetStatusText("MIcomPS - Disconnected", 0)

    def __do_layout(self):
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
        self.Bind(wx.EVT_MENU, self.__on_run, self.itemRun)
        self.Bind(wx.EVT_MENU, self.__on_clock, self.itemClock)
        self.Bind(wx.EVT_MENU, self.__on_exit, self.itemExit)
        self.Bind(wx.EVT_MENU, self.__on_help, self.itemHelp)
        self.Bind(wx.EVT_MENU, self.__on_about, self.itemAbout)
        self.Bind(wx.EVT_COMBOBOX, self.__on_combo, self.combo_ports)
        self.Bind(wx.EVT_BUTTON, self.__on_connect, self.button_connect)
        self.Bind(wx.EVT_BUTTON, self.__on_clock, self.button_clock)
        self.Bind(wx.EVT_BUTTON, self.__on_run, self.button_run)

    def __on_run(self, event):
        self.observer.send_event("run")

    def __on_clock(self, event):
        self.observer.send_event("clock")

    def __on_exit(self, event):
        self.Close(True)

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

    def __on_combo(self, event):
        self.port = event.GetString()

    def __on_connect(self, event):
        if self.port == "":
            self.main_frame_statusbar.SetStatusText = "ERROR: Choose a port."
        else:
            res = self.observer.connect_to_serial_port(self.port)
            if res == "ERROR":
                self.main_frame_statusbar.SetStatusText = "ERROR: Connection failed."
            else:
                self.main_frame_statusbar.SetStatusText = "ERROR: Connected."


class Micomps_UI(wx.App):
    def __init__(self, control):
        wx.App.__init__(self)
        self.main_frame = MicompsFrame(control, None, wx.ID_ANY, "")
        self.SetTopWindow(self.main_frame)
        self.main_frame.Show()
