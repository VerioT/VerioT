(Reqfrom, Reqto){
    atomic{
        indexAPIRequest1 = 0;
        do
            :: indexAPIRequest1 < Recvs[Reqto].index ->
                addItemRecv(Reqfrom, Recvs[Reqto].recvdToken[indexAPIRequest1], Recvs[Reqto].orignalDev[indexAPIRequest1]);
                indexAPIRequest1 ++;
            :: else -> break;
        od;
    }
}