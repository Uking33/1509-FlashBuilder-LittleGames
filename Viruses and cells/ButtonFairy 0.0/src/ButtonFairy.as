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
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	[swf(width="500",height="400",backgroundColor="#FFFFFF",framrate="60")]
	
	public class ButtonFairy extends Sprite
	{
		[Embed(source="../sounds/backmusic.mp3")]
		private var Backmusic:Class;
		[Embed(source="../sounds/bounce.mp3")]
		private var BounceMusic:Class;
		[Embed(source="../images/star.png")]
		private var StarImage:Class;
		[Embed(source="../images/子弹.png")]
		private var Star0Image:Class;
		[Embed(source="../images/character.png")]
		private var CharacterImage:Class;
		[Embed(source="../images/bomb.png")]
		private var WandImage:Class;
		[Embed(source="../images/bee.png")]
		private var BeeImage:Class;
		[Embed(source="../images/Again.png")]
		private var  AgainImage:Class;
		[Embed(source="../images/Again1.png")]
		private var  Again1Image:Class;
		
		public var backmusic:Sound=new Backmusic();
		public var bouncemusic:Sound=new BounceMusic();
		private var Channel:SoundChannel=new SoundChannel();
		private var bounceChannel:SoundChannel=new SoundChannel();
		
		private var stars:Array=new Array();
		private var starss:Array=new Array();
		private var bees:Array=new Array();
		private var beetimers:Array=new Array();
		private var startimers:Array=new Array();
		
		private var characterImage:DisplayObject=new CharacterImage;
		private var character:GameObject=new GameObject(characterImage,false);
		
		private var wandImage:DisplayObject=new WandImage;
		private var wand:GameObject=new GameObject(wandImage);
		
		private var beeRANGE:Number=200;
		public var SPEED:Number;
		public var TURN_SPEED:Number;
		private var starspeed:int;
		private var xx:int;
		private var yy:int;
		//public var SPEED:Number=3;
		//public var TURN_SPEED:Number=0.3;
		
		public var format:TextFormat=new TextFormat();
		public var output:TextField=new TextField();
		public var output1:TextField=new TextField();
		public var output2:TextField=new TextField();
		
		//
		private var beescore:int;
		private var myscore:int;
		private var hitmax:int;
		
		//
		public var againImage:DisplayObject=new AgainImage;
		public var again:GameObject=new GameObject(againImage);
		public var again1Image:DisplayObject=new Again1Image;
		public var again1:GameObject=new GameObject(again1Image);
		
		public function ButtonFairy()
		{
			creatGameObjects();
			setupEventListeners();
		}
		public function creatGameObjects():void
		{
			SPEED=3;
			TURN_SPEED=0.3;
			beeRANGE=200;
			starspeed=1;
			hitmax=10;
			xx=0;
			yy=0;
			
			beescore=0;
			myscore=0;
			//添加角色到舞台
			addGameObjectToStage(character,450,350);
			addGameObjectToStage(wand,450,350);
			character.speedLimit=20;
			
			//隐藏鼠标
			//Mouse.hide();
			
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
			output1.text="Mine:0";
			output2.defaultTextFormat=format;
			output2.width=200;
			output2.autoSize=TextFieldAutoSize.CENTER;
			output2.border=true;
			output2.background=true;
			output2.backgroundColor=0xFFFFFF;
			output2.alpha=0.8;
			output2.text="Bee:0";
			//显示并设置输出文本框的位置
			stage.addChild(output1);
			output1.x=100;
			output1.y=7;
			stage.addChild(output2);
			output2.x=335;
			output2.y=7;
			
		}		
		
		public function setupEventListeners():void
		{
			//添加蜜蜂
	    	stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			stage.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			Channel=backmusic.play(0);
			Channel.addEventListener(Event.SOUND_COMPLETE,loopSoundHandler);
		}
	    private function addbee():void
     	{
			var beetimer:Timer;
			beetimer=new Timer(1000);
			beetimer.addEventListener(TimerEvent.TIMER,beesupdateTimeHandler);
			beetimer.start();
			beetimers.push(beetimer);
	    }
		
		protected function beesupdateTimeHandler(event:TimerEvent):void
		{
			var beeImage:DisplayObject=new BeeImage;
			var bee:GameObject=new GameObject(beeImage);
			bees.push(bee);
			addGameObjectToStage(bee,Math.floor(Math.random()*40)*10+50,Math.floor(Math.random()*30)*10+50);
			var starttimer:Timer;
			starttimer=new (1000);//(1000/(hitmax/10));
			starttimer.addEventListener(TimerEvent.TIMER,starupdateTimeHandler);
			starttimer.start();
			startimers.push(starttimer);
		}
		
		protected function starupdateTimeHandler(event:TimerEvent):void
		{
			if(starss.length<10)
			{	
				//创建星星
				var starImage:DisplayObject=new StarImage();
				var star:GameObject=new GameObject(starImage);
				//星星起始位置
				star.x=bees[bees.length-1].x;
				star.y=bees[bees.length-1].y;
				//设置星星速度
				star.vx=Math.cos(Math.atan2(star.vy,star.vx))*2+bees[bees.length-1].vx;
				star.vy=Math.sin(Math.atan2(star.vy,star.vx))*2+bees[bees.length-1].vy;
				stage.addChild(star);
				//将星星压入stars数组
				starss.push(star);
				
			}
		}		
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			//创建星星
			var star0Image:DisplayObject=new Star0Image();
			var star0:GameObject=new GameObject(star0Image);
			stage.addChild(star0);
			//星星起始位置
			star0.x=wand.x;
			star0.y=wand.y;
			//设置星星速度
			star0.vx=Math.cos(Math.atan2(character.y-stage.mouseY,character.x-stage.mouseX))*-7;
			star0.vy=Math.sin(Math.atan2(character.y-stage.mouseY,character.x-stage.mouseX))*-7;
			//将星星压入stars数组
			stars.push(star0);
			bounceChannel=bouncemusic.play(0,1);
			
		}
		
		protected function loopSoundHandler(event:Event):void
		{
			if(SoundChannel!=null)
			{
				Channel=backmusic.play(0);
				Channel.addEventListener(Event.SOUND_COMPLETE,loopSoundHandler);
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
		protected function keyUpHandler(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.LEFT||event.keyCode==Keyboard.RIGHT)
			{
				character.accelerationX=0;
			}
			else if(event.keyCode==Keyboard.UP||event.keyCode==Keyboard.DOWN)
			{
				character.accelerationY=0;
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
				character.accelerationY=-0.2;
			}
			else if(event.keyCode==Keyboard.DOWN)
			{
			    character.accelerationY=0.2;
			}
		}
		public function enterFrameHandler(event:Event):void
		{
			if(beetimers.length<=3-1) addbee()
			else 
				for(var i:int=0;i<bees.length;i++)
				{
					beetimers[i].removeEventListener(TimerEvent.TIMER,beesupdateTimeHandler);
				}
			//蜜蜂
			for(var j:int=0;j<bees.length;j++)
			{
				Ai.follow(bees[j],character,beeRANGE,TURN_SPEED,SPEED);
				Ai.checkGround(bees[j],0,stage.stageWidth,0,stage.stageHeight,false,true);
			}
			//移动星星
		    starmove(stars,starss);
			
			//移动蜜蜂星星
			beestarmove(starss);
			
			//发射器
			Ai.around(wand,character,stage.mouseX,stage.mouseY,30);			
			KeyBoardMove();
			
		}
		
		private function KeyBoardMove():void
		{
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
			if (character.vy<-character.speedLimit)
			{
				character.vy=-character.speedLimit;
			}
			if (character.vy>character.speedLimit)
			{
				character.vy=character.speedLimit;
			}
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
			//character.vy+=character.gravity;
			
			//移动角色
			character.x+=character.vx;
			character.y+=character.vy;
			
			//检测边缘舞台（加弹跳）
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
				character.vy*=character.bounce;
				character.y=stage.stageHeight-character.height;
			}
		}
		
		private function beestarmove(stars1:Array):void
		{
			for(var z:int=0;z<stars1.length;z++)
			{
				var star1:GameObject=stars1[z];
				star1.x+=star1.vx;
				star1.y+=star1.vy;
				Ai.straight(star1,true,+3);
				//检测星星舞台边界
				if(Ai.checkGround(star1,0,stage.stageWidth,0,stage.stageHeight))
				{
					stage.removeChild(star1);
					star1=null;
					stars1.splice(z,1);
					startimers.splice(z,1);
					z--;
				}
				if (star1.hitTestObject(character)&&character.visible==true)
				{
					stage.removeChild(star1);
					star1=null;
					stars1.splice(z,1);
					startimers.splice(z,1);
					z--;
					stage.removeChild(character);
					addGameObjectToStage(character,450,350);
					beescore++;
					output2.text="Bee:"+beescore;
					if (beescore==10) gameOver();
				}
			}
			
		}
		
		
		private function starmove(stars1:Array, stars2:Array):void
		{
			for(var i:int=0;i<stars1.length;i++)
			{
				var star1:GameObject=stars[i];
				Ai.straight(star1,true,+3);
				//检测星星舞台边界
				if(Ai.checkGround(star1,0,stage.stageWidth,0,stage.stageHeight))
				{stage.removeChild(star1);star1=null;stars1.splice(i,1);i--;}
				for(var j:int=0;j<bees.length;j++)
				{
					
					if (star1.hitTestObject(bees[j])&&bees[j].visible==true)
					{
						removestar(stars1);
						stage.removeChild(bees[j]);
						bees.splice(j,1);
						beetimers.splice(j,1);
						myscore++;
						output1.text="Mine:"+myscore;
						xx=0;
						hard(myscore,2);
					}
					for(var i1:int=0;i1<stars2.length;i1++)
					{
						var star2:GameObject=stars2[i1];
						if(star2.hitTestObject(star1))
						{
							stage.removeChild(star1);
							star1=null;
							stars1.splice(i,1);
							i--;
							stage.removeChild(star2);
							star2=null;
							stars2.splice(i1,1);
							startimers.splice(i1,1);
							i1--;
						}
					}
				}
			}			
		}
		
		private function hard(hard:Number,type:Number):void
		{
			if(type==1)
			{
				if (hard%10==0)
				{
					SPEED+=1;
					TURN_SPEED+=0.1;
				}
			}
			if(type==2)
			{
				if (hard%20==0&&hard!=0)
				{
					hitmax*=2;
					starttime();
					starspeed*=2;
				}
				if (hard%50==0&&hard!=0)
				{
					SPEED+=1;
					TURN_SPEED+=0.1;
				}
				if (hard%100==0&&hard!=0)
				{
					beeRANGE+=10;
				}
			}
			if (type==3)
			{
				if (hard%50==0&&hard!=0)
				{
					beeRANGE+=50;
				}
			}
		}
		
		private function starttime():void
		{
			startimers[xx].removeEventListener(TimerEvent.TIMER,starupdateTimeHandler);
			startimers[xx]=new Timer(200/(hitmax/10));
			startimers[xx].addEventListener(TimerEvent.TIMER,starupdateTimeHandler);
			startimers[xx].start();
		}
		
		private function removestar(s:Array):void
		{
			for(var i:int=0;i<s.length;i++)
			{
				var star:GameObject=stars[i];
				stage.removeChild(star);
				star=null;
				stars.splice(i,1);
				i--;
			}
		}
		
		public function gameOver():void
		{
			Mouse.show();
			stage.removeChild(character);
			for(var i:Number=0;i<bees.length;i++)
			stage.removeChild(bees[i]);
			stage.removeChild(wand);
			//禁用移动
			stage.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			for(i=0;i<startimers.length;i++)
				startimers[i].removeEventListener(TimerEvent.TIMER,starupdateTimeHandler);
			for(var j:Number=0;j<startimers.length;j++)
			    beetimers[j].removeEventListener(TimerEvent.TIMER,beesupdateTimeHandler);
			removestar(starss);
			removestar(stars);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			
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
			output.visible=true;var 
			score:int=100*(Math.pow(2,Math.floor(myscore/10))-1)+(myscore%10)*10*(Math.pow(2,Math.floor(myscore/10)))
			output.text="Game Over!\nYou got "+score+" score!"
			
			//显示并设置输出文本框的位置
			stage.addChild(output);
			output.x=10;
			output.y=100;
			
			//清除数据
			
			addGameObjectToStage(again,250,300);			
			addGameObjectToStage(again1,250,300);
			again.visible=true;
			again1.visible=false;
			again.addEventListener(MouseEvent.MOUSE_OVER,mouseoveragainHandler);
			again1.addEventListener(MouseEvent.MOUSE_OUT,mouseoutagainHandler);
			again1.addEventListener(MouseEvent.CLICK,clickagainHandler);
		}
		
		protected function mouseoutagainHandler(event:MouseEvent):void
		{
			again1.visible=false;
			again.visible=true;
		}
		
		protected function mouseoveragainHandler(event:MouseEvent):void
		{
			again.visible=false;
			again1.visible=true;
		}
		
		protected function clickagainHandler(event:MouseEvent):void
		{
			Channel.stop();
			bounceChannel.stop();
			Channel.removeEventListener(Event.SOUND_COMPLETE,loopSoundHandler);
			stage.removeChild(again);
			again.removeEventListener(MouseEvent.MOUSE_OVER,mouseoveragainHandler);
			again1.removeEventListener(MouseEvent.MOUSE_OUT,mouseoutagainHandler);
			again.removeEventListener(MouseEvent.CLICK,clickagainHandler);
			again.visible=false;
			again1.visible=false
			output.visible=false;
			creatGameObjects();
			setupEventListeners();
		}
	}
}