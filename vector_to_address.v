module vector_loc_to_address #(
    address_width = 10,
    vector_idx_width = 8
) (
    input wire alt_address, 
    input wire  [vector_idx_width-1: 0] vector_index,
    output wire [address_width-1: 0] address1,
    output wire [address_width-1: 0] address2 
)

/*
    This is a hack and not really parametrizable.
    I know that there are only 3 vectors here
    So I'll store them starting at 0, 256, and 512
    The remainder of activations, I will store in the 768-1023 space.
    That way, I can probably save on adders

    vec 1, 0 - 255 -> addr 0 - 255
    vec 2, 0 - 255 -> addr 256 - 511
    vec 3, 0 - 265 -> addr 512 - 767

    vec 1, 256-263 -> addr 768 -> 775
    vec 2, 256-263 -> addr 776 -> 783
    vec 3, 256-263 -> addr 784 -> 791
*/

/*
 0 - 255
 256 - 511
 512 - 768
*/
always @(*) begin
    address1 = {2'b00, vector_index[7:0]};
    address2 = (alt_address?) {2'b10, vector_index[7:0]}: {2'b01, vector_index[7:0]}; 

    // {alt_address, !alt_address, vector_index[7:0]}

    if (vector_index[8]) begin
        address1 = {2'b11, 3'b000, 1'b0, 1'b0, vector_index[2:0]};
        address2 = {2'b11, 3'b000, alt_address, 1'b1, vector_index[2:0]}; 
    end

end

endmodule