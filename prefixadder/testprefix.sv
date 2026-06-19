module test;
  logic clk, reset;
  logic [15:0] a, b, y, yexpected;
  logic cout, cin, cexpected;
  logic [31:0] vectornum, errors;
  logic [49:0] testvector[200:0];
	
  prefixadder t(a, b, cin, y, cout);
  
  always
    begin
      clk = 1; #5; clk = 0; #5;
    end
  initial begin
    	
    $dumpfile("dump.vcd");
    $dumpvars(0,test);
    $readmemb("vectors.tv",testvector);
    vectornum = 0; errors=0;
    reset = 1; #6; reset = 0;
   
  end
  always@(posedge clk)
    begin
      #1; {a, b, cin, yexpected, cexpected} = testvector[vectornum];
    end
  always@(negedge clk)
    if (~reset) begin
      if (testvector[vectornum] === 50'bx) begin
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
    