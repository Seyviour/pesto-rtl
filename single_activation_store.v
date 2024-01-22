module SingleActivationStore #(
    parameter value_width = 16,
    parameter address_width = 10
) (
    input wire clk,
    input wire reset,
    input wire wr_en,

    input wire [address_width-1: 0] address1, address2;
    input wire [value_width-1:0] write_value,
    output reg [value_width-1:0] o_read_val1, o_read_val2
)

reg [value_width-1:0] mem [2 ** address_width-1:0]; 


always @(posedge clk) begin
    if (wr_en)
        mem[address1] <= write_value; 
    else
        o_read_val1 <= mem[address1]; 
end

always @(posedge clk) begin
    o_read_val2 <= mem[address2]; 
end

endmodule