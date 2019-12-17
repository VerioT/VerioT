        // share IDDELEGATOR_RP with DELEGATEE_RP
        // add IDDELEGATOR_RP to DELEGATOR_RP SCL and DELEGATEE_RP RCL
        printf("OPERATION_RP_1 ");
        printf("DELEGATOR_RP DELEGATEE_RP\n");
        addItemSCL(DELEGATOR_RP, IDDELEGATOR_RP);
        addItemRCL(DELEGATEE_RP, IDDELEGATOR_RP);
        
        ACVOPERATION_RP = 1;
