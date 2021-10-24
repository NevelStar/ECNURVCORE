<h1 align = "center">ECNURVCORE RISC-V CPU</h1>
> Design Team：tangyuchao oujiahua liyanzhong liuyuan jiachen

---

## 一、系统整体概述

### (1) 指令集架构

ECNURVCORE是由本团队设计的一个支持RV64I指令集的三级流水线顺序执行CPU。

### (2) 系统对外接口

- 系统具有一个时钟接口：CLK
- 一个高电平有效的复位接口：RESET
- 一个外部中断输入接口：IO_INTERRUPT
- 一组对外用于数据交互的AXI4 master总线，以及一组预留给DMA（暂未实现）的AXI总线接口
  由于对外只有1个master AXI4接口，处理器核内分为取指总线和访存总线两个接口，通过axi_interconnect模块进行仲裁成一个对外的master AXI接口。仲裁时，访存的优先级大于取指的优先级。

#### 以下是接口的详细表格：

| 对外接口  名称  |        |                   |                      |        |                  |
| --------------- | ------ | ----------------- | -------------------- | ------ | ---------------- |
| 时钟            |        |                   | 复位(高电平有效)     |        |                  |
| input           |        | clock             | input                |        | reset            |
| 外部中断        |        |                   |                      |        |                  |
| input           |        | io_interrupt      |                      |        |                  |
| AXI4 Master总线 |        |                   | AXI4 Slave总线(预留) |        |                  |
| input           |        | io_master_awready | output               |        | io_slave_awready |
| output          |        | io_master_awvalid | input                |        | io_slave_awvalid |
| output          | [31:0] | io_master_awaddr  | input                | [31:0] | io_slave_awaddr  |
| output          | [3:0]  | io_master_awid    | input                | [3:0]  | io_slave_awid    |
| output          | [7:0]  | io_master_awlen   | input                | [7:0]  | io_slave_awlen   |
| output          | [2:0]  | io_master_awsize  | input                | [2:0]  | io_slave_awsize  |
| output          | [1:0]  | io_master_awburst | input                | [1:0]  | io_slave_awburst |
| input           |        | io_master_wready  | output               |        | io_slave_wready  |
| output          |        | io_master_wvalid  | input                |        | io_slave_wvalid  |
| output          | [63:0] | io_master_wdata   | input                | [63:0] | io_slave_wdata   |
| output          | [7:0]  | io_master_wstrb   | input                | [7:0]  | io_slave_wstrb   |
| output          |        | io_master_wlast   | input                |        | io_slave_wlast   |
| output          |        | io_master_bready  | input                |        | io_slave_bready  |
| input           |        | io_master_bvalid  | output               |        | io_slave_bvalid  |
| input           | [1:0]  | io_master_bresp   | output               | [1:0]  | io_slave_bresp   |
| input           | [3:0]  | io_master_bid     | output               | [3:0]  | io_slave_bid     |
| input           |        | io_master_arready | output               |        | io_slave_arready |
| output          |        | io_master_arvalid | input                |        | io_slave_arvalid |
| output          | [31:0] | io_master_araddr  | input                | [31:0] | io_slave_araddr  |
| output          | [3:0]  | io_master_arid    | input                | [3:0]  | io_slave_arid    |
| output          | [7:0]  | io_master_arlen   | input                | [7:0]  | io_slave_arlen   |
| output          | [2:0]  | io_master_arsize  | input                | [2:0]  | io_slave_arsize  |
| output          | [1:0]  | io_master_arburst | input                | [1:0]  | io_slave_arburst |
| output          |        | io_master_rready  | input                |        | io_slave_rready  |
| input           |        | io_master_rvalid  | output               |        | io_slave_rvalid  |
| input           | [1:0]  | io_master_rresp   | output               | [1:0]  | io_slave_rresp   |
| input           | [63:0] | io_master_rdata   | output               | [63:0] | io_slave_rdata   |
| input           |        | io_master_rlast   | output               |        | io_slave_rlast   |
| input           | [3:0]  | io_master_rid     | output               | [3:0]  | io_slave_rid     |

### （3）总线地址分配

| **设备**    | **地址空间**      |
| ----------------- | ----------------------- |
| reserve           | 0x0000_0000~0x01ff_ffff |
| CLINT             | 0x0200_0000~0x0200_ffff |
| reserve           | 0x0201_0000~0x0fff_ffff |
| UART16550         | 0x1000_0000~0x1000_0fff |
| SPI控制器         | 0x1000_1000~0x1000_1fff |
| reserve           | 0x1000_2000~0x2fff_ffff |
| SPI-flash XIP模式 | 0x3000_0000~0x3fff_ffff |
| ChipLink MMIO     | 0x4000_0000~0x7fff_ffff |
| memory            | 0x8000_0000~0xffff_ffff |

---

## 二、核内设计

### （一）核内数据流图

![图片1](系统整体概述.png)

### （二）流水线层次

本CPU主要由3级流水线构成，在传统的5级riscv流水线上，合并了取指、访存、写回，实现了取指**->**译码**->**（执行/访存/写回）的一套三级流水线结构

#### 1.取指

本设计的取指过程通过axi总线接口完成，在核内，我们配置了一组组合逻辑来对输入、输出的取指信号进行预处理。

其中，取指的使能信号取决于流水线暂停使能，而在核内的取指单元中，会对pc进行预先的检查：

当pc超出范围或未对齐时，该模块会报告异常，并给出对应的异常原因。

另一方面，考虑到分支预测错误与总线仲裁失利等的影响，当处理器核从总线接口获得指令及其地址时，核内控制单元会向该模块发送指令冲刷使能信号，将被误读的指令用空指令掩盖。

#### 2．解码

本设计的解码模块由一部分组合逻辑与一组流水线寄存器组成，组合逻辑对获取的指令进行解码，而流水线寄存器的输出为执行模块部署输入，如操作数、操作码、访存类型等。

解码器首先对指令进行拆分，将对应段的指令取出，并根据要读取的数据地址，在通用寄存器堆从对应地址处获取执行所需的数据，并根据操作码、功能码来进行数据选择，为ALU分配操作数、操作码。在处理跳转指令时，考虑到要尽可能地减少跳转与指令冲刷带来的时序损失，会把跳转指令的相关信息在解码后直接通过组合逻辑送入控制模块处理。

#### 3．执行

本设计的执行模块由一部分组合逻辑与一组流水线寄存器组成，其中，计算结果和访存指令同时进行处理。其中，执行的组合逻辑部分由一组数据选择器构成，可以根据解码器给出的操作码对各种运算指令的结果进行选择。

#### 4．访存

本设计的访存过程与执行过程同时进行，且均位于执行模块内。在解码阶段，系统通过读取指令获得对应的访存指令类型，用load code/store code的形式传至执行模块的访存部分，生成对应的地址、数据与使能信号，交由AXI接口转为符合AXI4协议的输出，通过AXI总线访问内存。

#### 5．回写

回写指的是cpu运算过程中产生的结果，写回寄存器的过程。

### （三）流水线控制逻辑

#### 1.流水线指令生成

本设计中的程序计数器由一个多路选择器和一个寄存器构成，当流水线暂停或总线正忙而无法进行取指时，pc会保持不变；当发生跳转时，跳转使能信号拉高，并将pc直接置为目的地址，进而完成跳转。

#### 2.流水线的暂停

#### 导致流水线暂停的来源可能有如下几种原因：

##### [1] 跳转机制

##### [2] 访存等待

##### [3] 控制冲突

##### [4] 异常与中断

#### 3.流水线的冲刷

### （四）分支预测逻辑

### （五）LSU单元设计

---

## 二、AXI系统总线设计

### （一）Core-AXI接口转换

#### 1．取指接口

#### 2．访存接口

### （二）AXI互联

#### 1．读写机制

#### 2．总线仲裁

## 三、异常与中断处理

## 四、程序编译与仿真环境介绍

## 五、性能测试与成果展示
