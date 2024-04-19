/**
	Portfolio class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.portfolio {
	
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

	public class Portfolio extends Sprite {
		
		public var main:Sprite, menu:Sprite, controls:Sprite, previews:Sprite, project:Sprite, videoplayer:Sprite;
		public var currentCategoryIndex:uint = 0;
		public var currentProjectIndex:Number;
		public var currentMediaIndex:Number;
		public var categoriesArray:Array, itemsArray:Array;
		public var __root:*;
		public var controls_blocked:Boolean = false;
		public var menu_blocked:Boolean = false;
		public var killcache_str:String;
		public var killCachedFiles:Boolean = false;
		
		private var xml_URL:String;
		private var xmlLoader:URLLoader;
		private var dataXML:XML;
		private var XMLParserObj:Object, menuObj:Object, tnbarObj:Object, scrollerObj:Object, vpObj:Object;
		private var imageLoader1:Loader, imageLoader2:Loader, imageLoader3:Loader, imageLoader4:Loader, imageLoader5:Loader, imageLoader6:Loader, imageLoader7:Loader, imageLoader8:Loader, imageLoader9:Loader, imageLoader10:Loader;
		private var imageLoader11:Loader, imageLoader12:Loader, imageLoader13:Loader, imageLoader14:Loader, imageLoader15:Loader, imageLoader16:Loader, imageLoader17:Loader, imageLoader18:Loader, imageLoader19:Loader, imageLoader20:Loader;
		private var imageLoader21:Loader, imageLoader22:Loader, imageLoader23:Loader, imageLoader24:Loader, imageLoader25:Loader, imageLoader26:Loader, imageLoader27:Loader, imageLoader28:Loader, imageLoader29:Loader, imageLoader30:Loader;
		private var imageLoader31:Loader, imageLoader32:Loader, imageLoader33:Loader, imageLoader34:Loader, imageLoader35:Loader, imageLoader36:Loader, imageLoader37:Loader, imageLoader38:Loader, imageLoader39:Loader, imageLoader40:Loader;
		private var previewImgsLoader:Loader, bigImageLoader:Loader;
		private var textStyleSheet:StyleSheet;
		private var currentPreviewImgIndex:uint;
		private var previews_on_page:uint;
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
		public var previewsInCol:uint = 2;
		public var previewsTopMargin:uint = 0;
		public var previewWidth:uint = 325;
		public var previewHeight:uint = 200;
		public var previewSpacing:uint = 1;
		
		public var previewBgColor:Number;
		public var previewBgAlpha:Number;
		public var previewOverBgColor:Number;
		public var previewBorderColor:Number;
		public var previewBorderThickness:uint;
		public var previewOverBorderColor:Number;
		public var previewShadowColor:Number;
		public var previewShadowAlpha:Number;
		public var previewPadding:uint = 0;
		public var previewPreloaderColor:Number;
		public var previewPreloaderAlpha:Number;
		public var previewCaptionFontColor:Number;
		public var previewCaptionOverFontColor:Number;
		public var previewCaptionBgColor:uint = 0xFFFFFF;
		public var previewCaptionBgAlpha:Number = 0;
		public var previewCaptionOverBgColor:uint = 0xFFFFFF;
		public var previewCaptionOverBgAlpha:Number = 0;
		public var previewCaptionBlurredBg:Boolean = true;
		public var previewCaptionBgBlurAmount:uint;
		public var previewCaptionTopBottomPadding:uint = 0;
		public var previewCaptionLeftRightPadding:uint = 0;
		public var previewOverBrightness:Number = 0;		
		
		// Project controls properties
		public var projectAreaYPosition:uint = 0;
		public var projectHeaderHeight:uint = 0;
		public var projectAlign:String = "left";
		public var projectControlsRightMargin:uint = 0;
		public var projectListButtonURL:String;
		public var projectLeftNavButtonURL:String;
		public var projectRightNavButtonURL:String;
		public var projectNavButtonSpacing:uint = 6;
		public var projectButtonColor:uint = 0x999999;
		public var projectButtonOverColor:uint = 0x555555;
		public var projectControlsSeparatorURL:String;
		public var projectControlsSeparatorColor:uint = 0xCCCCCC;
		public var projectTitleTopMargin:uint = 0;
		public var projectContentTopMargin:uint = 0;
		public var showProjectDescription:Boolean = true;
		
		// Project big image properties
		public var bigImageWidth:uint = 560;
		public var bigImageHeight:uint = 315;
		public var bigImageBgColor:Number;
		public var bigImageBgAlpha:Number;
		public var bigImageBorderColor:Number;
		public var bigImageBorderThickness:uint;
		public var bigImagePadding:uint = 0;
		public var bigImageCaptionBgColor:Number;
		public var bigImageCaptionBgAlpha:Number;
		public var bigImageCaptionBlurredBg:Boolean = true;
		public var bigImageCaptionBgBlurAmount:uint;
		public var bigImageCaptionPadding:uint;
		public var bigImagePreloaderColor:Number;
		public var bigImagePreloaderAlpha:Number;
		public var bigImageOverBrightness:Number = 0;
		public var bigImageZoomIconColor:uint = 0x000000;
		public var bigImageZoomIconAlpha:Number = 0;
		public var bigImageZoomIconOverAlpha:Number = 0;
		public var bigImageRightMargin:uint = 0;
		
		// Project thumbnails properties
		public var thumbnailsVisible:uint;
		public var thumbnailsAlign:String = "left";
		public var thumbnailsTopMargin:uint = 0;
		public var thumbnailWidth:uint = 90;
		public var thumbnailHeight:uint = 60;
		public var thumbnailSpacing:uint = 10;
		public var thumbnailBgColor:Number;
		public var thumbnailBgAlpha:Number;
		public var thumbnailBorderColor:Number;
		public var thumbnailSelectedBorderColor:Number;
		public var thumbnailBorderThickness:uint;
		public var thumbnailShadowColor:Number;
		public var thumbnailShadowAlpha:Number;
		public var thumbnailPreloaderColor:Number;
		public var thumbnailPreloaderAlpha:Number;
		public var thumbnailOverBrightness:Number = 0;
		public var thumbnailVideoIconSize:uint = 30;
		public var thumbnailVideoIconColor:uint = 0xFFFFFF;
		public var thumbnailVideoIconAlpha:Number = 0.4;
		public var thumbnailVideoIconOverAlpha:Number = 0.8;
		public var thumbnailsLeftNavButtonURL:String;
		public var thumbnailsRightNavButtonURL:String;
		public var thumbnailsNavButtonColor:uint = 0x757575;
		public var thumbnailsNavButtonOverColor:uint = 0x333333;
		public var thumbnailsNavButtonPadding:uint = 10;
		
		// Single item view properties
		public var overlayBgColor:Number = 0x000000;
		public var overlayBgAlpha:Number = 0.9;
		public var controlsBarBgColor:Number = 0x000000;
		public var controlsBarBgAlpha:Number = 0.5;
		public var buttonIconColor:uint = 0x333333;
		public var buttonIconOverColor:uint = 0xFFFFFF;
		public var buttonBgColor:uint = 0xFEFEFE;
		public var buttonBgOverColor:uint = 0x999999;
		
		// Project video properties
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
		
		// Project description properties
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
		
		public function Portfolio():void {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addChild(main = new Sprite());
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the Portfolio object is added to the Stage.
	
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the SWF file is resized.
		
		private function onStageResized(e:Event):void {
			if (scrollerObj != null) {
				var blocks:Sprite = project.getChildByName("blocks") as Sprite;
				blocks.y = blocks_yPos;
				var mask_h:uint = stage.stageHeight - __root.page_content.y - __root.module_container.y - project.y - blocks_yPos - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
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
			previews_on_page = previewsInRow * previewsInCol;
			categoriesArray = XMLParserObj.categoryNodesParser(dataXML); // processing "category" nodes
			if (showCategoryMenu && categoriesArray.length > 1) {
				main.addChild(menu = new Sprite());
				menuObj = new Menu(this, textStyleSheet);
			}
			createProjectArea();
			if (__root != null) createSingleItemArea();
			createPreviewItems(currentCategoryIndex);
			if (__root != null) __root.openNewPage(); // calls the openNewPage() function of the WebsiteTemplate class
		}
		
		private function xmlDataError(e:IOErrorEvent):void {
			xmlLoader.removeEventListener(Event.COMPLETE, xmlDataProcessing);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlDataError);
		}
		
	/****************************************************************************************************/
	//	Function. Builds portfolio items previews.
	
		public function createPreviewItems(category_index:uint):void {
			itemsArray = XMLParserObj.categoryNodeParser(dataXML.category[category_index]); // processing a "category" node
			
			if (previews_on_page > 0) {
				current_page = 1;
				currentProjectIndex = currentMediaIndex = NaN;
				loadPreviewImgs();
				createPreviewsControls();
				if (previews == null) {
					main.addChild(previews = new Sprite());
					previews.x = 0;
					previews.y = previewsControlsYPosition + Math.ceil(controls.height) + previewsTopMargin;
				}
				controls_blocked = false;
				
				var border_thickness:uint = 0;
				if (!isNaN(previewBorderColor) && previewBorderThickness > 0) border_thickness = previewBorderThickness;
				preview_width = previewWidth + 2*previewPadding + 2*border_thickness;
				preview_height = previewHeight + 2*previewPadding + 2*border_thickness;
				
				if (previews.numChildren == 0) {

					var container_xPos:uint = 0;
					var container_yPos:uint = 0;
					var container_mask:Shape, base:Shape, shadow_base:Shape, bg:Shape, blurred_bg_mask:Shape;
					var container:Sprite, img:Sprite, blurred_bg:Sprite, caption:Sprite, hitarea:Sprite;
					if (!isNaN(previewShadowColor) && !isNaN(previewShadowAlpha)) {
						var df:DropShadowFilter = new DropShadowFilter();
						df.color = previewShadowColor;
						df.alpha = previewShadowAlpha;
						df.distance = 0;
						df.angle = 0;
						df.quality = imageShadowQuality;
						df.blurX = df.blurY = imageShadowBlur;
						df.strength = imageShadowStrength;
						df.knockout = true;
						var dfArray:Array = new Array();
						dfArray.push(df);
					}
					
					for (var i=1; i<=previews_on_page; i++) {
						container = new Sprite();
						container.name = "container"+i;
						container.x = container_xPos;
						container.y = container_yPos;
						previews.addChild(container);
						container.addChild(container_mask = new Shape());
						container_mask.name = "mask";
						container.mask = container_mask;
						container.addChild(shadow_base = new Shape());
						shadow_base.name = "shadow_base";
						container.addChild(bg = new Shape());
						bg.name = "bg";
						hitarea = new Sprite();
						container.addChild(hitarea);
						hitarea.mouseEnabled = false;
						container.addChild(img = new Sprite());
						img.name = "img";
						img.buttonMode = true;
						img.addEventListener(MouseEvent.CLICK, previewImageClickListener);
						img.hitArea = hitarea;
						container.addChild(blurred_bg = new Sprite());
						blurred_bg.name = "blurred_bg";
						blurred_bg.mouseEnabled = false;
						container.addChild(blurred_bg_mask = new Shape());
						blurred_bg_mask.name = "blurred_bg_mask";
						blurred_bg.cacheAsBitmap = blurred_bg_mask.cacheAsBitmap = true;
						blurred_bg.mask = blurred_bg_mask;
						container.addChild(caption = new Sprite());
						caption.name = "caption";
						caption.mouseEnabled = caption.mouseChildren = false;
						container.addChild(base = new Shape());
						base.name = "base";
						
						// Preview background, border and shadow
						if (!isNaN(previewBgColor) && !isNaN(previewBgAlpha)) {
							Geom.drawRectangle(bg, previewWidth+2*previewPadding, previewHeight+2*previewPadding, previewBgColor, previewBgAlpha);
						}
						if (!isNaN(previewShadowColor) && !isNaN(previewShadowAlpha)) {
							Geom.drawRectangle(shadow_base, preview_width, preview_height, 0xFFFFFF, 1);
							shadow_base.filters = dfArray;
						}
						if (!isNaN(previewBorderColor) && previewBorderThickness > 0) {
							Geom.drawBorder(base, previewWidth, previewHeight, previewBorderColor, 1, previewBorderThickness, previewPadding);
						}
						Geom.drawRectangle(hitarea, preview_width, preview_height, 0xFF9900, 0);
						Geom.drawRectangle(container_mask, preview_width+40, preview_height+40, 0xFF9900, 0, 0, 0, 0, 0, -20, -20);
						
						bg.x = bg.y = border_thickness;
						img.x = img.y = blurred_bg.x = blurred_bg.y = blurred_bg_mask.x = caption.x = border_thickness + previewPadding;
						base.x = base.y = border_thickness + previewPadding;
						
						// Preview caption
						var tf:TextField = new TextField();
						tf.name = "tf";
						caption.addChild(tf);
						tf.x = previewCaptionLeftRightPadding;
						tf.y = previewCaptionTopBottomPadding;
						if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
						tf.width = previewWidth - 2*previewCaptionLeftRightPadding;
						tf.autoSize = TextFieldAutoSize.LEFT;
						tf.multiline = true;
						tf.wordWrap = true;
						tf.embedFonts = true;
						tf.selectable = false;
						tf.antiAliasType = AntiAliasType.ADVANCED;
						tf.visible = false;
						var caption_bg:Shape = new Shape();
						caption_bg.name = "bg";
						caption.addChild(caption_bg);
						var tf_bmp:Sprite = new Sprite();
						tf_bmp.name = "tf_bmp";
						caption.addChild(tf_bmp);
						tf_bmp.x = previewCaptionLeftRightPadding;
						tf_bmp.y = previewCaptionTopBottomPadding;
						
						if (i/previewsInRow % 1 == 0) {
							container_xPos = 0;
							container_yPos += preview_height + previewSpacing;
							if (previewSpacing == 0) container_yPos -= border_thickness;
						} else {
							container_xPos += preview_width + previewSpacing;
							if (previewSpacing == 0) container_xPos -= border_thickness;
						}
						
						// Preview image loader
						if (this["imageLoader"+i] != null) {
							var imageLoader:Loader = this["imageLoader"+i];
							imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, previewImageLoadComplete);
							imageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, previewImageLoadError);
							imageLoader = null;
						}
						this["imageLoader"+i] = new Loader();
					}
				}
				changePreviews(current_page);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Changes portfolio items previews (currently visible).
	
		private function changePreviews(page:uint):void {
			
			// *** Changing selected buttons
			if (controls) {
				for (var j=1; j<=Math.ceil(itemsArray.length/previews_on_page); j++) {
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
			
			// *** Changing images and caption text
			for (var i=1; i<=previews_on_page; i++) {
				var index:uint = (page-1)*previews_on_page + (i-1);
				var container:Sprite = previews.getChildByName("container"+i) as Sprite;
				
				var bg:Shape = container.getChildByName("bg") as Shape;
				var img:Sprite = container.getChildByName("img") as Sprite;
				var blurred_bg:Sprite = container.getChildByName("blurred_bg") as Sprite;
				var blurred_bg_mask:Shape = container.getChildByName("blurred_bg_mask") as Shape;
				var caption:Sprite = container.getChildByName("caption") as Sprite;
				var base:Shape = container.getChildByName("base") as Shape;
				var preloader:MovieClip;
				
				Tweener.removeTweens(img);
				Tweener.removeTweens(blurred_bg);
				Tweener.removeTweens(caption);
				
				img.graphics.clear();
				blurred_bg.graphics.clear();
				blurred_bg_mask.graphics.clear();
				if (caption.getChildByName("bg")) {
					var caption_bg:Shape = caption.getChildByName("bg") as Shape;
					Tweener.removeTweens(caption_bg);
					caption_bg.graphics.clear();
				}
				if (caption.getChildByName("tf")) {
					var tf:TextField = caption.getChildByName("tf") as TextField;
					tf.htmlText = "";
				}
				if (caption.getChildByName("tf_bmp")) {
					var tf_bmp:Sprite = caption.getChildByName("tf_bmp") as Sprite;
					Tweener.removeTweens(tf_bmp);
					tf_bmp.graphics.clear();
				}
				if (container.getChildByName("preloader")) {
					preloader = container.getChildByName("preloader") as MovieClip;
					Tweener.removeTweens(preloader);
					container.removeChild(preloader);
				}
				img.alpha = blurred_bg.alpha = caption.alpha = 0;
				
				var imageLoader:Loader = this["imageLoader"+i];
				imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, previewImageLoadComplete);
				imageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, previewImageLoadError);
				try { imageLoader.close(); }
				catch(error:Error){};
				imageLoader.unload();
				
				if (index < itemsArray.length) {
					container.visible = true;
					if (itemsArray[index].previewBmpData == undefined) {
						if (itemsArray[index].previewSrc != undefined) {
							if (!isNaN(previewPreloaderColor) && !isNaN(previewPreloaderAlpha)) {
								preloader = new img_preloader();
								preloader.name = "preloader";
								container.addChild(preloader);
								preloader.x = Math.round((preview_width-preloader.width)/2);
								preloader.y = Math.round((preview_height-preloader.height)/2);
								var preloaderColor:ColorTransform = preloader.transform.colorTransform;
								preloaderColor.color = previewPreloaderColor;
								preloader.transform.colorTransform = preloaderColor;
								preloader.alpha = previewPreloaderAlpha;
							}
							imageLoader.name = "imageLoader_"+index+"_"+i;
							imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, previewImageLoadComplete);
							imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, previewImageLoadError);
							imageLoader.load(new URLRequest(itemsArray[index].previewSrc+(killCachedFiles?killcache_str:'')));
						} else {
							itemsArray[index].previewBmpData = "no";
						}
					} else {
						drawPreviewImage(container, itemsArray[index].previewBmpData, index);
					}
				} else {
					container.visible = false;
				}
			}
		}
		
	/****************************************************************************************************/
	//	Functions. Handles events on loading of preview images of portfolio items.
		
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
				if (itemsArray[index].previewBmpData == undefined) itemsArray[index].previewBmpData = bmpData;
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
				if (itemsArray[index].previewBmpData == undefined) itemsArray[index].previewBmpData = "no";
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
			var blurred_bg:Sprite = container.getChildByName("blurred_bg") as Sprite;
			var caption:Sprite = container.getChildByName("caption") as Sprite;
			
			if (bmpData != "no") {
				var bmp_matrix:Matrix = new Matrix();
				var img_width:uint, img_height:uint;
				if (bmpData.width > previewWidth || bmpData.height > previewHeight) {
					var sx:Number = previewWidth/bmpData.width;
					var sy:Number = previewHeight/bmpData.height;
					bmp_matrix.scale(Math.max(sx,sy), Math.max(sx,sy));
					if (sy > sx) bmp_matrix.tx = -0.5*(bmpData.width*sy-previewWidth);
					if (sx > sy) bmp_matrix.ty = -0.5*(bmpData.height*sx-previewHeight);
					img_width = previewWidth;
					img_height = previewHeight;
				} else {
					img_width = bmpData.width;
					img_height = bmpData.height;
				}
				with (img.graphics) {
					beginBitmapFill(bmpData, bmp_matrix, true, true);
					lineTo(img_width, 0);
					lineTo(img_width, img_height);
					lineTo(0, img_height);
					lineTo(0, 0);
					endFill();
				}
				Tweener.addTween(img, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
				if (!(previewOverBrightness == 0 && itemsArray[index].previewCaption == undefined)) {
					Image.drawPreviewCaption(container,
											previewWidth,
											previewHeight,
											bmpData,
											itemsArray[index].previewCaption,
											textStyleSheet,
											previewCaptionFontColor,
											previewCaptionOverFontColor,
											previewCaptionBgColor,
											previewCaptionBgAlpha,
											previewCaptionOverBgColor,
											previewCaptionOverBgAlpha,
											previewCaptionBlurredBg,
											previewCaptionBgBlurAmount,
											previewCaptionTopBottomPadding,
											previewOverBrightness,
											0.6,
											previewBgColor,
											previewOverBgColor,
											previewBorderColor,
											previewOverBorderColor);
					Tweener.addTween(blurred_bg, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
					Tweener.addTween(caption, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
				}
			}
		}

	/****************************************************************************************************/
	//	Function. Builds the controls (navigation buttons) of portfolio previews.
		
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
			
			for (var i=1; i<=Math.ceil(itemsArray.length/previews_on_page); i++) {
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
			
			if (itemsArray.length > previews_on_page) controls.visible = true;
			else controls.visible = false;
			Tweener.addTween(controls, {alpha:1, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
		}
		
	/****************************************************************************************************/
	//	Function. Loads preview images of portfolio items one by one (in background mode).
		
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
			for (var i=0; i<itemsArray.length; i++) {
				if (itemsArray[i].previewSrc != undefined) {
					if (itemsArray[i].previewBmpData == undefined) {
						currentPreviewImgIndex = i;
						previewImgsLoader.load(new URLRequest(itemsArray[i].previewSrc+(killCachedFiles?killcache_str:'')));
						break;
					}
				} else itemsArray[i].previewBmpData = "no";
			}
		}
		
		private function previewImgsLoadProcessing(e:Event):void {
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			var bmpData:BitmapData = bmp.bitmapData;
			if (itemsArray[currentPreviewImgIndex].previewBmpData == undefined) itemsArray[currentPreviewImgIndex].previewBmpData = bmpData;
			currentPreviewImgIndex++;
			for (var i=currentPreviewImgIndex; i<itemsArray.length; i++) {
				if (itemsArray[i].previewBmpData != undefined) {
					currentPreviewImgIndex++;
				} else {
					if (itemsArray[i].previewSrc != undefined) {
						previewImgsLoader.load(new URLRequest(itemsArray[i].previewSrc+(killCachedFiles?killcache_str:'')));
						break;
					} else {
						itemsArray[i].previewBmpData = "no";
						currentPreviewImgIndex++;
					}
				}
			}
			if (currentPreviewImgIndex >= itemsArray.length) {
				e.target.removeEventListener(Event.COMPLETE, previewImgsLoadProcessing);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, previewImgsLoadError);
			}
		}
		
		private function previewImgsLoadError(e:IOErrorEvent):void {
			itemsArray[currentPreviewImgIndex].previewBmpData = "no";
			currentPreviewImgIndex++;
			for (var i=currentPreviewImgIndex; i<itemsArray.length; i++) {
				if (itemsArray[i].previewBmpData != undefined) {
					currentPreviewImgIndex++;
				} else {
					if (itemsArray[i].previewSrc != undefined) {
						previewImgsLoader.load(new URLRequest(itemsArray[i].previewSrc+(killCachedFiles?killcache_str:'')));
						break;
					} else {
						itemsArray[i].previewBmpData = "no";
						currentPreviewImgIndex++;
					}
				}
			}
			if (currentPreviewImgIndex >= itemsArray.length) {
				e.target.removeEventListener(Event.COMPLETE, previewImgsLoadProcessing);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, previewImgsLoadError);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Preview image click listener.
	
		private function previewImageClickListener(e:MouseEvent):void {
			controls_blocked = menu_blocked = true;
			var container_index:uint = uint(e.target.parent.name.substr(9));
			var index:uint = (current_page-1)*previews_on_page + (container_index-1);
			if (index != currentProjectIndex) {
				currentProjectIndex = index;
				changeProject();
			}
			applyBlinds("hide");
		}
		
	/****************************************************************************************************/
	//	Function. Hides/reveals the portfolio preview images and controls.
	
		public function applyBlinds(val:String):void {
			var container:Sprite;
			var container_mask:Shape;
			var index:uint;
			if (val == "hide") {
				for (var i=1; i<=previews_on_page; i++) {
					index = (current_page-1)*previews_on_page + (i-1);
					container = previews.getChildByName("container"+i) as Sprite;
					container_mask = container.getChildByName("mask") as Shape;
					Tweener.addTween(container_mask, {height:0, y:Math.round(previewHeight/2), time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart"});
				}
				Tweener.addTween(controls, {alpha:0, time:PREVIEW_BLIND_DURATION, transition:"easeOutQuart", onComplete:
					function() {
						controls.visible = previews.visible = false;
						project.alpha = 0;
						project.visible = true;
						Tweener.addTween(project, {alpha:1, time:FADE_DURATION-0.2, transition:"easeInOutSine", onComplete:
							function() {
								controls_blocked = menu_blocked = false;
							}
						});
					}
				});
			}
			if (val == "reveal") {
				Tweener.removeTweens(controls);
				previews.visible = true;
				Tweener.addTween(project, {alpha:0, time:FADE_DURATION-0.2, transition:"easeInOutSine", onComplete:
					function() {
						project.visible = false;
						for (var i=1; i<=previews_on_page; i++) {
							index = (current_page-1)*previews_on_page + (i-1);
							container = previews.getChildByName("container"+i) as Sprite;
							container_mask = container.getChildByName("mask") as Shape;
							var mask_height:uint = preview_height + 40;
							Tweener.addTween(container_mask, {height:mask_height, y:0, time:PREVIEW_BLIND_DURATION, transition:"easeOutSine"});
						}
						Tweener.addTween(controls, {alpha:1, time:PREVIEW_BLIND_DURATION, transition:"easeOutSine", onComplete:
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
	//	Function. Builds the project area.
	
		private function createProjectArea():void {
			
			var controls:Sprite, separator:Sprite, container:Sprite, media:Sprite, blurred_bg:Sprite, caption:Sprite, title:Sprite;
			var base:Shape, bg:Shape, title_mask:Shape, separator_mask:Shape, blurred_bg_mask:Shape, caption_mask:Shape;
			var hover_icon:MovieClip;
			var tf:TextField;
			main.addChild(project = new Sprite());
			project.y = projectAreaYPosition;
			var module_width:uint;
			if (__root != null) module_width = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin;
			else module_width = 980;
			if (showProjectDescription == false) {
				switch (projectAlign) {
					case "center":
						project.x = Math.floor((module_width-bigImageWidth)/2);
					break;
					case "right":
						project.x = module_width - bigImageWidth;
				}
			}
			project.visible = false;
			
			// *** Big image/video
			project.addChild(container = new Sprite());
			container.name = "container";
			container.y = projectHeaderHeight;
			var border_thickness:uint = 0;
			container.addChild(bg = new Shape());
			bg.name = "bg";
			container.addChild(media = new Sprite());
			media.name = "media";
			container.addChild(blurred_bg = new Sprite());
			blurred_bg.name = "blurred_bg";
			blurred_bg.mouseEnabled = false;
			container.addChild(blurred_bg_mask = new Shape());
			blurred_bg_mask.name = "blurred_bg_mask";
			blurred_bg.mask = blurred_bg_mask;
			container.addChild(caption = new Sprite());
			caption.name = "caption";
			caption.mouseEnabled = caption.mouseChildren = false;
			container.addChild(caption_mask = new Shape());
			Geom.drawRectangle(caption_mask, bigImageWidth, bigImageHeight, 0xFF9900, 0);
			caption.mask = caption_mask;
			hover_icon = new zoom_mc();
			container.addChild(hover_icon);
			hover_icon.mouseEnabled = false;
			hover_icon.visible = false;
			hover_icon.name = "hover_icon";
			container.addChild(base = new Shape());
			base.name = "base";
			if (!isNaN(bigImageBgColor) && !isNaN(bigImageBgAlpha)) {
				Geom.drawRectangle(bg, bigImageWidth+2*bigImagePadding, bigImageHeight+2*bigImagePadding, bigImageBgColor, bigImageBgAlpha);
			}
			if (!isNaN(bigImageBorderColor) && bigImageBorderThickness > 0) {
				border_thickness = bigImageBorderThickness;
				Geom.drawBorder(base, bigImageWidth, bigImageHeight, bigImageBorderColor, 1, bigImageBorderThickness, bigImagePadding);
			}
			bg.x = bg.y = border_thickness;
			media.x = media.y = base.x = base.y = border_thickness + bigImagePadding;
			blurred_bg.x = blurred_bg.y = blurred_bg_mask.x = caption.x = caption_mask.x = caption_mask.y = border_thickness + bigImagePadding;
			bigImageLoader = new Loader();
			
			// Image caption
			tf = new TextField();
			tf.name = "tf";
			caption.addChild(tf);
			tf.x = tf.y = bigImageCaptionPadding;
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.width = bigImageWidth - 2*bigImageCaptionPadding;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.embedFonts = true;
			tf.selectable = false;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.visible = false;
			var tf_bmp:Sprite = new Sprite();
			tf_bmp.name = "tf_bmp";
			caption.addChild(tf_bmp);
			tf_bmp.x = tf_bmp.y = bigImageCaptionPadding;
			
			// *** Controls
			project.addChild(controls = new Sprite());
			controls.name = "controls";
			var list_but:Sprite = new Sprite();
			controls.addChild(list_but);
			list_but.name = "list_but";
			list_but.visible = false;
			if (projectListButtonURL != null) {
				var listButLoader:Loader = new Loader();
				listButLoader.name = "list";
				listButLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, navButLoadComplete);
				listButLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
				listButLoader.load(new URLRequest(projectListButtonURL+(killCachedFiles?killcache_str:'')));
				list_but.buttonMode = true;
			}
			
			var nav_but1:Sprite = new Sprite();
			controls.addChild(nav_but1);
			nav_but1.name = "nav_but1";
			var nav_but2:Sprite = new Sprite();
			controls.addChild(nav_but2);
			nav_but2.name = "nav_but2";
			nav_but1.visible = nav_but2.visible = false;
			if (projectLeftNavButtonURL != null && projectRightNavButtonURL != null) {
				var navBut1Loader:Loader = new Loader();
				navBut1Loader.name = "left";
				navBut1Loader.contentLoaderInfo.addEventListener(Event.COMPLETE, navButLoadComplete);
				navBut1Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
				navBut1Loader.load(new URLRequest(projectLeftNavButtonURL+(killCachedFiles?killcache_str:'')));
				var navBut2Loader:Loader = new Loader();
				navBut2Loader.name = "right";
				navBut2Loader.contentLoaderInfo.addEventListener(Event.COMPLETE, navButLoadComplete);
				navBut2Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
				navBut2Loader.load(new URLRequest(projectRightNavButtonURL+(killCachedFiles?killcache_str:'')));
			}
			
			if (projectControlsSeparatorURL != null && showProjectDescription) {
				project.addChild(separator = new Sprite());
				project.addChild(separator_mask = new Shape());
				separator.name = "separator";
				separator.x = separator_mask.x = bigImageWidth + bigImageRightMargin;
				separator.y = separator_mask.y = projectHeaderHeight + bigImagePadding + border_thickness;
				var sep_mask_width:uint;
				if (__root != null) sep_mask_width = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - separator.x;
				else sep_mask_width = 980 - separator.x;
				Geom.drawRectangle(separator_mask, sep_mask_width, 5, 0xFF9900, 0);
				separator.mask = separator_mask;
				var separatorLoader:Loader = new Loader();
				separatorLoader.load(new URLRequest(projectControlsSeparatorURL+(killCachedFiles?killcache_str:'')));
				separator.addChild(separatorLoader);
				var separatorColor:ColorTransform = separator.transform.colorTransform;
				separatorColor.color = projectControlsSeparatorColor;
				separator.transform.colorTransform = separatorColor;
			}
			
			// *** Title
			project.addChild(title = new Sprite());
			title.name = "title";
			tf = new TextField();
			tf.name = "tf";
			title.addChild(tf);
			project.addChild(title_mask = new Shape());
			title_mask.name = "title_mask";
			Geom.drawRectangle(title_mask, 10, 10, 0xFF9900, 0);
			title.mask = title_mask;
			var tf_width:uint;
			if (showProjectDescription) {
				title.x = title_mask.x = bigImageWidth + bigImageRightMargin;
				title.y = title_mask.y = projectHeaderHeight + projectTitleTopMargin;
				if (__root != null) tf_width = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - title.x;
				else tf_width = 980 - title.x;
			} else {
				title.x = title_mask.x = 0;
				title.y = title_mask.y = projectTitleTopMargin;
				tf_width = bigImageWidth;
			}
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.width = tf_width;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.embedFonts = true;
			tf.selectable = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			
			// *** Description
			blocks_xPos = bigImageWidth + bigImageRightMargin;
			
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
			var controls:Sprite = project.getChildByName("controls") as Sprite;
			var nav_but:Sprite = controls.getChildByName(button_name) as Sprite;
			var title:Sprite = project.getChildByName("title") as Sprite;
			var tf:TextField = title.getChildByName("tf") as TextField;
			var bmp:Bitmap = Bitmap(e.target.content);
			var hitarea:Sprite = new Sprite();
			nav_but.addChild(hitarea);
			Geom.drawRectangle(hitarea, bmp.width+2*NAV_BUTTON_ICON_PADDING, bmp.height+2*NAV_BUTTON_ICON_PADDING, 0xFF9900, 0);
			nav_but.hitArea = hitarea;
			nav_but.addChild(bmp);
			bmp.x = bmp.y = NAV_BUTTON_ICON_PADDING;
			var navButColor:ColorTransform = nav_but.transform.colorTransform;
			navButColor.color = projectButtonColor;
			nav_but.transform.colorTransform = navButColor;
			nav_but.addEventListener(MouseEvent.ROLL_OVER,
				function(e:MouseEvent) {
					if (nav_but.alpha == 1) {
						Tweener.removeTweens(nav_but);
						Tweener.addTween(nav_but, {_color:projectButtonOverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
				}
			);
			nav_but.addEventListener(MouseEvent.ROLL_OUT,
				function(e:MouseEvent) {
					if (nav_but.alpha == 1) {
						Tweener.removeTweens(nav_but);
						Tweener.addTween(nav_but, {_color:projectButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
				}
			);
			nav_but.addEventListener(MouseEvent.CLICK,
				function(e:MouseEvent) {
					if (!controls_blocked) {
						if (button == "left" && currentProjectIndex > 0) {
							controls_blocked = true;
							currentProjectIndex--;
							changeProject();
							if (currentProjectIndex == 0) Tweener.addTween(nav_but, {_color:projectButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
						} else if (button == "right" && currentProjectIndex < itemsArray.length-1) {
							controls_blocked = true;
							currentProjectIndex++;
							changeProject();
							if (currentProjectIndex == itemsArray.length-1) Tweener.addTween(nav_but, {_color:projectButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
						} else if (button == "list") {
							controls_blocked = menu_blocked = true;
							var ctrls:Sprite = main.getChildByName("controls") as Sprite;
							ctrls.alpha = 0;
							if (itemsArray.length > previews_on_page) ctrls.visible = true;
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
				list_but.x = nav_but1.width + projectNavButtonSpacing;
				nav_but2.x = list_but.x + list_but.width + projectNavButtonSpacing;
				if (showProjectDescription) {
					if (__root != null) controls.x = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - projectControlsRightMargin - controls.width;
					else controls.x = 980 - projectControlsRightMargin - controls.width;
				} else {
					controls.x = bigImageWidth - projectControlsRightMargin - controls.width;
					tf.width = controls.x - 20;
				}
			}
		}
		
		private function navButLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, navButLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
		}
		
	/****************************************************************************************************/
	//	Function. Changes a portfolio project (currently selected portfolio item).
	
		private function changeProject():void {
			var title:Sprite = project.getChildByName("title") as Sprite;
			var title_mask:Shape = project.getChildByName("title_mask") as Shape;
			var tf:TextField = title.getChildByName("tf") as TextField;
			var container:Sprite = project.getChildByName("container") as Sprite;
			var media:Sprite = container.getChildByName("media") as Sprite;
			var base:Shape = container.getChildByName("base") as Shape;
			var controls:Sprite = project.getChildByName("controls") as Sprite;
			var nav_but1:Sprite = controls.getChildByName("nav_but1") as Sprite;
			var nav_but2:Sprite = controls.getChildByName("nav_but2") as Sprite;
			
			// Controls
			if (currentProjectIndex == 0) { nav_but1.buttonMode = false; nav_but1.alpha = 0.7; }
			else { nav_but1.buttonMode = true; nav_but1.alpha = 1; }
			if (currentProjectIndex == itemsArray.length-1) { nav_but2.buttonMode = false; nav_but2.alpha = 0.7; }
			else { nav_but2.buttonMode = true; nav_but2.alpha = 1; }
			
			// Title
			title.alpha = 0;
			if (itemsArray[currentProjectIndex].title != undefined) tf.htmlText = itemsArray[currentProjectIndex].title;
			else tf.htmlText = "";
			title_mask.width = 0;
			title_mask.height = title.height;
			Tweener.removeTweens(title);
			Tweener.removeTweens(title_mask);
			Tweener.addTween(title, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
			Tweener.addTween(title_mask, {width:title.width, time:0.5*FADE_DURATION, transition:"easeInOutQuad"});
			
			// Thumbnail bar
			if (tnbarObj != null) {
				tnbarObj.destroyThumbnailBar();
				tnbarObj = null;
			}
			tnbarObj = new ThumbnailBar(this, currentProjectIndex, itemsArray[currentProjectIndex].media);
			
			// Big image/video
			currentMediaIndex = 0;
			changeMedia();
			tnbarObj.changePushedThumbnail(currentMediaIndex);
			
			// Description
			if (showProjectDescription) {
				var blocks:Sprite;
				if (project.getChildByName("blocks") != null) {
					if (scrollerObj != null) {
						scrollerObj.destroyScroller();
						scrollerObj = null;
					}
					blocks = project.getChildByName("blocks") as Sprite;
					Tweener.removeTweens(blocks);
					project.removeChild(blocks);
				}
				project.addChild(blocks = new Sprite());
				blocks.name = "blocks";
				blocks_yPos = projectHeaderHeight + (tf.htmlText != ""?projectTitleTopMargin+Math.ceil(title.height):0) + projectContentTopMargin;
				blocks.x = blocks_xPos;
				blocks.y = blocks_yPos;
				blocks.alpha = 0;
				block_yPos = 0;
				if (itemsArray[currentProjectIndex].descriptionBlocks != undefined) {
					for (var i=0; i<itemsArray[currentProjectIndex].descriptionBlocks.length; i++) {
						if (itemsArray[currentProjectIndex].descriptionBlocks[i].type == "text") buildTextBlock(blocks, itemsArray[currentProjectIndex].descriptionBlocks, i);
						if (itemsArray[currentProjectIndex].descriptionBlocks[i].type == "list") buildList(blocks, itemsArray[currentProjectIndex].descriptionBlocks, i);
						if (itemsArray[currentProjectIndex].descriptionBlocks[i].type == "link") buildLink(blocks, itemsArray[currentProjectIndex].descriptionBlocks, i);
						if (itemsArray[currentProjectIndex].descriptionBlocks[i].type == "separator") buildSeparator(blocks, itemsArray[currentProjectIndex].descriptionBlocks, i);
						if (itemsArray[currentProjectIndex].descriptionBlocks[i].type == "table") buildTable(blocks, itemsArray[currentProjectIndex].descriptionBlocks, i);
					}
				}
				attachScroller(); // attach a scroller to the blocks content
				Tweener.addTween(blocks, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
			}
			
			Tweener.addTween(project, {delay:FADE_DURATION, onComplete:function(){controls_blocked = false;}});
		}
		
	/****************************************************************************************************/
	//	Function. Attaches a scroller to the blocks content.
		
		private function attachScroller():void {
			var blocks:Sprite = project.getChildByName("blocks") as Sprite;
			var hitarea:Sprite = new Sprite();
			blocks.addChild(hitarea);
			blocks.hitArea = hitarea;
			hitarea.mouseEnabled = false;
			if (__root != null) {
				var mask_w:uint = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - blocks_xPos;
				var mask_h:uint = stage.stageHeight - __root.page_content.y - __root.module_container.y - project.y - blocks_yPos - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
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
	//	Function. Changes a media item (image or video) of the currently selected portfolio project.
	
		public function changeMedia():void {
			var tnbar:Sprite = project.getChildByName("tnbar") as Sprite;
			var container:Sprite = project.getChildByName("container") as Sprite;
			var media:Sprite = container.getChildByName("media") as Sprite;
			var hover_icon:MovieClip = container.getChildByName("hover_icon") as MovieClip;
			var bg:Shape = container.getChildByName("bg") as Shape;
			var base:Shape = container.getChildByName("base") as Shape;
			var blurred_bg:Sprite = container.getChildByName("blurred_bg") as Sprite;
			var blurred_bg_mask:Shape = container.getChildByName("blurred_bg_mask") as Shape;
			var caption:Sprite = container.getChildByName("caption") as Sprite;
			var preloader:MovieClip;
			Tweener.removeTweens(media);
			Tweener.removeTweens(blurred_bg);
			Tweener.removeTweens(caption);
			bigImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bigImageLoadComplete);
			bigImageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, bigImageLoadError);
			try { bigImageLoader.close(); }
			catch(error:Error){};
			bigImageLoader.unload();
			media.graphics.clear();
			blurred_bg.graphics.clear();
			blurred_bg_mask.graphics.clear();
			caption.graphics.clear();
			media.alpha = 0;
			media.buttonMode = false;
			media.removeEventListener(MouseEvent.CLICK, bigImageClickListener);
			hover_icon.visible = false;
			if (caption.getChildByName("tf")) {
				var tf:TextField = caption.getChildByName("tf") as TextField;
				tf.htmlText = "";
			}
			if (caption.getChildByName("tf_bmp")) {
				var tf_bmp:Sprite = caption.getChildByName("tf_bmp") as Sprite;
				Tweener.removeTweens(tf_bmp);
				tf_bmp.graphics.clear();
			}
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
			if (itemsArray[currentProjectIndex].media) {
				var border_thickness:uint = 0;
				if (!isNaN(bigImageBorderColor) && bigImageBorderThickness > 0) border_thickness = bigImageBorderThickness;
				if (itemsArray[currentProjectIndex].media[currentMediaIndex].type == "image") {
					if (itemsArray[currentProjectIndex].media[currentMediaIndex].bigImgBmpData == undefined) {
						if (itemsArray[currentProjectIndex].media[currentMediaIndex].src != undefined) {
							if (!isNaN(bigImagePreloaderColor) && !isNaN(bigImagePreloaderAlpha)) {
								preloader = new video_preloader();
								preloader.name = "preloader";
								container.addChild(preloader);
								preloader.x = Math.round(bigImageWidth/2) + media.x;
								preloader.y = Math.round(bigImageHeight/2) + media.y;
								preloader.scaleX = preloader.scaleY = 0.7;
								var preloaderColor:ColorTransform = preloader.transform.colorTransform;
								preloaderColor.color = bigImagePreloaderColor;
								preloader.transform.colorTransform = preloaderColor;
								preloader.alpha = bigImagePreloaderAlpha;
							}
							bigImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bigImageLoadComplete);
							bigImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bigImageLoadError);
							bigImageLoader.load(new URLRequest(itemsArray[currentProjectIndex].media[currentMediaIndex].src+(killCachedFiles?killcache_str:'')));
						} else {
							itemsArray[currentProjectIndex].media[currentMediaIndex].bigImgBmpData = "no";
							drawBigImage(container, itemsArray[currentProjectIndex].media[currentMediaIndex].bigImgBmpData);
						}
					} else {
						drawBigImage(container, itemsArray[currentProjectIndex].media[currentMediaIndex].bigImgBmpData);
					}
					base.visible = bg.visible = true;
					tnbar.y = projectHeaderHeight + bigImageHeight + 2*bigImagePadding + 2*border_thickness + thumbnailsTopMargin;
				} else {
					var videoURL:String = itemsArray[currentProjectIndex].media[currentMediaIndex].src;
					var previewImageURL:String = itemsArray[currentProjectIndex].media[currentMediaIndex].previewImage;
					var playbackQuality:String = itemsArray[currentProjectIndex].media[currentMediaIndex].playbackQuality;
					var videoAutoPlay:Boolean = itemsArray[currentProjectIndex].media[currentMediaIndex].autoPlay;
					var videoRatio:String = itemsArray[currentProjectIndex].media[currentMediaIndex].ratio;
					videoPlayerWidth = bigImageWidth;
					videoPlayerHeight = Math.round(videoPlayerWidth * (videoRatio == "16:9" ? 9/16 : 3/4));
					if (itemsArray[currentProjectIndex].media[currentMediaIndex].type == "youtube") {
						vpObj = new VideoPlayerYouTube(this, killCachedFiles, textStyleSheet, videoURL, previewImageURL, playbackQuality, videoAutoPlay);
					} else if (itemsArray[currentProjectIndex].media[currentMediaIndex].type == "video") {
						vpObj = new VideoPlayer(this, killCachedFiles, textStyleSheet, videoURL, previewImageURL, videoAutoPlay);
					}
					if (vpObj != null) {
						videoplayer = vpObj.videoplayer;
						media.addChild(videoplayer);
						videoplayer.name = "videoplayer";
						Tweener.addTween(media, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
					}
					tnbar.y = projectHeaderHeight + videoPlayerHeight + 2*bigImagePadding + 2*border_thickness + thumbnailsTopMargin;
					base.visible = bg.visible = false;
				}
			}
		}
		
	/****************************************************************************************************/
	//	Functions. Handles events on loading of big images of the currently selected portfolio project.
		
		private function bigImageLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, bigImageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, bigImageLoadError);
			var container:Sprite = project.getChildByName("container") as Sprite;
			var media:Sprite = container.getChildByName("media") as Sprite;
			var preloader:MovieClip = container.getChildByName("preloader") as MovieClip;
			if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.7*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[container, preloader]});
			if (!isNaN(currentProjectIndex) && !isNaN(currentMediaIndex)) {
				var bmp:Bitmap = Bitmap(e.target.content);
				bmp.smoothing = false;
				var bmpData:BitmapData = bmp.bitmapData;
				if (itemsArray[currentProjectIndex].media[currentMediaIndex].bigImgBmpData == undefined) itemsArray[currentProjectIndex].media[currentMediaIndex].bigImgBmpData = bmpData;
				drawBigImage(container, bmpData);
			}
		}
		
		private function bigImageLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, bigImageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, bigImageLoadError);
			var container:Sprite = project.getChildByName("container") as Sprite;
			var preloader:MovieClip = container.getChildByName("preloader") as MovieClip;
			if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.7*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[container, preloader]});
			if (!isNaN(currentProjectIndex) && !isNaN(currentMediaIndex)) {
				if (itemsArray[currentProjectIndex].media[currentMediaIndex].bigImgBmpData == undefined) itemsArray[currentProjectIndex].media[currentMediaIndex].bigImgBmpData = "no";
			}
		}
		
	/****************************************************************************************************/
	//	Function. Draws a big image of the currently selected media (image).
		
		private function drawBigImage(container:Sprite, bmpData:*):void {
			var container:Sprite = project.getChildByName("container") as Sprite;
			var media:Sprite = container.getChildByName("media") as Sprite;
			if (bmpData != "no") {
				var smoothing:Boolean = false;
				var bmp_matrix:Matrix = new Matrix();
				if (bmpData.width != bigImageWidth || bmpData.height != bigImageHeight) {
					var sx:Number = bigImageWidth/bmpData.width;
					var sy:Number = bigImageHeight/bmpData.height;
					bmp_matrix.scale(Math.max(sx,sy), Math.max(sx,sy));
					if (sy > sx) bmp_matrix.tx = -0.5*(bmpData.width*sy-bigImageWidth);
					if (sx > sy) bmp_matrix.ty = -0.5*(bmpData.height*sx-bigImageHeight);
					smoothing = true;
				}
				with (media.graphics) {
					beginBitmapFill(bmpData, bmp_matrix, true, smoothing);
					lineTo(bigImageWidth, 0);
					lineTo(bigImageWidth, bigImageHeight);
					lineTo(0, bigImageHeight);
					lineTo(0, 0);
					endFill();
				}
				Tweener.addTween(media, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
				
				var hover_icon:MovieClip = container.getChildByName("hover_icon") as MovieClip;
				var hoverIconColor:ColorTransform = hover_icon.transform.colorTransform;
				hoverIconColor.color = bigImageZoomIconColor;
				hover_icon.transform.colorTransform = hoverIconColor;
				hover_icon.alpha = bigImageZoomIconAlpha;
				hover_icon.x = Math.round((bigImageWidth-hover_icon.width)/2) + media.x;
				hover_icon.y = Math.round((bigImageHeight-hover_icon.height)/2) + media.y;
				
				var image_caption:String = itemsArray[currentProjectIndex].media[currentMediaIndex].caption;
				if (bigImageOverBrightness != 0 || bigImageZoomIconAlpha != 0 || bigImageZoomIconOverAlpha != 0 || image_caption != null) {
					Image.drawCaption(container,
									  bigImageWidth,
									  bigImageHeight,
									  bmpData,
									  image_caption,
									  textStyleSheet,
									  bigImageCaptionBgColor,
									  bigImageCaptionBgAlpha,
									  bigImageCaptionBlurredBg,
									  bigImageCaptionBgBlurAmount,
									  bigImageCaptionPadding,
									  "fade",
									  bigImageOverBrightness,
									  0.6,
									  "hover_icon",
									  bigImageZoomIconOverAlpha,
									  bigImageZoomIconAlpha);
				}
				
				if (bmpData.width > bigImageWidth || bmpData.height > bigImageHeight) {
					media.buttonMode = true;
					media.addEventListener(MouseEvent.CLICK, bigImageClickListener);
					hover_icon.visible = true;
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Big image click listener.
	
		private function bigImageClickListener(e:MouseEvent):void {
			if (__root != null && itemsArray[currentProjectIndex].media[currentMediaIndex].type == "image") {
				controls_blocked = menu_blocked = true;
				currentFsImageIndex = currentMediaIndex;
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
	//	Function. Builds a separator.
	
		private function buildSeparator(blocks:Sprite, blocksArray:Array, index:uint):void {
			var sep_max_width:uint, sep_width:uint;
			var block:Sprite = new Sprite();
			block.x = blocksArray[index].leftMargin;
			block.y = block_yPos + blocksArray[index].topMargin;
			blocks.addChild(block);
			if (__root != null) sep_max_width = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - blocks_xPos - block.x;
			else sep_max_width = 980 - blocks_xPos - block.x;
			if (blocksArray[index].width != undefined) sep_width = blocksArray[index].width;
			else sep_width = sep_max_width;
			
			// *** Separator icon loading
			if (blocksArray[index].iconURL != null) {
				var separator:Sprite = new Sprite();
				var separator_mask:Shape = new Shape();
				block.addChild(separator);
				block.addChild(separator_mask);
				Geom.drawRectangle(separator_mask, sep_width, blocksArray[index].height, 0xFF9900, 0);
				separator.mask = separator_mask;
				var separatorLoader:Loader = new Loader();
				separatorLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,
					function(e:Event) {
						if (e.target.content.height < blocksArray[index].height) e.target.content.height = blocksArray[index].height;
					}
				);
				separatorLoader.load(new URLRequest(blocksArray[index].iconURL+(killCachedFiles?killcache_str:'')));
				separator.addChild(separatorLoader);
				var separatorColor:ColorTransform = separator.transform.colorTransform;
				separatorColor.color = blocksArray[index].color;
				separator.transform.colorTransform = separatorColor;
			}
			// ***
			
			var block_height:uint = Math.ceil(block.height);
			block_yPos += blocksArray[index].topMargin + block_height;
		}
		
	/****************************************************************************************************/
	//	Function. Builds a table.
	
		private function buildTable(blocks:Sprite, blocksArray:Array, index:uint):void {
			var block:Sprite = new Sprite();
			block.x = blocksArray[index].leftMargin;
			block.y = block_yPos + blocksArray[index].topMargin;
			blocks.addChild(block);
			
			var tf:TextField;
			var cell:Sprite;
			var cell_width:uint, cell_height:uint;
			var thickness:uint = blocksArray[index].borderThickness;
			var cell_xPos:uint = thickness;
			var cell_yPos:uint = thickness;
			var cols_num:uint = blocksArray[index].colsNum;
			var cell_txt:String;
			for (var i=0; i<blocksArray[index].cells.length; i++) {
				cell = new Sprite();
				cell.x = cell_xPos;
				cell.y = cell_yPos;
				block.addChild(cell);
				cell_width = blocksArray[index].cells[i].width;
				cell_height = blocksArray[index].cells[i].height;
				if (blocksArray[index].cells[i].bgcolor != undefined) Geom.drawRectangle(cell, cell_width, cell_height, blocksArray[index].cells[i].bgcolor, 1);
				else Geom.drawRectangle(cell, cell_width, cell_height, 0xFFFFFF, 0);
				if (thickness > 0) {
					if (blocksArray[index].borderColor != undefined) Geom.drawBorder(cell, cell_width, cell_height, blocksArray[index].borderColor, 1, thickness, 0);
					else Geom.drawBorder(cell, cell_width, cell_height, 0xFFFFFF, 0, thickness, 0);
				}
				if (blocksArray[index].cells[i].col < cols_num) {
					cell_xPos += cell_width + thickness;
				} else {
					if (i < blocksArray[index].cells.length-1) cell_xPos = thickness;
					else cell_xPos += cell_width + thickness;
					cell_yPos += cell_height + thickness;
				}
				tf = new TextField();
				cell.addChild(tf);
				if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
				tf.width = cell_width;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.multiline = true;
				tf.wordWrap = true;
				tf.embedFonts = true;
				tf.selectable = true;
				tf.antiAliasType = AntiAliasType.ADVANCED;
				tf.mouseWheelEnabled = false;
				if (blocksArray[index].cells[i].text != undefined) {
					cell_txt = blocksArray[index].cells[i].text;
					if (blocksArray[index].cells[i].align == "left") tf.htmlText = cell_txt;
					else tf.htmlText = "<center>" + cell_txt + "</center>";
					tf.height += TEXT_LEADING; // disables TextField scrolling on selection (also is a workaround for "jumpy htmlText hyperlinks")
					tf.autoSize = TextFieldAutoSize.NONE;
				}
				tf.y = Math.round(0.5*(cell_height-tf.height)) + TEXT_LEADING/2;
				var metrics:TextLineMetrics = tf.getLineMetrics(1);
				if (metrics.height == 0) tf.y += TEXT_LEADING/2; // fix for a one-line list item
			}
			
			var block_height:uint = Math.ceil(block.height);
			block_yPos += blocksArray[index].topMargin + block_height;
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
			if (!isNaN(currentFsImageIndex) && !isNaN(currentProjectIndex)) {
				var bmpData:BitmapData = itemsArray[currentProjectIndex].media[currentFsImageIndex].bigImgBmpData;
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
			var bmpData:BitmapData = itemsArray[currentProjectIndex].media[currentFsImageIndex].bigImgBmpData;
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
			if (menuObj != null) menuObj = null;
			if (scrollerObj != null) {
				scrollerObj.destroyScroller();
				scrollerObj = null;
			}
			if (vpObj != null) {
				vpObj.killVideoPlayer();
				vpObj = null;
			}
			if (tnbarObj != null) {
				tnbarObj.destroyThumbnailBar();
				tnbarObj = null;
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