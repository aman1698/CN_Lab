set ns [ new Simulator ]

set error_rate 0.00

set traceFile [ open 1.tr w ]
$ns trace-all $traceFile

set namFile [ open 1.nam w ]
$ns namtrace-all $namFile

proc finish {} {
	global ns namFile traceFile
	$ns flush-trace

	close $traceFile
	close $namFile
	
	exec awk -f stats.awk 1.tr &
	exec nam 1.nam &
	exit 0
}

for { set i 0 } {$i < 6 } { incr i } {
 	set n($i) [$ns node]
}

$ns duplex-link $n(0) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 2Mb 10ms DropTail
$ns simplex-link $n(2) $n(3) 0.3Mb 100ms DropTail
$ns simplex-link $n(3) $n(2) 0.3Mb 100ms DropTail

set lan [$ns newLan " $n(3) $n(4) $n(5)" 0.5Mb 40ms LL Queue/DropTail Mac/802_3 Channel]

$ns duplex-link-op $n(0) $n(2) orient right-down
$ns duplex-link-op $n(1) $n(2) orient right-up
$ns simplex-link-op $n(2) $n(3) orient right

$ns queue-limit $n(2) $n(3) 20
$ns simplex-link-op $n(2) $n(3) queuePos 0.5

set loss_module [new ErrorModel]
$loss_module ranvar [new RandomVariable/Uniform]
$loss_module drop-target [new Agent/Null]
$loss_module set rate_ $error_rate
$ns lossmodel $loss_module $n(2) $n(3)

set TCPAgent [ new Agent/TCP/Newreno]
$ns attach-agent $n(0) $TCPAgent
$TCPAgent set fid_ 1
$TCPAgent set window_ 8000
$TCPAgent set packetSize_ 552

set TCPSink [ new Agent/TCPSink/DelAck]
$ns attach-agent $n(4) $TCPSink
$ns connect $TCPAgent $TCPSink

set ftp [new Application/FTP]
$ftp attach-agent $TCPAgent
$ftp set type_ FTP

set UDPAgent [ new Agent/UDP]
$ns attach-agent $n(1) $UDPAgent
$UDPAgent set fid_ 2


set nullsink [ new Agent/Null]
$ns attach-agent $n(5) $nullsink
$ns connect $UDPAgent $nullsink

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $UDPAgent
$cbr set type_ CBR
$cbr set packetSize_ 1000
$cbr set rate_ 0.2Mb
$cbr set random_ false

$ns at 0.1 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 124.0 "$ftp stop"
$ns at 124.5 "$cbr stop"
$ns at 125.0 "finish"
$ns run

