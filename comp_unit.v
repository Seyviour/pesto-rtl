module CompUnit #(
    parameter value_width = 16
) (
    input wire clk,
    input wire [2:0] instr,
    input wire [value_width-1:0] A1,
    input wire [value_width-1:0] A2,
    input wire [value_width-1:0] W1,
    input wire [value_width-1:0] W2,

    output reg [value_width-1:0] out1,
    output reg [value_width-1:0] out2
);

localparam clear = 3'b000; 
localparam mult_acc_A1_W1_A2_W2 = 3'b111;


reg [value_width*2-1:0] _mult_result1;
reg [value_width*2-1:0] _mult_result2;
reg [value_width*2-1:0] _sum_result; 

always @(*) begin
    casex (instr) 

        3'b000: begin
            _mult_result1 = 0;
            _mult_result2 = 0;
        end
            
        3'b111: begin 
            _mult_result1 = A1 * W1;
            _mult_result2 = A2 * W2;
        end

        3'b110: begin
            _mult_result1 = 0;
            _mult_result2 = A2 * W2; 
        end

        3'b101: begin
            _mult_result1 = {16'b0, W1};
            _mult_result2 = {16'b0, W2};
        end

        default: begin
            _mult_result1 = out1;
            _mult_result2 = 0; 
        end 

    endcase

    _sum_result = _mult_result1 + _mult_result2 + (instr[2]? out1: 0); 
end


always @(posedge clk) begin
    out1 <= _sum_result; 
end

endmodule