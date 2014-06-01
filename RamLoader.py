'''
Created on 10 Dec 2013

@author: samgeen
'''

import numpy as np
import threading, time, os, sys
import inspect, traceback
import pynbody

class LoaderThread(threading.Thread):
    def __init__(self, func):
        threading.Thread.__init__(self)
        self._func = func
        
    def run(self):
        self._func()
        
class RamData(object):
    '''
    A data-holding that contains the Ramses data read by the visualiser
    '''
    def __init__(self, pos=np.zeros((1,3)), smooth=np.zeros(1), mass=np.zeros(1), path="", time=0.0, outnum=0):
        self.pos = pos
        self.smooth = smooth
        self.mass = mass
        self.path = path
        self.time = time
        self.outnum = outnum

class RamLoader(object):
    '''
    A threaded loading class that returns the latest output on demand
    Fixed to a given fluid field type for simplicity reasons
    '''


    def __init__(self, type = "stars", simpath=""):
        '''
        Constructor
        '''
        # Simple locking variable
        self._lock = False
        # Current hydro type to load
        self._type = type
        # Loading thread
        self._thread = LoaderThread(self._RunInThread)
        # Data currently in memory
        self._latest = RamData()
        # Data being loaded now
        self._beingLoaded = RamData()
        # Current output path
        self._curroutput = ""
        # Flag to keep the thread alive
        self._keepRunning = True
        # Is there new data
        self._newdata = False
        # Simulation path
        if not simpath:
            simpath = os.getcwd()
        self._simpath = simpath
        
    def __del__(self):
        self._thread.Stop()
        
    def GetLatest(self):
        '''
        Get the latest output
        '''
        # Dumb locking mechanism
        while self._lock:
            pass
        self._newdata = False
        return self._latest
    
    def IsNewData(self):
        return self._newdata
    
    def Run(self):
        '''
        Run the loader in a thread
        '''
        print "Starting the loader thread"
        self._keepRunning = True
        self._thread.start()
        
    def Stop(self):
        '''
        Stops the thread
        '''
        print "Stopping the loader thread..."
        self._keepRunning = False
        
    def _RunInThread(self):
        '''
        Run on a loop and load any new data
        '''
        while self._keepRunning:
            # Check for a new output; this function will set the new current output to load
            if self._CheckForNewOutput():
                print "Loading new data from", self._curroutput
                self._LoadNewData()
            # Sleep for a tiny bit to prevent overdoing this loop
            time.sleep(0.01)
        print "Loader thread stopped"
    
    def _CheckForNewOutput(self):
        '''
        Check for new data and sets the current output to that value
        '''
        files = os.listdir(self._simpath)
        f = lambda f: "output_" in f
        outs = [x for x in files if "output_" in x]
        # HACK - READ THE ONE BEHIND TO MAKE SURE THE FILE IS WRITTEN
        if len(outs) <= 1:
            return False
        outs.sort()
        latest = self._simpath+"/"+outs[len(outs)-2]
        # Check that the new output is newer than the current one in memory
        if self._curroutput != latest:
            self._curroutput = latest
            return True
        else:
            return False
        
    def _LoadNewData(self):
        # Load data into pynbody
        print "STARTED LOADING DATA ", self._curroutput
        if len(self._curroutput) == 0:
            print "ABORTING LOADING (No file)"
            return
        ro=pynbody.load(self._curroutput)
        try:
            ro=pynbody.load(self._curroutput)
        except:
            print "ABORTING LOADING (Opening snapshot failed)"
            return
        if self._type == "stars":
            fluid = ro.stars
        elif self._type == "gas":
            fluid = ro.gas
        elif self._type == "dm":
            fluid = ro.dm
        else:
            print "Fluid type",self._type," not recognised! Use stars, gas or dm."
            raise TypeError
        posns = fluid["pos"]
        # No points?
        if len(posns) <= 1:
            print "ABORTING LOADING (No stars)"
            return
        smooth = fluid["smooth"]
        if not type == "gas":
            mass = fluid["mass"]
        else:
            mass = fluid["mass"]*fluid["temp"] # Hacky! Mmm. Basically display thermal energy in an element?
        if type == "dm":
            mass *= 0.1 # Artificially lower the brightness
        # Cut off background gas to save on rendering
        if self._type == "gas":
            cutoff = 1e-3
            lim = mass > cutoff*np.max(mass)
            posns = posns[lim]
            smooth = smooth[lim]
            mass = mass[lim]
        # Process lengths to fit screen
        rescalepoints = False
        if rescalepoints:
            pmin, pmax = (np.min(posns),np.max(posns))
            posns = (posns - pmin) / (pmax - pmin)
            smooth /= (pmax - pmin)
        if smooth.max() <= 0.0:
            smooth *= 0.0
            smooth += 1.0
        else:
            smooth[smooth <= 0.0] = smooth[smooth > 0.0].min()
        cheaprescale = False
        if cheaprescale:
            cheap = fluid["pos"].units
            posns /= cheap
            smooth /= cheap
        posns /= ro._info["boxlen"]
        smooth /= ro._info["boxlen"]
        posns -= 0.5
        #posns -= np.sum(posns,0)/len(posns)
        outnum = self._FindOutNum(self._curroutput)
        time = ro._info["time"]
        # Put into data structures
        self._beingLoaded = RamData(posns, smooth, mass, self._curroutput, time, outnum)
        empty = RamData()
        '''> >>>
        THREAD UNSAFE PART; USES DUMB LOCKING MECHANISM
        DO NOT ADD ANY MAJOR FUNCTIONAL CODE BETWEEN THESE COMMENTS
        '''
        self._lock = True
        self._latest = self._beingLoaded
        self._beingLoaded = empty
        self._newdata = True
        self._lock = False
        '''
        THREAD UNSAFE PART ENDS
        '''
        print "DONE LOADING"
        del ro
        
    def _FindOutNum(self, string):
        '''
        Find the RAMSES output number in a string containing the file path
        '''
        numpos = string.index("output_")+len("output_")
        numstr = string[numpos:numpos+5]
        return int(numstr)
        
if __name__=="__main__":
    loader = RamLoader("gas","/home/samgeen/Programming/MakeWee/workspace/MyGalaxy/")
    loader.Run()
    while 1:
        if loader.IsNewData():
            data = loader.GetLatest()
            print data.path
        time.sleep(1)