package sinco.vsguy.data;

typedef ShopItem =
{
	var name:String;
	var description:String;

	var price:Float;

	var sincoInterested:Bool;
	var sincoReact:Bool;
}

class ShopItemManager
{
    public static function blankShopItem():ShopItem
    {
        return {
            name: "Blank Item",
            description: "A Blank Item most likely to avoid a\ngame crash",
            price: 0.0,
            sincoInterested: false,
			sincoReact: true
        };
    }
}