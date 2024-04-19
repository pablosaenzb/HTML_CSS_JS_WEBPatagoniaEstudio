/**
	WebsiteTemplate class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex {
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
    import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.utils.getTimer;
	import com.emerald.phlex.utils.Geom;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import caurina.transitions.*;
	import caurina.transitions.properties.ColorShortcuts;

	public class WebsiteTemplate extends Sprite {
		
		private var configXML_URL:String;		// the path to the config XML file
		private var configXMLLoader:URLLoader, menuXMLLoader:URLLoader;
		private var moduleLoader:Loader;
		private var configXML:XML, menuXML:XML;
		private var XMLParserObj:Object, bgObj:Object, menuObj:Object;
		private var tween_status:String;
		private var home:Boolean;
		private var website_title:String;
		private var homepage_index:uint, error404_index:Number;
		private var bcArray:Array;
		private static const STAGE_MIN_HEIGHT:uint = 800;
		private static const ANIMATION_DURATION:Number = 0.8;
		private static const ON_ROLL_DURATION:Number = 0.3;
		private static const MASK_YPOS_SHIFT:uint = 20;
		private static const PAGE_TOP_MARGIN:uint = 25;
		private static const FULLSCREEN_BG_COLOR:uint = 0x000000;
		public const PAGE_BOTTOM_MARGIN:uint = 15;
		
		public var main:Sprite, page:Sprite, page_mask:Sprite, menu:Sprite, logo:Sprite, breadcrumbs:Sprite, page_content:Sprite, page_content_mask:Sprite, page_title:Sprite, module_container:Sprite, preloader:Sprite;
		public var header_bg:Sprite, header_pattern:Sprite, header_shadow:Sprite, body_bg:Sprite, body_pattern:Sprite, footer:Sprite, footer_bg:Sprite, footer_pattern:Sprite;
		public var video_fullscreen_bg:Sprite, gallery_container:Sprite;
		public var header_base:Shape, body_base:Shape, footer_base:Shape, page_bg:Shape, pm1:Shape, pm2:Shape, body_bg_mask:Shape, body_pattern_mask:Shape;
		public var pagesArray:Array, playList:Array, networksArray:Array;
		public var currentIndex:uint;
		public var footerObj:Object;
		public var killcache_str:String;
		public var killCachedFiles:Boolean = false;
		public var cachePeriod:String = "second";
		public var menu_initialized:Boolean = false;
		public var menu_blocked:Boolean = false;
		public var header_add:uint;
		public var submenu_max_h:uint = 0;
		public var isFullscreenVideo:Boolean = false;
		public var textStyleSheet:StyleSheet, footerTextStyleSheet:StyleSheet;
		public var bcIconBmpData:BitmapData;
		
		public var title_tf:TextField;
		public var title_tf_height:uint;
		
		// Config properties
		public var websiteTitle:String;
		public var templateWidth:uint;
		
		public var headerHeight:uint = 100;
		public var headerPattern:String;
		public var headerBgImage:String;
		public var headerBgColor:Number;
		public var headerShadow:String;
		
		public var logoURL:String;
		public var logoAlign:String = "left";
		public var logoXOffset:int = 0;
		public var logoYPosition:uint = 0;
		
		public var menuXML_URL:String;
		public var menuAlign:String = "right";
		public var menuXOffset:int = 0;
		public var menuYPosition:uint = 34;
		public var menuSpacing:uint = 26;
		public var menuFont:String = "Arial";
		public var menuFontSize:uint = 14;
		public var menuFontWeight:String = "normal";
		public var menuFontColor:uint = 0x444444;
		public var menuOverFontColor:uint = 0x577C95;
		public var menuSelectedFontColor:uint = 0x577C95;
		public var menuOverBgColor:Number;
		public var menuOverBgAlphaTop:Number = 0;
		public var menuOverBgAlphaBottom:Number = 1;
		
		public var submenuItemHeight:uint = 30;
		public var submenuFont:String = "Arial";
		public var submenuFontSize:uint = 12;
		public var submenuFontWeight:String = "normal";
		public var submenuFontColor:uint = 0x777777;
		public var submenuOverFontColor:uint = 0x444444;
		public var submenuSelectedFontColor:Number;
		public var submenuBgColor:uint = 0xFFFFFF;
		public var submenuBgAlpha:Number = 0.9;
		public var submenuOverBgColor:uint = 0xE7E7E7;
		public var submenuOverBgAlpha:Number = 1;
		public var submenuTopTrimHeight:uint = 1;
		public var submenuTopTrimColor:Number;
		public var submenuTopTrimAlpha:Number = 0;
		public var submenuShadowColor:uint = 0x333333;
		public var submenuShadowAlpha:Number = 0;
		public var submenuShadowStrength:Number = 0;
		public var submenuShadowDistance:Number = 0;
		
		public var bodyPattern:String;
		public var bodyPatternFullStage:Boolean = false;
		public var bodyBgImage:String;
		public var bodyBgImageFullStage:Boolean = false;
		public var bodyBgColor:Number;
		
		public var contentPageMinTopMargin:uint = 30;
		public var contentPageMaxTopMargin:uint = 100;
		public var contentPageBgColor:Number;
		public var contentPageBgAlpha:Number = 0;
		public var contentPageLeftMargin:uint = 0;
		public var contentPageRightMargin:uint = 0;
		public var styleSheetURL:String;
		
		public var breadcrumbsTopMargin:uint = 0;
		public var breadcrumbIconURL:String;
		public var breadcrumbIconTopPadding:uint = 0;
		public var breadcrumbIconColor:uint = 0x666666;
		public var breadcrumbSpacing:uint = 20;
		public var breadcrumbFont:String = "Arial";
		public var breadcrumbFontSize:uint = 12;
		public var breadcrumbFontColor:uint = 0x999999;
		public var breadcrumbOverFontColor:uint = 0x777777;
		public var breadcrumbSelectedFontColor:uint = 0x577C95;
		
		public var footerHeight:uint = 34;
		public var footerLeftMargin:uint = 0;
		public var footerRightMargin:uint = 0;
		public var footerPattern:String;
		public var footerBgImage:String;
		public var footerBgColor:Number;
		public var showMusicIcon:Boolean = true;
		public var showFullScreenIcon:Boolean = true;
		public var musicAndScreenIconsTopPadding:uint = 0;
		public var musicAndScreenIconsSpacing:uint = 15;
		public var musicAndScreenIconsColor:uint = 0xDDDDDD;
		public var musicAndScreenIconsOverBrightness:Number = 0;
		public var socialIconsTopPadding:uint = 0;
		public var socialIconsSpacing:uint = 6;
		public var socialIconsOverBrightness:Number = 0;
		
		public var showPreloader:Boolean = true;
		public var preloaderColor:uint = 0x333333;
		public var preloaderAlpha:Number = 0.5;
		
		public var musicEnabled:Boolean = true;
		public var musicBufferTime:Number = 3000;
		public var musicVolume:Number = 1;
		
		public var footerText:String;
		public var footerTextTopPadding:uint = 0;
		public var footerTextLeftPadding:uint = 0;
		
		ColorShortcuts.init();	// initiates the ColorShortcuts special properties of the Tweener class
		
	/****************************************************************************************************/
	//	Constructor function.

		public function WebsiteTemplate():void {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addChild(main = new Sprite());
			main.name = "template";
			main.addChild(body_base = new Shape());
			main.addChild(body_bg = new Sprite());
			main.addChild(body_bg_mask = new Shape());
			body_bg.mask = body_bg_mask;
			main.addChild(body_pattern = new Sprite());
			main.addChild(body_pattern_mask = new Shape());
			body_pattern.mask = body_pattern_mask;
			main.addChild(header_base = new Shape());
			main.addChild(header_bg = new Sprite());
			main.addChild(header_pattern = new Sprite());
			main.addChild(video_fullscreen_bg = new Sprite());
			main.addChild(page = new Sprite());
			main.addChild(page_mask = new Sprite());
			page.addChild(page_bg = new Shape());
			page.addChild(header_shadow = new Sprite());
			page.mask = page_mask;
			page.addChild(page_content_mask = new Sprite());
			page.addChild(page_content = new Sprite());
			page_content.mask = page_content_mask;
			page_content.addChild(module_container = new Sprite());
			page_content.addChild(page_title = new Sprite());
			page.addChild(breadcrumbs = new Sprite());
			page.addChild(logo = new Sprite());
			page.addChild(menu = new Sprite());
			main.addChild(preloader = new Sprite());
			main.addChild(footer_base = new Shape());
			main.addChild(footer_bg = new Sprite());
			main.addChild(footer_pattern = new Sprite());
			main.addChild(footer = new Sprite());
			main.addChild(gallery_container = new Sprite());
			
			// configXML, killCache, cachePeriod - can be passed through FlashVars (on HTML page)
			if (this.loaderInfo.parameters.configXML != null) configXML_URL = this.loaderInfo.parameters.configXML;
			else configXML_URL = "xml/layout1/config.xml";
			configXMLLoader = new URLLoader();
			configXMLLoader.addEventListener(Event.COMPLETE, configXMLDataProcessing);
			configXMLLoader.addEventListener(IOErrorEvent.IO_ERROR, catchError);
			if (this.loaderInfo.parameters.killCache == "true") killCachedFiles = true;
			var date:Date = new Date();
			killcache_str = generateKillCacheString(date);
			configXMLLoader.load(new URLRequest(configXML_URL+(killCachedFiles?killcache_str:'')));
			bgObj = new Backgrounds(this);
			menuObj = new Menu(this);
			footerObj = new Footer(this);
			moduleLoader = new Loader();
			moduleLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, moduleLoadComplete);
			moduleLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, moduleLoadError);
		}
		
		public function generateKillCacheString(date:Date):String {
			var period:String = this.loaderInfo.parameters.cachePeriod;
			if (period == "second" || period == "minute" || period == "hour" || period == "day") cachePeriod = this.loaderInfo.parameters.cachePeriod;
			var str:String = '?'+Math.floor(date.getTime()/1000/(cachePeriod=="minute"?60:1)/(cachePeriod=="hour"?3600:1)/(cachePeriod=="day"?86400:1)).toString();
			return str;
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the WebsiteTemplate object is added to the Stage.
	
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.stageFocusRect = false;
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the SWF file is resized.
	
		private function onStageResized(e:Event):void {

			if (isFullscreenVideo == false) {
				
				if (menu_initialized) {
					header_base.width = stage.stageWidth;
					header_bg.x = -Math.round((header_bg.width - stage.stageWidth)/2);
					header_pattern.x = -Math.round((header_pattern.width - stage.stageWidth)/2);
					body_base.width = body_bg_mask.width = stage.stageWidth;
					body_base.height = stage.stageHeight - headerHeight - footerHeight;
					body_bg_mask.height = stage.stageHeight - (bodyBgImageFullStage?0:headerHeight+footerHeight);
					bgObj.fitBodyBgImages();
					body_pattern.x = -Math.round((body_pattern.width - stage.stageWidth)/2);
					body_pattern_mask.width = stage.stageWidth;
					body_pattern_mask.height = stage.stageHeight - (bodyPatternFullStage?0:headerHeight+footerHeight);
					page.x = Math.floor(0.5*(stage.stageWidth-templateWidth));
					pm1.width = stage.stageWidth;
					pm2.height = stage.stageHeight-footerHeight;
					pm2.x = Math.floor(0.5*(stage.stageWidth-templateWidth)) - 20;
					header_shadow.x = -Math.round((header_shadow.width - stage.stageWidth)/2) - page.x;
					footer.x = Math.floor(0.5*(stage.stageWidth-templateWidth));
					footer.y = footer_base.y  = footer_pattern.y = stage.stageHeight - footerHeight;
					footer_base.width = stage.stageWidth;
					footer_bg.x = -Math.round((footer_bg.width - stage.stageWidth)/2);
					footer_bg.y = stage.stageHeight - footer_bg.height;
					footer_pattern.x = -Math.round((footer_pattern.width - stage.stageWidth)/2);
					header_add = Math.min((contentPageMaxTopMargin-contentPageMinTopMargin), Math.floor((stage.stageHeight-STAGE_MIN_HEIGHT)/2));
					page_content.y = page_content_mask.y = headerHeight + contentPageMinTopMargin + (stage.stageHeight>STAGE_MIN_HEIGHT?header_add:0);
					page_content_mask.y -= MASK_YPOS_SHIFT;
					
					if (Tweener.isTweening(page_content_mask)) {
						Tweener.removeTweens(page_content_mask);
						if (tween_status == "opening") {
							page_content_mask.height = stage.stageHeight-footerHeight-page_content_mask.y;
							pageContentOpened();
						}
						if (tween_status == "closing") {
							page_content_mask.height = 0;
							pageContentClosed();
						}
					} else {
						if (page_content_mask.height > 0) {
							page_content_mask.height = stage.stageHeight-footerHeight-page_content_mask.y;
						}
					}
				}
				preloader.x = Math.round(stage.stageWidth/2);
				preloader.y = Math.round(stage.stageHeight/2);
				
			} else {
				isFullscreenVideo = false;
			}
		}
		
	/****************************************************************************************************/
	//	Function. Processes the config XML file data
		
		private function configXMLDataProcessing(e:Event):void {
			configXMLLoader.removeEventListener(Event.COMPLETE, configXMLDataProcessing);
			configXMLLoader.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			configXML = new XML(e.currentTarget.data);
			XMLParserObj = new XMLParser(this);
			XMLParserObj.generalNodeParser(configXML.general); // processing "general" node
			playList = XMLParserObj.musicNodeParser(configXML.music); // processing "music" node
			networksArray = XMLParserObj.networksNodeParser(configXML.socialnetworks); // processing "socialnetworks" node
			XMLParserObj.footertextNodeParser(configXML.footertext); // processing "footertext" node
			
			if (menuAlign == "right") logoAlign = "left";
			else logoAlign = "right";
			
			stage.addEventListener(Event.RESIZE, onStageResized);
			
			// Loading the CSS file into the StyleSheet
			if (styleSheetURL != null) {
				var cssLoader:URLLoader = new URLLoader();
				cssLoader.addEventListener(Event.COMPLETE, cssFileProcessing);
				cssLoader.addEventListener(IOErrorEvent.IO_ERROR, cssFileError);
				cssLoader.load(new URLRequest(styleSheetURL+(killCachedFiles?killcache_str:'')));
			}
			
			// Preloader
			if (showPreloader && preloaderAlpha > 0) {
				var animation:MovieClip = new preloader_mc();
				preloader.addChild(animation);
				var animColor:ColorTransform = animation.transform.colorTransform;
				animColor.color = preloaderColor;
				animation.transform.colorTransform = animColor;
				animation.alpha = preloaderAlpha;
				preloader.x = Math.round(stage.stageWidth/2);
				preloader.y = Math.round(stage.stageHeight/2);
				preloader.alpha = 0;
				preloader.mouseEnabled = preloader.mouseChildren = false;
			} else if (preloaderAlpha == 0) showPreloader = false;
			
			// Video fullscreen state background
			video_fullscreen_bg.visible = false;
			Geom.drawRectangle(video_fullscreen_bg, stage.stageWidth, stage.stageHeight, FULLSCREEN_BG_COLOR, 1);
			
			// Gallery fullscreen state background
			gallery_container.visible = false;
			gallery_container.mouseEnabled = true;
		}
	
	/****************************************************************************************************/
	//	Function. Processes the CSS file.
		
		private function cssFileProcessing(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, cssFileProcessing);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			textStyleSheet = new StyleSheet();
			textStyleSheet.parseCSS(e.target.data);
			footerTextStyleSheet = new StyleSheet();
			footerTextStyleSheet.parseCSS(e.target.data);
			loadMenuXML();
		}
		
		private function cssFileError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, cssFileProcessing);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			loadMenuXML();
		}
		
	/****************************************************************************************************/
	//	Function. Loads the menu XML file.
		
		private function loadMenuXML():void {
			if (menuXML_URL != null) {
				menuXMLLoader = new URLLoader();
				menuXMLLoader.addEventListener(Event.COMPLETE, menuXMLDataProcessing);
				menuXMLLoader.addEventListener(IOErrorEvent.IO_ERROR, catchError);
				menuXMLLoader.load(new URLRequest(menuXML_URL+(killCachedFiles?killcache_str:'')));
			}
		}
		
	/****************************************************************************************************/
	//	Function. Processes the menu XML file data
		
		private function menuXMLDataProcessing(e:Event):void {
			menuXMLLoader.removeEventListener(Event.COMPLETE, menuXMLDataProcessing);
			menuXMLLoader.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			pagesArray = new Array();
			menuXML = new XML(e.currentTarget.data);
			menuObj.menuXMLParser(menuXML);
			menuObj.createMenu(menu);
			bgObj.createBodyBgContainers();
			
			for (var i=0; i<pagesArray.length; i++) {
				if (pagesArray[i].deepLinkURL == "home" && pagesArray[i].menuLevel == 1) homepage_index = i;
				if (pagesArray[i].deepLinkURL == "error404") error404_index = i;
			}
			
			// SWFAddress event listener
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, addressChangeListener);
			website_title = SWFAddress.getTitle();
		}

	/****************************************************************************************************/
	//	Function. Builds the template header. Called from the bgObj.changeHeaderBgImage() function.
		
		public function createHeader():void {
			header_base.alpha = 0;
			if (!isNaN(headerBgColor)) {
				Geom.drawRectangle(header_base, stage.stageWidth, headerHeight, headerBgColor, 1);
			}
			Tweener.addTween(header_base, {alpha:1, time:ANIMATION_DURATION, transition:"easeOutSine"});
			if (headerBgImage != null) {
				var headerBgImageLoader:Loader = new Loader();
				headerBgImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, headerBgImageLoadComplete);
				headerBgImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, headerBgImageLoadError);
				headerBgImageLoader.load(new URLRequest(headerBgImage+(killCachedFiles?killcache_str:'')));
			}
			if (headerPattern != null) {
				var headerPatternLoader:Loader = new Loader();
				headerPatternLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, headerPatternLoadComplete);
				headerPatternLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, headerPatternLoadError);
				headerPatternLoader.load(new URLRequest(headerPattern+(killCachedFiles?killcache_str:'')));
			}
			if (headerShadow != null) {
				var headerShadowLoader:Loader = new Loader();
				headerShadowLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, headerShadowLoadComplete);
				headerShadowLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, headerShadowLoadError);
				headerShadowLoader.load(new URLRequest(headerShadow+(killCachedFiles?killcache_str:'')));
			}
		}
		
		private function headerBgImageLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, headerBgImageLoadComplete);
			header_bg.alpha = 0;
			header_bg.addChild(e.target.content);
			header_bg.x = -Math.round((header_bg.width - stage.stageWidth)/2);
			Tweener.addTween(header_bg, {alpha:1, time:ANIMATION_DURATION, transition:"easeInOutQuint"});
		}
		
		private function headerBgImageLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, headerBgImageLoadError);
		}
		
		private function headerPatternLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, headerPatternLoadComplete);
			header_pattern.alpha = 0;
			var bmp:Bitmap = Bitmap(e.target.content);
			var bmpData:BitmapData = bmp.bitmapData;
			var bmp_matrix:Matrix = new Matrix();
			with (header_pattern.graphics) {
				beginBitmapFill(bmpData, bmp_matrix, true, false);
				lineTo(bmpData.width, 0);
				lineTo(bmpData.width, headerHeight);
				lineTo(0, headerHeight);
				lineTo(0, 0);
				endFill();
			}
			header_pattern.x = -Math.round((header_pattern.width - stage.stageWidth)/2);
			Tweener.addTween(header_pattern, {alpha:1, time:ANIMATION_DURATION, transition:"easeInOutQuint"});
		}
		
		private function headerPatternLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, headerPatternLoadError);
		}
		
		private function headerShadowLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, headerShadowLoadComplete);
			header_shadow.alpha = 0;
			header_shadow.addChild(e.target.content);
			header_shadow.x = -Math.round((header_shadow.width - stage.stageWidth)/2) - page.x;
			header_shadow.y = headerHeight;
			Tweener.addTween(header_shadow, {alpha:1, time:ANIMATION_DURATION, transition:"easeInOutQuint"});
		}
		
		private function headerShadowLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, headerShadowLoadError);
		}

	/****************************************************************************************************/
	//	Function. Builds the template body. Called from the bgObj.changeHeaderBgImage() function.
		
		public function createBody():void {
			body_base.alpha = 0;
			body_base.y = body_bg.y = body_bg_mask.y = headerHeight;
			if (bodyBgImageFullStage) body_bg.y = body_bg_mask.y = 0;
			if (!isNaN(bodyBgColor)) {
				Geom.drawRectangle(body_base, stage.stageWidth, stage.stageHeight-headerHeight-footerHeight, bodyBgColor, 1);
			}
			Tweener.addTween(body_base, {alpha:1, time:ANIMATION_DURATION, transition:"easeOutSine"});
			Geom.drawRectangle(body_bg_mask, stage.stageWidth, stage.stageHeight-(bodyBgImageFullStage?0:headerHeight+footerHeight), 0xFF9900, 0);
			if (bodyPattern != null) {
				var bodyPatternLoader:Loader = new Loader();
				bodyPatternLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bodyPatternLoadComplete);
				bodyPatternLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bodyPatternLoadError);
				bodyPatternLoader.load(new URLRequest(bodyPattern+(killCachedFiles?killcache_str:'')));
			}
		}
		
		private function bodyPatternLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, bodyPatternLoadComplete);
			body_pattern.alpha = 0;
			var bmp:Bitmap = Bitmap(e.target.content);
			var bmpData:BitmapData = bmp.bitmapData;
			var bmp_matrix:Matrix = new Matrix();
			with (body_pattern.graphics) {
				beginBitmapFill(bmpData, bmp_matrix, true, false);
				lineTo(bmpData.width, 0);
				lineTo(bmpData.width, 2000);
				lineTo(0, 2000);
				lineTo(0, 0);
				endFill();
			}
			body_pattern.x = -Math.round((body_pattern.width - stage.stageWidth)/2);
			body_pattern.y = body_pattern_mask.y = headerHeight;
			if (bodyPatternFullStage) body_pattern.y = body_pattern_mask.y = 0;
			Geom.drawRectangle(body_pattern_mask, stage.stageWidth, stage.stageHeight-(bodyPatternFullStage?0:headerHeight+footerHeight), 0xFF9900, 0);
			Tweener.addTween(body_pattern, {alpha:1, time:ANIMATION_DURATION, transition:"easeInOutQuint"});
		}
		
		private function bodyPatternLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, bodyPatternLoadError);
		}
		
	/****************************************************************************************************/
	//	Function. Builds the breadcrumb navigation panel.
	
		private function createBreadCrumbs():void {
			var items_container:Sprite;
			items_container = breadcrumbs.getChildByName("items_container") as Sprite;
			if (items_container != null) {
				breadcrumbs.removeChild(items_container);
				items_container = null;
			}
			
			if (pagesArray[currentIndex].showBreadCrumbs) {
				
				bcArray = new Array();
				var bcObject:Object;
				bcObject = new Object();
				bcObject.deepLinkURL = pagesArray[currentIndex].deepLinkURL;
				if (pagesArray[currentIndex].menuLevel == 1) bcObject.menuTitle = capitalizeWords(pagesArray[currentIndex].menuTitle);
				else bcObject.menuTitle = pagesArray[currentIndex].menuTitle;
				bcArray.push(bcObject);
				var index2:Number = pagesArray[currentIndex].parentIndex;
				if (index2) {
					bcObject = new Object();
					bcObject.deepLinkURL = pagesArray[index2].deepLinkURL;
					if (pagesArray[index2].menuLevel == 1) bcObject.menuTitle = capitalizeWords(pagesArray[index2].menuTitle);
					else bcObject.menuTitle = pagesArray[index2].menuTitle;
					bcArray.push(bcObject);
					var index3:Number = pagesArray[index2].parentIndex;
					if (index3) {
						bcObject = new Object();
						bcObject.deepLinkURL = pagesArray[index3].deepLinkURL;
						if (pagesArray[index3].menuLevel == 1) bcObject.menuTitle = capitalizeWords(pagesArray[index3].menuTitle);
						else bcObject.menuTitle = pagesArray[index3].menuTitle;
						bcArray.push(bcObject);
					}
				}
				bcObject = new Object();
				bcObject.deepLinkURL = "";
				bcObject.menuTitle = capitalizeWords(pagesArray[homepage_index].menuTitle);
				bcArray.push(bcObject);
				bcArray.reverse();
				
				breadcrumbs.addChild(items_container = new Sprite());
				items_container.name = "items_container";
				
				var item:Sprite;
				var tf:TextField;
				var hitarea:Shape;
				var separator:Sprite;
				var item_xPos:Number = 0;
				var bcTextFormat:TextFormat = new TextFormat();
				bcTextFormat.font = breadcrumbFont;
				bcTextFormat.size = breadcrumbFontSize;
				bcTextFormat.leftMargin = bcTextFormat.rightMargin = 0;
				
				for (var i=0; i<bcArray.length; i++) {
					item = new Sprite();
					item.name = "item"+(i+1);
					item.x = item_xPos;
					items_container.addChild(item);
					tf = new TextField();
					tf.name = "tf";
					tf.embedFonts = true;
					tf.autoSize = TextFieldAutoSize.LEFT;
					tf.selectable = false;
					tf.antiAliasType = AntiAliasType.ADVANCED;
					tf.mouseEnabled = false;
					if (bcArray[i].menuTitle != undefined) tf.text = bcArray[i].menuTitle;
					if (i == bcArray.length-1) bcTextFormat.color = breadcrumbSelectedFontColor;
					else bcTextFormat.color = breadcrumbFontColor;
					tf.setTextFormat(bcTextFormat);
					hitarea = new Shape();
					Geom.drawRectangle(hitarea, Math.ceil(tf.width), Math.ceil(tf.height), 0xFFFFFF, 0);
					item.addChild(hitarea);
					item.addChild(tf);
					item_xPos += item.width;
					if (i < bcArray.length-1) {
						item.buttonMode = true;
						item.addEventListener(MouseEvent.ROLL_OVER, bcItemListener);
						item.addEventListener(MouseEvent.ROLL_OUT, bcItemListener);
						item.addEventListener(MouseEvent.CLICK, bcItemListener);
						if (bcIconBmpData != null) {
							var w:uint = bcIconBmpData.width;
							var h:uint = bcIconBmpData.height;
							var bmp_matrix:Matrix = new Matrix(); 
							separator = new Sprite();
							with (separator.graphics) {
								beginBitmapFill(bcIconBmpData, bmp_matrix, true, false);
								lineTo(w, 0);
								lineTo(w, h);
								lineTo(0, h);
								lineTo(0, 0);
								endFill();
							}
							separator.x = item_xPos + Math.round(breadcrumbSpacing/2 - w/2);
							separator.y = breadcrumbIconTopPadding;
							if (!isNaN(breadcrumbIconColor)) {
								var separatorColor:ColorTransform = separator.transform.colorTransform;
								separatorColor.color = breadcrumbIconColor;
								separator.transform.colorTransform = separatorColor;
							}
							items_container.addChild(separator);
						}
					}
					item_xPos += breadcrumbSpacing;
				}
				breadcrumbs.x = templateWidth - contentPageRightMargin - Math.ceil(breadcrumbs.width);
				breadcrumbs.y = headerHeight + breadcrumbsTopMargin;
			}
		}
		
		private function bcItemListener(e:MouseEvent):void {
			var index:uint = e.currentTarget.name.substr(4)-1;
			var tf:TextField = e.currentTarget.getChildByName("tf");
			
			switch (e.type) {
				case "rollOver":
					Tweener.removeTweens(tf);
					Tweener.addTween(tf, {_color:breadcrumbOverFontColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
				break;
				case "rollOut":
					Tweener.removeTweens(tf);
					Tweener.addTween(tf, {_color:breadcrumbFontColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
				break;
				case "click":
					SWFAddress.setValue("/" + menuObj.getFullDeepLink(bcArray[index].deepLinkURL));
			}
		}
		
		private function capitalizeWords(str:String):String {
			var res_str:String = "";
			var str_array:Array = str.split(" ");
			for (var i=0; i<str_array.length; i++) {
				res_str += str_array[i].substr(0, 1).toUpperCase() + str_array[i].substr(1).toLowerCase();
				if (i < str_array.length-1) res_str += " ";
			}
			return res_str;
			
			// not used because doesn't recognize accents, umlauts etc.
			//var pattern:RegExp=/\b\S/g;
			//t = t.toLowerCase().replace(pattern, function($0){return $0.toUpperCase();});
		}

	/****************************************************************************************************/
	//	Function. Builds the template page. Called from the bgObj.changeHeaderBgImage() function.
		
		public function createPage():void {
			page.x = Math.floor(0.5*(stage.stageWidth-templateWidth));
			if (header_shadow.width > 0) header_shadow.x = -Math.round((header_shadow.width - stage.stageWidth)/2) - page.x;
			page_bg.alpha = 0;
			page_bg.y = headerHeight;
			if (!isNaN(contentPageBgColor) && !isNaN(contentPageBgAlpha)) {
				Geom.drawRectangle(page_bg, templateWidth, 2000, contentPageBgColor, contentPageBgAlpha);
			}
			Tweener.addTween(page_bg, {alpha:1, time:0.8, transition:"easeInOutQuint"});
			
			page_mask.addChild(pm1 = new Shape());
			page_mask.addChild(pm2 = new Shape());
			Geom.drawRectangle(pm1, stage.stageWidth, headerHeight+submenu_max_h+20, 0xFF9900, 0);
			Geom.drawRectangle(pm2, templateWidth+40, stage.stageHeight-footerHeight, 0xFF9900, 0);
			pm2.x = Math.floor(0.5*(stage.stageWidth-templateWidth)) - 20;
			page_mask.mouseEnabled = false;
			
			// Logo image loading
			if (logoURL != null) {
				var logoLoader:Loader = new Loader();
				logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, logoLoadComplete);
				logoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, logoLoadError);
				logoLoader.load(new URLRequest(logoURL+(killCachedFiles?killcache_str:'')));
			}
			
			// Breadcrumbs icon loading
			if (breadcrumbIconURL != null) {
				var bcIconLoader:Loader = new Loader();
				bcIconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bcIconLoadComplete);
				bcIconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bcIconLoadError);
				bcIconLoader.load(new URLRequest(breadcrumbIconURL+(killCachedFiles?killcache_str:'')));
			}
			
			// *** Page content
			header_add = Math.min((contentPageMaxTopMargin-contentPageMinTopMargin), Math.floor((stage.stageHeight-STAGE_MIN_HEIGHT)/2));
			page_content.y = page_content_mask.y = headerHeight + contentPageMinTopMargin + (stage.stageHeight>STAGE_MIN_HEIGHT?header_add:0);
			page_content_mask.y -= MASK_YPOS_SHIFT;
			
			var yOffset:uint = 2;
			title_tf = new TextField();
			title_tf.x = contentPageLeftMargin;
			title_tf.y = yOffset;
			title_tf.name = "title_tf";
			title_tf.embedFonts = true;
			title_tf.autoSize = TextFieldAutoSize.LEFT;
			title_tf.selectable = false;
			title_tf.antiAliasType = AntiAliasType.ADVANCED;
			title_tf.mouseEnabled = false;
			if (textStyleSheet != null) title_tf.styleSheet = textStyleSheet;
			title_tf.htmlText = "<h1>&nbsp;</h1>";
			page_title.addChild(title_tf);
			title_tf_height = Math.ceil(title_tf.height);
			
			Geom.drawRectangle(page_content_mask, templateWidth+40, stage.stageHeight-footerHeight-page_content_mask.y, 0xFF9900, 0);
			page_content_mask.x = -20;
			page_content_mask.height = 0;
			module_container.x = contentPageLeftMargin;
			// ***
			
			var test_tf:TextField = new TextField();
			test_tf = new TextField();
            test_tf.x = 0;
			test_tf.y = 0;
            test_tf.width = 400;
			test_tf.alpha = 0;
            addChild(test_tf);
			test_tf.mouseEnabled = false;
			test_tf.multiline = true;
			test_tf.autoSize = TextFieldAutoSize.LEFT;
			test_tf.textColor = 0xFFFFFF;
			test_tf.text = "Phlex Business Website Template, www.e-merald.com";
		}
		
		private function logoLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, logoLoadComplete);
			logo.alpha = 0;
			logo.addChild(e.target.content);
			if (logoAlign == "right") logo.x = templateWidth - logo.width - logoXOffset;
			else logo.x = logoXOffset;
			logo.y = logoYPosition;
			Tweener.addTween(logo, {alpha:1, time:0.8, transition:"easeInOutQuint"});
		}
		
		private function logoLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, logoLoadComplete);
		}
		
		private function logoClickListener(e:MouseEvent):void {
			if (!menu_blocked) SWFAddress.setValue("/");
		}
		
		private function bcIconLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, bcIconLoadComplete);
			var bmp:Bitmap = Bitmap(e.target.content);
			bcIconBmpData = bmp.bitmapData;
		}
		
		private function bcIconLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, bcIconLoadError);
		}
	
	/****************************************************************************************************/
	//	Function. Shows/hides the preloader.
	
		public function displayPreloader(val:Boolean):void {
			Tweener.removeTweens(preloader);
			if (val == true) Tweener.addTween(preloader, {alpha:1, time:0.3, transition:"easeInQuad"});
			if (val == false) Tweener.addTween(preloader, {alpha:0, time:0.3, transition:"easeInQuad"});
		}
	
	/****************************************************************************************************/
	// Function. SWFAddress handling.
		
		private function addressChangeListener(e:SWFAddressEvent):void {
			var pageTitle:String = websiteTitle ? websiteTitle : website_title;
			var deeplink:String = menuObj.correctDeepLink(e.value);
			var newpage_index:uint = 0;
			var error404_title:String = pageTitle;
			if (error404_index && pagesArray[error404_index].pageTitle != undefined) error404_title += " - " + pagesArray[error404_index].pageTitle;
			var deeplink_match:Boolean = false;
			var full_deeplink:Boolean = false;
			if (deeplink == "/home") SWFAddress.setValue("/");
			else if (deeplink != e.value) SWFAddress.setValue(deeplink);
			else{
				if (e.pathNames.length > 0) {
					if (deeplink.substr(1) == menuObj.getFullDeepLink(e.pathNames[e.pathNames.length-1])) full_deeplink = true;
					for (var n=0; n<e.pathNames.length; n++) {
						deeplink_match = false;
						for (var i=0; i<pagesArray.length; i++) {
							if (pagesArray[i].deepLinkURL == e.pathNames[n] && full_deeplink) {
								newpage_index = i;
								if (pagesArray[i].pageTitle != undefined) pageTitle += " - " + pagesArray[i].pageTitle;
								else if (pagesArray[i].menuTitle != undefined) pageTitle += " - " + pagesArray[i].menuTitle;
								deeplink_match = true;
								break;
							}
							if (i == pagesArray.length-1 && !deeplink_match) {
								if (error404_index) {
									SWFAddress.setTitle(error404_title);
									gotoNewAddress(error404_index);
								} else {
									SWFAddress.setTitle(websiteTitle?websiteTitle:website_title);
									gotoNewAddress(homepage_index);
								}
								break;
							}
						}
						if (deeplink_match == false) break;
					}
				} else if (deeplink == "/") {
					newpage_index = homepage_index;
					deeplink_match = true;
				}
				if (deeplink_match) {
					if (pagesArray[newpage_index].moduleURL == undefined && pagesArray[newpage_index].hasChild) {
						for (var k=0; k<pagesArray.length; k++) {
							if (pagesArray[k].parentIndex == newpage_index) {
								newpage_index = k;
								break;
							}
						}
					}
					SWFAddress.setTitle(pageTitle);
					gotoNewAddress(newpage_index);
				}
			}
		}
	
	/****************************************************************************************************/
	//	Function. Initiates a number of actions for navigating to a new deep linking address (new website page).
		
		private function gotoNewAddress(index:uint):void {
			if (index != currentIndex || menu_initialized == false) { // "menu_initialized == false" - on the first call of the function
				menu_blocked = true;
				setCurrentIndex(index);
				menuObj.setSelectedItem(menu, currentIndex);
				closeCurrentPage();
			}
		}
		
	/****************************************************************************************************/
	//	Function. Sets the value of the current index.
		
		private function setCurrentIndex(index:uint):void {
			currentIndex = index;
			if (pagesArray[currentIndex].deepLinkURL == "home" || pagesArray[currentIndex].deepLinkURL == "home-alt") home = true;
			else home = false;
		}
		
	/****************************************************************************************************/
	//	Function. Opens the new selected page. Called from the xmlDataProcessing() function of the currently loaded module.
		
		public function openNewPage():void {
			
			menu_blocked = true;
			
			createBreadCrumbs();
			Tweener.removeTweens(breadcrumbs);
			Tweener.addTween(breadcrumbs, {alpha:1, time:0.8*ANIMATION_DURATION, transition:"easeInOutQuad"});
			
			if (textStyleSheet != null) title_tf.styleSheet = textStyleSheet;
			if (home || pagesArray[currentIndex].pageTitle == undefined) title_tf.htmlText = "<h1>&nbsp;</h1>";
			else title_tf.htmlText = "<h1>" + pagesArray[currentIndex].pageTitle + "</h1>";
			
			page_content_mask.height = 0;
			module_container.alpha = title_tf.alpha = 0;
			Tweener.removeTweens(page_content_mask);
			Tweener.removeTweens(module_container);
			Tweener.removeTweens(title_tf);
			Tweener.addTween(page_content_mask, {height:stage.stageHeight-footerHeight-page_content.y+MASK_YPOS_SHIFT, time:0.8*ANIMATION_DURATION, transition:"easeInOutSine", onComplete:pageContentOpened});
			Tweener.addTween(module_container, {alpha:1, time:0.8*ANIMATION_DURATION, transition:"easeInOutQuad"});
			Tweener.addTween(title_tf, {alpha:1, time:0.5*ANIMATION_DURATION, transition:"easeInOutQuint"});
			tween_status = "opening";
		}
		
		private function pageContentOpened():void {
			if (bgObj.loading_in_bg_mode == true) {
				bgObj.loading_in_bg_mode = false;
				bgObj.loadBodyBgImgs(); // calls the function that starts loading body background images one by one (in background mode)
			}
			tween_status = null;
			menu_blocked = false;
			if (!home) {
				logo.buttonMode = true;
				logo.addEventListener(MouseEvent.CLICK, logoClickListener);
			} else {
				logo.buttonMode = false;
				logo.removeEventListener(MouseEvent.CLICK, logoClickListener);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Loads an SWF module. Called from the bgObj.changeHeaderBgImage() function.
	
		public function loadModule(page_index:uint):void {
			if (currentIndex != page_index) {
				setCurrentIndex(page_index);
				menuObj.setSelectedItem(menu, currentIndex);
				var deeplink:String = pagesArray[currentIndex].deepLinkURL;
				SWFAddress.setValue("/" + deeplink);
			}
			
			// *** This performs only on the first call of the function
			if (!menu_initialized) {
				menuObj.initiateMenu(menu);
				menu_initialized = true;
				if (pagesArray[currentIndex].moduleURL != undefined) {
					moduleLoader.load(new URLRequest(pagesArray[currentIndex].moduleURL+(killCachedFiles?killcache_str:'')));
					if (showPreloader) displayPreloader(true);
				} else {
					menu_blocked = false;
				}
				if (showPreloader && preloaderAlpha > 0) {
					var tf:TextField = preloader.getChildByName("tf") as TextField;
					tf.visible = false;
				}
			}
			// ***
			
			else {
				if (pagesArray[currentIndex].moduleURL != undefined) {
					moduleLoader.load(new URLRequest(pagesArray[currentIndex].moduleURL+(killCachedFiles?killcache_str:'')));
					if (showPreloader) displayPreloader(true);
				} else {
					menu_blocked = false;
				}
			}
		}
		
		private function moduleLoadComplete(e:Event):void {
			if (showPreloader && preloader.alpha > 0) displayPreloader(false);
			if (home) module_container.y = 0;
			else module_container.y = title_tf_height + PAGE_TOP_MARGIN;
			module_container.addChild(e.target.content);
			// launches the initiate() function in the module that is currently added to the Stage
			e.target.content.initiate(this, pagesArray[currentIndex].moduleXML, killCachedFiles, textStyleSheet);
			menu_blocked = false;
		}
		
		private function moduleLoadError(e:IOErrorEvent):void {
			if (showPreloader && preloader.alpha > 0) displayPreloader(false);
			menu_blocked = false;
		}
	
	/****************************************************************************************************/
	//	Function. Closes the currently opened page.
		
		private function closeCurrentPage():void {
			Tweener.removeTweens(breadcrumbs);
			Tweener.addTween(breadcrumbs, {alpha:0, time:0.8*ANIMATION_DURATION, transition:"easeInOutQuad"});
			bcArray = null;
			if (module_container.numChildren) {
				Tweener.removeTweens(page_content_mask);
				Tweener.removeTweens(module_container);
				Tweener.removeTweens(title_tf);
				Tweener.addTween(page_content_mask, {height:0, time:0.8*ANIMATION_DURATION, transition:"easeInOutSine", onComplete:pageContentClosed});
				Tweener.addTween(module_container, {alpha:0, time:0.8*ANIMATION_DURATION, transition:"easeInOutQuad"});
				Tweener.addTween(title_tf, {alpha:0, time:0.5*ANIMATION_DURATION, transition:"easeInOutQuint"});
				tween_status = "closing";
			} else {
				bgObj.loadBodyBgImage(currentIndex);	// starts loading a header background image for the selected page.
				menu_blocked = false;
			}
		}
		
		private function pageContentClosed():void {
			tween_status = null;
			if (module_container.numChildren) {
				for (var i=0; i<module_container.numChildren; i++) {
					var moduleObj:* = module_container.getChildAt(i);
					moduleObj.killModule();
				}
				try { moduleLoader.close(); }
				catch(error:Error){};
				moduleLoader.unloadAndStop();
				moduleLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, moduleLoadComplete);
				moduleLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, moduleLoadError);
				for (var j=0; j<module_container.numChildren; j++) { module_container.removeChildAt(j); }
			}
			page_content.removeChild(module_container);
			module_container = null;
			page_content.addChild(module_container = new Sprite());
			module_container.x = contentPageLeftMargin;
			moduleLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, moduleLoadComplete);
			moduleLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, moduleLoadError);
			
			bgObj.loadBodyBgImage(currentIndex);		// starts loading a header background image for the selected page.
			menu_blocked = false;
		}
		
	/****************************************************************************************************/
	//	Function. Catches input/output errors.
		
		private function catchError(event:IOErrorEvent):void {}
	
	/****************************************************************************************************/
	}
}