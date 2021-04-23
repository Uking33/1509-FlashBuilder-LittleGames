package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	public class GameOver2 extends Sprite
	{
		[Embed(source="../images/gameover2.png")]
		public var GameObjectImage:Class;
		public var gameObjectImage:DisplayObject=new GameObjectImage();
		public function GameOver2()
		{
			this.addChild(gameObjectImage)
		}
	}
}	