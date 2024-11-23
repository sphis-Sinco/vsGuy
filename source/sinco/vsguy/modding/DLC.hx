package sinco.vsguy.modding;

class DLC
{

    public static var dlcs:Array<String> = [];

    public static var DLC_FOLDER:String = './dlcs';

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
            var isfolder:Bool = false;
            try {
                isfolder = FileSystem.isDirectory('$DLC_FOLDER/$folder/');
            } catch(e) {}

            if (isfolder)
                trace('$folder is a folder (with something in it)!');
            else {
                trace('$folder is not a folder (with anything in it)!');
                dlc_folders.remove(folder);
            }
        }

        trace('DLC Folder Content: $dlc_folders');

        for (folder in dlc_folders)
        {
            trace('Added folder to newlist $folder');
            newlist.push(folder);
        }
        #end

        dlcs = newlist;
    }
    
}