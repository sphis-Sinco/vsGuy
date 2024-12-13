package sinco.vsguy.states.credits.json;

typedef CreditHeader =
{
	var text:String;
	var ?users:Array<CreditUser>;
}

typedef CreditUser =
{
	var person:String;
	var ?role:String;
}
