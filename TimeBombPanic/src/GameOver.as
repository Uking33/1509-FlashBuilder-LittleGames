package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	public class GameOver extends Sprite
	{
		[Embed(source="../images/gameover.png")]
		public var GameObjectImage:Class;
		public var gameObjectImage:DisplayObject=new GameObjectImage();
		public function GameOver()
		{
			this.addChild(gameObjectImage)
		}
	}
}	