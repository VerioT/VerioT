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
modelFileName = "_generatedModel.pml"
if os.path.exists(modelFileName):
    os.remove(modelFileName)
modelFile = open(modelFileName,"a")

# copy the codes in block1Basic to the generatedModel
block1BasicFile = open("./basicCodeBlock/block1Basic.txt","r")
for line in block1BasicFile:
    modelFile.write(line)
block1BasicFile.close()


# copy the codes in block1BasicOptional to the generatedModel
block1BasicOptionalFile = open("./basicCodeBlock/block1BasicOptional.txt","r")
for line in block1BasicOptionalFile:
    modelFile.write(line)
block1BasicOptionalFile.close()


# based on the configuration file to generated the code block2Generated
block2GeneratedFileName = "_block2Generated.pml"
if os.path.exists(block2GeneratedFileName):
    os.remove(block2GeneratedFileName)

block2GeneratedFile = open(block2GeneratedFileName,"a")

configurationFile = open("./configuration/configuration.txt","r")
block2GeneratedFile.write("\n")

for line in configurationFile:
    #print line
    confLine = line.split()
    block2GeneratedFile.write("\ninline " + confLine[0] + "(){\n")
    
    confVariables = confLine[1:]
    #print confVariables
    for item in confVariables:
        tempFileName = "./templates/" + confLine[0] + "_" + item + ".txt"
        tempFile = open(tempFileName,"r")
        for tempLine in tempFile:
            block2GeneratedFile.write(tempLine)
        tempFile.close()
    
    block2GeneratedFile.write("\n}\n")

block2GeneratedFile.write("\n")
block2GeneratedFile.close()

# copy the codes in block2Generated to the generatedModel
block2GeneratedFile = open(block2GeneratedFileName,"r")
for line in block2GeneratedFile:
    modelFile.write(line)
block2GeneratedFile.close()


# copy the codes in block3Basic to the generatedModel
block3BasicFile = open("./basicCodeBlock/block3Basic.txt","r")
for line in block3BasicFile:
    modelFile.write(line)
block3BasicFile.close()

modelFile.close()
print "Model generated!"


###################################################################
################### Model Checker #################################
###################################################################

# generate verifier
print "Generate verifier..."
os.system("spin -a " + modelFileName)
print "Verifier generated!"

# compile
print "Compiling..."
os.system("gcc -DMEMLIM=16384 -DVECTORSZ=4096 -O2 -DXUSAFE -DSAFETY -DNOCLAIM -DBITSTATE -w -o pan pan.c")
print "Compiled!"

# verify (to generate counterexamples)
print "Generating counterexample trails ..."
resultFileName = "_result.txt"
os.system("./pan -m" + depth + "-E -c0 -e -n > " + resultFileName)
print "Trails done!"

print "Generating readable counterexamples ..."
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
print "Analyzing counterexamples..."

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
                    print "already in " + str(inNumber)
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
