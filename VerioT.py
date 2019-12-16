import sys
import os
import time
import re

def getAssertionNameFromLine(line, assertions):
    for item in assertions:
        if item in line:
            return item
    return ""
    
# Spin's default number is 9999
# if max depth reached error, increase it
depth = "9999" 


###################################################################
######################### Model Generator #########################
###################################################################
print "Generating model..."

# create file for the generated model
modelFileName = "_0generatedModel.pml"
if os.path.exists(modelFileName):
    os.remove(modelFileName)
modelFile = open(modelFileName,"a")

configFileName = "_0configuration.txt"
configFile = open(configFileName,"r")

MAXCREDENTIALNUM = 0
MAXENITYNUM = 0
EntityList = []
EntityIDList = []

modelFile.write("// definiation of index\n")

configLine = configFile.readline()
MAXENITYNUM = int(configLine.split()[1])
MAXCREDENTIALNUM = 2 * MAXENITYNUM

modelFile.write("//#define MAXENITYNUM " + str(MAXENITYNUM) + "\n")

for i in range(0, MAXENITYNUM):
    deviceName = configFile.readline().split()[0]
    EntityList.append(deviceName)
    EntityIDList.append("ID" + deviceName)

for i in range(0, MAXENITYNUM):
    modelFile.write("#define " + EntityList[i] + " " + str(i) + "\n")

modelFile.write("\n")
modelFile.write("// definiation of ID\n")
for i in range(0, MAXENITYNUM):
    modelFile.write("#define " + EntityIDList[i] + " " + str(i+1) + "\n")

modelFile.write("\n")
modelFile.write("//#define MAXCREDENTIALNUM " + str(MAXCREDENTIALNUM) + "\n")

modelFile.write("\n")

modelFile.write("\n\
// define the data structures to store the credentials\n\
typedef credentialArray1{\n\
        short credentialArray[MAXCREDENTIALNUM];\n\
        short index = 0;\n\
        }\n\
\n\
typedef credentialArray2{\n\
        short credentialArray[MAXCREDENTIALNUM];\n\
        short delegateeArray[MAXCREDENTIALNUM];\n\
        short index = 0;\n\
        }\n\
\n\
credentialArray1 ACLs[MAXENITYNUM];\n\
credentialArray1 RCLs[MAXENITYNUM];\n\
credentialArray1 SCLs[MAXENITYNUM];\n\
credentialArray2 GCLs[MAXENITYNUM];\n\
\n\
short newCredential = 0;\n\
\n\
typedef array1{\n\
        bool order1[MAXENITYNUM];\n\
        }\n\
array1 adjacencyMatrix[MAXENITYNUM];\n\
array1 reachabilityMatrix[MAXENITYNUM];\n\
\n\
typedef array2{\n\
        short entities[MAXENITYNUM];\n\
        short index = 0;\n\
        }\n\
bool myOwnErrorFlag = false\n\
// Action Vabirables (ACV)\n\
")

configLine = configFile.readline()
configLine = configFile.readline()

deleOperationNum = int(configLine.split()[2])
if not (deleOperationNum % 2 == 0):
    print "wrong configuration: deleOperationNum must be an even number"
    exit()

deleOperationList = {}

keydeleOperation = 1

for i in range(0, deleOperationNum):
    configLine = configFile.readline().split()
    # odd number are delegation operations
    # even number are undelegation operations
    deleOperationList[keydeleOperation] = []
    deleOperationList[keydeleOperation].append(configLine[0])
    deleOperationList[keydeleOperation].append(configLine[1])
    deleOperationList[keydeleOperation].append(configLine[2])
    deleOperationList[keydeleOperation].append(configLine[3])
    keydeleOperation = keydeleOperation + 1

sorted(deleOperationList.keys())

"""
print deleOperationList
"""

configLine = configFile.readline()
otherOperationNum = int(configLine.split()[2])

otherOperationList = {}
keyotherOperation = 1
for i in range(0, otherOperationNum):
    configLine = configFile.readline().split()
    otherOperationList[keyotherOperation] = []
    otherOperationList[keyotherOperation].append(configLine[0])
    otherOperationList[keyotherOperation].append(configLine[1])
    otherOperationList[keyotherOperation].append(configLine[2])
    otherOperationList[keyotherOperation].append(configLine[3])
    keyotherOperation = keyotherOperation + 1
    
sorted(otherOperationList.keys())

"""
print otherOperationList
"""

for key in deleOperationList:
    if not (key % 2 == 0):
        modelFile.write("short ACV" + deleOperationList[key][0] + " = 0;\n")

for key in otherOperationList:
    modelFile.write("short ACV" + otherOperationList[key][0] + " = 0;\n")

modelFile.write("\n")

block1FileName = "./baseModel/baseModelBlock1.pml"
block1File = open(block1FileName, "r")

for line in block1File:
    modelFile.write(line)
    
block1File.close()

modelFile.write("\n")

# based on templates to create the operations, e.g., bind1, unbind2, etc.
for key in deleOperationList:
    modelFile.write("inline " + deleOperationList[key][0] + "(){\n")
    modelFile.write("\n")
    modelFile.write("something to do with the templates and " + deleOperationList[key][1] + " "+ deleOperationList[key][2] + " "+ deleOperationList[key][3] + " ")
    modelFile.write("\n")
    modelFile.write("}\n")
    modelFile.write("\n")


for key in otherOperationList:
    modelFile.write("inline " + otherOperationList[key][0] + "(){\n")
    modelFile.write("\n")
    modelFile.write("something to do with the templates and " + otherOperationList[key][1] + " "+ otherOperationList[key][2] + " "+ otherOperationList[key][3] + " ")
    modelFile.write("\n")
    modelFile.write("}\n")

configLine = configFile.readline()
configLine = configFile.readline()

assertionNum = int(configLine.split()[1])

assertionList = {}
keyassertion = 1
for i in range(0, assertionNum):
    assertionList[keyassertion] = []
    assertionList[keyassertion].append(configFile.readline().split()[0])
    
    delegateeTobeTest = []
    configLine = configFile.readline().split()
    for item in configLine:
        delegateeTobeTest.append(item)

    delegatorTobeTest = []
    configLine = configFile.readline().split()
    for item in configLine:
        delegatorTobeTest.append(item)
    
    assertionList[keyassertion].append(delegateeTobeTest)
    assertionList[keyassertion].append(delegatorTobeTest)
    
    keyassertion = keyassertion + 1

sorted(assertionList.keys())

"""
print assertionList
"""

for key in assertionList:
    modelFile.write("\ninline assertion" + assertionList[key][0] + "() {\n")
    modelFile.write("    atomic {\n")
    modelFile.write("        bool VOLFlag" + assertionList[key][0] + " = false;\n")
    modelFile.write("\n")
    modelFile.write("        ACV" + assertionList[key][0][2:] + " == 2 ->\n\
        calreachabilityMatrix();\n\
        //printfMatrix(2); \n\
                \n")
    
    for delegateeItem in assertionList[key][1]:
        for delegatorItem in assertionList[key][2]:
            modelFile.write("        if\n")
            modelFile.write("            :: reachabilityMatrix[" + delegateeItem + "].order1[" + delegatorItem + "] == true ->\n")
            modelFile.write("                VOLFlag" + assertionList[key][0] + " = true;\n")
            modelFile.write("            :: else ->\n")
            modelFile.write("                skip;\n")
            modelFile.write("        fi;\n\n");

    modelFile.write("        assert(VOLFlag" + assertionList[key][0] + " == false);\n")
    modelFile.write("    }\n")
    modelFile.write("}\n")
    
modelFile.write("\n")
modelFile.write("init {\n\
    run IoTDelegation();\n\
}\n\
\n\
proctype IoTDelegation(){\n\
    atomic {\n\
        printf(\"start delegation \\n\");\n\
\n")

configLine = configFile.readline()
denpendencyNum = int(configFile.readline().split()[2])
if not ( denpendencyNum == otherOperationNum + deleOperationNum):
    print "wrong configuration at operation dependency\n"
    exit()

dependencyList1 = {}
keydenpendency1 = 1

for i in range(0, deleOperationNum/2):
    configLine = configFile.readline().split()

    dependencyList1[keydenpendency1] = []
    dependencyList1[keydenpendency1].append(configLine[0])
    
    denpendentOpeationlist = []
    if "NULL" == configLine[1]:
        dependencyList1[keydenpendency1].append(denpendentOpeationlist)
        keydenpendency1 = keydenpendency1 + 1
        continue
        
    for item in configLine[1:]:
        denpendentOpeationlist.append(item)

    dependencyList1[keydenpendency1].append(denpendentOpeationlist)
    keydenpendency1 = keydenpendency1 + 1

sorted(dependencyList1.keys())

for key in dependencyList1:
    denpencyEquations = ""
    denpencyEquations = denpencyEquations + "ACV" + dependencyList1[key][0] + " == 0 "
    
    for item in dependencyList1[key][1]:
        denpencyEquations = denpencyEquations + "&& ACV" + item + " == 1 "
    
    modelFile.write("        if\n")
    modelFile.write("            :: " + denpencyEquations + "-> " + dependencyList1[key][0] + "();\n")
    modelFile.write("            :: else -> skip;\n\
        fi;\n\
\n")

modelFile.write("        printf(\"delegation done \\n\");\n")
modelFile.write("    }\n\n")

dependencyList2 = {}
keydenpendency2 = 1

for i in range(0, deleOperationNum/2):
    configLine = configFile.readline().split()

    dependencyList2[keydenpendency2] = []
    dependencyList2[keydenpendency2].append(configLine[0])
    
    denpendentOpeationlist = []
    if "NULL" == configLine[1]:
        dependencyList2[keydenpendency2].append(denpendentOpeationlist)
        keydenpendency2 = keydenpendency2 + 1
        continue
        
    for item in configLine[1:]:
        denpendentOpeationlist.append(item)

    dependencyList2[keydenpendency2].append(denpendentOpeationlist)
    keydenpendency2 = keydenpendency2 + 1

sorted(dependencyList2.keys())

modelFile.write("    do\n")

for key in dependencyList2:
    denpencyEquations = "        :: "
    for item in dependencyList2[key][1]:
        if "ACV" not in denpencyEquations:
            denpencyEquations = denpencyEquations + "ACV" + item + " == 1 "
        else:
            denpencyEquations = denpencyEquations + "&& ACV" + item + " == 1 "

    modelFile.write(denpencyEquations + "-> " + dependencyList2[key][0] + "();\n")
    
dependencyList3 = {}
keydenpendency3 = 1

for i in range(0, otherOperationNum):
    configLine = configFile.readline().split()

    dependencyList3[keydenpendency3] = []
    dependencyList3[keydenpendency3].append(configLine[0])
    
    denpendentOpeationlist = []
    if "NULL" == configLine[1]:
        dependencyList3[keydenpendency3].append(denpendentOpeationlist)
        keydenpendency3 = keydenpendency3 + 1
        continue
        
    for item in configLine[1:]:
        denpendentOpeationlist.append(item)

    dependencyList3[keydenpendency3].append(denpendentOpeationlist)
    keydenpendency3 = keydenpendency3 + 1

sorted(dependencyList3.keys())

for key in dependencyList3:
    denpencyEquations = "        :: ACV" + dependencyList3[key][0] + " == 0 "
    for item in dependencyList3[key][1]:
        denpencyEquations = denpencyEquations + "&& ACV" + item + " == 1 "
        
    modelFile.write(denpencyEquations + "-> " + dependencyList3[key][0] + "();\n")
    
modelFile.write("        :: else -> break;\n")
modelFile.write("    od;\n")
modelFile.write("\n}\n")

modelFile.close()
configFile.close()
print "Model generated!"

"""
###################################################################
################### Model Checker #################################
###################################################################
errorNumber = 0

# generate verifier
print "\nGenerate verifier..."
os.system("spin -a " + modelFileName)
print "Verifier generated!"

# compile
print "\nCompiling..."
os.system("gcc -DMEMLIM=16384 -DVECTORSZ=4096 -O2 -DXUSAFE -DSAFETY -DNOCLAIM -DBITSTATE -w -o pan pan.c")
print "Compiled!"

# verify (to generate counterexamples)
print "\nGenerating counterexample trails ..."
resultFileName = "_0result.txt"
os.system("./pan -m" + depth + "-E -c0 -e -n > " + resultFileName)
print "Trails done!"

print "\nGenerating readable counterexamples ..."
# transfer the trail files to readable execution path
resultFile = open(resultFileName, "r")
targetStr = "errors: "
for line in resultFile:
    if targetStr in line:
        errorNumber = int(line[line.find(targetStr)+len(targetStr):])
resultFile.close()

if errorNumber == 0:
    print ("no error\n")
    exit()

if not os.path.exists("counterexamples"):
    os.makedirs("counterexamples")

errorNumber = errorNumber + 1
for x in range(1,errorNumber):
    os.system("spin -k ./" + modelFileName + str(x) + ".trail -t ./" + modelFileName + " > ./counterexamples/" +str(x)+ ".txt")
print "Readable counterexamples done!"

###################################################################
################### Analyzer ######################################
###################################################################
print "\nAnalyzing counterexamples..."

actions = ['bind1_1', 'unbind1_4', 'bind2_1', 'unbind2_4', 'OAuth1_1', 'unOAuth1_1', 'share1_1', 'share1_2', 'unshare1_1', 'APIRequest1_1']
assertions = ['VOLFlagunbind1', 'VOLFlagunbind2', 'VOLFlagunOAuth1', 'VOLFlagunshare1']
counterexamplePaths = {'VOLFlagunbind1': [], 'VOLFlagunbind2': [], 'VOLFlagunOAuth1': [], 'VOLFlagunshare1': []}


inNumber = 1
for readableFileName in range(1,errorNumber):
#for readableFileName in range(96,100):
    readableFile = open('./counterexamples/' + str(readableFileName) + '.txt', 'r')
    #print str(readableFileName) + '.txt'
    
    operationExecuted = ""
    
    for line in readableFile:
        #print line
        if "trail ends" in line:
            break
        
        operation = line.split()[0]
        #print operation
        
        if operation not in actions:
            assertionName = getAssertionNameFromLine(line, assertions)
            #print assertionName
            
            if assertionName not in assertions:
                continue
            else:
                if operationExecuted not in counterexamplePaths[assertionName]:
                    counterexamplePaths[assertionName].append(operationExecuted)
                    #print numberbbbb
                    #numberbbbb = numberbbbb + 1
                    continue
                else:
                    #print "already in " + str(inNumber)
                    inNumber = inNumber + 1
        else:
            operationExecuted = operationExecuted + " " + operation
        
    
    readableFile.close()


ReportFileName = "_0report.txt"
reportFile = file(ReportFileName, "w+")

for key in counterexamplePaths:
    counterexamplePaths[key].sort()
    reportFile.write(key + "\n")
    number = 1
    
    for item in counterexamplePaths[key]:
        reportFile.write(str(number) + ":")
        reportFile.write(item + "\n")
        number = number + 1

reportFile.close()

print "Analyzing done!"
"""
