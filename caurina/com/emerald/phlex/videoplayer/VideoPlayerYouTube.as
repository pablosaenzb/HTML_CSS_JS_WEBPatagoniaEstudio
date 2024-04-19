/**
	VideoPlayerYouTube class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.videoplayer {
	
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import com.emerald.phlex.utils.Geom;
	import com.emerald.phlex.utils.Utils;
	import caurina.transitions.*;
	import caurina.transitions.properties.ColorShortcuts;

	public class VideoPlayerYouTube extends Sprite {
		
		public var videoplayer:Sprite;
		public var autohideTimer:Timer;
		public var isPlaying:Boolean = false;
		private var __root:*, wt:*;
		private var __stage:Stage;
		private var videoplayer_bg:Sprite, video_fg:Sprite, preview:Sprite, screen_button:Sprite, volume_bar_mask:Sprite;
		private var controls:MovieClip, controls_bg_main:MovieClip, controls_bg_left:MovieClip, controls_bg_middle:MovieClip, controls_bg_right:MovieClip;
		private var play_button:MovieClip, pause_button:MovieClip, timeline_bg:MovieClip, play_bar:MovieClip, seek_bar:MovieClip, timer:MovieClip, sound_on_button:MovieClip, sound_off_button:MovieClip, volume_bar:MovieClip, fs_on_button:MovieClip, fs_off_button:MovieClip;
		private var shadow_base:Shape;
		private var killCachedFiles:Boolean = false;
		private var imageLoader:Loader, playerLoader:Loader;
		private var textStyleSheet:StyleSheet;
		private var video:Object;
		private var sound_volume:Number;
		private var controls_initialized:Boolean = false;
		private var video_initialized:Boolean = false;
		private var timelineTimer:Timer;
		
		private var videoWidth:uint = 640;
		private var videoHeight:uint = 360;
		private var duration:Number;
		private var mouseIsOverTimeline:Boolean = false;
		private var mouseIsPressedOverTimeline:Boolean = false;
		private var mouseIsOverVolumeBar:Boolean = false;
		private var mouseIsPressedOverVolumeBar:Boolean = false;
		private var isFullscreenVideo:Boolean = false;
		private var timer_tf1:TextField, timer_tf2:TextField, timer_sep_tf:TextField;
		
		private var controls_xPos:uint, controls_yPos:uint;
		private var bg_main_width:uint;
		private var bg_middle_width:uint;
		private var bg_right_xPos:uint;
		private var timeline_width:uint;
		private var timer_xPos:uint;
		private var mute_button_xPos:uint;
		private var volume_bar_xPos:uint;
		private var fs_button_xPos:uint;
		
		private var videoURL:String;
		private var previewImageURL:String;
		private var playbackQuality:String;
		private var videoAutoPlay:Boolean = true;
		private static const FADE_DURATION:Number = 0.5;
		private static const ON_ROLL_DURATION:Number = 0.2;
		private static const TIMELINE_TIMER_DELAY:uint = 20;
		private static const YOUTUBE_API_PLAYER_URL:String = "http://www.youtube.com/apiplayer?version=3";
		
		ColorShortcuts.init();	// initiates the ColorShortcuts special properties of the Tweener class
		
		Security.allowDomain("*");
		Security.allowDomain("www.youtube.com");
		Security.allowDomain("youtube.com");
		Security.allowDomain("s.ytimg.com");
		Security.allowDomain("i.ytimg.com");
		Security.loadPolicyFile("http://youtube.com/crossdomain.xml");
		Security.loadPolicyFile("http://i.ytimg.com/crossdomain.xml");
		Security.loadPolicyFile("http://s.ytimg.com/crossdomain.xml");
		Security.loadPolicyFile("http://img.youtube.com/crossdomain.xml");
		Security.loadPolicyFile("http://i3.ytimg.com/crossdomain.xml");
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function VideoPlayerYouTube(obj:*, killcache:Boolean, stylesheet:StyleSheet, video_url:String, preview_url:String, playback_quality:String, auto_play:Boolean):void {
			__root = obj; // a reference to the object of the main class
			__stage = __root.stage as Stage; // a reference to the object of the Stage class
			wt = __root.__root; // a reference to the object of the WebsiteTemplate class
			videoURL = video_url;
			previewImageURL = preview_url;
			playbackQuality = playback_quality;
			videoAutoPlay = auto_play;
			var date:Date = new Date();
			killCachedFiles = killcache;
			textStyleSheet = stylesheet;
			addChild(videoplayer = new Sprite());
			controls = new controls_mc();
			controls.alpha = 0;
			play_button = controls.pp_button.play_mc;
			pause_button = controls.pp_button.pause_mc;
			timeline_bg = controls.timeline_bg;
			seek_bar = controls.seek_bar;
			play_bar = controls.play_bar;
			timer = controls.timer;
			timer_tf1 = timer.tf1;
			timer_tf2 = timer.tf2;
			timer_sep_tf = timer.sep_tf;
			sound_on_button = controls.mute_button.on_mc;
			sound_off_button = controls.mute_button.off_mc;
			volume_bar = controls.volume_bar;
			fs_on_button = controls.fs_button.on_mc;
			fs_off_button = controls.fs_button.off_mc;
			controls_bg_main = controls.bg_main;
			controls_bg_left = controls.bg_left;
			controls_bg_middle = controls.bg_middle;
			controls_bg_right = controls.bg_right;
			
			if (!isNaN(__root.videoPlayerWidth) && !isNaN(__root.videoPlayerHeight)) {
				videoWidth = __root.videoPlayerWidth;
				videoHeight = __root.videoPlayerHeight;
			}
			
			createControls();
			createVideo();
			__stage.addEventListener(FullScreenEvent.FULL_SCREEN, onStageFullscreen);
		}
		
	/****************************************************************************************************/
	//	Function. Creates a video object and a new NetConnection. Builds the videoplayer's background and shadow, and sets its position.
	
		private function createVideo():void {
			
			// *** Video player background and shadow
			videoplayer.addChild(shadow_base = new Shape());
			videoplayer.addChild(videoplayer_bg = new Sprite());
			videoplayer.addChild(video_fg = new Sprite());
			videoplayer.addChild(preview = new Sprite());
			videoplayer.addChild(controls);
			if (!isNaN(__root.videoPlayerBgColor) && !isNaN(__root.videoPlayerBgAlpha)) {
				Geom.drawRectangle(videoplayer_bg, videoWidth, videoHeight, __root.videoPlayerBgColor, __root.videoPlayerBgAlpha);
			} else {
				Geom.drawRectangle(videoplayer_bg, videoWidth, videoHeight, 0xFFFFFF, 0);
			}
			if (!isNaN(__root.videoPlayerShadowColor) && !isNaN(__root.videoPlayerShadowAlpha)) {
				Geom.drawRectangle(shadow_base, videoWidth, videoHeight, 0xFFFFFF, 1);
				var df:DropShadowFilter = new DropShadowFilter();
				df.color = __root.videoPlayerShadowColor;
				df.alpha = __root.videoPlayerShadowAlpha;
				df.distance = 0;
				df.angle = 0;
				df.quality = __root.videoPlayerShadowQuality;
				df.blurX = df.blurY = __root.videoPlayerShadowBlur;
				df.strength = __root.videoPlayerShadowStrength;
				df.knockout = true;
				var dfArray:Array = new Array();
				dfArray.push(df);
				shadow_base.filters = dfArray;
			}
			Geom.drawRectangle(video_fg, videoWidth, videoHeight, 0xFFFFFF, 0);
			
			// *** Preview image for a video
			if (previewImageURL != null) {
				preview.alpha = 0;
				preview.mouseEnabled = false;
				imageLoader = new Loader();
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadComplete);
				imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
				imageLoader.load(new URLRequest(previewImageURL));
			}
			
			// *** Video player screen play button
			if (__root.screenPlayButtonSize > 0 && __root.screenPlayButtonAlpha > 0) {
				videoplayer.addChild(screen_button = new Sprite());
				screen_button.x = Math.round((videoWidth-__root.screenPlayButtonSize)/2);
				screen_button.y = Math.round((videoHeight-__root.screenPlayButtonSize)/2);
				Geom.drawRectangle(screen_button, __root.screenPlayButtonSize, __root.screenPlayButtonSize, __root.screenPlayButtonBgColor, __root.screenPlayButtonAlpha, 10, 10, 10, 10);
				var triangle_size:uint = Math.round(0.5*(__root.screenPlayButtonSize-10));
				var triangle_height:uint = Math.round(0.5*triangle_size*Math.sqrt(3));
				var triangle_x:uint = Math.round((__root.screenPlayButtonSize-triangle_height)/2) + 1;
				var triangle_y:uint = Math.round((__root.screenPlayButtonSize-triangle_size)/2);
				screen_button.graphics.beginFill(__root.screenPlayButtonIconColor, __root.screenPlayButtonAlpha);
				screen_button.graphics.moveTo(triangle_x, triangle_y);
				screen_button.graphics.lineTo(triangle_x, triangle_y+triangle_size);
				screen_button.graphics.lineTo(triangle_x+triangle_height, triangle_y+0.5*triangle_size);
				screen_button.graphics.lineTo(triangle_x, triangle_y);
				screen_button.graphics.endFill();
				screen_button.alpha = 0;
			}
			
			// *** Loading the YouTube player
			playerLoader = new Loader();
			playerLoader.contentLoaderInfo.addEventListener(Event.INIT, playerLoadInit);
			playerLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, playerLoadError);
			playerLoader.load(new URLRequest(YOUTUBE_API_PLAYER_URL));
		}
			
	/****************************************************************************************************/
	//	Functions. Handle events on preview image loading.
		
		private function imageLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, imageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
			var bmp:Bitmap = Bitmap(e.target.content);
			if (e.target.width != videoWidth || e.target.height != videoHeight) {
				bmp.smoothing = true;
				var bmpData:BitmapData = bmp.bitmapData;
				var new_width:Number = videoWidth;
				var new_height:Number = videoHeight;
				var bmp_matrix:Matrix = new Matrix();
				var sx:Number = new_width/e.target.width;
				var sy:Number = new_height/e.target.height;
				bmp_matrix.scale(Math.max(sx,sy), Math.max(sx,sy));
				if (sy > sx) bmp_matrix.tx = -0.5*(e.target.width*sy-new_width);
				if (sx > sy) bmp_matrix.ty = -0.5*(e.target.height*sx-new_height);
				with (preview.graphics) {
					beginBitmapFill(bmpData, bmp_matrix, true, true);
					lineTo(new_width, 0);
					lineTo(new_width, new_height);
					lineTo(0, new_height);
					lineTo(0, 0);
					endFill();
				}
			} else {
				preview.addChild(bmp);
			}
			if (videoAutoPlay == false) Tweener.addTween(preview, {alpha:1, time:FADE_DURATION, transition:"easeOutQuad"});
		}
		
		private function imageLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, imageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
		}
		
	/****************************************************************************************************/
	//	Functions. Handle events on the YouTube player loading.
		
		private function playerLoadInit(e:Event):void {
			e.target.removeEventListener(Event.INIT, playerLoadInit);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, playerLoadError);
			videoplayer.addChild(playerLoader);
			videoplayer.setChildIndex(playerLoader, 2);
			playerLoader.content.addEventListener("onReady", onPlayerReady);
			playerLoader.content.addEventListener("onStateChange", onPlayerStateChange);
		}
		
		private function playerLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.INIT, playerLoadInit);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, playerLoadError);
		}
		
	/****************************************************************************************************/
	//	Function. Executes when the player is loaded and initialized, meaning it is ready to receive API calls.
		
		private function onPlayerReady(event:Event):void {
			video = playerLoader.content;
			video.setSize(videoWidth, videoHeight);
			video.setVolume(__root.videoSoundVolume*100);
			video.setPlaybackQuality(playbackQuality);
			if (videoURL != null) {
				timelineTimer = new Timer(TIMELINE_TIMER_DELAY, 0);
				timelineTimer.addEventListener(TimerEvent.TIMER, updateTimeline);
				timelineTimer.start();
				if (videoAutoPlay == false) {
					setPausedState(true);
					if (wt != null) wt.footerObj.playing_flag = wt.footerObj.getPlayState();
				} else {
					setPlayingState(true);
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Executes whenever the player's state changes.
	
		private function onPlayerStateChange(event:Event):void {
			
			if (!controls_initialized) {
				controls_initialized = true;
				initiateControls();
			}
			if (isNaN(duration) && video.getDuration() > 0) {
				duration = video.getDuration();
				timer_tf2.htmlText = "<videotimer>" + timeFormat(duration) + "</videotimer>";
			}
			switch (Object(event).data) {
				case 0:
					stopVideoPlayer();
				break;
				case 1:

				break;
			}
		}
		
			
	/****************************************************************************************************/
	//	Function. Executes when an error in the player occurs.
		
		private function onPlayerError(event:Event):void {
			trace("Player error:", Object(event).data);
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the Stage object enters, or leaves, full-screen mode.
		
		private function onStageFullscreen(e:FullScreenEvent):void {
			if (e.fullScreen == false) {
				if (isFullscreenVideo) {
					wt.isFullscreenVideo = isFullscreenVideo = false;
					goNormalMode();
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Tracks the loading/playing progress of the video stream and updates the timeline.
	
		private function updateTimeline(e:TimerEvent):void {
			
			var bytesTotal:Number = video.getVideoBytesTotal();
			var bytesLoaded:Number = video.getVideoBytesLoaded();
			var startBytes:Number = video.getVideoStartBytes();
			var progress:Number;
			
			if (bytesTotal == 0) {
				if (bytesLoaded == 0) progress = 0;
				else progress = 1;
			} else {
				progress = Math.min((bytesLoaded+startBytes)/bytesTotal, 1);
			}
			seek_bar.width = Math.round(timeline_width * progress);
			if (!mouseIsPressedOverTimeline) {
				play_bar.width = Math.round(video.getCurrentTime() / duration * timeline_width);
				timer_tf1.htmlText = "<videotimer>" + timeFormat(video.getCurrentTime()) + "</videotimer>";
			}
		}
		
	/****************************************************************************************************/
	//	Function. Builds the controls.
		
		private function createControls():void {
			bg_main_width = videoWidth;
			bg_middle_width = videoWidth - controls_bg_middle.x - controls_bg_right.width - 1;
			bg_right_xPos = videoWidth - controls_bg_right.width;
			mute_button_xPos = bg_right_xPos + 5;
			volume_bar_xPos = bg_right_xPos + 29;
			fs_button_xPos = bg_right_xPos + 89;
			
			controls_bg_main.width = bg_main_width;
			controls_bg_middle.width = bg_middle_width;
			controls_bg_right.x = bg_right_xPos;
			controls.mute_button.x = mute_button_xPos;
			volume_bar.x = volume_bar_xPos;
			controls.fs_button.x = fs_button_xPos;
			
			var bgColor:ColorTransform;
			bgColor = controls_bg_left.transform.colorTransform;
			bgColor.color = __root.videoControlsBgColor;
			controls_bg_left.transform.colorTransform = bgColor;
			bgColor = controls_bg_middle.transform.colorTransform;
			bgColor.color = __root.videoControlsBgColor;
			controls_bg_middle.transform.colorTransform = bgColor;
			bgColor = controls_bg_right.transform.colorTransform;
			bgColor.color = __root.videoControlsBgColor;
			controls_bg_right.transform.colorTransform = bgColor;
			var separatorColor:ColorTransform = controls_bg_main.transform.colorTransform;
			separatorColor.color = __root.videoControlsSeparatorColor;
			controls_bg_main.transform.colorTransform = separatorColor;
			
			var buttonColor:ColorTransform;
			buttonColor = controls.pp_button.transform.colorTransform;
			buttonColor.color = __root.videoControlsButtonColor;
			controls.pp_button.transform.colorTransform = buttonColor;
			buttonColor = controls.mute_button.transform.colorTransform;
			buttonColor.color = __root.videoControlsButtonColor;
			controls.mute_button.transform.colorTransform = buttonColor;
			
			var volumeBarFillColor:ColorTransform = volume_bar.fill.transform.colorTransform;
			volumeBarFillColor.color = __root.soundVolumeBarFillColor;
			volume_bar.fill.transform.colorTransform = volumeBarFillColor;
			var volumeBarBgColor:ColorTransform = volume_bar.bg.transform.colorTransform;
			volumeBarBgColor.color = __root.soundVolumeBarBgColor;
			volume_bar.bg.transform.colorTransform = volumeBarBgColor;
			volume_bar.addChild(volume_bar_mask = new Sprite());
			Geom.drawRectangle(volume_bar_mask, volume_bar.bg.width, volume_bar.bg.height, 0xFF9900, 0);
			volume_bar.fill.mask = volume_bar_mask;
			volume_bar_mask.x = Math.round(volume_bar_mask.width*(__root.videoSoundVolume-1));
			
			var timelineBgColor:ColorTransform = timeline_bg.transform.colorTransform;
			timelineBgColor.color = __root.timelineBgColor;
			timeline_bg.transform.colorTransform = timelineBgColor;
			var seekBarColor:ColorTransform = seek_bar.transform.colorTransform;
			seekBarColor.color = __root.timelineSeekBarColor;
			seek_bar.transform.colorTransform = seekBarColor;
			var playBarColor:ColorTransform = play_bar.transform.colorTransform;
			playBarColor.color = __root.timelinePlayBarColor;
			play_bar.transform.colorTransform = playBarColor;
			
			setTextFormat(timer_tf1, "00:00");
			setTextFormat(timer_sep_tf, "/");
			setTextFormat(timer_tf2, "00:00");
			timer_xPos = bg_right_xPos - (Math.ceil(timer.width) + 12);
			timer.x = timer_xPos;
			
			Geom.drawRectangle(timeline_bg, timeline_bg.width, 14, 0xFF9900, 0, 0, 0, 0, 0, 0, -6); // hit area
			timeline_width = timer.x - timeline_bg.x - 12;
			timeline_bg.width = timeline_width;
			seek_bar.width = play_bar.width = 0;
			
			if (videoAutoPlay == true) {
				play_button.visible = false;
				pause_button.visible = true;
			} else {
				play_button.visible = true;
				pause_button.visible = false;
			}
			if (__root.videoSoundVolume == 0) {
				sound_on_button.visible = false;
				sound_off_button.visible = true;
			} else {
				sound_on_button.visible = true;
				sound_off_button.visible = false;
			}
			fs_on_button.visible = false;
			fs_off_button.visible = true;
			controls.pp_button.alpha = timer.alpha = controls.mute_button.alpha = controls.fs_button.alpha = 0.5;
			controls_xPos = 0;
			controls_yPos = videoHeight - controls.height;
			controls.x = controls_xPos;
			controls.y = controls_yPos;
			
			if (__root.showVideoControls) {
				Tweener.removeTweens(controls);
				Tweener.addTween(controls, {alpha:1, time:FADE_DURATION, transition:"easeOutQuint"});
			}
		}
		
		private function setTextFormat(tf:TextField, txt:String ):void {
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = false;
			tf.wordWrap = false;
			tf.embedFonts = true;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.sharpness = 300;
			tf.htmlText = "<videotimer>" + txt + "</videotimer>";
		}
		
	/****************************************************************************************************/
	//	Function. Initiates the controls.
		
		private function initiateControls():void {
			controls.mouseEnabled = timer.mouseEnabled = controls_bg_left.mouseEnabled = controls_bg_middle.mouseEnabled = controls_bg_right.mouseEnabled = false;
			controls.pp_button.mouseEnabled = controls.mute_button.mouseEnabled = volume_bar.mouseEnabled = controls.fs_button.mouseEnabled = false;
			play_bar.mouseEnabled = seek_bar.mouseEnabled = false;
			controls_bg_main.mouseEnabled = true;
			video_fg.mouseEnabled = true;
			if (__root.showVideoControls) {
				controls.pp_button.mouseChildren = controls.mute_button.mouseChildren = volume_bar.mouseChildren = controls.fs_button.mouseChildren = true;
				play_button.buttonMode = pause_button.buttonMode = sound_on_button.buttonMode = sound_off_button.buttonMode = fs_on_button.buttonMode = fs_off_button.buttonMode = true;
				volume_bar.fill.mouseEnabled = false;
				volume_bar.bg.buttonMode = true;
				timeline_bg.mouseEnabled = true;
				timeline_bg.buttonMode = true;
				controls.pp_button.alpha = timer.alpha = controls.mute_button.alpha = controls.fs_button.alpha = 1;
			} else {
				timeline_bg.mouseEnabled = false;
			}
			
			if (__root.showVideoControls) {
				play_button.addEventListener(MouseEvent.ROLL_OVER, playPauseButtonListener);
				play_button.addEventListener(MouseEvent.ROLL_OUT, playPauseButtonListener);
				play_button.addEventListener(MouseEvent.CLICK, playPauseButtonListener);
				pause_button.addEventListener(MouseEvent.ROLL_OVER, playPauseButtonListener);
				pause_button.addEventListener(MouseEvent.ROLL_OUT, playPauseButtonListener);
				pause_button.addEventListener(MouseEvent.CLICK, playPauseButtonListener);
				sound_on_button.addEventListener(MouseEvent.ROLL_OVER, muteButtonListener);
				sound_on_button.addEventListener(MouseEvent.ROLL_OUT, muteButtonListener);
				sound_on_button.addEventListener(MouseEvent.CLICK, muteButtonListener);
				sound_off_button.addEventListener(MouseEvent.ROLL_OVER, muteButtonListener);
				sound_off_button.addEventListener(MouseEvent.ROLL_OUT, muteButtonListener);
				sound_off_button.addEventListener(MouseEvent.CLICK, muteButtonListener);
				volume_bar.bg.addEventListener(MouseEvent.ROLL_OVER, volumeBarListener);
				volume_bar.bg.addEventListener(MouseEvent.ROLL_OUT, volumeBarListener);
				volume_bar.bg.addEventListener(MouseEvent.MOUSE_DOWN, volumeBarListener);
				timeline_bg.addEventListener(MouseEvent.ROLL_OVER, timelineListener);
				timeline_bg.addEventListener(MouseEvent.ROLL_OUT, timelineListener);
				timeline_bg.addEventListener(MouseEvent.MOUSE_DOWN, timelineListener);
				fs_on_button.addEventListener(MouseEvent.ROLL_OVER, fullscreenButtonListener);
				fs_on_button.addEventListener(MouseEvent.ROLL_OUT, fullscreenButtonListener);
				fs_on_button.addEventListener(MouseEvent.CLICK, fullscreenButtonListener);
				fs_off_button.addEventListener(MouseEvent.ROLL_OVER, fullscreenButtonListener);
				fs_off_button.addEventListener(MouseEvent.ROLL_OUT, fullscreenButtonListener);
				fs_off_button.addEventListener(MouseEvent.CLICK, fullscreenButtonListener);
			}
			controls_bg_main.addEventListener(MouseEvent.ROLL_OVER, controlsMainBgListener);
			controls_bg_main.addEventListener(MouseEvent.ROLL_OUT, controlsMainBgListener);
			video_fg.addEventListener(MouseEvent.ROLL_OVER, videoplayerBgListener);
			video_fg.addEventListener(MouseEvent.ROLL_OUT, videoplayerBgListener);
			video_fg.addEventListener(MouseEvent.CLICK, videoplayerBgListener);
			__stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			
			if (screen_button) {
				screen_button.mouseEnabled = true;
				screen_button.addEventListener(MouseEvent.ROLL_OVER, screenButtonListener);
				screen_button.addEventListener(MouseEvent.ROLL_OUT, screenButtonListener);
				screen_button.addEventListener(MouseEvent.CLICK, screenButtonListener);
			}
			
			autohideTimer = new Timer(__root.videoControlsAutoHideDelay*1000, 1);
			autohideTimer.addEventListener(TimerEvent.TIMER, controlsFadeListener);
			autohideTimer.start();
		}
		
	/****************************************************************************************************/
	//	Function. Video player mouse over/out listener.
	
		private function videoplayerBgListener(e:MouseEvent):void {
			switch (e.type) {
				case "rollOver":
					autohideTimer.stop();
					controlsFade("in");
					autohideTimer.start();
					__stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveVPListener);
				break;
				case "rollOut":
					__stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveVPListener);
					autohideTimer.stop();
					autohideTimer.start();
				break;
				case "click":
					if (isPlaying) setPausedState();
					else setPlayingState();
				break;
			}
		}
		
	/****************************************************************************************************/
	//	Function. Controls main background listener.
	
		private function controlsMainBgListener(e:MouseEvent):void {
			switch (e.type) {
				case "rollOver":
					autohideTimer.stop();
					controlsFade("in");
				break;
				case "rollOut":
					autohideTimer.stop();
					autohideTimer.start();
				break;
			}
		}
		
	/****************************************************************************************************/
	//	Function. Mouse move listener (when the mouse is over the video player).
	
		private function mouseMoveVPListener(e:MouseEvent):void {
			autohideTimer.stop();
			controlsFade("in");
			autohideTimer.start();
		}
		
	/****************************************************************************************************/
	//	Function. Fades in/out the controls
	
		private function controlsFadeListener(e:TimerEvent):void {
			controlsFade("out");
		}

		private function controlsFade(val:String):void {
			if (__root.videoControlsAutoHide) {
				if (__root.showVideoControls) {
					Tweener.removeTweens(controls);
					if (val == "out") Tweener.addTween(controls, {alpha:0, time:FADE_DURATION, transition:"easeOutQuad"});
					if (val == "in") Tweener.addTween(controls, {alpha:1, time:FADE_DURATION, transition:"easeOutQuad"});
				}
				if (val == "in") Mouse.show();
				if (val == "out") {
					if (video_fg.mouseX >= 0 && video_fg.mouseX <= videoWidth && video_fg.mouseY >= 0 && video_fg.mouseY <= videoHeight) {
						Mouse.hide();
					} else {
						Mouse.show();
					}
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Screen play button listener.
	
		private function screenButtonListener(e:MouseEvent):void {
			if (isPlaying) screen_button.buttonMode = false;
			else screen_button.buttonMode = true;
			switch (e.type) {
				case "rollOver":
					if (!isPlaying) {
						autohideTimer.stop();
						controlsFade("in");
					}
				break;
				case "rollOut":
					autohideTimer.stop();
					autohideTimer.start();
				break;
				case "click":
					if (isPlaying) {
						setPausedState();
						screen_button.buttonMode = true;
						autohideTimer.stop();
						controlsFade("in");
					} else {
						setPlayingState();
						screen_button.buttonMode = false;
						autohideTimer.stop();
						autohideTimer.start();
					}
			}
		}

	/****************************************************************************************************/
	//	Function. Keybord "KEY_UP" event listener.
	
		private function keyUpListener(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.SPACE) {
				if (isPlaying) setPausedState();
				else setPlayingState();
			}
		}

	/****************************************************************************************************/
	//	Function. Play and pause buttons listener.
	
		private function playPauseButtonListener(e:MouseEvent):void {
			switch (e.type) {
				case "rollOver":
					Tweener.removeTweens(controls.pp_button);
					Tweener.addTween(controls.pp_button, {_color:__root.videoControlsButtonOverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					autohideTimer.stop();
					controlsFade("in");
				break;
				case "rollOut":
					Tweener.removeTweens(controls.pp_button);
					Tweener.addTween(controls.pp_button, {_color:__root.videoControlsButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					autohideTimer.stop();
					autohideTimer.start();
				break;
				case "click":
					if (e.currentTarget.name == "play_mc") setPlayingState();
					if (e.currentTarget.name == "pause_mc") setPausedState();
			}
		}
		
	/****************************************************************************************************/
	//	Function. Mute button listener.
	
		private function muteButtonListener(e:MouseEvent):void {
			switch (e.type) {
				case "rollOver":
					Tweener.removeTweens(controls.mute_button);
					Tweener.addTween(controls.mute_button, {_color:__root.videoControlsButtonOverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					autohideTimer.stop();
					controlsFade("in");
				break;
				case "rollOut":
					Tweener.removeTweens(controls.mute_button);
					Tweener.addTween(controls.mute_button, {_color:__root.videoControlsButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					autohideTimer.stop();
					autohideTimer.start();
				break;
				case "click":
					if (e.currentTarget.name == "on_mc") {
						sound_volume = video.getVolume()/100;
						video.setVolume(0);
						sound_on_button.visible = false;
						sound_off_button.visible = true;
						volume_bar_mask.x = - volume_bar_mask.width;
					}
					if (e.currentTarget.name == "off_mc") {
						video.setVolume(sound_volume*100);
						sound_on_button.visible = true;
						sound_off_button.visible = false;
						volume_bar_mask.x = Math.round(volume_bar_mask.width*(sound_volume-1));
					}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Full-screen buttons listener.
	
		private function fullscreenButtonListener(e:MouseEvent):void {
			switch (e.type) {
				case "rollOver":
					Tweener.removeTweens(controls.fs_button);
					Tweener.addTween(controls.fs_button, {_color:__root.videoControlsButtonOverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					autohideTimer.stop();
					controlsFade("in");
				break;
				case "rollOut":
					Tweener.removeTweens(controls.fs_button);
					Tweener.addTween(controls.fs_button, {_color:__root.videoControlsButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					autohideTimer.stop();
					autohideTimer.start();
				break;
				case "click":
					if (__stage.displayState == StageDisplayState.FULL_SCREEN) {
						if (!isFullscreenVideo) goFullscreenMode();
						else __stage.displayState = StageDisplayState.NORMAL;
					} else if (__stage.displayState == StageDisplayState.NORMAL) {
						goFullscreenMode();
					}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Timeline listener.
	
		private function timelineListener(e:MouseEvent):void {
			switch (e.type) {
				case "rollOver":
					mouseIsOverTimeline = true;
					autohideTimer.stop();
					controlsFade("in");
				break;
				case "rollOut":
					mouseIsOverTimeline = false;
					autohideTimer.stop();
					autohideTimer.start();
				break;
				case "mouseDown":
					mouseIsPressedOverTimeline = true;
					__stage.addEventListener(MouseEvent.MOUSE_UP, timelineListener);
					__stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveTimelineListener);
					scrubTimeline();
					if (preview.alpha > 0) {
						Tweener.removeTweens(preview);
						Tweener.addTween(preview, {alpha:0, time:FADE_DURATION, transition:"easeOutQuad"});
					}
				break;
				case "mouseUp":
					mouseIsPressedOverTimeline = false;
					__stage.removeEventListener(MouseEvent.MOUSE_UP, timelineListener);
					__stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveTimelineListener);
					scrubTimeline();
				break;
			}
		}
		
	/****************************************************************************************************/
	//	Function. Mouse move listener (when the mouse is over the timeline).
	
		private function mouseMoveTimelineListener(e:MouseEvent):void {
			scrubTimeline();
		}
		
	/****************************************************************************************************/
	//	Function. Updates the play bar width and the position of the playhead according to the timeline scrubber position.
	
		private function scrubTimeline():void {
			var _mouseX:uint = controls.mouseX - timeline_bg.x;
			var timeSeeked:uint = Math.min(Math.floor(duration*_mouseX/timeline_width), duration);
				
			if (mouseIsPressedOverTimeline) {
				if (isPlaying) video.pauseVideo();
				play_bar.width = Math.round(timeSeeked / duration * timeline_width);
				timer_tf1.htmlText = "<videotimer>" + timeFormat(timeSeeked) + "</videotimer>";
				if (!mouseIsOverTimeline) {
					autohideTimer.stop();
					controlsFade("in");
				}
			} else {
				video.seekTo(timeSeeked, true);
				if (isPlaying) video.playVideo();
				if (!mouseIsOverTimeline) {
					autohideTimer.stop();
					autohideTimer.start();
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Sound volume bar listener.
	
		private function volumeBarListener(e:MouseEvent):void {
			var bounds:Rectangle = new Rectangle(-volume_bar.bg.width, 0, volume_bar.bg.width, 0);
			switch (e.type) {
				case "rollOver":
					mouseIsOverVolumeBar = true;
					if (mouseIsPressedOverVolumeBar) {
						volume_bar_mask.x = volume_bar.bg.mouseX - volume_bar_mask.width;
						volume_bar_mask.startDrag(false, bounds);
					}
					autohideTimer.stop();
					controlsFade("in");
				break;
				case "rollOut":
					mouseIsOverVolumeBar = false;
					if (mouseIsPressedOverVolumeBar) volume_bar_mask.stopDrag();
					autohideTimer.stop();
					autohideTimer.start();
				break;
				case "mouseDown":
					mouseIsPressedOverVolumeBar = true;
					__stage.addEventListener(MouseEvent.MOUSE_UP, volumeBarListener);
					__stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveVolumeBarListener);
					volume_bar_mask.x = volume_bar.bg.mouseX - volume_bar_mask.width;
					volume_bar_mask.startDrag(false, bounds);
					updateSoundVolume();
					sound_on_button.visible = true;
					sound_off_button.visible = false;
				break;
				case "mouseUp":
					mouseIsPressedOverVolumeBar = false;
					__stage.removeEventListener(MouseEvent.MOUSE_UP, volumeBarListener);
					__stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveVolumeBarListener);
					volume_bar_mask.stopDrag();
				break;
			}
		}
		
	/****************************************************************************************************/
	//	Function. Mouse move listener (when the mouse is over the volume bar).
	
		private function mouseMoveVolumeBarListener(e:MouseEvent):void {
			updateSoundVolume();
		}
		
	/****************************************************************************************************/
	//	Function. Updates the value of the sound volume according to the volume scrubber position.
	
		private function updateSoundVolume():void {
			if (mouseIsOverVolumeBar) {
				var vol:Number = (volume_bar_mask.width+volume_bar_mask.x)/volume_bar_mask.width;
				video.setVolume(vol*100);
				sound_volume = vol;
				if (vol == 0) {
					sound_on_button.visible = false;
					sound_off_button.visible = true;
				} else {
					sound_on_button.visible = true;
					sound_off_button.visible = false;
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Toggles the video player into the "playing" state.
	
		private function setPlayingState(init:Boolean = false):void {
			if (!video_initialized) {
				video_initialized = true;
				video.loadVideoById(videoURL);
			}
			if (!init) video.playVideo();
			isPlaying = true;
			play_button.visible = false;
			pause_button.visible = true;
			displayScreenPlayButton(false);
			if (wt != null) {
				wt.footerObj.playing_flag = wt.footerObj.getPlayState();
				if (wt.footerObj.playing_flag == true) wt.footerObj.musicButtonClickHandler();
			}
			if (preview.alpha > 0) {
				Tweener.removeTweens(preview);
				Tweener.addTween(preview, {alpha:0, time:FADE_DURATION, transition:"easeOutQuad"});
			}
		}
		
	/****************************************************************************************************/
	//	Function. Toggles the video player into the "paused" state.
		
		public function setPausedState(init:Boolean = false):void {
			if (video.getPlayerState() == 0) {
				video.stopVideo();
				video.seekTo(0);
			}
			video.pauseVideo();
			isPlaying = false;
			play_button.visible = true;
			pause_button.visible = false;
			displayScreenPlayButton(true);
			if (wt != null && !init) {
				var pflag:Boolean = wt.footerObj.getPlayState();
				if (wt.footerObj.playing_flag == true && !pflag) wt.footerObj.musicButtonClickHandler();
			}
		}
		
	/****************************************************************************************************/
	//	Function. Toggles the video player into the Full-screen mode.
	
		private function goFullscreenMode():void {
			if (__stage.displayState != StageDisplayState.FULL_SCREEN) {
				wt.isFullscreenVideo = true;
				__stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			isFullscreenVideo = true;
			fs_on_button.visible = true;
			fs_off_button.visible = false;
			
			wt.header_base.visible = wt.header_bg.visible = wt.header_pattern.visible = wt.header_shadow.visible = false;
			wt.body_base.visible = wt.body_bg.visible = wt.body_pattern.visible = false;
			wt.footer_base.visible = wt.footer_bg.visible = wt.footer_pattern.visible = wt.footer.visible = false;
			
			wt.menu.visible = wt.logo.visible = wt.breadcrumbs.visible = wt.preloader.visible = false;
			wt.page_bg.visible = wt.page_title.visible = false;
			wt.page.mask = null;
			wt.page_content.mask = null;
			wt.video_fullscreen_bg.width = __stage.fullScreenWidth;
			wt.video_fullscreen_bg.height = __stage.fullScreenHeight;
			wt.video_fullscreen_bg.visible = true;
			
			if (Utils.getClass(__root).toString() == "[class StandardPage]") {
				if (__root.scrollerObj != null) {
					if (__root.main.getChildByName("scrollbar") != null) {
						var scrollbar:Sprite = __root.main.getChildByName("scrollbar") as Sprite;
						if (scrollbar.visible == true) scrollbar.visible = false;
					}
					__root.blocks.mask = null;
					__root.blocks.removeEventListener(MouseEvent.MOUSE_WHEEL, __root.scrollerObj.mouseWheelListener);
				}
				var current_block:Sprite = videoplayer.parent as Sprite;
				for (var i=0; i<__root.blocksArray.length; i++) {
					var block:Sprite = __root.blocks.getChildByName("block"+(i+1)) as Sprite;
					if (block != current_block) block.visible = false;
				}
			}
			
			if (Utils.getClass(__root).toString() == "[class Portfolio]") {
				var p_controls:Sprite = __root.project.getChildByName("controls") as Sprite;
				var p_separator:Sprite = __root.project.getChildByName("separator") as Sprite;
				var p_title:Sprite = __root.project.getChildByName("title") as Sprite;
				var p_tnbar:Sprite = __root.project.getChildByName("tnbar") as Sprite;
				var p_blocks:Sprite = __root.project.getChildByName("blocks") as Sprite;
				if (__root.menu) __root.menu.visible = false;
				if (p_tnbar) p_tnbar.visible = false;
				if (p_title) p_title.visible = false;
				if (p_controls) p_controls.visible = false;
				if (p_separator) p_separator.visible = false;
				if (p_blocks) p_blocks.visible = false;
			}
			
			if (Utils.getClass(__root).toString() == "[class Gallery]") {
				var ctrls:Sprite = __root.project.getChildByName("controls") as Sprite;
				if (__root.menu) __root.menu.visible = false;
				__root.controls.visible = false;
				__root.previews.visible = false;
				__root.fullscreen_bg.visible = false;
				if (ctrls) ctrls.visible = false;
			}
			
			if (Utils.getClass(__root).toString() == "[class News]") {
				var a_controls:Sprite = __root.article.getChildByName("controls") as Sprite;
				var a_separator:Sprite = __root.article.getChildByName("separator") as Sprite;
				var a_title:Sprite = __root.article.getChildByName("title") as Sprite;
				var a_dt:Sprite = __root.article.getChildByName("dt") as Sprite;
				var a_blocks:Sprite = __root.article.getChildByName("blocks") as Sprite;
				if (__root.menu) __root.menu.visible = false;
				if (a_controls) a_controls.visible = false;
				if (a_separator) a_separator.visible = false;
				if (a_title) a_title.visible = false;
				if (a_dt) a_dt.visible = false;
				if (a_blocks) a_blocks.visible = false;
			}
			
			video.width = videoplayer_bg.width = video_fg.width = preview.width = __stage.fullScreenWidth;
			video.height = videoplayer_bg.height = video_fg.height = preview.height = __stage.fullScreenWidth * videoHeight/videoWidth;
			var vpoint:Point = new Point(0, 0);
			vpoint = videoplayer.localToGlobal(vpoint);
			video.x = videoplayer_bg.x = video_fg.x = preview.x = - vpoint.x;
			video.y = videoplayer_bg.y = video_fg.y = preview.y = Math.round((__stage.fullScreenHeight-video.height)/2) - vpoint.y;
			if (screen_button) {
				screen_button.x = __stage.fullScreenWidth/2 - vpoint.x - Math.round(__root.screenPlayButtonSize/2);
				screen_button.y = __stage.fullScreenHeight/2 - vpoint.y - Math.round(__root.screenPlayButtonSize/2);
			}
			shadow_base.visible = false;
			controls.x = - vpoint.x;
			controls.y = __stage.fullScreenHeight - vpoint.y - controls.height;
			controls_bg_main.width = __stage.fullScreenWidth;
			controls_bg_middle.width = __stage.fullScreenWidth - controls_bg_middle.x - controls_bg_right.width - 1;
			controls_bg_right.x = __stage.fullScreenWidth - controls_bg_right.width;
			timer.x = controls_bg_right.x - (Math.ceil(timer.width) + 12);
			timeline_width = timer.x - timeline_bg.x - 12;
			timeline_bg.width = timeline_width;
			controls.mute_button.x = controls_bg_right.x + 5;
			volume_bar.x = controls_bg_right.x + 29;
			controls.fs_button.x = controls_bg_right.x + 89;
		}
		
	/****************************************************************************************************/
	//	Function. Toggles the video player into the Normal mode.
	
		private function goNormalMode():void {
			fs_on_button.visible = false;
			fs_off_button.visible = true;
			
			wt.header_base.visible = wt.header_bg.visible = wt.header_pattern.visible = wt.header_shadow.visible = true;
			wt.body_base.visible = wt.body_bg.visible = wt.body_pattern.visible = true;
			wt.footer_base.visible = wt.footer_bg.visible = wt.footer_pattern.visible = wt.footer.visible = true;
			
			wt.menu.visible = wt.logo.visible = wt.breadcrumbs.visible = wt.preloader.visible = true;
			wt.page_bg.visible = wt.page_title.visible = true;
			wt.page.mask = wt.page_mask;
			wt.page_content.mask = wt.page_content_mask;
			wt.video_fullscreen_bg.visible = false;
			
			if (Utils.getClass(__root).toString() == "[class StandardPage]") {
				if (__root.scrollerObj != null) {
					var pane_mask:Shape = __root.main.getChildByName("pane_mask") as Shape;
					__root.blocks.mask = pane_mask;
				}
				for (var i=0; i<__root.blocksArray.length; i++) {
					var block:Sprite = __root.blocks.getChildByName("block"+(i+1)) as Sprite;
					block.visible = true;
				}
			}
			
			if (Utils.getClass(__root).toString() == "[class Portfolio]") {
				var p_controls:Sprite = __root.project.getChildByName("controls") as Sprite;
				var p_separator:Sprite = __root.project.getChildByName("separator") as Sprite;
				var p_title:Sprite = __root.project.getChildByName("title") as Sprite;
				var p_tnbar:Sprite = __root.project.getChildByName("tnbar") as Sprite;
				var p_blocks:Sprite = __root.project.getChildByName("blocks") as Sprite;
				if (__root.menu) __root.menu.visible = true;
				if (p_tnbar) p_tnbar.visible = true;
				if (p_title) p_title.visible = true;
				if (p_controls) p_controls.visible = true;
				if (p_separator) p_separator.visible = true;
				if (p_blocks) p_blocks.visible = true;
			}
			
			if (Utils.getClass(__root).toString() == "[class Gallery]") {
				var ctrls:Sprite = __root.project.getChildByName("controls") as Sprite;
				if (__root.menu) __root.menu.visible = true;
				if (__root.itemsArray.length > __root.previews_on_page) __root.controls.visible = true;
				__root.previews.visible = true;
				__root.fullscreen_bg.visible = true;
				if (ctrls) ctrls.visible = true;
			}
			
			if (Utils.getClass(__root).toString() == "[class News]") {
				var a_controls:Sprite = __root.article.getChildByName("controls") as Sprite;
				var a_separator:Sprite = __root.article.getChildByName("separator") as Sprite;
				var a_title:Sprite = __root.article.getChildByName("title") as Sprite;
				var a_dt:Sprite = __root.article.getChildByName("dt") as Sprite;
				var a_blocks:Sprite = __root.article.getChildByName("blocks") as Sprite;
				if (__root.menu) __root.menu.visible = true;
				if (a_controls) a_controls.visible = true;
				if (a_separator) a_separator.visible = true;
				if (a_title) a_title.visible = true;
				if (a_dt) a_dt.visible = true;
				if (a_blocks) a_blocks.visible = true;
			}
			
			video.width = videoplayer_bg.width = video_fg.width = preview.width = videoWidth;
			video.height = videoplayer_bg.height = video_fg.height = preview.height = videoHeight;
			video.x = videoplayer_bg.x = video_fg.x = preview.x = 0;
			video.y = videoplayer_bg.y = video_fg.y = preview.y = 0;
			if (screen_button) {
				screen_button.x = Math.round((videoWidth-__root.screenPlayButtonSize)/2);
				screen_button.y = Math.round((videoHeight-__root.screenPlayButtonSize)/2);
			}
			shadow_base.visible = true;
			
			controls.x = controls_xPos;
			controls.y = controls_yPos;
			controls_bg_main.width = bg_main_width;
			controls_bg_middle.width = bg_middle_width;
			controls_bg_right.x = bg_right_xPos;
			timer.x = timer_xPos;
			timeline_width = timer.x - timeline_bg.x - 12;
			timeline_bg.width = timeline_width;
			controls.mute_button.x = mute_button_xPos;
			volume_bar.x = volume_bar_xPos;
			controls.fs_button.x = fs_button_xPos;
		}
		
	/****************************************************************************************************/
	//	Function. Pauses the video and seeks to the first frame.
	
		private function stopVideoPlayer():void {
			Tweener.removeTweens(preview);
			Tweener.addTween(preview, {alpha:1, time:FADE_DURATION, transition:"easeOutQuad"});
			setPausedState();
		}
		
	/****************************************************************************************************/
	//	Function. Shows/hides the screen play button.
	
		private function displayScreenPlayButton(val:Boolean):void {
			if (screen_button) {
				Tweener.removeTweens(screen_button);
				if (val == true) Tweener.addTween(screen_button, {alpha:1, time:0.3, transition:"easeInQuant"});
				if (val == false) Tweener.addTween(screen_button, {alpha:0, time:0.3, transition:"easeInQuant"});
			}
		}
	
	/****************************************************************************************************/
	//	Function. Sets the format of the given time value.
	
		private function timeFormat(time:Number):String {
			time = Math.round(time);
			var min:uint = Math.floor(time/60);
			var sec:uint = time-min*60;
			var min_str:String, sec_str:String
			min_str = (min < 10?'0':'')+min.toString();
			sec_str = (sec < 10?'0':'')+sec.toString();
			var t:String = min_str+':'+sec_str;
			return t;
		}
		
	/****************************************************************************************************/
	//	Function. Performs a number of actions for deactivating the video player.
	
		public function killVideoPlayer():void {
			
			if (wt != null) {
				var pflag:Boolean = wt.footerObj.getPlayState();
				if (wt.footerObj.playing_flag == true && !pflag) wt.footerObj.musicButtonClickHandler();
			}
			
			if (video != null) {
				playerLoader.content.removeEventListener("onReady", onPlayerReady);
				playerLoader.content.removeEventListener("onStateChange", onPlayerStateChange);
				video.destroy();
			}
			
			__stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onStageFullscreen);
			__stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			__stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveVPListener);
			
			if (imageLoader) {
				imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoadComplete);
				imageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
			}
			
			if (timelineTimer) {
				timelineTimer.stop();
				timelineTimer.removeEventListener(TimerEvent.TIMER, updateTimeline);
			}
			if (autohideTimer) {
				autohideTimer.stop();
				autohideTimer.removeEventListener(TimerEvent.TIMER, controlsFadeListener);
			}
			Utils.removeTweens(videoplayer);
			
			if (video != null) {
				videoplayer.removeChild(playerLoader);
				video = null;
			}
			if (controls != null) {
				videoplayer.removeChild(controls);
				controls = null;
			}
		}
		
	}
}