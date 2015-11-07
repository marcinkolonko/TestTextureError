package ch.inaffect.legiapp.theme
{
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontWeight;
	
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Callout;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.TabBar;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleButton;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.themes.StyleNameFunctionTheme;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class BaseLegiTheme extends StyleNameFunctionTheme
	{
		[Embed(source="/../assets/atlas/LegiAtlas.png")]
		private static const ATLAS_BITMAP:Class;
		
		[Embed(source="/../assets/atlas/LegiAtlas.xml",mimeType="application/octet-stream")]
		private static const ATLAS_XML:Class;
		
		[Embed(source="/../assets/atlas/LegiAtlasNoScale.png")]
		private static const ATLAS_NO_SCALE_BITMAP:Class;
		
		[Embed(source="/../assets/atlas/LegiAtlasNoScale.xml",mimeType="application/octet-stream")]
		private static const ATLAS_NO_SCALE_XML:Class;
		
		public static const BLACK : uint = 0x000000;
		public static const WHITE : uint = 0xffffff;

		public static const LEGI_MAGENTA : uint = 0xe72360;
		public static const LEGI_MAGENTA_LIGHT : uint = 0xf49cb7;
		public static const LEGI_MAGENTA_DARK : uint = 0xb61a4a;
		
		public static const LEGI_GRAY_DARK : uint = 0x464547;
		public static const LEGI_GRAY_LIGHT : uint = 0xf0f0f0;
		
		public static const LEGI_TEXT_DARK : uint = 0x515151;
		public static const LEGI_TEXT_PROMPT : uint = 0xcccccc;
		public static const LEGI_TEXT_LIGHT : uint = WHITE;
		
		public static const SHADOW_DEPTH_LEVEL_1 : int = 5;
		public static const SHADOW_DEPTH_LEVEL_2 : int = 3;
		public static const SHADOW_DEPTH_LEVEL_3 : int = 1;
		
		protected static const MODAL_OVERLAY_COLOR : uint = BLACK;
		protected static const MODAL_OVERLAY_ALPHA : Number = 0.7;
		
		protected static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
		protected static const ORIGINAL_DPI_IPAD_RETINA:int =264;
		
		protected static const BUTTON_SCALE9_GRID : Rectangle = new Rectangle(4, 4, 24, 24);
		
		protected var scale : int = 1;
		protected var controlSize:Number;
		protected var gutterSize:Number;
		protected var smallGutterSize:Number;
		protected var gridSize:Number;
		
		protected var fontSizeSmall : Number;
		protected var fontSizeMedium : Number;
		protected var fontSizeLarge : Number;
		protected var fontSizeExtraLarge : Number;
		
		protected var atlas : TextureAtlas;
		protected var atlasNoScale : TextureAtlas;
		
		protected var regularFontDescription : FontDescription;
		protected var boldFontDescription : FontDescription;
		
//		protected var fontDarkRegMedium : ElementFormat;
//		protected var fontLightRegMedium : ElementFormat;
//		protected var fontDarkRegSmall : ElementFormat;
//		protected var fontLightRegSmall : ElementFormat;
//		protected var fontDarkRegLarge : ElementFormat;
//		protected var fontLightRegLarge : ElementFormat;
//		protected var fontDisabledSmall : ElementFormat;
//		protected var fontDisabledMedium : ElementFormat;
//		protected var fontDisabledLarge : ElementFormat;
//
//		protected var fontDarkBoldMedium : ElementFormat;
//		protected var fontLightBoldMedium : ElementFormat;
//		protected var fontDarkBoldSmall : ElementFormat;
//		protected var fontLightBoldSmall : ElementFormat;
//		protected var fontDarkBoldLarge : ElementFormat;
//		protected var fontLightBoldLarge : ElementFormat;
		
		protected var fontDisabledSmall : TextFormat;
		protected var fontDisabledMedium : TextFormat;
		protected var fontDisabledLarge : TextFormat;
		
		protected var fontDarkRegSmall : TextFormat;
		protected var fontDarkRegMedium : TextFormat;
		protected var fontDarkRegLarge : TextFormat;
		protected var fontLightRegSmall : TextFormat;
		protected var fontLightRegMedium : TextFormat;
		protected var fontLightRegLarge : TextFormat;

		protected var fontDarkBoldSmall : TextFormat;
		protected var fontDarkBoldMedium : TextFormat;
		protected var fontDarkBoldLarge : TextFormat;
		protected var fontLightBoldSmall : TextFormat;
		protected var fontLightBoldMedium : TextFormat;
		protected var fontLightBoldLarge : TextFormat;

		protected var fontPromptRegMedium : TextFormat;

		protected var fontName : String;
		protected var fontNameBold : String;
		
		private var _originalDPI : int;
		private var _scaleToDPI : Boolean;
		
		protected static function popUpOverlayFactory() : DisplayObject
		{
			var quad : Quad = new Quad(100, 100, MODAL_OVERLAY_COLOR);
			quad.alpha = MODAL_OVERLAY_ALPHA;
			return quad;
		}
		
		protected static function textRendererFactory() : TextFieldTextRenderer
		{
			var tr : TextFieldTextRenderer = new TextFieldTextRenderer();
			tr.embedFonts = true;
			tr.isHTML = true;
			tr.antiAliasType = AntiAliasType.ADVANCED;
			return tr;
		}
		
		protected static function textEditorFactory():StageTextTextEditor
		{
			return new StageTextTextEditor();
		}
		
		public function BaseLegiTheme(scaleToDPI : Boolean = true)
		{
			super();
			
			_scaleToDPI = scaleToDPI;
			
			createTextureAtlas();
			initialize();
		}
		
		override public function dispose():void
		{
			if(atlas)
			{
				atlas.dispose();
				atlas = null;
			}
			
			if(atlasNoScale)
			{
				atlasNoScale.dispose();
				atlasNoScale = null;
			}
			
			super.dispose();
		}
		
		private function createTextureAtlas():void
		{
			var atlasTexture : Texture = Texture.fromEmbeddedAsset(ATLAS_BITMAP, true,false, Starling.contentScaleFactor);
			var atlasXML:XML = XML(new ATLAS_XML());
			atlas = new TextureAtlas( atlasTexture, atlasXML );
			
			atlasTexture = Texture.fromEmbeddedAsset(ATLAS_NO_SCALE_BITMAP);
			atlasXML = XML(new ATLAS_NO_SCALE_XML());
			atlasNoScale = new TextureAtlas(atlasTexture, atlasXML);
		}
		
		public function get originalDPI():int
		{
			return this._originalDPI;
		}
		
		public function get scaleToDPI():Boolean
		{
			return _scaleToDPI;
		}
		
		protected function initialize() : void
		{
//			initScale();
			initDimensions();
			initFonts();
			initGlobals();
			initStyleProviders();
		}
		
		protected function initGlobals():void
		{
			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;
			
			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePadding = smallGutterSize;
		}
		
		protected function initScale():void
		{
			scale = Starling.contentScaleFactor;
		}
		
		protected function initDimensions():void
		{
			gridSize = Math.round(88 * scale);
			controlSize = Math.round(48 * scale);
			smallGutterSize = Math.round(8 * scale);
			gutterSize = Math.round(22 * scale);
		}
		
		protected function initFonts() : void
		{
			fontSizeSmall = Math.round(12 * scale);
			fontSizeMedium = Math.round(15 * scale);
			fontSizeLarge = Math.round(17 * scale);
			fontSizeExtraLarge = Math.round(20 * scale);
			
//			regularFontDescription = new FontDescription(_fontName, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
//			boldFontDescription = new FontDescription(_fontNameBold, FontWeight.BOLD, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
			
//			fontDarkRegSmall = new ElementFormat(regularFontDescription, smallFontSize, LEGI_TEXT_DARK);
//			fontDarkRegMedium = new ElementFormat(regularFontDescription, mediumFontSize, LEGI_TEXT_DARK);
//			fontDarkRegLarge = new ElementFormat(regularFontDescription, largeFontSize, LEGI_TEXT_DARK);
//			fontLightRegSmall = new ElementFormat(regularFontDescription, smallFontSize, LEGI_TEXT_LIGHT);
//			fontLightRegMedium = new ElementFormat(regularFontDescription, mediumFontSize, LEGI_TEXT_LIGHT);
//			fontLightRegLarge = new ElementFormat(regularFontDescription, largeFontSize, LEGI_TEXT_LIGHT);
//
//			fontDarkBoldSmall = new ElementFormat(boldFontDescription, smallFontSize, LEGI_TEXT_DARK);
//			fontDarkBoldMedium = new ElementFormat(boldFontDescription, mediumFontSize, LEGI_TEXT_DARK);
//			fontDarkBoldLarge = new ElementFormat(boldFontDescription, largeFontSize, LEGI_TEXT_DARK);
//			fontLightBoldSmall = new ElementFormat(boldFontDescription, smallFontSize, LEGI_TEXT_LIGHT);
//			fontLightBoldMedium = new ElementFormat(boldFontDescription, mediumFontSize, LEGI_TEXT_LIGHT);
//			fontLightBoldLarge = new ElementFormat(boldFontDescription, largeFontSize, LEGI_TEXT_LIGHT);
//			
//			fontDisabledSmall = new ElementFormat(regularFontDescription, smallFontSize, LEGI_GRAY_LIGHT);
//			fontDisabledMedium = new ElementFormat(regularFontDescription, mediumFontSize, LEGI_GRAY_LIGHT);
//			fontDisabledLarge = new ElementFormat(regularFontDescription, largeFontSize, LEGI_GRAY_LIGHT);
			
			fontLightRegSmall = new TextFormat(fontName, fontSizeSmall, LEGI_TEXT_LIGHT);
			fontLightRegMedium = new TextFormat(fontName, fontSizeMedium, LEGI_TEXT_LIGHT);
			fontLightRegLarge = new TextFormat(fontName, fontSizeLarge, LEGI_TEXT_LIGHT);
			fontDarkRegSmall = new TextFormat(fontName, fontSizeSmall, LEGI_TEXT_DARK);
			fontDarkRegMedium = new TextFormat(fontName, fontSizeMedium, LEGI_TEXT_DARK);
			fontDarkRegLarge = new TextFormat(fontName, fontSizeLarge, LEGI_TEXT_DARK);

			fontLightBoldSmall = new TextFormat(fontName, fontSizeSmall, LEGI_TEXT_LIGHT, FontWeight.BOLD);
			fontLightBoldMedium = new TextFormat(fontName, fontSizeMedium, LEGI_TEXT_LIGHT, FontWeight.BOLD);
			fontLightBoldLarge = new TextFormat(fontName, fontSizeLarge, LEGI_TEXT_LIGHT, FontWeight.BOLD);
			fontDarkBoldSmall = new TextFormat(fontName, fontSizeSmall, LEGI_TEXT_DARK, FontWeight.BOLD);
			fontDarkBoldMedium = new TextFormat(fontName, fontSizeMedium, LEGI_TEXT_DARK, FontWeight.BOLD);
			fontDarkBoldLarge = new TextFormat(fontName, fontSizeLarge, LEGI_TEXT_DARK, FontWeight.BOLD);
			
			fontPromptRegMedium = new TextFormat(fontName, fontSizeMedium, LEGI_TEXT_PROMPT);
			
			fontDisabledSmall = new TextFormat(fontName, fontSizeSmall, LEGI_GRAY_LIGHT);
			fontDisabledMedium = new TextFormat(fontName, fontSizeMedium, LEGI_GRAY_LIGHT);
			fontDisabledLarge = new TextFormat(fontName, fontSizeLarge, LEGI_GRAY_LIGHT);
		}
		
		protected function initStyleProviders():void
		{
			// Button
			getStyleProviderForClass(Button).defaultStyleFunction = setButtonStyles;

			// ButtonGroup
			getStyleProviderForClass(ButtonGroup).defaultStyleFunction = setButtonGroupStyles;
			getStyleProviderForClass(Button).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_NAME_BUTTON, setButtonGroupButtonStyles);
			getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_NAME_BUTTON, setButtonGroupButtonStyles);
			
			// TabBar
			getStyleProviderForClass(TabBar).defaultStyleFunction = setTabBarStyles;
			getStyleProviderForClass(Button).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, setTabBarButtonStyles);
			getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, setTabBarButtonStyles);
			
			// Label
			getStyleProviderForClass(Label).defaultStyleFunction = setLabelStyles;
			getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_NAME_HEADING, setHeadingLabelStyles);
			getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_NAME_DETAIL, setDetailLabelStyles);
			
			// Header
			getStyleProviderForClass(Header).defaultStyleFunction = setHeaderStyles;
			
			// List Item Renderer
			getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = setItemRendererStyles;
			
			// TextInput
			getStyleProviderForClass(TextInput).defaultStyleFunction = setTextInputStyles;
		}
		
		/**
		 * Button Styles
		 */
		protected function setBaseButtonStyles(btn : Button) : void
		{
			btn.paddingTop = smallGutterSize;
			btn.paddingBottom = smallGutterSize;
			btn.paddingLeft = smallGutterSize;
			btn.paddingRight = smallGutterSize;
			btn.gap = smallGutterSize;
			btn.minGap = smallGutterSize;
			btn.minWidth = btn.minHeight = controlSize;
			btn.minTouchWidth = gridSize;
			btn.minTouchHeight = gridSize;
			
			btn.defaultLabelProperties.textFormat = fontLightRegMedium;
		}
		
		protected function setButtonStyles(btn : Button) : void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = LEGI_MAGENTA;
			skinSelector.setValueForState(LEGI_MAGENTA_DARK, Button.STATE_DOWN, false);
			skinSelector.setValueForState(LEGI_MAGENTA_LIGHT, Button.STATE_DISABLED, false);
			
			btn.stateToSkinFunction = skinSelector.updateValue;
			
			setBaseButtonStyles(btn);
		}
		
		/**
		 * ButtonGroup
		 */
		protected function setButtonGroupStyles(btnGroup : ButtonGroup) : void
		{
			btnGroup.gap = this.smallGutterSize;
		}
		
		protected function setButtonGroupButtonStyles(btn : Button):void
		{
			setButtonStyles(btn);
		}
		
		/**
		 * TabBar
		 */
		protected function setTabBarStyles(tabBar:TabBar):void
		{
			tabBar.minHeight = 48;
			tabBar.distributeTabSizes = true;
		}
		
		protected function setTabBarButtonStyles(btn:Button):void
		{
			setBaseButtonStyles(btn);
			
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			
			if(btn is ToggleButton)
			{
				skinSelector.defaultValue = LEGI_MAGENTA;
				skinSelector.setValueForState(LEGI_MAGENTA, Button.STATE_UP, false);
				skinSelector.setValueForState(LEGI_MAGENTA_DARK, Button.STATE_DOWN, false);
				
				skinSelector.defaultSelectedValue = LEGI_MAGENTA_DARK;
				skinSelector.setValueForState(LEGI_MAGENTA_DARK, Button.STATE_UP, true);
				skinSelector.setValueForState(LEGI_MAGENTA, Button.STATE_DOWN, true);
			}
			btn.stateToSkinFunction = skinSelector.updateValue;
			
			if(btn is ToggleButton)
			{
				ToggleButton(btn).defaultSelectedLabelProperties.textFormat = fontLightRegMedium;
			}
		}
		
		/**
		 * Label
		 */
		protected function setLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = fontDarkRegMedium;
		}
		protected function setHeadingLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = fontDarkBoldLarge;
		}
		protected function setDetailLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = fontDarkRegMedium;
		}
		
		/**
		 * Header
		 */
		protected function setHeaderStyles(header : Header) : void
		{
			var shadow : BlurFilter = BlurFilter.createDropShadow(SHADOW_DEPTH_LEVEL_1, 1.57, BLACK, 0.5, 0.5);
			shadow.cache();
			header.filter = shadow;
			header.backgroundSkin = new Quad(10,10,LEGI_MAGENTA);
		}
		
		/**
		 * List Renderer
		 */
		protected function setItemRendererStyles(renderer : BaseDefaultItemRenderer) : void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = WHITE;
			skinSelector.defaultSelectedValue = LEGI_GRAY_LIGHT;
			skinSelector.setValueForState(LEGI_GRAY_LIGHT, Button.STATE_DOWN, false);
			skinSelector.setValueForState(WHITE, Button.STATE_DOWN, true);
			renderer.stateToSkinFunction = skinSelector.updateValue;
			
			renderer.defaultLabelProperties.textFormat = fontDarkRegMedium;
			
			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.smallGutterSize;
			renderer.paddingLeft = this.gutterSize + this.smallGutterSize;
			renderer.paddingRight = this.gutterSize;
			renderer.gap = this.gutterSize;
			renderer.minGap = this.gutterSize;
			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.gutterSize;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			renderer.minWidth = this.gridSize;
			renderer.minHeight = this.gridSize;
			renderer.minTouchWidth = this.gridSize;
			renderer.minTouchHeight = this.gridSize;
		}
		
		/**
		 * TextInput
		 */
		protected function setBaseTextInputStyles(input:TextInput):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();			
			skinSelector.defaultValue = LEGI_GRAY_LIGHT;
			skinSelector.setValueForState(LEGI_GRAY_LIGHT, TextInput.STATE_FOCUSED);
			input.stateToSkinFunction = skinSelector.updateValue;
			
			input.minWidth = controlSize;
			input.minHeight = controlSize;
			input.minTouchWidth = gridSize;
			input.minTouchHeight = gridSize;
			input.gap = smallGutterSize;
			input.padding = smallGutterSize;
			
			input.textEditorProperties.fontFamily = fontName;
			input.textEditorProperties.fontSize = fontSizeMedium;
			input.textEditorProperties.color = LEGI_MAGENTA;
			
			input.promptFactory = function():ITextRenderer
			{
				var textRenderer : TextFieldTextRenderer = new TextFieldTextRenderer();
				
				textRenderer.textFormat = fontPromptRegMedium;
				textRenderer.embedFonts = true;
				
				return textRenderer;
			}
		}
		
		protected function setTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);
		}
	}
}