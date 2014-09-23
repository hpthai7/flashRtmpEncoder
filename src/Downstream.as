
	package com.powerflasher.SampleApp {
		
		import flash.events.NetStatusEvent;
		import flash.media.Video;
		import flash.net.NetConnection;
		import flash.net.NetStream;
		
		public class Downstream extends RTMPStream {
			
			/* the constructor. */
			public function Downstream():void {
				
				trace("Downstream object has been created."); // debug trace..
				
				this.oVideo = new Video(640, 480);
				
				this.oConnection = new NetConnection();
				this.oConnection.addEventListener(NetStatusEvent.NET_STATUS, eNetStatus, false, 0, true);
				this.oConnection.connect(this.sMediaServerURL);
				
			}
			
			/* triggered when a net status event is received. */
			private function eNetStatus(oEvent1:NetStatusEvent) {
				
				trace("NetStatusEvent: " + oEvent1.info.code); // debug trace..
				
				switch (oEvent1.info.code) {
				case "NetConnection.Connect.Success":
				
					// create a stream for the connection..
					this.oNetStream = new NetStream(oConnection);
					this.oNetStream.addEventListener(NetStatusEvent.NET_STATUS, eNetStatus, false, 0, true);
					this.oNetStream.bufferTime = 5; // set this to whatever is comfortable..
					
					// listen for meta data..
					this.oMetaData.onMetaData = eMetaDataReceived;
					this.oNetStream.client = this.oMetaData;
					
					// attach the stream to the stage..
					this.oVideo.attachNetStream(oNetStream);
					this.oNetStream.play(sStreamName);
					this.addChildAt(this.oVideo, 0);
				
					trace("Connected to the RTMP server."); // debug trace..
					break;
					
				case "NetConnection.Connect.Closed":
				
					trace("Disconnected from the RTMP server."); // debug trace..
					break;
					
				case "NetStream.Play.StreamNotFound":
				
					trace("This stream is currently unavailable."); // debug trace..
					break;
					
				}

			}
			
		}
		
	}
	