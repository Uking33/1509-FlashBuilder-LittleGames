package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	[swf(width="500",height="400",backgroundColor="#FFFFFF",framrate="30")]
	
	public class Snake extends Sprite
	{
		[Embed(source="../images/SnakeHead.png")]
		private var SnakeHeadImage:Class;
		[Embed(source="../images/SnakeBody.png")]
		private var SnakeBodyImage:Class;
		[Embed(source="../images/SnakeTail.png")]
		private var SnakeTailImage:Class;
		[Embed(source="../images/food1.png")]
		private var  Food1Image:Class;
		[Embed(source="../images/Again.png")]
		private var  AgainImage:Class;
		[Embed(source="../images/Again1.png")]
		private var  Again1Image:Class;
		[Embed(source="../images/background.png")]
		private var  BackgroundImage:Class;
		[Embed(source="../sounds/backmusic.mp3")]
		private var Backmusic:Class;
	//创建文本对象
	public var format:TextFormat=new TextFormat();
	public var output:TextField=new TextField();
	public var output1:TextField=new TextField();
	public var output2:TextField=new TextField();
	
	//创建蛇
	private var snakes:Array=new Array();
	private var snakeheadImage:DisplayObject=new SnakeHeadImage;
	private var snakehead:GameObject=new GameObject(snakeheadImage)
	private var snaketailImage:DisplayObject=new SnakeTailImage;
	private var snaketail:GameObject=new GameObject(snaketailImage)
	public var snakebodyImage:DisplayObject=new SnakeBodyImage;
	public var snakebody:GameObject=new GameObject(snakebodyImage);
	
	//创建背景
	public var backgroundImage:DisplayObject=new BackgroundImage;
	public var background:GameObject=new GameObject(backgroundImage);
	public var againImage:DisplayObject=new AgainImage;
	public var again:GameObject=new GameObject(againImage);
	public var again1Image:DisplayObject=new Again1Image;
	public var again1:GameObject=new GameObject(again1Image);
	
	//游戏变量
	public var vx:int;
	public var vy:int;
	public var eat:uint;
	private var EatFood:Boolean;
	private var eatmax:uint;
	private var addspeed:int;
	private var space:Boolean;
	
	
	private var food1Image:DisplayObject=new Food1Image;
	private var Food1:GameObject=new GameObject(food1Image);
	
	//
	public var timer:Timer;
	public var timerspeed:Timer;
	
	//
	public var backmusic:Sound=new Backmusic();
	private var bounceChannel:SoundChannel=new SoundChannel();
	
		public function Snake()
		{
			makeStage();
			startGame();
		}
		public function makeStage():void
		{	
			//
			vx=0;
			vy=-10;
			eat=0;
			EatFood=false;
			eatmax=10;
			addspeed=1;
			space=false;
			
			//加载背景
			addGameObjectToStage(background,250,200,false);
			
			//加载角色
			snakes.push(snakehead);
			snakes.push(snakebody);
			snakes.push(snaketail);
			snakes[snakes.length-1].rotation=0;
			addGameObjectToStage(snakehead,250,170);
			addGameObjectToStage(snakebody,250,180);
			addGameObjectToStage(snaketail,250,190);
			
			//加载食物
			addFood();
			
			//设置文本格式对象
			format.font="Helvetica";
			format.size=38;
			format.color=0x000000;
			format.align=TextFormatAlign.CENTER;
			
			//设置输出文本框
			output1.defaultTextFormat=format;
			output1.width=200;
			output1.autoSize=TextFieldAutoSize.CENTER;
			output1.border=true;
			output1.background=true;
			output1.backgroundColor=0xFFFFFF;
			output1.alpha=0.8;
			output1.text="0";
			
			//显示并设置输出文本框的位置
			stage.addChild(output1);
			output1.x=235;
			output1.y=7;
			//为键盘添加事件监听器
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			bounceChannel=backmusic.play(0);
			bounceChannel.addEventListener(Event.SOUND_COMPLETE,loopSoundHandler);
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
		public function startGame():void
		{
			if (eat<eatmax)
			{
				timer=new Timer(200/(eatmax/10)/addspeed);
				timer.addEventListener(TimerEvent.TIMER,updateTimeHandler);
				timer.start();
			}
			if (eat==eatmax)
			{
				eatmax*=2;
				starttime();
			}
		}
		
		private function starttime():void
		{
			timer.removeEventListener(TimerEvent.TIMER,updateTimeHandler);
			timer=new Timer(200/(eatmax/10)/addspeed);
			timer.addEventListener(TimerEvent.TIMER,updateTimeHandler);
			timer.start();
		}
		
		protected function loopSoundHandler(event:Event):void
		{
			if(SoundChannel!=null)
			{
				bounceChannel=backmusic.play(0);
				bounceChannel.addEventListener(Event.SOUND_COMPLETE,loopSoundHandler);
			}
		}
		
		protected function updateTimeHandler(event:TimerEvent):void
		{
			if (eat==eatmax)
			{
				eatmax*=2;
				starttime();
			}
			//
			Collision.block(snakes[0],Food1)
			if(Collision.collisionSide=="Top"&&vy<0||Collision.collisionSide=="Bottom"&&vy>0||Collision.collisionSide=="Left"&&vx<0||Collision.collisionSide=="Right"&&vx>0)		
				EatFood=true;
			
			//移动角色
			
			if(EatFood)
			{
				var snakebodyImage:DisplayObject=new SnakeBodyImage;
				var snakebody:GameObject=new GameObject(snakebodyImage);
				snakehead=snakes.shift();
				snakes.unshift(snakebody);
				snakes.unshift(snakehead);		
				addGameObjectToStage(snakebody,snakes[0].x,snakes[0].y);
				addGameObjectToStage(snakehead,snakes[0].x+vx,snakes[0].y+vy);
				stage.addChild(output1);
				stage.removeChild(Food1);
				addFood();
				eat++;
				output1.text=""+eat;
				EatFood=false;
			}
			else
			{
				for(var j:int=snakes.length-1;j>0;j--)
				{
					snakes[j].x=snakes[j-1].x;
					snakes[j].y=snakes[j-1].y;
					stage.addChild(output1);
				}
				snakes[0].x=snakes[0].x+vx;
				snakes[0].y=snakes[0].y+vy;
			}
			
			//尾旋转
			Collision.block(snakes[snakes.length-2],snakes[snakes.length-3]);	
			switch(Collision.collisionSide)
			{
			case "Right":
			{
				Collision.block(snakes[snakes.length-1],snakes[snakes.length-2]);	
				if(Collision.collisionSide=="Bottom")
				{
					snakes[snakes.length-1].rotation=180;
				}
				else if(Collision.collisionSide=="Top")
				{
					snakes[snakes.length-1].rotation=90;
				}
				break;
			}
			case "Left":
			{
				Collision.block(snakes[snakes.length-1],snakes[snakes.length-2]);	
				if(Collision.collisionSide=="Bottom")
				{
					snakes[snakes.length-1].rotation=-90;
				}
				else if(Collision.collisionSide=="Top")
				{
					snakes[snakes.length-1].rotation=0;
				}
				break;
			}
			case "Top":
			{
				Collision.block(snakes[snakes.length-1],snakes[snakes.length-2]);	
				if(Collision.collisionSide=="Right")
				{
					snakes[snakes.length-1].rotation=90;
				}
				else if(Collision.collisionSide=="Left")
				{
					snakes[snakes.length-1].rotation=0;
				}
				break;
			}
			case "Bottom":
			{
				Collision.block(snakes[snakes.length-1],snakes[snakes.length-2]);	
				if(Collision.collisionSide=="Right")
				{
					snakes[snakes.length-1].rotation=180;
				}
				else if(Collision.collisionSide=="Left")
				{
					snakes[snakes.length-1].rotation=-90;
				}
				break;
			}
			}
			//头旋转
			if(vx<0)
			{
				snakes[0].rotation=-90;
			}
			else if(vx>0)
			{
				snakes[0].rotation=90;
			}
			else if(vy<0)
			{
				snakes[0].rotation=0;
			}
			else if(vy>0)
			{
				snakes[0].rotation=180;
			}
			
			//检测边境
			if (snakes[0].x<5)
			{
				gameOver();
			}
			if (snakes[0].y<5)
			{
				gameOver();
			}
			if (snakes[0].x+5>stage.stageWidth)
			{
				gameOver();
			}
			if (snakes[0].y+5>stage.stageHeight)
			{
				gameOver();
			}
			//检测身体
			for(var z:int=snakes.length-1;z>2;z--)
			{
				Collision.block(snakes[0],snakes[z]);	
				if (Collision.collisionSide=="Top"&&vy<0||Collision.collisionSide=="Bottom"&&vy>0||Collision.collisionSide=="Left"&&vx<0||Collision.collisionSide=="Right"&&vx>0)
					gameOver();
			}
		}
		
		private function addFood():void
		{
			var foodx:Number;
			var foody:Number;
			var fooded:Boolean=true;
			while(fooded)
			{
				foodx=Math.floor(Math.random()*40)*10+50;
				foody=Math.floor(Math.random()*30)*10+50;
				for(var i:int=0;i<snakes.length;i++)
				{
					if (foodx==snakes[i].x&&foody==snakes[i].y)
					{
						fooded=false;
						break;
					}
				}
				if (fooded==true) break;
				fooded=true;
			}
			addGameObjectToStage(Food1,foodx,foody);
		}
		
		public function keyDownHandler(event:KeyboardEvent):void
		{
			Collision.block(snakes[0],snakes[1]);	
			if(event.keyCode==Keyboard.LEFT&&Collision.collisionSide!="Left")
			{
				vx=-10;
				vy=0;
				if(!space)
				{
					timerspeed=new Timer(200/(eatmax/10)/addspeed*2);
					timerspeed.addEventListener(TimerEvent.TIMER,updateTimespeedHandler);
					timerspeed.start();
					addspeed=2;
					space=true;
				}
			}
			else if(event.keyCode==Keyboard.RIGHT&&Collision.collisionSide!="Right")
			{
				vx=10;
				vy=0;
				if(!space)
				{
					timerspeed=new Timer(200/(eatmax/10)/addspeed*2);
					timerspeed.addEventListener(TimerEvent.TIMER,updateTimespeedHandler);
					timerspeed.start();
					space=true;
				}
			}
			else if(event.keyCode==Keyboard.UP&&Collision.collisionSide!="Top")
			{
				vy=-10;
				vx=0;
				if(!space)
				{
					timerspeed=new Timer(200/(eatmax/10)/addspeed*2);
					timerspeed.addEventListener(TimerEvent.TIMER,updateTimespeedHandler);
					timerspeed.start();
					space=true;
				}
			}
			else if(event.keyCode==Keyboard.DOWN&&Collision.collisionSide!="Bottom")
			{
				vy=10;
				vx=0;
				if(!space)
				{
					timerspeed=new Timer(200/(eatmax/10)/addspeed*2);
					timerspeed.addEventListener(TimerEvent.TIMER,updateTimespeedHandler);
					timerspeed.start();
					space=true;
				}
			}
		}
		
		protected function updateTimespeedHandler(event:TimerEvent):void
		{
			addspeed=2;
			timerspeed.removeEventListener(TimerEvent.TIMER,updateTimespeedHandler);
			starttime();
		}
		
		protected function keyUpHandler(event:KeyboardEvent):void
		{
			if (space==true)
			{
				addspeed=1;
				space=false;
				timerspeed.removeEventListener(TimerEvent.TIMER,updateTimespeedHandler);
				starttime();
			}
		}
		
		
		public function gameOver():void
		{
			//禁用移动
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			stage.removeEventListener(Event.ENTER_FRAME,updateTimeHandler);
			timer.removeEventListener(TimerEvent.TIMER,updateTimeHandler);
			
			//设置文本格式对象
			format.font="Helvetica";
			format.size=40;
			format.color=0xFF0000;
			format.align=TextFormatAlign.CENTER;
			format.bold=true;
			
			//设置输出文本框
			output.defaultTextFormat=format;
			output.width=480;
			output.height=100;
			output.border=true;
			output.wordWrap=true;
			output.background=true;
			output.visible=true;
			var score:int=100*(Math.pow(2,Math.floor(eat/10))-1)+(eat%10)*10*(Math.pow(2,Math.floor(eat/10)))
			output.text="Game Over!\nYou got "+score+" score!"
			
			//显示并设置输出文本框的位置
			stage.addChild(output);
			output.x=10;
			output.y=100;
			
			for(var i:int=0;i<snakes.length;i++)
			{
				stage.removeChild(snakes[i]);
				snakes.shift();
				i--;
			}
			
			addGameObjectToStage(again,250,300);			
			addGameObjectToStage(again1,250,300);
			again.visible=true;
			again1.visible=false;
			again.addEventListener(MouseEvent.MOUSE_OVER,mouseoverHandler);
			again1.addEventListener(MouseEvent.MOUSE_OUT,mouseoutHandler);
			again1.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		protected function mouseoutHandler(event:MouseEvent):void
		{
			again1.visible=false;
			again.visible=true;
		}
		
		protected function mouseoverHandler(event:MouseEvent):void
		{
			again.visible=false;
			again1.visible=true;
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			bounceChannel.stop();
			bounceChannel.removeEventListener(Event.SOUND_COMPLETE,loopSoundHandler);
			stage.removeChild(again);
			again.removeEventListener(MouseEvent.MOUSE_OVER,mouseoverHandler);
			again1.removeEventListener(MouseEvent.MOUSE_OUT,mouseoutHandler);
			again.removeEventListener(MouseEvent.CLICK,clickHandler);
			again.visible=false;
			again1.visible=false;
			output.visible=false;
			makeStage();
			startGame();
		}
		
	}
}