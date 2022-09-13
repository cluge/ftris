package provide app-main 1.0

package require Tk

proc for4x4 {ni nj body} {
	upvar $ni i $nj j
	for {set i 0} {$i < 4} {incr i} {
		for {set j 0} {$j < 4} {incr j} {
			uplevel 1 $body
		}
	}
}

#            red     orange  yellow  green   cyan    blue    magenta
# set Colors { #E57373 #FFB74D #FFEE58 #4CAF50 #4dd0e1 #1e88e5 #BA68C8 }
set Colors { #EA8686 #FFA726 #FFD54F #66BB6A #4dd0e1 #42A5F5 #BA68C8 }

set shape {
	{ { { 0 0 0 0 } { 0 1 1 0 } { 0 1 1 0 } { 0 0 0 0 } } }
	{ { { 0 0 0 0 } { 1 1 1 1 } { 0 0 0 0 } { 0 0 0 0 } }
	  { { 0 0 1 0 } { 0 0 1 0 } { 0 0 1 0 } { 0 0 1 0 } } }
	{ { { 0 0 0 0 } { 0 0 1 1 } { 0 1 1 0 } { 0 0 0 0 } }
	  { { 0 0 1 0 } { 0 0 1 1 } { 0 0 0 1 } { 0 0 0 0 } } }
	{ { { 0 0 0 0 } { 0 1 1 0 } { 0 0 1 1 } { 0 0 0 0 } }
	  { { 0 0 0 1 } { 0 0 1 1 } { 0 0 1 0 } { 0 0 0 0 } } }
	{ { { 0 0 0 0 } { 0 1 1 1 } { 0 1 0 0 } { 0 0 0 0 } }
	  { { 0 0 1 0 } { 0 0 1 0 } { 0 0 1 1 } { 0 0 0 0 } }
	  { { 0 0 0 1 } { 0 1 1 1 } { 0 0 0 0 } { 0 0 0 0 } }
	  { { 0 1 1 0 } { 0 0 1 0 } { 0 0 1 0 } { 0 0 0 0 } } }
	{ { { 0 0 0 0 } { 0 1 1 1 } { 0 0 0 1 } { 0 0 0 0 } }
	  { { 0 0 1 1 } { 0 0 1 0 } { 0 0 1 0 } { 0 0 0 0 } }
	  { { 0 1 0 0 } { 0 1 1 1 } { 0 0 0 0 } { 0 0 0 0 } }
	  { { 0 0 1 0 } { 0 0 1 0 } { 0 1 1 0 } { 0 0 0 0 } } }
	{ { { 0 0 0 0 } { 0 1 1 1 } { 0 0 1 0 } { 0 0 0 0 } }
	  { { 0 0 1 0 } { 0 0 1 1 } { 0 0 1 0 } { 0 0 0 0 } }
	  { { 0 0 1 0 } { 0 1 1 1 } { 0 0 0 0 } { 0 0 0 0 } }
	  { { 0 0 1 0 } { 0 1 1 0 } { 0 0 1 0 } { 0 0 0 0 } } }
}

proc createUi {} {
	global Stats
	wm withdraw .
	wm title . Ftris
	wm resizable . 0 0
	. configure -bg #102027 -bd 20
	#extrafont::load [file dirname [file normalize [info script]]]/MAIAN.TTF
	# set font [font create uifont -family Ubuntu -size 14]
	#set font [font create uifont -family {Eras Medium ITC} -size 15]
	#set hfnt [font create hfont -family {Eras Medium ITC} -size 13]
	set font [font create uifont -family {Maiandra GD} -size 15]
	set hfnt [font create hfont -family {Maiandra GD} -size 13]
	#set font [font create uifont -family {Tempus Sans ITC} -size 15]
	#set hfnt [font create hfont -family {Tempus Sans ITC} -size 12]

    # фрейм с очками, помощью и рекордами
    frame .rf -bg #102027
    grid [frame .rf.sf -bg #102027] -row 0 -column 0
    grid [label .rf.sf.capt -text game -bg #102027 -fg white -font $font] -row 0 -column 0 -columnspan 2
    grid [label .rf.sf.lcapt -text level -bg #102027 -fg white -font $hfnt] -row 1 -column 0 -sticky w
    grid [label .rf.sf.lnum -textvariable level -bg #102027 -fg white -font $hfnt] -row 1 -column 1 -sticky e
    grid [label .rf.sf.rcapt -text rows -bg #102027 -fg white -font $hfnt] -row 2 -column 0 -sticky w
    grid [label .rf.sf.rcnt -textvariable lines -bg #102027 -fg white -font $hfnt] \
    	-row 2 -column 1 -sticky e
    grid [label .rf.sf.scapt -text score -bg #102027 -fg white -font $hfnt] -row 3 -column 0 -sticky w
    grid [label .rf.sf.score -textvariable Score -bg #102027 -fg white -font $hfnt -width 5 -anchor e] \
    	-row 3 -column 1 -sticky e
    set ::Score 0
    set ::level 1
    set ::lines 0

    grid [frame .rf.bf -bg #102027] -row 1 -column 0 -pady 10
    grid [label .rf.bf.capt -text best -bg #102027 -fg white -font $font] -row 0 -column 0 -columnspan 2
    grid [label .rf.bf.b1d -text 00.00 -bg #102027 -fg white -font $hfnt -width 5 -anchor w] -row 1 -column 0
    grid [label .rf.bf.b1s -text 00000 -bg #102027 -fg white -font $hfnt -width 5 -anchor e] -row 1 -column 1
    grid [label .rf.bf.b2d -text 00.00 -bg #102027 -fg white -font $hfnt -width 5 -anchor w] -row 2 -column 0
    grid [label .rf.bf.b2s -text 00000 -bg #102027 -fg white -font $hfnt -width 5 -anchor e] -row 2 -column 1
    grid [label .rf.bf.b3d -text 00.00 -bg #102027 -fg white -font $hfnt -width 5 -anchor w] -row 3 -column 0
    grid [label .rf.bf.b3s -text 00000 -bg #102027 -fg white -font $hfnt -width 5 -anchor e] -row 3 -column 1

    grid [frame .rf.hf -bg #102027] -row 2 -column 0
    grid [label .rf.hf.capt -text help -bg #102027 -fg white -font $font] -row 0 -column 0 -columnspan 2
    grid [label .rf.hf.lcapt -text left -bg #102027 -fg white -font $hfnt -anchor e] -row 1 -column 0 -sticky w
    grid [label .rf.hf.ltext -text "left, a" -bg #102027 -fg white -font $hfnt -anchor e] -row 1 -column 1 -sticky w
    grid [label .rf.hf.ricapt -text right -bg #102027 -fg white -font $hfnt -anchor e] -row 2 -column 0 -sticky w
    grid [label .rf.hf.ritext -text "right, d" -bg #102027 -fg white -font $hfnt -anchor e] -row 2 -column 1 -sticky w
    grid [label .rf.hf.rocapt -text rotate -bg #102027 -fg white -font $hfnt -anchor e] -row 3 -column 0 -sticky w
    grid [label .rf.hf.rotext -text "up, w" -bg #102027 -fg white -font $hfnt -anchor e] -row 3 -column 1 -sticky w
    grid [label .rf.hf.dcapt -text drop -bg #102027 -fg white -font $hfnt -anchor e] -row 4 -column 0 -sticky w
    grid [label .rf.hf.dtext -text "down, s" -bg #102027 -fg white -font $hfnt -anchor e] -row 4 -column 1 -sticky w
    grid [label .rf.hf.pcapt -text pause -bg #102027 -fg white -font $hfnt -anchor e] -row 5 -column 0 -sticky w
    grid [label .rf.hf.ptext -text p -bg #102027 -fg white -font $hfnt -anchor e] -row 5 -column 1 -sticky w
    grid [label .rf.hf.ncapt -text new -bg #102027 -fg white -font $hfnt -anchor e] -row 7 -column 0 -sticky w
    grid [label .rf.hf.ntext -text enter -bg #102027 -fg white -font $hfnt -anchor e] -row 7 -column 1 -sticky w
    grid [label .rf.hf.ecapt -text exit -bg #102027 -fg white -font $hfnt -anchor e] -row 8 -column 0 -sticky w
    grid [label .rf.hf.etext -text escape -bg #102027 -fg white -font $hfnt -anchor e] -row 8 -column 1 -sticky w


	# игровое поле	
	frame .board -bg #102027
	for {set i 1} {$i <= 22} {incr i} {
		set row {}
		for {set j 1} {$j <= 12} {incr j} {
			grid [frame .board.${i}x${j} -width 20 -height 20 \
				-bg [lindex {#000a12 #455A64} [expr {$i < 2 || $i > 21 || $j < 2 || $j > 11}]]] \
				-row $i -column $j -padx [expr {$j % 2}] -pady [expr {$i % 2}]
		}
	}
	grid [frame .board.coner -width 1 -height 1 -bg #102027] -row 23 -column 13
	grid [label .board.lpause -text "PAUSE" -font $font -fg white -bg #102027] \
		-row 10 -column 3 -rowspan 4 -columnspan 8 -sticky nswe
	grid [label .board.lgameover -text "GAME OVER" -font $font -fg white -bg #102027] \
		-row 10 -column 3 -rowspan 4 -columnspan 8 -sticky nswe
	grid remove .board.lgameover
	grid remove .board.lpause
	# grid configure .board.lgameover

	# фрейм со следующей фигурой и статиситкой
	frame .lf -bg #102027
	grid [label .lf.lnext -text next -font $font -bg #102027 -fg white] \
		-row 0 -column 0
	frame .lf.fnext -bg #102027
	for4x4 i j {
		grid [frame .lf.fnext.${i}x${j} -width [expr {$j == 0 ? 0 : 20}] -height 20 -bg #102027] \
			-row [expr {$i + 1}] -column $j -padx [expr {$j % 2}] -pady [expr {$i % 2}]
	}
	frame .lf.fstats -bg #102027
	grid [label .lf.fstats.catp -text statistics -font $font -bg #102027 -fg white] \
		-row 0 -column 0 -columnspan 2
    for {set p 0} {$p < 7} {incr p} {
    	grid [frame .lf.fstats.f$p -bg #102027] -row [expr {$p + 1}] -sticky w
    	grid [label .lf.fstats.l$p -font $hfnt -bg #102027 -width 6 \
    			-fg white -textvariable Stats($p) -anchor e] \
    		-row [expr {$p + 1}] -column 1 -sticky e
    	set Stats($p) 0
    	# puts [.lf.fstats.l$p configure]
    	for {set i [expr {$p == 1 ? 0 : 1}]} {$i < 3} {incr i} {
    		for {set j 0} {$j < 4} {incr j} {
    			if {[lindex $::shape $p 0 $i $j]} {
    				set bg [lindex $::Colors $p]
    				set s 9
    			} else {
    				set bg #102027
    				set s 0
    			}
    			grid [frame .lf.fstats.f$p.${i}x${j} -width $s -height 9 -bg $bg] \
    				-row $i -column $j
    		}
    	}
    }
    grid [label .lf.fstats.lall -text all -font $hfnt -bg #102027 -fg white] -row 8 -sticky w
    grid [label .lf.fstats.vall -textvariable Stats(all) \
    		-font $hfnt -bg #102027 -fg white -anchor e -width 6] \
    	-row 8 -column 1 -sticky e
    set Stats(all) 0
    grid [label .lf.fstats.ltime -text time -font $hfnt -bg #102027 -fg white] -row 9 -sticky w
    grid [label .lf.fstats.vtime -textvariable Game(tmstr) -font $hfnt -bg #102027 -fg white] \
    	-row 9 -column 1 -sticky e
    set ::Game(tmstr) 0:00

	grid columnconfigure . 0 -minsize 130
	grid columnconfigure . 2 -minsize 130

	grid .lf.fnext -row 1 -column 0
	grid [frame .lf.fs -height 60 -bg #102027] -row 2 -column 0
	grid .lf.fstats -row 3 -column 0

	grid .board -row 0 -column 1 -padx 20
	grid .rf -row 0 -column 0
	grid .lf -row 0 -column 2

	update
	lassign [split [wm geometry .] x+] w h sx sy
	set sw [expr {([winfo rootx .] - $sx) * 2 + $w}]
	set sh [expr {[winfo rooty .] - $sy + [winfo rootx .] - $sx + $h}]
	set sx [expr {([winfo screenwidth .] - $sw) / 2}]
	set sy [expr {([winfo screenheight .] - $sh) / 2}]
	wm geometry . +$sx+$sy
	wm deiconify .
}

proc board {method args} {
	global Board Piece
	switch $method {
		create {
			set Board {}
			for {set i 0} {$i < 24} {incr i} {
				set r {}
				for {set j 0} {$j < 14} {incr j} {
					lappend r [expr {$i < 2 || $i > 21 || $j < 2 || $j > 11}]
				}
				lappend Board $r
			}
		}
		clear {
			for {set i 2} {$i < 22} {incr i} {
				for {set j 2} {$j < 12} {incr j} {
					lset Board $i $j 0
					.board.${i}x${j} configure -bg #000a12
				}
			}
		}
		removefilled {
			set lines 0
			for {set i 21} {$i > 1} {incr i -1} {
				set line 1
				for {set j 2} {$j < 12} {incr j} {
					if {![lindex $Board $i $j]} {
						set line 0
						break;
					}
				}
				if {$line} {
					incr lines
					for {set ii $i} {$ii > 2} {incr ii -1} {
						lset Board $ii [lindex $Board [expr {$ii - 1}]]
						for {set j 2} {$j < 12} {incr j} {
							.board.${ii}x${j} configure -bg [.board.[expr {$ii - 1}]x${j} cget -bg]
						}
					}
					for {set j 2} {$j < 12} {incr j} {
						.board.2x${j} configure -bg #000a12
					}
					incr i
				}
			}
			return $lines
		}
		cell {
			lassign $args x y v
			if {$v eq {}} {
				return [lindex $Board $x $y]
			} else {
				lset Board $x $y $v
			}
		}
	}
}

proc piece {method args} {
	global Piece Colors shape
	switch $method {
		create {
			array set Piece [list \
				x 1 y 5 o 0 \
				t [lindex $shape $args] \
				c [lindex $Colors $args] \
				n [expr {int(rand() * 7)}]]
			piece draw
			piece drawnext
			stats add $args
			set drops 0
		}
		next {
			piece create $Piece(n)
		}
		drawnext {
        	set p [lindex $shape $Piece(n) 0]
        	set c [lindex $Colors $Piece(n) 0]
        	for4x4 i j {
				.lf.fnext.${i}x${j} configure \
					-bg [lindex [list #102027 $c] [lindex $p $i $j]] \
					-width [expr {[lindex $p $i $j] ? 20 : 0}]
			}
			update
		}
		cell {
			lassign $args x y o
			if {$o eq {}} { set o $Piece(o) }
			return [lindex $Piece(t) $o $x $y]
		}
		clear {
			for4x4 i j {
				if {[piece cell $i $j $Piece(o)]} {
					.board.[expr {$Piece(x) + $i}]x[expr {$Piece(y) + $j}] configure -bg #000a12
				}
			}
		}
		draw {
			for4x4 i j {
				if {[piece cell $i $j $Piece(o)]} {
					.board.[expr {$Piece(x) + $i}]x[expr {$Piece(y) + $j}] configure -bg $Piece(c)
				}
			}
		}
		valid {
			lassign $args x y o
			if {$x eq {}} {	set x $Piece(x); set y $Piece(y); set o $Piece(o) }
			set result 1
			for4x4 i j {
				if {[piece cell $i $j $o] && [board cell [expr {$x + $i}] [expr {$y + $j}]]} {
					set result 0
				}
			}
			return $result
		}
		down {
			if {[piece valid [expr {$Piece(x) + 1}] $Piece(y) $Piece(o)]} {
				piece clear
				incr Piece(x)
				piece draw
				return 1
			} else {
				for4x4 i j {
					if {[piece cell $i $j]} {
						board cell [expr {$Piece(x) + $i}] [expr {$Piece(y) + $j}] 1
					}
				}
				return 0
			}
		}
		rotate {
			set no [expr {$Piece(o) + 1 >= [llength $Piece(t)] ? 0 : $Piece(o) + 1}]
			if {[piece valid $Piece(x) $Piece(y) $no]} {
				piece clear
				set Piece(o) $no
				piece draw
			} elseif {$Piece(x) == 1} {
				set nx [expr {$Piece(x) + 1}]
				if {[piece valid $nx $Piece(y) $no]} {
					piece clear
					set Piece(o) $no
					set Piece(x) $nx
					piece draw
				}
			}
		}
		left - right {
			set ny [expr {$Piece(y) + [dict get {left -1 right 1} $method]}]
            if {[piece valid $Piece(x) $ny]} {
            	piece clear
            	set Piece(y) $ny
            	piece draw
            }
		}
	}
}

proc stats {method args} {
	global Stats
	switch $method {
		clear {
			for {set i 0} {$i < 7} {incr i} { set Stats($i) 0 }
			set Stats(all) 0
		}
		add {
			incr Stats($args)
			incr Stats(all)
		}
	}
}

proc game {method args} {
	global bt fall level lines evtm drops Score Game Stats Best
	switch $method {
		start {
			grid remove .board.lpause
			grid remove .board.lgameover

			board clear
			stats clear
			piece create [expr {int(rand() * 7)}]

			set fall 0
			set level 1
			set lines 0
			set evtm 600
			set GameState RUN
			set bt [expr {[clock milliseconds] + 500}]
			
			set Game(begtm) [clock seconds]
			set Game(tmstr) 0:00
			set Game(pause) 0
			set Game(stop) 0
			set Game(rcnt) 0
			set drops 0

			set Score 0

            game run
		}
		run {
			if {$Game(pause) || $Game(stop)} return
			set gtm [expr {[clock seconds] - $Game(begtm)}]
			set Game(tmstr) [format %d:%02d [expr {$gtm / 60}] [expr {$gtm % 60}]]
			set ct [clock milliseconds]
			if {$ct - $bt >= ($fall ? 30 : $evtm)} {
				incr bt [expr {$fall ? 30 : $evtm}]
				if {![piece down]} {
					incr Score [expr {$drops + $level}]
					set drops 0
					if {[set n [board removefilled]]} {
						#incr Score [expr {int($level * $n * 1.661)}]
						incr Score [expr {$level * $n * $n}]
						incr Game(rcnt)
						incr lines $n
					}
					#set level [expr {$Game(rcnt) && $Game(rcnt) < 61 ? ($Game(rcnt) - 1) / 6 + 1 : $level}]
					set level [expr {$lines && $lines < 101 ? ($lines - 1) / 10 + 1 : $level}]
					set evtm [expr {660 - $level * 60}]
					# puts "rcnt: $Game(rcnt); level: $level; evtm: $evtm"
					set fall 0
					piece next
					if {![piece valid]} {
                        grid configure .board.lgameover
						set d [clock format [clock seconds] -format %d.%m]
						lappend Best [list $d $Score]
						proc cmp {x y} {
							lassign $x xd xs
							lassign $y yd ys
							if {$xs > $ys} {
								return -1
							} elseif {$xs < $ys} {
								return 1
							}
							return [string compare $xd $yd]
						}
						set Best [lrange [lsort -command cmp $Best] 0 2]
						set sf [open $::sfn w]
						puts $sf $Best
						close $sf
						set i 1
						foreach e $Best {
							lassign $e d s
							.rf.bf.b${i}d configure -text $d
							.rf.bf.b${i}s configure -text $s
							incr i
						}
						set Game(stop) 1
                        return
					}
					set bt [clock milliseconds]
				} else {
					if {$fall} { incr drops }
				}
			}
			after 2 { game run }
		}
	}
}

bind . <Key> {
	if {!$Game(pause)} {
		switch %K {
			Up - W - w 		{ piece rotate }
			Left - A - a	{ piece left }
	        Right - D - d	{ piece right }
			Down - space - S - s {
				set fall 1
				set bt [expr {[clock milliseconds] - 40}]
			}
		}
	}
	switch %K {
		P - p {
			if {!$Game(pause)} {
				set Game(pause) 1
				set dt [expr {[clock milliseconds] - $bt}]
				set pt [clock seconds]
				grid configure .board.lpause
			} else {
				set Game(pause) 0
				set bt [expr {[clock milliseconds] - $dt}]
				grid remove .board.lpause
				set Game(begtm) [expr {$Game(begtm) + [clock seconds] - $pt}]
				game run
			}
		}
		Return {
			set Game(stop) 1
			after 5 { game start }
		}
		Escape { exit }
	}
}

createUi
board create

if {[info exists env(APPDATA)]} {
	set ::sfn "$env(APPDATA)\\.ftetscr"
} elseif {[info exists env(HOME)]} {
	set ::sfn "$env(HOME)\\.ftetscr"
} else {
	set ::sfn .ftetscr
}

if {[catch {open $sfn r} sf]} {
    set ::Best { {00.00 0} {00.00 0} {00.00 0} }
} else {
	set ::Best [read $sf]
	close $sf
}

#    grid [label .rf.bf.b1d -text 00.00 -bg #102027 -fg white -font $hfnt] -row 1 -column 0
#    grid [label .rf.bf.b1s -text 00000 -bg #102027 -fg white -font $hfnt] -row 1 -column 1
set i 1
foreach e $Best {
	lassign $e d s
	.rf.bf.b${i}d configure -text $d
	.rf.bf.b${i}s configure -text $s
	incr i
}

after idle { game start }
