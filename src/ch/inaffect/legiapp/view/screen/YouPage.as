package ch.inaffect.legiapp.view.screen
{
	import flash.geom.Point;
	
	import ch.inaffect.legiapp.Main;
	import ch.inaffect.legiapp.theme.LegiTheme;
	import ch.inaffect.legiapp.view.component.OfferList;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.Screen;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class YouPage extends Screen
	{
		private var _dummyTexture:Texture;
		private var _header:Header;
		private var _offerList:OfferList;
		
		public function YouPage()
		{
			super();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(FeathersEventType.INITIALIZE, onAfterInitialize);
			
			_dummyTexture = Texture.fromEmbeddedAsset(Main.DummyImage);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout;
			
			width = stage.stageWidth;
			height = stage.stageHeight;
			
			createHeader();
			
			var aLayoutData : AnchorLayoutData = new AnchorLayoutData(0,10,0,10);
			aLayoutData.topAnchorDisplayObject = _header;
			
			_offerList = new OfferList();
			_offerList.layoutData = aLayoutData;
			_offerList.addEventListener(TouchEvent.TOUCH, onTouch);
			
			addChild(_offerList);
			addChild(_header);
		}
		
		private function onAfterInitialize(e : Event) : void
		{
			validate();
			start();
		}
		
		private function createHeader() : void
		{
			var btnSettings : Button = new Button;
			btnSettings.styleNameList.add(LegiTheme.STYLE_BUTTON_SETTINGS);
			
			var btnSocial : Button = new Button;
			btnSocial.styleNameList.add(LegiTheme.STYLE_BUTTON_SHARE);
			
			_header = new Header();
			_header.layoutData = new AnchorLayoutData(0,0,NaN,0);
			_header.rightItems = new <DisplayObject>[ btnSocial,btnSettings ];
			
			var btnBack : Button = new Button;
			btnBack.label = "to Screen 2";
			btnBack.styleNameList.add( Button.ALTERNATE_STYLE_NAME_BACK_BUTTON );
			btnBack.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
			_header.leftItems = new <DisplayObject>[ btnBack ];
		}
		
		private function start() : void
		{
			_offerList.start();
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(_offerList);
			if(touch == null) return;
			
			var pos:Point = touch.getLocation(_offerList);
			
			if (touch.phase == TouchPhase.BEGAN)
			{
				_offerList.touchBegan(pos, e.target, e.currentTarget);
			}
			else if (touch.phase == TouchPhase.MOVED)
			{
				_offerList.touchMoved(pos, e.target, e.currentTarget);
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				_offerList.touchEnded(pos, e.target, e.currentTarget);
			}
		}
		
		private function backButton_triggeredHandler() : void
		{
			dispatchEventWith(Main.EVENT_SHOW_DETAIL_OFFER);
		}
		
		private function onRemovedFromStage(e : Event) : void
		{
			removeEventListener(e.type, onRemovedFromStage);
			removeEventListener(FeathersEventType.INITIALIZE, onAfterInitialize);
			_dummyTexture.dispose();
			removeChild(_header, true);
			removeChild(_offerList, true);
			
			dispose();
		}
	}
}