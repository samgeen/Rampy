'''
Compiles files for use with rampy
Called by the makefile
Sam Geen, July 2014
'''

import os, sys, shutil
import stopskimmer

def makedir(path):
    try: 
        os.makedirs(path)
    except OSError:
        if not os.path.isdir(path):
            raise

def tempfile(input):
    '''
    Convert a file in a directory to 
    '''
    sep = os.path.sep
    return "temp"+sep+input[input.rfind(sep)+1:]

if __name__=="__main__":
    '''
    Compile the original file with 
    sys.argv[1] is the original file
    sys.argv[2:] is the compiler call
    '''
    # Make temp directory if not already made
    makedir("temp")
    # Copy source file to temp directory
    forig = sys.argv[1]
    ftemp = tempfile(forig)
    shutil.copy(forig, ftemp)
    stopskimmer.ProcessFile(forig,ftemp)
    # Call the compiler command inputted by the user
    call = " ".join(sys.argv[2:])
    call = call.replace(forig, ftemp)
    print "BLAH", call
    os.system(call)
