package sinco.vsguy.modding;

class DLC
{

    public static var dlcs:Array<String> = [];

    public static function updateDLCList()
    {
        var newlist:Array<String> = [];

        #if desktop
        var dlc_folders:Array<String> = FileSystem.readDirectory('./dlcs/');
        for (file in dlc_folders)
        {
            if (file.contains('.') || file == 'readme.text')
            {
                dlc_folders.remove(file);
                trace('Removed file from dlc_folders: $file');
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