onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color {Medium Orchid} /asynch_fifo_tb/uut/W_CLK
add wave -noupdate -color {Medium Orchid} /asynch_fifo_tb/uut/R_CLK
add wave -noupdate /asynch_fifo_tb/uut/W_RST
add wave -noupdate /asynch_fifo_tb/uut/W_INC
add wave -noupdate /asynch_fifo_tb/uut/R_RST
add wave -noupdate /asynch_fifo_tb/uut/R_INC
add wave -noupdate /asynch_fifo_tb/uut/WR_DATA
add wave -noupdate -color Cyan /asynch_fifo_tb/uut/FULL
add wave -noupdate -color Cyan /asynch_fifo_tb/uut/EMPTY
add wave -noupdate -color Gold /asynch_fifo_tb/uut/RD_DATA
add wave -noupdate -color White -radix binary /asynch_fifo_tb/uut/wptr
add wave -noupdate -color White -radix binary /asynch_fifo_tb/uut/wq2_wptr
add wave -noupdate -color {Violet Red} -radix binary /asynch_fifo_tb/uut/rptr
add wave -noupdate -color {Violet Red} -radix binary /asynch_fifo_tb/uut/wq2_rptr
add wave -noupdate /asynch_fifo_tb/uut/waddr
add wave -noupdate /asynch_fifo_tb/uut/raddr
add wave -noupdate -color Cyan /asynch_fifo_tb/uut/wclken
add wave -noupdate -color Cyan /asynch_fifo_tb/uut/fifo_memory/ren
add wave -noupdate /asynch_fifo_tb/uut/fifo_memory/W_RST
add wave -noupdate /asynch_fifo_tb/uut/fifo_memory/WR_DATA
add wave -noupdate /asynch_fifo_tb/uut/fifo_memory/wclken
add wave -noupdate /asynch_fifo_tb/uut/fifo_memory/waddr
add wave -noupdate /asynch_fifo_tb/uut/fifo_memory/raddr
add wave -noupdate /asynch_fifo_tb/uut/fifo_memory/RD_DATA
add wave -noupdate -color {Light Blue} -expand -subitemconfig {{/asynch_fifo_tb/uut/fifo_memory/FIFO_mem[0]} {-color {Light Blue}} {/asynch_fifo_tb/uut/fifo_memory/FIFO_mem[1]} {-color {Light Blue}} {/asynch_fifo_tb/uut/fifo_memory/FIFO_mem[2]} {-color {Light Blue}} {/asynch_fifo_tb/uut/fifo_memory/FIFO_mem[3]} {-color {Light Blue}} {/asynch_fifo_tb/uut/fifo_memory/FIFO_mem[4]} {-color {Light Blue}} {/asynch_fifo_tb/uut/fifo_memory/FIFO_mem[5]} {-color {Light Blue}} {/asynch_fifo_tb/uut/fifo_memory/FIFO_mem[6]} {-color {Light Blue}} {/asynch_fifo_tb/uut/fifo_memory/FIFO_mem[7]} {-color {Light Blue}}} /asynch_fifo_tb/uut/fifo_memory/FIFO_mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {252916 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 291
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {558247 ps}
