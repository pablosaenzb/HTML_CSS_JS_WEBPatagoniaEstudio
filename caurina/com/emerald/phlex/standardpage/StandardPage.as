/**
	StandardPage class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.standardpage {
	
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
	import com.emerald.phlex.bannerrotator.BannerRotator;
	import com.emerald.phlex.videoplayer.VideoPlayer;
	import com.emerald.phlex.videoplayer.VideoPlayerYouTube;
	import com.emerald.phlex.utils.Geom;
	import com.emerald.phlex.utils.Image;
	import com.emerald.phlex.utils.Scroller;
	import com.emerald.phlex.utils.Utils;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import caurina.transitions.*;

	public class StandardPage extends Sprite {
		
		public var main:Sprite, blocks:Sprite, rotator:Sprite, videoplayer:Sprite;
		public var __root:*;
		public var blocksArray:Array;
		public var scrollerObj:Object;
		private var xml_URL:String;
		private var xmlLoader1:URLLoader, xmlLoader2:URLLoader;
		private var data1XML:XML;
		private var data2XML:XMLList;
		private var XMLParserObj:Object, brObj:Object;
		private var killcache_str:String;
		private var killCachedFiles:Boolean = false;
		private var textStyleSheet:StyleSheet;
		private var block_xPos:uint, block_yPos:uint, maxH_in_cols:uint;
		private var block_in_col_yPos:uint, maxW_in_col:uint;
		private var blocks_yPos:uint = 0;
		
		// -- single item area
		public var currentFsImageIndex:Number;
		public var fullscreen_bg:Shape;
		public var fsimg:Sprite;
		public var controls_blocked:Boolean = false;
		public var menu_blocked:Boolean = false;
		private static const BUTTONS_XOFFSET:uint = 16;
		private static const BUTTONS_YOFFSET:uint = 10;
		private static const BIG_IMAGE_YOFFSET:uint = 0;
		private static const FS_FADE_DURATION:Number = 0.4;
		private static const ON_ROLL_DURATION:Number = 0.3;
		// --
		
		private static const FADE_DURATION:Number = 1;
		private static const TEXT_LEADING:uint = 6;
		
		// Image properties
		public var imageBgColor:Number;
		public var imageBgAlpha:Number;
		public var imageBorderColor:Number;
		public var imageBorderThickness:uint;
		public var imageShadowColor:Number;
		public var imageShadowAlpha:Number;
		public var imagePadding:uint = 0;
		public var imagePreloaderColor:Number;
		public var imagePreloaderAlpha:Number;
		public var imageCaptionBgColor:Number;
		public var imageCaptionBgAlpha:Number;
		public var imageCaptionBlurredBg:Boolean = true;
		public var imageCaptionBgBlurAmount:uint;
		public var imageCaptionPadding:uint;
		public var imageOverBrightness:Number = 0;
		public var imageZoomIconColor:uint = 0x000000;
		public var imageZoomIconAlpha:Number = 0;
		public var imageZoomIconOverAlpha:Number = 0;
		
		// Single item view properties
		public var overlayBgColor:Number = 0x000000;
		public var overlayBgAlpha:Number = 0.9;
		public var controlsBarBgColor:Number = 0x000000;
		public var controlsBarBgAlpha:Number = 0.5;
		public var buttonIconColor:uint = 0x333333;
		public var buttonIconOverColor:uint = 0xFFFFFF;
		public var buttonBgColor:uint = 0xFEFEFE;
		public var buttonBgOverColor:uint = 0x999999;
		
		// Video properties
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
		
		// List properties
		public var listItemMarkerURL:String;
		public var listItemMarkerTopPadding:uint = 0;
		public var listItemLeftPadding:uint = 0;
		public var listItemBottomPadding:uint = 0;
		
		// Scroll bar properties
		public var scrollBarTrackWidth:uint;
		public var scrollBarTrackColor:Number;
		public var scrollBarTrackAlpha:Number = 1;
		public var scrollBarSliderOverWidth:uint;
		public var scrollBarSliderColor:uint = 0xB5B5B5;
		public var scrollBarSliderOverColor:Number;
		
		// Slideshow properties
		public var useSlideshow:Boolean = false;
		public var slideshowLeftMargin:uint = 0;
		public var slideshowTopMargin:uint = 0;
		public var slideshowHeight:uint;
		public var slideshowXML:String;
		
		public var contentTopMargin:uint = 0;
		
		// Image Shadow
		private var imageShadowBlur:uint = 16;
		private var imageShadowStrength:uint = 1;
		private var imageShadowQuality:uint = 2;
		
		// Video Player Shadow
		public var videoPlayerShadowBlur:uint = 16;
		public var videoPlayerShadowStrength:uint = 1;
		public var videoPlayerShadowQuality:uint = 2;
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function StandardPage():void {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addChild(main = new Sprite());
			main.addChild(blocks = new Sprite());
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the StandardPage object is added to the Stage.
	
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the SWF file is resized.
		
		public function onStageResized(e:Event):void {
			blocks.y = blocks_yPos;
			var mask_h:uint = stage.stageHeight - __root.page_content.y - __root.module_container.y - blocks.y - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
			scrollerObj.onStageResized(mask_h);
			
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
				xmlLoader1 = new URLLoader();
				xmlLoader1.addEventListener(Event.COMPLETE, xmlData1Processing);
				xmlLoader1.addEventListener(IOErrorEvent.IO_ERROR, xmlData1Error);
				var date:Date = new Date();
				if (__root != null) killcache_str = __root.generateKillCacheString(date);
				xmlLoader1.load(new URLRequest(xml_URL+(killCachedFiles?killcache_str:'')));
			}
		}

	/****************************************************************************************************/
	//	Function. Processes the XML data (page module).
		
		private function xmlData1Processing(e:Event):void {
			xmlLoader1.removeEventListener(Event.COMPLETE, xmlData1Processing);
			xmlLoader1.removeEventListener(IOErrorEvent.IO_ERROR, xmlData1Error);
			data1XML = new XML(e.currentTarget.data);
			XMLParserObj = new XMLParser(this);
			XMLParserObj.settingsNodeParser(data1XML.settings); // processing "settings" node
			blocksArray = XMLParserObj.contentNodeParser(data1XML.content); // processing "content" node
			
			if (useSlideshow && slideshowXML != null && slideshowHeight > 0) {
				xmlLoader2 = new URLLoader();
				xmlLoader2.addEventListener(Event.COMPLETE, xmlData2Processing);
				xmlLoader2.addEventListener(IOErrorEvent.IO_ERROR, xmlData2Error);
				xmlLoader2.load(new URLRequest(slideshowXML+(killCachedFiles?killcache_str:'')));
			}
			
			if (blocksArray.length > 0) createBlocks();
			if (__root != null) createSingleItemArea();
			if (__root != null) __root.openNewPage(); // calls the openNewPage() function of the WebsiteTemplate class
		}
		
		private function xmlData1Error(e:IOErrorEvent):void {
			xmlLoader1.removeEventListener(Event.COMPLETE, xmlData1Processing);
			xmlLoader1.removeEventListener(IOErrorEvent.IO_ERROR, xmlData1Error);
		}
		
		/****************************************************************************************************/
	//	Function. Processes the XML data (banner rotator module).
		
		private function xmlData2Processing(e:Event):void {
			xmlLoader2.removeEventListener(Event.COMPLETE, xmlData2Processing);
			xmlLoader2.removeEventListener(IOErrorEvent.IO_ERROR, xmlData2Error);
			data2XML = new XMLList(e.currentTarget.data);
			brObj = new BannerRotator(data2XML, killCachedFiles, killcache_str, textStyleSheet);
			rotator = brObj.rotator;
			main.addChild(rotator);
			rotator.x = slideshowLeftMargin;
			rotator.y = slideshowTopMargin;
		}
		
		private function xmlData2Error(e:IOErrorEvent):void {
			xmlLoader2.removeEventListener(Event.COMPLETE, xmlData2Processing);
			xmlLoader2.removeEventListener(IOErrorEvent.IO_ERROR, xmlData2Error);
		}
	
	/****************************************************************************************************/
	//	Function. Creates text/image blocks, lists, separators.
		
		private function createBlocks():void {
			blocks_yPos = (useSlideshow && slideshowXML != null && slideshowHeight > 0) ? slideshowTopMargin + slideshowHeight + contentTopMargin : contentTopMargin;
			blocks.y = blocks_yPos;
			block_xPos = block_yPos = maxH_in_cols = block_in_col_yPos = maxW_in_col = 0;
			for (var i=0; i<blocksArray.length; i++) {
				if (blocksArray[i].cols) {
					if (blocksArray[i].type == "text") buildTextBlock(i, blocksArray[i].cols, blocksArray[i].col);
					if (blocksArray[i].type == "image") buildImageBlock(i, blocksArray[i].cols, blocksArray[i].col);
					if (blocksArray[i].type == "video" || blocksArray[i].type == "youtube") buildVideoBlock(i, blocksArray[i].cols, blocksArray[i].col);
					if (blocksArray[i].type == "list") buildList(i, blocksArray[i].cols, blocksArray[i].col);
					if (blocksArray[i].type == "link") buildLink(i, blocksArray[i].cols, blocksArray[i].col);
					if (blocksArray[i].type == "separator") buildSeparator(i, blocksArray[i].cols, blocksArray[i].col);
					if (blocksArray[i].type == "table") buildTable(i, blocksArray[i].cols, blocksArray[i].col);
				} else {
					if (blocksArray[i].type == "text") buildTextBlock(i);
					if (blocksArray[i].type == "image") buildImageBlock(i);
					if (blocksArray[i].type == "video" || blocksArray[i].type == "youtube") buildVideoBlock(i);
					if (blocksArray[i].type == "list") buildList(i);
					if (blocksArray[i].type == "link") buildLink(i);
					if (blocksArray[i].type == "separator") buildSeparator(i);
					if (blocksArray[i].type == "table") buildTable(i);
				}
			}
			attachScroller(); // attach a scroller to the blocks content
			stage.addEventListener(Event.RESIZE, onStageResized);
		}
		
	/****************************************************************************************************/
	//	Function. Attaches a scroller to the blocks content.
		
		public function attachScroller():void {
			var hitarea:Sprite = new Sprite();
			blocks.addChild(hitarea);
			blocks.hitArea = hitarea;
			hitarea.mouseEnabled = false;
			var maskXOffset:int = -20;
			if (__root != null) {
				var mask_w:uint = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin;
				var mask_h:uint = stage.stageHeight - __root.page_content.y - __root.module_container.y - blocks.y - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
				Geom.drawRectangle(hitarea, mask_w, blocks.height, 0xFF9900, 0);
				scrollerObj = new Scroller(blocks,
										   mask_w,
										   mask_h,
										   scrollBarTrackWidth,
										   scrollBarTrackColor,
										   scrollBarTrackAlpha,
										   scrollBarSliderOverWidth,
										   scrollBarSliderColor,
										   scrollBarSliderOverColor,
										   maskXOffset);
			} else {
				Geom.drawRectangle(hitarea, 980, blocks.height, 0xFF9900, 0);
				scrollerObj = new Scroller(blocks, 980, 750, scrollBarTrackWidth, scrollBarTrackColor, scrollBarTrackAlpha, scrollBarSliderOverWidth, scrollBarSliderColor, scrollBarSliderOverColor, maskXOffset);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Builds a text block.
	
		private function buildTextBlock(index:uint, cols:uint = 0, col:uint = 0):void {
			var tf_max_width:uint;
			var block:Sprite = new Sprite();
			block.name = "block"+(index+1);
			block.x = block_xPos + blocksArray[index].leftMargin;
			block.y = block_yPos + block_in_col_yPos + blocksArray[index].topMargin;
			blocks.addChild(block);
			if (__root != null) tf_max_width = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - block.x;
			else tf_max_width = 980 - block.x;
			tf_max_width -= 10; // increase the spacing between the right edge of a text field and the scroll bar
			var tf:TextField = new TextField();
			block.addChild(tf);
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			if (blocksArray[index].width != undefined) tf.width = blocksArray[index].width;
			else tf.width = tf_max_width;
			if (blocksArray[index].height != undefined) {
				tf.height = blocksArray[index].height;
				tf.autoSize = TextFieldAutoSize.NONE;
			} else {
				tf.autoSize = TextFieldAutoSize.LEFT;
			}
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
			var block_width:uint = Math.ceil(block.width);
			var block_height:uint = Math.ceil(block.height) - TEXT_LEADING - oneline_fix; // original height of the block
			setNextBlockParams(block, index, cols, col, block_width, block_height);
		}
		
	/****************************************************************************************************/
	//	Function. Builds an image block.
	
		private function buildImageBlock(index:uint, cols:uint = 0, col:uint = 0):void {
			var base:Shape, shadow_base:Shape, bg:Shape, blurred_bg_mask:Shape, caption_mask:Shape;
			var block:Sprite, img:Sprite, blurred_bg:Sprite, caption:Sprite, hitarea:Sprite;
			var hover_icon:MovieClip;
			var border_thickness:uint, img_width:uint, img_height:uint;
			block = new Sprite();
			block.name = "block"+(index+1);
			block.x = block_xPos + blocksArray[index].leftMargin;
			block.y = block_yPos + block_in_col_yPos + blocksArray[index].topMargin;
			blocks.addChild(block);
			block.addChild(shadow_base = new Shape());
			block.addChild(bg = new Shape());
			bg.name = "bg";
			hitarea = new Sprite();
			block.addChild(hitarea);
			hitarea.mouseEnabled = false;
			block.addChild(img = new Sprite());
			img.name = "img";
			img.hitArea = hitarea;
			block.addChild(blurred_bg = new Sprite());
			blurred_bg.name = "blurred_bg";
			blurred_bg.mouseEnabled = false;
			block.addChild(blurred_bg_mask = new Shape());
			blurred_bg_mask.name = "blurred_bg_mask";
			blurred_bg.mask = blurred_bg_mask;
			block.addChild(caption = new Sprite());
			caption.name = "caption";
			caption.mouseEnabled = caption.mouseChildren = false;
			block.addChild(caption_mask = new Shape());
			Geom.drawRectangle(caption_mask, blocksArray[index].imgWidth, blocksArray[index].imgHeight, 0xFF9900, 0);
			caption.mask = caption_mask;
			if (blocksArray[index].clickLink != undefined) hover_icon = new link_mc();
			else hover_icon = new zoom_mc();
			block.addChild(hover_icon);
			hover_icon.mouseEnabled = false;
			hover_icon.visible = false;
			hover_icon.name = "hover_icon";
			block.addChild(base = new Shape());
			base.name = "base";
			
			if (!isNaN(imageBorderColor) && imageBorderThickness > 0) border_thickness = imageBorderThickness;
			else border_thickness = 0;
			img_width = blocksArray[index].imgWidth + 2*imagePadding + 2*border_thickness;
			img_height = blocksArray[index].imgHeight + 2*imagePadding + 2*border_thickness;
			
			if (!isNaN(imageBgColor) && !isNaN(imageBgAlpha)) {
				Geom.drawRectangle(bg, blocksArray[index].imgWidth+2*imagePadding, blocksArray[index].imgHeight+2*imagePadding, imageBgColor, imageBgAlpha);
			}
			if (!isNaN(imageShadowColor) && !isNaN(imageShadowAlpha)) {
				Geom.drawRectangle(shadow_base, img_width, img_height, 0xFFFFFF, 1);
				var df:DropShadowFilter = new DropShadowFilter();
				df.color = imageShadowColor;
				df.alpha = imageShadowAlpha;
				df.distance = 0;
				df.angle = 0;
				df.quality = imageShadowQuality;
				df.blurX = df.blurY = imageShadowBlur;
				df.strength = imageShadowStrength;
				df.knockout = true;
				var dfArray:Array = new Array();
				dfArray.push(df);
				shadow_base.filters = dfArray;
			}
			if (!isNaN(imageBorderColor) && imageBorderThickness > 0) {
				Geom.drawBorder(base, blocksArray[index].imgWidth, blocksArray[index].imgHeight, imageBorderColor, 1, imageBorderThickness, imagePadding);
			}
			Geom.drawRectangle(hitarea, img_width, img_height, 0xFF9900, 0);
			
			bg.x = bg.y = border_thickness;
			img.x = img.y = blurred_bg.x = blurred_bg.y = blurred_bg_mask.x = caption.x = caption_mask.x = caption_mask.y = border_thickness + imagePadding;
			base.x = base.y = border_thickness + imagePadding;
			
			var tf:TextField = new TextField();
			tf.name = "tf";
			caption.addChild(tf);
			tf.x = tf.y = imageCaptionPadding;
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.width = blocksArray[index].imgWidth - 2*imageCaptionPadding;
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
			tf_bmp.x = tf_bmp.y = imageCaptionPadding;
			
			if (blocksArray[index].imgSrc != undefined) {
				if (!isNaN(imagePreloaderColor) && !isNaN(imagePreloaderAlpha)) {
					var preloader:MovieClip = new img_preloader();
					preloader.name = "preloader";
					block.addChild(preloader);
					preloader.x = Math.round((img_width-preloader.width)/2);
					preloader.y = Math.round((img_height-preloader.height)/2);
					var preloaderColor:ColorTransform = preloader.transform.colorTransform;
					preloaderColor.color = imagePreloaderColor;
					preloader.transform.colorTransform = preloaderColor;
					preloader.alpha = imagePreloaderAlpha;
				}
				var imageLoader:Loader = new Loader();
				imageLoader.name = "imageLoader"+(index+1);
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadComplete);
				imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
				imageLoader.load(new URLRequest(blocksArray[index].imgSrc+(killCachedFiles?killcache_str:'')));
			}
			var block_width:uint = Math.ceil(block.width);
			var block_height:uint = Math.ceil(block.height);
			setNextBlockParams(block, index, cols, col, block_width, block_height);
		}
		
	/****************************************************************************************************/
	//	Functions. Handles events on image loading.
		
		private function imageLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, imageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
			var index:uint = e.target.loader.name.substr(11)-1;
			var bmp:Bitmap = Bitmap(e.target.content);
			var block:Sprite = blocks.getChildByName("block"+(index+1)) as Sprite;
			var preloader:MovieClip = block.getChildByName("preloader") as MovieClip;
			if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.5*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[block, preloader]});
			var img:Sprite = block.getChildByName("img") as Sprite;
			img.alpha = 0;
			var bmpData:BitmapData;
			if (e.target.width != blocksArray[index].imgWidth || e.target.height != blocksArray[index].imgHeight) {
				bmp.smoothing = true;
				bmpData = bmp.bitmapData;
				var new_width:Number = blocksArray[index].imgWidth;
				var new_height:Number = blocksArray[index].imgHeight;
				var bmp_matrix:Matrix = new Matrix();
				var sx:Number = new_width/e.target.width;
				var sy:Number = new_height/e.target.height;
				bmp_matrix.scale(Math.max(sx,sy), Math.max(sx,sy));
				if (sy > sx) bmp_matrix.tx = -0.5*(e.target.width*sy-new_width);
				if (sx > sy) bmp_matrix.ty = -0.5*(e.target.height*sx-new_height);
				with (img.graphics) {
					beginBitmapFill(bmpData, bmp_matrix, true, true);
					lineTo(new_width, 0);
					lineTo(new_width, new_height);
					lineTo(0, new_height);
					lineTo(0, 0);
					endFill();
				}
			} else {
				img.addChild(bmp);
				bmpData = bmp.bitmapData;
			}
			blocksArray[index].imageBmpData = bmpData;
			
			var hover_icon:MovieClip = block.getChildByName("hover_icon") as MovieClip;
			var hoverIconColor:ColorTransform = hover_icon.transform.colorTransform;
			hoverIconColor.color = imageZoomIconColor;
			hover_icon.transform.colorTransform = hoverIconColor;
			hover_icon.alpha = imageZoomIconAlpha;
			hover_icon.x = Math.round((blocksArray[index].imgWidth-hover_icon.width)/2) + img.x;
			hover_icon.y = Math.round((blocksArray[index].imgHeight-hover_icon.height)/2) + img.y;
			
			Tweener.addTween(img, {alpha:1, time:FADE_DURATION, transition:"easeOutQuint"});
			if (imageOverBrightness != 0 || imageZoomIconAlpha != 0 || imageZoomIconOverAlpha != 0 || blocksArray[index].caption != undefined) {
				Image.drawCaption(block,
								blocksArray[index].imgWidth,
								blocksArray[index].imgHeight,
								bmpData,
								blocksArray[index].caption,
								textStyleSheet,
								imageCaptionBgColor,
								imageCaptionBgAlpha,
								imageCaptionBlurredBg,
								imageCaptionBgBlurAmount,
								imageCaptionPadding,
								"fade",
								imageOverBrightness,
								0.6,
								"hover_icon",
								imageZoomIconOverAlpha,
								imageZoomIconAlpha);
			}
			if (blocksArray[index].clickLink != undefined || (e.target.width > blocksArray[index].imgWidth || e.target.height > blocksArray[index].imgHeight)) {
				img.buttonMode = true;
				img.addEventListener(MouseEvent.CLICK, imgClickListener);
				hover_icon.visible = true;
			}
		}
		
		private function imageLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, imageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
			var index:uint = e.target.loader.name.substr(11)-1;
			var block:Sprite = blocks.getChildByName("block"+(index+1)) as Sprite;
			var preloader:MovieClip = block.getChildByName("preloader") as MovieClip;
			if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.5*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[block, preloader]});
		}
		
	/****************************************************************************************************/
	//	Function. Image click listener.
	
		private function imgClickListener(e:MouseEvent):void {
			var index:uint = e.target.parent.name.substr(5)-1;
			var link:String = blocksArray[index].clickLink;
			var target:String = blocksArray[index].clickTarget;
			var hover_icon:MovieClip = e.target.parent.getChildByName("hover_icon") as MovieClip;
			if (link != null) {
				if (target == null) target = "_blank";
				if (link == "#") SWFAddress.setValue("/");
				else {
					if (link.substr(0, 1) == "#") SWFAddress.setValue(link.substr(1));
					else {
						try { navigateToURL(new URLRequest(link), target); }
						catch (e:Error) { }
					}
				}
			} else if (hover_icon.visible == true && __root != null) {
				controls_blocked = menu_blocked = true;
				if (currentFsImageIndex != index) {
					currentFsImageIndex = index;
					changeFullscreenImage();
				}
				displaySingleItemView(true);
			}
		}		
		
	/****************************************************************************************************/
	//	Function. Removes an image preloader.
		
		private function removeImagePreloader(block:Sprite, preloader:MovieClip):void {
			block.removeChild(preloader);
			preloader = null;
		}
		
		
	/****************************************************************************************************/
	//	Function. Builds a video block.
	
		private function buildVideoBlock(index:uint, cols:uint = 0, col:uint = 0):void {
			var block:Sprite = new Sprite();
			block.name = "block"+(index+1);
			block.x = block_xPos + blocksArray[index].leftMargin;
			block.y = block_yPos + block_in_col_yPos + blocksArray[index].topMargin;
			blocks.addChild(block);
			block.alpha = 0;
			
			var videoURL:String = blocksArray[index].videoSrc;
			var previewImageURL:String = blocksArray[index].previewImage;
			var playbackQuality:String = blocksArray[index].playbackQuality;
			var videoAutoPlay:Boolean = blocksArray[index].autoPlay;
			videoPlayerWidth = blocksArray[index].videoWidth;
			videoPlayerHeight = blocksArray[index].videoHeight;
			if (blocksArray[index].type == "youtube") {
				blocksArray[index].vpObj = new VideoPlayerYouTube(this, killCachedFiles, textStyleSheet, videoURL, previewImageURL, playbackQuality, videoAutoPlay);
			} else if (blocksArray[index].type == "video") {
				blocksArray[index].vpObj = new VideoPlayer(this, killCachedFiles, textStyleSheet, videoURL, previewImageURL, videoAutoPlay);
			}
			if (blocksArray[index].vpObj != undefined) {
				videoplayer = blocksArray[index].vpObj.videoplayer;
				block.addChild(videoplayer);
				Tweener.addTween(block, {alpha:1, time:FADE_DURATION, transition:"easeOutQuint"});
			}
			var block_width:uint = Math.ceil(block.width);
			var block_height:uint = Math.ceil(block.height);
			setNextBlockParams(block, index, cols, col, block_width, block_height);
		}
		
	/****************************************************************************************************/
	//	Function. Builds a list.
	
		private function buildList(index:uint, cols:uint = 0, col:uint = 0):void {
			var tf_max_width:uint;
			var block:Sprite = new Sprite();
			block.name = "block"+(index+1);
			block.x = block_xPos + blocksArray[index].leftMargin;
			block.y = block_yPos + block_in_col_yPos + blocksArray[index].topMargin;
			if (__root != null) tf_max_width = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - block.x - listItemLeftPadding;
			else tf_max_width = 980 - block.x - listItemLeftPadding;
			tf_max_width -= 10; // increase the spacing between the right edge of a text field and the scroll bar
			blocks.addChild(block);
			
			var tf:TextField;
			var tf_yPos:uint = 0;
			var listitem:Sprite, marker:Sprite;
			var oneline_fix:uint = 0;
			for (var i=0; i<blocksArray[index].items.length; i++) {
				listitem = new Sprite();
				block.addChild(listitem);
				tf = new TextField();
				listitem.addChild(tf);
				if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
				if (blocksArray[index].width != undefined) tf.width = blocksArray[index].width;
				else tf.width = tf_max_width;
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
			var block_width:uint = Math.ceil(block.width);
			var block_height:uint = Math.ceil(block.height) - TEXT_LEADING - oneline_fix; // original height of the block
			setNextBlockParams(block, index, cols, col, block_width, block_height);
		}
		
	/****************************************************************************************************/
	//	Function. Builds a link block.
	
		private function buildLink(index:uint, cols:uint = 0, col:uint = 0):void {
			var block:Sprite = new Sprite();
			block.name = "block"+(index+1);
			block.x = block_xPos + blocksArray[index].leftMargin;
			block.y = block_yPos + block_in_col_yPos + blocksArray[index].topMargin;
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
			var block_width:uint = Math.ceil(block.width);
			var block_height:uint = Math.ceil(block.height);
			setNextBlockParams(block, index, cols, col, block_width, block_height);
		}
		
	/****************************************************************************************************/
	//	Function. Builds a separator.
	
		private function buildSeparator(index:uint, cols:uint = 0, col:uint = 0):void {
			var sep_max_width:uint, sep_width:uint;
			var block:Sprite = new Sprite();
			block.name = "block"+(index+1);
			block.x = block_xPos + blocksArray[index].leftMargin;
			block.y = block_yPos + block_in_col_yPos + blocksArray[index].topMargin;
			blocks.addChild(block);
			if (__root != null) sep_max_width = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - block.x;
			else sep_max_width = 980 - block.x;
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
			
			var block_width:uint = Math.ceil(block.width);
			var block_height:uint = Math.ceil(block.height);
			setNextBlockParams(block, index, cols, col, block_width, block_height);
		}
		
	/****************************************************************************************************/
	//	Function. Builds a table.
	
		private function buildTable(index:uint, cols:uint = 0, col:uint = 0):void {
			var block:Sprite = new Sprite();
			block.name = "block"+(index+1);
			block.x = block_xPos + blocksArray[index].leftMargin;
			block.y = block_yPos + block_in_col_yPos + blocksArray[index].topMargin;
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
			
			var block_width:uint = Math.ceil(block.width);
			var block_height:uint = Math.ceil(block.height);
			setNextBlockParams(block, index, cols, col, block_width, block_height);
		}
		
	/****************************************************************************************************/
	//	Function. Sets the coordinates and other parameters to be used by the next block in the array.
	
		private function setNextBlockParams(block:Sprite, index:uint, cols:uint, col:uint, block_width:uint, block_height:uint):void {
			if (cols && index < blocksArray.length-1) { // the block is in columns and not the last in the array
				if (blocksArray[index+1].cols == cols) { // the next block is in the same columns
					if (blocksArray[index+1].col == col) { // the next block is in the same column
						block_in_col_yPos += blocksArray[index].topMargin + block_height;
						if (block_in_col_yPos > maxH_in_cols) maxH_in_cols = block_in_col_yPos;
						if ((blocksArray[index].leftMargin + block_width) > maxW_in_col) maxW_in_col = blocksArray[index].leftMargin + block_width;
					} else { // the next block is in another column
						block_xPos += Math.max((blocksArray[index].leftMargin + block_width), maxW_in_col);
						if (index > 0 && blocksArray[index-1].col == col) { // the previous block is in the same column
							block_in_col_yPos += blocksArray[index].topMargin + block_height;
							if (block_in_col_yPos > maxH_in_cols) maxH_in_cols = block_in_col_yPos;
						}
						if ((blocksArray[index].topMargin + block_height) > maxH_in_cols) maxH_in_cols = blocksArray[index].topMargin + block_height;
						block_in_col_yPos = 0;
						maxW_in_col = 0;
					}
				} else { // the next block is not in columns or is in other columns
					if (index > 0 && blocksArray[index-1].cols == cols) { // the block is not the first in the array, the previous block is in the same columns
						if (blocksArray[index-1].col == col) { // the previous block is in the same column
							block_in_col_yPos += blocksArray[index].topMargin + block_height;
							if (block_in_col_yPos > maxH_in_cols) maxH_in_cols = block_in_col_yPos;
						}
						if ((blocksArray[index].topMargin + block_height) > maxH_in_cols) maxH_in_cols = blocksArray[index].topMargin + block_height;
						block_yPos += maxH_in_cols;
					} else { // this block is the only block in the current columns (and in the current column as well)
						block_yPos += blocksArray[index].topMargin + block_height;
					}
					block_xPos = 0;
					maxH_in_cols = 0;
					block_in_col_yPos = 0;
					maxW_in_col = 0;
				}
			} else {
				block_yPos += blocksArray[index].topMargin + block_height;
				maxH_in_cols = 0;
				block_in_col_yPos = 0;
				maxW_in_col = 0;
			}
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
						Tweener.addTween(fsimg, {delay:0.4*FADE_DURATION, onComplete:function(){controls_blocked = false;}});
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
			if (!isNaN(currentFsImageIndex)) {
				var bmpData:BitmapData = blocksArray[currentFsImageIndex].imageBmpData;
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
					Tweener.addTween(fsimg, {delay:0.4*FADE_DURATION, onComplete:function(){controls_blocked = false;}});
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
			if (blocksArray[currentFsImageIndex].imageBmpData != undefined) {
				drawFullscreenImage(container, blocksArray[currentFsImageIndex].imageBmpData);
			}
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
			Utils.removeTweens(__root.gallery_container);
			if (scrollerObj != null) {
				scrollerObj.destroyScroller();
				scrollerObj = null;
			}
			if (brObj != null) {
				brObj.killBannerRotator();
				brObj = null;
			}
			for (var i=0; i<blocksArray.length; i++) {
				if (blocksArray[i].vpObj != undefined) {
					blocksArray[i].vpObj.killVideoPlayer();
					blocksArray[i].vpObj = null;
				}
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