module andx #(parameter n = 8)(input logic[n-1:0] a, b,
                              output logic[n-1:0] y);
    assign y = a & b;
endmodule

module orx #(parameter n = 8)(input logic[n-1:0] a, b,
                              output logic[n-1:0] y);
    assign y = a | b;
endmodule

module inverter #(parameter n = 8)(input logic[n-1:0] a,
                                   output logic[n-1:0] y);
    assign y = ~a;
endmodule

module adder #(parameter n = 8)(input logic[n-1:0] a, b, 
                              input logic cin,
                              output logic[n-1:0] s,
                              output logic cout);
    assign {cout, s} = a + b + cin;
endmodule

module mux2 #(parameter n= 8)(input logic [n-1:0] d0, d1,
                                  input logic s,
                                  output logic [n-1:0] y);

  assign y = s ? d1 : d0;
endmodule


module zeroExtend #(parameter n = 8)(input logic a,
                                     output logic[n-1:0] y);
  assign y = {{(n-1){1'b0}},a};
endmodule

module alu #(parameter n = 8)(input logic[n-1:0] a, b,
                              input logic[2:0] f,
                              output logic cout,
                              output logic[n-1:0] y);
    logic[n-1:0] b_bar, bb, s, s_and, s_or, s_extend;
  	logic s_cout;
    inverter invB(b, b_bar);
    mux2 mx(b, b_bar, f[2], bb);
    adder add(a, bb, f[2], s, s_cout);
    andx doAnd(a, bb, s_and);
    orx doOr(a, bb, s_or);
    zeroExtend zextend(s[n-1], s_extend);
  
	assign cout = s_cout;	
    always_comb
        case (f[1:0])
            2'b00: y = s_and;
            2'b01: y = s_or;
            2'b10: y = s;
            2'b11: y = s_extend;
            default: y = '0;
        endcase
endmodule