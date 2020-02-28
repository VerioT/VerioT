(delegator, delegatee){
    atomic{
        indexunbind1 = 0;
        markedIteminACLs = 0;
        
        do
            :: indexunbind1 < ACLs[delegator].index ->
                if 
                    :: ACLs[delegator].issuedToWhom[indexunbind1] == delegatee ->
                        ACLs[delegator].issuedToken[indexunbind1] = 0;
                        markedIteminACLs ++;
                        break;
                    :: else -> skip;
                fi;
                indexunbind1 ++;
            :: else -> 
                printf("\nWrong parameter in unbind1_1(%d,%d): No tokend issued from %d to %d!\n", delegator, delegatee, delegator, delegatee);
                myOwnErrorFlag = true;
                break;
        od;
        delMarkedItemsinACLs(delegator, markedIteminACLs);
    }
}
