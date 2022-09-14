function create():Void {
    state.optionShit.members = [];
    state.optionShit.add('mb', function() {
        trace(CoolUtil.getAllChartKeys());
        FlxG.switchState(new ModState("ModBrowser", mod));
    }, Paths.getSparrowAtlas('mbMenu'), 'modbrowser basic', 'modbrowser white');
    state.optionShit.add('c', function() {
        trace(CoolUtil.getAllChartKeys());
        FlxG.switchState(new ModState("Cleanup", mod));
    }, Paths.getSparrowAtlas('cleanupMenu'), 'cleanup basic', 'cleanup white');

}
function createPost():Void { state.bg.loadGraphic(Paths.image("browserBG")); }
