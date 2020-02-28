(delegator, delegatee, device){
    atomic{
        earseArray(medialRights);
        mapDevicetoRecvTokens(delegator, device, medialRights);
        
        indexunshare1 = 0;
        markedIteminACLs = 0;
        do 
            :: indexunshare1 < ACLs[delegator].index ->
                if 
                    :: delegatee == ACLs[delegator].issuedToWhom[indexunshare1] ->
                        isList1inList2(ACLs[delegator].accessRightLists[indexunshare1], medialRights);
                        if
                            :: isList1inList2Bool == true ->
                                ACLs[delegator].issuedToken[indexunshare1] = 0;
                                markedIteminACLs ++;
                            :: else -> skip;
                        fi;
                    :: else -> skip;
                fi;
                
                indexunshare1 ++;
            :: else -> break;
        od;
        delMarkedItemsinACLs(delegator, markedIteminACLs);
    }
}