        // invalidate the token
        // remove the DELEGATEE_RP's token from DELEGATOR_RP's GCL
        printf("OPERATION_RP_1 ");
        printf("DELEGATOR_RP DELEGATEE_RP\n");
        removeItemGCL(DELEGATOR_RP, DELEGATEE_RP);
        
        ACVOPERATION_RP = 2;
