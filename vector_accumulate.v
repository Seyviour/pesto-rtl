module VectorAccumulate #(
    parameter vector_length = 7,
    parameter data_width = 48
) (
    input wire clk,
    input wire reset,

    input wire [vector_length*data_width-1: 0] vector_in,
    output wire [data_width-1: 0] vector_sum
);

/*
0,1,2,3,4,5,6,7,8,9,10,11,12,13
|_| |_| |_| |_| |_| |__|   |_| 
##|___|   |___|   |____|     |
######|_______|        |_____|
##############|______________|
#############################|
*/

// TODO: Dynamically Generate instead

localparam num_stages = $clog2(vector_length);
localparam [num_stages*8-1:0] adders_for_stage [3:0] ={0};
genvar k;

// for (k = 0; k < num_stages; k = k + 1) begin
//     if (k == 0) begin
//         adders_for_stage[(k+1)*8: (k*8)] = vector_length/2; 
//     end
// end


generate
    begin: adder_gen
        genvar stage; 

        for (stage=0; stage<num_stages; stage=stage+1) begin: stage_gen
            genvar i;
            genvar num_stage_inputs = vector_length/(2**(stage+1));
            // num_stage_inputs =  

            generate
                for (i=0; i<vector_length/2; i=i+1) begin: stage_io
                    reg [data_width-1: 0] sum;
                    wire [data_width-1: 0] A, B;
                    if (stage == 0) begin
                        assign A = vector_in[(2*i+1)*data_width-1: i*data_width];
                        assign B = vector_in[(2*i+2)*data_width-1: (i+1)*data_width]; 
                    end else begin
                        assign A = stage_gen[stage-1].stage_io[0].sum;
                        assign B = stage_gen[stage-1].stage_io[1].sum; 
                    end
                    
                    always@(posedge clk) begin
                        sum <= A + B; 
                    end
                end
            endgenerate

        end
    end

endgenerate







endmodule