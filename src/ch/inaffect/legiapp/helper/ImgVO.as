package ch.inaffect.legiapp.helper
{
	public class ImgVO
	{
		public var width : int;
		public var height : int;
		public var url : String;
		
		public function ImgVO(w : int, h : int, s : String) : void
		{
			width = w;
			height = h;
			url = s;
		}
	}
}