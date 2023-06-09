package meta.state.menus.menuObjects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import meta.subState.WebsiteSubState;
import meta.data.dependency.Discord;
import meta.data.*;

// eu acho q esse cabô
class MainMenuGroup extends MusicBeatGroup
{
	var optionShit:Array<String> = ["play", "credits", "buy moonleap", "options", "exit"];
	static var curSelected:Int = 0;
	
	var menuItems:FlxTypedGroup<FlxText>;
	
	public function new()
	{
		super();
		groupName = GlobalMenuState.spawnMenu = 'main-menu';
		
		#if desktop
		Discord.changePresence('MAIN MENU', 'Main Menu');
		#end
		
		//if(Init.debugMode)
		//	optionShit.insert(optionShit.length - 1, 'debug menu');
		if(GlobalMenuState.realClock != null)
			optionShit.insert(3, "< clock >");
		
		menuItems = new FlxTypedGroup<FlxText>();
		add(menuItems);
		
		for(i in 0...optionShit.length)
		{
			var menuItem:FlxText = new FlxText(0, 0, 0, optionShit[i]);
			menuItem.scrollFactor.set();
			menuItem.setFormat(Main.gFont, 36, FlxColor.WHITE, CENTER);
			menuItem.ID = i;
			menuItems.add(menuItem);
			
			// arrumando os lugar
			menuItem.x = (FlxG.width / 2) - (menuItem.width / 2);
			menuItem.y = 300 + (50 * i); // 380
			//menuItem.alpha = 0;
			//flixel.tweens.FlxTween.tween(menuItem, {alpha: 1}, 0.5, {ease: flixel.tweens.FlxEase.expoOut});
		}
		
		#if mobile
		addVirtualPad(LEFT_FULL, A_B);
		addVirtualPadCamera();
		#end
		
		changeSelection();
	}
	
	var selectedSomething:Bool = false;
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if(!selectedSomething)
		{
			if(controls.UI_UP_P)
				changeSelection(-1);
			if(controls.UI_DOWN_P)
				changeSelection(1);
			
			/*if(FlxG.keys.justPressed.SEVEN)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				Init.debugMode = !Init.debugMode;
				GlobalMenuState.nextMenu = new MainMenuGroup();
				alive = false;
			}*/
			if(optionShit[curSelected] == "< clock >")
			{
				GlobalMenuState.realClock.moving = (controls.UI_LEFT || controls.UI_RIGHT);
				if(GlobalMenuState.realClock.moving)
				{
					GlobalMenuState.realClock.curTime += (elapsed * 2 * 60) * (controls.UI_LEFT ? -1 : 1);
					//trace("time is: " + GlobalMenuState.realClock.curTime);
				}
			}
			if(SaveData.trueSettings.get('Finished'))
			{
				if(FlxG.keys.justPressed.NUMPADMULTIPLY)
				{
					selectedSomething = true;
					WarningState.curWarning = ENDING;
					Main.switchState(new WarningState());
				}
			}

            menuItems.forEach(function(txt:FlxText){
				if(apertasimples(txt)){
					curSelected=txt.ID;
					changeSelection(txt.ID);
					selecionarcoisa();
				}
			});


    public static function selecionarcoisa() {
				selectedSomething = true;
				GlobalMenuState.nextMenu = new MainMenuGroup();
				FlxG.sound.play(Paths.sound('confirmMenu'));
				
                if(!selectedSomething) {
				switch(optionShit[curSelected])
				{
					case 'story':
						//FlxG.sound.play(Paths.sound('confirmMenu'));
						FlxG.sound.music.stop();
						
						PlayState.storyPlaylist = ['leap', 'crescent', 'odyssey'];
						PlayState.isStoryMode = true;
						
						PlayState.storyDifficulty = 0;
						
						PlayState.SONG = Song.loadFromJson('leap', 'leap');
						PlayState.storyWeek = 0;
						PlayState.campaignScore = 0;
						Main.switchState(new PlayState());
						
					case 'freeplay' | 'play': 
                        GlobalMenuState.nextMenu = new FreeplayGroup();
						//Main.switchState(new meta.state.menus.FreeplayState());

					case 'credits':
                        GlobalMenuState.nextMenu = new CreditsGroup();
					case 'options': 
                        GlobalMenuState.nextMenu = new OptionsGroup();
					case 'exit': 
                        Sys.exit(0);
					
					case 'debug menu': 
                        GlobalMenuState.nextMenu = new DebugMenuGroup();
					
					case 'ost' | 'buy moonleap':
						var link:String = (optionShit[curSelected] == 'ost') ? "https://on.soundcloud.com/ha9oz" : "https://store.steampowered.com/app/2166050/Moonleap/";
						FlxG.state.openSubState(new WebsiteSubState(link));
						//selectedSomething = false;
						
					//default: selectedSomething = false; // do nothing
				}
				
				alive = false;
			}
   }
}

    //thanks silver
    public static function apertasimples(coisa:Dynamic):Bool
        {
            #if desktop
            if (FlxG.mouse.overlaps(coisa) && FlxG.mouse.justPressed)
                return true;
            #elseif mobile
            for (touch in FlxG.touches.list)
                if (touch.overlaps(coisa) && touch.justPressed)
                    return true;
            #end
    
            return false;
        }
	
	public function changeSelection(direction:Int = 0)
	{
		if(direction != 0) FlxG.sound.play(Paths.sound('scrollMenu'));
		
		curSelected += direction;
		curSelected = FlxMath.wrap(curSelected, 0, optionShit.length - 1);
		
		for(item in menuItems)
		{
			item.color = FlxColor.fromRGB(170,170,255);
			if (item.ID == curSelected)
				item.color = FlxColor.fromRGB(170,255,255);
		}
	} 
}