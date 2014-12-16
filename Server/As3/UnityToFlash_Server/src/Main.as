package 
{
	import flash.errors.IOError;
	import flash.net.ServerSocket;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	
	import flash.net.Socket;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.ServerSocketConnectEvent;
	
	
	/**
	 * ...
	 * @author weichih25@gmail.com
	 */
	public class Main extends Sprite 
	{
		
		static private const IP:String = "127.0.0.1";
		static private const PORT:uint =9050;
		
		private var _socket:ServerSocket;
		private var _textFiled:TextField;
		private var _sprite:Sprite;
		private var _log:String;
		private var _sendTextTimer:Timer;
		private var _conectTimer:Timer;
		private var _client:Socket ;
		private var _consoleMsg:String;
		
		
		
		public function Main():void 
		{
			_consoleMsg = "";
			_socket = new ServerSocket();
			_socket.bind(PORT, IP);
			_socket.addEventListener(ServerSocketConnectEvent.CONNECT, OnConnectedHandler);
			_socket.listen();
			
			_sprite = new Sprite();
			_textFiled = new TextField();
			_sprite.addChild(_textFiled);
			addChild(_sprite);
			
			ConsoleWriteLine("Random Start :)");
			_textFiled.width = stage.stageWidth;
			_textFiled.height = stage.stageHeight;

			_sendTextTimer = new Timer(1000);
			_sendTextTimer.addEventListener(TimerEvent.TIMER, OnTimerHandler);
			 _sendTextTimer.start();
			
		}
		
		private function OnConnectedHandler(e:ServerSocketConnectEvent):void {

		
			_client  = e.socket;
			_client.flush();
	
			
		}
		
		private function OnTimerHandler(e:TimerEvent):void {
			var msg:String = String(Math.random());
			ConsoleWriteLine(msg);
			if( _client != null){
				if (_client.connected) {
					
					_client.writeUTFBytes(msg);
					_client.flush();
				
				}
			}
		}
		
		private function ConsoleWriteLine(cmd:String):void {
			_consoleMsg = cmd + "\n" + _consoleMsg ; 
			_textFiled.text = "Server Console\n-------------------------\n" + _consoleMsg  ; 
		}
		
		
	}
	
}