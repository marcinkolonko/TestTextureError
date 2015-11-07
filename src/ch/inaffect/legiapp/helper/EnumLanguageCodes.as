package ch.inaffect.legiapp.helper
{
	public class EnumLanguageCodes
	{
		public static const deCH : EnumLanguageCodes = new EnumLanguageCodes("de-CH");
		public static const frCH : EnumLanguageCodes = new EnumLanguageCodes("fr-CH");
		public static const itCH : EnumLanguageCodes = new EnumLanguageCodes("it-CH");
		
		private var _language : String;
		
		public function EnumLanguageCodes(lang : String) : void
		{
			_language = lang;
		}
		
		public function toString() : String
		{
			return _language;
		}
	}
}