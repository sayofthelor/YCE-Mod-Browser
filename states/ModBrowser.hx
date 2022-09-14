import("sys.Http");
import("haxe.Json");
import("flixel.text.FlxTextBorderStyle");
import("mod_support_stuff.InstallModScreen");
import("sys.io.File");
import ("sys.FileSystem");
import("flixel.util.FlxTimer");

var bg:FlxSprite;
var g:FlxSprite;
var loadingText:FlxText;
var modName:FlxText;
var titleText:Alphabet;
var modNameText:FlxText;
var modAuthorText:FlxText;
var modDescText:FlxText;
var thingsSelectable:Bool = true;
var modList = ["" => {}]; modList.remove("");
var getShit:Array<String> = null;
var selected:Int = 0;
var realIDs:Array<String> = [];
var guideText:FlxText;
var lowThing:FlxSprite;

function create():Void {
    add(bg = new FlxSprite().loadGraphic(Paths.image("browserBG")));
    bg.screenCenter();
    add(g = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000));
    g.alpha = 0.5;
    add(loadingText = new FlxText(32, 32, FlxG.width - 64, "Loading...", 32));
    loadingText.borderStyle = FlxTextBorderStyle.OUTLINE;
    loadingText.borderSize = 4;
    getMods();
    loadingText.destroy();
    titleText = new Alphabet(32, 32, "YCE Mod Browser", true);
    add(titleText);
    modNameText = new FlxText(32, 128, FlxG.width - 64, "", 64);
    modNameText.borderStyle = FlxTextBorderStyle.OUTLINE;
    modNameText.borderSize = 4;
    modAuthorText = new FlxText(32, modNameText.y + modNameText.height - 4, FlxG.width - 64, "", 16);
    modAuthorText.borderStyle = FlxTextBorderStyle.OUTLINE;
    modAuthorText.borderSize = 2;
    modDescText = new FlxText(32, modAuthorText.y + modAuthorText.height + 4, FlxG.width - 64, "", 32);
    modDescText.borderStyle = FlxTextBorderStyle.OUTLINE;
    modDescText.borderSize = 4;
    add(modNameText);
    add(modAuthorText);
    add(modDescText);
    guideText = new FlxText(32, FlxG.height - 36, FlxG.width - 64, "Press [UP] and [DOWN] to select a mod, [ACCEPT] to install it, and [BACK] to go back to the menu.", 12);
    guideText.borderStyle = FlxTextBorderStyle.OUTLINE;
    guideText.borderSize = 2;
    lowThing = new FlxSprite(0, FlxG.height - 48).makeGraphic(FlxG.width, 48, 0xFF000000);
    lowThing.alpha = 0.6;
    add(lowThing);
    add(guideText);
    updateModTexts();
}

function update(elapsed:Float):Void {
    if (FlxG.state.controls.UP_P) {
        if (thingsSelectable) {
            selected--;
            if (selected < 0) selected = realIDs.length - 1;
            updateModTexts();
        }
    }
    if (FlxG.state.controls.DOWN_P) {
        if (thingsSelectable) {
            selected++;
            if (selected >= realIDs.length) selected = 0;
            updateModTexts();
        }
    }
    if (FlxG.state.controls.BACK && thingsSelectable) FlxG.switchState(new MainMenuState());
    if (FlxG.state.controls.ACCEPT && thingsSelectable) {
        thingsSelectable = false;
        initModInstall();
    }
}

function updateModTexts():Void {
    modNameText.text = modList[realIDs[selected]].name;
    modAuthorText.text = modList[realIDs[selected]].author + " || v" + modList[realIDs[selected]].version;
    modDescText.text = modList[realIDs[selected]].description;
}

function getMods():Void {
    getShit = try (Http.requestUrl("https://raw.githubusercontent.com/sayofthelor/YCE-MB-Database/master/uploadedMods.txt").split('\n')) catch (e:Dynamic) null;
    if (getShit == null) {
        trace("ERROR: Could not get mod list!");
        FlxG.switchState(new MainMenuState());
    }
    for (i in getShit) {
        var ID = try (Json.parse(Http.requestUrl("https://raw.githubusercontent.com/sayofthelor/YCE-MB-Database/master/mods/" + i + "/mod.json"))) catch (e:Dynamic) null;
        if (mod != null) {
            realIDs.push(i);
            modList.set(i, ID);
        }   
    }
    trace(modList);
}

var otherThing:FlxSprite;
function initModInstall():Void {
    otherThing = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
    otherThing.alpha = 0.9;
    add(otherThing);
    titleText = new FlxText(32, 32, FlxG.width - 64, "Downloading mod...\nGame will look frozen, it isn't!\n(DON'T PRESS F5!)", 32);
    titleText.alignment = "center";
    titleText.screenCenter();
    titleText.borderStyle = FlxTextBorderStyle.OUTLINE;
    titleText.borderSize = 4;
    add(titleText);
    var initShit = new Http("https://raw.githubusercontent.com/sayofthelor/YCE-MB-Database/master/mods/" + realIDs[selected] + "/mod.ycemod");
    initShit.onBytes = function(data) {
        File.saveBytes(Paths.get_modsPath() + "/tempMod.ycemod", data);
        InstallModScreen.path = Paths.get_modsPath() + "/tempMod.ycemod";
        FlxG.switchState(new InstallModScreen());
    }
    new FlxTimer().start(1, function() {
        trace("DOWNLOADING");
        initShit.request(false);
    });
}