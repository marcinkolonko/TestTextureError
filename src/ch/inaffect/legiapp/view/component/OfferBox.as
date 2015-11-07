package ch.inaffect.legiapp.view.component
{
	import flash.geom.Point;
	
	import ch.inaffect.legiapp.helper.EnumDiscount;
	import ch.inaffect.legiapp.model.Model;
	import ch.inaffect.legiapp.theme.BaseLegiTheme;
	import ch.inaffect.legiapp.theme.LegiTheme;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class OfferBox extends LayoutGroup
	{
		private var _imgLoader : ImageLoader;
		private var _legiDiscountGroup : LayoutGroup;
		private var _p : Point = new Point(0,0);
		private var _dummyTexture:Texture;
		private var _txtBgAlpha : Number = 0.7;
		private var _title:String;
		private var _shortInfo:String;
		private var _discount:String;
		private var _discountType:int;
		private var _discountValue:Number;
		private var _discountBadge:LegiDiscountBadge;
		private var _mediaUrl:String;
		private var _flagIsOver : Boolean = false;
		
		public function OfferBox()
		{
			super();
			addEventListener(starling.events.Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			styleNameList.add(LegiTheme.STYLE_OFFERBOX);
		}
		
		public function set dummyTexture(t : Texture) : void
		{
			_dummyTexture = t;
		}
		
		public function set mediaUrl(s : String) : void
		{
			_mediaUrl = s;
		}
		
		public function set title(s : String) : void
		{
			_title = s;
		}
		
		public function set shortInfo(s : String) : void
		{
			_shortInfo = s;
		}
		
		public function set txtBgAlpha(n : Number) : void
		{
			_txtBgAlpha = n;
		}
		
		public function set discount(s : String) : void
		{
			_discount = s;
		}
		
		public function set discountType(n : int) : void
		{
			_discountType = n;
		}
		
		public function set discountValue(n : Number) : void
		{
			_discountValue = n;
		}
		
		public function get globalPosition() : Point
		{
			return localToGlobal(_p);
		}
		
		public function get isOver() : Boolean
		{
			return _flagIsOver;
		}
		
		public function over() : void
		{
			_flagIsOver = true;
		}
		
		public function out() : void
		{
			_flagIsOver = false;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			addLegiDiscountGroup();
			addFooter();
		}
		
		private function addLegiDiscountGroup() : void
		{
			_imgLoader = new ImageLoader();
			_imgLoader.touchable = false;
			_imgLoader.width = width;
			_imgLoader.height = height;
			_imgLoader.maintainAspectRatio = true;
			_imgLoader.scaleContent = true;
			_imgLoader.source = _mediaUrl;
			
			if(_discountType != EnumDiscount.ForFree)
			{
				_discount = _discountValue + Model.getDiscountType(_discountType);
				if(_discountType == EnumDiscount.TwoForOne)
				{
					_discount = Model.getDiscountType(EnumDiscount.TwoForOne);
				}
			}

			_discountBadge = new LegiDiscountBadge();
			_discountBadge.discount = _discount;
			
			_legiDiscountGroup = new LayoutGroup();
			_legiDiscountGroup.touchable = false;
			_legiDiscountGroup.layout = new AnchorLayout();
			_legiDiscountGroup.addChild(_imgLoader);
			_legiDiscountGroup.addChild(_discountBadge);
			
			addChild(_legiDiscountGroup);
		}
		
		private function addFooter() : void
		{
			var footer : LayoutGroup = new LayoutGroup();
			footer.touchable = false;
			footer.layout = new AnchorLayout();
			footer.layoutData = new AnchorLayoutData(NaN,0,0,0);
			footer.backgroundSkin = getBackground(BaseLegiTheme.WHITE, _txtBgAlpha);
			
			var anchorLayoutData : AnchorLayoutData = new AnchorLayoutData(5,NaN,NaN,10);
			var title : Label = new Label();
			title.styleNameList.add(Label.ALTERNATE_STYLE_NAME_HEADING);
			title.layoutData = anchorLayoutData;
			title.text = _title;
			
			anchorLayoutData = new AnchorLayoutData(0,NaN,7,10);
			anchorLayoutData.topAnchorDisplayObject = title;
			
			var info : Label = new Label();
			info.styleNameList.add(Label.ALTERNATE_STYLE_NAME_DETAIL);
			info.layoutData = anchorLayoutData;
			info.text = _shortInfo;
			
			footer.addChild(title);
			footer.addChild(info);
			
			addChild(footer);
		}
		
		private function getBackground(color : uint, alpha : Number = 1) : Quad
		{
			var bg : Quad = new Quad(10,10,color);
			bg.alpha = alpha;
			return bg;
		}
		
		private function onRemoveFromStage(e : starling.events.Event) : void
		{
			removeEventListener(e.type, onRemoveFromStage);
			
			_dummyTexture.dispose();
			
			if(_imgLoader != null)
			{
				_imgLoader.dispose();
				removeChild(_imgLoader);
			}
			
			dispose();
		}
	}
}


