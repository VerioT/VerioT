

inline printaccessRightList(accessRightList2bePrint){
    atomic{
        short indexPrintaccessRightList = 0;
        printf("\n[")
        do 
            :: indexPrintaccessRightList < accessRightList2bePrint.index ->
                printf("%d, ", accessRightList2bePrint.accessRight[indexPrintaccessRightList]);
                indexPrintaccessRightList ++;
            :: else -> break;
        od;
        printf("]\n");
    }
}

inline printPaths(numerofPaths){
    atomic{
        irrPaths = 0;
        indexprintPaths = 0;
        
        printf("\n %d Paths to be printed\n", numerofPaths);
        
        do
            :: irrPaths < numerofPaths ->
                printf("\nlength is %d, accessable: %d\n", paths[irrPaths].length, paths[irrPaths].accessPathFlag);
                
                printf("[");
                indexprintPaths = 0;
                do 
                    :: indexprintPaths < MAXENITYNUM ->
                        printf("%d ", paths[irrPaths].node[indexprintPaths]);
                        indexprintPaths ++;
                    :: else -> break;
                od;
                printf("]\n");
                
                irrPaths ++;
            :: else -> break;
        od;
    }
}

inline printACL(entity){
    atomic{
        short irrIndex = 0;
        printf("\nACL: (token, toWhom, [right])\n")
        do
            :: irrIndex < ACLs[entity].index ->
                printf("\n(%d, %d,", ACLs[entity].issuedToken[irrIndex],ACLs[entity].issuedToWhom[irrIndex]);
                
                short irrIndex2 = 0;
                printf("[");
                do 
                    :: irrIndex2 < ACLs[entity].accessRightLists[irrIndex].index ->
                        printf("%d,", ACLs[entity].accessRightLists[irrIndex].accessRight[irrIndex2]);
                        irrIndex2 ++;
                    :: else -> break;
                od;
                printf("])\n");
                
                irrIndex ++;
            :: else -> break;
        od;
    }
}

inline printRecv(entity){
    atomic{
        short indexPrintRecv = 0;
        printf("\nRecv: (token, device)\n");
        do
            :: indexPrintRecv < Recvs[entity].index ->
                printf("(%d,%d)\n", Recvs[entity].recvdToken[indexPrintRecv],Recvs[entity].orignalDev[indexPrintRecv])
                indexPrintRecv ++;
            :: else -> break;
        od;
    }
}

inline isIteminList(item, list){
    atomic{
        indexisIteminList = 0;
        do
            :: indexisIteminList < list.index ->
                if 
                    :: item == list.accessRight[indexisIteminList] ->
                        isIteminListBool = true;
                        goto endOfisIteminList;
                    :: else -> skip;
                fi;
                indexisIteminList ++;
            :: else -> break;
        od;
        isIteminListBool = false;
        
        endOfisIteminList:
            skip;
    }
}

inline isList1inList2(list1, list2){
    atomic{
        indexisList1inList2 = 0;
        do
            :: indexisList1inList2 < list1.index ->
                isIteminList(list1.accessRight[indexisList1inList2], list2);
                if 
                    :: isIteminListBool == false ->
                        isList1inList2Bool = false;
                        goto endOfisList1inList2;
                    :: else -> skip;
                fi;
                
                indexisList1inList2 ++;
            :: else -> break;
        od;
        isList1inList2Bool = true;
        endOfisList1inList2:
            skip;
    }
}

// add array2 to array1
inline addArraytoArray(array1, array2){
    atomic{
        
        if
            :: array1.index + array2.index >= MAXTOKENNUM -> 
                printf("Exceed MAXTOKENNUM when addArraytoArray \n"); 
                myOwnErrorFlag = true;
            :: else -> skip;
        fi;
        
        index_addArraytoArray = 0;
        do :: index_addArraytoArray < array2.index -> 
                isIteminList(array2.accessRight[index_addArraytoArray], array1);
                if 
                    :: isIteminListBool == false ->
                        array1.accessRight[array1.index] = array2.accessRight[index_addArraytoArray];
                        array1.index ++;
                    :: else -> skip;
                fi;
                index_addArraytoArray ++;
           :: else -> break;
        od;
    }
}

inline earseArray(array){
    atomic{
        irrIndexearseArray = 0;
        
        do
            :: irrIndexearseArray < MAXTOKENNUM ->
                array.accessRight[irrIndexearseArray] = 0;
                irrIndexearseArray ++;
            :: else -> break;
        od;
        
        array.index = 0;
    }
}

inline copyArraytoArray(array1, array2){
    atomic{
        earseArray(array1);
        addArraytoArray(array1, array2);
    }
}

inline addItemACL(delegator, delegatee, token, right){
    atomic{
        if
            :: delegatee < 0 || delegatee > MAXENITYNUM || delegator < 0 || delegator > MAXENITYNUM ->
                printf("\nWrong parameter in addItemACL(%d,%d,*,[*])\n",delegator,delegatee);
                myOwnErrorFlag = true;
            :: ACLs[delegator].index >= MAXTOKENNUM -> 
                printf("Exceed MAXTOKENNUM when adding token in ACLs[%d] \n", delegator); 
                myOwnErrorFlag = true;
            :: else -> skip;
        fi;

        indexaddItemACL = 0;
        do
            :: indexaddItemACL < ACLs[delegator].index ->
                if 
                    :: token == ACLs[delegator].issuedToken[indexaddItemACL] && delegatee == ACLs[delegator].issuedToWhom[indexaddItemACL] ->
                        addArraytoArray(ACLs[delegator].accessRightLists[indexaddItemACL], right);
                        goto endofaddItemACL;
                    :: else -> skip;
                fi;
                indexaddItemACL ++;
            :: else -> break;
        od;

        ACLs[delegator].issuedToken[ACLs[delegator].index] = token;
        ACLs[delegator].issuedToWhom[ACLs[delegator].index] = delegatee;
        addArraytoArray(ACLs[delegator].accessRightLists[ACLs[delegator].index], right);
        ACLs[delegator].index ++;
        
        endofaddItemACL:
            skip;
    }
}

inline addItemRecv(delegatee, token, device){
    atomic{
        if
            :: delegatee < 0 || delegatee > MAXENITYNUM || device < 0 || device > MAXENITYNUM ->
                printf("\nWrong parameter in addItemRecv(%d,%d,%d)\n", delegatee, token, device);
                myOwnErrorFlag = true;
            :: Recvs[delegatee].index >= MAXTOKENNUM -> 
                    printf("Exceed MAXTOKENNUM when adding token in Recvs[%d] \n", delegatee); 
                    myOwnErrorFlag = true;
            :: else -> skip;
        fi;
        
        indexaddItemRecv = 0;
        do
            :: indexaddItemRecv < Recvs[delegatee].index ->
                if
                    :: token == Recvs[delegatee].recvdToken[indexaddItemRecv] && device == Recvs[delegatee].orignalDev[indexaddItemRecv] ->
                        goto endofaddItemRecv;
                    :: else -> skip;
                fi;
                indexaddItemRecv ++;
            :: else -> break;
        od;
        
        Recvs[delegatee].recvdToken[Recvs[delegatee].index] = token;
        Recvs[delegatee].orignalDev[Recvs[delegatee].index] = device;
        Recvs[delegatee].index ++;
        
        endofaddItemRecv:
            skip;
    }
}

inline addItemtoArray(item, accessRightList2beAdd){
    atomic{
        if 
            :: accessRightList2beAdd.index >= MAXTOKENNUM ->
                printf("\nExceed MAXTOKENNUM when adding %d addItemtoArray(%d, accessRightList2beAdd)", item, item);
                myOwnErrorFlag = true;
            :: else -> skip;
        fi;
        
        accessRightList2beAdd.accessRight[accessRightList2beAdd.index] = item;
        accessRightList2beAdd.index ++;
    }
}

inline mapDevicetoRecvTokens(delegator, device, returnedAccessRightList){
    atomic{
        indexmap = 0;
        do
            :: indexmap < Recvs[delegator].index ->
                if 
                    :: Recvs[delegator].orignalDev[indexmap] == device ->
                        addItemtoArray(Recvs[delegator].recvdToken[indexmap], returnedAccessRightList);
                    :: else -> skip;
                fi;
                indexmap ++;
            :: else -> break;
        od;
    }
}

inline earseACLsStartingfromIndex(entity, paraindex){
    // paraindex == 0 -> not item left in the ACLs
    // paraindex == 1 -> the first one item left in the ACLs
    // paraindex == N -> the first N items left in the ACLs
    atomic{
        if 
            :: paraindex < 0 || paraindex > MAXTOKENNUM ->
                printf("\nWrong parameter in earseACLsStartingfromIndex(%d,%d): paraindex should >= 0 and <= MAXTOKENNUM(%d) !\n", entity, paraindex, MAXTOKENNUM);
                myOwnErrorFlag = true;
            :: else -> skip;
        fi;
        
        indexearseACLsStartingfromIndex = paraindex;
        do
            :: indexearseACLsStartingfromIndex < MAXTOKENNUM -> 
                ACLs[entity].issuedToken[indexearseACLsStartingfromIndex] = 0;
                ACLs[entity].issuedToWhom[indexearseACLsStartingfromIndex] = 0;
                copyArraytoArray(ACLs[entity].accessRightLists[indexearseACLsStartingfromIndex], emptyRights);
                indexearseACLsStartingfromIndex ++;
            :: else -> break;
        od;
        
        ACLs[entity].index = paraindex;
    }
}

inline delMarkedItemsinACLs(entity, numofMarkedItem){
    atomic{
        numofValidIteminACLs = ACLs[entity].index - numofMarkedItem;
        if
            :: numofValidIteminACLs < 0 ->
                printf("\nWrong parameter in delMarkedItemsinACLs(%d,%d): number of valid item < 0!\n", entity, numofMarkedItem);
                myOwnErrorFlag = true;
            :: else -> skip;
        fi;
        
        currentIndexforCopy = 0;
        irrIndexdelMarkedItemsinACLs = 0;
        
        do
            :: irrIndexdelMarkedItemsinACLs < MAXTOKENNUM ->
                if
                    :: ACLs[entity].issuedToken[irrIndexdelMarkedItemsinACLs] != 0 ->
                        ACLs[entity].issuedToken[currentIndexforCopy] = ACLs[entity].issuedToken[irrIndexdelMarkedItemsinACLs];
                        ACLs[entity].issuedToWhom[currentIndexforCopy] = ACLs[entity].issuedToWhom[irrIndexdelMarkedItemsinACLs];
                        copyArraytoArray(ACLs[entity].accessRightLists[currentIndexforCopy],ACLs[entity].accessRightLists[irrIndexdelMarkedItemsinACLs]);
                        currentIndexforCopy ++;
                        if 
                            :: currentIndexforCopy >= numofValidIteminACLs -> break;
                            :: else -> skip;
                        fi;
                    :: else -> skip;
                fi;
                irrIndexdelMarkedItemsinACLs ++;
            :: else -> break;
        od;
        
        if
            :: currentIndexforCopy < numofValidIteminACLs ->
                printf("Something went wrong! delMarkedItemsinACLs(%d,%d), not enough valid item found: only %d of %d found\n",entity, numofMarkedItem,currentIndexforCopy,numofValidIteminACLs);
                myOwnErrorFlag = true;
            :: else -> skip;
        fi;
        
        earseACLsStartingfromIndex(entity, numofValidIteminACLs);
    }
}

inline factorial(n, result){
    atomic{
        intfactorial = 1;
        result = 1;
        do
            :: intfactorial <= n ->
                result = result * intfactorial;
                intfactorial ++;
            :: else -> break;
        od;
    }
}

inline permutation(n,m,result){
    atomic{
        if
            :: n < m ->
                printf("Wrong parameter permutation(%d,%d,*)\n",n,m);
                myOwnErrorFlag = true;
            :: else -> skip;
        fi;
        
        factorial(n, permutation1);
        factorial(n-m, permutation2);
        result = permutation1 / permutation2;
    }
}

inline sumpermutation(n, result){
    atomic{
        intsumpermutation = 0;
        result = 0;
        do 
            :: intsumpermutation <= n ->
                permutation(n, intsumpermutation, sumpermutation1);
                result = result + sumpermutation1;
                intsumpermutation ++;
            :: else -> break;
        od;
    }
}

inline earsePaths(){
    atomic{
        indexearsePaths = 0;
        do
            :: indexearsePaths < MAXPATHNUM ->
                paths[indexearsePaths].length = 0;
                paths[indexearsePaths].accessPathFlag = false;
                
                irrNode = 0;
                do
                    :: irrNode < MAXENITYNUM ->
                        paths[indexearsePaths].node[irrNode] = -1;
                        irrNode ++;
                    :: else -> break;
                od;
                
                indexearsePaths ++;
            :: else -> break;
        od;
    }
}

inline earseTempdataforPaths(){
    atomic{
        indexearseTempdata = 0;
        do
            :: indexearseTempdata < MAXENITYNUM ->
                usedNodes[indexearseTempdata] = false;
                resultNodes[indexearseTempdata] = 0;
                block[indexearseTempdata] = false;
                indexearseTempdata ++;
            :: else -> break;
        od;
    }
}

inline storeThePath(user, device){
    atomic{
        indexstoreThePath = 0;
        paths[pathIndex].node[0] = user;
        
        do
            :: indexstoreThePath < irrHop ->
                paths[pathIndex].node[indexstoreThePath+1] = medialNodes[resultNodes[indexstoreThePath]];
                indexstoreThePath ++;
            :: else -> break;
        od;
        paths[pathIndex].node[indexstoreThePath+1] = device;
        paths[pathIndex].length = 2 + indexstoreThePath;
        paths[pathIndex].accessPathFlag = false;
        pathIndex ++;
    }
}

inline prepareMedialNodes(user, device){
    atomic{
        indexMedialnodes = 1;
        
        irrEntity = 0;
        do
            :: irrEntity < MAXENITYNUM ->
                if
                    :: irrEntity != user && irrEntity != device ->
                        medialNodes[indexMedialnodes] = irrEntity;
                        indexMedialnodes ++;
                    :: else -> skip;
                fi;
                irrEntity ++;
                
            :: else -> break;
        od;
    }
}

inline generatePaths(user, device){
    atomic{
        earsePaths();
        prepareMedialNodes(user, device);
        
        // user -> device 
        pathIndex = 0;
        paths[pathIndex].node[0] = user;
        paths[pathIndex].node[1] = device;
        paths[pathIndex].length = 2;
        paths[pathIndex].accessPathFlag = false;
        pathIndex ++;
        
        sumpermutation(hop, pathNum);
        
        irrHop = 1;
        do
            :: irrHop <= hop ->
                earseTempdataforPaths();
                run perm(0, user, device);
                block[0] == true;
                block[0] = false;
                irrHop ++;
            :: else -> break;
        od;
    }
}

inline isTokeninACL(paraToken, paraACL){
    atomic{
        isTokeninACLFlag = false;
        irrparaACL = 0;
        do
            :: irrparaACL < paraACL.index ->
                if
                    :: paraACL.issuedToken[irrparaACL] == paraToken ->
                        isTokeninACLFlag = true;
                        break;
                    :: else -> skip;
                fi;
                irrparaACL ++;
            :: else -> break;
        od;
    }
}

inline printAPath(whichPath){
    atomic{
        irrPrintAPath = 0;
        printf("\n counterpath found ");
        do
            :: irrPrintAPath < paths[whichPath].length ->
                printf("%d -> ", paths[whichPath].node[irrPrintAPath]);
                irrPrintAPath ++;
            :: else -> break;
        od;
        printf("\n");
    }
}

inline lastStepinPath(paraRecv, paraACL, whichPath, boolflag){
    atomic{
        irrparaRecv = 0;

        do
            :: irrparaRecv < paraRecv.index ->
                isTokeninACL(paraRecv.recvdToken[irrparaRecv], paraACL);
                if
                    :: isTokeninACLFlag == true ->
                        boolflag = true;
                        paths[whichPath].accessPathFlag = true;
                        printAPath(whichPath);
                        break;
                    :: else -> skip;
                fi;
                
                irrparaRecv ++;
            :: else -> break;
        od;
    }
}

inline addItemMappedTokens(paraToken){
    atomic{
        if
            :: mappedTokens.index >= MAXTOKENNUM ->
                printf("\nExceed MAXTOKENNUM when addItemMappedTokens(%d)", paraToken);
                myOwnErrorFlag = true;
            :: else -> skip;
        fi;
        
        mappedTokens.recvdToken[mappedTokens.index] = paraToken;
        mappedTokens.index ++;
    }
}

inline printMappedTokens(){
    atomic{
    indexPrintMappedTokens = 0;
    //printf("\n MappedTokens begin\n");
    for (indexPrintMappedTokens : 0 .. mappedTokens.index-1){
        printf("%d ", mappedTokens.recvdToken[indexPrintMappedTokens]);
    }
    //printf("\n  MappedTokens end \n");
    }
}

inline getMappedtokens(paraRecv, paraACL){
    atomic{
        // earse the medial Token set
        indexGetMappedtokens = 0;
        do
            :: indexGetMappedtokens < MAXTOKENNUM ->
                medialTokenset.accessRight[indexGetMappedtokens] = 0;
                indexGetMappedtokens ++;
            :: else -> break;
        od;
        medialTokenset.index = 0;
        
        indexGetMappedtokens = 0;
        indexGetMappedtokensACL = 0;
        
        for (indexGetMappedtokens : 0 .. paraRecv.index - 1){
            for (indexGetMappedtokensACL: 0 .. paraACL.index - 1){
                if
                    :: paraRecv.recvdToken[indexGetMappedtokens] == paraACL.issuedToken[indexGetMappedtokensACL] ->
                        addArraytoArray(medialTokenset, paraACL.accessRightLists[indexGetMappedtokensACL]);
                    :: else -> skip;
                fi;
            }
        }
        
        // earse the Mappled Token set
        indexGetMappedtokens = 0;
        do
            :: indexGetMappedtokens < MAXTOKENNUM ->
                mappedTokens.recvdToken[indexGetMappedtokens] = 0;
                indexGetMappedtokens ++;
            :: else -> break;
        od;
        mappedTokens.index = 0;
        
        // copy  medialTokenset to mappedTokens 
        
        indexGetMappedtokens = 0;
        do
            :: indexGetMappedtokens < MAXTOKENNUM && medialTokenset.accessRight[indexGetMappedtokens] != 0 ->
                addItemMappedTokens(medialTokenset.accessRight[indexGetMappedtokens]);
                indexGetMappedtokens ++;
            :: else -> break;
        od;
    }
    
    //printMappedTokens();
}

inline isAccessPath(whichPath, boolflag){
    atomic{
        // path: user -> device
        
        if
            :: paths[whichPath].length == 2 ->
                lastStepinPath(Recvs[paths[whichPath].node[0]], ACLs[paths[whichPath].node[1]], whichPath, boolflag);
                goto endofisAccessPath;
            :: else -> skip;
        fi;

        
        // path: user -> other actors -> device
        getMappedtokens(Recvs[paths[whichPath].node[0]], ACLs[paths[whichPath].node[1]]);
        
        irrPathNode = 1;
        do
            :: irrPathNode < paths[whichPath].length -2 ->
                getMappedtokens(mappedTokens, ACLs[paths[whichPath].node[irrPathNode+1]]);
                irrPathNode ++;
            :: else -> break;
        od;
        
        lastStepinPath(mappedTokens, ACLs[paths[whichPath].node[paths[whichPath].length-1]], whichPath, boolflag);

        endofisAccessPath:
            skip;
    }
}

inline calAllAccessPaths(user, device, boolflag){
    atomic{
        //if boolflag == true print the path
        
        generatePaths(user, device);
        //printPaths(pathNum+1);
        
        boolflag = false;
        indexcalAllAccessPaths = 0;
        do
            :: indexcalAllAccessPaths < pathNum ->
                isAccessPath(indexcalAllAccessPaths, boolflag);
                indexcalAllAccessPaths ++;
            :: else -> break;
        od;
        
        assert(boolflag == false);
    }
}

init {
    run IoTDelegation();
}

proctype perm(short step, user, device){
    atomic{
        // printf("perm(%d)\n",step);
        
        short index = 0;
        
        if
            :: irrHop < 1 || irrHop > hop ->
                printf("Wrong parameter in perm(***), irrHop(%d) should be 1 <= irrHop <= hop(%d) \n", irrHop, hop);
                myOwnErrorFlag = true;
            :: else -> skip;
        fi;
        
        if
            :: step == irrHop ->
                storeThePath(user, device);
                block[step] = true;
            :: else -> 
                index = 0;
                do
                    :: index < hop ->
                        if 
                            :: usedNodes[index] == false ->
                                // printf("\n-%d-\n",index);
                                usedNodes[index] = true;
                                resultNodes[step] = index + 1;
                                run perm(step + 1,user, device);
                                block[step+1] == true;
                                block[step+1] = false;
                                // printf("\n+%d+\n",index);
                                usedNodes[index] = false;
                            :: else -> skip;
                        fi;
                        index ++;
                    :: else ->
                        block[step] = true;
                        break;
                od;
        fi;
    }
}
