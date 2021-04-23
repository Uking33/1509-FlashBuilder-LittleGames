package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	public class GameObject extends Sprite
	{
		//公共属性
		//x的速度（左减右加），y的速度（上减下加）
		public var vx:Number=0;
		public var vy:Number=0;
		//加速度和上限（0.2配5上限）
		public var accelerationX:Number=0;
		public var accelerationY:Number=0;
		public var speedLimit:Number=5;
		//摩擦力（无摩擦:1;流体:0.94-0.98;超快减速:0.6-0.7）
		public var friction:Number=0.96;
		//弹跳值（1:毫无弹性;-0.7:温和;-1:弹跳十足;<-1:超级弹性;）
		public var bounce:Number=-0.7;
		//重力值（0.3自然）
		public var gravity:Number=0.3;
		//跳跃（isOnGround是否在地面；jumpForce跳跃增加速度,注意拜托加速度）
		public var isOnGround:Boolean=undefined;
		public var jumpForce:Number=-10;
		
		//
		public var Father:int=0;
		public var Son:int=0;
		
		//蜜蜂能力
		public var type:uint;
		public var starMax:uint=5;
		public var starSpeed:Number=5;
		public var starShoutSpeed:Number=200;
		public var attackRange:Number=200;
		public var attackLevel:uint;
		public var attackex:Number=0;
		public var attackexMax:Number=300;
		public var defenseLevel:uint;
		public var defenseex:Number=0;
		public var defenseexMax:Number=300;
		public var turnSpeed:Number=0.3;
		public var speed:Number=3;
		public var searchRange:Number=50;
		public var search_X:Number;
		public var search_Y:Number;
		public var searchLevel:uint;
		public var searchex:Number=0;
		public var searchexMax:Number=300;
		
		public function GameObject(image:DisplayObject,center:Boolean=true)
		{
			//添加图片
			this.addChild(image);
			//居中
			if(center)
			{
				image.x-=image.width/2;
				image.y-=image.height/2;
			}
		}
	}
}