(delegator, delegatee, device){
    atomic{
        earseArray(medialRights);
        mapDevicetoRecvTokens(delegator, device, medialRights);
        
        if 
            :: medialRights.index == 0 ->
                printf("\nWrong parameter in share2(%d,%d,%d): No mapped recvdToken found!\n", delegator, delegatee, device);
                myOwnErrorFlag = true;
            :: else -> skip;
        fi;
        
        newToken --;
        addItemACL(delegator, delegatee, newToken, medialRights);
        addItemRecv(delegatee, newToken, device);
        
        short indexshare2_1 = 0;
        do
            :: indexshare2_1 < Recvs[delegator].index ->
                addItemRecv(delegatee, Recvs[delegator].recvdToken[indexshare2_1], Recvs[delegator].orignalDev[indexshare2_1]);
                indexshare2_1 ++;
            :: else -> break;
        od;
    }
}