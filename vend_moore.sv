
module vend(
    input logic clk,
	input logic rst_,
	input logic [1:0] coin,
	output logic dis, //dispense
	output logic change //changes
);
 reg [2:0] n_state;
 reg [2:0] state;

// combination logic 
parameter int S0 = 3'b000;
parameter int S1 = 3'b001;
parameter int S2 = 3'b010;
parameter int S3 = 3'b011;
parameter int S4 = 3'b100;
parameter int S5 = 3'b101;

parameter int no_coin = 2'b00;
parameter int y0_5 = 2'b01;
parameter int y1 = 2'b10;


 Generating next state logic
always_comb begin
 case(state)
  S0: begin
      case(coin)
	  y0_5: n_state = S1;
      y1: n_state = S2;
	  default: n_state = S0;
      endcase
	  end
  S1: begin
      case(coin)
	  y0_5: n_state = S2;
      y1: n_state = S3;
	  default: n_state = S1;
      endcase
	  end
  S2: begin
      case(coin)
	  y0_5: n_state = S3;
      y1: n_state = S5;
	  default: n_state = S2;
      endcase
	  end
  S3: begin
      case(coin)
	  y0_5: n_state = S5;
      y1: n_state = S4;
	  default: n_state = S3;
      endcase
	  end
  S4: n_state = S0;
  S5: n_state = S0;

  default: n_state = 'hx;
endcase
end

 //State register
 always @(posedge clk, negedge rst_) begin
  if(!rst_) state <= 0;
  else state <= n_state;
 end

 // Generating output
always_comb begin
 case(state)
  S0:begin
     dis = 0;
     change = 0;
	 end
  S1:begin
     dis = 0;
     change = 0;
	 end
  S2:begin
     dis = 0;
     change = 0;
	 end
  S3:begin
     dis = 0;
     change = 0;
	 end
  S4:begin
     dis = 1;
     change = 0;
	 end
  S5:begin
     dis = 1;
     change = 1;
	 end

  default: begin
           dis = 'hx;
		   change = 'hx;
		   end
endcase
end

endmodule
