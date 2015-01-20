local class = require 'middleclass' 

local CollisionObject = class("CollisionObject")

function CollisionObject:initialize(go1, go2)
   if go1.id < go2.id then
      self.o1 = go1
      self.o2 = go2
   else
      self.o1 = go2
      self.o2 = go1
   end
   self.unit = {}
   self.unit.x = self.o2.trans.x - self.o1.trans.x
   self.unit.y = self.o2.trans.y - self.o1.trans.y
   local len = math.sqrt(self.unit.x^2+self.unit.y^2)
   self.unit.x = self.unit.x/len
   self.unit.y = self.unit.y/len
end

function CollisionObject:getDeltaVel(id)
   local dv = {}
   local v1,v2,m1,m2,phi,theta1,theta2,currentVel,hardness
   hardness = (self.o1.att["rigidbody"]+self.o2.att["rigidbody"])/2
   if id == self.o1.id then
      v1 = math.sqrt(self.o1.physics.vel.x^2+self.o1.physics.vel.y^2)
      v2 = math.sqrt(self.o2.physics.vel.x^2+self.o2.physics.vel.y^2)
      m1 = self.o1.physics.mass
      m2 = self.o2.physics.mass
      theta1 = math.atan2(self.o1.physics.vel.y,self.o1.physics.vel.x) 
      theta2 = math.atan2(self.o2.physics.vel.y,self.o2.physics.vel.x) 
      currentVel = self.o1.physics.vel
   elseif id == self.o2.id then
      v2 = math.sqrt(self.o1.physics.vel.x^2+self.o1.physics.vel.y^2)
      v1 = math.sqrt(self.o2.physics.vel.x^2+self.o2.physics.vel.y^2)
      m2 = self.o1.physics.mass
      m1 = self.o2.physics.mass
      theta2 = math.atan2(self.o1.physics.vel.y,self.o1.physics.vel.x) 
      theta1 = math.atan2(self.o2.physics.vel.y,self.o2.physics.vel.x) 
      currentVel = self.o2.physics.vel
   else
      print("No id match in CollisionObject->getDeltaVel")
   end
      phi = math.atan2(self.unit.y,self.unit.x)

   local static = ((v1*math.cos(theta1-phi)*(m1-m2)+2*m2*v2*math.cos(theta2-phi))/(m1+m2))

   dv.x =   static*
            math.cos(phi)+v1*math.sin(theta1-phi)*math.cos(phi + math.pi/2)
   
   dv.y =   static*
            math.sin(phi)+v1*math.sin(theta1-phi)*math.sin(phi + math.pi/2)
   dv.x = dv.x - currentVel.x
   dv.y = dv.y - currentVel.y
   dv.x = dv.x *hardness
   dv.y = dv.y *hardness
   return dv
end


return CollisionObject
