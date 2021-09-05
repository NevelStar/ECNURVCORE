`include "define.v"
module timer
#{
	parameter AXI_ADDRESS_WIDTH = 64, AXI_DATA_WIDTH = 64
}
(
    input wire clk,
    input wire rst,
	
	//write address channel
	input wire [AXI_ADDRESS_WIDTH-1:0] saxi_awaddr,
	input wire saxi_awvaild,
	output wire saxi_awready,
	
	//read address channel
	input wire [AXI_ADDRESS_WIDTH-1:0] saxi_araddr,
	input wire saxi_arvaild,
	output wire saxi_arready,
	
	//write data channel
	input wire saxi_wvaild,
	input wire saxi_wready,
	input wire [AXI_DATA_WIDTH-1:0] saxi_wdata,
	
	//read data channel
	output wire saxi_rvaild,
	input wire saxi_rready,
	output wire [AXI_DATA_WIDTH-1:0] saxi_rdata,
	
	//write response channel
	output wire saxi_bvaild,
	input wire saxi_bready,

    output wire[AXI_DATA_WIDTH:0] mtime_o,
	output wire[AXI_DATA_WIDTH:0] mtimecmp_o,

    output time_irq_o;
);

//#define CLINT                   (0x2000000L)
//#define CLINT_MTIMECMP(hartid)  (CLINT + 0x4000 + 4*(hartid))	//hartid = 0
//#define CLINT_MTIME             (CLINT + 0xBFF8)            	// cycles since boot.

// | ADDRESS    		|  NAME    | FUNCTION 							|
// | 0x0000000002004000 | MTIMECMP | TRIG IRG WHEN MTIME >= MTIMECMP	|
// | 0x000000000200BFF8 | MTIME    | TIME CONUNTER						|

`define CLINT_MTIMECMP 64'h0000000002004000
`define CLINT_MTIME    64'h000000000200BFF8

reg [AXI_DATA_WIDTH-1:0] mtime;
reg [AXI_DATA_WIDTH-1:0] mtimecmp;

assign mtime_o = mtime;
assign mtimecmp_o = mtimecmp;

//AXI write address channel
always @(posedge clk)
begin
	if (rst == `RstEnable)
	begin
		saxi_awready <= 1'b0;
	end
	else begin
		if (saxi_awvaild) begin
			saxi_awready <= 1'b1;
		end
		else begin
			saxi_awready <= 1'b0;
		end
	end
end

reg [AXI_ADDRESS_WIDTH-1:0] axi_awaddr_buf; //Reg for address need to be wirtten


always @(posedge clk)
begin
	if (rst == `RstEnable)
	begin
		axi_awaddr_buf <= 1'b0;
	end
	else begin
		if (saxi_awvaild && saxi_awready) begin
			axi_awaddr_buf <= saxi_awaddr;
		end
	end
end

reg [AXI_ADDRESS_WIDTH-1:0] axi_waddr; // the address need to be wirtten

always@(*)
begin
	if (saxi_wvaild && saxi_wready && saxi_awvaild && saxi_awready) begin 
		awi_waddr = saxi_awaddr;  		//the address is now available on the interface
	end 
	else begin
		awi_waddr = axi_awaddr_buf;		//the address is assigned in previous command
	end
end

//AXI write data channel
always @(posedge clk)
begin
	if (rst == `RstEnable)
	begin
		saxi_wready <= 1'b0;
	end
	else begin
		if (saxi_wvaild) begin
			saxi_wready <= 1'b1;
		end
		else begin
			saxi_wready <= 1'b0;
		end 
	end
end

//Response request
reg axi_need_resp; //a write operation, need response

always @(posedge clk)
begin
	if (rst == `RstEnable)
	begin
		axi_need_resp <= 1'b0;
	end
	else begin
		if (saxi_wvaild && saxi_wready) begin
			axi_need_resp <= 1'b1;
		end
		else begin
			axi_need_resp <= 1'b0;
		end 
	end
end

//AXI write response section
always @(posedge clk)
begin
	if (rst == `RstEnable)
	begin
		saxi_bvaild <= 1'b0;
	end
	else begin
		if (axi_need_resp) begin
			saxi_bvaild <= 1'b1;  //when need to response
		end
		if (saxi_bvaild && saxi_bready) begin
			saxi_bvaild <= 1'b0;  //when response was received
		end 
	end
end

//AXI read address section
always @(posedge clk)
begin
	if (rst == `RstEnable)
	begin
		saxi_arready <= 1'b0;
	end
	else begin
		if (saxi_arvaild) begin
			saxi_arready <= 1'b1;
		end
		else begin
			saxi_arready <= 1'b0;
		end
	end
end

reg [AXI_ADDRESS_WIDTH-1:0] axi_raddr; // the address need to be wirtten
reg axi_need_read; //A read operation, need 

always @(posedge clk)
begin
	if (rst == `RstEnable)
	begin
		axi_raddr <= (`AXI_ADDRESS_WIDTH)'b0;
		axi_need_read <= 1'b0;
	end
	else begin
		if (saxi_rvaild && saxi_rready) begin
			axi_raddr <= saxi_raddr;
			axi_need_read <= 1'b1;
		end
		else begin
			axi_need_read <= 1'b0;
		end
	end
end

//AXI read data section
reg axi_wait_for_read; //read wait mode,waiting for master ready signal
ref [AXI_DATA_WIDTH-1:0]axi_data_to_read;
always @(posedge clk)
begin
	if (rst == `RstEnable)
	begin
		saxi_rvaild <= 1'b0;
		saxi_rdata <= (`AXI_DATA_WIDTH)'b0;
		axi_wait_for_read <=1'b0;
	end
	else begin
		if (axi_wait_for_read && saxi_rready) begin  
			saxi_rdata <= axi_need_read;
			saxi_rvaild <= 1'b1;
			axi_wait_for_read <= 1'b0;					//exit wait for read mode
		end
		else if (axi_need_read && saxi_rready) begin  	//ready signal is assigned, read now 
			saxi_rdata <= axi_data_to_read;		
			saxi_rvaild <= 1'b1;
		end
		else if (axi_need_read) begin  					//wait ready signal for read
			axi_wait_for_read <= 1'b1;					//enter wait for read mode
			saxi_rvaild <= 1'b0;				
		end
		else begin
			saxi_rvaild <= (`AXI_DATA_WIDTH)'b0;
		end
	end
end

//AXI register read
always @(*)
begin
	case(axi_raddr)
		(`CLINT_MTIME): 	axi_data_to_read <= mtime;
		(`CLINT_MTIMECMP): 	axi_data_to_read <= mtimecmp;
	default: axi_data_to_read = (`AXI_DATA_WIDTH)'b0;
	endcase
	
end


//AXI register write
//Timer Control
reg timer_irq;
assign time_irq_o = timer_irq;

always @(posedge clk)
begin
	if (rst == `RstEnable)
	begin   //REG RESET VALUE
		mtime <= 64'b0;
		mtimecmp <= 64'hFFFFFFFFFFFFFFFF;
	end
	else begin
		if (saxi_wvaild && saxi_wready)
		begin
			case (axi_waddr)
			(`CLINT_MTIME): mtime <= saxi_wdata;
			(`CLINT_MTIMECMP): mtimecmp <= saxi_wdata;
			default: begin end //do nothing
			endcase
		end
		else begin
			mtime <= mtime +1'b1;
			if (mtime < mtimecmp) timer_irq = 1'b0;
			else  timer_irq = 1'b1;
		end
	end
end

endmodule
