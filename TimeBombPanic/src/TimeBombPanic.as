package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	[swf(width="550",height="400",backgroundColor="#FFFFFF",framrate="60")]
	
	public class TimeBombPanic extends Sprite
	{		
		[Embed(source="../sounds/backmusic.mp3")]
		private var Backmusic:Class;
		public var backmusic:Sound=new Backmusic();
		private var bounceChannel:SoundChannel=new SoundChannel();
		
		//创建文本对象
		public var format:TextFormat=new TextFormat();
		public var output:TextField=new TextField();
		public var input:TextField=new TextField();
		public var gameResult:TextField=new TextField();
		
		//创建游戏对象
		public var character:Character=new Character();
		public var background:Background=new Background();
		public var gameOver1:GameOver1=new GameOver1();
		public var gameOver2:GameOver2=new GameOver2();
		
		//地雷
		public var bomb1:Bomb=new Bomb();
		public var bomb2:Bomb=new Bomb();
		public var bomb3:Bomb=new Bomb();
		public var bomb4:Bomb=new Bomb();
		public var bomb5:Bomb=new Bomb();
		
		//箱子
		public var box1:Box=new Box();
		public var box2:Box=new Box();
		public var box3:Box=new Box();
		public var box4:Box=new Box();
		public var box5:Box=new Box();
		public var box6:Box=new Box();
		public var box7:Box=new Box();
		public var box8:Box=new Box();
		public var box9:Box=new Box();
		public var box10:Box=new Box();
		public var box11:Box=new Box();
		public var box12:Box=new Box();
		public var box13:Box=new Box();
		public var box14:Box=new Box();
		
		//
		public var timer:Timer;
		
		//
		public var vx:int=0;
		public var vy:int=0;
		
		//
		public var bombsDefused:uint=0;
		public var maxTime:uint=10
		
		public function TimeBombPanic()
		{
			creatGameObjects();
			setupTextfields();
			setupEventListeners();
		}
		public function creatGameObjects():void
		{
			//
			addGameObjectToStage(background,0,0);
			
			//			
			addGameObjectToStage(character,50,50);
			
			//
			addGameObjectToStage(box1,100,100);
			addGameObjectToStage(box2,150,100);
			addGameObjectToStage(box3,200,100);
			addGameObjectToStage(box4,150,150);
			addGameObjectToStage(box5,100,250);
			addGameObjectToStage(box6,200,250);
			addGameObjectToStage(box7,250,250);
			addGameObjectToStage(box8,250,200);
			addGameObjectToStage(box9,300,100);
			addGameObjectToStage(box10,300,300);
			addGameObjectToStage(box11,350,250);
			addGameObjectToStage(box12,400,100);
			addGameObjectToStage(box13,400,200);
			addGameObjectToStage(box14,400,250);
			
			//
			addGameObjectToStage(bomb1,105,160);
			addGameObjectToStage(bomb2,205,310);
			addGameObjectToStage(bomb3,305,260);
			addGameObjectToStage(bomb4,255,310);
			addGameObjectToStage(bomb5,455,110);
			
			//
			addGameObjectToStage(gameOver1,0,0);
			gameOver1.visible=false;
			addGameObjectToStage(gameOver2,0,0);
			gameOver2.visible=false;
			
			//
			timer=new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER,updateTimeHandler);
			timer.start();
			
			//
			bounceChannel=backmusic.play(0,2148483647);
		}
		
		public function setupTextfields():void
		{
			//设置文本格式对象
			format.font="Helvetica";
			format.size=38;
			format.color=0xFFFFFF;
			format.align=TextFormatAlign.CENTER;
			
			//设置输出文本框
			output.defaultTextFormat=format;
  			output.autoSize=TextFieldAutoSize.CENTER;
			output.border=false;
			output.text="0";
			
			//显示并设置输出文本框的位置
			stage.addChild(output);
			output.x=265;
			output.y=7;
			
		}
		
		public function setupEventListeners():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			stage.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		public function updateTimeHandler(event:TimerEvent):void
		{
			output.text=String(timer.currentCount);
			
			//
			output.text=String(timer.currentCount);
			if(timer.currentCount==maxTime)
			{
				checkGameOver();
			}
		}
		
		public function enterFrameHandler(event:Event):void
		{
			//
			character.x+=vx;
			character.y+=vy;
			
			//
			if (character.x<50)
			{
				character.x=50;
			}
			if (character.y<50)
			{
				character.y=50;
			}
			if (character.x+character.width>500)
			{
				character.x=stage.stageWidth-50;
			}
			if (character.y+character.height>350)
			{
				character.y=300;
			}
			
			//
			Collision.block(character,box1);
			Collision.block(character,box2);
			Collision.block(character,box3);
			Collision.block(character,box4);
			Collision.block(character,box5);
			Collision.block(character,box6);
			Collision.block(character,box7);
			Collision.block(character,box8);
			Collision.block(character,box9);
			Collision.block(character,box10);
			Collision.block(character,box11);
			Collision.block(character,box12);
			Collision.block(character,box13);
			Collision.block(character,box14);
			//
			if (character.hitTestObject(bomb1)&&bomb1.visible==true)
			{
				bomb1.visible=false;
				bombsDefused++;
				checkGameOver();
				
			}
			if (character.hitTestObject(bomb2)&&bomb2.visible==true)
			{
				bomb2.visible=false;
				bombsDefused++;
				checkGameOver();
				
			}
			if (character.hitTestObject(bomb3)&&bomb3.visible==true)
			{
				bomb3.visible=false;
				bombsDefused++;
				checkGameOver();
				
			}
			if (character.hitTestObject(bomb4)&&bomb4.visible==true)
			{
				bomb4.visible=false;
				bombsDefused++;
				checkGameOver();
				
			}
			if (character.hitTestObject(bomb5)&&bomb5.visible==true)
			{
				bomb5.visible=false;
				bombsDefused++;
				checkGameOver();
				
			}
		}
		
		public function checkGameOver():void
		{
			if(bombsDefused==5)
			{
				gameOver1.visible=true;
				character.alpha=0.5;
				background.alpha=0.5;
				output.text="";
				timer.removeEventListener(TimerEvent.TIMER,updateTimeHandler);
				stage.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			}
			else if(timer.currentCount==maxTime)
			{
				gameOver2.visible=true;
				character.alpha=0.5;
				background.alpha=0.5;
				output.text="";
				timer.removeEventListener(TimerEvent.TIMER,updateTimeHandler);
				stage.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			}
		}
		
		public function addGameObjectToStage(gameObject:Sprite,xPos:int,yPos:int):void
		{
			stage.addChild(gameObject);
			gameObject.x=xPos;
			gameObject.y=yPos;
		}
		
		public function keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.LEFT)
			{
				vx=-5;
			}
			else if(event.keyCode==Keyboard.RIGHT)
			{
				vx=5;
			}
			else if(event.keyCode==Keyboard.UP)
			{
				vy=-5;
			}
			else if(event.keyCode==Keyboard.DOWN)
			{
				vy=5;
			}
		}
		
		public function keyUpHandler(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.LEFT||event.keyCode==Keyboard.RIGHT)
			{
				vx=0;
			}
			else if(event.keyCode==Keyboard.UP||event.keyCode==Keyboard.DOWN)
			{
				vy=0;
			}
		}
	}
}