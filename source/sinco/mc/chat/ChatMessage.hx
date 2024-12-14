package sinco.mc.chat;

class ChatMessage extends FlxSpriteGroup
{
    public var messageBox:ChatBox;
	public var textField:FlxText = new FlxText(0, 0, 0, "Hello World", 16);

    public var textFieldPadding:Float = 2;

    public var timer:FlxTimer = new FlxTimer(new FlxTimerManager());

	override public function new(text:String = "Hello World")
	{
		super();

		messageBox = new ChatBox(0, FlxG.height - 120);
		messageBox.alpha = 0.5;
		messageBox.scrollFactor.set(0,0);

		textField.text = text;
		textField.setFormat(Paths.font('mc.ttf'), 16, FlxColor.WHITE);
		textField.alignment = LEFT;
		textField.setPosition(messageBox.x - textFieldPadding, messageBox.y + textFieldPadding);
		textField.scrollFactor.set(0, 0);

		add(messageBox);
		add(textField);

		timer.start(3, function(tmr:FlxTimer) {
            destroy();
        });
	}

    public function moveUp()
    {
		messageBox.y -= messageBox.height;
		textField.setPosition(messageBox.x - textFieldPadding, messageBox.y + textFieldPadding);
	}

}