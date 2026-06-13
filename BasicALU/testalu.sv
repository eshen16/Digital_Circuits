module test;
  logic clk, reset;
  logic [7:0] a, b, y, yexpected;
  logic [2:0] f;
  logic cout, cexpected;
  logic [31:0] vectornum, errors;
  logic [27:0] testvector[200:0];
	
  alu t(a, b, f, cout, y);
  
  always
    begin
      clk = 1; #5; clk = 0; #5;
    end
  initial begin
    	
    $dumpfile("dump.vcd");
    $dumpvars(0,test);
    $readmemb("aluvectors.tv",testvector);
    vectornum = 0; errors=0;
    reset = 1; #6; reset = 0;
   
  end
  always@(posedge clk)
    begin
      #1; {a, b, f, yexpected, cexpected} = testvector[vectornum];
    end
  always@(negedge clk)
    if (~reset) begin
      if (testvector[vectornum] === 28'bx) begin
        $display("%d tests completed with %d errors", vectornum, errors);
        $finish;
      end
      if(y !== yexpected) begin
        $display("Error: inputs= %b and %b", {a}, {b});
		$display(" outputs= %b (%b expected)", y, yexpected);
        errors = errors + 1;
      end
      if(cout !== cexpected) begin
        $display("Error: inputs= %b and %b", {a}, {b});
        $display(" outputs= %b (%b expected)", cout, cexpected);
        errors = errors + 1;
      end
      vectornum = vectornum+1;
    end
endmodule
    