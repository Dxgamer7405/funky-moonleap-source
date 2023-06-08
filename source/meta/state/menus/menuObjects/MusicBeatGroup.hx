package meta.state.menus.menuObjects;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;
import meta.data.PlayerSettings;
#if mobile
import mobile.MobileControls;
import mobile.flixel.FlxVirtualPad;
import flixel.FlxCamera;
import flixel.input.actions.FlxActionInput;
import flixel.util.FlxDestroyUtil;
#end

/*
*	just a FlxTypedGroup with step/beat hit functions and controls
*/
class MusicBeatGroup extends FlxTypedGroup<FlxBasic>
{
	public var groupName:String = 'none';
	
	private var controls(get, never):Controls;
	
	inline function get_controls():Controls
		return PlayerSettings.player1.controls;
	
		#if mobile
	var virtualPad:FlxVirtualPad;
	var trackedInputsVirtualPad:Array<FlxActionInput> = [];

	public function addVirtualPad(DPad:FlxDPadMode, Action:FlxActionMode)
	{
		if (virtualPad != null)
			removeVirtualPad();

		virtualPad = new FlxVirtualPad(DPad, Action);
		add(virtualPad);

		controls.setVirtualPadUI(virtualPad, DPad, Action);
		trackedInputsVirtualPad = controls.trackedInputsUI;
		controls.trackedInputsUI = [];
	}

	public function removeVirtualPad()
	{
		if (trackedInputsVirtualPad.length > 0)
			controls.removeVirtualControlsInput(trackedInputsVirtualPad);

		if (virtualPad != null)
			remove(virtualPad);
	}

	public function addVirtualPadCamera(DefaultDrawTarget:Bool = false)
	{
		if (virtualPad != null)
		{
			var camControls:FlxCamera = new FlxCamera();
			FlxG.cameras.add(camControls, DefaultDrawTarget);
			camControls.bgColor.alpha = 0;
			virtualPad.cameras = [camControls];
		}
	}
	#end

	override function destroy()
	{
		#if mobile
		if (trackedInputsVirtualPad.length > 0)
			controls.removeVirtualControlsInput(trackedInputsVirtualPad);
		#end

		super.destroy();

		#if mobile
		if (virtualPad != null)
			virtualPad = FlxDestroyUtil.destroy(virtualPad);
		#end
	}
	
	public function new()
		super();
	
	// funny beat stuff if you want to use it i guess
	public function stepHit(curStep:Int = 0) {}
	public function beatHit(curBeat:Int = 0) {}
}
