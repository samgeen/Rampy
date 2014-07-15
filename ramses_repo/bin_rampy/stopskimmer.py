'''
Skims Fortran files in this folder for "stop" commands and replaced them
with Python-safe exit commands
Sam Geen, November 2013
'''

import subprocess, re

def TestLine(line):
    '''
    Test a given line for stop commands
    Sorry about the horrible spaghetti logic here!
    '''
    # Is stop in the line?
    linelow = line.lower()
    if " stop" in linelow:
        # Is there actual text after the string? 
        # i.e. is it an isolated STOP command?
        pos = linelow.find("stop")
        if len(line[pos+4:pos+5].strip()) > 0:
            return False
        # DIAGNOSTIC CODE; TO REMOVE
        #print r"   "+line[0:pos]+"|"+line[pos:pos+4]+"|"+\
        #    line[pos+4:pos+5]+"|"\
        #    line[pos+5:len(line)]
        #print len(line[pos+4:pos+5].strip())
        # Does this line have a comment in it?
        if "!" in line:
            pos1 = line.find(r"!")
            pos2 = linelow.find("stop")
            # Is the first instance of stop after a comment?
            if pos1 < pos2:
                return False
            else:
                return True
        # stop is in the line as functional code!
        else:
            return True
    # Nothing found
    return False

def ReplaceLine(line,dolongjump=False):
    '''
    dolongjump - call long_jump instead? (for update_time.f90::clean_stop)
    '''
    funcname = "clean_stop"
    if dolongjump:
        funcname = "long_jump"
    pos = line.lower().find("stop")
    tab = line[0:pos]
    newline = ""
    newline += tab+"!HACK - REPLACED STOP WITH NON-LETHAL ALTERNATIVE\n"
    newline += tab+"!AUTOHACKED BY stopskimmer.py\n"
    newline += tab+"call "+funcname
    newline += tab+"!HACK ENDS"
    return newline

def ProcessFile(oldname, newname):
    '''
    Process a file
    oldname - the old file location (string)
    newname - the new one to update (string)
    '''
    fold = open(oldname,'r')
    filetext = fold.read()
    # Special case where we're calling clean_stop; replace with long_jump
    dolongjump = False
    isupdatetime = "update_time.f90" in oldname
    # Skim through old file if we find stop somewhere in it
    if "stop" in filetext.lower():
        fnew = open(newname,"w")
        lines = filetext.split("\n")
        for line in lines:
            if isupdatetime and "subroutine clean_stop" in line:
                dolongjump = True
            if TestLine(line):
                line = ReplaceLine(line,dolongjump=dolongjump)
                dolongjump = False
            fnew.write(line+"\n")
        fnew.close()
    fold.close()

def run():
    cmd = "find ramses-orig/ -type f"
    p = subprocess.Popen(cmd.split(" "), stdout=subprocess.PIPE, 
                                       stderr=subprocess.PIPE)
    files, err = p.communicate()
    lro = len("ramses-orig/")
    # Run through each file
    for f in files.split("\n"):
        if f[-4:] == ".f90":
            fname = f[lro:]
            oldf = f
            newf = "ramses/"+fname
            ProcessFile(oldf, newf)

if __name__=="__main__":
    run()
