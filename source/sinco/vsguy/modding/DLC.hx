package sinco.vsguy.modding;

import haxe.Json;
import lime.utils.Assets;

typedef DLCMeta = {
    public var api_version:String;
}

class DLC
{
	public static var dlcs:Array<String> = [];

	public static var DLC_FOLDER:String = 'dlcs';
    public static var DLC_APIVER:String = '0.0.1';

	public static function updateDLCList(?checks:Int = 2)
	{
		var newlist:Array<String> = [];
        var loops:Int = 0;

		#if desktop
		var dlc_folders:Array<String> = FileSystem.readDirectory('$DLC_FOLDER/');

		for (file in dlc_folders)
		{
			if (file.contains('.') || file == 'readme.txt')
			{
				dlc_folders.remove(file);
			}
		}

        // trace(dlc_folders);
        // dlc_folders.push('');
		
        while (loops < checks){
            for (i in 0...dlc_folders.length)
            {
                var folder = dlc_folders[i];
                var path:String = '$DLC_FOLDER/$folder/';

                try {
                    var dir = FileSystem.readDirectory(path);
                    
                    var dlcfile:DLCMeta = Json.parse(Assets.getText(path+'dlc.json'));

                    if (dlcfile.api_version != DLC_APIVER) {
                        dlc_folders.remove(folder);
                    }
                } catch(e)
                {
                    trace(e);
                    dlc_folders.remove(folder);
                }
            }
            loops++;
        }
        
        // trace(dlc_folders);

		for (folder in dlc_folders)
		{
			var path:String = '$DLC_FOLDER/$folder/';

			if (!folder.contains('.') || folder != 'readme.txt')
                {
                   if (FileSystem.isDirectory(path))
                    newlist.push(folder);
                }
		}
		#end

		dlcs = newlist;
	}
}
