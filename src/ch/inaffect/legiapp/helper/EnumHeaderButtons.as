package ch.inaffect.legiapp.helper
{
	public class EnumHeaderButtons
	{
		public static const SETTINGS : EnumHeaderButtons = new EnumHeaderButtons(10);
		public static const FILTER : EnumHeaderButtons = new EnumHeaderButtons(20);
		public static const BACK : EnumHeaderButtons = new EnumHeaderButtons(30);
		public static const BRANDING : EnumHeaderButtons = new EnumHeaderButtons(40);
		
		private var _id : int;
		
		public function EnumHeaderButtons(id : int) : void
		{
			_id = id;
		}
		
		public function get id() : int
		{
			return _id;
		}
	}
}