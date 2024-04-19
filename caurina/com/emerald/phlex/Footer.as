/**
	Footer class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.Bitmap;
    import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundChannel;
    import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.utils.Timer;
	import com.emerald.phlex.utils.Geom;
	import com.emerald.phlex.utils.Image;
	import com.everydayflash.equalizer.*;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import caurina.transitions.*;

	public class Footer {
		
		private var __root:WebsiteTemplate;
		private var __stage:Stage;
		private var footer:Sprite, footer_bg:Sprite, footer_pattern:Sprite, fullscreen_but:Sprite, music_but:Sprite, social_icons:Sprite;
		private var footer_base:Shape;
		private var fs_but:MovieClip;
		private var playList:Array, networksArray:Array;
		private var volumeTimer:Timer;
		private var pause_position:Number = 0;
		
		public var currentTrackIndex:uint;
		public var sound:Sound;
		public var sound_request:URLRequest;
		public var sound_context:SoundLoaderContext;
		public var sound_transform:SoundTransform;
		public var sound_channel:SoundChannel;
		public var isPlaying:Boolean = false;
		public var volume_fade:String;
		public var playing_flag:Boolean = false;	// stores the current play/pause music state at the time a video starts playing
		public var footerTextStyleSheet:StyleSheet;
		
		private static const TIMER_DELAY:uint = 30;
		private static const VOLUME_FADING_STEP:Number = 0.1;
		private static const FADE_DURATION:Number = 0.8;
		private static const ON_ROLL_FADE_DURATION:Number = 0.2;
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function Footer(obj:WebsiteTemplate):void {
			__root = obj; // a reference to the object of the WebsiteTemplate class
			__stage = __root.stage as Stage; // a reference to the object of Stage class
			footer = __root.footer;
			footer_base = __root.footer_base;
			footer_bg = __root.footer_bg;
			footer_pattern = __root.footer_pattern;
		}
		
	/****************************************************************************************************/
	//	Function. Builds the footer. Called from the __root.bgObj.changeBgImage() function.
		
		public function createFooter():void {
			footer.alpha = footer_base.alpha = 0;
			if (!isNaN(__root.footerBgColor)) {
				Geom.drawRectangle(footer_base, __stage.stageWidth, __root.footerHeight, __root.footerBgColor, 1);
			}
			footer.x = Math.floor(0.5*(__stage.stageWidth-__root.templateWidth));
			footer.y = footer_base.y = __stage.stageHeight - __root.footerHeight;
			Tweener.addTween(footer, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuint"});
			Tweener.addTween(footer_base, {alpha:1, time:FADE_DURATION, transition:"easeOutSine"});
			
			// Footer background image loading
			if (__root.footerBgImage != null) {
				var footerBgImageLoader:Loader = new Loader();
				footerBgImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, footerBgImageLoadComplete);
				footerBgImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, footerBgImageLoadError);
				footerBgImageLoader.load(new URLRequest(__root.footerBgImage+(__root.killCachedFiles?__root.killcache_str:'')));
			}
			
			// Footer pattern loading
			if (__root.footerPattern != null) {
				var footerPatternLoader:Loader = new Loader();
				footerPatternLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, footerPatternLoadComplete);
				footerPatternLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, footerPatternLoadError);
				footerPatternLoader.load(new URLRequest(__root.footerPattern+(__root.killCachedFiles?__root.killcache_str:'')));
			}
			
			// Full screen icon
			if (__root.showFullScreenIcon) {
				fs_but = new fullscreen_button();
				var fullscreenButtonColor:ColorTransform = fs_but.transform.colorTransform;
				fullscreenButtonColor.color = __root.musicAndScreenIconsColor;
				fs_but.transform.colorTransform = fullscreenButtonColor;
				fullscreen_but = new Sprite();
				fullscreen_but.addChild(fs_but);
				fullscreen_but.name = "fullscreen_but";
				fullscreen_but.x = __root.templateWidth - __root.footerRightMargin - fullscreen_but.width;
				fullscreen_but.y = __root.musicAndScreenIconsTopPadding;
				footer.addChild(fullscreen_but);
				if (__root.musicAndScreenIconsOverBrightness != 0) Image.applyBrightness(fullscreen_but, __root.musicAndScreenIconsOverBrightness, ON_ROLL_FADE_DURATION);
				fullscreen_but.buttonMode = true;
				fullscreen_but.addEventListener(MouseEvent.CLICK, fsButtonClickListener);
			}
			
			// Sound initiating
			if (__root.musicEnabled) {
				playList = __root.playList;
				if (playList.length > 0) {
					currentTrackIndex = 0;
					sound_context = new SoundLoaderContext(__root.musicBufferTime, false);
					sound_transform = new SoundTransform(__root.musicVolume, 0);
					startNewTrack(currentTrackIndex);
					volumeTimer = new Timer(TIMER_DELAY, 0);
					volumeTimer.addEventListener(TimerEvent.TIMER, changeVolume);
				}
			}
			
			// *** Music icon-equalizer
			if (__root.showMusicIcon) {
				music_but = new Sprite();
				music_but.name = "music_but";
				Geom.drawRectangle(music_but, 16, 16, 0xFF9900, 0);
				Geom.drawRectangle(music_but, 3, 3, __root.musicAndScreenIconsColor, 1, 0, 0, 0, 0, 0, 13);
				Geom.drawRectangle(music_but, 3, 3, __root.musicAndScreenIconsColor, 1, 0, 0, 0, 0, 4, 13);
				Geom.drawRectangle(music_but, 3, 3, __root.musicAndScreenIconsColor, 1, 0, 0, 0, 0, 8, 13);
				Geom.drawRectangle(music_but, 3, 3, __root.musicAndScreenIconsColor, 1, 0, 0, 0, 0, 12, 13);
				music_but.x = __root.templateWidth - __root.footerRightMargin - (fullscreen_but?fullscreen_but.width+__root.musicAndScreenIconsSpacing:0) - music_but.width;
				music_but.y = __root.musicAndScreenIconsTopPadding;
				footer.addChild(music_but);
				
				// -- Equalizer
				var es:EqualizerSettings = new EqualizerSettings();
				es.numOfBars = 4;
				es.height = 13;
				es.barSize = 4;
				es.vgrid = true;
				es.hgrid = 0;
				es.barColor = __root.musicAndScreenIconsColor;
				
				var equalizer:Equalizer = new Equalizer(this, es);
				music_but.addChild(equalizer);
				// --
				
				music_but.addEventListener(Event.ENTER_FRAME, equalizer.render);
				
				if (__root.musicEnabled && playList.length > 0) {
					if (__root.musicAndScreenIconsOverBrightness != 0) Image.applyBrightness(music_but, __root.musicAndScreenIconsOverBrightness, ON_ROLL_FADE_DURATION);
					music_but.buttonMode = true;
					music_but.addEventListener(MouseEvent.CLICK, musicButtonClickListener);
				}
			}
			
			// Social network icons
			networksArray = __root.networksArray;
			if (networksArray.length > 0) {
				social_icons = new Sprite();
				social_icons.x = __root.footerLeftMargin;
				social_icons.y = __root.socialIconsTopPadding;
				footer.addChild(social_icons);
				loadIcon(0);
			} else {
				drawFooterText();
			}
		}
		
		private function footerBgImageLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, footerBgImageLoadComplete);
			footer_bg.alpha = 0;
			footer_bg.addChild(e.target.content);
			footer_bg.x = -Math.round((footer_bg.width - __stage.stageWidth)/2);
			footer_bg.y = __stage.stageHeight - footer_bg.height;
			Tweener.addTween(footer_bg, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuint"});
		}
		
		private function footerBgImageLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, footerBgImageLoadError);
		}
		
		private function footerPatternLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, footerPatternLoadComplete);
			footer_pattern.alpha = 0;
			var bmp:Bitmap = Bitmap(e.target.content);
			var bmpData:BitmapData = bmp.bitmapData;
			var bmp_matrix:Matrix = new Matrix();
			with (footer_pattern.graphics) {
				beginBitmapFill(bmpData, bmp_matrix, true, false);
				lineTo(bmpData.width, 0);
				lineTo(bmpData.width, __root.footerHeight);
				lineTo(0, __root.footerHeight);
				lineTo(0, 0);
				endFill();
			}
			footer_pattern.x = -Math.round((footer_pattern.width - __stage.stageWidth)/2);
			footer_pattern.y = __stage.stageHeight - __root.footerHeight;
			Tweener.addTween(footer_pattern, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuint"});
		}
		
		private function footerPatternLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, footerPatternLoadError);
		}
	
	/****************************************************************************************************/
	//	Function. Fullscreen button click listener.
	
		private function fsButtonClickListener(e:MouseEvent):void {
			if (__stage.displayState == StageDisplayState.NORMAL) __stage.displayState = StageDisplayState.FULL_SCREEN;
			else __stage.displayState = StageDisplayState.NORMAL;
		}
		
	/****************************************************************************************************/
	//	Function. Music button click listener.
	
		private function musicButtonClickListener(e:MouseEvent):void {
			musicButtonClickHandler();
		}
		
	/****************************************************************************************************/
	//	Function. Music button click handler: toggles the play/pause mode (with turning the volume up/down).
	
		public function musicButtonClickHandler():void {
			if (isPlaying) {
				if (volume_fade == null || volume_fade == "in") volume_fade = "out";
				else if (volume_fade == "out") volume_fade = "in";
			} else {
				volume_fade = "in";
			}
			volumeTimer.stop();
			volumeTimer.start();
		}
		
	/****************************************************************************************************/
	//	Function. Gets the current music play state. Called from the VideoPlayer/VideoPlayerYouTube class.
	
		public function getPlayState():Boolean {
			var flag:Boolean;
			if (isPlaying) {
				if (volume_fade == null || volume_fade == "in") flag = true;
				else if (volume_fade == "out") flag = false;
			} else {
				flag = false;
			}
			return flag;
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when a sound has finished playing.
	
		private function playbackComplete(event:Event) {
			sound_channel.removeEventListener(Event.SOUND_COMPLETE, playbackComplete);
			pause_position = 0;
			if (currentTrackIndex == playList.length-1) currentTrackIndex = 0;
			else currentTrackIndex += 1;
			startNewTrack(currentTrackIndex);
		}
		
	/****************************************************************************************************/
	//	Function. Starts loading and playing a new music track.
		
		private function startNewTrack(index:uint):void {
			sound = new Sound();
			sound_request = new URLRequest(playList[index]);
			sound.load(sound_request, sound_context);
			sound_channel = sound.play();
			sound_channel.soundTransform = sound_transform;
			sound_channel.addEventListener(Event.SOUND_COMPLETE, playbackComplete);
			isPlaying = true;
			playing_flag = true;
		}
		
	/****************************************************************************************************/
	//	Function. Increases/decreases the sound volume.
	
		private function changeVolume(e:TimerEvent):void {
			var st:SoundTransform = sound_channel.soundTransform;
			var vol:Number;
			if (isPlaying) {
				if (volume_fade == "out") {
					vol = st.volume - VOLUME_FADING_STEP;
					if (vol < 0) vol = 0;
					if (vol == 0) {
						pause_position = sound_channel.position;
						sound_channel.stop();
						volumeTimer.stop();
						volume_fade = null;
						isPlaying = false;
					}
				} else if (volume_fade == "in") {
					vol = st.volume + VOLUME_FADING_STEP;
					if (vol > __root.musicVolume) vol = __root.musicVolume;
					if (vol == __root.musicVolume) {
						volumeTimer.stop();
						volume_fade = null;
					}
				}
			} else {
				isPlaying = true;
				sound_channel = sound.play(pause_position);
				vol = st.volume + VOLUME_FADING_STEP;
				if (vol > __root.musicVolume) vol = __root.musicVolume;
				if (vol == __root.musicVolume) {
					volumeTimer.stop();
					volume_fade = null;
				}
			}
			st.volume = vol;
            sound_channel.soundTransform = st;
			sound_channel.removeEventListener(Event.SOUND_COMPLETE, playbackComplete);
			sound_channel.addEventListener(Event.SOUND_COMPLETE, playbackComplete);
		}

	/****************************************************************************************************/
	//	Function. Loads an icon.
	
		private function loadIcon(index:uint):void {
			var iconLoader:Loader = new Loader();
			iconLoader.name = "iconLoader"+(index+1);
			iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, iconLoadComplete);
			iconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, iconLoadError);
			iconLoader.load(new URLRequest(networksArray[index].iconSrc+(__root.killCachedFiles?__root.killcache_str:'')));
		}
		
	/****************************************************************************************************/
	//	Functions. Handles events on icon loading.
		
		private function iconLoadComplete(e:Event):void {
			e.target.loader.removeEventListener(Event.COMPLETE, iconLoadComplete);
			e.target.loader.removeEventListener(IOErrorEvent.IO_ERROR, iconLoadError);
			var index:uint = e.target.loader.name.substr(10)-1;
			var container:Sprite = new Sprite();
			container.name = "container"+(index+1);
			container.x = social_icons.width + (social_icons.width>0?__root.socialIconsSpacing:0);
			social_icons.addChild(container);
			container.alpha = 0;
			container.addChild(e.target.loader);
			container.buttonMode = true;
			Tweener.addTween(container, {alpha:1, time:FADE_DURATION, transition:"easeOutQuint"});
			if (__root.socialIconsOverBrightness != 0) Image.applyBrightness(container, __root.socialIconsOverBrightness, 0.5*ON_ROLL_FADE_DURATION);
				
			if (networksArray[index].clickLink != undefined) {
				var link:String = networksArray[index].clickLink;
				var target:String = networksArray[index].clickTarget;
				if (target == null) target = "_blank";
				container.addEventListener(MouseEvent.CLICK,
					function(e:MouseEvent){
						if (link == "#") SWFAddress.setValue("/");
						else {
							if (link.substr(0, 1) == "#") SWFAddress.setValue(link.substr(1));
							else {
								try { navigateToURL(new URLRequest(link), target); }
								catch (e:Error) { }
							}
						}
					}
				);
			}
			
			if (index < networksArray.length-1) loadIcon(index+1);
			else drawFooterText();
		}
		
		private function iconLoadError(e:IOErrorEvent):void {
			e.target.loader.removeEventListener(Event.COMPLETE, iconLoadComplete);
			e.target.loader.removeEventListener(IOErrorEvent.IO_ERROR, iconLoadError);
			var index:uint = e.target.loader.name.substr(10)-1;
			if (index < networksArray.length-1) loadIcon(index+1);
			else drawFooterText();
		}
		
	/****************************************************************************************************/
	//	Function. Creates the footer text.
	
		private function drawFooterText():void {
			var tf:TextField = new TextField();
			tf.name = "tf";
			tf.x = __root.footerLeftMargin + (social_icons ? social_icons.width + __root.footerTextLeftPadding : 0);
			tf.y = __root.footerTextTopPadding;
			var tf_max_width:uint = __root.templateWidth - tf.x - __root.footerRightMargin - (fullscreen_but?fullscreen_but.width+__root.musicAndScreenIconsSpacing:0) - (music_but?music_but.width+__root.musicAndScreenIconsSpacing:0);
			footer.addChild(tf);
			
			if (__root.footerTextStyleSheet != null) {
				footerTextStyleSheet = __root.footerTextStyleSheet;
				var hobj:Object = footerTextStyleSheet.getStyle("footerlink-hover");
				var hover_obj:Object = new Object();
				hover_obj.color = hobj.color;
				footerTextStyleSheet.setStyle("a:hover", hover_obj);
				tf.styleSheet = footerTextStyleSheet;
			}
			
			tf.width = tf_max_width;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.embedFonts = true;
			tf.selectable = false;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.mouseWheelEnabled = false;
			if (__root.footerText != null) tf.htmlText = __root.footerText;
		}
	}
}