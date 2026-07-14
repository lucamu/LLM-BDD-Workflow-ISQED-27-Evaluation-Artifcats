clear -all
catch {set_property_compile_time_limit 60s}
catch {analyze -sv12 -f minsoc_tc_top.f}
catch {check_cov -init -type {coi proof}}
if {![catch {elaborate -top minsoc_tc_top} e_el]} { puts "JGELAB ok" } else { puts "JGELAB fail: $e_el" }
catch {clock wb_clk_i}
catch {reset wb_rst_i}
catch {set_prove_time_limit 60s}
catch {prove -all}
if {![catch {set props [get_property_list -include {type assert}]} err]} {
    foreach p $props {
        if {![catch {set st [get_property_info $p -list status]} e2]} {
            puts "JGPROP $p $st"
        }
    }
}
catch {check_cov -measure}
if {![catch {set cov [check_cov -report -report_file cov.rpt -force]} e5]} {
    puts "JGCOV_BEGIN"
    puts $cov
    puts "JGCOV_END"
}
exit
