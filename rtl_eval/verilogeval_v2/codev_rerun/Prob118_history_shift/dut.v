module TopModule(
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    output [31:0] predict_history,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history
);
    reg [31:0] branch_history;
    reg [4:0] history_counter;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_counter <= 5'b0;
        end
        else begin
            if (train_mispredicted) begin
                history_counter <= history_counter - 1;
            end
            if (predict_valid) begin
                history_counter <= history_counter + 1;
            end
        end
    end
    always @(posedge clk) begin
        if (train_mispredicted) begin
            branch_history <= {train_history[30:0], train_taken};
        end
        else if (predict_valid) begin
            branch_history[history_counter] <= predict_taken;
        end
    end
    assign predict_history = branch_history;
endmodule
