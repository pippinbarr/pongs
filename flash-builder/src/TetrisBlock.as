package
{

import org.flixel.*;

public class TetrisBlock extends FlxSprite
{
	[Embed(source="/assets/blocks/TBlock.png")]
	public const T_BLOCK:Class;
	[Embed(source="/assets/blocks/IBlock.png")]
	public const I_BLOCK:Class;
	[Embed(source="/assets/blocks/LBlock.png")]
	public const L_BLOCK:Class;
	[Embed(source="/assets/blocks/RBlock.png")]
	public const R_BLOCK:Class;
	[Embed(source="/assets/blocks/SBlock.png")]
	public const S_BLOCK:Class;
	[Embed(source="/assets/blocks/ZBlock.png")]
	public const Z_BLOCK:Class;
	[Embed(source="/assets/blocks/SquareBlock.png")]
	public const SQUARE_BLOCK:Class;

	private const BLOCK_SIZE:uint = 20;

	private const _shapeClasses:Array = new Array(T_BLOCK,I_BLOCK,L_BLOCK,R_BLOCK,S_BLOCK,Z_BLOCK,SQUARE_BLOCK);
	private const _shapeSizes:Array = new Array(3 * BLOCK_SIZE,4 * BLOCK_SIZE,3 * BLOCK_SIZE,3 * BLOCK_SIZE,3 * BLOCK_SIZE,3 * BLOCK_SIZE,2 * BLOCK_SIZE);
	private const _shapeFrames:Array = new Array(4,2,4,4,2,2,1);

	private var _frameCount:uint = 0;

	private var _stopped:Boolean = false;

	private const BLOCK_VELOCITY:Number = 150;

	public function TetrisBlock()
	{
		super();

		setupBlock();
	}



	public function setupBlock():void
	{
		makeRandomBlock();
		setRandomLocation();

		this.velocity.y = BLOCK_VELOCITY;
	}


	private function makeRandomBlock():void
	{
		var index:uint = Math.floor(Math.random() * _shapeClasses.length);
		this.loadGraphic(_shapeClasses[index],true,false,_shapeSizes[index],_shapeSizes[index]);
		var frame:uint = Math.floor(Math.random() * _shapeFrames[index]);
		this.addAnimation("shape",[frame,frame],0,true);
		this.play("shape");
	}


	private function setRandomLocation():void
	{
		this.x = Math.floor(Math.random() * (FlxG.width/BLOCK_SIZE - this.width/BLOCK_SIZE - 2*2*Globals.PADDLE_WIDTH/10)) * BLOCK_SIZE + Globals.PADDLE_WIDTH*2;
		while ((this.x > FlxG.width/2 - this.width - 10 && this.x < FlxG.width/2 + this.width + 10))
			this.x = Math.floor(Math.random() * (FlxG.width/BLOCK_SIZE - this.width/BLOCK_SIZE - 2*2*Globals.PADDLE_WIDTH/10)) * BLOCK_SIZE + Globals.PADDLE_WIDTH*2;

		this.y = -this.height;
	}


	public override function update():void
	{
		_frameCount++;

		super.update();

		if (this.y + this.height > FlxG.height)
		{
			this.y = FlxG.height - this.height;
			this.velocity.y = 0;
			this.immovable = true;
		}

	}


	public function contact():void
	{
		this.velocity.y = 0;
		_stopped = true;
		this.immovable = true;
	}


	public override function destroy():void
	{
		super.destroy();
	}
}
}
