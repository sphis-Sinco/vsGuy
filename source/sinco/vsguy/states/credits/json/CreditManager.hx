package sinco.vsguy.states.credits.json;

class CreditManager
{
	public static var creditItemAPIVER:Float = 0.2;

	public static function templateCredits():CreditsList
	{
		return {
			api_ver: creditItemAPIVER,
			credits: [
				{
					header: {
						text: 'Template',
						users: [
							{
								person: 'Sinco',
								role: 'Creator'
							}
						]
					}
				}
			]
		}
	}
}
