'''
Created on 8 Nov 2013

@author: samgeen
'''

import ramses
import threading

class RamsesThread(threading.Thread):
    def __init__(self, sim):
        '''
        sim - Simulation object, as below
        '''
        threading.Thread.__init__(self)
        self._sim = sim
        
    def run(self):
        try:
            ramses.run()
        except:
            print "RAMPY FAILS"


class Simulation(object):
    '''
    A Rampy Simulation
    NOTE that this isn't a Hamu simulation object - be careful with namespace fighting!
    '''
    
    def __init__(self, name, location):
        '''
        Constructor
        name - String containing the simulation's name
        location - String containing the simulation's file path
        '''
        self._name = name
        self._location = location
        
    def Name(self):
        return self._name
        
    def Run(self):
        print threading.activeCount()
        thread = RamsesThread(sim)
        try:
            thread.start()
        except:
            print "Son, you done goobered up the threads"
        # Can do other stuff here
    
if __name__=="__main__":
    sim = Simulation("TestSim", ".")
    sim.Run()