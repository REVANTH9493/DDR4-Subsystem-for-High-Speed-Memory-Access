module ddr4_rtl_project(
	input ddr4_ckt,			//true clock
	input ddr4_ckc,			//complementary clock
	input ddr4_reset_n,		//reset
	input ddr4_cs_n,		//control signal
	input [31:0] ddr4_addr,		//32 bit address
	input ddr4_we_n,		//write enable
	input ddr4_dm,			//data masking
	input ddr4_ras_n,		//row address stalk
	input ddr4_cas_n,		//column address stalk
	input ddr4_odt,			//
	input ddr4_cke,			//	
	input ddr4_act_n,		//
	output reg ddr4_ready,		//
	inout [15:0] ddr4_dq			//
);

	reg [15:0] dq_r;
	reg [71:0] ddr4_command, next_ddr4_command;
	reg [15:0] row_addr;
	reg [9:0] col_addr;
	reg [15:0] mem [65536:0];
	reg [1:0] bank_group;
	reg [1:0] bank_addr;
	reg [1:0] mr_config;
	reg [4:0] cas_rd_latency;
	reg burst_type;
	reg [1:0] burst_len;
	reg [1:0] additive_latency;
	reg [15:0] active_row;
	reg [9:0] active_col;
	reg [5:0] delay;
	reg done;

	localparam IDLE = "IDLE";
	localparam ACTIVATE = "ACTIVATE";
	localparam MRS_STATE = "MRS";
	localparam READ = "READ";
	localparam WRITE = "WRITE";
	localparam PRECHARGE = "PRECHARGE";

	always@(ddr4_addr) begin
		row_addr = ddr4_addr[31:16];		//16 bits
		col_addr = ddr4_addr[15:6];		//10 bits
		bank_group = ddr4_addr[5:4];		//2 bits
		bank_addr = ddr4_addr[3:0];		//4 bits
	end




	always@(posedge clk) begin
		if(!rst)
			ddr4_command <= IDLE;
		else
			ddr4_command <= next_ddr4_command;
	end

	always@(*) begin
		case(ddr4_command) begin
			IDLE: begin
				if(!(ddr4_ras_n || ddr4_cas_n || ddr4_we_n))
					next_ddr4_command <= MRS_STATE;					
				else
					next_ddr4_command <= IDLE;
			end
			MRS_STATE: begin
				mr_config <= ddr4_addr[12:11];

				case(mr_config) begin
					2'b00: begin
						cas_RD_latency <= ddr4_addr[7:3];
						burst_type <= ddr4_addr[2];
						burst_len <= ddr4_addr[1:0];
					end

					2'b01: begin
						cas_wr_latency <= ddr4_addr[10:8];
					end


				if(ddr4_cas_n)
					next_ddr4_command <= ACTIVATE;
				else
					next_ddr4_command <= MRS_STATE:

			end
			ACTIVATE: begin
				if(ddr4_dm)
					next_ddr4_command <= WRITE;
				else
					next_ddr4_command <= READ;
			end
			READ: begin
				if(ddr4_ras_n || ddr4_cas_n || we_n)
					next_ddr4_command <= PRECHARGE;
			end
			WRITE: begin
				if(ddr4_ras_n || ddr4_cas_n || ddr4_we_n)
					next_ddr4_command <= PRECHARGE;
			end
			PRECHARGE: begin
				if(!(ddr4_ras_n || ddr4_cas_n || ddr4_we_n))
					next_ddr4_command <= IDLE;
			end
			default: 
				next_ddr4_command <= IDLE;
		endcase

	end

endmodule
