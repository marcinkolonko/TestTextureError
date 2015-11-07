package ch.inaffect.legiapp.model
{
	import ch.inaffect.legiapp.helper.EnumDiscount;
	import ch.inaffect.legiapp.helper.EnumImageDimensions;
	import ch.inaffect.legiapp.helper.ImgVO;

	public class Model
	{
		public static var languageTag:String;
		public static var dataObject:Vector.<Object>;
		public static var detailObject:Object;		
		
		//Discount Types by Number
		public static function getDiscountType(discountTypeNumber : int):String
		{
			var discountType:String;
			
			switch(discountTypeNumber)
			{
				case EnumDiscount.Percental:
					discountType = "%";
					break;
				
				case EnumDiscount.MoneyAmount:
					discountType = ".-";
					break;
				
				case EnumDiscount.ForFree:
					discountType = "FREE";
					break;
				
				case EnumDiscount.TwoForOne:
					discountType = "2/1";
					break;
				
				default:
					discountType = "";
			}
			return discountType;
		}
		
		public static function getItemAt(i : int) : Object
		{
			return dataObject[i];
		}
		
		public static function getImgVO(w : int) : ImgVO
		{
			var vo : ImgVO;
			
			if(EnumImageDimensions.OFFER_XS.width > w)
			{
				vo = EnumImageDimensions.OFFER_XS;
			}
			else if(EnumImageDimensions.OFFER_SM.width > w)
			{
				vo = EnumImageDimensions.OFFER_SM;
			}
			else if(EnumImageDimensions.OFFER_MD.width > w)
			{
				vo = EnumImageDimensions.OFFER_MD;
			}
			else
			{
				vo = EnumImageDimensions.OFFER_LG;
			}
			
			return vo;
		}
	}
}