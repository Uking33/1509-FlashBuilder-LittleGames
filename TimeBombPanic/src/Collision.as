package
{
	import flash.display.Sprite;
	public class Collision
	{
		static public var collisionSide:String="";
		public function Collision()
		{
		}
		static public function block(r1:Sprite,r2:Sprite):void
		{
			var vx:Number=(r1.x+(r1.width))-(r2.x+(r2.width));
			var vy:Number=(r1.y+(r1.height))-(r2.y+(r2.height));
			if(Math.abs(vx)<r1.width/2+r2.width/2)
			{
				if(Math.abs(vy)<r1.height/2+r2.height/2)
				{
					var overlap_X:Number=r1.width/2+r2.width/2-Math.abs(vx);
					var overlap_Y:Number=r1.height/2+r2.height/2-Math.abs(vy);
					if(overlap_X>=overlap_Y)
					{
						if(vy>0)
						{
							collisionSide="Top"
							r1.y=r1.y+overlap_Y;	
						}
						else
						{
							collisionSide="Bottom"
							r1.y=r1.y-overlap_Y;	
						}
					}
					else
					{
						if(vx>0)
						{
							collisionSide="Left"
							r1.x=r1.x+overlap_X;	
						}
						else
						{
							collisionSide="Right"
							r1.x=r1.x-overlap_X;	
						}
					}
				}
				else
				{
					collisionSide="No collision";
				}
			}
			else
			{
				collisionSide="No collision";
			}
		}
	}
}