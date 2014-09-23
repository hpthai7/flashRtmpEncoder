package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	
	[SWF( width="940", height="880" )]
	public class WebFlbProj extends Sprite
	{
		private var up:Upstream;
		private var video:Video;
		
		public function WebFlbProj() {
			up = new Upstream();
			this.addEventListener(Event.ADDED_TO_STAGE, showCamera);
		}
		
		private function showCamera(event:Event=null):void {
			video = new Video(Upstream.videoSizeX, Upstream.videoSizeY);
			video.x = Upstream.videoLocatX;
			video.y = Upstream.videoLocatY;
			video.attachCamera(Camera.getCamera());
			stage.addChild(video);
		}
		
	}
}

