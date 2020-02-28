(delegator, delegatee, device){
    atomic{
        earseArray(medialRights);
        mapDevicetoRecvTokens(delegator, device, medialRights);
        
        short indexunOAuth1_1 = 0;
        markedIteminACLs = 0;
        do 
            :: indexunOAuth1_1 < ACLs[delegator].index ->
                if 
                    :: delegatee == ACLs[delegator].issuedToWhom[indexunOAuth1_1] ->
                        isList1inList2(ACLs[delegator].accessRightLists[indexunOAuth1_1], medialRights);
                        if
                            :: isList1inList2Bool == true ->
                                ACLs[delegator].issuedToken[indexunOAuth1_1] = 0;
                                markedIteminACLs ++;
                            :: else -> skip;
                        fi;
                    :: else -> skip;
                fi;
                
                indexunOAuth1_1 ++;
            :: else -> break;
        od;
        delMarkedItemsinACLs(delegator, markedIteminACLs);
    }
}