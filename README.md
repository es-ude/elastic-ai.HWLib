# elastic-ai.HWLib
This repository contains hardware components with HDL language that we continually developed over the past years for energy-efficient AI on embedded FPGAs.
## What do we provide?
- [x] lstm_cell component with VHDL
	- [x] Test bench for the lstm_cell
- [x] 1d convolution layer component with VHDL
	- [x] Test bench for the convolution layer
- [x] 1d linear layer component with VHDL
  - [x] Test bench for the linear layer
- [ ] FIR filter component with VHDL
  - [ ] Test bench for the FIR filter

--- 
## File structure
The file structure of this project looks like, below:
```bash
.
├── conv_1d_layer
│   ├── conv_1d_layer.md
│   ├── makefile
│   ├── source
│   │   ├── cnn_common.vhd
│   │   └── linear_layer.vhd
│   └── testbench
│       └── conv_1d_tb.vhd
├── FIR filter
├── linear_layer
├── lstm-cell
└── README.md
```

Each sub folder contains 1 hardware components with its implementation and testbench and document. In each sub folder, 
    - the `makefile` is more about an example of how I test my VHDL components with **make**.
    - `source` folder contains HDL components, and should be the components will be compiled (synthesis) and tested later.
    - `testbench` includes all testbenches that are necessary for developing the HDL components. 


---

## Dependency
To launch a quick test of the hardware components, you need to install these softwares:
- GHDL 1.0.0
```
    sudo apt install ghdl # install
    ghdl --version # check the version
```

- GTKWave
```
    sudo apt install gtkwave
```

- Setup the python environment, at the root directory, execute
```
    pip install poetry # if you don't have poetry installed
    poetry install     # install dependencies
    poetry shell       # activate the virtual environment in the terminal
```