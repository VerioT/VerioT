(Reqfrom, Reqto, device, thirdCloud){
    atomic{
        // device
        newToken --;
        addItemACL(device, thirdCloud, newToken, emptyRights);
        addItemRecv(Reqfrom, newToken, device);
        addItemRecv(Reqto, newToken, device);
        
        // cloud 
        earseArray(medialRights);
        medialRights.accessRight[0] = newToken;
        medialRights.index = 1;
        newToken --;
        addItemACL(Reqto, Reqfrom, newToken, medialRights);
        addItemRecv(Reqfrom, newToken, device);
    }
}