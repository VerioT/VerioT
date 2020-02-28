(delegator, delegatee, device){
    atomic{
        indexsetTrigger1 = 0;
        do
            :: indexsetTrigger1 < Recvs[delegatee].index ->
                if
                    :: Recvs[delegatee].orignalDev[indexsetTrigger1] < DEVICENUM -> 
                        addItemRecv(delegator, Recvs[delegatee].recvdToken[indexsetTrigger1], Recvs[delegatee].orignalDev[indexsetTrigger1]);
                    :: else -> skip;
                fi;
                indexsetTrigger1 ++;
            :: else -> break;
        od;
        
        earseArray(medialRights);
        mapDevicetoRecvTokens(delegator, device, medialRights);
        
        if 
            :: medialRights.index == 0 ->
                printf("\nWrong parameter in setTrigger1(%d,%d,%d): No mapped recvdToken found!\n", delegator, delegatee, device);
                myOwnErrorFlag = true;
            :: else -> skip;
        fi;
        
        newToken --;
        addItemACL(delegator, delegatee, newToken, medialRights);
        addItemRecv(delegatee, newToken, device);
    }
}