# 1D convolution layer implementation
1. file structure:
```
.
├── conv_1d_layer.md
├── makefile
├── source
│   ├── cnn_common.vhd
│   └── conv_1d.vhd
└── testbench
    └── conv_1d_tb.vhd
```
2. This convolution layer uses fixed point data. And it merges the max pooling layer in it to improve the performance.
3. Weighs and biases are stored outside this component, which means the AI developer would need to implementation a memory block by him self and connect it to the interface of this component.
4. This component is designed to be scalable, the AI developer can adjust the parameters in the `generic` map as she wishes.

## Example
An example of how to use/test this component are represented as a testbench in the testbench folder. To run the simulation, you could run the command below:
``` Bash
make TESTBENCH=conv_1d
```
The output of the simulation should be like below:
```
testbench/conv_1d_tb.vhd:103:13:@195ns:(report note): The value of conn_out(0) is 896
testbench/conv_1d_tb.vhd:103:13:@355ns:(report note): The value of conn_out(1) is 896
testbench/conv_1d_tb.vhd:103:13:@515ns:(report note): The value of conn_out(2) is 896
testbench/conv_1d_tb.vhd:103:13:@675ns:(report note): The value of conn_out(3) is 896
testbench/conv_1d_tb.vhd:103:13:@835ns:(report note): The value of conn_out(4) is 896
testbench/conv_1d_tb.vhd:103:13:@995ns:(report note): The value of conn_out(5) is 896
testbench/conv_1d_tb.vhd:103:13:@1155ns:(report note): The value of conn_out(6) is 896
...
```
