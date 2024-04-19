/**
	News class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.news {
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextLineMetrics;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.ui.Keyboard;
	import com.emerald.phlex.videoplayer.VideoPlayer;
	import com.emerald.phlex.videoplayer.VideoPlayerYouTube;
	import com.emerald.phlex.utils.Geom;
	import com.emerald.phlex.utils.Image;
	import com.emerald.phlex.utils.Scroller;
	import com.emerald.phlex.utils.Utils;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import caurina.transitions.*;
	import caurina.transitions.properties.ColorShortcuts;

	public class News extends Sprite {
		
		public var main:Sprite, menu:Sprite, controls:Sprite, previews:Sprite, article:Sprite, videoplayer:Sprite;
		public var currentCategoryIndex:uint = 0;
		public var currentArticleIndex:Number;
		public var categoriesArray:Array, newsArray:Array;
		public var __root:*;
		public var controls_blocked:Boolean = false;
		public var menu_blocked:Boolean = false;
		
		private var xml_URL:String;
		private var xmlLoader:URLLoader;
		private var dataXML:XML;
		private var XMLParserObj:Object, menuObj:Object, scrollerObj:Object, vpObj:Object;
		private var scrollerObj1:Object, scrollerObj2:Object, scrollerObj3:Object, scrollerObj4:Object, scrollerObj5:Object, scrollerObj6:Object, scrollerObj7:Object, scrollerObj8:Object;
		private var imageLoader1:Loader, imageLoader2:Loader, imageLoader3:Loader, imageLoader4:Loader, imageLoader5:Loader, imageLoader6:Loader, imageLoader7:Loader, imageLoader8:Loader;
		private var previewImgsLoader:Loader, bigImageLoader:Loader;
		private var killcache_str:String;
		private var killCachedFiles:Boolean = false;
		private var textStyleSheet:StyleSheet;
		private var currentPreviewImgIndex:uint;
		private var current_page:uint;
		private var blocks_xPos:uint, blocks_yPos:uint, block_yPos:uint;
		private var preview_width:uint, preview_height:uint;
		
		// -- single item area
		public var currentFsImageIndex:Number;
		public var fullscreen_bg:Shape;
		public var fsimg:Sprite;
		private static const BUTTONS_XOFFSET:uint = 16;
		private static const BUTTONS_YOFFSET:uint = 10;
		private static const BIG_IMAGE_YOFFSET:uint = 0;
		private static const FS_FADE_DURATION:Number = 0.4;
		// --
		
		private static const FADE_DURATION:Number = 0.7;
		private static const ON_ROLL_DURATION:Number = 0.3;
		private static const BUTTON_SPACING:uint = 5;
		private static const TEXT_LEADING:uint = 6;
		private static const PREVIEW_BLIND_DURATION:Number = 0.5;
		private static const NAV_BUTTON_ICON_PADDING:uint = 6;
		
		// Category menu properties
		public var showCategoryMenu:Boolean = true;
		public var categoryMenuYPosition:uint = 0;
		public var categorySpacing:uint = 30;
		public var categoryFont:String = "Arial";
		public var categoryFontSize:uint = 13;
		public var categoryFontWeight:String = "bold";
		public var categoryFontColor:uint = 0x666666;
		public var categoryOverFontColor:uint = 0x333333;
		public var categorySelectedFontColor:uint = 0x577C95;
		
		// Previews properties
		public var previewsControlsYPosition:int = 0;
		public var previewsControlsRightMargin:uint = 0;
		public var previewsNavButtonColor:uint = 0x888888;
		public var previewsNavButtonSelectedColor:uint = 0xE77927;
		
		public var previewsInRow:uint = 3;
		public var previewsTopMargin:uint = 0;
		public var previewsLeftMargin:uint = 0;
		public var previewImageWidth:uint = 300;
		public var previewImageHeight:uint = 163;
		public var previewSpacing:uint = 30;
		
		public var previewImageBgColor:Number;
		public var previewImageBgAlpha:Number;
		public var previewImageBorderColor:Number;
		public var previewImageBorderThickness:uint;
		public var previewImageShadowColor:Number;
		public var previewImageShadowAlpha:Number;
		public var previewImagePadding:uint = 0;
		public var previewImagePreloaderColor:Number;
		public var previewImagePreloaderAlpha:Number;
		public var previewImageOverBrightness:Number = 0;
		public var previewImageBottomMargin:uint = 0;
		
		public var previewTitleBottomPadding:uint = 0;
		public var previewDateBottomPadding:uint = 0;
		public var previewDateBgColor:Number;
		public var previewDateBgAlpha:Number;
		
		// Single article controls properties
		public var showSingleArticle:Boolean = true;
		public var singleArticleYPosition:uint = 0;
		public var articleHeaderHeight:uint = 0;
		public var articleControlsRightMargin:uint = 0;
		public var articleListButtonURL:String;
		public var articleLeftNavButtonURL:String;
		public var articleRightNavButtonURL:String;
		public var articleNavButtonSpacing:uint = 6;
		public var articleButtonColor:uint = 0x999999;
		public var articleButtonOverColor:uint = 0x555555;
		public var articleControlsSeparatorURL:String;
		public var articleControlsSeparatorColor:uint = 0xCCCCCC;
		public var articleTitleTopMargin:uint = 0;
		public var articleDateTopMargin:uint = 0;
		public var articleContentTopMargin:uint = 0;
		
		// Single article big image properties
		public var showArticleMedia:Boolean = true;
		public var bigImageAreaWidth:uint = 480;
		public var bigImageAreaRightMargin:uint = 0;
		public var bigImageBgColor:Number;
		public var bigImageBgAlpha:Number;
		public var bigImageBorderColor:Number;
		public var bigImageBorderThickness:uint;
		public var bigImagePadding:uint = 0;
		public var bigImagePreloaderColor:Number;
		public var bigImagePreloaderAlpha:Number;
		public var bigImageOverBrightness:Number = 0;
		public var bigImageZoomIconColor:uint = 0x000000;
		public var bigImageZoomIconAlpha:Number = 0;
		public var bigImageZoomIconOverAlpha:Number = 0;
		
		// Single item view properties
		public var overlayBgColor:Number = 0x000000;
		public var overlayBgAlpha:Number = 0.9;
		public var controlsBarBgColor:Number = 0x000000;
		public var controlsBarBgAlpha:Number = 0.5;
		public var buttonIconColor:uint = 0x333333;
		public var buttonIconOverColor:uint = 0xFFFFFF;
		public var buttonBgColor:uint = 0xFEFEFE;
		public var buttonBgOverColor:uint = 0x999999;
		
		// Single article video properties
		public var videoPlayerWidth:Number;
		public var videoPlayerHeight:Number;
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
		
		// Single article description properties
		public var listItemMarkerURL:String;
		public var listItemMarkerTopPadding:uint = 0;
		public var listItemLeftPadding:uint = 0;
		public var listItemBottomPadding:uint = 0;
		public var scrollBarTrackWidth:uint;
		public var scrollBarTrackColor:Number;
		public var scrollBarTrackAlpha:Number = 1;
		public var scrollBarSliderOverWidth:uint;
		public var scrollBarSliderColor:uint = 0xB5B5B5;
		public var scrollBarSliderOverColor:Number;
		
		// Image Shadow
		private var imageShadowBlur:uint = 16;
		private var imageShadowStrength:uint = 1;
		private var imageShadowQuality:uint = 2;
		
		// Video Player Shadow
		public var videoPlayerShadowBlur:uint = 16;
		public var videoPlayerShadowStrength:uint = 1;
		public var videoPlayerShadowQuality:uint = 2;
		
		ColorShortcuts.init();	// initiates the ColorShortcuts special properties of the Tweener class
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function News():void {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addChild(main = new Sprite());
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the News object is added to the Stage.
	
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the SWF file is resized.
		
		private function onStageResized(e:Event):void {
			if (scrollerObj != null) {
				var blocks:Sprite = article.getChildByName("blocks") as Sprite;
				blocks.y = blocks_yPos;
				var mask_h:uint = stage.stageHeight - __root.page_content.y - __root.module_container.y - article.y - blocks_yPos - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
				scrollerObj.onStageResized(mask_h);
			}
			
			// -- single item area
			if (__root != null) resizeSingleItemArea();
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
			categoriesArray = XMLParserObj.categoryNodesParser(dataXML); // processing "category" nodes
			if (categoriesArray.length > 1) currentCategoryIndex = categoriesArray.length - 1;
			if (showCategoryMenu && categoriesArray.length > 1) {
				main.addChild(menu = new Sprite());
				menuObj = new Menu(this, textStyleSheet);
			}
			createArticleArea();
			if (__root != null) createSingleItemArea();
			createPreviewItems(currentCategoryIndex);
			if (__root != null) __root.openNewPage(); // calls the openNewPage() function of the WebsiteTemplate class
		}
		
		private function xmlDataError(e:IOErrorEvent):void {
			xmlLoader.removeEventListener(Event.COMPLETE, xmlDataProcessing);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlDataError);
		}
		
	/****************************************************************************************************/
	//	Function. Builds news items previews.
	
		public function createPreviewItems(category_index:uint):void {
			newsArray = XMLParserObj.categoryNodeParser(dataXML.category[category_index]); // processing a "category" node
			newsArray.reverse();
			
			if (previewsInRow > 0) {
				current_page = 1;
				currentArticleIndex = NaN;
				loadPreviewImgs();
				createPreviewsControls();
				if (previews == null) {
					main.addChild(previews = new Sprite());
					previews.x = previewsLeftMargin;
					previews.y = previewsControlsYPosition + Math.ceil(controls.height) + previewsTopMargin;
				}
				controls_blocked = false;
				
				var border_thickness:uint = 0;
				if (!isNaN(previewImageBorderColor) && previewImageBorderThickness > 0) border_thickness = previewImageBorderThickness;
				preview_width = previewImageWidth + 2*previewImagePadding + 2*border_thickness;
				preview_height = previewImageHeight + 2*previewImagePadding + 2*border_thickness;
				
				if (previews.numChildren == 0) {
					
					var container_xPos:uint = 0;
					var base:Shape, shadow_base:Shape, bg:Shape, mask1:Shape, mask2:Shape, mask3:Shape, mask4:Shape, middle_hitarea:Shape;
					var container:Sprite, img:Sprite, title:Sprite, dt:Sprite, txt:Sprite, hitarea:Sprite;
					var tf:TextField;
					if (!isNaN(previewImageShadowColor) && !isNaN(previewImageBgAlpha)) {
						var df:DropShadowFilter = new DropShadowFilter();
						df.color = previewImageShadowColor;
						df.alpha = previewImageShadowAlpha;
						df.distance = 0;
						df.angle = 0;
						df.quality = imageShadowQuality;
						df.blurX = df.blurY = imageShadowBlur;
						df.strength = imageShadowStrength;
						df.knockout = true;
						var dfArray:Array = new Array();
						dfArray.push(df);
					}
					
					for (var i=1; i<=previewsInRow; i++) {
						container = new Sprite();
						container.name = "container"+i;
						container.x = container_xPos;
						previews.addChild(container);
						if (showSingleArticle) {
							container.addEventListener(MouseEvent.CLICK, previewImageClickListener);
							container.buttonMode = true;
						}
						container.addChild(middle_hitarea = new Shape());
						middle_hitarea.name = "middle_hitarea"; // this is for making the whole container area solid and mouse enabled
						middle_hitarea.y = preview_height;
						container.addChild(shadow_base = new Shape());
						shadow_base.name = "shadow_base";
						container.addChild(mask1 = new Shape());
						mask1.name = "mask1";
						shadow_base.mask = mask1;
						container.addChild(bg = new Shape());
						bg.name = "bg";
						container.addChild(mask2 = new Shape());
						mask2.name = "mask2";
						bg.mask = mask2;
						hitarea = new Sprite();
						container.addChild(hitarea);
						hitarea.mouseEnabled = false;
						container.addChild(img = new Sprite());
						img.name = "img";
						img.hitArea = hitarea;
						container.addChild(mask3 = new Shape());
						mask3.name = "mask3";
						img.mask = mask3;
						container.addChild(base = new Shape());
						base.name = "base";
						container.addChild(mask4 = new Shape());
						mask4.name = "mask4";
						base.mask = mask4;
						
						if (!isNaN(previewImageBgColor) && !isNaN(previewImageBgAlpha)) {
							Geom.drawRectangle(bg, previewImageWidth+2*previewImagePadding, previewImageHeight+2*previewImagePadding, previewImageBgColor, previewImageBgAlpha);
						}
						if (!isNaN(previewImageShadowColor) && !isNaN(previewImageShadowAlpha)) {
							Geom.drawRectangle(shadow_base, preview_width, preview_height, 0xFFFFFF, 1);
							shadow_base.filters = dfArray;
						}
						if (!isNaN(previewImageBorderColor) && previewImageBorderThickness > 0) {
							Geom.drawBorder(base, previewImageWidth, previewImageHeight, previewImageBorderColor, 1, previewImageBorderThickness, previewImagePadding);
						}
						Geom.drawRectangle(hitarea, preview_width, preview_height, 0xFF9900, 0);
						
						bg.x = bg.y = border_thickness;
						img.x = img.y = base.x = base.y = border_thickness + previewImagePadding;
						
						Geom.drawRectangle(mask1, preview_width+40, preview_height+40, 0xFF9980, 0, 0, 0, 0, 0, -20, -20);
						Geom.drawRectangle(mask2, preview_width+40, preview_height+40, 0xFF9900, 0, 0, 0, 0, 0, -20, -20);
						Geom.drawRectangle(mask3, preview_width+40, preview_height+40, 0xFF9900, 0, 0, 0, 0, 0, -20, -20);
						Geom.drawRectangle(mask4, preview_width+40, preview_height+40, 0xFF9900, 0, 0, 0, 0, 0, -20, -20);
						
						// Title
						container.addChild(title = new Sprite());
						title.name = "title";
						title.y = preview_height + previewImageBottomMargin;
						tf = new TextField();
						tf.name = "tf";
						title.addChild(tf);
						if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
						tf.width = preview_width;
						tf.autoSize = TextFieldAutoSize.LEFT;
						tf.multiline = true;
						tf.wordWrap = true;
						tf.embedFonts = true;
						tf.selectable = true;
						tf.antiAliasType = AntiAliasType.ADVANCED;
						if (showSingleArticle) tf.mouseEnabled = false;
						
						// Date
						container.addChild(dt = new Sprite());
						dt.name = "dt";
						var tf_bg:Shape = new Shape();
						tf_bg.name = "tf_bg";
						dt.addChild(tf_bg);
						tf = new TextField();
						tf.name = "tf";
						dt.addChild(tf);
						if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
						tf.autoSize = TextFieldAutoSize.LEFT;
						tf.multiline = false;
						tf.wordWrap = false;
						tf.embedFonts = true;
						tf.selectable = true;
						tf.antiAliasType = AntiAliasType.ADVANCED;
						if (showSingleArticle) tf.mouseEnabled = false;
						
						// Text
						container.addChild(txt = new Sprite());
						txt.name = "txt";
						tf = new TextField();
						tf.name = "tf";
						txt.addChild(tf);
						if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
						tf.width = preview_width;
						tf.width -= 10; // increase the spacing between the right edge of a text field and the scroll bar
						tf.autoSize = TextFieldAutoSize.LEFT;
						tf.multiline = true;
						tf.wordWrap = true;
						tf.embedFonts = true;
						tf.selectable = true;
						tf.antiAliasType = AntiAliasType.ADVANCED;
						if (showSingleArticle) tf.mouseEnabled = false;
						tf.mouseWheelEnabled = false;
						
						container_xPos += preview_width + previewSpacing;
						this["imageLoader"+i] = new Loader();
					}
				}
				changePreviews(current_page);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Changes news items previews (currently visible).
	
		private function changePreviews(page:uint):void {
			
			// *** Changing selected buttons
			if (controls) {
				for (var j=1; j<=Math.ceil(newsArray.length/previewsInRow); j++) {
					var nav_but:MovieClip = controls.getChildByName("nav_but"+j) as MovieClip;
					Tweener.removeTweens(nav_but);
					if (j == page) {
						nav_but.stop();
						if (nav_but.currentFrame <= 3 || (nav_but.currentFrame >= 9 && nav_but.currentFrame <=11)) {
							nav_but.gotoAndPlay(12);
						} else if (nav_but.currentFrame >= 4 && nav_but.currentFrame <= 8) {
							nav_but.gotoAndPlay(16);
						}
						Tweener.addTween(nav_but, {_color:previewsNavButtonSelectedColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					} else {
						if (nav_but.currentFrame == 16) nav_but.gotoAndPlay(22);
						else if (nav_but.currentFrame == 22) nav_but.play();
						if (nav_but.currentFrame == 16 || nav_but.currentFrame == 22) {
							Tweener.addTween(nav_but, {_color:previewsNavButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
						}
					}
				}
				Tweener.addTween(controls, {delay:ON_ROLL_DURATION, onComplete:function(){controls_blocked = false;}});
			}
			
			// *** Changing images and text
			for (var i=1; i<=previewsInRow; i++) {
				var index:uint = (page-1)*previewsInRow + (i-1);
				var container:Sprite = previews.getChildByName("container"+i) as Sprite;
				var img:Sprite = container.getChildByName("img") as Sprite;
				var title:Sprite = container.getChildByName("title") as Sprite;
				var dt:Sprite = container.getChildByName("dt") as Sprite;
				var txt:Sprite = container.getChildByName("txt") as Sprite;
				var preloader:MovieClip;
				Tweener.removeTweens(container);
				Tweener.removeTweens(img);
				Tweener.removeTweens(title);
				Tweener.removeTweens(dt);
				Tweener.removeTweens(txt);
				img.graphics.clear();
				img.alpha = title.alpha = dt.alpha = txt.alpha = 0;
				if (container.getChildByName("preloader")) {
					preloader = container.getChildByName("preloader") as MovieClip;
					Tweener.removeTweens(preloader);
					container.removeChild(preloader);
				}
				var imageLoader:Loader = this["imageLoader"+i];
				imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, previewImageLoadComplete);
				imageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, previewImageLoadError);
				try { imageLoader.close(); }
				catch(error:Error){};
				imageLoader.unload();
				
				if (index < newsArray.length) {
					container.visible = true;
					if (newsArray[index].previewBmpData == undefined) {
						if (newsArray[index].previewImgSrc != undefined) {
							if (!isNaN(previewImagePreloaderColor) && !isNaN(previewImagePreloaderAlpha)) {
								preloader = new img_preloader();
								preloader.name = "preloader";
								container.addChild(preloader);
								preloader.x = Math.round((preview_width-preloader.width)/2);
								preloader.y = Math.round((preview_height-preloader.height)/2);
								var preloaderColor:ColorTransform = preloader.transform.colorTransform;
								preloaderColor.color = previewImagePreloaderColor;
								preloader.transform.colorTransform = preloaderColor;
								preloader.alpha = previewImagePreloaderAlpha;
							}
							imageLoader.name = "imageLoader_"+index+"_"+i;
							imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, previewImageLoadComplete);
							imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, previewImageLoadError);
							imageLoader.load(new URLRequest(newsArray[index].previewImgSrc+(killCachedFiles?killcache_str:'')));
						} else {
							newsArray[index].previewBmpData = "no";
						}
					} else {
						drawPreviewImage(container, newsArray[index].previewBmpData, index);
					}
					drawText(container, index);
				} else {
					container.visible = false;
				}
			}
		}
		
	/****************************************************************************************************/
	//	Functions. Handles events on loading of preview images of news items.
		
		private function previewImageLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, previewImageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, previewImageLoadError);
			var index_arr:Array = e.target.loader.name.split("_");
			var index:uint = index_arr[1];
			var container_index:uint = index_arr[2];
			var container:Sprite = previews.getChildByName("container"+container_index) as Sprite;
			if (container.visible == true) {
				var preloader:MovieClip = container.getChildByName("preloader") as MovieClip;
				if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.7*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[container, preloader]});
				var bmp:Bitmap = Bitmap(e.target.content);
				bmp.smoothing = true;
				var bmpData:BitmapData = bmp.bitmapData;
				if (newsArray[index].previewBmpData == undefined) newsArray[index].previewBmpData = bmpData;
				drawPreviewImage(container, bmpData, index);
			}
		}
		
		private function previewImageLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, previewImageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, previewImageLoadError);
			var index_arr:Array = e.target.loader.name.split("_");
			var index:uint = index_arr[1];
			var container_index:uint = index_arr[2];
			var container:Sprite = previews.getChildByName("container"+container_index) as Sprite;
			if (container.visible == true) {
				if (newsArray[index].previewBmpData == undefined) newsArray[index].previewBmpData = "no";
				var preloader:MovieClip = container.getChildByName("preloader") as MovieClip;
				if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.7*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[container, preloader]});
			}
		}
		
		
	/****************************************************************************************************/
	//	Function. Removes an image preloader.
		
		private function removeImagePreloader(container:Sprite, preloader:MovieClip):void {
			container.removeChild(preloader);
			preloader = null;
		}
		
	/****************************************************************************************************/
	//	Function. Draws a preview image on a specified container.
		
		private function drawPreviewImage(container:Sprite, bmpData:*, index:uint):void {
			var img:Sprite = container.getChildByName("img") as Sprite;
			if (bmpData != "no") {
				var bmp_matrix:Matrix = new Matrix();
				if (bmpData.width != previewImageWidth || bmpData.height != previewImageHeight) {
					var sx:Number = previewImageWidth/bmpData.width;
					var sy:Number = previewImageHeight/bmpData.height;
					bmp_matrix.scale(Math.max(sx,sy), Math.max(sx,sy));
					if (sy > sx) bmp_matrix.tx = -0.5*(bmpData.width*sy-previewImageWidth);
					if (sx > sy) bmp_matrix.ty = -0.5*(bmpData.height*sx-previewImageHeight);
				}
				with (img.graphics) {
					beginBitmapFill(bmpData, bmp_matrix, true, true);
					lineTo(previewImageWidth, 0);
					lineTo(previewImageWidth, previewImageHeight);
					lineTo(0, previewImageHeight);
					lineTo(0, 0);
					endFill();
				}
				Tweener.addTween(img, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
			}
			if (showSingleArticle) {
				if (!container.hasEventListener(MouseEvent.ROLL_OVER)) {
					if (previewImageOverBrightness != 0) Image.applyBrightnessToChild(container, previewImageOverBrightness, 0.6, "img");
				}
			} else {
				if (!img.hasEventListener(MouseEvent.ROLL_OVER)) {
					if (previewImageOverBrightness != 0) Image.applyBrightness(img, previewImageOverBrightness);
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Creates text content on a specified container.
		
		private function drawText(container:Sprite, index:uint):void {
			var container_index:uint = uint(container.name.substr(9));
			var title:Sprite = container.getChildByName("title") as Sprite;
			var tf1:TextField = title.getChildByName("tf") as TextField;
			var dt:Sprite = container.getChildByName("dt") as Sprite;
			var tf2:TextField = dt.getChildByName("tf") as TextField;
			var tf_bg:Shape = dt.getChildByName("tf_bg") as Shape;
			var txt:Sprite = container.getChildByName("txt") as Sprite;
			var tf3:TextField = txt.getChildByName("tf") as TextField;
			var middle_hitarea:Shape = container.getChildByName("middle_hitarea") as Shape;
			
			if (container.getChildByName("txt") != null) {
				// Destroy scroller
				if (this["scrollerObj"+container_index]) {
					this["scrollerObj"+container_index].destroyScroller();
					this["scrollerObj"+container_index] = null;
				}
			}
			
			if (newsArray[index].previewTitle != undefined) tf1.htmlText = newsArray[index].previewTitle;
			else tf1.htmlText = "";
			if (newsArray[index].previewDate != undefined) tf2.htmlText = newsArray[index].previewDate;
			else tf2.htmlText = "";
			tf_bg.graphics.clear();
			if (!isNaN(previewDateBgColor) && !isNaN(previewDateBgAlpha)) {
				Geom.drawRectangle(tf_bg, dt.width+4, dt.height, previewDateBgColor, previewDateBgAlpha);
				tf2.x = 2;
			}
			tf3.autoSize = TextFieldAutoSize.LEFT;
			if (newsArray[index].previewText != undefined) {
				tf3.htmlText = newsArray[index].previewText;
				tf3.height += TEXT_LEADING; // disables TextField scrolling on selection (also is a workaround for "jumpy htmlText hyperlinks")
				tf3.autoSize = TextFieldAutoSize.NONE;
			}
			else tf3.htmlText = "";
			
			dt.y = title.y + (tf1.htmlText != ""?Math.ceil(title.height)+previewTitleBottomPadding:0);
			var txt_yPos:uint = dt.y + (tf2.htmlText != ""?Math.ceil(dt.height)+previewDateBottomPadding:0);
			txt.y = txt_yPos;
			middle_hitarea.graphics.clear();
			Geom.drawRectangle(middle_hitarea, preview_width, txt_yPos-preview_height, 0xFF9900, 0);
			attachScroller1(txt, txt_yPos, index); // attach a scroller to the preview text
			
			Tweener.addTween(title, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
			Tweener.addTween(dt, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
			Tweener.addTween(txt, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
			if (container.getChildByName("scrollbar") != null) {
				var scrollbar:Sprite = container.getChildByName("scrollbar") as Sprite;
				if (scrollbar.visible == true) {
					scrollbar.alpha = 0;
					Tweener.addTween(scrollbar, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
				}
			}
		}
	
	/****************************************************************************************************/
	//	Function. Attaches a scroller to the preview text.
		
		private function attachScroller1(txt:Sprite, txt_yPos:uint, index:uint):void {
			var container_index:uint = uint(txt.parent.name.substr(9));
			var hitarea:Sprite;
			if (txt.getChildByName("hitarea")) {
				hitarea = txt.getChildByName("hitarea") as Sprite;
				hitarea.graphics.clear();
			} else {
				txt.addChild(hitarea = new Sprite());
				hitarea.name = "hitarea";
				txt.hitArea = hitarea;
				hitarea.mouseEnabled = false;
			}
			var mask_w:uint = preview_width;
			if (__root != null) {
				var mask_h:uint = stage.stageHeight - __root.page_content.y - __root.module_container.y - previews.y - txt.y - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
				Geom.drawRectangle(hitarea, mask_w, txt.height, 0xFF9900, 0);
				this["scrollerObj"+container_index] = new Scroller(txt,
										  							mask_w,
																	mask_h,
																	scrollBarTrackWidth,
																	scrollBarTrackColor,
																	scrollBarTrackAlpha,
																	scrollBarSliderOverWidth,
																	scrollBarSliderColor,
																	scrollBarSliderOverColor);
				stage.addEventListener(Event.RESIZE,
					function(e:Event) {
						if (main != null) {
							txt.y = txt_yPos;
							mask_h = stage.stageHeight - __root.page_content.y - __root.module_container.y - previews.y - txt.y - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
							main.parent["scrollerObj"+container_index].onStageResized(mask_h);
						}
					}
				);
			} else {
				Geom.drawRectangle(hitarea, mask_w, txt.height, 0xFF9900, 0);
				this["scrollerObj"+container_index] = new Scroller(txt, mask_w, 150, scrollBarTrackWidth, scrollBarTrackColor, scrollBarTrackAlpha, scrollBarSliderOverWidth, scrollBarSliderColor, scrollBarSliderOverColor);
			}
		}

	/****************************************************************************************************/
	//	Function. Builds the controls (navigation buttons) of news previews.
		
		private function createPreviewsControls():void {
			if (controls != null) {
				main.removeChild(controls);
				controls = null;
			}
			main.addChild(controls = new Sprite());
			controls.name = "controls";
			controls.y = previewsControlsYPosition;
			controls.alpha = 0;
			var controls_xPos:uint;
			var button_xPos:uint = 0;
			
			for (var i=1; i<=Math.ceil(newsArray.length/previewsInRow); i++) {
				var nav_but:MovieClip = new nav_button();
				nav_but.name = "nav_but"+i;
				nav_but.x = button_xPos;
				nav_but.buttonMode = true;
				var navButColor:ColorTransform = nav_but.transform.colorTransform;
				navButColor.color = previewsNavButtonColor;
				nav_but.transform.colorTransform = navButColor;
				controls.addChild(nav_but);
				button_xPos += Math.ceil(nav_but.width) + BUTTON_SPACING;
				
				nav_but.addEventListener(MouseEvent.ROLL_OVER,
					function(e:MouseEvent) {
						var page:uint = e.target.name.substr(7);
						var nav_but:MovieClip = e.target as MovieClip;
						if (page != current_page && !controls_blocked) {
							nav_but.stop();
							if (nav_but.currentFrame < 6) nav_but.play();
							if (nav_but.currentFrame > 6 && nav_but.currentFrame <= 11) {
								nav_but.gotoAndPlay(12-nav_but.currentFrame);
							}
						}
					}
				);
				nav_but.addEventListener(MouseEvent.ROLL_OUT,
					function(e:MouseEvent) {
						var page:uint = e.target.name.substr(7);
						var nav_but:MovieClip = e.target as MovieClip;
						if (page != current_page && !controls_blocked) {
							nav_but.stop();
							if (nav_but.currentFrame >= 6) nav_but.play();
							if (nav_but.currentFrame < 6) {
								nav_but.gotoAndPlay(12-nav_but.currentFrame);
							}
						}
					}
				);
				nav_but.addEventListener(MouseEvent.CLICK,
					function(e:MouseEvent) {
						var page:uint = e.target.name.substr(7);
						var nav_but:MovieClip = e.target as MovieClip;
						if (page != current_page && !controls_blocked) {
							controls_blocked = true;
							current_page = page;
							changePreviews(current_page);
						}
					}
				);
			}
			if (__root != null) controls_xPos = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - previewsControlsRightMargin - controls.width;
			else controls_xPos = 980 - previewsControlsRightMargin - controls.width;
			controls.x = controls_xPos;
			
			if (newsArray.length > previewsInRow) controls.visible = true;
			else controls.visible = false;
			Tweener.addTween(controls, {alpha:1, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
		}
		
	/****************************************************************************************************/
	//	Function. Loads preview images of news items one by one (in background mode).
		
		private function loadPreviewImgs():void {
			if (previewImgsLoader != null) {
				previewImgsLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, previewImgsLoadProcessing);
				previewImgsLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, previewImgsLoadError);
				try { previewImgsLoader.close(); }
				catch(error:Error){};
				previewImgsLoader.unload();
			}
			previewImgsLoader = new Loader();
			previewImgsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, previewImgsLoadProcessing);
			previewImgsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, previewImgsLoadError);
			for (var i=0; i<newsArray.length; i++) {
				if (newsArray[i].previewImgSrc != undefined) {
					if (newsArray[i].previewBmpData == undefined) {
						currentPreviewImgIndex = i;
						previewImgsLoader.load(new URLRequest(newsArray[i].previewImgSrc+(killCachedFiles?killcache_str:'')));
						break;
					}
				} else newsArray[i].previewBmpData = "no";
			}
		}
		
		private function previewImgsLoadProcessing(e:Event):void {
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			var bmpData:BitmapData = bmp.bitmapData;
			if (newsArray[currentPreviewImgIndex].previewBmpData == undefined) newsArray[currentPreviewImgIndex].previewBmpData = bmpData;
			currentPreviewImgIndex++;
			for (var i=currentPreviewImgIndex; i<newsArray.length; i++) {
				if (newsArray[i].previewBmpData != undefined) {
					currentPreviewImgIndex++;
				} else {
					if (newsArray[i].previewImgSrc != undefined) {
						previewImgsLoader.load(new URLRequest(newsArray[i].previewImgSrc+(killCachedFiles?killcache_str:'')));
						break;
					} else {
						newsArray[i].previewBmpData = "no";
						currentPreviewImgIndex++;
					}
				}
			}
			if (currentPreviewImgIndex >= newsArray.length) {
				e.target.removeEventListener(Event.COMPLETE, previewImgsLoadProcessing);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, previewImgsLoadError);
			}
		}
		
		private function previewImgsLoadError(e:IOErrorEvent):void {
			newsArray[currentPreviewImgIndex].previewBmpData = "no";
			currentPreviewImgIndex++;
			for (var i=currentPreviewImgIndex; i<newsArray.length; i++) {
				if (newsArray[i].previewBmpData != undefined) {
					currentPreviewImgIndex++;
				} else {
					if (newsArray[i].previewImgSrc != undefined) {
						previewImgsLoader.load(new URLRequest(newsArray[i].previewImgSrc+(killCachedFiles?killcache_str:'')));
						break;
					} else {
						newsArray[i].previewBmpData = "no";
						currentPreviewImgIndex++;
					}
				}
			}
			if (currentPreviewImgIndex >= newsArray.length) {
				e.target.removeEventListener(Event.COMPLETE, previewImgsLoadProcessing);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, previewImgsLoadError);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Preview image click listener.
	
		private function previewImageClickListener(e:MouseEvent):void {
			controls_blocked = menu_blocked = true;
			var container_index:uint = uint(e.currentTarget.name.substr(9));
			var index:uint = (current_page-1)*previewsInRow + (container_index-1);
			if (index != currentArticleIndex) {
				currentArticleIndex = index;
				changeArticle();
			}
			applyBlinds("hide");
		}
		
	/****************************************************************************************************/
	//	Function. Hides/reveals the news preview images and controls.
	
		public function applyBlinds(val:String):void {
			var container:Sprite, title:Sprite, dt:Sprite, txt:Sprite;
			var mask1:Shape, mask2:Shape, mask3:Shape, mask4:Shape;
			var index:uint;
			if (val == "hide") {
				for (var i=1; i<=previewsInRow; i++) {
					index = (current_page-1)*previewsInRow + (i-1);
					container = previews.getChildByName("container"+i) as Sprite;
					container.mouseEnabled = container.mouseChildren = false;
					mask1 = container.getChildByName("mask1") as Shape;
					mask2 = container.getChildByName("mask2") as Shape;
					mask3 = container.getChildByName("mask3") as Shape;
					mask4 = container.getChildByName("mask4") as Shape;
					title = container.getChildByName("title") as Sprite;
					dt = container.getChildByName("dt") as Sprite;
					txt = container.getChildByName("txt") as Sprite;
					Tweener.addTween(mask1, {height:0, y:Math.round(preview_height/2), time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
					Tweener.addTween(mask2, {height:0, y:Math.round(preview_height/2), time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
					Tweener.addTween(mask3, {height:0, y:Math.round(preview_height/2), time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
					Tweener.addTween(mask4, {height:0, y:Math.round(preview_height/2), time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
					Tweener.addTween(title, {alpha:0, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
					Tweener.addTween(dt, {alpha:0, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
					Tweener.addTween(txt, {alpha:0, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
					if (container.getChildByName("scrollbar") != null) {
						var scrollbar:Sprite = container.getChildByName("scrollbar") as Sprite;
						if (scrollbar.visible == true) Tweener.addTween(scrollbar, {alpha:0, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
					}
				}
				Tweener.addTween(controls, {alpha:0, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart", onComplete:
					function() {
						controls.visible = previews.visible = false;
						article.alpha = 0;
						article.visible = true;
						Tweener.addTween(article, {alpha:1, time:FADE_DURATION, transition:"easeInOutSine", onComplete:
							function() {
								controls_blocked = menu_blocked = false;
							}
						});
					}
				});
			}
			if (val == "reveal") {
				for (var j=1; j<=previewsInRow; j++) {
					index = (current_page-1)*previewsInRow + (j-1);
					container = previews.getChildByName("container"+j) as Sprite;
					title = container.getChildByName("title") as Sprite;
					dt = container.getChildByName("dt") as Sprite;
					txt = container.getChildByName("txt") as Sprite;
					Tweener.removeTweens(title);
					Tweener.removeTweens(dt);
					Tweener.removeTweens(txt);
					title.alpha = dt.alpha = txt.alpha = 0;
				}
				Tweener.removeTweens(controls);
				previews.visible = true;
				Tweener.addTween(article, {alpha:0, time:FADE_DURATION, transition:"easeInOutSine", onComplete:
					function() {
						article.visible = false;
						for (var i=1; i<=previewsInRow; i++) {
							index = (current_page-1)*previewsInRow + (i-1);
							container = previews.getChildByName("container"+i) as Sprite;
							container.mouseEnabled = container.mouseChildren = true;
							mask1 = container.getChildByName("mask1") as Shape;
							mask2 = container.getChildByName("mask2") as Shape;
							mask3 = container.getChildByName("mask3") as Shape;
							mask4 = container.getChildByName("mask4") as Shape;
							title = container.getChildByName("title") as Sprite;
							dt = container.getChildByName("dt") as Sprite;
							txt = container.getChildByName("txt") as Sprite;
							var mask_height:uint = preview_height + 40;
							Tweener.addTween(mask1, {height:mask_height, y:0, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
							Tweener.addTween(mask2, {height:mask_height, y:0, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
							Tweener.addTween(mask3, {height:mask_height, y:0, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
							Tweener.addTween(mask4, {height:mask_height, y:0, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
							Tweener.addTween(title, {alpha:1, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
							Tweener.addTween(dt, {alpha:1, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
							Tweener.addTween(txt, {alpha:1, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
							if (container.getChildByName("scrollbar") != null) {
								var scrollbar:Sprite = container.getChildByName("scrollbar") as Sprite;
								if (scrollbar.visible == true) Tweener.addTween(scrollbar, {alpha:1, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
							}
						}
						Tweener.addTween(controls, {alpha:1, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart", onComplete:
							function(){
								controls_blocked = menu_blocked = false;
							}
						});
						if (vpObj != null) {
							if (vpObj.isPlaying) vpObj.setPausedState();
							vpObj.autohideTimer.stop();
						}
					}
				});
			}
		}		
		
	/****************************************************************************************************/
	//	Function. Builds the article (opened item) area.
	
		private function createArticleArea():void {
			
			var controls:Sprite, separator:Sprite, container:Sprite, media:Sprite, title:Sprite, dt:Sprite;
			var base:Shape, bg:Shape, title_mask:Shape, separator_mask:Shape;
			var hover_icon:MovieClip;
			var tf:TextField;
			main.addChild(article = new Sprite());
			article.y = singleArticleYPosition;
			article.visible = false;
			
			// *** Big image/video
			article.addChild(container = new Sprite());
			container.name = "container";
			container.y = articleHeaderHeight;
			var border_thickness:uint = 0;
			container.addChild(bg = new Shape());
			bg.name = "bg";
			container.addChild(media = new Sprite());
			media.name = "media";
			hover_icon = new zoom_mc();
			container.addChild(hover_icon);
			hover_icon.mouseEnabled = false;
			hover_icon.visible = false;
			hover_icon.name = "hover_icon";
			container.addChild(base = new Shape());
			base.name = "base";
			if (showArticleMedia) {
				if (!isNaN(bigImageBgColor) && !isNaN(bigImageBgAlpha)) {
					Geom.drawRectangle(bg, bigImageAreaWidth+2*bigImagePadding, Math.round(bigImageAreaWidth*9/16)+2*bigImagePadding, bigImageBgColor, bigImageBgAlpha);
				}
				if (!isNaN(bigImageBorderColor) && bigImageBorderThickness > 0) {
					border_thickness = bigImageBorderThickness;
					Geom.drawBorder(base, bigImageAreaWidth, Math.round(bigImageAreaWidth*9/16), bigImageBorderColor, 1, bigImageBorderThickness, bigImagePadding);
				}
				bg.x = bg.y = border_thickness;
				media.x = media.y = base.x = base.y = border_thickness + bigImagePadding;
			}
			
			bigImageLoader = new Loader();
			
			// *** Controls
			article.addChild(controls = new Sprite());
			controls.name = "controls";
			var list_but:Sprite = new Sprite();
			controls.addChild(list_but);
			list_but.name = "list_but";
			list_but.visible = false;
			if (articleListButtonURL != null) {
				var listButLoader:Loader = new Loader();
				listButLoader.name = "list";
				listButLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, navButLoadComplete);
				listButLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
				listButLoader.load(new URLRequest(articleListButtonURL+(killCachedFiles?killcache_str:'')));
				list_but.buttonMode = true;
			}
			
			var nav_but1:Sprite = new Sprite();
			controls.addChild(nav_but1);
			nav_but1.name = "nav_but1";
			var nav_but2:Sprite = new Sprite();
			controls.addChild(nav_but2);
			nav_but2.name = "nav_but2";
			nav_but1.visible = nav_but2.visible = false;
			if (articleLeftNavButtonURL != null && articleRightNavButtonURL != null) {
				var navBut1Loader:Loader = new Loader();
				navBut1Loader.name = "left";
				navBut1Loader.contentLoaderInfo.addEventListener(Event.COMPLETE, navButLoadComplete);
				navBut1Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
				navBut1Loader.load(new URLRequest(articleLeftNavButtonURL+(killCachedFiles?killcache_str:'')));
				var navBut2Loader:Loader = new Loader();
				navBut2Loader.name = "right";
				navBut2Loader.contentLoaderInfo.addEventListener(Event.COMPLETE, navButLoadComplete);
				navBut2Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
				navBut2Loader.load(new URLRequest(articleRightNavButtonURL+(killCachedFiles?killcache_str:'')));
			}
			
			if (articleControlsSeparatorURL != null) {
				article.addChild(separator = new Sprite());
				article.addChild(separator_mask = new Shape());
				separator.name = "separator";
				separator.x = separator_mask.x = bigImageAreaWidth + bigImageAreaRightMargin;
				separator.y = separator_mask.y = articleHeaderHeight + bigImagePadding + border_thickness;
				var sep_mask_width:uint;
				if (__root != null) sep_mask_width = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - separator.x;
				else sep_mask_width = 980 - separator.x;
				Geom.drawRectangle(separator_mask, sep_mask_width, 5, 0xFF9900, 0);
				separator.mask = separator_mask;
				var separatorLoader:Loader = new Loader();
				separatorLoader.load(new URLRequest(articleControlsSeparatorURL+(killCachedFiles?killcache_str:'')));
				separator.addChild(separatorLoader);
				var separatorColor:ColorTransform = separator.transform.colorTransform;
				separatorColor.color = articleControlsSeparatorColor;
				separator.transform.colorTransform = separatorColor;
			}
			
			// *** Title
			article.addChild(title = new Sprite());
			title.name = "title";
			tf = new TextField();
			tf.name = "tf";
			title.addChild(tf);
			article.addChild(title_mask = new Shape());
			title_mask.name = "title_mask";
			Geom.drawRectangle(title_mask, 10, 10, 0xFF9900, 0);
			title.mask = title_mask;
			var tf_width:uint;
			title.x = title_mask.x = bigImageAreaWidth + bigImageAreaRightMargin;
			title.y = title_mask.y = articleHeaderHeight + articleTitleTopMargin;
			if (__root != null) tf_width = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - title.x;
			else tf_width = 980 - title.x;
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.width = tf_width;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.embedFonts = true;
			tf.selectable = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			
			// *** Date
			article.addChild(dt = new Sprite());
			dt.name = "dt";
			dt.x = bigImageAreaWidth + bigImageAreaRightMargin;
			tf = new TextField();
			tf.name = "tf";
			dt.addChild(tf);
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = false;
			tf.wordWrap = false;
			tf.embedFonts = true;
			tf.selectable = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			
			// *** Description
			blocks_xPos = bigImageAreaWidth + bigImageAreaRightMargin;
			
			if (__root != null) stage.addEventListener(Event.RESIZE, onStageResized);
		}
		
	/****************************************************************************************************/
	//	Functions. Handles events on navigation button ("left", "right" or "list") loading.
		
		private function navButLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, navButLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
			var button:String = e.target.loader.name;
			var button_name:String;
			switch (button) {
				case "left":
					button_name = "nav_but1";
				break;
				case "right":
					button_name = "nav_but2";
				break;
				case "list":
					button_name = "list_but";
			}
			var controls:Sprite = article.getChildByName("controls") as Sprite;
			var nav_but:Sprite = controls.getChildByName(button_name) as Sprite;
			var bmp:Bitmap = Bitmap(e.target.content);
			var hitarea:Sprite = new Sprite();
			nav_but.addChild(hitarea);
			Geom.drawRectangle(hitarea, bmp.width+2*NAV_BUTTON_ICON_PADDING, bmp.height+2*NAV_BUTTON_ICON_PADDING, 0xFF9900, 0);
			nav_but.hitArea = hitarea;
			nav_but.addChild(bmp);
			bmp.x = bmp.y = NAV_BUTTON_ICON_PADDING;
			var navButColor:ColorTransform = nav_but.transform.colorTransform;
			navButColor.color = articleButtonColor;
			nav_but.transform.colorTransform = navButColor;
			nav_but.addEventListener(MouseEvent.ROLL_OVER,
				function(e:MouseEvent) {
					if (nav_but.alpha == 1) {
						Tweener.removeTweens(nav_but);
						Tweener.addTween(nav_but, {_color:articleButtonOverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
				}
			);
			nav_but.addEventListener(MouseEvent.ROLL_OUT,
				function(e:MouseEvent) {
					if (nav_but.alpha == 1) {
						Tweener.removeTweens(nav_but);
						Tweener.addTween(nav_but, {_color:articleButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
				}
			);
			nav_but.addEventListener(MouseEvent.CLICK,
				function(e:MouseEvent) {
					if (!controls_blocked) {
						if (button == "left" && currentArticleIndex > 0) {
							controls_blocked = true;
							currentArticleIndex--;
							changeArticle();
							if (currentArticleIndex == 0) Tweener.addTween(nav_but, {_color:articleButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
						} else if (button == "right" && currentArticleIndex < newsArray.length-1) {
							controls_blocked = true;
							currentArticleIndex++;
							changeArticle();
							if (currentArticleIndex == newsArray.length-1) Tweener.addTween(nav_but, {_color:articleButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
						} else if (button == "list") {
							controls_blocked = menu_blocked = true;
							var ctrls:Sprite = main.getChildByName("controls") as Sprite;
							ctrls.alpha = 0;
							if (newsArray.length > previewsInRow) ctrls.visible = true;
							else ctrls.visible = false;
							applyBlinds("reveal");
						}
					}
				}
			);
			var nav_but1:Sprite = controls.getChildByName("nav_but1") as Sprite;
			var nav_but2:Sprite = controls.getChildByName("nav_but2") as Sprite;
			var list_but:Sprite = controls.getChildByName("list_but") as Sprite;
			if (nav_but1.width > 0 && nav_but2.width > 0 && list_but.width > 0) {
				nav_but1.visible = nav_but2.visible = list_but.visible = true;
				list_but.x = nav_but1.width + articleNavButtonSpacing;
				nav_but2.x = list_but.x + list_but.width + articleNavButtonSpacing;
				if (__root != null) controls.x = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - articleControlsRightMargin - controls.width;
				else controls.x = 980 - articleControlsRightMargin - controls.width;
			}
		}
		
		private function navButLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, navButLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
		}

	/****************************************************************************************************/
	//	Function. Changes a news article (currently selected news item).
	
		private function changeArticle():void {
			var title:Sprite = article.getChildByName("title") as Sprite;
			var title_mask:Shape = article.getChildByName("title_mask") as Shape;
			var tf1:TextField = title.getChildByName("tf") as TextField;
			var dt:Sprite = article.getChildByName("dt") as Sprite;
			var tf2:TextField = dt.getChildByName("tf") as TextField;
			var container:Sprite = article.getChildByName("container") as Sprite;
			var media:Sprite = container.getChildByName("media") as Sprite;
			var base:Shape = container.getChildByName("base") as Shape;
			var controls:Sprite = article.getChildByName("controls") as Sprite;
			var nav_but1:Sprite = controls.getChildByName("nav_but1") as Sprite;
			var nav_but2:Sprite = controls.getChildByName("nav_but2") as Sprite;
			
			// Big image/video
			if (showArticleMedia) changeMedia();
			
			// Controls
			if (currentArticleIndex == 0) { nav_but1.buttonMode = false; nav_but1.alpha = 0.7; }
			else { nav_but1.buttonMode = true; nav_but1.alpha = 1; }
			if (currentArticleIndex == newsArray.length-1) { nav_but2.buttonMode = false; nav_but2.alpha = 0.7; }
			else { nav_but2.buttonMode = true; nav_but2.alpha = 1; }
			
			// Title
			title.alpha = 0;
			if (newsArray[currentArticleIndex].articleTitle != undefined) tf1.htmlText = newsArray[currentArticleIndex].articleTitle;
			else tf1.htmlText = "";
			title_mask.width = 0;
			title_mask.height = title.height;
			Tweener.removeTweens(title);
			Tweener.removeTweens(title_mask);
			Tweener.addTween(title, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
			Tweener.addTween(title_mask, {width:title.width, time:0.5*FADE_DURATION, transition:"easeInOutQuad"});
			
			// Date
			dt.alpha = 0;
			if (newsArray[currentArticleIndex].articleDate != undefined) tf2.htmlText = newsArray[currentArticleIndex].articleDate;
			else tf2.htmlText = "";
			dt.y = articleHeaderHeight + (tf1.htmlText != ""?articleTitleTopMargin+Math.ceil(title.height):0) + articleDateTopMargin;
			Tweener.addTween(dt, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
			
			// Description
			var blocks:Sprite;
			if (article.getChildByName("blocks") != null) {
				if (scrollerObj != null) {
					scrollerObj.destroyScroller();
					scrollerObj = null;
				}
				blocks = article.getChildByName("blocks") as Sprite;
				Tweener.removeTweens(blocks);
				article.removeChild(blocks);
			}
			article.addChild(blocks = new Sprite());
			blocks.name = "blocks";
			blocks_yPos = articleHeaderHeight + (tf1.htmlText != ""?articleTitleTopMargin+Math.ceil(title.height):0) + (tf2.htmlText != ""?articleDateTopMargin+Math.ceil(dt.height):0) + articleContentTopMargin;
			blocks.x = blocks_xPos;
			blocks.y = blocks_yPos;
			blocks.alpha = 0;
			block_yPos = 0;
			if (newsArray[currentArticleIndex].articleBlocks != undefined) {
				for (var i=0; i<newsArray[currentArticleIndex].articleBlocks.length; i++) {
					if (newsArray[currentArticleIndex].articleBlocks[i].type == "text") buildTextBlock(blocks, newsArray[currentArticleIndex].articleBlocks, i);
					if (newsArray[currentArticleIndex].articleBlocks[i].type == "list") buildList(blocks, newsArray[currentArticleIndex].articleBlocks, i);
					if (newsArray[currentArticleIndex].articleBlocks[i].type == "link") buildLink(blocks, newsArray[currentArticleIndex].articleBlocks, i);
				}
			}
			attachScroller2(); // attach a scroller to the blocks content
			Tweener.addTween(blocks, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
			
			Tweener.addTween(article, {delay:FADE_DURATION, onComplete:function(){controls_blocked = false;}});
		}
		
	/****************************************************************************************************/
	//	Function. Attaches a scroller to the article text.
		
		private function attachScroller2():void {
			var blocks:Sprite = article.getChildByName("blocks") as Sprite;
			var hitarea:Sprite = new Sprite();
			blocks.addChild(hitarea);
			blocks.hitArea = hitarea;
			hitarea.mouseEnabled = false;
			if (__root != null) {
				var mask_w:uint = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - blocks_xPos;
				var mask_h:uint = stage.stageHeight - __root.page_content.y - __root.module_container.y - article.y - blocks.y - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
				Geom.drawRectangle(hitarea, mask_w, blocks.height, 0xFF9900, 0);
				scrollerObj = new Scroller(blocks,
										   mask_w,
										   mask_h,
										   scrollBarTrackWidth,
										   scrollBarTrackColor,
										   scrollBarTrackAlpha,
										   scrollBarSliderOverWidth,
										   scrollBarSliderColor,
										   scrollBarSliderOverColor);
			} else {
				Geom.drawRectangle(hitarea, 980-blocks_xPos, blocks.height, 0xFF9900, 0);
				scrollerObj = new Scroller(blocks, 980-blocks_xPos, 500, scrollBarTrackWidth, scrollBarTrackColor, scrollBarTrackAlpha, scrollBarSliderOverWidth, scrollBarSliderColor, scrollBarSliderOverColor);
			}
		}		
		
	/****************************************************************************************************/
	//	Function. Changes a media item (image or video) of the currently selected news article.
	
		private function changeMedia():void {
			var container:Sprite = article.getChildByName("container") as Sprite;
			var media:Sprite = container.getChildByName("media") as Sprite;
			var hover_icon:MovieClip = container.getChildByName("hover_icon") as MovieClip;
			var bg:Shape = container.getChildByName("bg") as Shape;
			var base:Shape = container.getChildByName("base") as Shape;
			var preloader:MovieClip;
			Tweener.removeTweens(media);
			bigImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bigImageLoadComplete);
			bigImageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, bigImageLoadError);
			try { bigImageLoader.close(); }
			catch(error:Error){};
			bigImageLoader.unload();
			media.graphics.clear();
			media.alpha = 0;
			media.buttonMode = false;
			media.removeEventListener(MouseEvent.CLICK, bigImageClickListener);
			hover_icon.visible = false;
			if (vpObj != null) {
				vpObj.killVideoPlayer();
				vpObj = null;
			}
			if (videoplayer != null) {
				media.removeChild(videoplayer);
				videoplayer = null;
			}
			if (container.getChildByName("preloader")) {
				preloader = container.getChildByName("preloader") as MovieClip;
				Tweener.removeTweens(preloader);
				container.removeChild(preloader);
			}
			if (newsArray[currentArticleIndex].media) {
				if (newsArray[currentArticleIndex].media[0].type == "image") {
					if (newsArray[currentArticleIndex].media[0].bigImgBmpData == undefined) {
						if (newsArray[currentArticleIndex].media[0].src != undefined) {
							if (!isNaN(bigImagePreloaderColor) && !isNaN(bigImagePreloaderAlpha)) {
								preloader = new video_preloader();
								preloader.name = "preloader";
								container.addChild(preloader);
								if (bg.width > 0){
									preloader.x = Math.round(bg.width/2) + bg.x;
									preloader.y = Math.round(bg.height/2) + bg.y;
								} else if (base.width > 0) {
									preloader.x = Math.round(base.width/2) + base.x;
									preloader.y = Math.round(base.height/2) + base.y;
								} else {
									preloader.x = Math.round(bigImageAreaWidth/2);
									preloader.y = Math.round(9/16*bigImageAreaWidth/2);
									bg.graphics.clear();
									base.graphics.clear();
									var border_thickness:uint = 0;
									if (!isNaN(bigImageBgColor) && !isNaN(bigImageBgAlpha)) {
										Geom.drawRectangle(bg, bigImageAreaWidth+2*bigImagePadding, Math.round(bigImageAreaWidth*9/16)+2*bigImagePadding, bigImageBgColor, bigImageBgAlpha);
									}
									if (!isNaN(bigImageBorderColor) && bigImageBorderThickness > 0) {
										border_thickness = bigImageBorderThickness;
										Geom.drawBorder(base, bigImageAreaWidth, Math.round(bigImageAreaWidth*9/16), bigImageBorderColor, 1, bigImageBorderThickness, bigImagePadding);
									}
									bg.x = bg.y = border_thickness;
									media.x = media.y = base.x = base.y = border_thickness + bigImagePadding;
									preloader.x += media.x;
									preloader.y += media.y;
								}
								preloader.scaleX = preloader.scaleY = 0.7;
								var preloaderColor:ColorTransform = preloader.transform.colorTransform;
								preloaderColor.color = bigImagePreloaderColor;
								preloader.transform.colorTransform = preloaderColor;
								preloader.alpha = bigImagePreloaderAlpha;
							}
							bigImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bigImageLoadComplete);
							bigImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bigImageLoadError);
							bigImageLoader.load(new URLRequest(newsArray[currentArticleIndex].media[0].src+(killCachedFiles?killcache_str:'')));
						} else {
							newsArray[currentArticleIndex].media[0].bigImgBmpData = "no";
							drawBigImage(newsArray[currentArticleIndex].media[0].bigImgBmpData);
						}
					} else {
						drawBigImage(newsArray[currentArticleIndex].media[0].bigImgBmpData);
					}
					base.visible = bg.visible = true;
				} else {
					var videoURL:String = newsArray[currentArticleIndex].media[0].src;
					var previewImageURL:String = newsArray[currentArticleIndex].media[0].previewImage;
					var playbackQuality:String = newsArray[currentArticleIndex].media[0].playbackQuality;
					var videoAutoPlay:Boolean = newsArray[currentArticleIndex].media[0].autoPlay;
					var videoRatio:String = newsArray[currentArticleIndex].media[0].ratio;
					videoPlayerWidth = bigImageAreaWidth;
					videoPlayerHeight = Math.round(videoPlayerWidth * (videoRatio == "16:9" ? 9/16 : 3/4));
					if (newsArray[currentArticleIndex].media[0].type == "youtube") {
						vpObj = new VideoPlayerYouTube(this, killCachedFiles, textStyleSheet, videoURL, previewImageURL, playbackQuality, videoAutoPlay);
					} else if (newsArray[currentArticleIndex].media[0].type == "video") {
						vpObj = new VideoPlayer(this, killCachedFiles, textStyleSheet, videoURL, previewImageURL, videoAutoPlay);
					}
					if (vpObj != null) {
						videoplayer = vpObj.videoplayer;
						media.addChild(videoplayer);
						videoplayer.name = "videoplayer";
						Tweener.addTween(media, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
					}
					base.visible = bg.visible = false;
					container.x = 0;
					bg.graphics.clear();
					base.graphics.clear();
				}
			}
		}
		
	/****************************************************************************************************/
	//	Functions. Handles events on loading of big images of the currently selected news article.
		
		private function bigImageLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, bigImageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, bigImageLoadError);
			if (!isNaN(currentArticleIndex)) {
				var bmp:Bitmap = Bitmap(e.target.content);
				bmp.smoothing = true;
				var bmpData:BitmapData = bmp.bitmapData;
				if (newsArray[currentArticleIndex].media[0].bigImgBmpData == undefined) newsArray[currentArticleIndex].media[0].bigImgBmpData = bmpData;
				drawBigImage(bmpData);
			}
		}
		
		private function bigImageLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, bigImageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, bigImageLoadError);
			var container:Sprite = article.getChildByName("container") as Sprite;
			var preloader:MovieClip = container.getChildByName("preloader") as MovieClip;
			if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.7*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[container, preloader]});
			if (!isNaN(currentArticleIndex)) {
				if (newsArray[currentArticleIndex].media[0].bigImgBmpData == undefined) newsArray[currentArticleIndex].media[0].bigImgBmpData = "no";
			}
		}
		
	/****************************************************************************************************/
	//	Function. Draws a big image of the currently selected media (image).
		
		private function drawBigImage(bmpData:*):void {
			var container:Sprite = article.getChildByName("container") as Sprite;
			var media:Sprite = container.getChildByName("media") as Sprite;
			var bg:Shape = container.getChildByName("bg") as Shape;
			var base:Shape = container.getChildByName("base") as Shape;
			var preloader:MovieClip = container.getChildByName("preloader") as MovieClip;
			if (preloader) removeImagePreloader(container, preloader);
			container.x = 0;
			bg.graphics.clear();
			base.graphics.clear();
			if (bmpData != "no") {
				var smoothing:Boolean = false;
				var new_width:uint = bmpData.width;
				var new_height:uint = bmpData.height;
				var bmp_matrix:Matrix = new Matrix();
				if (bmpData.width > bigImageAreaWidth) {
					var sx:Number = bigImageAreaWidth/bmpData.width;
					bmp_matrix.scale(sx, sx);
					new_width = bigImageAreaWidth;
					new_height = Math.round(new_width*bmpData.height/bmpData.width);
					smoothing = true;
				}
				
				var border_thickness:uint = 0;
				if (!isNaN(bigImageBgColor) && !isNaN(bigImageBgAlpha)) {
					Geom.drawRectangle(bg, new_width+2*bigImagePadding, new_height+2*bigImagePadding, bigImageBgColor, bigImageBgAlpha);
				}
				if (!isNaN(bigImageBorderColor) && bigImageBorderThickness > 0) {
					border_thickness = bigImageBorderThickness;
					Geom.drawBorder(base, new_width, new_height, bigImageBorderColor, 1, bigImageBorderThickness, bigImagePadding);
				}
				bg.x = bg.y = border_thickness;
				media.x = media.y = base.x = base.y = border_thickness + bigImagePadding;
				if (bmpData.width < bigImageAreaWidth) container.x = Math.round((bigImageAreaWidth-bmpData.width)/2) - bigImagePadding - border_thickness;
				
				with (media.graphics) {
					beginBitmapFill(bmpData, bmp_matrix, true, smoothing);
					lineTo(new_width, 0);
					lineTo(new_width, new_height);
					lineTo(0, new_height);
					lineTo(0, 0);
					endFill();
				}
				Tweener.addTween(media, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
				
				var hover_icon:MovieClip = container.getChildByName("hover_icon") as MovieClip;
				var hoverIconColor:ColorTransform = hover_icon.transform.colorTransform;
				hoverIconColor.color = bigImageZoomIconColor;
				hover_icon.transform.colorTransform = hoverIconColor;
				hover_icon.alpha = bigImageZoomIconAlpha;
				hover_icon.x = Math.round((new_width-hover_icon.width)/2) + media.x;
				hover_icon.y = Math.round((new_height-hover_icon.height)/2) + media.y;
				
				if (bigImageOverBrightness != 0 || bigImageZoomIconAlpha != 0 || bigImageZoomIconOverAlpha != 0) {
					Image.drawCaption(container, 0, 0, null, null, null, NaN, NaN, false, NaN, 0, null, bigImageOverBrightness, 0.6, "hover_icon", bigImageZoomIconOverAlpha, bigImageZoomIconAlpha);
				}
				if (bmpData.width > bigImageAreaWidth) {
					media.buttonMode = true;
					media.addEventListener(MouseEvent.CLICK, bigImageClickListener);
					hover_icon.visible = true;
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Big image click listener.
	
		private function bigImageClickListener(e:MouseEvent):void {
			if (__root != null && newsArray[currentArticleIndex].media[0].type == "image") {
				controls_blocked = menu_blocked = true;
				currentFsImageIndex = 0;
				changeFullscreenImage();
				displaySingleItemView(true);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Builds a text block.
	
		private function buildTextBlock(blocks:Sprite, blocksArray:Array, index:uint):void {
			var tf_max_width:uint;
			var block:Sprite = new Sprite();
			block.x = blocksArray[index].leftMargin;
			block.y = block_yPos + blocksArray[index].topMargin;
			blocks.addChild(block);
			if (__root != null) tf_max_width = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - blocks_xPos - block.x;
			else tf_max_width = 980 - blocks_xPos - block.x;
			tf_max_width -= 10; // increase the spacing between the right edge of a text field and the scroll bar
			var tf:TextField = new TextField();
			block.addChild(tf);
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.width = tf_max_width;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.embedFonts = true;
			tf.selectable = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.mouseWheelEnabled = false;
			var oneline_fix:uint = 0;
			if (blocksArray[index].text != undefined) {
				tf.htmlText = blocksArray[index].text;
				tf.height += TEXT_LEADING; // disables TextField scrolling on selection (also is a workaround for "jumpy htmlText hyperlinks")
				tf.autoSize = TextFieldAutoSize.NONE;
				var metrics:TextLineMetrics = tf.getLineMetrics(1);
				if (metrics.height == 0) oneline_fix = TEXT_LEADING; // fix for a one-line text block
			}
			var block_height:uint = Math.ceil(block.height) - TEXT_LEADING - oneline_fix; // original height of the block
			block_yPos += blocksArray[index].topMargin + block_height;
		}
		
	/****************************************************************************************************/
	//	Function. Builds a list.
	
		private function buildList(blocks:Sprite, blocksArray:Array, index:uint):void {
			var tf_max_width:uint;
			var block:Sprite = new Sprite();
			block.x = blocksArray[index].leftMargin;
			block.y = block_yPos + blocksArray[index].topMargin;
			if (__root != null) tf_max_width = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - blocks_xPos - block.x - listItemLeftPadding;
			else tf_max_width = 980 - blocks_xPos - block.x - listItemLeftPadding;			
			tf_max_width -= 10; // increase the spacing between the right edge of a text field and the scroll bar
			blocks.addChild(block);
			
			var tf:TextField;
			var tf_yPos:uint = 0;;
			var listitem:Sprite, marker:Sprite;
			var oneline_fix:uint = 0;
			for (var i=0; i<blocksArray[index].items.length; i++) {
				listitem = new Sprite();
				block.addChild(listitem);
				tf = new TextField();
				listitem.addChild(tf);
				if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
				tf.width = tf_max_width;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.multiline = true;
				tf.wordWrap = true;
				tf.embedFonts = true;
				tf.selectable = true;
				tf.antiAliasType = AntiAliasType.ADVANCED;
				tf.mouseWheelEnabled = false;
				if (blocksArray[index].items[i] != undefined) {
					tf.htmlText = blocksArray[index].items[i];
					tf.height += TEXT_LEADING; // disables TextField scrolling on selection (also is a workaround for "jumpy htmlText hyperlinks")
					tf.autoSize = TextFieldAutoSize.NONE;
				}
				var metrics:TextLineMetrics = tf.getLineMetrics(1);
				listitem.x = listItemLeftPadding;
				listitem.y = tf_yPos;
				
				// *** List item marker loading
				if (listItemMarkerURL != null) {
					marker = new Sprite();
					block.addChild(marker);
					Geom.drawRectangle(marker, listItemLeftPadding, 0, 0xFFFFFF, 0); // this is only for setting the bounds of a marker sprite
					marker.y = tf_yPos + listItemMarkerTopPadding;
					var markerLoader:Loader = new Loader();
					markerLoader.load(new URLRequest(listItemMarkerURL+(killCachedFiles?killcache_str:'')));
					marker.addChild(markerLoader);
					markerLoader.x = 3;
					if (blocksArray[index].markerColor != undefined) {
						var markerColor:ColorTransform = marker.transform.colorTransform;
						markerColor.color = blocksArray[index].markerColor;
						marker.transform.colorTransform = markerColor;
					}
				}
				// ***
				
				tf_yPos -= TEXT_LEADING; // subtract N px added to a text field height above
				tf_yPos += Math.ceil(tf.height) + listItemBottomPadding;
				if (metrics.height == 0) {
					tf_yPos -= TEXT_LEADING; // fix for a one-line list item
					if (i == blocksArray[index].items.length-1) oneline_fix = TEXT_LEADING;
				}
			}
			
			var block_height:uint = Math.ceil(block.height) - TEXT_LEADING - oneline_fix; // original height of the block
			block_yPos += blocksArray[index].topMargin + block_height;
		}
		
	/****************************************************************************************************/
	//	Function. Builds a link block.
	
		private function buildLink(blocks:Sprite, blocksArray:Array, index:uint):void {
			var block:Sprite = new Sprite();
			block.x = blocksArray[index].leftMargin;
			block.y = block_yPos + blocksArray[index].topMargin;
			blocks.addChild(block);
			var tf:TextField = new TextField();
			block.addChild(tf);
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = false;
			tf.wordWrap = false;
			tf.embedFonts = true;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			if (blocksArray[index].text != undefined) tf.htmlText = blocksArray[index].text;
			if (blocksArray[index].align == "right") tf.x = blocksArray[index].leftPadding;
			
			// *** Link icon loading
			if (blocksArray[index].iconURL != null) {
				var icon:Sprite = new Sprite();
				block.addChild(icon);
				icon.y = blocksArray[index].iconTopPadding;
				var iconLoader:Loader = new Loader();
				iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,
					function(e:Event) {
						if (blocksArray[index].align == "left") iconLoader.x = Math.ceil(tf.width) + blocksArray[index].rightPadding - e.target.content.width;
						Geom.drawRectangle(block, Math.ceil(block.width), Math.ceil(block.height), 0xFFFFFF, 0);
					}
				);
				iconLoader.load(new URLRequest(blocksArray[index].iconURL+(killCachedFiles?killcache_str:'')));
				icon.addChild(iconLoader);
			}
			// ***
			
			if (blocksArray[index].color != undefined) {
				var linkColor:ColorTransform = block.transform.colorTransform;
				linkColor.color = blocksArray[index].color;
				block.transform.colorTransform = linkColor;
			}
			block.buttonMode = true;
			block.addEventListener(MouseEvent.ROLL_OVER,
				function(e:MouseEvent) {
					Tweener.removeTweens(block);
					Tweener.addTween(block, {_color:blocksArray[index].hoverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
				}
			);
			block.addEventListener(MouseEvent.ROLL_OUT,
				function(e:MouseEvent) {
					Tweener.removeTweens(block);
					Tweener.addTween(block, {_color:blocksArray[index].color, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
				}
			);
			if (blocksArray[index].clickLink != undefined) {
				var link:String = blocksArray[index].clickLink;
				var target:String = blocksArray[index].clickTarget;
				if (target == null) target = "_blank";
				block.addEventListener(MouseEvent.CLICK,
					function(e:MouseEvent) {
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
			block_yPos += blocksArray[index].topMargin + Math.ceil(block.height);
		}
		
	/****************************************************************************************************/
	//	Function. Displays/hides the single item view.
	
		private function displaySingleItemView(vis:Boolean):void {
			if (vis == true) {
				resizeSingleItemArea();
				__root.gallery_container.alpha = 0;
				__root.gallery_container.visible = true;
				Tweener.addTween(__root.gallery_container, {alpha:1, time:FS_FADE_DURATION, transition:"easeOutQuad", onComplete:
					function() {
						controls_blocked = false;
					}
				});
			}
			if (vis == false) {
				Tweener.addTween(__root.gallery_container, {alpha:0, time:FS_FADE_DURATION, transition:"easeOutQuad", onComplete:
					function() {
						__root.gallery_container.visible = false;
						controls_blocked = menu_blocked = false;
					}
				});
			}
		}
		
	/****************************************************************************************************/
	//	Function. Builds the single item area.
	
		private function createSingleItemArea():void {
			
			var controls:Sprite, buttons:Sprite, container:Sprite, media:Sprite;
			var controls_bg:Shape;
			var butIconColor:ColorTransform, butBgColor:ColorTransform;
			
			__root.gallery_container.addChild(fullscreen_bg = new Shape());
			__root.gallery_container.addChild(fsimg = new Sprite());
			Geom.drawRectangle(fullscreen_bg, stage.stageWidth, stage.stageHeight, overlayBgColor, overlayBgAlpha);
			
			// *** Fullscreen image
			fsimg.addChild(container = new Sprite());
			container.name = "container";
			container.addChild(media = new Sprite());
			media.name = "media";
			
			// *** Controls (close button)
			fsimg.addChild(controls = new Sprite());
			controls.name = "controls";
			controls.addChild(controls_bg = new Shape());
			controls_bg.name = "controls_bg";
			controls.addChild(buttons = new Sprite());
			buttons.name = "buttons";
			var close_but:MovieClip = new close_button();
			close_but.name = "close_but";
			close_but.buttonMode = true;
			close_but.addEventListener(MouseEvent.ROLL_OVER, closeButtonListener);
			close_but.addEventListener(MouseEvent.ROLL_OUT, closeButtonListener);
			close_but.addEventListener(MouseEvent.CLICK, closeButtonListener);
			butIconColor = close_but.icon.transform.colorTransform;
			butIconColor.color = buttonIconColor;
			close_but.icon.transform.colorTransform = butIconColor;
			butBgColor = close_but.bg.transform.colorTransform;
			butBgColor.color = buttonBgColor;
			close_but.bg.transform.colorTransform = butBgColor;
			buttons.addChild(close_but);
			buttons.x = BUTTONS_XOFFSET;
			buttons.y = BUTTONS_YOFFSET + 1;
			Geom.drawRectangle(controls_bg, buttons.width+2*BUTTONS_XOFFSET, buttons.height+2*BUTTONS_YOFFSET, controlsBarBgColor, controlsBarBgAlpha, 16, 0, 0, 0);
			controls.x = stage.stageWidth - controls.width;
			controls.y = stage.stageHeight - controls.height;
			
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		}
		
		private function closeButtonListener(e:MouseEvent):void {
			var but:MovieClip = e.currentTarget as MovieClip;
			switch (e.type) {
				case "rollOver":
					Tweener.removeTweens(but.icon);
					Tweener.removeTweens(but.bg);
					Tweener.addTween(but.icon, {_color:buttonIconOverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					Tweener.addTween(but.bg, {_color:buttonBgOverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
				break;
				case "rollOut":
					Tweener.removeTweens(but.icon);
					Tweener.removeTweens(but.bg);
					Tweener.addTween(but.icon, {_color:buttonIconColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					Tweener.addTween(but.bg, {_color:buttonBgColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
				break;
				case "click":
					if (!controls_blocked) {
						controls_blocked = true;
						displaySingleItemView(false);
						Tweener.addTween(fsimg, {delay:FS_FADE_DURATION, onComplete:function(){controls_blocked = false;}});
					}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Resizes the single item area.
	
		private function resizeSingleItemArea():void {
			var controls:Sprite = fsimg.getChildByName("controls") as Sprite;
			var container:Sprite = fsimg.getChildByName("container") as Sprite;
			var media:Sprite = container.getChildByName("media") as Sprite;
			fullscreen_bg.width = stage.stageWidth;
			fullscreen_bg.height = stage.stageHeight;
			controls.x = stage.stageWidth - controls.width;
			controls.y = stage.stageHeight - controls.height;
			if (!isNaN(currentFsImageIndex) && !isNaN(currentArticleIndex)) {
				// currentFsImageIndex can be NaN or 0 in the News module
				var bmpData:BitmapData = newsArray[currentArticleIndex].media[currentFsImageIndex].bigImgBmpData;
				if (bmpData != null) {
					media.graphics.clear();
					media.alpha = 0;
					drawFullscreenImage(container, bmpData);
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Keybord "KEY_UP" event listener.
	
		private function keyUpListener(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ESCAPE) {
				if (!controls_blocked && __root.gallery_container.visible == true) {
					controls_blocked = true;
					displaySingleItemView(false);
					Tweener.addTween(fsimg, {delay:FS_FADE_DURATION, onComplete:function(){controls_blocked = false;}});
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Changes the current fullscreen image.
	
		private function changeFullscreenImage():void {
			var container:Sprite = fsimg.getChildByName("container") as Sprite;
			var media:Sprite = container.getChildByName("media") as Sprite;
			Tweener.removeTweens(media);
			media.graphics.clear();
			media.alpha = 0;
			var bmpData:BitmapData = newsArray[currentArticleIndex].media[currentFsImageIndex].bigImgBmpData;
			if (bmpData != null) drawFullscreenImage(container, bmpData);
		}
		
	/****************************************************************************************************/
	//	Function. Draws a fullscreen image.
		
		private function drawFullscreenImage(container:Sprite, bmpData:*):void {
			var media:Sprite = container.getChildByName("media") as Sprite;
			var max_width:uint, max_height:uint, new_width:uint, new_height:uint, new_x:uint, new_y:uint;
			max_width = stage.stageWidth;
			max_height = stage.stageHeight - 2*BIG_IMAGE_YOFFSET;
			new_width = bmpData.width;
			new_height = bmpData.height;
			new_x = Math.round((stage.stageWidth - bmpData.width)/2);
			new_y = Math.round((stage.stageHeight - bmpData.height)/2);
			var bmp_matrix:Matrix = new Matrix();
			if (bmpData.width > max_width || bmpData.height > max_height) {
				var sx:Number = max_width/bmpData.width;
				var sy:Number = max_height/bmpData.height;
				bmp_matrix.scale(Math.min(sx,sy), Math.min(sx,sy));
				if (sx >= sy) {
					new_height = max_height;
					new_width = Math.round(new_height*bmpData.width/bmpData.height);
					new_x = Math.round((stage.stageWidth - new_width)/2);
					new_y = BIG_IMAGE_YOFFSET;
				}
				if (sy > sx) {
					new_width = max_width;
					new_height = Math.round(new_width*bmpData.height/bmpData.width);
					new_x = 0;
					new_y = Math.round((stage.stageHeight - new_height)/2);
				}
			}
			with (media.graphics) {
				beginBitmapFill(bmpData, bmp_matrix, true, true);
				lineTo(new_width, 0);
				lineTo(new_width, new_height);
				lineTo(0, new_height);
				lineTo(0, 0);
				endFill();
			}
			media.x = new_x;
			media.y = new_y;
			Tweener.addTween(media, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
		}

	/****************************************************************************************************/
	//	Function. Performs a number of actions for deactivating the module.
	//	Called from the pageContentClosed() function of the WebsiteTemplate class.

		public function killModule():void {
			
			stage.removeEventListener(Event.RESIZE, onStageResized);
			Utils.removeTweens(main);
			if (scrollerObj != null) {
				scrollerObj.destroyScroller();
				scrollerObj = null;
			}
			for (var i=1; i<=8; i++) {
				if (this["scrollerObj"+i]) {
					this["scrollerObj"+i].destroyScroller();
					this["scrollerObj"+i] = null;
				}
			}
			if (vpObj != null) {
				vpObj.killVideoPlayer();
				vpObj = null;
			}
			if (fsimg != null) {
				__root.gallery_container.removeChild(fsimg);
				fsimg = null;
			}
			if (fullscreen_bg != null) {
				__root.gallery_container.removeChild(fullscreen_bg);
				fullscreen_bg = null;
			}
			if (main != null) {
				removeChild(main);
				main = null;
			}
		}
		
	/****************************************************************************************************/
	
	}
}