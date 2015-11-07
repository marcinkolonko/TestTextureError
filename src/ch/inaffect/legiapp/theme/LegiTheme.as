package ch.inaffect.legiapp.theme
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.engine.FontWeight;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.TabBar;
	import feathers.display.Scale9Image;
	import feathers.layout.AnchorLayout;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	
	import ch.inaffect.legiapp.Main;

	public class LegiTheme extends BaseLegiTheme
	{
		public static const STYLE_BUTTONGROUP_FILTER : String = "styleFilterButtonGroup";
		public static const STYLE_TABBAR_FILTER : String = "styleFilterTabbar";
		public static const STYLE_BUTTON_REDEEM_OFFER : String = "styleBtnConfirm";
		public static const STYLE_BUTTON_GRAY : String = "styleBtnGray";
		public static const STYLE_BUTTON_SETTINGS : String = "styleBtnSettings";
		public static const STYLE_BUTTON_SHARE : String = "styleBtnShare";
		public static const STYLE_BUTTON_FILTER : String = "styleBtnFilter";
		public static const STYLE_LABEL_DISCOUNT : String = "styleLebelDiscount";
		public static const STYLE_LABEL_REDEEMINFO : String = "styleLabelRedeemInfo";
		public static const STYLE_LABEL_EXTRALARGE : String = "styleLabelExtraLarge";
		public static const STYLE_LABEL_EXTRALARGE_LIGHT : String = "styleLabelExtraLargeLight";
		public static const STYLE_CARD : String = "styleCard";
		public static const STYLE_OFFERBOX : String = "styleOfferBox";
		
		public static const CARD_SCALE9_GRID : Rectangle = new Rectangle(6,6,24,24);
		
		[Embed(source="/../assets/images/LegiLogo.png")]
		public static const TitleImage : Class;
		
		[Embed(source="/../assets/images/legi_benefitsymbol.png")]
		public static const LegiDiscountImage:Class;
		
		[Embed(source="/../assets/images/dummy.png")]
		public static const DummyImage : Class;
		
		[Embed(
			source = "/../assets/fonts/OpenSans-Regular.ttf",
			fontName = "OpenSans",
			mimeType="application/x-font",
			advancedAntiAliasing="true",
			embedAsCFF="false")]
		protected static const OpenSansRegular : Class;
		
		[Embed(
			source="/../assets/fonts/OpenSans-Bold.ttf",
			fontName="OpenSans",
			fontWeight="bold",
			mimeType="application/x-font",
			advancedAntiAliasing="true",
			embedAsCFF="false")
		]
		protected static const OpenSansBold : Class;
		
		protected var fontLightBoldExtraLarge : TextFormat;
		protected var fontDarkBoldExtraLarge : TextFormat;
		protected var fontDarkRegSmallCentered : TextFormat;
		
		protected var btnRedeemOfferUp : Scale9Textures;
		protected var btnRedeemOfferDown : Scale9Textures;
		protected var bgCard:Scale9Textures;
		
		protected var icnShare : Texture;
		protected var icnSettings : Texture;
		protected var icnFilter : Texture;
		
		public function LegiTheme(scaleToDPI:Boolean=true)
		{
			fontName = "OpenSans";

			super(scaleToDPI);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			initTextures();
		}
		
		protected function initTextures() : void
		{
			var bucket : String = Main.GetBucket();
			
			btnRedeemOfferUp = new Scale9Textures(atlasNoScale.getTexture("btn-redeem-offer-up"), BUTTON_SCALE9_GRID);
			btnRedeemOfferDown = new Scale9Textures(atlasNoScale.getTexture("btn-redeem-offer-down"), BUTTON_SCALE9_GRID);
			bgCard = new Scale9Textures(atlasNoScale.getTexture("bg-card"), CARD_SCALE9_GRID);
			
			icnShare = atlas.getTexture("icn-share-" + bucket);
			icnSettings = atlas.getTexture("icn-settings-" + bucket);
			icnFilter = atlas.getTexture("icn-filter-" + bucket);
		}
		
		override protected function initFonts() : void
		{
			super.initFonts();
			
			fontLightBoldExtraLarge = new TextFormat(fontName, fontSizeExtraLarge, WHITE, FontWeight.BOLD);
			fontDarkBoldExtraLarge = new TextFormat(fontName, fontSizeExtraLarge, LEGI_GRAY_DARK, FontWeight.BOLD);
			fontDarkRegSmallCentered = new TextFormat(fontName, fontSizeSmall, LEGI_GRAY_DARK, null,null,null,null,null,TextFormatAlign.CENTER);
		}
		
		override protected function initStyleProviders() : void
		{
			super.initStyleProviders();
			
			// Button
			getStyleProviderForClass(Button).setFunctionForStyleName(STYLE_BUTTON_REDEEM_OFFER, setRedeemOfferBtnStyles);
			getStyleProviderForClass(Button).setFunctionForStyleName(STYLE_BUTTON_GRAY, setGrayBtnStyles);
			getStyleProviderForClass(Button).setFunctionForStyleName(STYLE_BUTTON_SETTINGS, setSettingsBtnStyles);
			getStyleProviderForClass(Button).setFunctionForStyleName(STYLE_BUTTON_SHARE, setShareBtnStyles);
			getStyleProviderForClass(Button).setFunctionForStyleName(STYLE_BUTTON_FILTER, setFilterBtnStyles);
			
			// Label
			getStyleProviderForClass(Label).setFunctionForStyleName(STYLE_LABEL_DISCOUNT, setDiscountLabelStyles);
			getStyleProviderForClass(Label).setFunctionForStyleName(STYLE_LABEL_REDEEMINFO, setRedeemInfoLabelStyles);
			getStyleProviderForClass(Label).setFunctionForStyleName(STYLE_LABEL_EXTRALARGE, setExtraLargeLabelStyles);
			getStyleProviderForClass(Label).setFunctionForStyleName(STYLE_LABEL_EXTRALARGE_LIGHT, setExtraLargeLightLabelStyles);
			
			// TabBar
			getStyleProviderForClass(TabBar).setFunctionForStyleName(STYLE_TABBAR_FILTER, setFilterTabBarStyles);
			
			// LayoutGroup
			getStyleProviderForClass(LayoutGroup).setFunctionForStyleName(STYLE_CARD, setCardStyles);
			getStyleProviderForClass(LayoutGroup).setFunctionForStyleName(STYLE_OFFERBOX, setOfferBoxStyles);
		}
		
		protected function setFilterBtnStyles(btn : Button) : void
		{
			var icon : Image = new Image(icnFilter);
			
			setButtonStyles(btn);
			btn.defaultIcon = icon;
		}
		
		protected function setShareBtnStyles(btn : Button) : void
		{
			var icon : Image = new Image(icnShare);
			
			setButtonStyles(btn);
			btn.defaultIcon = icon;
		}
		
		protected function setSettingsBtnStyles(btn : Button) : void
		{
			var icon : Image = new Image(icnSettings);
			
			setButtonStyles(btn);
			btn.defaultIcon = icon;
		}
		
		protected function setRedeemOfferBtnStyles(btn : Button) : void
		{
			setBaseButtonStyles(btn);
			
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = btnRedeemOfferUp;
			skinSelector.setValueForState(btnRedeemOfferDown, Button.STATE_DOWN, false);
			
			btn.stateToSkinFunction = skinSelector.updateValue;
			btn.defaultLabelProperties.textFormat = fontLightBoldMedium;
		}
		
		protected function setGrayBtnStyles(btn : Button) : void
		{
			setBaseButtonStyles(btn);
			
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = LEGI_GRAY_LIGHT;
			skinSelector.setValueForState(LEGI_GRAY_LIGHT, Button.STATE_UP, false);
			skinSelector.setValueForState(LEGI_GRAY_DARK, Button.STATE_DOWN, false);
			
			btn.stateToSkinFunction = skinSelector.updateValue;
			btn.defaultLabelProperties.textFormat = fontDarkRegMedium;
			btn.downLabelProperties.textFormat = fontLightRegMedium;
		}
		
		protected function setFilterTabBarStyles(tabBar : TabBar) : void
		{
			tabBar.paddingTop = 50;
			tabBar.direction = TabBar.DIRECTION_HORIZONTAL;
			tabBar.distributeTabSizes = true;
		}
		
		protected function setDiscountLabelStyles(label : Label) : void
		{
			label.textRendererProperties.textFormat = fontLightBoldMedium;
		}
		
		protected function setRedeemInfoLabelStyles(label : Label) : void
		{
			label.textRendererProperties.textFormat = fontDarkRegSmallCentered;
		}
		
		protected function setExtraLargeLabelStyles(label : Label) : void
		{
			label.textRendererProperties.textFormat = fontDarkBoldExtraLarge;
		}
		
		protected function setExtraLargeLightLabelStyles(label : Label) : void
		{
			label.textRendererProperties.textFormat = fontLightBoldExtraLarge;
		}
		
		protected function setCardStyles(card : LayoutGroup) : void
		{
			card.layout = new AnchorLayout;
			card.backgroundSkin = new Scale9Image(bgCard);
		}
		
		protected function setOfferBoxStyles(box : LayoutGroup) : void
		{
			box.layout = new AnchorLayout;
			box.backgroundSkin = new Quad(10,10,0xffffff);
		}
	}
}