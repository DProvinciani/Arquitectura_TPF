import ui
import controller

# This program needs to run pyserial and bitstring modules

if __name__ == "__main__":
    control = controller.Controller()
    view = ui.Micomps_UI(control)
    view.MainLoop()
