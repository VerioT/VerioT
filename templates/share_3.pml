        // generate new whitelistID in PHILIPSHUEBULB GCL and  PHILIPSHUEUESER RCL 
        printf("OPERATION_RP_3 ");
        printf("DELEGATOR_RP DELEGATEE_RP\n");
        newCredential --;
        addItemGCL(PHILIPSHUEBULB, PHILIPSHUEUESER, newCredential);
        addItemRCL(PHILIPSHUEUESER, newCredential);
        
        // generate new OAuth token in PHILIPSHUECLOUD GCL and PHILIPSHUEUESER RCL 
        newCredential --;
        addItemGCL(PHILIPSHUECLOUD, PHILIPSHUEUESER, newCredential);
        addItemRCL(PHILIPSHUEUESER, newCredential);
        
        ACVOPERATION_RP = 1;

