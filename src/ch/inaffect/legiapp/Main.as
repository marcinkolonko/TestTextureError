package ch.inaffect.legiapp
{
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	
	import ch.inaffect.legiapp.helper.EnumLanguageCodes;
	import ch.inaffect.legiapp.helper.EnumScreenBuckets;
	import ch.inaffect.legiapp.helper.InternetChecker;
	import ch.inaffect.legiapp.helper.RequestFilter;
	import ch.inaffect.legiapp.helper.RequestLastChanges;
	import ch.inaffect.legiapp.helper.RequestOffers;
	import ch.inaffect.legiapp.helper.StorageHandler;
	import ch.inaffect.legiapp.model.Model;
	import ch.inaffect.legiapp.theme.LegiTheme;
	import ch.inaffect.legiapp.view.screen.DetailOffer;
	import ch.inaffect.legiapp.view.screen.YouPage;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ProgressBar;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.motion.transitions.TabBarSlideTransitionManager;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Main extends LayoutGroup
	{
		public static const ANDROID : String = "android";
		public static const IOS : String = "ios";
		
		public static const EVENT_LANGUAGE_CHANGE : String = "changeLanguage";
		public static const EVENT_SHOW_YOUPAGE : String = "eventShowYouPage";
		public static const EVENT_SHOW_DETAIL_OFFER : String = "eventShowDetailOffer";
		
		public static var LANGUAGE : EnumLanguageCodes = EnumLanguageCodes.deCH;
		
		private static const SCREEN_YOU_PAGE : String = "screenYouPage";
		private static const SCREEN_DETAIL_OFFER : String = "screenDetailOffer";
		
		[Embed(source="/../assets/images/dummy.png")]
		public static const DummyImage : Class;
		
		private var _screenNavigator:ScreenNavigator;
		private var _screenTransitionManager:ScreenSlidingStackTransitionManager;
		private var _transitionManager:TabBarSlideTransitionManager;
		private var _imgLoader:ImageLoader;
		private var _progressBar:ProgressBar;
		private var _offersWrapper:LayoutGroup;
		private var _titleImg:Texture;
		private var _flagLoadingOffers:Boolean = true;
		private var _flagLoadingFilter:Boolean = true;
		
		public static function get PrefLanguage() : EnumLanguageCodes
		{
			var lang : String = (Capabilities.languages[0] as String).split("-")[0];
			
			if(EnumLanguageCodes.deCH.toString().indexOf(lang) > -1)
			{
				return EnumLanguageCodes.deCH;
			}
			else if(EnumLanguageCodes.frCH.toString().indexOf(lang) > -1)
			{
				return EnumLanguageCodes.frCH;
			}
			else if(EnumLanguageCodes.itCH.toString().indexOf(lang) > -1)
			{
				return EnumLanguageCodes.itCH;
			}
			else
			{
				return null;
			}
		}
		
		public static function get DeviceOS():String
		{
			if(Capabilities.version.toLowerCase().indexOf("ios") > -1)
			{
				return IOS;
			}
			else if(Capabilities.version.toLowerCase().indexOf("and") > -1)
			{
				return ANDROID;
			}
			
			return null;
		}
		
		public static function GetBucket() : String
		{
			var bucket : String;
			var scale : int = Starling.contentScaleFactor;
			
			if(scale >= 4){
				bucket = EnumScreenBuckets.XXXHDPI.bucket;
			}
			else if(scale >= 3)
			{
				bucket = EnumScreenBuckets.XXHDPI.bucket;
			}
			else if(scale >= 2)
			{
				bucket = EnumScreenBuckets.XHDPI.bucket;
			}
			else
			{
				bucket = EnumScreenBuckets.MDPI.bucket;
			}
			
			return bucket;
		}
		
		public function Main()
		{
			super();
			Starling.current.showStats = true;
			
			new LegiTheme();
			layout = new AnchorLayout;
			
			_titleImg = Texture.fromEmbeddedAsset(LegiTheme.TitleImage);
			
			checkDate();
			
			var lang : EnumLanguageCodes = PrefLanguage;
			if(lang != null) LANGUAGE = lang;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			addLoaderImage();
			addProgressBar();
			addScreenNavigator();
		}
		
		private function checkDate() : void
		{
			if(InternetChecker.NET_STATUS)
			{
				var req : RequestLastChanges = new RequestLastChanges;
				req.addEventListener(Event.COMPLETE, onCheckDateComplete);
			}
			else
			{
				var ic : InternetChecker = InternetChecker.getInstance();
				ic.addEventListener(InternetChecker.EVENT_NET_STATUS_CHANGED, onCheckDatePending);
			}
		}
		
		private function onCheckDatePending(e : Event) : void
		{
			InternetChecker(e.currentTarget).removeEventListener(e.type, onCheckDatePending);
			checkDate();
		}
		
		private function onCheckDateComplete(e : Event, o : Object) : void
		{
			RequestLastChanges(e.currentTarget).removeEventListener(e.type, onCheckDateComplete);
			
			var time : Number = o as Number;
			var so : StorageHandler = StorageHandler.getInstance();
			
			if(isNaN(so.timestamp) != true) // have stored timestamp
			{
				if(time > so.timestamp) // have updates
				{
					so.timestamp = time;
					startLoadingOffers();
					startLoadingFilter();
				}
				else
				{
					if(so.offers != null) // have stored offers, no updates -> ready to go
					{
						_flagLoadingOffers = false;
						Model.dataObject = so.offers;
						showYouPage();
					}
					else // should not happen: have timestamp but no offers
					{
						so.timestamp = time;
						startLoadingOffers();
					}
					
					if(so.citiesFilter != null && so.categoriesFilter != null) // we have stored filter
					{
						_flagLoadingFilter = false;
						showYouPage();
					}
					else // we don't have stored filter
					{
						startLoadingFilter();
					}
				}
			}
			else // probably first time user
			{
				so.timestamp = time;
				startLoadingOffers();
				startLoadingFilter();
			}
		}
		
		private function startLoadingOffers() : void
		{
			if(InternetChecker.NET_STATUS)
			{
				var req : RequestOffers = new RequestOffers;
				req.addEventListener(Event.COMPLETE, onFinishedLoadingOffers);
				req.addEventListener(Event.IO_ERROR, onErrorLoadingOffers);
			}
			else
			{
				var ic : InternetChecker = InternetChecker.getInstance();
				ic.addEventListener(InternetChecker.EVENT_NET_STATUS_CHANGED, onLoadingOffersPending);
			}
		}
		
		private function onErrorLoadingOffers(e : Event) : void
		{
			trace(RequestOffers(e.currentTarget).errorMessage);
		}
		
		private function onLoadingOffersPending(e : Event) : void
		{
			InternetChecker(e.currentTarget).removeEventListener(e.type, onLoadingOffersPending);
			startLoadingOffers();
		}
		
		private function onFinishedLoadingOffers(e : Event, a : Array) : void
		{
			var data : Vector.<Object> = Vector.<Object>(a);
			var so : StorageHandler = StorageHandler.getInstance();
			
			Model.dataObject = data;
			so.offers = data;
			
			_flagLoadingOffers = false;
			showYouPage();
		}
		
		private function startLoadingFilter() : void
		{
			if(InternetChecker.NET_STATUS == true)
			{
				var req : RequestFilter = new RequestFilter;
				req.addEventListener(Event.COMPLETE, onFilterLoaded);
			}
			else
			{
				var ic : InternetChecker = InternetChecker.getInstance();
				ic.addEventListener(InternetChecker.EVENT_NET_STATUS_CHANGED, onLoadingFilterPending);
			}
		}
		
		private function onLoadingFilterPending(e : Event) : void
		{
			InternetChecker(e.currentTarget).removeEventListener(e.type, onLoadingFilterPending);
			startLoadingFilter();
		}
		
		private function onFilterLoaded(e : Event) : void
		{
			var req : RequestFilter = e.target as RequestFilter;
			req.removeEventListener(e.type, onFilterLoaded);
			
			var so : StorageHandler = StorageHandler.getInstance();
			so.citiesFilter = req.cities;
			so.categoriesFilter = req.categories;
			
			_flagLoadingFilter = false;
			showYouPage();
		}
		
		private function addLoaderImage() : void
		{
			var anchorLayoutData : AnchorLayoutData = new AnchorLayoutData(100,30,NaN,30);
			anchorLayoutData.percentWidth = 1;
			
			_imgLoader = new ImageLoader();
			_imgLoader.layoutData = anchorLayoutData;
			_imgLoader.maintainAspectRatio = true;
			_imgLoader.scaleContent = true;
			_imgLoader.source = _titleImg;
			addChild(_imgLoader);
		}
		
		private function addProgressBar() : void
		{
			var anchorLayoutData : AnchorLayoutData = new AnchorLayoutData(100,30,NaN,30);
			anchorLayoutData.topAnchorDisplayObject = _imgLoader;
			
			_progressBar = new ProgressBar();
			_progressBar.layoutData = anchorLayoutData;
			_progressBar.minimum = 0;
			_progressBar.maximum = 100;
			_progressBar.value = 0;
			_progressBar.backgroundSkin = new Quad(1,2,0xffffff);
			_progressBar.fillSkin = new Quad(1,2,0xff0000);
			addChild(_progressBar);
		}
		
		private function addScreenNavigator():void
		{
			_screenNavigator = new ScreenNavigator();
			_screenNavigator.width = stage.stageWidth;
			_screenNavigator.height = stage.stageHeight;
			
			var page : ScreenNavigatorItem = new ScreenNavigatorItem(YouPage);
			page.setScreenIDForEvent(EVENT_SHOW_DETAIL_OFFER, SCREEN_DETAIL_OFFER);
			_screenNavigator.addScreen(SCREEN_YOU_PAGE, page);
			
			page = new ScreenNavigatorItem(DetailOffer);
			page.setScreenIDForEvent(EVENT_SHOW_YOUPAGE, SCREEN_YOU_PAGE);
			_screenNavigator.addScreen(SCREEN_DETAIL_OFFER, page);
			_screenTransitionManager = new ScreenSlidingStackTransitionManager(_screenNavigator);
			
			addChild(_screenNavigator);
		}
		
		private function showYouPage() : void
		{
			if(_flagLoadingFilter == true || _flagLoadingOffers == true) return;
			
			_titleImg.dispose();
			removeChild(_imgLoader, true);
			removeChild(_progressBar, true);
			
			_screenNavigator.showScreen(SCREEN_YOU_PAGE);
			
//			addTimer();
		}
		
//		private function addTimer() : void
//		{
//			var t : Timer = new Timer(500);
//			t.addEventListener(TimerEvent.TIMER, onTick);
//			t.start();
//		}
		
//		private var _screenArray : Array = [SCREEN_YOU_PAGE,SCREEN_DETAIL_OFFER];
//		private function onTick(e : TimerEvent) : void
//		{
//			var t : Timer = e.currentTarget as Timer;
//			var index : int = t.currentCount%2;
//			if(index > 0) Model.detailObject = Model.dataObject[index];
//			_screenNavigator.showScreen(_screenArray[t.currentCount%2]);
//		}
		
		private function onLanguageChange(e : Event, lang : EnumLanguageCodes) : void
		{
			LANGUAGE = lang;
			dispatchEventWith(EVENT_LANGUAGE_CHANGE);
		}
	}
}