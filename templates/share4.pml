(delegator, delegatee, device){
    atomic{
        // device
        newToken --;
        addItemACL(device, delegatee, newToken, emptyRights);
        addItemRecv(delegatee, newToken, device);
        addItemRecv(delegator, newToken, device);
        
        // cloud 
        earseArray(medialRights);
        medialRights.accessRight[0] = newToken;
        medialRights.index = 1;
        newToken --;
        addItemACL(delegator, delegatee, newToken, medialRights);
        addItemRecv(delegatee, newToken, device);
    }
}