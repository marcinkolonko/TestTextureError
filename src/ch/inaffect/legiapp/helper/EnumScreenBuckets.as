package ch.inaffect.legiapp.helper
{
	public class EnumScreenBuckets
	{
		public static const XXXHDPI : EnumScreenBuckets = new EnumScreenBuckets("xxxhdpi", 4);
		public static const XXHDPI : EnumScreenBuckets = new EnumScreenBuckets("xxhdpi", 3);
		public static const XHDPI : EnumScreenBuckets = new EnumScreenBuckets("xhdpi", 2);
		public static const HDPI : EnumScreenBuckets = new EnumScreenBuckets("hdpi", 1.5);
		public static const MDPI : EnumScreenBuckets = new EnumScreenBuckets("mdpi", 1);
		
		private var _bucket : String;
		private var _scale : Number;
		
		public function EnumScreenBuckets(bucket : String, scale : Number)
		{
			_bucket = bucket;
			_scale = scale;
		}
		
		public function get bucket() : String
		{
			return _bucket;
		}
		
		public function get scale() : Number
		{
			return _scale;
		}
	}
}