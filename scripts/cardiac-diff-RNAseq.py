# Data are from Wamstad et al 2012
# CMdiff_RNAseq.txt in "C:/Users/bioch/projects/classes/data"
# current file location "C:/Users/bioch/projects/classes/scripts/"
# 4 stages of mouse cells treated in vitro:
# ESC: embryonic stem cell (day 0)
# MES: mesoderm (day 4)
# CP: cardiac progenitors (day 5.3)
# CM: cardiomyocytes (day 10)
# RPKM is a normalized way to measure expression level (ESC.RPKM, MES.RPKM, ...)

# all functions associated with regex in Python are in the "re" module
import re

# re.search(pattern, string) takes a regex pattern preceded by r.
# re.search(pattern, string) returns a MatchObject depending on whether a
# match has been found - this can be used in an if statement for control flow:
myPattern = re.search(r"(\S+)\s(MIT_\S+)\s\S+", string)
if myPattern:    # myPattern True if match found, False otherwise...
    print myPattern.group(1) + myPattern.group(2)
# the MatchObject also contains the parts of the string that were matched
# including groups if they were specified
#myPattern.group(1)
#myPattern.group(2)
# to get the entire string matched, use
#myPattern.group(0)