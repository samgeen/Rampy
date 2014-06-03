'''
Created on 3 Jun 2014

@author: samgeen
'''

import rampy
import numpy as np


import pyglet
from pyglet.gl import *


class Integrator(object):
    def __init__(self):
        self._glPoints = None
        self._window = pyglet.window.Window(512,512)
        self._window._integrator = self
        self._mx = 0.5
        self._my = 0.5
        
    def Setup(self):
        
        @self._window.event
        def on_draw():
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
            
            glDisable(GL_DEPTH_TEST)
            glLoadIdentity()
            glViewport(0, 0, self._window.width, self._window.height)
            glMatrixMode(GL_PROJECTION)
            glLoadIdentity()
            glOrtho(0,1,0,1,-1,2)
            glMatrixMode(GL_MODELVIEW)
            glLoadIdentity()
            
            glColor4f(1.0,1.0,1.0,0.5)
            pts = rampy.data.xp.flatten()
            self._glPoints = (GLdouble * len(pts))(*pts)
            
            glEnableClientState(GL_VERTEX_ARRAY)
            glVertexPointer(3, GL_DOUBLE, 0, self._glPoints)
            glDrawArrays(GL_POINTS,0,len(pts)//3)
            
        @self._window.event
        def on_mouse_drag(x, y, dx, dy, buttons, modifiers):
            w, h = self._window.get_size()
            x = x/float(w)
            y = y/float(h)
            mx, my = self._mx, self._my
            if x >= 1.0:
                return
            if x <= 0.0:
                return
            if y >= 1.0:
                return
            if y <= 0.0:
                return
            self._mx = x
            self._my = y
        # Initialise sim data
        self._MakeParts()
        rampy.data.init()
        rampy.data.units_time = 1.0/np.sqrt(6.67e-8*rampy.data.units_density)
        # Set up rendering
        s = 0.02
        #glOrtho(-s,+s,-s,+s,-100*s,+100*s)
        glEnable(GL_BLEND)
        glPointSize(2)
        # Set up pyglet to run
        pyglet.clock.set_fps_limit(60)
        pyglet.clock.schedule_interval(self.Step,1.0/60.0)
        pyglet.app.run()
        

    def _MakeCloud(self, nparts):
        # Make a spherical distribution of points
        mean = [0,0,0]
        cov = [[1.0,0,0],[0,1.0,0],[0,0,1.0]]*np.array([0.01])
        points = np.random.multivariate_normal(mean,cov,nparts)
        print "Made points with shape", np.shape(points)
        return points
        
    def _MakeParts(self):
        # Write particle data file
        nparts = 1000
        f = open("ic_part","w")
        cloud = self._MakeCloud(nparts)
        vel = self._MakeCloud(nparts)*0.0
        mass = 1e1
        # Set up principal mouse-following particle
        cloud[0,:] = 0.0
        vel[0,:] = 0.0
        mmouse = 1e6
        for i in range(0,nparts):
            if i == 0:
                m = mmouse
            else:
                m = mass
            f.write(str(cloud[i,0])+" "+
                    str(cloud[i,1])+" "+
                    str(cloud[i,2])+" "+
                    str(vel[i,0])+" "+
                    str(vel[i,1])+" "+
                    str(vel[i,2])+" "+
                    str(m)+"\n")
        f.close()
    
    def Step(self, dt):
        rampy.data.xp[0,0] = self._mx
        rampy.data.xp[0,1] = self._my
        rampy.data.xp[0,2] = 0.5
        rampy.data.vp[0,:] = 0.0
        rampy.data.vp[:,:] *= 0.5**(dt)
        rampy.data.step()
        


if __name__=="__main__":
    int = Integrator()
    int.Setup()
    