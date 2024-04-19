/**
	Gallery class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.gallery {
	
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

	public class Gallery extends Sprite {
		
		public var main:Sprite, menu:Sprite, controls:Sprite, previews:Sprite, videoplayer:Sprite;
		public var currentCategoryIndex:uint = 0;
		public var categoriesArray:Array, itemsArray:Array;
		public var __root:*;
		public var controls_blocked:Boolean = false;
		public var menu_blocked:Boolean = false;
		public var previews_on_page:uint;
		
		private var xml_URL:String;
		private var xmlLoader:URLLoader;
		private var dataXML:XML;
		private var XMLParserObj:Object, menuObj:Object, vpObj:Object, scrollerObj:Object;
		private var imageLoader1:Loader, imageLoader2:Loader, imageLoader3:Loader, imageLoader4:Loader, imageLoader5:Loader, imageLoader6:Loader, imageLoader7:Loader, imageLoader8:Loader, imageLoader9:Loader, imageLoader10:Loader;
		private var imageLoader11:Loader, imageLoader12:Loader, imageLoader13:Loader, imageLoader14:Loader, imageLoader15:Loader, imageLoader16:Loader, imageLoader17:Loader, imageLoader18:Loader, imageLoader19:Loader, imageLoader20:Loader;
		private var imageLoader21:Loader, imageLoader22:Loader, imageLoader23:Loader, imageLoader24:Loader, imageLoader25:Loader, imageLoader26:Loader, imageLoader27:Loader, imageLoader28:Loader, imageLoader29:Loader, imageLoader30:Loader;
		private var imageLoader31:Loader, imageLoader32:Loader, imageLoader33:Loader, imageLoader34:Loader, imageLoader35:Loader, imageLoader36:Loader, imageLoader37:Loader, imageLoader38:Loader, imageLoader39:Loader, imageLoader40:Loader;
		private var previewImgsLoader:Loader, bigImgsLoader:Loader, bigImageLoader:Loader;
		public var killcache_str:String;
		public var killCachedFiles:Boolean = false;
		private var textStyleSheet:StyleSheet;
		private var currentPreviewImgIndex:uint, currentBigImgIndex:uint;
		private var current_page:uint;
		private var preview_width:uint, preview_height:uint;
		
		// -- single item area
		public var currentProjectIndex:Number;
		public var fullscreen_bg:Shape;
		public var project:Sprite;
		private var description_opened:Boolean = false;
		private var buttons_width:uint, buttons_height:uint;
		private static const BUTTONS_XOFFSET:uint = 20;
		private static const BUTTONS_YOFFSET:uint = 6;
		private static const BIG_IMAGE_YOFFSET:uint = 0;
		private static const FS_FADE_DURATION:Number = 0.4;
		// --
		
		private static const FADE_DURATION:Number = 0.7;
		private static const ON_ROLL_DURATION:Number = 0.3;
		private static const BUTTON_SPACING:uint = 5;
		private static const TEXT_LEADING:uint = 6;
		
		// Category properties
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
		public var previewWidth:uint = 295;
		public var previewHeight:uint = 180;
		public var previewSpacing:uint = 1;
		
		public var previewBgColor:Number;
		public var previewBgAlpha:Number;
		public var previewBorderColor:Number;
		public var previewBorderThickness:uint;
		public var previewShadowColor:Number;
		public var previewShadowAlpha:Number;
		public var previewPadding:uint = 0;
		public var previewPreloaderColor:Number;
		public var previewPreloaderAlpha:Number;
		public var previewCaptionBgColor:uint = 0xFFFFFF;
		public var previewCaptionBgAlpha:Number = 0;
		public var previewCaptionBlurredBg:Boolean = true;
		public var previewCaptionBgBlurAmount:uint;
		public var previewCaptionPadding:uint;
		public var previewCaptionAnimationType:String = "slide";
		public var previewOverBrightness:Number = 0;		
		public var previewVideoIconSize:uint = 30;
		public var previewVideoIconColor:uint = 0xFFFFFF;
		public var previewVideoIconAlpha:Number = 0.4;
		public var previewVideoIconOverAlpha:Number = 0.8;
		
		// Single item view properties
		public var overlayBgColor:Number = 0x000000;
		public var overlayBgAlpha:Number = 0.8;
		public var controlsBarBgColor:Number = 0x333333;
		public var controlsBarBgAlpha:Number = 0.5;
		public var buttonSpacing:uint = 10;
		public var buttonIconColor:uint = 0x333333;
		public var buttonIconOverColor:uint = 0xFFFFFF;
		public var buttonBgColor:uint = 0xDDDDDD;
		public var buttonBgOverColor:uint = 0xE15151;
		public var showInfoButton:Boolean = true;
		public var singleItemTextLeftMargin:uint = 40;
		public var singleItemTextRightMargin:uint = 40;
		public var singleItemDescriptionHeight:Number;
		public var singleItemDescriptionTopMargin:uint = 10;
		public var singleItemPreloaderColor:Number;
		public var singleItemPreloaderAlpha:Number;
		
		// Project video properties
		public var videoPlayerWidth:Number = 853;
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
		
		// Description scroll bar properties
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
		
		public function Gallery():void {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addChild(main = new Sprite());
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the Gallery object is added to the Stage.
	
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the SWF file is resized.
		
		private function onStageResized(e:Event):void {
			if (__root != null) {
				var controls:Sprite = project.getChildByName("controls") as Sprite;
				var container:Sprite = project.getChildByName("container") as Sprite;
				var controls_bg:Shape = controls.getChildByName("controls_bg") as Shape;
				var buttons:Sprite = controls.getChildByName("buttons") as Sprite;
				var title:Sprite = controls.getChildByName("title") as Sprite;
				var description:Sprite = controls.getChildByName("description") as Sprite;
				var media:Sprite = container.getChildByName("media") as Sprite;
				var tf1:TextField, tf2:TextField;
				var hitarea:Sprite;
				
				fullscreen_bg.width = stage.stageWidth;
				fullscreen_bg.height = stage.stageHeight;
				controls_bg.width = stage.stageWidth;
				buttons.x = stage.stageWidth - buttons_width - BUTTONS_XOFFSET;
				tf1 = title.getChildByName("tf") as TextField;
				tf2 = description.getChildByName("tf") as TextField;
				if (!isNaN(currentProjectIndex)) {
					if (itemsArray[currentProjectIndex].description != undefined) description.y = title.y + title.height + singleItemDescriptionTopMargin;
					else description.y = 0;
				}
				if (description.getChildByName("hitarea")) {
					hitarea = description.getChildByName("hitarea") as Sprite;
					hitarea.graphics.clear();
				}
				tf1.width = tf2.width = stage.stageWidth - title.x - buttons_width - BUTTONS_XOFFSET - singleItemTextRightMargin;
				setDescriptionState(false);
				
				if (!isNaN(currentProjectIndex)) {
					if (itemsArray[currentProjectIndex].media[0].type == "image") {
						var bmpData:* = itemsArray[currentProjectIndex].media[0].bigImgBmpData;
						if (bmpData != undefined && bmpData != "no") {
							media.graphics.clear();
							media.alpha = 0;
							drawBigImage(container, bmpData);
						}
					} else if (itemsArray[currentProjectIndex].media[0].type == "video" || itemsArray[currentProjectIndex].media[0].type == "youtube") {
						media.x = Math.round((stage.stageWidth - videoPlayerWidth)/2);
						media.y = Math.round((stage.stageHeight - buttons_height - 2*BUTTONS_YOFFSET - videoPlayerHeight)/2);
					}
				}
				if (container.getChildByName("preloader")) {
					var preloader:MovieClip = container.getChildByName("preloader") as MovieClip;
					preloader.x = Math.round(stage.stageWidth/2);
					preloader.y = Math.round((stage.stageHeight - buttons_height - 2*BUTTONS_YOFFSET)/2);
				}
				if (scrollerObj != null) {
					var mask_h:uint = singleItemDescriptionHeight - 5;
					var mask_w:uint = description.width + 10; // increase the spacing between the right edge of a text field and the scroll bar
					Geom.drawRectangle(hitarea, mask_w, description.height, 0xFF9900, 0);
					scrollerObj.onStageResized(mask_h, mask_w);
				}
			}
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
			if (__root != null) createSingleItemArea();
			createPreviewItems(currentCategoryIndex);
			if (__root != null) __root.openNewPage(); // calls the openNewPage() function of the WebsiteTemplate class
		}
		
		private function xmlDataError(e:IOErrorEvent):void {
			xmlLoader.removeEventListener(Event.COMPLETE, xmlDataProcessing);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlDataError);
		}
		
	/****************************************************************************************************/
	//	Function. Builds gallery items previews.
	
		public function createPreviewItems(category_index:uint):void {
			itemsArray = XMLParserObj.categoryNodeParser(dataXML.category[category_index]); // processing a "category" node
			
			if (previews_on_page > 0) {
				current_page = 1;
				currentProjectIndex = NaN;
				loadPreviewImgs();
				loadBigImgs();
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
					var base:Shape, shadow_base:Shape, bg:Shape, blurred_bg_mask:Shape, caption_mask:Shape, video_icon:Shape;
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
						container.addChild(shadow_base = new Shape());
						shadow_base.name = "shadow_base";
						container.addChild(bg = new Shape());
						bg.name = "bg";
						hitarea = new Sprite();
						container.addChild(hitarea);
						hitarea.mouseEnabled = false;
						container.addChild(img = new Sprite());
						img.name = "img";
						img.addEventListener(MouseEvent.CLICK, previewImageClickListener);
						img.hitArea = hitarea;
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
						Geom.drawRectangle(caption_mask, previewWidth, previewHeight, 0xFF9900, 0);
						caption.mask = caption_mask;
						container.addChild(video_icon = new Shape());
						video_icon.name = "video_icon";
						video_icon.x = Math.round((preview_width-previewVideoIconSize)/2);
						video_icon.y = Math.round((preview_height-previewVideoIconSize)/2);
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
						
						bg.x = bg.y = border_thickness;
						img.x = img.y = blurred_bg.x = blurred_bg.y = blurred_bg_mask.x = caption.x = caption_mask.x = caption_mask.y = border_thickness + previewPadding;
						base.x = base.y = border_thickness + previewPadding;
						
						// Preview caption
						var tf:TextField = new TextField();
						tf.name = "tf";
						caption.addChild(tf);
						tf.x = tf.y = previewCaptionPadding;
						if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
						tf.width = previewWidth - 2*previewCaptionPadding;
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
						tf_bmp.x = tf_bmp.y = previewCaptionPadding;
						
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
	//	Function. Changes gallery items previews (currently visible).
	
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
				var video_icon:Shape = container.getChildByName("video_icon") as Shape;
				var base:Shape = container.getChildByName("base") as Shape;
				var preloader:MovieClip;
				
				Tweener.removeTweens(img);
				Tweener.removeTweens(blurred_bg);
				Tweener.removeTweens(caption);
				
				img.graphics.clear();
				blurred_bg.graphics.clear();
				blurred_bg_mask.graphics.clear();
				video_icon.graphics.clear();
				caption.graphics.clear();
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
				img.alpha = 0;
				
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
	//	Functions. Handles events on loading of preview images of gallery items.
		
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
			var video_icon:Shape = container.getChildByName("video_icon") as Shape;
			
			if (bmpData != "no") {
				var bmp_matrix:Matrix = new Matrix();
				if (bmpData.width != previewWidth || bmpData.height != previewHeight) {
					var sx:Number = previewWidth/bmpData.width;
					var sy:Number = previewHeight/bmpData.height;
					bmp_matrix.scale(Math.max(sx,sy), Math.max(sx,sy));
					if (sy > sx) bmp_matrix.tx = -0.5*(bmpData.width*sy-previewWidth);
					if (sx > sy) bmp_matrix.ty = -0.5*(bmpData.height*sx-previewHeight);
				}
				with (img.graphics) {
					beginBitmapFill(bmpData, bmp_matrix, true, true);
					lineTo(previewWidth, 0);
					lineTo(previewWidth, previewHeight);
					lineTo(0, previewHeight);
					lineTo(0, 0);
					endFill();
				}
				
				// Preview video icon
				if ((itemsArray[index].media[0].type == "video" || itemsArray[index].media[0].type == "youtube") && previewVideoIconSize > 0) {
					video_icon.graphics.lineStyle(2, previewVideoIconColor, 1, true);
					video_icon.graphics.beginFill(0xFFFFFF, 0);
					video_icon.graphics.drawCircle(Math.round(previewVideoIconSize/2), Math.round(previewVideoIconSize/2), Math.floor(previewVideoIconSize/2));
					video_icon.graphics.endFill();
					var triangle_size:uint = previewVideoIconSize - 14;
					var triangle_height:uint = Math.round(0.5*triangle_size*Math.sqrt(3));
					var triangle_x:uint = Math.round((previewVideoIconSize-triangle_size/Math.sqrt(3))/2);
					var triangle_y:uint = Math.round((previewVideoIconSize-triangle_size)/2);
					video_icon.graphics.lineStyle(NaN, 0);
					video_icon.graphics.beginFill(previewVideoIconColor, 1);
					video_icon.graphics.moveTo(triangle_x, triangle_y);
					video_icon.graphics.lineTo(triangle_x, triangle_y+triangle_size);
					video_icon.graphics.lineTo(triangle_x+triangle_height, triangle_y+0.5*triangle_size);
					video_icon.graphics.lineTo(triangle_x, triangle_y);
					video_icon.graphics.endFill();
					video_icon.alpha = previewVideoIconAlpha;
				}
				
				Tweener.addTween(img, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
				if (!(previewOverBrightness == 0 && itemsArray[index].previewCaption == undefined)) {
					Image.drawCaption(container,
										previewWidth,
										previewHeight,
										bmpData,
										itemsArray[index].previewCaption,
										textStyleSheet,
										previewCaptionBgColor,
										previewCaptionBgAlpha,
										previewCaptionBlurredBg,
										previewCaptionBgBlurAmount,
										previewCaptionPadding,
										previewCaptionAnimationType,
										previewOverBrightness,
										0.6,
										"video_icon",
										previewVideoIconOverAlpha,
										previewVideoIconAlpha);
				}
			}
			if (itemsArray[index].media[0].src != undefined || itemsArray[index].previewClickLink != undefined) {
				img.buttonMode = true;
			} else {
				img.buttonMode = false;
			}
		}

	/****************************************************************************************************/
	//	Function. Builds the controls (navigation buttons) of gallery previews.
		
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
				var nav_but:MovieClip = new previews_nav_button();
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
			Tweener.addTween(controls, {alpha:1, time:0.7*FADE_DURATION, transition:"easeOutQuart"});
		}
		
	/****************************************************************************************************/
	//	Function. Loads preview images of gallery items one by one (in background mode).
		
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
			if (__root != null) {
				var container_index:uint = uint(e.target.parent.name.substr(9));
				var index:uint = (current_page-1)*previews_on_page + (container_index-1);
				if (itemsArray[index].media[0].src != undefined) {
					controls_blocked = menu_blocked = true;
					if (index != currentProjectIndex) {
						currentProjectIndex = index;
						changeOpenedItem();
					}
					displaySingleItemView(true);
				} else if (itemsArray[index].previewClickLink != undefined) {
					var link:String = itemsArray[index].previewClickLink;
					var target:String = itemsArray[index].previewClickTarget;
					if (target == null) target = "_blank";
					if (link == "#") SWFAddress.setValue("/");
					else {
						if (link.substr(0, 1) == "#") SWFAddress.setValue(link.substr(1));
						else {
							try { navigateToURL(new URLRequest(link), target); }
							catch (e:Error) { }
						}
					}
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Displays/hides the single item view.
	
		private function displaySingleItemView(vis:Boolean):void {
			if (vis == true) {
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
						controls_blocked = menu_blocked = description_opened = false;
						setDescriptionState();
						if (vpObj != null) {
							if (vpObj.isPlaying) vpObj.setPausedState();
							vpObj.autohideTimer.stop();
						}
					}
				});
			}
		}

	/****************************************************************************************************/
	//	Function. Builds the single item area.
	
		private function createSingleItemArea():void {
			
			var controls:Sprite, title:Sprite, description:Sprite, buttons:Sprite, counter:Sprite, container:Sprite, media:Sprite;
			var controls_bg:Shape;
			var tf:TextField;
			var butIconColor:ColorTransform, butBgColor:ColorTransform;
			
			__root.gallery_container.addChild(fullscreen_bg = new Shape());
			__root.gallery_container.addChild(project = new Sprite());
			Geom.drawRectangle(fullscreen_bg, stage.stageWidth, stage.stageHeight, overlayBgColor, overlayBgAlpha);
			
			// *** Big image/video
			project.addChild(container = new Sprite());
			container.name = "container";
			container.addChild(media = new Sprite());
			media.name = "media";
			bigImageLoader = new Loader();
			
			// *** Controls (buttons, counter, title, description)
			project.addChild(controls = new Sprite());
			controls.name = "controls";
			controls.addChild(controls_bg = new Shape());
			controls_bg.name = "controls_bg";
			Geom.drawRectangle(controls_bg, stage.stageWidth, 500, controlsBarBgColor, controlsBarBgAlpha);
			controls.addChild(buttons = new Sprite());
			buttons.name = "buttons";
			
			// Buttons
			var left_but:MovieClip = new left_arrow_button();
			left_but.name = "left_but";
			left_but.buttonMode = true;
			left_but.addEventListener(MouseEvent.ROLL_OVER, singleItemControlsListener);
			left_but.addEventListener(MouseEvent.ROLL_OUT, singleItemControlsListener);
			left_but.addEventListener(MouseEvent.CLICK, singleItemControlsListener);
			butIconColor = left_but.icon.transform.colorTransform;
			butIconColor.color = buttonIconColor;
			left_but.icon.transform.colorTransform = butIconColor;
			butBgColor = left_but.bg.transform.colorTransform;
			butBgColor.color = buttonBgColor;
			left_but.bg.transform.colorTransform = butBgColor;
			buttons.addChild(left_but);
			var right_but:MovieClip = new right_arrow_button();
			right_but.name = "right_but";
			right_but.x = left_but.width + buttonSpacing;
			right_but.buttonMode = true;
			right_but.addEventListener(MouseEvent.ROLL_OVER, singleItemControlsListener);
			right_but.addEventListener(MouseEvent.ROLL_OUT, singleItemControlsListener);
			right_but.addEventListener(MouseEvent.CLICK, singleItemControlsListener);
			butIconColor = right_but.icon.transform.colorTransform;
			butIconColor.color = buttonIconColor;
			right_but.icon.transform.colorTransform = butIconColor;
			butBgColor = right_but.bg.transform.colorTransform;
			butBgColor.color = buttonBgColor;
			right_but.bg.transform.colorTransform = butBgColor;
			buttons.addChild(right_but);
			var info_but:MovieClip = new info_button();
			info_but.name = "info_but";
			if (showInfoButton) {
				info_but.x = right_but.x + right_but.width + buttonSpacing;
				info_but.buttonMode = true;
				info_but.addEventListener(MouseEvent.ROLL_OVER, singleItemControlsListener);
				info_but.addEventListener(MouseEvent.ROLL_OUT, singleItemControlsListener);
				info_but.addEventListener(MouseEvent.CLICK, singleItemControlsListener);
			} else {
				info_but.x = right_but.x;
				info_but.visible = false;
			}
			butIconColor = info_but.icon.transform.colorTransform;
			butIconColor.color = buttonIconColor;
			info_but.icon.transform.colorTransform = butIconColor;
			butBgColor = info_but.bg.transform.colorTransform;
			butBgColor.color = buttonBgColor;
			info_but.bg.transform.colorTransform = butBgColor;
			buttons.addChild(info_but);
			var close_but:MovieClip = new close_button();
			close_but.name = "close_but";
			close_but.x = info_but.x + info_but.width + buttonSpacing;
			close_but.buttonMode = true;
			close_but.addEventListener(MouseEvent.ROLL_OVER, singleItemControlsListener);
			close_but.addEventListener(MouseEvent.ROLL_OUT, singleItemControlsListener);
			close_but.addEventListener(MouseEvent.CLICK, singleItemControlsListener);
			butIconColor = close_but.icon.transform.colorTransform;
			butIconColor.color = buttonIconColor;
			close_but.icon.transform.colorTransform = butIconColor;
			butBgColor = close_but.bg.transform.colorTransform;
			butBgColor.color = buttonBgColor;
			close_but.bg.transform.colorTransform = butBgColor;
			buttons.addChild(close_but);
			buttons_width = buttons.width;
			buttons_height = buttons.height;
			controls.y = stage.stageHeight - buttons_height - 2*BUTTONS_YOFFSET;
			buttons.x = stage.stageWidth - buttons_width - BUTTONS_XOFFSET;
			buttons.y = BUTTONS_YOFFSET + 1;
			
			// Counter
			counter = new Sprite();
			controls.addChild(counter);
			counter.name = "counter";
			tf = new TextField();
			tf.name = "tf";
			counter.addChild(tf);
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = false;
			tf.wordWrap = false;
			tf.embedFonts = true;
			tf.selectable = false;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.htmlText = '<span class="galleryitem-counter">1/2</span>';
			counter.x = BUTTONS_XOFFSET;
			counter.y = BUTTONS_YOFFSET + Math.round((buttons_height-counter.height)/2);
			
			// Title
			controls.addChild(title = new Sprite());
			title.name = "title";
			tf = new TextField();
			tf.name = "tf";
			title.addChild(tf);
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.autoSize = TextFieldAutoSize.NONE;
			tf.multiline = false;
			tf.wordWrap = false;
			tf.embedFonts = true;
			tf.selectable = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			title.x = BUTTONS_XOFFSET + counter.width + singleItemTextLeftMargin;
			
			// Description
			controls.addChild(description = new Sprite());
			description.name = "description";
			tf = new TextField();
			tf.name = "tf";
			description.addChild(tf);
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.embedFonts = true;
			tf.selectable = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.mouseWheelEnabled = false;
			description.x = title.x;
				
			stage.addEventListener(Event.RESIZE, onStageResized);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		}
		
		private function singleItemControlsListener(e:MouseEvent):void {
			var but:MovieClip = e.currentTarget as MovieClip;
			var container:Sprite = project.getChildByName("container") as Sprite;
			var controls:Sprite = project.getChildByName("controls") as Sprite;
			var media:Sprite = container.getChildByName("media") as Sprite;
			var title:Sprite = controls.getChildByName("title") as Sprite;
			var description:Sprite = controls.getChildByName("description") as Sprite;
			var controls_bg:Shape = controls.getChildByName("controls_bg") as Shape;
			switch (e.type) {
				case "rollOver":
					if (but.alpha == 1) {
						Tweener.removeTweens(but.icon);
						Tweener.removeTweens(but.bg);
						Tweener.addTween(but.icon, {_color:buttonIconOverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
						Tweener.addTween(but.bg, {_color:buttonBgOverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
				break;
				case "rollOut":
					if (but.alpha == 1) {
						Tweener.removeTweens(but.icon);
						Tweener.removeTweens(but.bg);
						Tweener.addTween(but.icon, {_color:buttonIconColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
						Tweener.addTween(but.bg, {_color:buttonBgColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
				break;
				case "click":
					if (!controls_blocked) {
						controls_blocked = true;
						switch (e.currentTarget.name) {
							case "left_but":
								if (currentProjectIndex > 0) {
									Tweener.addTween(media, {alpha:0, time:0.5*FADE_DURATION, transition:"easeOutQuad", onComplete:
										function() {
											currentProjectIndex--;
											changeOpenedItem();
											if (currentProjectIndex == 0) {
												Tweener.addTween(but.icon, {_color:buttonIconColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
												Tweener.addTween(but.bg, {_color:buttonBgColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
											}
										}
									});
									Tweener.addTween(title, {alpha:0, time:0.5*FADE_DURATION, transition:"easeOutQuad"});
									Tweener.addTween(description, {alpha:0, time:0.5*FADE_DURATION, transition:"easeOutQuad"});
								}
							break;
							case "right_but":
								if (currentProjectIndex < itemsArray.length-1) {
									Tweener.addTween(media, {alpha:0, time:0.5*FADE_DURATION, transition:"easeOutQuad", onComplete:
										function() {
											currentProjectIndex++;
											changeOpenedItem();
											if (currentProjectIndex == itemsArray.length-1) {
												Tweener.addTween(but.icon, {_color:buttonIconColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
												Tweener.addTween(but.bg, {_color:buttonBgColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
											}
										}
									});
									Tweener.addTween(title, {alpha:0, time:0.5*FADE_DURATION, transition:"easeOutQuad"});
									Tweener.addTween(description, {alpha:0, time:0.5*FADE_DURATION, transition:"easeOutQuad"});
								}
							break;
							case "info_but":
								if (itemsArray[currentProjectIndex].description != undefined) {
									description_opened = !description_opened;
									setDescriptionState();
								}
							break;
							case "close_but":
								displaySingleItemView(false);
						}
						Tweener.addTween(project, {delay:0.5*FADE_DURATION, onComplete:function(){controls_blocked = false;}});
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
					Tweener.addTween(project, {delay:0.5*FADE_DURATION, onComplete:function(){controls_blocked = false;}});
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Changes the opened gallery item (currently selected).
	
		private function changeOpenedItem():void {
			var controls:Sprite = project.getChildByName("controls") as Sprite;
			var title:Sprite = controls.getChildByName("title") as Sprite;
			var description:Sprite = controls.getChildByName("description") as Sprite;
			var controls_bg:Shape = controls.getChildByName("controls_bg") as Shape;
			var tf:TextField;
			
			// Title
			Tweener.removeTweens(title);
			title.alpha = 0;
			tf = title.getChildByName("tf") as TextField;
			tf.width = stage.stageWidth - title.x - buttons_width - BUTTONS_XOFFSET - singleItemTextRightMargin;
			if (itemsArray[currentProjectIndex].title != undefined) tf.htmlText = itemsArray[currentProjectIndex].title;
			else tf.htmlText = "";
			var metrics:TextLineMetrics = tf.getLineMetrics(0);
			tf.height = metrics.height + 4;
			title.y = BUTTONS_YOFFSET + Math.ceil((buttons_height-title.height)/2);
			Tweener.removeTweens(title);
			Tweener.addTween(title, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
			
			// Description
			Tweener.removeTweens(description);
			description.alpha = 0;
			if (scrollerObj != null) {
				scrollerObj.destroyScroller();
				scrollerObj = null;
			}
			tf = description.getChildByName("tf") as TextField;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.width = stage.stageWidth - title.x - buttons_width - BUTTONS_XOFFSET - singleItemTextRightMargin;
			if (itemsArray[currentProjectIndex].description != undefined) {
				tf.htmlText = itemsArray[currentProjectIndex].description;
				description.y = title.y + title.height + singleItemDescriptionTopMargin;
			} else {
				tf.htmlText = "";
				description.y = 0;
			}
			tf.height += TEXT_LEADING; // disables TextField scrolling on selection (also is a workaround for "jumpy htmlText hyperlinks")
			tf.autoSize = TextFieldAutoSize.NONE;
			Tweener.removeTweens(description);
			Tweener.addTween(description, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
			
			updateCounter();
			setDescriptionState();
			if (itemsArray[currentProjectIndex].description != undefined && !isNaN(singleItemDescriptionHeight) && singleItemDescriptionHeight > 0) {
				attachScroller(); // attach a scroller to the description content
			}
			changeMedia();
		}
		
	/****************************************************************************************************/
	//	Function. Attaches a scroller to the description content.
		
		private function attachScroller():void {
			var controls:Sprite = project.getChildByName("controls") as Sprite;
			var description:Sprite = controls.getChildByName("description") as Sprite;
			var hitarea:Sprite;
			if (description.getChildByName("hitarea")) {
				hitarea = description.getChildByName("hitarea") as Sprite;
				hitarea.graphics.clear();
			} else {
				description.addChild(hitarea = new Sprite());
				hitarea.name = "hitarea";
				description.hitArea = hitarea;
				hitarea.mouseEnabled = false;
			}
			if (__root != null) {
				var mask_w:uint = description.width + 10; // increase the spacing between the right edge of a text field and the scroll bar
				var mask_h:uint = singleItemDescriptionHeight - 5;
				Geom.drawRectangle(hitarea, mask_w, description.height, 0xFF9900, 0);
				scrollerObj = new Scroller(description,
										   mask_w,
										   mask_h,
										   scrollBarTrackWidth,
										   scrollBarTrackColor,
										   scrollBarTrackAlpha,
										   scrollBarSliderOverWidth,
										   scrollBarSliderColor,
										   scrollBarSliderOverColor);
			}
		}	
		
	/****************************************************************************************************/
	//	Function. Updates the opened gallery item counter.
	
		private function updateCounter():void {
			var controls:Sprite = project.getChildByName("controls") as Sprite;
			var buttons:Sprite = controls.getChildByName("buttons") as Sprite;
			var left_but:Sprite = buttons.getChildByName("left_but") as Sprite;
			var right_but:Sprite = buttons.getChildByName("right_but") as Sprite;
			var info_but:Sprite = buttons.getChildByName("info_but") as Sprite;
			var counter:Sprite = controls.getChildByName("counter") as Sprite;
			var tf:TextField = counter.getChildByName("tf") as TextField;
			tf.htmlText = '<span class="galleryitem-counter">'+((!isNaN(currentProjectIndex)?currentProjectIndex:0)+1)+'/'+itemsArray.length+'</span>';			
			if (currentProjectIndex == 0) { left_but.buttonMode = false; left_but.alpha = 0.7; }
			else { left_but.buttonMode = true; left_but.alpha = 1; }
			if (currentProjectIndex == itemsArray.length-1) { right_but.buttonMode = false; right_but.alpha = 0.7; }
			else { right_but.buttonMode = true; right_but.alpha = 1; }
			if (itemsArray[currentProjectIndex].description == undefined) { info_but.buttonMode = false; info_but.alpha = 0.7; }
			else { info_but.buttonMode = true; info_but.alpha = 1; }
		}
		
	/****************************************************************************************************/
	//	Function. Sets the y-coordinate of the controls bar depending on some settings.
	
		private function setDescriptionState(use_tween:Boolean = true):void {
			var controls:Sprite = project.getChildByName("controls") as Sprite;
			var description:Sprite = controls.getChildByName("description") as Sprite;
			var bar_height:uint, controls_y:uint;
			if (description_opened == false || itemsArray[currentProjectIndex].description == undefined || singleItemDescriptionHeight == 0) {
				bar_height = buttons_height + 2*BUTTONS_YOFFSET;
			} else {
				if (!isNaN(singleItemDescriptionHeight)) bar_height = description.y + singleItemDescriptionHeight + BUTTONS_YOFFSET;
				else bar_height = description.y + description.height + BUTTONS_YOFFSET;
			}
			controls_y = stage.stageHeight - bar_height;
			if (controls.y != controls_y) {
				if (use_tween) Tweener.addTween(controls, {y:controls_y, time:0.5*FADE_DURATION, transition:"easeOutQuad"});
				else controls.y = controls_y;
			}
		}
		
	/****************************************************************************************************/
	//	Function. Changes the media (image or video) of the opened gallery item.
	
		private function changeMedia():void {
			var container:Sprite = project.getChildByName("container") as Sprite;
			var media:Sprite = container.getChildByName("media") as Sprite;
			var preloader:MovieClip;
			Tweener.removeTweens(media);
			bigImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bigImageLoadComplete);
			bigImageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, bigImageLoadError);
			try { bigImageLoader.close(); }
			catch(error:Error){};
			bigImageLoader.unload();
			media.graphics.clear();
			if (vpObj != null) {
				vpObj.killVideoPlayer();
				vpObj = null;
			}
			if (videoplayer != null) {
				media.removeChild(videoplayer);
				videoplayer = null;
			}
			media.alpha = 0;
			if (container.getChildByName("preloader")) {
				preloader = container.getChildByName("preloader") as MovieClip;
				Tweener.removeTweens(preloader);
				container.removeChild(preloader);
			}
			if (itemsArray[currentProjectIndex].media[0].type == "image") {
				if (itemsArray[currentProjectIndex].media[0].bigImgBmpData == undefined) {
					if (itemsArray[currentProjectIndex].media[0].src != undefined) {
						if (!isNaN(singleItemPreloaderColor) && !isNaN(singleItemPreloaderAlpha)) {
							preloader = new video_preloader();
							preloader.name = "preloader";
							container.addChild(preloader);
							preloader.x = Math.round(stage.stageWidth/2);
							preloader.y = Math.round((stage.stageHeight - buttons_height - 2*BUTTONS_YOFFSET)/2);
							preloader.scaleX = preloader.scaleY = 0.7;
							var preloaderColor:ColorTransform = preloader.transform.colorTransform;
							preloaderColor.color = singleItemPreloaderColor;
							preloader.transform.colorTransform = preloaderColor;
							preloader.alpha = singleItemPreloaderAlpha;
						}
						bigImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bigImageLoadComplete);
						bigImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bigImageLoadError);
						bigImageLoader.name = "bigImageLoader_"+currentProjectIndex;
						bigImageLoader.load(new URLRequest(itemsArray[currentProjectIndex].media[0].src+(killCachedFiles?killcache_str:'')));
					} else {
						itemsArray[currentProjectIndex].media[0].bigImgBmpData = "no";
					}
				} else {
					drawBigImage(container, itemsArray[currentProjectIndex].media[0].bigImgBmpData);
				}
			} else {
				var videoURL:String = itemsArray[currentProjectIndex].media[0].src;
				var previewImageURL:String = itemsArray[currentProjectIndex].media[0].previewImage;
				var playbackQuality:String = itemsArray[currentProjectIndex].media[0].playbackQuality;
				var videoAutoPlay:Boolean = itemsArray[currentProjectIndex].media[0].autoPlay;
				var videoRatio:String = itemsArray[currentProjectIndex].media[0].ratio;
				videoPlayerHeight = Math.round(videoPlayerWidth * (videoRatio == "16:9" ? 9/16 : 3/4));
				if (itemsArray[currentProjectIndex].media[0].type == "youtube") {
					vpObj = new VideoPlayerYouTube(this, killCachedFiles, textStyleSheet, videoURL, previewImageURL, playbackQuality, videoAutoPlay);
				} else if (itemsArray[currentProjectIndex].media[0].type == "video") {
					vpObj = new VideoPlayer(this, killCachedFiles, textStyleSheet, videoURL, previewImageURL, videoAutoPlay);
				}
				if (vpObj != null) {
					videoplayer = vpObj.videoplayer;
					media.addChild(videoplayer);
					media.x = Math.round((stage.stageWidth - videoPlayerWidth)/2);
					media.y = Math.round((stage.stageHeight - buttons_height - 2*BUTTONS_YOFFSET - videoPlayerHeight)/2);
					Tweener.addTween(media, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
				}
			}
		}
		
	/****************************************************************************************************/
	//	Functions. Handles events on loading of big images of opened gallery items.
		
		private function bigImageLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, bigImageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, bigImageLoadError);
			var index_arr:Array = e.target.loader.name.split("_");
			var index:uint = index_arr[1];
			var container:Sprite = project.getChildByName("container") as Sprite;
			var media:Sprite = container.getChildByName("media") as Sprite;
			var preloader:MovieClip = container.getChildByName("preloader") as MovieClip;
			if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.7*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[container, preloader]});
			if (!isNaN(currentProjectIndex) && currentProjectIndex == index) {
				var bmp:Bitmap = Bitmap(e.target.content);
				bmp.smoothing = true;
				var bmpData:BitmapData = bmp.bitmapData;
				if (itemsArray[currentProjectIndex].media[0].bigImgBmpData == undefined) itemsArray[currentProjectIndex].media[0].bigImgBmpData = bmpData;
				drawBigImage(container, bmpData);
			}
		}
		
		private function bigImageLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, bigImageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, bigImageLoadError);
			var index_arr:Array = e.target.loader.name.split("_");
			var index:uint = index_arr[1];
			var container:Sprite = project.getChildByName("container") as Sprite;
			var preloader:MovieClip = container.getChildByName("preloader") as MovieClip;
			if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.7*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[container, preloader]});
			if (!isNaN(currentProjectIndex) && currentProjectIndex == index) {
				if (itemsArray[currentProjectIndex].media[0].bigImgBmpData == undefined) itemsArray[currentProjectIndex].media[0].bigImgBmpData = "no";
			}
		}
		
	/****************************************************************************************************/
	//	Function. Draws a big image of the opened media (image).
		
		private function drawBigImage(container:Sprite, bmpData:*):void {
			var media:Sprite = container.getChildByName("media") as Sprite;
			if (bmpData != "no") {
				var max_width:uint, max_height:uint, new_width:uint, new_height:uint, new_x:uint, new_y:uint;
				max_width = stage.stageWidth;
				max_height = stage.stageHeight - buttons_height - 2*BUTTONS_YOFFSET - 2*BIG_IMAGE_YOFFSET;
				new_width = bmpData.width;
				new_height = bmpData.height;
				new_x = Math.round((stage.stageWidth - bmpData.width)/2);
				new_y = Math.round((stage.stageHeight - buttons_height - 2*BUTTONS_YOFFSET - bmpData.height)/2);
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
						new_y = Math.round((stage.stageHeight - buttons_height - 2*BUTTONS_YOFFSET - new_height)/2);
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
		}
		
	/****************************************************************************************************/
	//	Function. Loads big images (within the selected gallery category) one by one (in background mode).
		
		private function loadBigImgs():void {
			if (bigImgsLoader != null) {
				bigImgsLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bigImgsLoadProcessing);
				bigImgsLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, bigImgsLoadError);
				try { bigImgsLoader.close(); }
				catch(error:Error){};
				bigImgsLoader.unload();
			}
			bigImgsLoader = new Loader();
			bigImgsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bigImgsLoadProcessing);
			bigImgsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bigImgsLoadError);
			for (var i=0; i<itemsArray.length; i++) {
				if (itemsArray[i].media[0].src != undefined && itemsArray[i].media[0].type == "image") {
					if (itemsArray[i].media[0].bigImgBmpData == undefined) {
						currentBigImgIndex = i;
						bigImgsLoader.load(new URLRequest(itemsArray[i].media[0].src+(killCachedFiles?killcache_str:'')));
						break;
					}
				} else itemsArray[i].media[0].bigImgBmpData = "no";
			}
		}
		
		private function bigImgsLoadProcessing(e:Event):void {
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			var bmpData:BitmapData = bmp.bitmapData;
			if (itemsArray[currentBigImgIndex].media[0].bigImgBmpData == undefined) itemsArray[currentBigImgIndex].media[0].bigImgBmpData = bmpData;
			currentBigImgIndex++;
			for (var i=currentBigImgIndex; i<itemsArray.length; i++) {
				if (itemsArray[i].media[0].bigImgBmpData != undefined) {
					currentBigImgIndex++;
				} else {
					if (itemsArray[i].media[0].src != undefined && itemsArray[i].media[0].type == "image") {
						bigImgsLoader.load(new URLRequest(itemsArray[i].media[0].src+(killCachedFiles?killcache_str:'')));
						break;
					} else {
						itemsArray[i].media[0].bigImgBmpData = "no";
						currentBigImgIndex++;
					}
				}
			}
			if (currentBigImgIndex >= itemsArray.length) {
				e.target.removeEventListener(Event.COMPLETE, bigImgsLoadProcessing);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, bigImgsLoadError);
			}
		}
		
		private function bigImgsLoadError(e:IOErrorEvent):void {
			itemsArray[currentBigImgIndex].media[0].bigImgBmpData = "no";
			currentBigImgIndex++;
			for (var i=currentBigImgIndex; i<itemsArray.length; i++) {
				if (itemsArray[i].media[0].bigImgBmpData != undefined) {
					currentBigImgIndex++;
				} else {
					if (itemsArray[i].media[0].src != undefined && itemsArray[i].media[0].type == "image") {
						bigImgsLoader.load(new URLRequest(itemsArray[i].media[0].src+(killCachedFiles?killcache_str:'')));
						break;
					} else {
						itemsArray[i].media[0].bigImgBmpData = "no";
						currentBigImgIndex++;
					}
				}
			}
			if (currentBigImgIndex >= itemsArray.length) {
				e.target.removeEventListener(Event.COMPLETE, bigImgsLoadProcessing);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, bigImgsLoadError);
			}
		}		

	/****************************************************************************************************/
	//	Function. Performs a number of actions for deactivating the module.
	//	Called from the pageContentClosed() function of the WebsiteTemplate class.

		public function killModule():void {
			
			stage.removeEventListener(Event.RESIZE, onStageResized);
			Utils.removeTweens(__root.gallery_container);
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
			if (project != null) {
				__root.gallery_container.removeChild(project);
				project = null;
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