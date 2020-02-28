(delegator, delegatee){
    atomic{
        staticToken = delegator - MAXENITYNUM;
        addItemACL(delegator, delegatee, staticToken, emptyRights);
        addItemRecv(delegatee, staticToken, delegator);
    }
}