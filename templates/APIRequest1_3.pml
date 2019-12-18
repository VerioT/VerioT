        // generate new whitelistID in PHILIPSHUEBULB GCL and USERTHIRDCLOUD RCL PHILIPSHUEUESER RCL 
        printf("APIRequest1_3 ");
        printf("DELEGATEEUESER DELEGATORCLOUD\n");
        newCredential --;
        addItemGCL(PHILIPSHUEBULB, USERTHIRDCLOUD, newCredential);
        addItemRCL(USERTHIRDCLOUD, newCredential);
        addItemRCL(PHILIPSHUEUESER, newCredential);
        
        // generate new OAuth token in PHILIPSHUECLOUD GCL and USERTHIRDCLOUD RCL PHILIPSHUEUESER RCL 
        newCredential --;
        addItemGCL(PHILIPSHUECLOUD, USERTHIRDCLOUD, newCredential);
        addItemRCL(USERTHIRDCLOUD, newCredential);
        addItemRCL(PHILIPSHUEUESER, newCredential);
        
        ACVAPIRequest1 = 1;

