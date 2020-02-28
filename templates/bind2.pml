(delegator, delegatee){
    atomic{
        newToken --;
        addItemACL(delegator, delegatee, newToken, emptyRights);
        addItemRecv(delegatee, newToken, delegator);
    }
}