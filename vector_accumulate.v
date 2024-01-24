module VectorAccumulate #(
    parameter vector_length = 7,
    parameter data_width = 16
) (
    input wire clk,
    input wire [vector_length*data_width-1: 0] vector_in,
    output wire [data_width+$clog2(vector_length)-1: 0] vector_sum
);

localparam expanded_vector_length = 2 ** ($clog2(vector_length));
localparam length_diff = expanded_vector_length - vector_length;
localparam left_pad_zeros = length_diff * data_width;

wire [expanded_vector_length*data_width-1:0] expanded_vector_in;

assign expanded_vector_in = {{length_diff{1'b0}}, vector_in}; 
/*
0,1,2,3,4,5,6,7,8,9,10,11,12,13
|_| |_| |_| |_| |_| |__|   |_|   
##|___|   |___|   |____|     |  ## stage 0
######|_______|        |_____|  ## stage 1
##############|______________|  ## stage 2
#############################|  ## stage 3

0 -> 1 
1 -> 3
2 -> 7
*/

// TODO: Dynamically Generate instead

localparam num_stages = $clog2(vector_length);


generate
    begin: adder_gen
        genvar stage; 

        for (stage=0; stage<4; stage=stage+1) begin: stage_gen
            genvar i;

            generate
                for (i=2**(stage+1)-1; i<expanded_vector_length; i=i+(2**(stage+1))) begin: stage_io
                    reg [data_width+stage: 0] sum;
                    wire [data_width+stage-1: 0] A, B;
                    if (stage == 0) begin
                        assign A = expanded_vector_in[i*data_width-1: (i-1)*data_width];
                        assign B = expanded_vector_in[(i+1)*data_width-1: i*data_width];

                    end else begin
                        assign A = stage_gen[stage-1].stage_io[i].sum;
                        assign B = stage_gen[stage-1].stage_io[i-2**stage].sum; 
                    end
                    
                    always@(posedge clk) begin
                        sum <= A + B; 
                    end
                end
            endgenerate
        end
    end

endgenerate


assign vector_sum = adder_gen.stage_gen[num_stages-1].stage_io[expanded_vector_length-1].sum;

endmodule