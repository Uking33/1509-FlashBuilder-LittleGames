package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	
	[swf(width="550",height="400",backgroundColor="#FFFFFF",framrate="60")]
	public class NumberGuessingGame extends Sprite
	{
		//创建文本对象
		public var format:TextFormat=new TextFormat();
		public var output:TextField=new TextField();
		public var input:TextField=new TextField();
		
		//创建按钮对象
		public var buttonUpURL:URLRequest=new URLRequest("images/buttonUp.png");
		public var buttonOverURL:URLRequest=new URLRequest("images/buttonOver.png");
		public var buttonDownURL:URLRequest=new URLRequest("images/buttonDown.png");
		public var buttonUpImage:Loader=new Loader();
		public var buttonOverImage:Loader=new Loader();
		public var buttonDownImage:Loader=new Loader();
		public var button:Sprite=new Sprite();
		
		//游戏变量
		public var startMessage:String;
		public var mysteryNumber:uint;
		public var currentGuess:uint;
		public var guessesRemaining:int;
		public var guessesMade:uint;
		public var gameStatus:String;
		public var gameWon:Boolean;
		
		public function NumberGuessingGame()
		{
			setupTextfields();
			makeButton();
			startGame();
		}
		
		public function setupTextfields():void
		{
			//设置文本格式对象
			format.font="Helvetica";
			format.size=32;
			format.color=0xFF0000;
			format.align=TextFormatAlign.CENTER;
			format.bold=true;
			
			//设置输出文本框
			output.defaultTextFormat=format;
			output.width=400;
			output.height=80;
			output.border=true;
			output.wordWrap=true;
			output.text="This is the output text field";
			
			//显示并设置输出文本框的位置
			stage.addChild(output);
			output.x=70;
			output.y=65;
			//设置输入文本框
			format.size=60;
			input.defaultTextFormat=format;
			input.width=80;
			input.height=60;
			input.border=true;
			input.type="input";
			input.maxChars=2;
			input.restrict="0-9";
			input.background=true;
			input.backgroundColor=0xCCCCCC;
			input.text="";
			
			//显示并设置输入文本框的位置
			stage.addChild(input);
			input.x=150;
			input.y=170;
			stage.focus=input;
		}
		
		public function makeButton():void
		{
			//加载图片
			buttonUpImage.load(buttonUpURL);
			buttonDownImage.load(buttonDownURL);
			buttonOverImage.load(buttonOverURL);
			
			//除了up这张图片外，所有的图片均设为不可见
			buttonUpImage.visible=true;
			buttonDownImage.visible=false;
			buttonOverImage.visible=false;
			
			//将所有的图片添加到按钮Sprite中
			button.addChild(buttonUpImage);
			button.addChild(buttonDownImage);
			button.addChild(buttonOverImage);
			
			//设置Sprite的按钮属性
			button.buttonMode=true;
			/*button.mouseEnabled=true;
			button.useHandCursor=true;*/
			button.mouseChildren=false;
			
			//将按钮Sprite添加到舞台
			stage.addChild(button);
			button.x=300;
			button.y=175;
		}
		
		public function startGame():void
		{
			//初始化变量
			startMessage="I am thinking of a number between 0 and 99";
			mysteryNumber=Math.floor(Math.random()*100);
			
			//初始化文本框
			output.text=startMessage;
			input.text="";
			guessesRemaining=10;
			guessesMade=0;
			gameStatus="";
			gameWon=false;
			
			//打印谜底数值
			trace("The mystery number:"+mysteryNumber);
			
			//为键盘添加一个事件监听器
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyPressHandler);
			
			//为按钮添加事件监听器
			button.addEventListener(MouseEvent.ROLL_OVER,overHandler);
			button.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			button.addEventListener(MouseEvent.ROLL_OUT,resetHandler);
			button.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		public function playGame():void
		{
			guessesRemaining--;
			guessesMade++;
			gameStatus="Guess:"+guessesMade+",Remaining:"+guessesRemaining;
			currentGuess=uint(input.text);
			if (currentGuess>mysteryNumber)
			{
				output.text="That's too high."+"\n"+gameStatus;
				checkGameOver();	
			}
			else if (currentGuess<mysteryNumber)
			{
				output.text="That's too low."+"\n"+gameStatus;
				checkGameOver();	
			}
			else
			{
				output.text="You got it!";
				gameWon=true;
				endGame();
			}
		}
		public function checkGameOver():void
		{
			if (guessesRemaining<1)
			{
				endGame();
			}
		}
		public function endGame():void
		{
			if (gameWon)
			{
				output.text="Yes,it's "+mysteryNumber+"!"+"\n"+"It only took you "+guessesMade+" guesses.";
			}
			else
			{
				output.text="No more guesses left!"+"\n"+"The number was:"+mysteryNumber+".";
			}
			//禁用回车键
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyPressHandler);
			input.type="dynamic";
			input.alpha=0.5;
			
			//禁用按钮
			button.removeEventListener(MouseEvent.ROLL_OVER,overHandler);
			button.removeEventListener(MouseEvent.MOUSE_DOWN,overHandler);
			button.removeEventListener(MouseEvent.ROLL_OUT,overHandler);
			button.removeEventListener(MouseEvent.CLICK,overHandler);
			button.alpha=0.5;
		}
		public function keyPressHandler(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.ENTER)
			{
				playGame();
				input.text="";
			}
		}
		public function overHandler(event:MouseEvent):void
		{
			buttonUpImage.visible=false;
			buttonDownImage.visible=false;
			buttonOverImage.visible=true;
		}
		public function downHandler(event:MouseEvent):void
		{
			buttonUpImage.visible=false;
			buttonDownImage.visible=true;
			buttonOverImage.visible=false;
		}
		public function clickHandler(event:MouseEvent):void
		{
			buttonUpImage.visible=true;
			buttonDownImage.visible=false;
			buttonOverImage.visible=false;
			input.text="";
			stage.focus=input;
			playGame();
		}
		public function resetHandler(event:MouseEvent):void
		{
			buttonUpImage.visible=true;
			buttonDownImage.visible=false;
			buttonOverImage.visible=false;
		}
	}
}
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

