BEGIN{
	telnetsize=0;
	ftpsize=0;
	telentpacket=0;
	ftppacket=0;
	totaltelnet=0;
	totalftp=0;
}
{
	packettype=$5;
	event=$1;
	fromnode=$9;
	tonode=$10;
	packetsize=$6;
	
	if(event=="r" && packettype=="tcp" && fromnode=="0.0" && tonode=="3.0")
	{
		telnetpacket++;
		telnetsize=packetsize;
	}
	
		if(event=="r" && packettype=="tcp" && fromnode=="1.0" && tonode=="3.1")
	{
		ftppacket++;
		ftpsize=packetsize;
	}
}
END{
	totaltelnet=telnetpacket*telnetsize*8;
	totalftp=ftppacket*ftpsize*8;
	printf("Throughput of FTP is %d\n",totalftp/24);
	printf("Throughput of telnet is %d\n",totaltelnet/24);
}

