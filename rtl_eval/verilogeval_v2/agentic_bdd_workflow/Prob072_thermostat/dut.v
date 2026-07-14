// ============================================================================
// Module: TopModule
// Purpose: Combinational Heating/Cooling Thermostat Controller
//
// Behavior:
//   - heater = mode AND too_cold                    (@heater-logic)
//   - aircon = (NOT mode) AND too_hot                (@aircon-logic)
//   - fan    = heater OR aircon OR fan_on            (@fan-logic)
//
// These equations inherently guarantee:
//   - heater AND aircon == 0 always                  (@mutual-exclusion)
//   - mode=1 => aircon=0                             (@heating-mode-no-aircon)
//   - mode=0 => heater=0                             (@cooling-mode-no-heater)
//   - fan is asserted whenever heater or aircon is on
//     (@fan-implied-by-heater, @fan-implied-by-aircon)
// ============================================================================
module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // @heater-logic: Heater turns on only in heating mode when too cold
    // @cooling-mode-no-heater: mode=0 forces heater=0 (satisfied since mode term is ANDed)
    // @heating-mode-too-cold: mode=1, too_cold=1 => heater=1
    assign heater = mode & too_cold;

    // @aircon-logic: Air conditioner turns on only in cooling mode when too hot
    // @heating-mode-no-aircon: mode=1 forces aircon=0 (satisfied since (~mode) term is ANDed)
    // @cooling-mode-too-hot: mode=0, too_hot=1 => aircon=1
    assign aircon = (~mode) & too_hot;

    // @fan-logic: Fan turns on when heater, aircon, or manual fan_on request is active
    // @manual-fan-request: fan_on=1 forces fan=1 regardless of heater/aircon state
    // @fan-implied-by-heater / @fan-implied-by-aircon: fan is OR'd with heater and aircon,
    //   so whenever either is 1, fan is guaranteed to be 1
    assign fan = heater | aircon | fan_on;

    // @mutual-exclusion: heater & aircon = (mode & too_cold) & (~mode & too_hot) = 0
    //   since mode & ~mode = 0, this is structurally guaranteed by the equations above.

    // @all-off / @all-off-cooling: When mode-specific trigger and fan_on are all 0,
    //   heater, aircon, and fan are all naturally 0 by the above equations.

endmodule