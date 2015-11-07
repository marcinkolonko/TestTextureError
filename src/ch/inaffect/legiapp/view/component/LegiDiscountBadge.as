package ch.inaffect.legiapp.view.component
{
	import avmplus.getQualifiedClassName;
	
	import ch.inaffect.legiapp.theme.LegiTheme;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class LegiDiscountBadge extends LayoutGroup
	{		
		private var _discount : String;
		private var _imgLoader:ImageLoader;
		private var _badge:Texture;
		
		public function LegiDiscountBadge()
		{
			super();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			layout = new AnchorLayout;
			layoutData = new AnchorLayoutData(20,20);
			
			_badge = Texture.fromEmbeddedAsset(LegiTheme.LegiDiscountImage);
		}
		
		override protected function initialize() : void
		{
			_imgLoader = new ImageLoader();
			_imgLoader.x = 0;
			_imgLoader.y = 0;
			_imgLoader.maintainAspectRatio = true;
			_imgLoader.source = _badge;
			
			var label : Label = new Label();
			label.styleNameList.add(LegiTheme.STYLE_LABEL_DISCOUNT);
			label.layoutData = new AnchorLayoutData(NaN,NaN,NaN,NaN,0,3);
			label.text = _discount;
			
			addChild(_imgLoader);
			addChild(label);
		}
		
		public function set discount(s : String) : void
		{
			_discount = s;
		}
		
		private function onRemoveFromStage(e : Event) : void
		{
			trace("*** remove: " + getQualifiedClassName(this) + " ***");
			removeEventListener(e.type, onRemoveFromStage);
			
			_badge.dispose();
			_imgLoader.dispose();
			
			dispose();
		}
	}
}