package ch.inaffect.legiapp.localisation
{
	import ch.inaffect.legiapp.Main;
	import ch.inaffect.legiapp.helper.EnumLanguageCodes;
	
	public class l18n
	{
		public static const LOGIN_PASSWORD_PLACEHOLDER : String = "loginPasswordPlaceholder";
		public static const LOGIN_PASSWORD : String = "loginPassword";
		public static const LOGIN_EMAIL_PLACEHOLDER : String = "loginEmailPlaceholder";
		public static const LOGIN_EMAIL : String = "loginEmail";
		public static const TXT_LOGIN_REQUEST : String = "loginRequest";
		public static const TXT_WELCOME_BACK : String = "welcomeBack";
		public static const TXT_SETTINGS : String = "settings";
		public static const TXT_CHECK_INTERNET : String = "checkInternet";
		public static const TXT_NO_INTERNET : String = "noInternet";
		public static const TXT_LOADING : String = "loading";
		public static const TXT_REDEEMINFO : String = "redeem";
		public static const ALERT_CANNOT_LOGIN_TITLE : String = "alertCannotLoginTitle";
		public static const ALERT_CANNOT_LOGIN : String = "alertCannotLogin";
		public static const BTN_SOCIAL : String = "btnSocial";
		public static const BTN_SETTINGS : String = "btnSettings";
		public static const BTN_BACK : String = "btnBack";
		public static const BTN_FILTER : String = "btnFilter";
		public static const BTN_CONFIRM : String = "btnConfirm";
		public static const BTN_DISMISS : String = "btnDismiss";
		public static const BTN_APPLY_SETTINGS : String = "btnApplySettings";
		public static const BTN_APPLY_FILTER : String = "btnApplyFilter";
		public static const BTN_GOTO_SUPPLIER : String = "btnGotoSupplier";
		public static const BTN_LOGIN : String = "btnLogin";
		public static const BTN_LOGOUT : String = "btnLogout";
		public static const TAB_CITIES : String = "tabCities";
		public static const TAB_CATEGORIES : String = "tabCategories";

		public static const ENUM_CONTINGENT_ALWAYS : String = "enumContingentAlways";
		public static const ENUM_CONTINGENT_DAILY : String = "enumContingentDaily";
		public static const ENUM_CONTINGENT_WEEKLY : String = "enumContingentWeekly";
		public static const ENUM_CONTINGENT_MONTHLY : String = "enumContingentMonthly";
		public static const ENUM_CONTINGENT_QUARTAL : String = "enumContingentPerQuartal";
		public static const ENUM_CONTINGENT_SEMESTER : String = "enumContingentPerSemester";
		public static const ENUM_CONTINGENT_ONCE : String = "enumContingentOnce";
		
		public static function getString(stringName : String, param1 : String = null, param2 : String = null, langCode : EnumLanguageCodes = null) : String
		{
			var noFr : String = "** fr **";
			var noIt : String = "** it **";
			
			if(langCode == null) langCode = Main.LANGUAGE;
			
			var l18n : Object =
				{
					loginPasswordPlaceholder:{
						"de-CH":"Dein Password",
						"fr-CH":"",
						"it-CH":""
					},
					loginPassword:{
						"de-CH":"Password:",
						"fr-CH":"",
						"it-CH":""
					},
					loginEmailPlaceholder:{
						"de-CH":"Deine Email",
						"fr-CH":"",
						"it-CH":""
					},
					loginEmail:{
						"de-CH":"Email:",
						"fr-CH":"",
						"it-CH":""
					},
					loginRequest:{
						"de-CH":"Log dich bitte ein:",
						"fr-CH":"",
						"it-CH":""
					},
					welcomeBack:{
						"de-CH":"Willkommen zurück $1!",
						"fr-CH":"",
						"it-CH":""
					},
					settings:{
						"de-CH":"Einstellungen",
						"fr-CH":"",
						"it-CH":""
					},
					redeem:{
						"de-CH":"<b>Verfügbarkeit</b>: $1\nEinlösbar über das Smartphone oder die LEGI App.",
						"fr-CH":"",
						"it-CH":""
					},
					enumContingentAlways:{
						"de-CH":"Immer",
						"fr-CH":"",
						"it-CH":""
					},
					enumContingentDaily:{
						"de-CH":"Täglich",
						"fr-CH":"",
						"it-CH":""
					},
					enumContingentWeekly:{
						"de-CH":"Wöchentlich",
						"fr-CH":"",
						"it-CH":""
					},
					enumContingentMonthly:{
						"de-CH":"Monatlich",
						"fr-CH":"",
						"it-CH":""
					},
					enumContingentPerQuartal:{
						"de-CH":"Per Quartal",
						"fr-CH":"",
						"it-CH":""
					},
					enumContingentPerSemester:{
						"de-CH":"Per Semester",
						"fr-CH":"",
						"it-CH":""
					},
					enumContingentOnce:{
						"de-CH":"Einmalig",
						"fr-CH":"",
						"it-CH":""
					},
					checkInternet:{
						"de-CH":"Verbindung wird gesucht...",
						"fr-CH":noFr,
						"it-CH":noIt
					},
					alertCannotLoginTitle:{
						"de-CH":"Keine Internetverbindung",
						"fr-CH":noFr,
						"it-CH":noIt
					},
					alertCannotLogin:{
						"de-CH":"Bei der ersten Benutzung dieser App musst du mit dem Internet verbunden sein.",
						"fr-CH":noFr,
						"it-CH":noIt
					},
					noInternet:{
						"de-CH":"Keine Internetverbindung! Es werden die Lokalen Daten verwendet.",
						"fr-CH":noFr,
						"it-CH":noIt
					},
					loading:{
						"de-CH":"Daten werden geladen...",
						"fr-CH":noFr,
						"it-CH":noIt
					},
					btnLogin:{
						"de-CH":"Anmelden",
						"fr-CH":"",
						"it-CH":""
					},
					btnLogout:{
						"de-CH":"Abmelden",
						"fr-CH":"",
						"it-CH":""
					},
					btnApplySettings:{
						"de-CH":"Speichern",
						"fr-CH":"",
						"it-CH":""
					},
					btnShare:{
						"de-CH":"Teilen",
						"fr-CH":"",
						"it-CH":""
					},
					btnSettings:{
						"de-CH":"Settings",
						"fr-CH":"",
						"it-CH":""
					},
					btnGotoSupplier:{
						"de-CH":"Zum Anbieter",
						"fr-CH":"",
						"it-CH":""
					},
					btnBack:{
						"de-CH":"Zurück",
						"fr-CH":noFr,
						"it-CH":noIt
					},
					btnFilter:{
						"de-CH":"Filter",
						"fr-CH":noFr,
						"it-CH":noIt
					},
					btnConfirm:{
						"de-CH":"Bestätigung durch das Verkaufspersonal",
						"fr-CH":noFr,
						"it-CH":noIt
					},
					btnDismiss:{
						"de-CH":"Abbrechen",
						"fr-CH":noFr,
						"it-CH":noIt
					},
					btnApplyFilter:{
						"de-CH":"Filter Anwenden",
						"fr-CH":noFr,
						"it-CH":noIt
					},
					tabCities:{
						"de-CH":"Städte",
						"fr-CH":noFr,
						"it-CH":noIt
					},
					tabCategories:{
						"de-CH":"Kategorien",
						"fr-CH":noFr,
						"it-CH":noIt
					}
				};
			
			var txt : String = l18n[stringName][langCode.toString()];
			var param : String;
			
			if(param1 != null)
			{
				param = (l18n.hasOwnProperty(param1)) ? l18n[param1][langCode.toString()] : param1
				txt = txt.replace(/\$1/, param);
			}
			
			if(param2 != null)
			{
				param = (l18n.hasOwnProperty(param2)) ? l18n[param2][langCode.toString()] : param2
				txt = txt.replace(/\$1/, param);
			}
			
			return txt;
		}
	}
}