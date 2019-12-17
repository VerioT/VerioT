        // generate new credential on behalf of resource owner 
        // add to DELEGATOR_RP GCL and  DELEGATEE_RP RCL 
        printf("OPERATION_RP_1 ");
        printf("DELEGATOR_RP DELEGATEE_RP\n");
        newCredential --;
        addItemGCL(DELEGATOR_RP, DELEGATEE_RP, newCredential);
        addItemRCL(DELEGATEE_RP, newCredential);
        
        ACVOPERATION_RP = 1;
