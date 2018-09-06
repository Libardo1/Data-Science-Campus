
## Import Regex module
import re

## Intro
#phoneNumRegex = re.compile(r'\d{3}-\d{3}-\d{4}')
#mo = phoneNumRegex.search('My number is 415-555-4242.')
#print('Phone number found: ' + mo.group())

phoneNumRegex = re.compile(r'(\d{3})-(\d{3}-\d{4})')
mo = phoneNumRegex.search('My number is 415-555-4242.')
mo.group(1)
mo.group(2)
mo.group()
mo.groups()

areaCode, mainNumber = mo.groups()

## Optional matching with the Question mark
batRegex = re.compile(r'Bat(wo)?man')
mo1 = batRegex.search('The Adventures of Batman')
mo1.group()

mo2 = batRegex.search('The Adventures of Batwoman')
mo2.group()

## Matching zero or more with the star
batRegex = re.compile(r'Bat(wo)*man')
mo1 = batRegex.search('The Adventures of Batman')
mo1.group()

mo2 = batRegex.search('The Adventures of Batwoman')
mo2.group()

mo3 = batRegex.search('The Adventures of Batwowowowoman')
mo3.group()

## Matching one or more with the Plus
batRegex = re.compile(r'Bat(wo)+man')
mo1 = batRegex.search('The Adventures of Batman')
#mo1.group()      ## Returns ERROR -> AttributeError: 'NoneType' object has no attribute 'group'
mo1 == None

mo2 = batRegex.search('The Adventures of Batwoman')
mo2.group()

mo3 = batRegex.search('The Adventures of Batwowowowoman')
mo3.group()

## Greedy and Nongreedy matching
greedyHaRegex = re.compile(r'(Ha){3,5}')

mo1 = greedyHaRegex.search('HaHaHaHaHa')
mo1.group()

nongreedyHaRegex = re.compile(r'(Ha){3,5}?')

mo2 = nongreedyHaRegex.search('HaHaHaHaHa')
mo2.group()

## The Wildcard Character
atRegex = re.compile(r'.at')

atRegex.findall('The cat in the hat sat on the flat mat.')

####################################
## Match Everything with Dot-Star
####################################
nameRegex = re.compile(r'First Name: (.*) Last Name: (.*)')
mo = nameRegex.search('First Name: Al Last Name: Sweigart')

mo.group(1)
mo.group(2)
mo.group()

## Nongreedy fashion
nongreedyRegex = re.compile(r'<.*?>')
mo = nongreedyRegex.search('<To serve man> for dinner.>')
mo.group()

## Greedy fashion
greedyRegex = re.compile(r'<.*>')
mo = greedyRegex.search('<To serve man> for dinner.>')
mo.group()

##################################
## Case-Insensetive Matching
##################################
robocop = re.compile(r'robocop', re.I)
robocop.search('RoboCop is part man, part machine, all cop.').group()
robocop.search('ROBOCOP protects the innocent.').group()
robocop.search('Al, why does your programming book talk about robocop so much?').group()

















