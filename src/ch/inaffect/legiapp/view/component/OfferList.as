package ch.inaffect.legiapp.view.component
{
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Easing;
	import com.doitflash.consts.Orientation;
	import com.doitflash.events.ScrollEvent;
	import com.doitflash.starling.MySprite;
	import com.doitflash.starling.utils.list.List;
	import com.doitflash.starling.utils.scroller.Scroller;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import avmplus.getQualifiedClassName;
	
	import ch.inaffect.legiapp.Main;
	import ch.inaffect.legiapp.helper.EnumDiscount;
	import ch.inaffect.legiapp.helper.ImgVO;
	import ch.inaffect.legiapp.model.Model;
	import ch.inaffect.legiapp.theme.BaseLegiTheme;
	import ch.inaffect.legiapp.theme.LegiTheme;
	
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	
	public class OfferList extends LayoutGroup
	{
		private const ITEM_SPACE : Number = 10;
		private const NUMBER_COLUMNS : Number = 1;
		
		private var _touchTexture:MySprite;
		private var _list:List;
		private var _numItems:uint;
		private var _scroll:Scroller;
		private var _boxHeight:int;
		private var _globalPos:Point;
		private var _shadowOfferBox:BlurFilter;
		private var _dummyTexture : Texture = Texture.fromEmbeddedAsset(LegiTheme.DummyImage);
		
		public function OfferList()
		{
			super();
			trace(getQualifiedClassName(this));
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			_shadowOfferBox = BlurFilter.createDropShadow(BaseLegiTheme.SHADOW_DEPTH_LEVEL_3,1.58,BaseLegiTheme.BLACK);
			_shadowOfferBox.cache();
		}
		
		override protected function initialize() : void
		{
			super.initialize();
			layout = new AnchorLayout();
		}
		
		public function start() : void
		{
			initList();
		}
		
		public function replace(v : Vector.<Object>) : void
		{
			if(_list.items.length > 0) _list.removeAll();
			addItems(v);
		}
		
		private function initList() : void
		{
			_globalPos = localToGlobal(new Point(0,0));
			clipRect = new Rectangle(0, 0, width, height);
			
			var listHolder:Sprite = new Sprite();
			addChild(listHolder);
			
			_list = new List();
			_list.holder = listHolder;
			_list.itemsHolder = new Sprite();
			_list.orientation = Orientation.VERTICAL;
			_list.hDirection = Direction.LEFT_TO_RIGHT;
			_list.vDirection = Direction.TOP_TO_BOTTOM;
			_list.row = NUMBER_COLUMNS;
			_list.space = ITEM_SPACE;
			
			_scroll = new Scroller();
			_scroll.addEventListener(ScrollEvent.TOUCH_TWEEN_UPDATE, onScrollerUpdate);
			_scroll.boundWidth = width;
			_scroll.boundHeight = height - y;
			_scroll.content = _list.holder;
			_scroll.orientation = Orientation.VERTICAL;
			_scroll.easeType = Easing.Expo_easeOut;
			_scroll.duration = .3;
			_scroll.holdArea = 10;
			_scroll.isStickTouch = false;
			
			addItems(Model.dataObject);
		}
		
		private function onScrollerUpdate(e:ScrollEvent):void
		{
			optimizeScrolling();
		}
		
		private function addItems(v : Vector.<Object>):void
		{
			var length : int = v.length;
			var i:int;
			var boxWidth : int = stage.stageWidth - 20;
			var imgVO : ImgVO = Model.getImgVO(boxWidth);
			var box : OfferBox;
			var dummy : Texture = Texture.fromEmbeddedAsset(LegiTheme.DummyImage);
			
			_boxHeight = Math.floor(imgVO.height * (boxWidth / imgVO.width));

			for (i = 0; i < length; i++) 
			{
				box = new OfferBox();
				box.dummyTexture = dummy;
				box.mediaUrl = (v[i].mediaImage != null) ? v[i].mediaImage[imgVO.url] : "";
				box.title = v[i].title;
				box.shortInfo = v[i].shortInfo;
				box.discount = Model.getDiscountType(EnumDiscount.ForFree);
				box.discountType = v[i].legiDiscountType;
				box.discountValue = v[i].legiDiscountValue;
				box.setSize(boxWidth, _boxHeight);
				box.filter = _shadowOfferBox;
				_list.add(box);
			}
			_list.itemArrange();
			_list.holder.height = _list.itemsHolder.height;
			_list.itemsHolder.x = _list.holder.width - _list.itemsHolder.width >> 1;
			_list.itemsHolder.y = _list.holder.height - _list.itemsHolder.height >> 1;
			
			_numItems = _list.items.length;
			
			validate();
			optimizeScrolling();
		}
		
		private function optimizeScrolling():void
		{
			var box : OfferBox;
			var i : int;
			
			for (i = 0; i < _numItems; i++) 
			{
				box = _list.items[i].content as OfferBox;
				
				if (box.globalPosition.y > _globalPos.y - _boxHeight && box.globalPosition.y < _globalPos.y + height)
				{
					if(box.visible == false)
					{
//						box.dummyTexture = _dummyTexture;
						box.visible = true;
					}
				}
				else
				{
					if(box.visible == true) box.visible = false;
				}
			}
		}
		
		public function touchBegan($position:Point, $target:EventDispatcher, $currentTarget:EventDispatcher):void
		{
			_scroll.startScroll($position);
			
			var box : OfferBox = $target as OfferBox;
			if (box)
			{
				box.over();
			}
		}
		
		public function touchMoved($position:Point, $target:EventDispatcher, $currentTarget:EventDispatcher):void
		{
			_scroll.startScroll($position);
			
			var box : OfferBox = $target as OfferBox;			
			if (box && _scroll.isHoldAreaDone)
			{
				box.out();
			}
			
			optimizeScrolling();
		}
		
		public function touchEnded($position:Point, $target:EventDispatcher, $currentTarget:EventDispatcher):void
		{
			_scroll.fling();
			
			var box : OfferBox = $target as OfferBox;			
			if (box && box.isOver)
			{
				box.out();
				Model.detailObject = Model.dataObject[_list.getItemIndex(box)];
				dispatchEventWith(Main.EVENT_SHOW_DETAIL_OFFER);
			}
		}
		
		private function onRemoveFromStage(e : Event) : void
		{
			trace("*** remove: " + getQualifiedClassName(this) + " ***");
			removeEventListener(e.type, onRemoveFromStage);
			
			_scroll.removeEventListener(ScrollEvent.TOUCH_TWEEN_UPDATE, onScrollerUpdate);
			_list.removeAll();
			
			dispose();
		}
	}
}