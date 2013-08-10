import os
import sys

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print ("Error! No FPGA specified. Valid architectures are v6 and v7")   
    else:
        if sys.argv[1] == "v7":
           os.system("xtclsh V7_Pci_Axi_Switch.tcl rebuild_project")
           os.system("cp top.bit v7_top.bit")
        elif sys.argv[1] == "v6":
           os.system("xtclsh V6_Pci_Axi_Switch.tcl rebuild_project")
           os.system("cp top.bit v6_top.bit")
        else:
           print("Illegal FPGA specified")