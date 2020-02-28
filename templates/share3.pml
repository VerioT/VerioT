(delegator, delegatee, device){
    atomic{
        // device
        staticToken = device - MAXENITYNUM;
        //addItemACL(device, delegator, staticToken, emptyRights);
        addItemRecv(delegatee, staticToken, device);
        //addItemRecv(delegator, staticToken, device);
        
        // cloud 
        earseArray(medialRights);
        mapDevicetoRecvTokens(delegator, device, medialRights);
        
        if 
            :: medialRights.index == 0 ->
                printf("\nWrong parameter in share3(%d,%d,%d): No mapped recvdToken found!\n", delegator, delegatee, device);
                myOwnErrorFlag = true;
            :: else -> skip;
        fi;
        
        newToken --;
        addItemACL(delegator, delegatee, newToken, medialRights);
        addItemRecv(delegatee, newToken, device);
    }
}