package ch.inaffect.legiapp.view.screen
{
	import ch.inaffect.legiapp.Main;
	import ch.inaffect.legiapp.helper.EnumDiscount;
	import ch.inaffect.legiapp.helper.EnumOfferContingent;
	import ch.inaffect.legiapp.helper.ImgVO;
	import ch.inaffect.legiapp.helper.InternetChecker;
	import ch.inaffect.legiapp.helper.RequestRedeemOffers;
	import ch.inaffect.legiapp.helper.RequestSupplier;
	import ch.inaffect.legiapp.helper.StorageHandler;
	import ch.inaffect.legiapp.localisation.l18n;
	import ch.inaffect.legiapp.model.Model;
	import ch.inaffect.legiapp.theme.BaseLegiTheme;
	import ch.inaffect.legiapp.theme.LegiTheme;
	import ch.inaffect.legiapp.view.component.OfferBox;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollScreen;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	
	public class DetailOffer extends ScrollScreen
	{
		private var _data : Object;
		private var _header:Header;
		private var _shadowOfferBox:BlurFilter;
		private var _reqSupplier:RequestSupplier;
		private var _offerBoxY : int = -1;
		private var _offerBox : OfferBox;
		private var _redeemCard:LayoutGroup;
		private var _btnRedeem:Button;
		private var _ownerCard:LayoutGroup;
		private var _pendingOffers:Array;
		private var _flagRedeemPending:Boolean;
		private var _reqRedeemOffers:RequestRedeemOffers;
		private var _internetCheck:InternetChecker;
		
		public function DetailOffer()
		{
			super();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			_data = Model.detailObject;
			
			layout = new AnchorLayout;
			elasticity = 0.1;
			elasticSnapDuration = 0.2;
			scrollBarDisplayMode = SCROLL_BAR_DISPLAY_MODE_NONE;
			horizontalScrollPolicy = ScrollScreen.SCROLL_POLICY_OFF;
			paddingBottom = 10;
			backButtonHandler = backButton_triggeredHandler;
			
			_shadowOfferBox = BlurFilter.createDropShadow(BaseLegiTheme.SHADOW_DEPTH_LEVEL_3,1.58,BaseLegiTheme.BLACK);
			_shadowOfferBox.cache();
			
			_reqRedeemOffers = new RequestRedeemOffers;
			_reqRedeemOffers.addEventListener(Event.COMPLETE, onRedeemOfferFinished);
			_reqRedeemOffers.addEventListener(Event.IO_ERROR, onRedeemOffersError);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout;
			
			width = stage.stageWidth;
			height = stage.stageHeight;
			
			_reqSupplier = new RequestSupplier;
			_reqSupplier.flagLoadImage = false;
			_reqSupplier.stageWidth = stage.stageWidth;
			_reqSupplier.load(_data.supplierId);
			_reqSupplier.addEventListener(Event.COMPLETE, onLoadedSupplier);
			
			createHeader();
			createOfferBox();
			createRedeemCard();
			createOwnerCard();
			
			addChild(_ownerCard);
			addChild(_redeemCard);
			addChild(_offerBox);
			addChild(_header);
		}
		
		override protected function draw():void
		{
			super.draw();
			_header.y = verticalScrollPosition;
			
			if(_offerBoxY < 0) _offerBoxY = _offerBox.y;
			if(verticalScrollPosition > 0)
			{
				_offerBox.y = _offerBoxY + verticalScrollPosition * 0.3;
			}
			else
			{
				_offerBox.y = _offerBoxY;
			}
			_offerBox.filter = _shadowOfferBox;
		}
		
		private function createHeader() : void
		{
			var btnSettings : Button = new Button;
			btnSettings.styleNameList.add(LegiTheme.STYLE_BUTTON_SETTINGS);
			
			var btnSocial : Button = new Button;
			btnSocial.styleNameList.add(LegiTheme.STYLE_BUTTON_SHARE);
			
			var btnBack : Button = new Button;
			btnBack.label = "to Screen 1";
			btnBack.styleNameList.add( Button.ALTERNATE_STYLE_NAME_BACK_BUTTON );
			btnBack.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
			
			_header = new Header();
			_header.layoutData = new AnchorLayoutData(0,0,NaN,0);
			_header.rightItems = new <DisplayObject>[ btnSocial,btnSettings ];
			_header.leftItems = new <DisplayObject>[ btnBack ];
		}
		
		private function createOfferBox() : void
		{
			var imgVO : ImgVO = Model.getImgVO(width);
			var aLayoutData : AnchorLayoutData = new AnchorLayoutData(0,0,NaN,0);
			aLayoutData.topAnchorDisplayObject = _header;
			
			_offerBox = new OfferBox;
			_offerBox.dummyTexture = Texture.fromEmbeddedAsset(LegiTheme.DummyImage);
			_offerBox.mediaUrl = (_data.mediaImage != null) ? _data.mediaImage[imgVO.url] : "";
			_offerBox.title = _data.title;
			_offerBox.shortInfo = _data.shortInfo;
			_offerBox.txtBgAlpha = 0.95;
			_offerBox.discount = Model.getDiscountType(EnumDiscount.ForFree);
			_offerBox.discountType = _data.legiDiscountType;
			_offerBox.discountValue = _data.legiDiscountValue;
			_offerBox.layoutData = aLayoutData;
			_offerBox.setSize(stage.stageWidth, Math.floor(imgVO.height * (width / imgVO.width)));
		}
		
		private function createRedeemCard() : void
		{
			var aLayoutData : AnchorLayoutData = new AnchorLayoutData(20,10,NaN,10);
			aLayoutData.topAnchorDisplayObject = _offerBox;
			
			_redeemCard = makeCard(aLayoutData);
			
			_btnRedeem = new Button;
			_btnRedeem.addEventListener(Event.TRIGGERED, onRedeem);
			_btnRedeem.layoutData = new AnchorLayoutData(10,10,NaN,10);;
			_btnRedeem.styleNameList.add(LegiTheme.STYLE_BUTTON_REDEEM_OFFER);
			_btnRedeem.label = l18n.getString(l18n.BTN_CONFIRM);
			
			aLayoutData = new AnchorLayoutData(20,10,10,10);
			aLayoutData.topAnchorDisplayObject = _btnRedeem;
			
			var redeemInfo : Label = new Label;
			redeemInfo.layoutData = aLayoutData;
			redeemInfo.width = stage.stageWidth;
			redeemInfo.styleNameList.add(LegiTheme.STYLE_LABEL_REDEEMINFO);
			redeemInfo.text = l18n.getString(l18n.TXT_REDEEMINFO, EnumOfferContingent.GetKey(_data.offerContingent).key);
			
			_redeemCard.addChild(_btnRedeem);
			_redeemCard.addChild(redeemInfo);
		}
		
		private function createOwnerCard() : void
		{
			var aLayoutData : AnchorLayoutData = new AnchorLayoutData(20,10,NaN,10);
			aLayoutData.topAnchorDisplayObject = _redeemCard;
			
			_ownerCard = makeCard(aLayoutData);
			
			var title : Label = new Label;
			title.width = stage.stageWidth;
			title.styleNameList.add(LegiTheme.STYLE_LABEL_EXTRALARGE);
			title.layoutData = new AnchorLayoutData(10,0,NaN,10);
			title.text = _data.title;
			
			aLayoutData = new AnchorLayoutData(5,0,NaN,10);
			aLayoutData.topAnchorDisplayObject = title;
			
			var detailDescription : Label = new Label;
			detailDescription.styleNameList.add(Label.ALTERNATE_STYLE_NAME_DETAIL);
			detailDescription.layoutData = aLayoutData;
			detailDescription.text = _data.detailDescription;
			
			aLayoutData = new AnchorLayoutData(20,15,NaN,15);
			aLayoutData.topAnchorDisplayObject = detailDescription;
			
			var imgLoader : ImageLoader = _reqSupplier.imageLoader;
			imgLoader.layoutData = aLayoutData;
			imgLoader.paddingBottom = 10;
			
			_ownerCard.addChild(title);
			_ownerCard.addChild(detailDescription);
			_ownerCard.addChild(imgLoader);
		}
		
		private function onLoadedSupplier(e : Event) : void
		{
		}
		
		private function onRedeem(e : Event) : void
		{
			_btnRedeem.isEnabled = false;
			
			var so : StorageHandler = StorageHandler.getInstance();
			if(so.pendingOffers != null)
			{
				var aOld : Array = so.pendingOffers;
				_pendingOffers = aOld.concat([{offerId:_data.offerId, useDate:new Date().getTime()}]);
			}
			_pendingOffers = [{offerId:_data.offerId, useDate:new Date().getTime()}];
			
			_flagRedeemPending = true;
			redeemOffers();
		}
		
		private function redeemOffers() : void
		{
			if(InternetChecker.NET_STATUS)
			{
				_reqRedeemOffers.load(_pendingOffers);
			}
			else
			{
				_internetCheck = InternetChecker.getInstance();
				_internetCheck.addEventListener(InternetChecker.EVENT_NET_STATUS_CHANGED, redeemOffersPending);
			}
		}
		
		private function redeemOffersPending(e : Event) : void
		{
			redeemOffers();
		}
		
		private function onRedeemOfferFinished(e : Event): void
		{
			_flagRedeemPending = false;
		}
		
		private function onRedeemOffersError(e : Event) : void
		{
			trace("*** could not redeem offers ***\n" + _reqRedeemOffers.errorMessage);
		}
		
		private function backButton_triggeredHandler() : void
		{
			dispatchEventWith(Main.EVENT_SHOW_YOUPAGE);
		}
		
		private function makeCard(ld : AnchorLayoutData) : LayoutGroup
		{
			var card : LayoutGroup = new LayoutGroup;
			card.layout = new AnchorLayout;
			card.layoutData = ld;
			card.styleNameList.add(LegiTheme.STYLE_CARD);
			
			return card;
		}
		
		private function onRemovedFromStage(e : Event) : void
		{
			removeEventListener(e.type, onRemovedFromStage);
			
			if(_internetCheck != null) _internetCheck.removeEventListener(e.type, redeemOffersPending);
			_btnRedeem.removeEventListener(e.type, onRedeem);
			_reqRedeemOffers.removeEventListener(e.type, onRedeemOfferFinished);
			_reqRedeemOffers.removeEventListener(e.type, onRedeemOffersError);
			_reqRedeemOffers.dispose();
			_reqSupplier.removeEventListener(Event.COMPLETE, onLoadedSupplier);
			_reqSupplier.dispose();
			
			_shadowOfferBox.dispose();

			removeChild(_header, true);
			removeChild(_offerBox,true);
			removeChild(_redeemCard,true);
			removeChild(_ownerCard, true);
		}
	}
}