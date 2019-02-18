i = "Unknown"
# Load fileName from temp and then clear temp
fileName = ""
with open('temp', 'r') as myfile:
    fileName=myfile.read().replace('\n', '')
fileName = fileName[1:len(fileName)-2]

print (fileName)
# EUR Base
with open(fileName, 'rb') as f:
    s = f.read()
temp = s.find(b'\x30\x31\x30\x30\x61\x35\x35\x30\x30\x33\x62\x35\x63\x30\x30\x30')
if temp != -1 and temp < 1000:
	i = "0100A55003B5C000"
# EUR Update
temp = s.find(b'\x30\x31\x30\x30\x61\x35\x35\x30\x30\x33\x62\x35\x63\x38\x30\x30')
if temp != -1and temp < 1000:
	i = "0100A55003B5C800"
	
# USA Base
temp = s.find(b'\x30\x31\x30\x30\x62\x37\x64\x30\x30\x32\x32\x65\x65\x30\x30\x30')
if temp != -1and temp < 1000:
	i = "0100B7D0022EE000"
# USA Update
temp = s.find(b'\x30\x31\x30\x30\x62\x37\x64\x30\x30\x32\x32\x65\x65\x38\x30\x30')
if temp != -1and temp < 1000:
	i = "0100B7D0022EE800"

open('temp', 'w').close()
with open('temp', 'a') as tempFile:
    tempFile.write(i)