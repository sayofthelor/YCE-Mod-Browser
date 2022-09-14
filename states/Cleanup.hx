import("sys.FileSystem");
import("Paths");

// deletes tempMod.ycemod

var txt:FlxText;

function create():Void {
    add(txt = new FlxText(0, 0, FlxG.width, "Cleaning up...", 48));
    txt.alignment = "center";
    txt.screenCenter();
    try (FileSystem.deleteFile(Paths.get_modsPath() + "/tempMod.ycemod"))
    catch (e:Dynamic) {
        txt.text = "Already cleaned up!\nPress [ACCEPT] to exit.";
        txt.screenCenter();
        return;
    }
    txt.text = "Done!\nPress [ACCEPT] to exit.";
    txt.screenCenter();
}

function update(elapsed:Float):Void {
    if (FlxG.state.controls.ACCEPT) {
        FlxG.switchState(new MainMenuState());
    }
}