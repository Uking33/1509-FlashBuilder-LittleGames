package
{
	import flash.display.Sprite;
	public class Ai
	{
		static public var collisionSide:String="No collision";

		public function Ai()
		{
			
		}
		
		public static function checkGround(r:GameObject,x1:int,x2:int,y1:int,y2:int,iscenter:Boolean=false,isbounce:Boolean=false):Boolean
		{
			var check:Boolean= false;
			if(iscenter)
			{
				r.x-=r.width;
				r.y-=r.height;
			}
			if (r.x<x1)
			{
				if(isbounce)r.vx*=r.bounce;
				r.x=x1;
				collisionSide="Left";
				check=true;
			}
			if (r.y<y1)
			{
				if(isbounce)r.vy*=r.bounce;
				r.y=y1;
				collisionSide="Top";
				check=true;
			}
			if (r.x+r.width>x2)
			{
				if(isbounce)r.vx*=r.bounce;
				r.x=x2-r.width;
				collisionSide="Right";
				check=true;
			}
			if (r.y+r.height>y2)
			{
				if(isbounce)r.vy*=r.bounce;
				r.y=y2-r.height;
				collisionSide="Bottom";
				check=true;
			}
			return check;
		}
		
		public static function straight(r:GameObject,isrotate:Boolean=false,rotatespeed:int=0):void
		{
			r.x+=r.vx;
			r.y+=r.vy;
			if(isrotate)
			{
				if(r.rotation+rotatespeed>180)
					r.rotation=-180+(r.rotation+rotatespeed-180);
				else r.rotation+=rotatespeed;				
			}
		}
		
		public static function around(aroundThing:GameObject,bearoundThing:GameObject, mouseX:Number, mouseY:Number,radius:Number,aroundThingCenter:Boolean=false,bearoundThingCenter:Boolean=false):void
		{
			var vx:Number=bearoundThing.x-mouseX;
			var vy:Number=bearoundThing.y-mouseY;
			var angle:Number=Math.atan2(vy,vx);
			if(!aroundThingCenter) 
			{
				vx-=aroundThing.width/2;
				vy-=aroundThing.height/2;
			}
			aroundThing.x=bearoundThing.x+((-radius)*Math.cos(angle));
			aroundThing.y=bearoundThing.y+((-radius)*Math.sin(angle));	
			if(!bearoundThingCenter) 
			{
				aroundThing.x+=bearoundThing.width/2;
				aroundThing.y+=bearoundThing.height/2;
			}		
		}		
		
		public static function follow(r1:GameObject,r2:GameObject,RANGE:Number,TURN_SPEED:Number,SPEED:Number,r1isCenter:Boolean=false,r2isCenter:Boolean=false):void
		{
			//计算距离
			var vx:Number=r2.x-r1.x;
			var vy:Number=r2.y-r1.y;
			var distance:Number=Math.sqrt(vx*vx+vy*vy);
			if(distance<=RANGE)
			{
				//计算要移动多远
				var move_X:Number=TURN_SPEED*vx/distance;
				var move_Y:Number=TURN_SPEED*vy/distance;
				//增加速度
				r1.vx+=move_X;
				r1.vy+=move_Y;
				//计算移动距离
				var moveDistance:Number=Math.sqrt(r1.vx*r1.vx+r1.vy*r1.vy);
				//缓动
				r1.vx=SPEED*r1.vx/moveDistance;
				r1.vy=SPEED*r1.vy/moveDistance;
				//旋转
				var Angle:Number=Math.atan2(r1.vy,r1.vx);
				r1.rotation=Angle*180/Math.PI;
			}
			else 
			{
				vx=0;
				vy=0;
			}
			//摩擦
			r1.vx*=r1.friction;
			r1.vy*=r1.friction;
			//移动
			r1.x+=r1.vx;
			r1.y+=r1.vy;
		}
	}
}