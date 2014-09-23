
package {
	
	import flash.display.MovieClip;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class RTMPStream extends MovieClip {
		
		protected var sMediaServerURL:String = "rtmp://192.168.71.100:1935/cam/";
		protected var sStreamName:String = "stream";
		
		protected var oConnection:NetConnection;
		protected var oMetaData:Object = new Object();
		protected var oNetStream:NetStream;
		protected var oVideo:Video;
		
		/* the constructor */
		public function RTMPStream():void {
			
			NetConnection.prototype.onBWDone = function(oObject1:Object) {
				trace("onBWDone: " + oObject1.toString()); // some media servers are dumb, so we need to catch a strange event..
			};
			
		}
		
		/* triggered when meta data is received. */
		protected function eMetaDataReceived(oObject:Object):void {
			trace("MetaData: " + oObject.toString()); // debug trace..
		}
		
	}
	
}
