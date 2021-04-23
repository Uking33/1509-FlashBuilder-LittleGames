package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.text.*;
	import flash.ui.Keyboard;
	
	[swf(width="550",height="400",backgroundColor="#FFFFFF",framrate="60")]
	
	public class Main extends Sprite
	{
		[Embed(source="../sounds/bounce.mp3")]
		private var Bounce:Class;
		[Embed(source="../sounds/backmusic.mp3")]
		private var Backmusic:Class;
		[Embed(source="../images/star.png")]
		private var StarImage:Class;
		[Embed(source="../images/character.png")]
		private var CharacterImage:Class;
		
		public var bounce:Sound=new Bounce();
		public var backmusic:Sound=new Backmusic();
		private var bounceChannel:SoundChannel=new SoundChannel();
		
		private var stars:Array=new Array();
		private var angle:Number;
		
		private var characterImage:DisplayObject=new CharacterImage;
		private var character:GameObject=new GameObject(characterImage,false);
		
		private var boxes:Array=new Array();
		private var boxPositions:Array=new Array();
		
		
		
		public function Main()
		{
			creatGameObjects();
			setupEventListeners();
		}
		
		public function creatGameObjects():void
		{
			//添加箱子
			boxPositions=[
				          [0,200],
						  [100,100],
						  [100,250],
						  [150,50],
						  [150,250],
						  [200,50],
						  [300,200],
						  [350,150],
						  [400,150],
						  [400,300],
						  [450,150],
						  [450,300],
						  [500,250]];
			for(var i:int=0;i<boxPositions.length;i++)
			{
				var box:Box=new Box();
				addGameObjectToStage(box,boxPositions[i][0],boxPositions[i][1]);
				boxes.push(box);
			}
						  
			
			//添加角色到舞台
			addGameObjectToStage(character,250,170);
			character.bounce=-1;
			character.jumpForce=-15;
			
		}		
		
		
		public function setupEventListeners():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			stage.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			bounceChannel=backmusic.play(0);
			bounceChannel.addEventListener(Event.SOUND_COMPLETE,loopSoundHandler);
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			//创建星星
			var starImage:DisplayObject=new StarImage();
			var star:GameObject=new GameObject(starImage);
			stage.addChild(star);
			//星星起始位置
			star.x=character.x+character.width/2;
			star.y=character.y+character.height/2;
			//设置星星速度
			star.vx=Math.cos(angle)*-7;
			star.vy=Math.sin(angle)*-7;
			//将星星压入stars数组
			stars.push(star);
			
		}
		
		protected function loopSoundHandler(event:Event):void
		{
			if(SoundChannel!=null)
			{
				bounceChannel=backmusic.play(0);
				bounceChannel.addEventListener(Event.SOUND_COMPLETE,loopSoundHandler);
			}
		}
		
		public function addGameObjectToStage(gameObject:Sprite,xPos:int,yPos:int,center:Boolean=false):void
		{
			stage.addChild(gameObject);
			gameObject.x=xPos;
			gameObject.y=yPos;
			if(center)
			{
				gameObject.x+=gameObject.width/2;
				gameObject.y+=gameObject.height/2;
			}
		}
		
		public function enterFrameHandler(event:Event):void
		{
			//鼠标与角色夹角
			angle=Math.atan2(character.y-stage.mouseY,character.x-stage.mouseX);
			//移动星星
			for(var i:int=0;i<stars.length;i++)
			{
				var star:GameObject=stars[i];
				star.x+=star.vx;
				star.y+=star.vy;
				//检测星星舞台边界
				if(star.y<0||star.x<0||star.x>stage.stageWidth||star.y>stage.stageHeight)
				{
					stage.removeChild(star);
					star=null;
					stars.splice(i,1);
					i--;
				}
			}
			
			
			//应用加速度
			character.vx+=character.accelerationX;
			character.vy+=character.accelerationY;
			//限制速度
			if (character.vx<-character.speedLimit)
			{
				character.vx=-character.speedLimit;
			}
			if (character.vx>character.speedLimit)
			{
				character.vx=character.speedLimit;
			}
			/*
			if (character.vy<-character.speedLimit)
			{
				character.vy=-character.speedLimit;
			}
			if (character.vy>character.speedLimit)
			{
				character.vy=character.speedLimit;
			}
			*/
			
			//应用摩擦
			character.vx*=character.friction;
			character.vy*=character.friction;
			//限制摩擦
			if (Math.abs(character.vx)<0.1)
			{
				character.vx=0;
			}
			if (Math.abs(character.vy)<0.1)
			{
				character.vy=0;
			}
			
			//应用重力
			character.vy+=character.gravity;
			
			//移动角色
			character.x+=character.vx;
			character.y+=character.vy;
			//检测边缘舞台（加弹跳+跳跃）
			if (character.x<0)
			{
				character.vx*=character.bounce;
				character.x=0;
			}
			if (character.y<0)
			{
				character.vy*=character.bounce;
				character.y=0;
			}
			if (character.x+character.width>stage.stageWidth)
			{
				character.vx*=character.bounce;
				character.x=stage.stageWidth-character.width;
			}
			if (character.y+character.height>=stage.stageHeight)
			{
				character.isOnGround=true;
				character.vy*=character.bounce;
				character.y=stage.stageHeight-character.height;
			}
			
			//检测与箱子碰撞
			for(var j:int=0;i<boxPositions.length;i++)
			{
				Collision.block(character,boxes[i]);
				if(Collision.collisionSide=="Bottom")
				{
					character.isOnGround=true;
					character.vy=-character.gravity;
				}
				else if(Collision.collisionSide=="Top")
				{
					character.vy=0;
				}
				else if(Collision.collisionSide=="Right"||Collision.collisionSide=="Left")
				{
					character.vx=0;
				}
			}
		}
		
		public function keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.LEFT)
			{
				character.accelerationX=-0.2;
			}
			else if(event.keyCode==Keyboard.RIGHT)
			{
				character.accelerationX=0.2;
			}
			else if(event.keyCode==Keyboard.UP||event.keyCode==Keyboard.SPACE)
			{
				/*
				character.accelerationY=-0.2;
				character.gravity=0*/
				if(character.isOnGround)
				{
					character.vy+=character.jumpForce;
					character.isOnGround=false;
					bounceChannel=bounce.play();
				}
			}
			/*else if(event.keyCode==Keyboard.DOWN)
			{
				character.accelerationY=0.2;
			}*/
		}
		
		public function keyUpHandler(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.LEFT||event.keyCode==Keyboard.RIGHT)
			{
				character.accelerationX=0;
			}
			else if(event.keyCode==Keyboard.UP||event.keyCode==Keyboard.DOWN)
			{
				character.accelerationY=0;
			}
			character.gravity=0.3;
		}
		
	}
}