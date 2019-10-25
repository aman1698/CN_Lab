set ns [new Simulator]

set traceFile [ open 1.tr w]
$ns trace-all $traceFile

set namFile [ open 1.nam w]
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

for {set i 0} {$i < 4} {incr i} {
	set n($i) [$ns node]
}

$ns duplex-link $n(0) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(2) $n(3) 900kb 10ms DropTail

$ns queue-limit $n(0) $n(2) 10

set tcp [new Agent/TCP]
$ns attach-agent $n(0) $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n(3) $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp set type_ FTP
$ftp attach-agent $tcp


set udp [new Agent/UDP]
$ns attach-agent $n(1) $udp

set null [new Agent/Null]
$ns attach-agent $n(3) $null

$ns connect $udp $null

set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 500
$cbr set interval_ 0.005
$cbr attach-agent $udp

$ns at 0.5 "$ftp start"
$ns at 1.0 "$cbr start"
$ns at 9.0 "$cbr stop"
$ns at 9.5 "$ftp stop"
$ns at 10.0 "finish"

$ns run


