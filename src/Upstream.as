package {
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Camera;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
		public class Upstream extends RTMPStream {
			
			private var oCamera:Camera;
			private var oMicrophone:Microphone;
			public static var videoSizeX:int = 480;
			public static var videoSizeY:int = 360;
			public static var videoLocatX:int = 20;
			public static var videoLocatY:int = 10;
			

			/* the constructor. */
			public function Upstream():void {
				trace("Upstream object has been created.");
								
				this.oConnection = new NetConnection();
				this.oConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
				this.oConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				this.oConnection.connect(this.sMediaServerURL);
				this.oConnection.client = this;
				
			}
			
			public function getCamera():Camera {
				return this.oCamera;
			}
			
			/* triggered when a net status event is received. */
			private function netStatusHandler(oEvent1:NetStatusEvent):void {
				
				trace("#NetStatusEvent: " + oEvent1.info.code); // debug trace..
				
				switch (oEvent1.info.code) {
				case "NetConnection.Connect.Success":
					connectStream();
					trace("Connected to the RTMP server."); // debug trace..
					break;
				
				case "NetConnection.Connect.Closed":
					trace("Disconnected from the RTMP server."); // debug trace..
					break;
				
				case "NetConnection.Connect.Failed":
					trace("Connection failed");
					break;
				}
			}
			
			private function getVideo():Video {
				return this.oVideo;
			}
						
			private function connectStream():void {
				if (!Camera.isSupported) {
					trace("Camera unavailable");
					return;
				}
				
				this.oCamera = Camera.getCamera();
				if (!this.oCamera) {
					trace("Camera not installed");
					return;
				}
				this.oCamera.setMode(videoSizeX, videoSizeY, 36, true); // fps
				this.oCamera.setQuality(1000000, 50); // bandwidth in bytes, quality
				this.oCamera.setKeyFrameInterval(4);
				// this.oMicrophone = Microphone.getMicrophone();
				
				// H264 encoding
				var h264:H264VideoStreamSettings = new H264VideoStreamSettings();
				h264.setProfileLevel(H264Profile.MAIN, H264Level.LEVEL_3_1);

				// create a stream for the connection..
				this.oNetStream = new NetStream(oConnection);
				this.oNetStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				this.oNetStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				
				// attach the camera and microphone to the stream..
				this.oNetStream.attachCamera(this.oCamera);
				// this.oNetStream.attachAudio(this.oMicrophone);
				
				// start publishing the stream..
				this.oNetStream.videoStreamSettings = h264;
				this.oNetStream.publish(this.sStreamName);
				
				// listen for meta data..
				this.oMetaData.onMetaData = eMetaDataReceived;
				this.oNetStream.client = this.oMetaData;
			}
			
			private function securityErrorHandler(event:SecurityErrorEvent):void {
				trace("SecurityErrorHandler: " + event); 
			}
			
			private function asyncErrorHandler(event:AsyncErrorEvent):void {
				trace("AsyncErrorEvent: " + event);
			}
			
		}
		
	}
	