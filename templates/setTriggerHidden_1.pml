
inline setTriggerHidden_1(){
    atomic{
        // the DELEGATOR_RP gets read access to the devices in the DELEGATEE_RP
        // add the IDs of devices in DELEGATEE_RP ( 1 or 2 in RCL) to DELEGATOR_RP RCL
        bool deviceDelegatedtoDELEGATEE_RPFlag = false;
        isIteminArray(1, RCLs[DELEGATEE_RP], deviceDelegatedtoDELEGATEE_RPFlag);
        if
            :: deviceDelegatedtoDELEGATEE_RPFlag == true -> addItemRCL(DELEGATOR_RP, 1)
            :: else -> skip;
        fi;
        
        deviceDelegatedtoDELEGATEE_RPFlag = false;
        isIteminArray(2, RCLs[DELEGATEE_RP], deviceDelegatedtoDELEGATEE_RPFlag);
        if
            :: deviceDelegatedtoDELEGATEE_RPFlag == true -> addItemRCL(DELEGATOR_RP, 2)
            :: else -> skip;
        fi;
    }
}
