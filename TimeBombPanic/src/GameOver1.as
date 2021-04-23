package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	public class GameOver1 extends Sprite
	{
		[Embed(source="../images/gameover1.png")]
		public var GameObjectImage:Class;
		public var gameObjectImage:DisplayObject=new GameObjectImage();
		public function GameOver1()
		{
			this.addChild(gameObjectImage)
		}
	}
}	