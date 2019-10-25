BEGIN{
	count=0;
}
{
	event=$1;
	if(event=="d")
	{
		count++;
	}
}
END{
	printf("no of packets dropped = %d\n",count);
}
