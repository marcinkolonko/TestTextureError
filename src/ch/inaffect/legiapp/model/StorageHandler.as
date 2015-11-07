package ch.inaffect.legiapp.model
{
	import flash.data.EncryptedLocalStore;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;

	public class StorageHandler
	{
		public static var HAS_TOKEN : Boolean = false;
		
		// SharedObject Properties
		private static const SHARED_OBJECT : String = "legiData";
		public static const SO_TIMESTAMP : String = "soTimestamp";
		public static const SO_USERNAME : String = "soUsername";
		public static const SO_OFFERS : String = "soOffers";
		public static const SO_FILTER_CITIES : String = "soFilterCities";
		public static const SO_SELECTED_CITIES : String = "soSelectedCities";
		public static const SO_FILTER_CATEGORIES : String = "soFilterCategories";
		public static const SO_SELECTED_CATEGORIES : String = "soSelectedCategories";
		public static const SO_PENDING_OFFERS : String = "soPendingOffers";
		
		private static const STORAGE_TOKEN : String = "storageToken";
		
		private static var _instance : StorageHandler;
		private var _so:SharedObject;
		
		public static function getInstance() : StorageHandler
		{
			if(!_instance)
			{
				new StorageHandler();
			} 
			return _instance;
		}
		
		public function StorageHandler() : void
		{
			if(_instance){
				throw new Error("Singleton... use getInstance()");
			}
			
			_instance = this;
			_so = SharedObject.getLocal(SHARED_OBJECT);
			
			if(token != null) HAS_TOKEN = true;
		}
		
		public function set token(token : String) : void
		{
			var ba : ByteArray = new ByteArray;
			ba.writeUTFBytes(token);
			
			EncryptedLocalStore.setItem(STORAGE_TOKEN, ba);
			
			HAS_TOKEN = true;
		}
		public function get token() : String
		{
			var ba : ByteArray = EncryptedLocalStore.getItem(STORAGE_TOKEN);
			
			if(ba != null)
			{
				var token : String = ba.readUTFBytes(ba.length);
				if(token.length > 0) return token;
			}
			return null;
		}
		public function removeToken() : void
		{
			HAS_TOKEN = false;
			EncryptedLocalStore.removeItem(STORAGE_TOKEN);
		}
		
		public function logout() : void
		{
			removeToken();
			
			delete _so.data[SO_TIMESTAMP];
			delete _so.data[SO_USERNAME];
			_so.flush();
		}
		
		public function set timestamp(n : Number) : void
		{
			_so.data[SO_TIMESTAMP] = n;
			_so.flush();
		}
		public function get timestamp() : Number
		{
			var n : Number = _so.data[SO_TIMESTAMP];
			
			if(isNaN(n) == false) return n;
			return NaN;
		}
		
		public function set offers(v : Vector.<Object>) : void
		{
			_so.data[SO_OFFERS] = v;
			_so.flush();
		}
		public function get offers() : Vector.<Object>
		{
			var v : Vector.<Object> = _so.data[SO_OFFERS];
			
			if(v != null && v.length > 0) return v;
			return null;
		}
		
		public function set citiesFilter(a : Array) : void
		{
			_so.data[SO_FILTER_CITIES] = a;
			_so.flush();
		}
		public function get citiesFilter() : Array
		{
			var a : Array = _so.data[SO_FILTER_CITIES];
			
			if(a != null && a.length > 0) return a;
			return null;
		}
		
		public function set categoriesFilter(a : Array) : void
		{
			_so.data[SO_FILTER_CATEGORIES] = a;
			_so.flush();
		}
		public function get categoriesFilter() : Array
		{
			var a : Array = _so.data[SO_FILTER_CATEGORIES];
			
			if(a != null && a.length > 0)return a;
			return null;
		}
		
		public function set selectedCities(v : Vector.<int>) : void
		{
			_so.data[SO_SELECTED_CITIES] = v;
			_so.flush();
		}
		public function get selectedCities() : Vector.<int>
		{
			var v : Vector.<int> = _so.data[SO_SELECTED_CITIES];
			
			if(v != null && v.length > 0) return v;
			return null;
		}
		
		public function set selectedCategories(v : Vector.<int>) : void
		{
			_so.data[SO_SELECTED_CATEGORIES] = v;
			_so.flush();
		}
		public function get selectedCategories() : Vector.<int>
		{
			var v : Vector.<int> = _so.data[SO_SELECTED_CATEGORIES];
			
			if(v != null && v.length > 0) return v;
			return null;
		}
		
		public function set pendingOffers(a : Array) : void
		{
			var aOld : Array = _so.data[SO_PENDING_OFFERS];
			var aNew : Array;
			
			if(aOld != null && aOld.length > 0)
			{
				aNew = aOld.concat(a);
			}
			else
			{
				aNew = a;
			}
			_so.data[SO_PENDING_OFFERS] = aNew;
			_so.flush();
		}
		public function get pendingOffers() : Array
		{
			var a : Array = _so.data[SO_PENDING_OFFERS];
			
			if(a != null && a.length > 0)return a
			return null;
		}
		public function delPendingOffers() : void
		{
			delete _so.data[SO_PENDING_OFFERS];
			_so.flush();
		}
	}
}