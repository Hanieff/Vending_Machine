
module vend(
    input logic clk,
	input logic rst_,
	input logic pulse,
	input logic [1:0] coin,
	output logic sell, //dispense drink
	output logic change //changes
);
 logic [1:0] n_state;
 logic [1:0] state;

// combination logic 
parameter IDLE = 2'b00;
parameter GET05 = 2'b01;
parameter GET10 = 2'b10;
parameter GET15 = 2'b11;

parameter NC = 2'b00; // NC = no coin
parameter Y05 = 2'b01; // 0.5 yuan
parameter Y1 = 2'b10; // 1 yuan


// Generating next state logic
always_comb begin
 case(state)
  IDLE: begin
      if ((coin == Y05) && pulse) n_state = GET05;
      else if((coin == Y1) && pulse) n_state = GET10;
	  else n_state = state;
	  end
  GET05: begin
      if ((coin == Y05) && pulse) n_state = GET10;
      else if((coin == Y1) && pulse) n_state = GET15;
	  else n_state = state;
	  end
  GET10: begin
      if ((coin == Y05) && pulse) n_state = GET15;
      else if((coin == Y1) && pulse) n_state = IDLE;
	  else n_state = state;
	  end
  GET15: begin
      if ((coin != NC) && pulse) n_state = IDLE;
      else n_state = state;
	  end 
  default: n_state = 'hx;
endcase
end

 //State register
 always_ff @(posedge clk, negedge rst_) begin
  if(!rst_) state <= 0;
  else state = n_state;
 end

 // Generating output
 assign sell = ((state == GET10)&&(coin==Y1))||((state == GET15)&&(coin != NC));
 assign change = (state == GET15)&&(coin == Y1);

endmodule
