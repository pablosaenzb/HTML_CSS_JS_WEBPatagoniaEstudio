/**
	Showreel class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.showreel {
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.text.StyleSheet;
	import com.emerald.phlex.videoplayer.VideoPlayer;
	import com.emerald.phlex.videoplayer.VideoPlayerYouTube;

	public class Showreel extends Sprite {
		
		public var main:Sprite, videoplayer:Sprite;
		public var __root:*;
		private var xml_URL:String;
		private var xmlLoader:URLLoader;
		private var dataXML:XML;
		private var XMLParserObj:Object, vpObj:Object;
		private var killcache_str:String;
		private var killCachedFiles:Boolean = false;
		private var textStyleSheet:StyleSheet;
		private var video_width:uint;
		private var video_height:uint;
		
		// General Settings
		public var videoPlayerWidth:Number;
		public var videoPlayerHeight:Number;
		public var videoPlayerYPosition:int = 0;
		public var videoPlayerHorizontalAlign:String = "center";
		public var videoPlayerVerticalAlign:String = "top";
		public var videoPlayerBgColor:Number;
		public var videoPlayerBgAlpha:Number;
		public var videoPlayerShadowColor:Number;
		public var videoPlayerShadowAlpha:Number;
		public var videoPlayerPreloaderColor:Number = 0xFFFFFF;
		public var videoPlayerPreloaderAlpha:Number = 0.7;
		
		public var videoBufferTime:Number = 3;
		public var videoSoundVolume:Number = 1;
		
		public var showVideoControls:Boolean = true;
		public var videoControlsAutoHide:Boolean = true;
		public var videoControlsAutoHideDelay:Number = 3;
		public var videoControlsBgColor:uint = 0xFFFFFF;
		public var videoControlsSeparatorColor:uint = 0xE5E5E5;
		public var videoControlsButtonColor:uint = 0x777777;
		public var videoControlsButtonOverColor:uint = 0x444444;
		public var soundVolumeBarFillColor:uint = 0xFFCC99;
		public var soundVolumeBarBgColor:uint = 0xEEEEEE;
		public var timelineBgColor:uint = 0xEEEEEE;
		public var timelineSeekBarColor:uint = 0xCCCCCC;
		public var timelinePlayBarColor:uint = 0x606060;
		
		public var screenPlayButtonSize:uint = 62;
		public var screenPlayButtonIconColor:uint = 0xFFFFFF;
		public var screenPlayButtonBgColor:uint = 0x000000;
		public var screenPlayButtonAlpha:Number = 0.5;
		
		public var videoURL:String;
		public var previewImageURL:String;
		public var youTubeMode:Boolean = false;
		public var playbackQuality:String = "default";
		public var videoAutoPlay:Boolean = true;
		
		// Video Player Shadow
		public var videoPlayerShadowBlur:uint = 16;
		public var videoPlayerShadowStrength:uint = 1;
		public var videoPlayerShadowQuality:uint = 2;
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function Showreel():void {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addChild(main = new Sprite());
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the Showreel object is added to the Stage.
	
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
	/****************************************************************************************************/
	//	Function. Initiates a number of actions for preparing and activating the module.
	//	Called from the moduleLoadComplete() function of the WebsiteTemplate class.

		public function initiate(obj:*, xmlURL:String, killcache:Boolean, stylesheet:StyleSheet):void {
			__root = obj; // a reference to the object of the WebsiteTemplate class
			xml_URL = xmlURL;
			killCachedFiles = killcache;
			textStyleSheet = stylesheet;
			if (xml_URL != null) {
				xmlLoader = new URLLoader();
				xmlLoader.addEventListener(Event.COMPLETE, xmlDataProcessing);
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlDataError);
				var date:Date = new Date();
				if (__root != null) killcache_str = __root.generateKillCacheString(date);
				xmlLoader.load(new URLRequest(xml_URL+(killCachedFiles?killcache_str:'')));
			}
		}

	/****************************************************************************************************/
	//	Function. Processes the XML data.
		
		private function xmlDataProcessing(e:Event):void {
			xmlLoader.removeEventListener(Event.COMPLETE, xmlDataProcessing);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlDataError);
			dataXML = new XML(e.currentTarget.data);
			XMLParserObj = new XMLParser(this);
			XMLParserObj.settingsNodeParser(dataXML.settings); // processing "settings" node
			XMLParserObj.videoNodeParser(dataXML.video); // processing "video" node
			
			if (youTubeMode == true) vpObj = new VideoPlayerYouTube(this, killCachedFiles, textStyleSheet, videoURL, previewImageURL, playbackQuality, videoAutoPlay);
			else vpObj = new VideoPlayer(this, killCachedFiles, textStyleSheet, videoURL, previewImageURL, videoAutoPlay);
			videoplayer = vpObj.videoplayer;
			main.addChild(videoplayer);
			video_width = videoplayer.width;
			video_height = videoplayer.height;
			
			// *** Video player positioning
			switch (videoPlayerHorizontalAlign) {
				case "left":
					videoplayer.x = 0;
				break;
				case "center":
					if (__root != null) videoplayer.x = Math.ceil(0.5*(__root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - video_width));
					else videoplayer.x = Math.ceil(490 - video_width/2);
				break;
				case "right":
					if (__root != null) videoplayer.x = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - video_width;
					else videoplayer.x = 980 - video_width;
				break;
			}
			switch (videoPlayerVerticalAlign) {
				case "top":
					videoplayer.y = videoPlayerYPosition;
				break;
				case "middle":
				case "center":
					if (__root != null) {
						var videoplayer_y:int = 0.5*(stage.stageHeight-__root.footerHeight-video_height+__root.headerHeight) - __root.page_content.y - __root.module_container.y;
						videoplayer.y = Math.max(videoplayer_y, videoPlayerYPosition);
						stage.addEventListener(Event.RESIZE, onStageResized);
					}
					else videoplayer.y = 70;
				break;
			}
			
			if (__root != null) __root.openNewPage(); // calls the openNewPage() function of the WebsiteTemplate class
		}
		
		private function xmlDataError(e:IOErrorEvent):void {
			xmlLoader.removeEventListener(Event.COMPLETE, xmlDataProcessing);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlDataError);
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the SWF file is resized.
		
		private function onStageResized(e:Event):void {
			if (!__root.isFullscreenVideo) {
				var videoplayer_y:int = 0.5*(stage.stageHeight-__root.footerHeight-video_height+__root.headerHeight) - __root.page_content.y - __root.module_container.y;
				videoplayer.y = Math.max(videoplayer_y, videoPlayerYPosition);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Performs a number of actions for deactivating the module.
	//	Called from the pageContentClosed() function of the WebsiteTemplate class.

		public function killModule():void {
			
			if (stage.hasEventListener(Event.RESIZE)) stage.removeEventListener(Event.RESIZE, onStageResized);
			if (vpObj != null) {
				vpObj.killVideoPlayer();
				vpObj = null;
			}
			if (main != null) {
				removeChild(main);
				main = null;
			}
		}
	
	/****************************************************************************************************/
	
	}
}