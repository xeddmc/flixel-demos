package;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;

class PlayState extends FlxState
{
	override public function create():Void
	{			
		// Background
		FlxG.state.bgColor = 0xffacbcd7;
		var decoration:FlxSprite = new FlxSprite(256, 159, "assets/bg.png");
		decoration.moves = false;
		decoration.solid = false;
		add(decoration);
		add(new FlxText(32, 36, 96, "collision").setFormat(null, 16, 0x778ea1, "center"));
		add(new FlxText(32, 60, 96, "DEMO").setFormat(null, 24, 0x778ea1, "center"));
		
		var path:FlxPath;
		var sprite:FlxSprite;
		var destination:FlxPoint;
		
		// Create the elevator and put it on a up and down path
		sprite = new FlxSprite(208, 80, "assets/elevator.png");
		sprite.immovable = true;
		destination = sprite.getMidpoint();
		destination.y += 112;
		path = new FlxPath([sprite.getMidpoint(),destination]);
		sprite.followPath(path, 40, FlxPath.YOYO);
		add(sprite);
		
		// Create the side-to-side pusher object and put it on a different path
		sprite = new FlxSprite(96, 208, "assets/pusher.png");
		sprite.immovable = true;
		destination = sprite.getMidpoint();
		destination.x += 56;
		path = new FlxPath([sprite.getMidpoint(),destination]);
		sprite.followPath(path, 40, FlxPath.YOYO);
		add(sprite);
		
		// Then add the player, its own class with its own logic
		var player:Player = new Player(32, 176);
		add(player);
		
		// Then create the crates that are sprinkled around the level
		var crates:Array<FlxPoint> = [
			new FlxPoint(64, 208),
			new FlxPoint(108, 176),
			new FlxPoint(140, 176),
			new FlxPoint(192, 208),
			new FlxPoint(272, 48)];
		
		for (i in 0...crates.length)
		{
			sprite = new FlxSprite(crates[i].x, crates[i].y, "assets/crate.png");
			sprite.height = sprite.height - 1;
			sprite.acceleration.y = 400;
			sprite.drag.x = 200;
			add(sprite);
		}
		
		// This is the thing that spews nuts and bolts
		var dispenser:FlxEmitter = new FlxEmitter(32, 40);
		dispenser.setSize(8, 40);
		dispenser.setXSpeed(100, 240);
		dispenser.setYSpeed( -50, 50);
		dispenser.gravity = 300;
		dispenser.bounce = 0.3;
		dispenser.makeParticles("assets/gibs.png", 100, 16, true);
		dispenser.start(false, 10, 0.035);
		add(dispenser);
		
		// Basic level structure
		var level:FlxTilemap = new FlxTilemap();
		level.loadMap(FlxTilemap.imageToCSV("assets/map.png", false, 2), "assets/tiles.png", 0, 0, FlxTilemap.ALT);
		level.follow();
		add(level);
		
		// Library label in upper left
		var tx:FlxText;
		tx = new FlxText(2, 0, Std.int(FlxG.width / 2), FlxG.libraryName);
		tx.scrollFactor.x = tx.scrollFactor.y = 0;
		tx.color = 0x778ea1;
		tx.shadow = 0x233e58;
		tx.useShadow = true;
		add(tx);
		
		// Instructions
		tx = new FlxText(2, FlxG.height - 12, FlxG.width, "Interact with ARROWS / WASD, or press ENTER for next demo.");
		tx.scrollFactor.x = tx.scrollFactor.y = 0;
		tx.color = 0x778ea1;
		tx.shadow = 0x233e58;
		tx.useShadow = true;
		tx.alignment = "center";
		add(tx);
	}
	
	override public function update():Void
	{
		super.update();
		
		FlxG.collide();
		
		if (FlxG.keys.justReleased("ENTER"))
		{
			FlxG.switchState(new PlayState2());
		}
	}
}