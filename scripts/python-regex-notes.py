def myfunction(x,y):
    z = x + y
    return z
    
print myfunction(2,3)

# indentation is required for functions, conditionals, flow control
x = 7
if x < 6:
    print "x is greater than 5"
    print x
    
# indexing starts at zero    
for i in range(0,6):
    print i
    print 2*i
    
# Regex special characters (must be escaped): .^$*+?{}[]\|()
# \ escape
# . anything
# | or

# Regex anchors
# ^ start
# $ end

#Regex grouping
# [Brackets] specify a group to extract
# (Parentheses) specify a whole group to match


# Regex special sequences:
# \s any whitespace
# \S any non-whitespace
# \d any decimal digit
# \D any non-digit
# \w any alphanumeric or underscore character [A-Za-z0-9_]
# \W any non-alphanumeric character
# \n newline
# \t tab


# Regex Quantifiers:
# * 0 or more characters
# + 1 or more characters
# ? 0 or 1 characters
# {Braces} specify an exact number or range of numbers of characters/grouns to match
# i.e. [MITx]{2,4} will match 2, 3, or 4 characters M, I, T or x

# Note regexs are greedy by default: they will match as many characters as they can if they get the chance, unless they have ? which makes them minimal
# <.*> matches ALL of <p>test</p> instead of just <p> and </p> - <.*>? will match the second set instead

# Q: Which of these patterns will match the whole string "Bio"?
# YES: (Bio)
# NO: [Bio], [bio] - individual letters, second has no B
# NO: (bio) - case sensitive

# Q: Which of these patterns will register a match of any size for the string "biology"?
# YES: biology, [a-z]+, [a-z]?, (Bio)* - the last one because 0 is any times
# NO: (Biology)+ - requires one or more

# Q: Which of these patterns will match all of the string "biology"?
# YES: biology, [a-z]+
# NO: (Biology)+, [a-z]? (Bio)*

# Q: Which of these patterns will match all of the string "Bio"?
# YES: [Bio]{3}, [Bio]{1,5}
# NO: [bio]{3}, (bio){2}

# Q: Which of these patterns will match any of "Biology = 5Xfun!"?
# YES:\d+, \S+, \s\S\s\S, \S+\s\S+\s\S+
# NO: \s\S\s\s, \w\W\w\W

# Q: Which of these patterns will match all of "Biology = 5Xfun!"?
# YES:\S+\s\S+\s\S+
# NO:\s\S\s\s, \w\W\w\W, d+, \S+, \s\S\s\S

# Q: What is the shortest regex that will match all of "Biology is cool!"?
# .* 

# Q: Write a regex that matches a row of data in a table with a gene and its genomic coordinates like:
#  "Sox2  chr3  345848926  34551382  +"
# with two spaces between each column and the last character +/-
# \w+\s{2}\w+\s{2}\d+\s{2}\d+\s{2}\W
