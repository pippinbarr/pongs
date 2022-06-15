package
{
	public class Assets
	{
		[Embed(source="/assets/fonts/Commodore Pixelized v1.2.ttf", fontName="Commodore", fontWeight="Regular", embedAsCFF="false")]
		public static const COMMODORE_FONT:Class;

		[Embed(source="/assets/sounds/paddle.mp3")]
		public static const PADDLE_SOUND:Class;

		[Embed(source="/assets/sounds/wall.mp3")]
		public static const WALL_SOUND:Class;

		[Embed(source="/assets/sounds/point.mp3")]
		public static const POINT_SOUND:Class;

		public function Assets()
		{
		}
	}
}
