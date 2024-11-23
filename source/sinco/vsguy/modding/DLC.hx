package sinco.vsguy.modding;

class DLC
{

    public static var dlcs:Array<String> = [];

    public static function updateDLCList()
    {
        var newlist:Array<String> = [];

        #if desktop
        var dlc_folder:Array<String> = FileSystem.readDirectory('./dlcs/');
        trace('DLC Folder Content: $dlc_folder');
        #end
    }
    
}