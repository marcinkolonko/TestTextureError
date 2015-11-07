package ch.inaffect.legiapp.helper
{
	import ch.inaffect.legiapp.localisation.l18n;

	public class EnumOfferContingent
	{
		public static const ALWAYS : EnumOfferContingent = new EnumOfferContingent(l18n.ENUM_CONTINGENT_ALWAYS,10);
		public static const DAILY : EnumOfferContingent = new EnumOfferContingent(l18n.ENUM_CONTINGENT_DAILY,20);
		public static const WEEKLY : EnumOfferContingent = new EnumOfferContingent(l18n.ENUM_CONTINGENT_WEEKLY,30);
		public static const MONTHLY : EnumOfferContingent = new EnumOfferContingent(l18n.ENUM_CONTINGENT_MONTHLY,40);
		public static const PER_QUARTAL : EnumOfferContingent = new EnumOfferContingent(l18n.ENUM_CONTINGENT_QUARTAL,50);
		public static const PER_SEMESTER : EnumOfferContingent = new EnumOfferContingent(l18n.ENUM_CONTINGENT_SEMESTER,60);
		public static const ONCE : EnumOfferContingent = new EnumOfferContingent(l18n.ENUM_CONTINGENT_ONCE,70);
		
		private var _code : int;
		private var _key : String;
		
		public static function GetKey(code : int) : EnumOfferContingent
		{
			var entry : EnumOfferContingent;
			switch(code)
			{
				case 10:
					entry = EnumOfferContingent.ALWAYS;
					break;
				case 20:
					entry = EnumOfferContingent.DAILY;
					break;
				case 30:
					entry = EnumOfferContingent.WEEKLY;
					break;
				case 40:
					entry = EnumOfferContingent.MONTHLY;
					break;
				case 50:
					entry = EnumOfferContingent.PER_QUARTAL;
					break;
				case 60:
					entry = EnumOfferContingent.PER_SEMESTER;
					break;
			}
			return entry;
		}
		
		public function EnumOfferContingent(name : String, code : int) : void
		{
			_key = name;
			_code = code;
		}
		
		public function get key() : String
		{
			return _key;
		}
		
		public function get code() : int
		{
			return _code;
		}
	}
}