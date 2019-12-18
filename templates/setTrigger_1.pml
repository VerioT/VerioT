
        // generate new credential 
        // add to DELEGATEE_RP RCL and  DELEGATOR_RP SCL 
        printf("OPERATION_RP_1 ");
        printf("DELEGATOR_RP DELEGATEE_RP\n");
        newCredential --;
        addItemSCL(DELEGATOR_RP, newCredential);
        addItemRCL(DELEGATEE_RP, newCredential);
        
        setTriggerHidden_1()
        
        ACVOPERATION_RP = 1;
