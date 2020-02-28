(delegator, delegatee, device){
    atomic{
        earseArray(medialRights);
        mapDevicetoRecvTokens(delegator, device, medialRights);
        
        if 
            :: medialRights.index == 0 ->
                printf("\nWrong parameter in share1(%d,%d,%d): No mapped recvdToken found!\n", delegator, delegatee, device);
                myOwnErrorFlag = true;
            :: else -> skip;
        fi;
        
        newToken --;
        addItemACL(delegator, delegatee, newToken, medialRights);
        addItemRecv(delegatee, newToken, device);
    }
}
