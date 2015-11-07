package ch.inaffect.legiapp.helper
{
	public interface IRequestHandler
	{
		function load(o : * = null) : Boolean;
		function get data() : *;
		function get errorMessage() : String;
		function get status() : int;
		function dispose() : void;
	}
}