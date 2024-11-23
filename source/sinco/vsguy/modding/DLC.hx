package sinco.vsguy.modding;

import haxe.Json;
import lime.utils.Assets;

typedef DLCMeta = {
    public var api_version:String;
}

class DLC
{
	public static var dlcs:Array<String> = [];

	public static var DLC_FOLDER:String = './dlcs';
    public static var DLC_APIVER:String = '0.0.1';

	public static function updateDLCList()
	{
		var newlist:Array<String> = [];

		#if desktop
		var dlc_folders:Array<String> = FileSystem.readDirectory('$DLC_FOLDER/');

		for (file in dlc_folders)
		{
			if (file.contains('.') || file == 'readme.text')
			{
				dlc_folders.remove(file);
				trace('Removed file from dlc_folders: $file');
			}
		}

		for (folder in dlc_folders)
		{
			var path:String = '$DLC_FOLDER/$folder/';
			try {
                if (FileSystem.readDirectory(path).contains('dlc.json'))
				{
                    trace(path+'dlc.json');
                    try {
                        var dlcfile:DLCMeta = Json.parse(Assets.getText(path+'dlc.json'));
                        trace(dlcfile);

                        if (dlcfile.api_version == DLC_APIVER)
                            trace('$folder is a valid DLC');

                    } catch(e) {
                        dlc_folders.remove(folder);
                    }
				}
				else
				{
					dlc_folders.remove(folder);
				}
            } catch(e) {
                dlc_folders.remove(folder);
            }
		}

		for (folder in dlc_folders)
		{
			newlist.push(folder);
		}
		#end

		dlcs = newlist;
	}
}
