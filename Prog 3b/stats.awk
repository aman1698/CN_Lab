BEGIN{
	tcpsent=0;
	tcpreceived=0;
	tcplost=0;
	udpsent=0;
	udpreceived=0;
	udplost=0;
	totalsent=0;
	totallost=0;
}
{
	packettype=$5
	event=$1
	if(packettype == "tcp")
	{
		if(event == "+")
		{
			tcpsent++;
		}
		else if(event == "r")
		{
			tcpreceived++;
		}
		else if (event == "d")
		{
			tcplost++;
		}
	}
	if(packettype == "cbr")
	{
		if(event == "+")
		{
			udpsent++;
		}
		else if(event == "r")
		{
			udpreceived++;
		}
		else if (event == "d")
		{
			udplost++;
		}
	}
}
END{
	totalsent = tcpsent + udpsent;
    	totallost = tcplost + udplost;
    printf("\nTCP packets sent : %d\n",tcpsent);
    printf("TCP packets recieved : %d\n",tcpreceived);
    printf("TCP packets dropped: %d\n", tcplost);
    printf("UDP packets sent : %d\n",udpsent);
    printf("UDP packets recieved : %d\n",udpreceived);
    printf("UDP packets dropped: %d\n", udplost);
    printf("Total Sent: %d\n",totalsent);
    printf("Total Dropped: %d\n",totallost);
}
