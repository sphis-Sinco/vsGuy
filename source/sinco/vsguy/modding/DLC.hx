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
			if (file.contains('.') || file == 'readme.txt')
			{
				dlc_folders.remove(file);
			}
		}

        trace(dlc_folders);
		for (folder in dlc_folders)
		{
            var valid:Bool = false;
			var path:String = '$DLC_FOLDER/$folder/';

			try {
                var dir = FileSystem.readDirectory(path);
                
                var dlcfile:DLCMeta = Json.parse(Assets.getText(path+'dlc.json'));

                if (dlcfile.api_version == DLC_APIVER) {
                    valid = true;
                    trace('$folder is a valid DLC');
                }
            } catch(e)
            {
                trace(e);
            }

            if (!valid)
				dlc_folders.remove(folder);
		}
        
        trace(dlc_folders);

		for (folder in dlc_folders)
		{
			newlist.push(folder);
		}
		#end

		dlcs = newlist;
	}
}
