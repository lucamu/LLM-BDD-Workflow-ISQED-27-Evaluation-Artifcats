// Module: TopModule
// Purpose: Purely combinational control logic for shut_off_computer and
//          keep_driving, with no latches and fully defined outputs for
//          all input combinations.
module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    // Scenario: shut_off_computer is fully defined for all values of cpu_overheated
    // Scenario: shut_off_computer asserts when cpu is overheated (C=1 -> 1)
    // Scenario: shut_off_computer deasserts when cpu is not overheated (C=0 -> 0)
    // Scenario: shut_off_computer is independent of arrived and gas_tank_empty
    assign shut_off_computer = cpu_overheated;

    // Scenario: keep_driving is fully defined for all values of arrived and gas_tank_empty
    // Scenario: keep_driving asserts only when not arrived and gas tank not empty
    // Scenario: keep_driving deasserts when arrived regardless of gas tank state
    // Scenario: keep_driving deasserts when gas tank is empty and not arrived
    // Scenario: keep_driving is independent of cpu_overheated
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule