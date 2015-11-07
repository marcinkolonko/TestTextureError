package com.doitflash.starling
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * 
	 * @author Hadi Tavakoli - 7/26/2012 4:51 PM
	 */
	public class MyStarlingSprite extends Sprite 
	{
		protected var _bg:MySprite;
		protected var _bgTexture:Texture;
		protected var _defBgTexture:Texture;
		protected var _bgImage:Image;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _margin:Number = 0;
		protected var _marginX:Number = 0;
		protected var _marginY:Number = 0;
		protected var _xml:XML;
		protected var _configXml:XML;
		protected var _data:Object = {};
		protected var _id:int;
		protected var _base:Object;
		protected var _holder:Object;
		protected var _nativeStage:Object;
		
		protected var _bgAlpha:Number = 1;
		protected var _bgColor:uint = 0x000000;
		protected var _bgStrokeAlpha:Number = 1;
		protected var _bgStrokeColor:uint = 0xFF0000;
		protected var _bgStrokeThickness:Number = 1;
		
		protected var _touchData:Object = {};
		
		public function MyStarlingSprite():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
		}
		
		private function onStageAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			if (_defBgTexture)
			{
				_bgImage = new Image(_defBgTexture);
				this.addChildAt(_bgImage, 0);
			}
			
			if (_bgTexture) 
			{
				_bgImage = new Image(_bgTexture);
				this.addChildAt(_bgImage, 0);
			}
		}
		
		public function drawBg($bgAlpha:Number=1, $bgColor:uint=0xFFFFFF, $bgStrokeAlpha:Number=1, $bgStrokeColor:uint=0x000000, $bgStrokeThickness:Number=1):void
		{
			_bg = new MySprite();
			if($bgAlpha) _bg.bgAlpha = _bgAlpha = $bgAlpha;
			if($bgColor) _bg.bgColor = _bgColor = $bgColor;
			if($bgStrokeAlpha) _bg.bgStrokeAlpha = _bgStrokeAlpha = $bgStrokeAlpha;
			if($bgStrokeColor) _bg.bgStrokeColor = _bgStrokeColor = $bgStrokeColor;
			if ($bgStrokeThickness) _bg.bgStrokeThickness = _bgStrokeThickness = $bgStrokeThickness;
			
			_bg.width = _width;
			_bg.height = _height;
			
			_bg.drawBg();
			_bgTexture = _bg.getTexture();
			
			if (stage && !_bgImage)
			{
				_bgImage = new Image(_bgTexture);
				this.addChildAt(_bgImage, 0);
			}
		}
		
		public function updateBg($image:Image=null, $texture:Texture=null):Boolean
		{
			if ($texture)
			{
				$image = new Image($texture);
			}
			
			if ($image) 
			{
				if (_bgImage)
				{
					_bgImage.dispose();
					this.removeChild(_bgImage);
				}
				
				_bgImage = $image;
				this.addChildAt(_bgImage, 0);
				
				return true;
			}
			
			if (!_bgImage) return false;
			
			_bgImage.dispose();
			this.removeChild(_bgImage);
			
			_bgTexture = _bg.getTexture();
			_bgImage = new Image(_bgTexture);
			this.addChildAt(_bgImage, 0);
			
			return true;
		}
		
		public function getBgImage():Image
		{
			if (_bgImage) return _bgImage;
			else return null;
		}
		
		protected function onResize(e:*=null):void 
		{
			if (_bg)
			{
				_bg.width = _width;
				_bg.height = _height;
			}
			
			if (_defBgTexture && _bgImage)
			{
				_bgImage.width = _width;
				_bgImage.height = _height;
			}
		}
		
		protected function toBoolean(a:String):Boolean
		{
			if (a == "true") return true;
			
			return false;
		}
		
//----------------------------------------------------------------------------------------------------- Getter - Setter
		
		public function get bgTexture():Texture
		{
			return _bgTexture;
		}
		
		public function get theBase():Object
		{
			return _base;
		}
		
		public function get myBase():Object
		{
			return _base;
		}
		
		public function set myBase(a:Object):void
		{
			_base = a;
		}
		
		public function set theBase(a:Object):void
		{
			_base = a;
		}
		
		public function get holder():Object
		{
			return _holder;
		}
		
		public function set holder(a:Object):void
		{
			_holder = a;
		}
		
		public function get nativeStage():Object
		{
			return _nativeStage;
		}
		
		public function set nativeStage(a:Object):void
		{
			_nativeStage = a;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(a:Number):void
		{
			if (_width != a)
			{
				_width = a;
				onResize();
			}
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(a:Number):void
		{
			if (_height != a)
			{
				_height = a;
				onResize();
			}
		}
		
		public function get margin():Number
		{
			return _margin;
		}
		
		public function set margin(a:Number):void
		{
			_margin = a;
		}
		
		public function get marginX():Number
		{
			return _marginX;
		}
		
		public function set marginX(a:Number):void
		{
			_marginX = a;
		}
		
		public function get marginY():Number
		{
			return _marginY;
		}
		
		public function set marginY(a:Number):void
		{
			_marginY = a;
		}
		
		public function get xml():XML
		{
			return _xml;
		}
		
		public function set xml(a:XML):void
		{
			_xml = a;
		}
		
		public function get configXml():XML
		{
			return _configXml;
		}
		
		public function set configXml(a:XML):void
		{
			_configXml = a;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(a:Object):void
		{
			_data = a;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(a:int):void
		{
			_id = a;
		}
		
		public function set defBgTexture(a:Texture):void
		{
			_defBgTexture = a;
		}
	}
	
}