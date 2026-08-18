   # Project 3A timing constraints                                                                                           2 # CLK_PORT and CLK_PERIOD come from project_setup.tcl
  
   # ------------------------------------------------------------
   # Clock
   # ------------------------------------------------------------
  
   create_clock \
       -name CLK \
     -period $CLK_PERIOD \
      -waveform [list 0 [expr {$CLK_PERIOD / 2.0}]] \
      [get_ports $CLK_PORT]
 
 
  # ------------------------------------------------------------
  # Input-port groups
  # ------------------------------------------------------------
 
  set CLOCK_INPUT [get_ports $CLK_PORT]
  set RESET_INPUT [get_ports FSM_ARESET]
 
  # Remove the clock and asynchronous reset from normal data inputs
  set DATA_INPUTS \
      [remove_from_collection \
          [remove_from_collection \
              [all_inputs] \
              $CLOCK_INPUT] \
          $RESET_INPUT]
  # ------------------------------------------------------------
  # Interface delays
  # ------------------------------------------------------------
  set_input_delay \
      [expr {$CLK_PERIOD / 4.0}] \
      -clock [get_clocks CLK] \
      $DATA_INPUTS
 
  set_output_delay \
      [expr {$CLK_PERIOD / 4.0}] \
      -clock [get_clocks CLK] \
      [all_outputs]
 
 
  # ------------------------------------------------------------
  # Asynchronous-reset timing exception
  # ------------------------------------------------------------
 
  set_false_path \
      -from $RESET_INPUT          
