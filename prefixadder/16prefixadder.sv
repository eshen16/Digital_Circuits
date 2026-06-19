module prefixinit(input logic[14:0] a, b,
                  output logic[14:0] p, g);
    assign p = a | b;
    assign g = a & b;
endmodule

module prefixmid(input logic pik, pkj,
                 input logic gik, gkj,
                 output logic pij, gij);
    assign pij = pik & pkj;
    assign gij = (pik & gkj) | gik;
endmodule

module prefixsum(input logic[15:0] a, b,
                 input logic[15:0] g,
                 output logic[15:0] s);
    assign s = (a ^ b) ^ g;
endmodule

module prefixadder(input logic[15:0] a, b,
                   input logic cin,
                   output logic [15:0] s,
                   output logic cout);
    logic [14:0] p, g;
    logic [7:0] pij_1, pij_2, pij_3, pij_4, gij_1, gij_2, gij_3, gij_4;
    logic [15:0] gen;
    prefixinit pinit(a[14:0], b[14:0], p, g);

  	prefixmid pmid_10(p[0], 1'b0, g[0], cin, pij_1[0], gij_1[0]);
    genvar i;
    generate
        for(i=1; i<8; i=i+1) begin
            prefixmid pmid_1(p[i*2],p[i*2-1], g[i*2], g[i*2-1], pij_1[i], gij_1[i]);
        end
        for(i=0; i<4; i=i+1) begin
            prefixmid pmid_21(p[i*4+1], pij_1[i*2], g[i*4+1], gij_1[i*2], pij_2[i*2], gij_2[i*2]);
            prefixmid pmid_22(pij_1[i*2+1], pij_1[i*2], gij_1[i*2+1], gij_1[i*2], pij_2[i*2+1], gij_2[i*2+1]);
        end
        for(i=0; i<2; i=i+1) begin
            prefixmid pmid_31(p[i*8+3], pij_2[i*4+1], g[i*8+3], gij_2[i*4+1], pij_3[i*4], gij_3[i*4]);
            prefixmid pmid_32(pij_1[i*4+2], pij_2[i*4+1], gij_1[i*4+2], gij_2[i*4+1], pij_3[i*4+1], gij_3[i*4+1]);
            prefixmid pmid_33(pij_2[i*4+2], pij_2[i*4+1], gij_2[i*4+2], gij_2[i*4+1], pij_3[i*4+2], gij_3[i*4+2]);
            prefixmid pmid_34(pij_2[i*4+3], pij_2[i*4+1], gij_2[i*4+3], gij_2[i*4+1], pij_3[i*4+3], gij_3[i*4+3]);
        end
    endgenerate
    prefixmid pmid_40(p[7],pij_3[3],g[7],gij_3[3], pij_4[0], gij_4[0]);
    prefixmid pmid_41(pij_1[4],pij_3[3],gij_1[4],gij_3[3], pij_4[1], gij_4[1]);
    prefixmid pmid_42(pij_2[4],pij_3[3],gij_2[4],gij_3[3], pij_4[2], gij_4[2]);
    prefixmid pmid_43(pij_2[5],pij_3[3],gij_2[5],gij_3[3], pij_4[3], gij_4[3]);
    prefixmid pmid_44(pij_3[4],pij_3[3],gij_3[4],gij_3[3], pij_4[4], gij_4[4]);
    prefixmid pmid_45(pij_3[5],pij_3[3],gij_3[5],gij_3[3], pij_4[5], gij_4[5]);
    prefixmid pmid_46(pij_3[6],pij_3[3],gij_3[6],gij_3[3], pij_4[6], gij_4[6]);
    prefixmid pmid_47(pij_3[7],pij_3[3],gij_3[7],gij_3[3], pij_4[7], gij_4[7]);
  
    assign gen = {gij_4, gij_3[3:0], gij_2[1:0], gij_1[0], cin};
      
    prefixsum finalsum(a,b,gen,s);

    assign cout = (((a[15]|b[15])&gij_4[7]) | (a[15]&b[15]));
endmodule
 