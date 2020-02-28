
#define MAXPATHNUM 20

typedef accessRightList{
    short accessRight[MAXTOKENNUM];
    short index = 0;
}

typedef ACL{
    short issuedToken[MAXTOKENNUM];
    short issuedToWhom[MAXTOKENNUM];
    accessRightList accessRightLists[MAXTOKENNUM];
    short index = 0;
}

typedef Recv{
    short recvdToken[MAXTOKENNUM];
    short orignalDev[MAXTOKENNUM];
    short index = 0;
}

typedef path{
    short node[MAXENITYNUM];
    short length = 0;
    bool accessPathFlag = false;
}

ACL ACLs[MAXENITYNUM];
Recv Recvs[MAXENITYNUM];
path paths[MAXPATHNUM];
bool usedNodes[MAXENITYNUM];
short resultNodes[MAXENITYNUM];
bool block[MAXENITYNUM];
short medialNodes[MAXENITYNUM];
Recv mappedTokens;
accessRightList medialTokenset;

short newToken = 0 - MAXENITYNUM;
bool myOwnErrorFlag = false;
accessRightList emptyRights;
accessRightList medialRights;
short indexmap = 0;
short index_addArraytoArray = 0;
bool isList1inList2Bool = false;
bool isIteminListBool = false;
short indexisList1inList2 = 0;
short indexisIteminList = 0;
short markedIteminACLs = 0;
short numofValidIteminACLs = 0;
short indexearseACLsStartingfromIndex = 0;
short currentIndexforCopy = 0;
short irrIndexdelMarkedItemsinACLs = 0;
short irrIndexearseArray = 0;
short indexaddItemRecv = 0;
short staticToken = 0 - MAXENITYNUM;
short indexaddItemACL = 0;
short intfactorial = 1;
short hop = MAXENITYNUM - 2;
short permutation1 = 0;
short permutation2 = 0;
short intsumpermutation = 0;
short sumpermutation1 = 0;
short pathNum = 0;
short indexearsePaths = 0;
short irrNode = 0;
short pathIndex = 0;
short irrHop = 1;
short indexearseTempdata = 0;
short indexstoreThePath = 0;
short indexMedialnodes = 0;
short irrEntity = 0;
short indexcalAllAccessPaths = 0;
short irrPrintAPath = 0;
short irrparaRecv = 0;
short isTokeninACLFlag = false;
short irrparaACL = 0;
short irrPaths = 0;
short indexunshare1 = 0;
short indexprintPaths = 0;
short irrPathNode = 0;
short indexGetMappedtokens = 0;
short indexGetMappedtokensACL = 0;
short indexPrintMappedTokens = 0;
short indexgetMappedtokens = 0;
short indexsetTrigger1 = 0;
short indexAPIRequest1 = 0;
short indexunbind1 = 0;
