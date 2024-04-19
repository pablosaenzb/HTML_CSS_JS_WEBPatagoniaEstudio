/**
	Homepage class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.homepage {
	
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
	import com.emerald.phlex.bannerrotator.BannerRotator;
	import com.emerald.phlex.utils.Geom;
	import com.emerald.phlex.utils.Image;
	import com.emerald.phlex.utils.Scroller;
	import com.emerald.phlex.utils.Utils;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import caurina.transitions.*;
	import caurina.transitions.properties.ColorShortcuts;

	public class Homepage extends Sprite {
		
		public var main:Sprite, rotator:Sprite, slogan:Sprite, teasers:Sprite, bottom_sep:Sprite, blocks:Sprite;
		private var __root:*;
		private var xml_URL:String;
		private var xmlLoader:URLLoader;
		private var dataXML:XML;
		private var XMLParserObj:Object, brObj:Object, scrollerObj:Object;
		private var teasersArray:Array, blocksArray:Array;
		private var killcache_str:String;
		private var killCachedFiles:Boolean = false;
		private var textStyleSheet:StyleSheet;
		private var teasers_visarea_width:uint, teasers_full_width:uint, teaser_width:uint, teaser_height:uint;
		private var block_xPos:uint, block_yPos:uint, maxH_in_cols:uint;
		private var block_in_col_yPos:uint, maxW_in_col:uint;
		private var blocks_yPos:uint = 0;
		private static const FADE_DURATION:Number = 1;
		private static const MOVE_DURATION:Number = 0.5;
		private static const ON_ROLL_DURATION:Number = 0.2;
		private static const NAV_BUTTON_ICON_PADDING:uint = 8;
		private static const SLOGAN_TEXT_LEADING:uint = 4;
		private static const TEXT_LEADING:uint = 6;
		
		// Slogan properties
		public var sloganWidth:Number;
		public var sloganTopMargin:uint = 0;
		public var sloganLeftMargin:uint = 0;
		public var sloganText:String;
		
		// Teasers properties
		public var teasersTopMargin:uint = 0;
		public var teasersType:String = "1";
		public var teasersVisible:uint = 3;
		public var teaserWidth:uint = 200;
		public var teaserHeight:uint = 100;
		public var teaserSpacing:uint = 30;
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
		public var imageLinkIconAlpha:Number = 0;
		public var imageLinkIconOverAlpha:Number = 0;
		public var imageBottomMargin:uint = 0;
		public var titleBottomPadding:uint = 0;
		public var leftNavButtonURL:String;
		public var rightNavButtonURL:String;
		public var navButtonColor:uint = 0x757575;
		public var navButtonOverColor:uint = 0x333333;
		public var navButtonPadding:uint = 10;
		
		// Bottom separator properties
		public var bottomSeparatorWidth:Number;
		public var bottomSeparatorHeight:uint = 1;
		public var bottomSeparatorTopMargin:uint = 0;
		public var bottomSeparatorLeftMargin:uint = 0;
		public var bottomSeparatorColor:uint = 0x666666;
		public var bottomSeparatorIconURL:String;
		
		// Bottom content properties
		public var bottomContentTopMargin:uint = 0;
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
		
		ColorShortcuts.init();	// initiates the ColorShortcuts special properties of the Tweener class
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function Homepage():void {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addChild(main = new Sprite());
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the Homepage object is added to the Stage.
	
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the SWF file is resized.
		
		private function onStageResized(e:Event):void {
			blocks.y = blocks_yPos;
			var mask_h:uint = stage.stageHeight - __root.page_content.y - __root.module_container.y - blocks.y - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
			scrollerObj.onStageResized(mask_h);
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
			
			// Banner rotator
			brObj = new BannerRotator(dataXML.rotator, killCachedFiles, killcache_str, textStyleSheet);
			rotator = brObj.rotator;
			main.addChild(rotator);
			if (__root != null) rotator.x = Math.ceil(0.5*(__root.templateWidth-__root.contentPageLeftMargin-__root.contentPageRightMargin-rotator.width));
			else rotator.x = Math.ceil(450 - rotator.width/2);
			
			// Slogan text
			if (dataXML.slogan != undefined) {
				XMLParserObj.sloganNodeParser(dataXML.slogan); // processing "slogan" node
				if (sloganText != null) createSlogan();
			}
			
			// Teasers
			if (dataXML.teasers != undefined) {
				XMLParserObj.teasersSettingsNodeParser(dataXML.teasers.settings); // processing "teasers" -> "settings" node
				teasersArray = XMLParserObj.teasersNodeParser(dataXML.teasers); // processing "teasers" node
				if (teasersArray.length > 0) createTeasers();
			}
			
			// Bottom separator
			if (dataXML.bottomSeparator != undefined && teasersType == "1") {
				XMLParserObj.bottomSeparatorNodeParser(dataXML.bottomSeparator); // processing "bottomSeparator" node
				createBottomSeparator();
			}
			
			// Bottom content
			if (dataXML.bottomContent != undefined && teasersType == "1") {
				XMLParserObj.bottomContentSettingsNodeParser(dataXML.bottomContent.settings); // processing "bottomContent" -> "settings" node
				blocksArray = XMLParserObj.bottomContentNodeParser(dataXML.bottomContent); // processing "bottomContent" node
				if (blocksArray.length > 0) createBlocks();
			}
			
			if (__root != null) __root.openNewPage(); // calls the openNewPage() function of the WebsiteTemplate class
		}
		
		private function xmlDataError(e:IOErrorEvent):void {
			xmlLoader.removeEventListener(Event.COMPLETE, xmlDataProcessing);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlDataError);
		}
		
	/****************************************************************************************************/
	//	Function. Builds the slogan text block.
	
		private function createSlogan():void {
			main.addChild(slogan = new Sprite());
			slogan.x = sloganLeftMargin;
			slogan.y = rotator.height + sloganTopMargin;
			var tf_max_width:uint;
			if (__root != null) tf_max_width = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - slogan.x;
			else tf_max_width = 980 - slogan.x;
			var tf:TextField = new TextField();
			slogan.addChild(tf);
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			if (!isNaN(sloganWidth)) tf.width = sloganWidth;
			else tf.width = tf_max_width;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.embedFonts = true;
			tf.selectable = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			if (sloganText != null) tf.htmlText = sloganText;
			tf.height += SLOGAN_TEXT_LEADING; // disables TextField scrolling on selection (also is a workaround for "jumpy htmlText hyperlinks")
			tf.autoSize = TextFieldAutoSize.NONE;
		}
		
	/****************************************************************************************************/
	//	Function. Builds the teasers.
	
		private function createTeasers():void {
			
			main.addChild(teasers = new Sprite());
			var container:Sprite = new Sprite();
			container.name = "container";
			teasers.addChild(container);
			var container_mask:Sprite = new Sprite();
			container_mask.name = "container_mask";
			teasers.addChild(container_mask);
			container.cacheAsBitmap = container_mask.cacheAsBitmap = true;
			container.mask = container_mask;
			
			var border_thickness:uint = 0;
			if (!isNaN(imageBorderColor) && imageBorderThickness > 0) border_thickness = imageBorderThickness;
			teaser_width = teaserWidth + 2*imagePadding + 2*border_thickness;
			teaser_height = teaserHeight + 2*imagePadding + 2*border_thickness;
			teasers_visarea_width = teaser_width*Math.min(teasersVisible, teasersArray.length) + teaserSpacing*(Math.min(teasersVisible, teasersArray.length)-1);
			teasers_full_width = teaser_width*teasersArray.length + teaserSpacing*(teasersArray.length-1);
			if (__root != null) teasers.x = Math.round(0.5*(__root.templateWidth-__root.contentPageLeftMargin-__root.contentPageRightMargin-teasers_visarea_width));
			else teasers.x = 450 - Math.round(teasers_visarea_width/2);
			teasers.y = rotator.height + (slogan?sloganTopMargin+Math.ceil(slogan.height):0) + teasersTopMargin;
			
			// Teasers mask
			var mask_y_offset:uint = 20;
			var gradient_left:MovieClip = new grad_mask_left();
			var gradient_right:MovieClip = new grad_mask_right();
			gradient_left.height = gradient_right.height = teaser_height + 2*mask_y_offset;
			container_mask.addChild(gradient_left);
			container_mask.addChild(gradient_right);
			var mask_width_add:int = 2*(teaserSpacing - gradient_left.width);
			Geom.drawRectangle(container_mask, teasers_visarea_width+mask_width_add, teaser_height+2*mask_y_offset, 0xFF9900, 1, 0, 0, 0, 0, gradient_left.width, 0);
			gradient_right.x = gradient_left.width + teasers_visarea_width + mask_width_add;
			container_mask.x = -gradient_left.width - 0.5*mask_width_add;
			container_mask.y = -mask_y_offset;
			
			var teaser_xPos:uint = 0;
			var base:Shape, shadow_base:Shape, bg:Shape, blurred_bg_mask:Shape, caption_mask:Shape;
			var teaser:Sprite, img:Sprite, blurred_bg:Sprite, title:Sprite, caption:Sprite, hitarea:Sprite;
			var hover_icon:MovieClip;
			var tf1:TextField, tf2:TextField;
			if (!isNaN(imageShadowColor) && !isNaN(imageShadowAlpha)) {
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
			}
			
			// *** Teasers
			for (var i=0; i<teasersArray.length; i++) {
				teaser = new Sprite();
				teaser.name = "teaser"+(i+1);
				teaser.x = teaser_xPos;
				teaser.y = 0;
				container.addChild(teaser);
				teaser.addChild(shadow_base = new Shape());
				shadow_base.name = "shadow_base";
				teaser.addChild(bg = new Shape());
				bg.name = "bg";
				hitarea = new Sprite();
				teaser.addChild(hitarea);
				hitarea.mouseEnabled = false;
				teaser.addChild(img = new Sprite());
				img.name = "img";
				img.hitArea = hitarea;
				teaser.addChild(blurred_bg = new Sprite());
				blurred_bg.name = "blurred_bg";
				blurred_bg.mouseEnabled = false;
				teaser.addChild(blurred_bg_mask = new Shape());
				blurred_bg_mask.name = "blurred_bg_mask";
				blurred_bg.mask = blurred_bg_mask;
				teaser.addChild(title = new Sprite());
				title.name = "title";
				teaser.addChild(caption = new Sprite());
				caption.name = "caption";
				if (teasersType == "1") caption.mouseEnabled = caption.mouseChildren = false;
				teaser.addChild(caption_mask = new Shape());
				Geom.drawRectangle(caption_mask, teaserWidth, teaserHeight, 0xFF9900, 0);
				if (teasersType == "1") caption.mask = caption_mask;
				hover_icon = new link_mc();
				teaser.addChild(hover_icon);
				hover_icon.mouseEnabled = false;
				hover_icon.visible = false;
				hover_icon.name = "hover_icon";
				teaser.addChild(base = new Shape());
				base.name = "base";
				if (!isNaN(imageBgColor) && !isNaN(imageBgAlpha)) {
					Geom.drawRectangle(bg, teaserWidth+2*imagePadding, teaserHeight+2*imagePadding, imageBgColor, imageBgAlpha);
				}
				if (!isNaN(imageShadowColor) && !isNaN(imageShadowAlpha)) {
					Geom.drawRectangle(shadow_base, teaser_width, teaser_height, 0xFFFFFF, 1);
					shadow_base.filters = dfArray;
				}
				if (!isNaN(imageBorderColor) && imageBorderThickness > 0) {
					Geom.drawBorder(base, teaserWidth, teaserHeight, imageBorderColor, 1, imageBorderThickness, imagePadding);
				}
				Geom.drawRectangle(hitarea, teaser_width, teaser_height, 0xFF9900, 0);
				
				bg.x = bg.y = border_thickness;
				img.x = img.y = blurred_bg.x = blurred_bg.y = blurred_bg_mask.x = caption.x = caption_mask.x = caption_mask.y = border_thickness + imagePadding;
				base.x = base.y = border_thickness + imagePadding;
				
				// Title
				if (teasersType == "2") {
					title.y = teaser_height + imageBottomMargin;
					title.addChild(tf1 = new TextField());
					tf1.name = "tf";
					if (textStyleSheet != null) tf1.styleSheet = textStyleSheet;
					tf1.width = teaser_width;
					tf1.autoSize = TextFieldAutoSize.LEFT;
					tf1.multiline = true;
					tf1.wordWrap = true;
					tf1.embedFonts = true;
					tf1.selectable = true;
					tf1.antiAliasType = AntiAliasType.ADVANCED;
					if (teasersArray[i].title != undefined) tf1.htmlText = teasersArray[i].title;
				}
				
				// Caption
				caption.addChild(tf2 = new TextField());
				tf2.name = "tf";
				if (textStyleSheet != null) tf2.styleSheet = textStyleSheet;
				tf2.autoSize = TextFieldAutoSize.LEFT;
				tf2.multiline = true;
				tf2.wordWrap = true;
				tf2.embedFonts = true;
				tf2.antiAliasType = AntiAliasType.ADVANCED;
				if (teasersType == "1") {
					tf2.x = tf2.y = imageCaptionPadding;
					tf2.width = teaserWidth - 2*imageCaptionPadding;
					tf2.selectable = false;
					tf2.visible = false;
					var tf_bmp:Sprite = new Sprite();
					tf_bmp.name = "tf_bmp";
					caption.addChild(tf_bmp);
					tf_bmp.x = tf_bmp.y = imageCaptionPadding;
				} else if (teasersType == "2") {
					caption.x = 0;
					caption.y = teaser_height + imageBottomMargin + (tf1.htmlText != ""?Math.ceil(title.height)+titleBottomPadding:0);
					tf2.width = teaser_width;
					tf2.selectable = true;
					if (teasersArray[i].caption != undefined) {
						tf2.htmlText = teasersArray[i].caption;
						tf2.height += TEXT_LEADING; // disables TextField scrolling on selection (also is a workaround for "jumpy htmlText hyperlinks")
						tf2.autoSize = TextFieldAutoSize.NONE;
					}
					if (teasersArray[i].blocks != undefined) createTeaserLink(teaser, i);
					attachScroller2(caption, caption.y, i); // attach a scroller to a teaser caption
				}
				
				if (teasersArray[i].imgSrc != undefined) {
					if (!isNaN(imagePreloaderColor) && !isNaN(imagePreloaderAlpha)) {
						var preloader:MovieClip = new img_preloader();
						preloader.name = "preloader";
						teaser.addChild(preloader);
						preloader.x = Math.round((teaser_width-preloader.width)/2);
						preloader.y = Math.round((teaser_height-preloader.height)/2);
						var preloaderColor:ColorTransform = preloader.transform.colorTransform;
						preloaderColor.color = imagePreloaderColor;
						preloader.transform.colorTransform = preloaderColor;
						preloader.alpha = imagePreloaderAlpha;
					}
					var imageLoader:Loader = new Loader();
					imageLoader.name = "imageLoader"+(i+1);
					imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadComplete);
					imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
					imageLoader.load(new URLRequest(teasersArray[i].imgSrc+(killCachedFiles?killcache_str:'')));
				}
				teaser_xPos += teaser_width + teaserSpacing;
			}
			container_mask.height = container.height + 2*mask_y_offset;
			// ***
			
			// Navigation buttons
			if (leftNavButtonURL != null && rightNavButtonURL != null && teasersArray.length > teasersVisible) {
				var nav_but1:Sprite, nav_but2:Sprite;
				teasers.addChild(nav_but1 = new Sprite());
				nav_but1.name = "nav_but1";
				teasers.addChild(nav_but2 = new Sprite());
				nav_but2.name = "nav_but2";
				var navBut1Loader:Loader = new Loader();
				navBut1Loader.name = "L";
				navBut1Loader.contentLoaderInfo.addEventListener(Event.COMPLETE, navButLoadComplete);
				navBut1Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
				navBut1Loader.load(new URLRequest(leftNavButtonURL+(killCachedFiles?killcache_str:'')));
				var navBut2Loader:Loader = new Loader();
				navBut2Loader.name = "R";
				navBut2Loader.contentLoaderInfo.addEventListener(Event.COMPLETE, navButLoadComplete);
				navBut2Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
				navBut2Loader.load(new URLRequest(rightNavButtonURL+(killCachedFiles?killcache_str:'')));
			}
		}
		
	/****************************************************************************************************/
	//	Functions. Handles events on teaser image loading.
		
		private function imageLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, imageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
			var index:uint = e.target.loader.name.substr(11)-1;
			var bmp:Bitmap = Bitmap(e.target.content);
			var container:Sprite = teasers.getChildByName("container") as Sprite;
			var teaser:Sprite = container.getChildByName("teaser"+(index+1)) as Sprite;
			var preloader:MovieClip = teaser.getChildByName("preloader") as MovieClip;
			if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.5*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[teaser, preloader]});
			var shadow_base:Shape = teaser.getChildByName("shadow_base") as Shape;
			var bg:Shape = teaser.getChildByName("bg") as Shape;
			var img:Sprite = teaser.getChildByName("img") as Sprite;
			var base:Shape = teaser.getChildByName("base") as Shape;
			var caption:Sprite = teaser.getChildByName("caption") as Sprite;
			img.alpha = 0;
			var bmpData:BitmapData;
			if (e.target.width != teaserWidth || e.target.height != teaserHeight) {
				bmp.smoothing = true;
				bmpData = bmp.bitmapData;
				var bmp_matrix:Matrix = new Matrix();
				var sx:Number = teaserWidth/e.target.width;
				var sy:Number = teaserHeight/e.target.height;
				bmp_matrix.scale(Math.max(sx,sy), Math.max(sx,sy));
				if (sy > sx) bmp_matrix.tx = -0.5*(e.target.width*sy-teaserWidth);
				if (sx > sy) bmp_matrix.ty = -0.5*(e.target.height*sx-teaserHeight);
				with (img.graphics) {
					beginBitmapFill(bmpData, bmp_matrix);
					lineTo(teaserWidth, 0);
					lineTo(teaserWidth, teaserHeight);
					lineTo(0, teaserHeight);
					lineTo(0, 0);
					endFill();
				}
			} else {
				img.addChild(bmp);
				bmpData = bmp.bitmapData;
			}
			
			Tweener.addTween(img, {alpha:1, time:FADE_DURATION, transition:"easeOutQuint"});
			if (teasersType == "1") {
				if (!(imageOverBrightness == 0 && teasersArray[index].caption == undefined)) {
					Image.drawCaption(teaser,
										teaserWidth,
										teaserHeight,
										bmpData,
										teasersArray[index].caption,
										textStyleSheet,
										imageCaptionBgColor,
										imageCaptionBgAlpha,
										imageCaptionBlurredBg,
										imageCaptionBgBlurAmount,
										imageCaptionPadding,
										"fade",
										imageOverBrightness);
				}
			}
			
			if (teasersType == "2") {
				var hover_icon:MovieClip = teaser.getChildByName("hover_icon") as MovieClip;
				hover_icon.alpha = imageLinkIconAlpha;
				hover_icon.x = Math.round((teaser_width-hover_icon.width)/2);
				hover_icon.y = Math.round((teaser_height-hover_icon.height)/2);
				if (imageOverBrightness != 0 || imageLinkIconAlpha != 0 || imageLinkIconOverAlpha != 0) {
					Image.drawCaption(teaser, teaserWidth, teaserHeight, null, null, null, NaN, NaN, false, NaN, 0, null, imageOverBrightness, 0.6, "hover_icon", imageLinkIconOverAlpha, imageLinkIconAlpha);
				}
			}
			
			if (teasersArray[index].clickLink != undefined) {
				var link:String = teasersArray[index].clickLink;
				var target:String = teasersArray[index].clickTarget;
				if (target == null) target = "_blank";
				if (teasersType == "2") hover_icon.visible = true;
				img.buttonMode = true;
				img.addEventListener(MouseEvent.CLICK,
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
		}
		
		private function imageLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, imageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
			var index:uint = e.target.loader.name.substr(11)-1;
			var container:Sprite = teasers.getChildByName("container") as Sprite;
			var teaser:Sprite = container.getChildByName("teaser"+(index+1)) as Sprite;
			var preloader:MovieClip = teaser.getChildByName("preloader") as MovieClip;
			if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.5*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[teaser, preloader]});
		}
		
		
	/****************************************************************************************************/
	//	Function. Removes an image preloader.
		
		private function removeImagePreloader(teaser:Sprite, preloader:MovieClip):void {
			teaser.removeChild(preloader);
			preloader = null;
		}
		
	/****************************************************************************************************/
	//	Functions. Handles events on navigation button loading.
		
		private function navButLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, navButLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
			var button:String = e.target.loader.name;
			var index:uint = (button=="L"?1:2);
			var container:Sprite = teasers.getChildByName("container") as Sprite;
			var nav_but:Sprite = teasers.getChildByName("nav_but"+index) as Sprite;
			nav_but.alpha = 0;
			var nav_but_other:Sprite = teasers.getChildByName("nav_but"+(button=="L"?2:1)) as Sprite;
			var bmp:Bitmap = Bitmap(e.target.content);
			var hitarea:Sprite = new Sprite();
			nav_but.addChild(hitarea);
			Geom.drawRectangle(hitarea, bmp.width+2*NAV_BUTTON_ICON_PADDING, bmp.height+2*NAV_BUTTON_ICON_PADDING, 0xFF9900, 0);
			nav_but.hitArea = hitarea;
			nav_but.addChild(bmp);
			bmp.x = bmp.y = NAV_BUTTON_ICON_PADDING;
			if (button == "L") {
				nav_but.x = -(nav_but.width + navButtonPadding);
				nav_but.buttonMode = false;
			}
			if (button == "R") {
				nav_but.x = teasers_visarea_width + navButtonPadding;
				nav_but.buttonMode = true;
			}
			nav_but.y = Math.round(0.5*(teaser_height-bmp.height)) - NAV_BUTTON_ICON_PADDING;
			var navButColor:ColorTransform = nav_but.transform.colorTransform;
			navButColor.color = navButtonColor;
			nav_but.transform.colorTransform = navButColor;
			
			Tweener.addTween(nav_but, {alpha:(button=="L"?0.7:1), time:0.5*FADE_DURATION, transition:"easeOutQuint"});
			
			nav_but.addEventListener(MouseEvent.ROLL_OVER,
				function(e:MouseEvent) {
					if (nav_but.alpha == 1) {
						Tweener.removeTweens(nav_but);
						Tweener.addTween(nav_but, {_color:navButtonOverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
				}
			);
			nav_but.addEventListener(MouseEvent.ROLL_OUT,
				function(e:MouseEvent) {
					if (nav_but.alpha == 1) {
						Tweener.removeTweens(nav_but);
						Tweener.addTween(nav_but, {_color:navButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
				}
			);
			nav_but.addEventListener(MouseEvent.CLICK,
				function(e:MouseEvent) {
					var new_x:int;
					var end_point1:int = 0;
					var end_point2:int = Math.round(teasers_visarea_width-teasers_full_width);
					if (button == "L") {
						if (Tweener.isTweening(container) == false) {
							new_x = Math.round(container.x + teaser_width + teaserSpacing);
							if (new_x <= end_point1) {
								if (new_x == end_point1) {
									nav_but.alpha = 0.7;
									nav_but.buttonMode = false;
									Tweener.addTween(nav_but, {_color:navButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
								}
								nav_but_other.alpha = 1;
								nav_but_other.buttonMode = true;
								Tweener.addTween(container, {x:new_x, time:MOVE_DURATION, transition:"easeInOutQuint"});
							}
						}
					}
					if (button == "R") {
						if (Tweener.isTweening(container) == false) {
							new_x = Math.round(container.x - teaser_width - teaserSpacing);
							if (new_x >= end_point2) {
								if (new_x == end_point2) {
									nav_but.alpha = 0.7;
									nav_but.buttonMode = false;
									Tweener.addTween(nav_but, {_color:navButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
								}
								nav_but_other.alpha = 1;
								nav_but_other.buttonMode = true;
								Tweener.addTween(container, {x:new_x, time:MOVE_DURATION, transition:"easeInOutQuint"});
							}
						}
					}
				}
			);
		}
		
		private function navButLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, navButLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
		}
		
	/****************************************************************************************************/
	//	Function. Creates the link for a specified teaser (teasersType = 2).
		
		private function createTeaserLink(teaser:Sprite, index:uint):void {
			var caption:Sprite = teaser.getChildByName("caption") as Sprite;
			var tf:TextField = caption.getChildByName("tf") as TextField;
			var block:Sprite = new Sprite();
			caption.addChild(block);
			block.name = "block";
			if (tf.htmlText != "") block.y = Math.ceil(tf.height) - TEXT_LEADING + teasersArray[index].blocks[0].topMargin;
			else block.y = 0;
			var linkArray:Array = teasersArray[index].blocks;
			
			tf = new TextField();
			block.addChild(tf);
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = false;
			tf.wordWrap = false;
			tf.embedFonts = true;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			if (linkArray[0].text != undefined) tf.htmlText = linkArray[0].text;
			if (linkArray[0].align == "right") tf.x = linkArray[0].leftPadding;
			
			// *** Link icon loading
			if (linkArray[0].iconURL != null) {
				var icon:Sprite = new Sprite();
				block.addChild(icon);
				icon.y = linkArray[0].iconTopPadding;
				var iconLoader:Loader = new Loader();
				iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,
					function(e:Event) {
						if (linkArray[0].align == "left") iconLoader.x = Math.ceil(tf.width) + linkArray[0].rightPadding - e.target.content.width;
						Geom.drawRectangle(block, Math.ceil(block.width), Math.ceil(block.height), 0xFFFFFF, 0);
					}
				);
				iconLoader.load(new URLRequest(linkArray[0].iconURL+(killCachedFiles?killcache_str:'')));
				icon.addChild(iconLoader);
			}
			// ***
			
			var linkColor:ColorTransform = block.transform.colorTransform;
			linkColor.color = linkArray[0].color;
			block.transform.colorTransform = linkColor;
			block.buttonMode = true;
			block.addEventListener(MouseEvent.ROLL_OVER,
				function(e:MouseEvent) {
					Tweener.removeTweens(block);
					Tweener.addTween(block, {_color:linkArray[0].hoverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
				}
			);
			block.addEventListener(MouseEvent.ROLL_OUT,
				function(e:MouseEvent) {
					Tweener.removeTweens(block);
					Tweener.addTween(block, {_color:linkArray[0].color, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
				}
			);
				
			if (linkArray[0].clickLink != undefined) {
				var link:String = linkArray[0].clickLink;
				var target:String = linkArray[0].clickTarget;
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
		}
		
	/****************************************************************************************************/
	//	Function. Attaches a scroller to a teaser caption (teasersType = 2).
		
		private function attachScroller2(caption:Sprite, caption_yPos:uint, index:uint):void {
			var hitarea:Sprite = new Sprite();
			caption.addChild(hitarea);
			caption.hitArea = hitarea;
			hitarea.mouseEnabled = false;
			var mask_w:uint = teaser_width;
			if (__root != null) {
				var mask_h:uint = stage.stageHeight - __root.page_content.y - __root.module_container.y - teasers.y - caption.y - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
				Geom.drawRectangle(hitarea, mask_w, caption.height, 0xFF9900, 0);
				teasersArray[index].scroller = new Scroller(caption,
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
							caption.y = caption_yPos;
							mask_h = stage.stageHeight - __root.page_content.y - __root.module_container.y - teasers.y - caption.y - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
							teasersArray[index].scroller.onStageResized(mask_h);
						}
					}
				);
			} else {
				Geom.drawRectangle(hitarea, mask_w, caption.height, 0xFF9900, 0);
				teasersArray[index].scroller = new Scroller(caption, mask_w, 100, scrollBarTrackWidth, scrollBarTrackColor, scrollBarTrackAlpha, scrollBarSliderOverWidth, scrollBarSliderColor, scrollBarSliderOverColor);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Builds the bottom separator.
	
		private function createBottomSeparator():void {
			main.addChild(bottom_sep = new Sprite());
			bottom_sep.x = bottomSeparatorLeftMargin;
			bottom_sep.y = rotator.height + (slogan?sloganTopMargin+Math.ceil(slogan.height):0) + (teasers?teasersTopMargin+teaser_height:0) + bottomSeparatorTopMargin;
			
			var sep_max_width:uint, sep_width:uint;
			if (__root != null) sep_max_width = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - bottom_sep.x;
			else sep_max_width = 980 - bottom_sep.x;
			if (!isNaN(bottomSeparatorWidth)) sep_width = bottomSeparatorWidth;
			else sep_width = sep_max_width;
			
			// *** Separator icon loading
			if (bottomSeparatorIconURL != null) {
				var separator:Sprite = new Sprite();
				var separator_mask:Shape = new Shape();
				bottom_sep.addChild(separator);
				bottom_sep.addChild(separator_mask);
				Geom.drawRectangle(separator_mask, sep_width, bottomSeparatorHeight, 0xFF9900, 0);
				separator.mask = separator_mask;
				var separatorLoader:Loader = new Loader();
				separatorLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,
					function(e:Event) {
						if (e.target.content.height < bottomSeparatorHeight) e.target.content.height = bottomSeparatorHeight;
					}
				);
				separatorLoader.load(new URLRequest(bottomSeparatorIconURL+(killCachedFiles?killcache_str:'')));
				separator.addChild(separatorLoader);
				var separatorColor:ColorTransform = separator.transform.colorTransform;
				separatorColor.color = bottomSeparatorColor;
				separator.transform.colorTransform = separatorColor;
			}
			// ***
		}
		
	/****************************************************************************************************/
	//	Function. Creates text blocks, lists, links and separators (teasersType = 1).
		
		private function createBlocks():void {
			main.addChild(blocks = new Sprite());
			blocks_yPos = rotator.height + (slogan?sloganTopMargin+Math.ceil(slogan.height):0) + (teasers?teasersTopMargin+teaser_height:0) + (bottom_sep?bottomSeparatorTopMargin+bottom_sep.height:0) + bottomContentTopMargin;
			blocks.y = blocks_yPos;
			block_xPos = block_yPos = maxH_in_cols = block_in_col_yPos = maxW_in_col = 0;
			for (var i=0; i<blocksArray.length; i++) {
				if (blocksArray[i].cols) {
					if (blocksArray[i].type == "text") buildTextBlock(i, blocksArray[i].cols, blocksArray[i].col);
					if (blocksArray[i].type == "list") buildList(i, blocksArray[i].cols, blocksArray[i].col);
					if (blocksArray[i].type == "link") buildLink(i, blocksArray[i].cols, blocksArray[i].col);
					if (blocksArray[i].type == "separator") buildSeparator(i, blocksArray[i].cols, blocksArray[i].col);
				} else {
					if (blocksArray[i].type == "text") buildTextBlock(i);
					if (blocksArray[i].type == "list") buildList(i);
					if (blocksArray[i].type == "link") buildLink(i);
					if (blocksArray[i].type == "separator") buildSeparator(i);
				}
			}
			attachScroller1(); // attach a scroller to the blocks content
			stage.addEventListener(Event.RESIZE, onStageResized);
		}
		
	/****************************************************************************************************/
	//	Function. Attaches a scroller to the blocks content (teasersType = 1).
		
		private function attachScroller1():void {
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
				scrollerObj = new Scroller(blocks, 980, 200, scrollBarTrackWidth, scrollBarTrackColor, scrollBarTrackAlpha, scrollBarSliderOverWidth, scrollBarSliderColor, scrollBarSliderOverColor, maskXOffset);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Builds a text block.
	
		private function buildTextBlock(index:uint, cols:uint = 0, col:uint = 0):void {
			var tf_max_width:uint;
			var block:Sprite = new Sprite();
			block.x = block_xPos + blocksArray[index].leftMargin;
			block.y = block_yPos + block_in_col_yPos + blocksArray[index].topMargin;
			blocks.addChild(block);
			if (__root != null) tf_max_width = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - block.x;
			else tf_max_width = 980 - block.x;
			tf_max_width -= 10; // increase the spacing between the right edge of a text field and the scroll bar
			var tf:TextField = new TextField();
			block.addChild(tf);
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			if (blocksArray[index].width != undefined) {
				tf.width = blocksArray[index].width;
				tf.width -= 5; // increase the spacing between the right edge of a text field and the scroll bar
			} else tf.width = tf_max_width;
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
	//	Function. Builds a list.
	
		private function buildList(index:uint, cols:uint = 0, col:uint = 0):void {
			var tf_max_width:uint;
			var block:Sprite = new Sprite();
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
	//	Function. Performs a number of actions for deactivating the module.
	//	Called from the pageContentClosed() function of the WebsiteTemplate class.

		public function killModule():void {
			
			stage.removeEventListener(Event.RESIZE, onStageResized);
			Utils.removeTweens(main);
			if (scrollerObj != null) {
				scrollerObj.destroyScroller();
				scrollerObj = null;
			}
			for (var i=0; i<teasersArray.length; i++) {
				if (teasersArray[i].scroller != undefined) {
					teasersArray[i].scroller.destroyScroller();
					teasersArray[i].scroller = null;
				}
			}
			if (brObj != null) {
				brObj.killBannerRotator();
				brObj = null;
			}
			if (main != null) {
				removeChild(main);
				main = null;
			}
		}

	/****************************************************************************************************/
	
	}
}