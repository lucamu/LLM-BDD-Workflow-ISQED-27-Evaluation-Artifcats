module TopModule (
    input  logic cpu_overheated,
    output logic shut_off_computer,
    input  logic arrived,
    input  logic gas_tank_empty,
    output logic keep_driving
);

    always @(*) begin
        if (cpu_overheated)
            shut_off_computer = 1;
        else
            shut_off_computer = 0;
    end

    always @(*) begin
        if (~arrived)
            keep_driving = ~gas_tank_empty;
        else
            keep_driving = 0;
    end

endmodule