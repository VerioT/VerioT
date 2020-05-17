import sys
import os
import time
import re

def getAssertionNameFromLine(line, assertions):
    for item in assertions:
        if item in line:
            return item
    return ""

depth = "20000" 
###################################################################
######################### Model Generator #########################
###################################################################
print "Generating model..."

# create file for the generated model
modelFileName = "_generatedModel.pml"
if os.path.exists(modelFileName):
    os.remove(modelFileName)
modelFile = open(modelFileName,"a")

configFileName = "_0configuration.txt"
configFile = open(configFileName,"r")

MAXTOKENNUM = 0
MAXENITYNUM = 0
configLine = configFile.readline()
MAXENITYNUM = int(configLine.split()[1])
MAXTOKENNUM = 2 * MAXENITYNUM
modelFile.write("#define MAXENITYNUM " + str(MAXENITYNUM) + "\n")
modelFile.write("#define MAXTOKENNUM " + str(MAXTOKENNUM) + "\n")

DEVICENUM = 0
configLine = configFile.readline()
DEVICENUM = int(configLine.split()[1])
modelFile.write("#define DEVICENUM " + str(DEVICENUM) + "\n")

# names of entities e.g., [PHILIPSBULB PHILIPSCLOUD ...]
EntityList = []  

# map entity name to entity index e.g., {("PHILIPSBULB": 0), ("PHILIPSCLOUD":1)...}
entityIndexList = {}
# map entity index to entity name e.g., {("->": "->"), ("0": "PHILIPSBULB"), ("1": "PHILIPSCLOUD")...}
indexEntityList = {}
indexEntityList["->"] = "->"

entityIndex = 0

for i in range(0, MAXENITYNUM):
    entityName = configFile.readline().split()[0]
    EntityList.append(entityName)
    
    entityIndexList[entityName] = entityIndex
    indexEntityList[str(entityIndex)] = entityName
    entityIndex = entityIndex + 1
modelFile.write("\n")

for i in range(0, MAXENITYNUM):
    modelFile.write("#define " + EntityList[i] + " " + str(i) + "\n")
modelFile.write("\n")

BaseModelBlock1File = open("./BaseModel/BaseModelBlock1.pml", "r")
for line in BaseModelBlock1File:
    modelFile.write(line)
BaseModelBlock1File.close()
modelFile.write("\n")

configLine = configFile.readline()
while "delegation operations" not in configLine:
    configLine = configFile.readline()

deleOperationNum = int(configLine.split()[2])

modelCodesB = ""
modelCodesC = "\n"

# list records the operations ["bind1", "unbind1", ....]
actions = []

deleOperationList = {}
keydeleOperation = 1

parametersofOperations = {}

for i in range(0, deleOperationNum):
    configLine = configFile.readline().split()
    actions.append(configLine[0])
    # odd number are delegation operations
    # even number are undelegation operations
    deleOperationList[keydeleOperation] = []
    for item in configLine:
        deleOperationList[keydeleOperation].append(item)
    keydeleOperation = keydeleOperation + 1
    
    parametersofOperations[configLine[0]] = []
    for item in configLine[2:]:
        parametersofOperations[configLine[0]].append(item)

sorted(deleOperationList.keys())

for key in deleOperationList:
    if not (key % 2 == 0):
        modelCodesB = modelCodesB + "short ACV" + deleOperationList[key][0] + " = 0;\n"

# based on templates to create the operations, e.g., bind1, unbind2, etc.
for key in deleOperationList:
    modelCodesC = modelCodesC + "inline " + deleOperationList[key][0]
    operationName = deleOperationList[key][0][:len(deleOperationList[key][0])-1]
    templateFileName = "./Templates/" + operationName + deleOperationList[key][1] + ".pml"
    templateFile = open(templateFileName, "r")
    
    for line in templateFile:
        modelCodesC = modelCodesC + line
    templateFile.close()
    
    modelCodesC = modelCodesC + "\n\n"

configLine = configFile.readline()
while "assertions" not in configLine:
    configLine = configFile.readline()

assertionNum = int(configLine.split()[1])

# map to record the assetions  key : value
#                    can be more than 1    can be more than 1
#  1  : [unbind1    [PHILIPSUSER, ... ]   [PHILIPSBULB, ...]   ]
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

assertions = []
counterexamplePaths = {}

for key in assertionList:
    assertions.append("VOLFlag" + assertionList[key][0])
    counterexamplePaths["VOLFlag" + assertionList[key][0]] = {}
    
    modelCodesB = modelCodesB + "bool VOLFlag" + assertionList[key][0] + " = false;\n"
    
    modelCodesC = modelCodesC + "\ninline assertion" + assertionList[key][0] + "(){\n"
    modelCodesC = modelCodesC + "    atomic{\n"
    modelCodesC = modelCodesC + "        VOLFlag" + assertionList[key][0] + " = false;\n"

    for delegateeItem in assertionList[key][1]:
        for delegatorItem in assertionList[key][2]:
            modelCodesC = modelCodesC + "        calAllAccessPaths("
            modelCodesC = modelCodesC + delegateeItem + ", "
            modelCodesC = modelCodesC + delegatorItem + ", "
            modelCodesC = modelCodesC + "VOLFlag" + assertionList[key][0] + ");\n"

    modelCodesC = modelCodesC + "    }\n"
    modelCodesC = modelCodesC + "}\n"

modelFile.write(modelCodesB)
BaseModelBlock2File = open("./BaseModel/BaseModelBlock2.pml", "r")
for line in BaseModelBlock2File:
    modelFile.write(line)
BaseModelBlock2File.close()
modelFile.write("\n")

modelFile.write(modelCodesC)

configLine = configFile.readline()
while "operation dependency" not in configLine:
    configLine = configFile.readline()
    
denpendencyNum = int(configLine.split()[2])
if not ( denpendencyNum == deleOperationNum):
    print "wrong configuration at operation dependency\n"
    exit()

noAssertionDelegationNum = int(configLine.split()[3])
#assertionDelegationNum = denpendencyNum - noAssertionDelegationNum

dependencyList1 = {}
keydenpendency1 = 1

for i in range(0, denpendencyNum):
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

modelFile.write("\nproctype IoTDelegation(){\n\
    atomic{\n\
        printf(\"start delegation \\n\");\n\n\
        do")

#print dependencyList1

for key in range(noAssertionDelegationNum):
    denpencyEquations = ""
    denpencyEquations = denpencyEquations + "ACV" + dependencyList1[key+1][0] + " == 0 "
    
    for item in dependencyList1[key+1][1]:
        if item[:2] == "un":
            denpencyEquations = denpencyEquations + "&& ACV" + item[2:] + " == 2 "
        else:
            denpencyEquations = denpencyEquations + "&& ACV" + item + " == 1 "

    modelFile.write("\n            :: " + denpencyEquations + "->\n")
    modelFile.write("                atomic{\n")
    modelFile.write("                    printf(\"" + dependencyList1[key+1][0] + " ")
    
    for item in parametersofOperations[dependencyList1[key+1][0]]:
        modelFile.write(item + " ")
    modelFile.write("\\n\");\n")
    
    modelFile.write("                    " + dependencyList1[key+1][0] + "(")
    parameterString = ""
    for item in parametersofOperations[dependencyList1[key+1][0]]:
        parameterString = parameterString + item + ", "
    parameterString = parameterString[:len(parameterString)-2]
    modelFile.write(parameterString+ ");\n")
    
    modelFile.write("                    ACV" + dependencyList1[key+1][0] + " = 1;\n")
    modelFile.write("                }\n")
      
modelFile.write("\n            :: else -> break;\n")
modelFile.write("        od;\n")
modelFile.write("\n        printf(\"delegation done \\n\");\n")
modelFile.write("    } \n\n")
modelFile.write("    do")

for key in range(noAssertionDelegationNum + 1, denpendencyNum+1):
    denpencyEquations = ""
    if not (dependencyList1[key][0][:2] == "un"):
        denpencyEquations = denpencyEquations + " ACV" + dependencyList1[key][0] + " == 0 &&"
    
    for item in dependencyList1[key][1]:
        if item[:2] == "un":
            denpencyEquations = denpencyEquations + "ACV" + item[2:] + " == 2 && "
        else:
            denpencyEquations = denpencyEquations + " ACV" + item + " == 1 && "

    modelFile.write("\n        ::" + denpencyEquations[:len(denpencyEquations)-3] + "->\n")
    modelFile.write("            atomic{\n")
    modelFile.write("                printf(\"" + dependencyList1[key][0] + " ")
    
    for item in parametersofOperations[dependencyList1[key][0]]:
        modelFile.write(item + " ")
    modelFile.write("\\n\");\n")
    
    modelFile.write("                " + dependencyList1[key][0] + "(")
    parameterString = ""
    for item in parametersofOperations[dependencyList1[key][0]]:
        parameterString = parameterString + item + ", "
    parameterString = parameterString[:len(parameterString)-2]
    modelFile.write(parameterString+ ");\n")
    
    if not (dependencyList1[key][0][:2] == "un"):
        modelFile.write("                ACV" + dependencyList1[key][0] + " = 1;\n")
    else:
        modelFile.write("                ACV" + dependencyList1[key][0][2:] + " = 2;\n")
    
    modelFile.write("                assertion" + dependencyList1[key][0] + "();\n")
    modelFile.write("            }\n")
    
modelFile.write("\n        :: else -> break;\n")
modelFile.write("    od;\n")
modelFile.write("}\n")
    
modelFile.close()
configFile.close()
print "Model generated!"

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

for readableFileName in range(1,errorNumber):
#for readableFileName in range(13,14):
    readableFile = open('./counterexamples/' + str(readableFileName) + '.txt', 'r')
    #print str(readableFileName) + '.txt'
    
    operationExecuted = ""
    attackingPath = ""
    for line in readableFile:
        #print line
        
        if "trail ends" in line: 
            # no further process needed, move to next counterexample
            break
            
        if "text of failed assertion" in line:
            # record the current attackingPath
            # conitue to search for next attackingPath
            assertionName = getAssertionNameFromLine(line, assertions)
            
            if operationExecuted in counterexamplePaths[assertionName].keys():
                if attackingPath not in counterexamplePaths[assertionName][operationExecuted]:
                    counterexamplePaths[assertionName][operationExecuted].append(attackingPath)
            else:
                counterexamplePaths[assertionName][operationExecuted] = []
                counterexamplePaths[assertionName][operationExecuted].append(attackingPath)
                
            continue
        
        if "counterpath found" in line:
            # record the current attackingPath
            # continue to read other line for further process
            line = line.split()
            attackingPath = ""
            for item in line[2:len(line)-1]:
                attackingPath = attackingPath + indexEntityList[item]
                
            continue
        
        line = line.split()
        if len(line) == 0: 
            #line is emplty
            continue
        
        operation = line[0]
        #print operation
        
        if operation in actions:
            operationExecuted = operationExecuted + " " + operation
    
    readableFile.close()


ReportFileName = "_0report.txt"
reportFile = file(ReportFileName, "w+")

for key in counterexamplePaths:
    reportFile.write(key + "\n")
    number = 1
    
    for itemKey in counterexamplePaths[key]:
        reportFile.write(str(number) + ":")
        reportFile.write(itemKey + "\n")
        
        for item in counterexamplePaths[key][itemKey]:
            reportFile.write(item + "\n")
            
        number = number + 1
    
    if number == 1:
        reportFile.write("no flaw with " + key[7:] + "\n")
        
    reportFile.write("\n")
    
reportFile.close()

print "Analyzing done!"
