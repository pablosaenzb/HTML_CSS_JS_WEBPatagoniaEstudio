/**
	Contact class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.contact {
	
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
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.ui.Keyboard;
	import com.emerald.phlex.utils.Geom;
	import com.emerald.phlex.utils.Image;
	import com.emerald.phlex.utils.Scroller;
	import com.emerald.phlex.utils.Utils;
	import caurina.transitions.*;
	import caurina.transitions.properties.ColorShortcuts;

	public class Contact extends Sprite {
		
		public var main:Sprite, picture:Sprite, form:Sprite, info:Sprite, info2:Sprite;
		private var send_but:Sprite;
		private var tf1_bg:Shape, tf2_bg:Shape, tf3_bg:Shape, tf4_bg:Shape;
		private var tf1_border:Shape, tf2_border:Shape, tf3_border:Shape, tf4_border:Shape;
		private var tf1:TextField, tf2:TextField, tf3:TextField, tf4:TextField, msg_tf:TextField;
		private var __root:*;
		private var xml_URL:String;
		private var xmlLoader:URLLoader;
		private var dataXML:XML;
		private var XMLParserObj:Object, scrollerObj1:Object, scrollerObj2:Object;
		private var imageLoader:Loader;
		private var killcache_str:String;
		private var killCachedFiles:Boolean = false;
		private var textStyleSheet:StyleSheet;
		private var fieldTextFormat:TextFormat, msgFieldTextFormat:TextFormat, infoMsgTextFormat:TextFormat;
		private var all_required:Boolean = true;
		private var send_button_blocked:Boolean = false;
		private var mouseIsOverButton:Boolean = false;
		private var form_tf_max_width:uint
		private var info2_yPos:uint;
		private var imageBmpData:BitmapData;
		
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
		// --
		
		private static const FADE_DURATION:Number = 1;
		private static const ON_ROLL_DURATION:Number = 0.3;
		private static const ON_FOCUS_DURATION:Number = 0.1;
		private static const FIELD_VERTICAL_SPACING:uint = 7;
		private static const MAX_CHARS_SINGLE:uint = 200;
		private static const MAX_CHARS_MULTIPLE:uint = 5000;
		private static const MESSAGE_FIELD_HEIGHT:uint = 120;
		private static const TEXT_LEADING:uint = 6;
		
		public var phpFileURL:String;
		
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
		
		public var fieldFont:String = "Arial";
		public var filedFontSize:uint = 13;
		public var fieldFontColor:uint = 0x666666;
		public var fieldBgColor:uint = 0xFFFFFF;
		public var fieldBgAlpha:Number = 0.4;
		public var focusedFieldBgColor:uint = 0xFFFFFF;
		public var focusedFieldBgAlpha:Number = 0.6;
		public var focusedFieldBorderColor:Number;
		public var sendButtonLabel:String = "Send";
		public var sendButtonColor:uint = 0x31484F;
		public var sendButtonOverColor:uint = 0x777777;
		public var infoMessageFontColor:uint = 0x666666;
		
		public var scrollBarTrackWidth:uint;
		public var scrollBarTrackColor:Number;
		public var scrollBarTrackAlpha:Number = 1;
		public var scrollBarSliderOverWidth:uint;
		public var scrollBarSliderColor:uint = 0xB5B5B5;
		public var scrollBarSliderOverColor:Number;
		
		public var leftColumnWidth:uint = 0;
		public var rightColumnWidth:uint = 0;
		public var columnSpacing:uint = 0;
		
		public var imagePosition:String;
		public var formPosition:String;
		public var infoPosition:String;
		public var info2Position:String;
		
		public var imageURL:String;
		public var imageWidth:uint;
		public var imageHeight:uint;
		public var imageTopMargin:uint = 0;
		public var imageCaptionText:String;
		public var infoTopMargin:uint = 0;
		public var infoHeight:Number;
		public var infoText:String;
		public var info2TopMargin:uint = 0;
		public var info2Text:String;
		
		// Contact form
		public var formTopMargin:uint = 0;
		public var formActivated:Boolean = true;
		public var successMsg:String;
		public var warningMsg:String;
		public var errorMsg:String;
		public var nameFieldLabel:String;
		public var nameFieldRequired:Boolean = true;
		public var nameFieldErrorMsg:String;
		public var emailFieldLabel:String;
		public var emailFieldRequired:Boolean = true;
		public var emailFieldErrorMsg1:String;
		public var emailFieldErrorMsg2:String;
		public var phoneFieldLabel:String;
		public var phoneFieldRequired:Boolean = false;
		public var phoneFieldErrorMsg:String;
		public var messageFieldLabel:String;
		public var messageFieldRequired:Boolean = true;
		public var messageFieldErrorMsg:String;
		
		// Image Shadow
		private var imageShadowBlur:uint = 16;
		private var imageShadowStrength:uint = 1;
		private var imageShadowQuality:uint = 2;
		
		ColorShortcuts.init();	// initiates the ColorShortcuts special properties of the Tweener class
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function Contact():void {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addChild(main = new Sprite());
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the Contact object is added to the Stage.
	
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the SWF file is resized.
		
		private function onStageResized(e:Event):void {
			if (scrollerObj2 != null) {
				info2.y = info2_yPos;
				var mask_h:uint = stage.stageHeight - __root.page_content.y - __root.module_container.y - info2.y - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
				scrollerObj2.onStageResized(mask_h);
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
			XMLParserObj.columnNodeParser(dataXML.leftColumn); // processing "leftColumn" node
			XMLParserObj.columnNodeParser(dataXML.rightColumn); // processing "rightColumn" node
			if (__root != null) {
				var module_width:uint = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin;
				leftColumnWidth = Math.min(leftColumnWidth, module_width);
				if (leftColumnWidth == module_width) columnSpacing = 0;
				rightColumnWidth = Math.max(module_width-leftColumnWidth-columnSpacing, 0);
			} else {
				leftColumnWidth = Math.min(leftColumnWidth, 900);
				if (leftColumnWidth == 900) columnSpacing = 0;
				rightColumnWidth = Math.max(900-leftColumnWidth-columnSpacing, 0);
			}
			if (imagePosition == "left" && leftColumnWidth == 0) imagePosition = null;
			if (imagePosition == "right" && rightColumnWidth == 0) imagePosition = null;
			if (formPosition == "left" && leftColumnWidth == 0) formPosition = null;
			if (formPosition == "right" && rightColumnWidth == 0) formPosition = null;
			if (infoPosition == "left" && leftColumnWidth == 0) infoPosition = null;
			if (infoPosition == "right" && rightColumnWidth == 0) infoPosition = null;
			if (info2Position == "left" && leftColumnWidth == 0) info2Position = null;
			if (info2Position == "right" && rightColumnWidth == 0) info2Position = null;
			createContact();
			
			if (__root != null) createSingleItemArea();
			if (__root != null) __root.openNewPage(); // calls the openNewPage() function of the WebsiteTemplate class
			if (__root != null) stage.addEventListener(Event.RESIZE, onStageResized);
		}
		
		private function xmlDataError(e:IOErrorEvent):void {
			xmlLoader.removeEventListener(Event.COMPLETE, xmlDataProcessing);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlDataError);
		}
		
	/****************************************************************************************************/
	//	Function. Builds contact page elements.
	
		private function createContact():void {
			if (imagePosition != null) {
				if (imagePosition == "left") drawImage("left");
				if (imagePosition == "right") drawImage("right");
			}
			if (infoPosition != null) {
				if (infoPosition == "left" && imagePosition != "left") createInfo("left");
				if (infoPosition == "right" && imagePosition != "right") createInfo("right");
			}
			if (formPosition != null) {
				if (formPosition == "left" && imagePosition != "left") createForm("left");
				if (formPosition == "right" && imagePosition != "right") createForm("right");
			}
			if (info2Position != null) {
				if (info2Position == "left" && formPosition != "left" && infoPosition != "left") createInfo2("left");
				if (info2Position == "right" && formPosition != "right" && infoPosition != "right") createInfo2("right");
			}
		}
		
	/****************************************************************************************************/
	//	Function. Draws the image on the contact page.
	
		private function drawImage(position:String):void {
			var base:Shape, shadow_base:Shape, bg:Shape, blurred_bg_mask:Shape, caption_mask:Shape;
			var img:Sprite, blurred_bg:Sprite, caption:Sprite, hitarea:Sprite;
			var hover_icon:MovieClip;
			var border_thickness:uint, img_width:uint, img_height:uint
			if (position == "left" && imageWidth > leftColumnWidth) imageWidth = leftColumnWidth;
			if (position == "right" && imageWidth > rightColumnWidth) imageWidth = rightColumnWidth;
			
			main.addChild(picture = new Sprite());
			if (position == "right") picture.x = leftColumnWidth + columnSpacing;
			picture.y = imageTopMargin;
			picture.addChild(shadow_base = new Shape());
			picture.addChild(bg = new Shape());
			bg.name = "bg";
			hitarea = new Sprite();
			picture.addChild(hitarea);
			hitarea.mouseEnabled = false;
			picture.addChild(img = new Sprite());
			img.name = "img";
			img.hitArea = hitarea;
			picture.addChild(blurred_bg = new Sprite());
			blurred_bg.name = "blurred_bg";
			blurred_bg.mouseEnabled = false;
			picture.addChild(blurred_bg_mask = new Shape());
			blurred_bg_mask.name = "blurred_bg_mask";
			blurred_bg.mask = blurred_bg_mask;
			picture.addChild(caption = new Sprite());
			caption.name = "caption";
			caption.mouseEnabled = caption.mouseChildren = false;
			picture.addChild(caption_mask = new Shape());
			Geom.drawRectangle(caption_mask, imageWidth, imageHeight, 0xFF9900, 0);
			caption.mask = caption_mask;
			hover_icon = new zoom_mc();
			picture.addChild(hover_icon);
			hover_icon.mouseEnabled = false;
			hover_icon.visible = false;
			hover_icon.name = "hover_icon";
			picture.addChild(base = new Shape());
			base.name = "base";
			
			if (!isNaN(imageBorderColor) && imageBorderThickness > 0) border_thickness = imageBorderThickness;
			else border_thickness = 0;
			img_width = imageWidth + 2*imagePadding + 2*border_thickness;
			img_height = imageHeight + 2*imagePadding + 2*border_thickness;
			
			if (!isNaN(imageBgColor) && !isNaN(imageBgAlpha)) {
				Geom.drawRectangle(bg, imageWidth+2*imagePadding, imageHeight+2*imagePadding, imageBgColor, imageBgAlpha);
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
				Geom.drawBorder(base, imageWidth, imageHeight, imageBorderColor, 1, imageBorderThickness, imagePadding);
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
			tf.width = imageWidth - 2*imageCaptionPadding;
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
			
			if (imageURL != null) {
				if (!isNaN(imagePreloaderColor) && !isNaN(imagePreloaderAlpha)) {
					var preloader:MovieClip = new img_preloader();
					preloader.name = "preloader";
					picture.addChild(preloader);
					preloader.x = Math.round((img_width-preloader.width)/2);
					preloader.y = Math.round((img_height-preloader.height)/2);
					var preloaderColor:ColorTransform = preloader.transform.colorTransform;
					preloaderColor.color = imagePreloaderColor;
					preloader.transform.colorTransform = preloaderColor;
					preloader.alpha = imagePreloaderAlpha;
				}
				var imageLoader:Loader = new Loader();
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadComplete);
				imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
				imageLoader.load(new URLRequest(imageURL+(killCachedFiles?killcache_str:'')));
			}
		}
		
	/****************************************************************************************************/
	//	Functions. Handles events on image loading.
		
		private function imageLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, imageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
			var bmp:Bitmap = Bitmap(e.target.content);
			var bmpData:BitmapData;
			var img:Sprite = picture.getChildByName("img") as Sprite;
			var preloader:MovieClip = picture.getChildByName("preloader") as MovieClip;
			if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.5*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[picture, preloader]});
			img.alpha = 0;
			if (e.target.width != imageWidth || e.target.height != imageHeight) {
				bmp.smoothing = true;
				bmpData = bmp.bitmapData;
				var new_width:Number = imageWidth;
				var new_height:Number = imageHeight;
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
			imageBmpData = bmpData;
			
			var hover_icon:MovieClip = picture.getChildByName("hover_icon") as MovieClip;
			var hoverIconColor:ColorTransform = hover_icon.transform.colorTransform;
			hoverIconColor.color = imageZoomIconColor;
			hover_icon.transform.colorTransform = hoverIconColor;
			hover_icon.alpha = imageZoomIconAlpha;
			hover_icon.x = Math.round((imageWidth-hover_icon.width)/2) + img.x;
			hover_icon.y = Math.round((imageHeight-hover_icon.height)/2) + img.y;
			
			Tweener.addTween(img, {alpha:1, time:FADE_DURATION, transition:"easeOutQuint"});
			if (!(imageOverBrightness == 0 && imageCaptionText != null)) {
				Image.drawCaption(picture,
								  imageWidth,
								  imageHeight,
								  bmpData,
								  imageCaptionText,
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
			if (e.target.width > imageWidth || e.target.height > imageHeight) {
				img.buttonMode = true;
				img.addEventListener(MouseEvent.CLICK, imgClickListener);
				hover_icon.visible = true;
			}
		}
		
		private function imageLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, imageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
			var preloader:MovieClip = picture.getChildByName("preloader") as MovieClip;
			if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.5*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[picture, preloader]});
		}
		
	/****************************************************************************************************/
	//	Function. Image click listener.
	
		private function imgClickListener(e:MouseEvent):void {
			var hover_icon:MovieClip = picture.getChildByName("hover_icon") as MovieClip;
			if (hover_icon.visible == true && __root != null) {
				if (isNaN(currentFsImageIndex)) {
					currentFsImageIndex = 0;
					changeFullscreenImage();
				}
				displaySingleItemView(true);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Removes an image preloader.
		
		private function removeImagePreloader(obj:Sprite, preloader:MovieClip):void {
			obj.removeChild(preloader);
			preloader = null;
		}
		
	/****************************************************************************************************/
	//	Function. Builds the info text.
	
		private function createInfo(position:String):void {
			var tf_max_width:uint;
			main.addChild(info = new Sprite());
			if (position == "right") {
				info.x = leftColumnWidth + columnSpacing;
				tf_max_width = rightColumnWidth;
			} else {
				tf_max_width = leftColumnWidth;
			}
			info.y = infoTopMargin;
			var tf:TextField = new TextField();
			info.addChild(tf);
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.width = tf_max_width;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.embedFonts = true;
			tf.selectable = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.mouseWheelEnabled = false;
			tf.htmlText = infoText;
			if (!isNaN(infoHeight) && info.height > infoHeight) tf_max_width -= 10; // increase the spacing between the right edge of a text field and the scroll bar
			tf.width = tf_max_width;
			tf.height += TEXT_LEADING; // disables TextField scrolling on selection (also is a workaround for "jumpy htmlText hyperlinks")
			tf.autoSize = TextFieldAutoSize.NONE;
			if (!isNaN(infoHeight) && info.height > infoHeight) attachScroller1(tf_max_width+10); // attach a scroller to the info text
		}
		
	/****************************************************************************************************/
	//	Function. Attaches a scroller to the info text.
		
		private function attachScroller1(mask_w:uint):void {
			var hitarea:Sprite = new Sprite();
			info.addChild(hitarea);
			info.hitArea = hitarea;
			hitarea.mouseEnabled = false;
			Geom.drawRectangle(hitarea, mask_w, info.height, 0xFF9900, 0);
			scrollerObj1 = new Scroller(info,
										mask_w,
										infoHeight,
										scrollBarTrackWidth,
										scrollBarTrackColor,
										scrollBarTrackAlpha,
										scrollBarSliderOverWidth,
										scrollBarSliderColor,
										scrollBarSliderOverColor);
		}		

	/****************************************************************************************************/
	//	Function. Builds the contact form.
	
		private function createForm(position:String):void {
			var field_yPos:uint = 0;
			var metrics:TextLineMetrics;
			var tfBgColor:ColorTransform, tfBorderColor:ColorTransform;
			main.addChild(form = new Sprite());
			if (position == "right") {
				form.x = leftColumnWidth + columnSpacing;
				form_tf_max_width = rightColumnWidth;
			} else {
				form_tf_max_width = leftColumnWidth;
			}
			if (!isNaN(infoHeight)) form.y = (info?infoTopMargin+infoHeight:0) + formTopMargin;
			else form.y = (info?infoTopMargin+Math.ceil(info.height):0) + formTopMargin;
			
			if (nameFieldLabel && !nameFieldRequired) all_required = false;
			if (emailFieldLabel && !emailFieldRequired) all_required = false;
			if (phoneFieldLabel && !phoneFieldRequired) all_required = false;
			if (messageFieldLabel && !messageFieldRequired) all_required = false;
			
			fieldTextFormat = new TextFormat();
			msgFieldTextFormat = new TextFormat();
			infoMsgTextFormat = new TextFormat();
			fieldTextFormat.font = msgFieldTextFormat.font = infoMsgTextFormat.font = fieldFont;
			fieldTextFormat.color = msgFieldTextFormat.color = fieldFontColor;
			fieldTextFormat.size = msgFieldTextFormat.size = infoMsgTextFormat.size = filedFontSize;
			fieldTextFormat.leftMargin = fieldTextFormat.rightMargin = msgFieldTextFormat.leftMargin = msgFieldTextFormat.rightMargin = 4;
			msgFieldTextFormat.leading = 4;
			infoMsgTextFormat.color = infoMessageFontColor;
			
			// "Name" input field
			if (nameFieldLabel) {
				tf1_bg = new Shape();
				form.addChild(tf1_bg);
				tf1_border = new Shape();
				form.addChild(tf1_border);
				tf1_bg.y = tf1_border.y = field_yPos;
				tf1 = new TextField();
				form.addChild(tf1);
				tf1.y = field_yPos + 3;
				tf1.type = TextFieldType.INPUT;
				tf1.width = form_tf_max_width;
				tf1.autoSize = TextFieldAutoSize.NONE;
				tf1.multiline = false;
				tf1.embedFonts = true;
				tf1.selectable = true;
				tf1.antiAliasType = AntiAliasType.ADVANCED;
				tf1.maxChars = MAX_CHARS_SINGLE;
				tf1.tabEnabled = true;
				tf1.tabIndex = 1;
				tf1.text = nameFieldLabel + (!all_required && nameFieldRequired ? ' *' : '');
				tf1.setTextFormat(fieldTextFormat);
				metrics = tf1.getLineMetrics(0);
				tf1.height = Math.ceil(metrics.height) + 4;
				Geom.drawRectangle(tf1_bg, tf1.width, tf1.height+6, 0xFFFFFF, 1);
				tfBgColor = tf1_bg.transform.colorTransform;
				tfBgColor.color = fieldBgColor;
				tf1_bg.transform.colorTransform = tfBgColor;
				tf1_bg.alpha = fieldBgAlpha;
				if (!isNaN(focusedFieldBorderColor)) {
					Geom.drawRectangle(tf1_border, tf1_bg.width, tf1_bg.height, 0xFFFFFF, 0, 0, 0, 0, 0, 0, 0, 0xFFFFFF, 1, 1);
					tfBorderColor = tf1_border.transform.colorTransform;
					tfBorderColor.color = focusedFieldBorderColor;
					tf1_border.transform.colorTransform = tfBorderColor;
					tf1_border.alpha = 0;
				}
				tf1.addEventListener(FocusEvent.FOCUS_IN, formFieldListener);
				tf1.addEventListener(FocusEvent.FOCUS_OUT, formFieldListener);
				field_yPos += tf1_bg.height + FIELD_VERTICAL_SPACING;
			}
			
			// "Email" input field
			if (emailFieldLabel) {
				tf2_bg = new Shape();
				form.addChild(tf2_bg);
				tf2_border = new Shape();
				form.addChild(tf2_border);
				tf2_bg.y = tf2_border.y = field_yPos;
				tf2 = new TextField();
				form.addChild(tf2);
				tf2.y = field_yPos + 3;
				tf2.type = TextFieldType.INPUT;
				tf2.width = form_tf_max_width;
				tf2.autoSize = TextFieldAutoSize.NONE;
				tf2.multiline = false;
				tf2.embedFonts = true;
				tf2.selectable = true;
				tf2.antiAliasType = AntiAliasType.ADVANCED;
				tf2.maxChars = MAX_CHARS_SINGLE;
				tf2.tabEnabled = true;
				tf2.tabIndex = 2;
				tf2.text = emailFieldLabel + (!all_required && emailFieldRequired ? ' *' : '');
				tf2.setTextFormat(fieldTextFormat);
				metrics = tf2.getLineMetrics(0);
				tf2.height = Math.ceil(metrics.height) + 4;
				Geom.drawRectangle(tf2_bg, tf2.width, tf2.height+6, 0xFFFFFF, 1);
				tfBgColor = tf2_bg.transform.colorTransform;
				tfBgColor.color = fieldBgColor;
				tf2_bg.transform.colorTransform = tfBgColor;
				tf2_bg.alpha = fieldBgAlpha;
				if (!isNaN(focusedFieldBorderColor)) {
					Geom.drawRectangle(tf2_border, tf2_bg.width, tf2_bg.height, 0xFFFFFF, 0, 0, 0, 0, 0, 0, 0, 0xFFFFFF, 1, 1);
					tfBorderColor = tf2_border.transform.colorTransform;
					tfBorderColor.color = focusedFieldBorderColor;
					tf2_border.transform.colorTransform = tfBorderColor;
					tf2_border.alpha = 0;
				}
				tf2.addEventListener(FocusEvent.FOCUS_IN, formFieldListener);
				tf2.addEventListener(FocusEvent.FOCUS_OUT, formFieldListener);
				field_yPos += tf2_bg.height + FIELD_VERTICAL_SPACING;
			}
			
			// "Phone" input field
			if (phoneFieldLabel) {
				tf3_bg = new Shape();
				form.addChild(tf3_bg);
				tf3_border = new Shape();
				form.addChild(tf3_border);
				tf3_bg.y = tf3_border.y = field_yPos;
				tf3 = new TextField();
				form.addChild(tf3);
				tf3.y = field_yPos + 3;
				tf3.type = TextFieldType.INPUT;
				tf3.width = form_tf_max_width;
				tf3.autoSize = TextFieldAutoSize.NONE;
				tf3.multiline = false;
				tf3.embedFonts = true;
				tf3.selectable = true;
				tf3.antiAliasType = AntiAliasType.ADVANCED;
				tf3.maxChars = MAX_CHARS_SINGLE;
				tf3.tabEnabled = true;
				tf3.tabIndex = 3;
				tf3.text = phoneFieldLabel + (!all_required && phoneFieldRequired ? ' *' : '');
				tf3.setTextFormat(fieldTextFormat);
				metrics = tf3.getLineMetrics(0);
				tf3.height = Math.ceil(metrics.height) + 4;
				Geom.drawRectangle(tf3_bg, tf3.width, tf3.height+6, 0xFFFFFF, 1);
				tfBgColor = tf3_bg.transform.colorTransform;
				tfBgColor.color = fieldBgColor;
				tf3_bg.transform.colorTransform = tfBgColor;
				tf3_bg.alpha = fieldBgAlpha;
				if (!isNaN(focusedFieldBorderColor)) {
					Geom.drawRectangle(tf3_border, tf3_bg.width, tf3_bg.height, 0xFFFFFF, 0, 0, 0, 0, 0, 0, 0, 0xFFFFFF, 1, 1);
					tfBorderColor = tf3_border.transform.colorTransform;
					tfBorderColor.color = focusedFieldBorderColor;
					tf3_border.transform.colorTransform = tfBorderColor;
					tf3_border.alpha = 0;
				}
				tf3.addEventListener(FocusEvent.FOCUS_IN, formFieldListener);
				tf3.addEventListener(FocusEvent.FOCUS_OUT, formFieldListener);
				field_yPos += tf3_bg.height + FIELD_VERTICAL_SPACING;
			}
			
			// "Message" input field
			if (messageFieldLabel) {
				tf4_bg = new Shape();
				form.addChild(tf4_bg);
				tf4_border = new Shape();
				form.addChild(tf4_border);
				tf4_bg.y = tf4_border.y = field_yPos;
				tf4 = new TextField();
				form.addChild(tf4);
				tf4.y = field_yPos + 3;
				tf4.type = TextFieldType.INPUT;
				tf4.width = form_tf_max_width;
				tf4.autoSize = TextFieldAutoSize.NONE;
				tf4.multiline = true;
				tf4.wordWrap = true;
				tf4.embedFonts = true;
				tf4.selectable = true;
				tf4.antiAliasType = AntiAliasType.ADVANCED;
				tf4.mouseWheelEnabled = true;
				tf4.maxChars = MAX_CHARS_MULTIPLE;
				tf4.tabEnabled = true;
				tf4.tabIndex = 4;
				tf4.text = messageFieldLabel + (!all_required && messageFieldRequired ? ' *' : '');
				tf4.setTextFormat(msgFieldTextFormat);
				tf4.height = MESSAGE_FIELD_HEIGHT;
				Geom.drawRectangle(tf4_bg, tf4.width, tf4.height+6, 0xFFFFFF, 1);
				tfBgColor = tf4_bg.transform.colorTransform;
				tfBgColor.color = fieldBgColor;
				tf4_bg.transform.colorTransform = tfBgColor;
				tf4_bg.alpha = fieldBgAlpha;
				if (!isNaN(focusedFieldBorderColor)) {
					Geom.drawRectangle(tf4_border, tf4_bg.width, tf4_bg.height, 0xFFFFFF, 0, 0, 0, 0, 0, 0, 0, 0xFFFFFF, 1, 1);
					tfBorderColor = tf4_border.transform.colorTransform;
					tfBorderColor.color = focusedFieldBorderColor;
					tf4_border.transform.colorTransform = tfBorderColor;
					tf4_border.alpha = 0;
				}
				tf4.addEventListener(FocusEvent.FOCUS_IN, formFieldListener);
				tf4.addEventListener(FocusEvent.FOCUS_OUT, formFieldListener);
				field_yPos += tf4_bg.height + FIELD_VERTICAL_SPACING;
			}
			
			if (form.width > 0) {
				// info message
				msg_tf = new TextField();
				form.addChild(msg_tf);
				msg_tf.y = field_yPos + 2;
				msg_tf.autoSize = TextFieldAutoSize.LEFT;
				msg_tf.multiline = false;
				msg_tf.wordWrap = false;
				msg_tf.embedFonts = true;
				msg_tf.selectable = false;
				msg_tf.antiAliasType = AntiAliasType.ADVANCED;
				msg_tf.setTextFormat(infoMsgTextFormat);
				
				// "send" button
				send_but = new Sprite();
				var but_label:Sprite = new Sprite();
				var but_icon:MovieClip = new arrow_icon();
				var tf:TextField = new TextField();
				var hitarea:Shape = new Shape();
				form.addChild(send_but);
				send_but.addChild(but_label);
				send_but.addChild(but_icon);
				send_but.addChild(hitarea);
				but_label.addChild(tf);
				if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.multiline = false;
				tf.wordWrap = false;
				tf.embedFonts = true;
				tf.selectable = false;
				tf.antiAliasType = AntiAliasType.ADVANCED;
				tf.mouseEnabled = false;
				tf.htmlText = "<sendbutton>" + sendButtonLabel + "</sendbutton>";
				but_icon.x = but_label.width + 5;
				but_icon.y = Math.ceil((but_label.height-but_icon.height)/2);
				Geom.drawRectangle(hitarea, send_but.width+8, send_but.height, 0xFF9900, 0, 0, 0, 0, 0, -4, 0);
				var sendButColor:ColorTransform = send_but.transform.colorTransform;
				sendButColor.color = sendButtonColor;
				send_but.transform.colorTransform = sendButColor;
				send_but.y = field_yPos;
				if (formPosition == "right") send_but.x = form_tf_max_width - Math.ceil(send_but.width) - 5;
				
				send_but.buttonMode = true;
				send_but.addEventListener(MouseEvent.ROLL_OVER,
					function(e:MouseEvent) {
						mouseIsOverButton = true;
						if (!send_button_blocked) {
							Tweener.removeTweens(send_but);
							Tweener.addTween(send_but, {_color:sendButtonOverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
						}
					}
				);
				send_but.addEventListener(MouseEvent.ROLL_OUT,
					function(e:MouseEvent) {
						mouseIsOverButton = false;
						if (!send_button_blocked) {
							Tweener.removeTweens(send_but);
							Tweener.addTween(send_but, {_color:sendButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
						}
					}
				);
				send_but.addEventListener(MouseEvent.CLICK,
					function(e:MouseEvent) {
						var error:Boolean = false;
						if (messageFieldLabel && messageFieldRequired) {
							if (tf4.text == "" || tf4.text == messageFieldLabel + (!all_required?' *':'')) {
								if (messageFieldErrorMsg != null) {
									msg_tf.text = messageFieldErrorMsg;
									msg_tf.setTextFormat(infoMsgTextFormat);
								}
								error = true;
							}
						}
						if (phoneFieldLabel && phoneFieldRequired) {
							if (tf3.text == "" || tf3.text == phoneFieldLabel + (!all_required?' *':'')) {
								if (phoneFieldErrorMsg != null) {
									msg_tf.text = phoneFieldErrorMsg;
									msg_tf.setTextFormat(infoMsgTextFormat);
								}
								error = true;
							}
						}
						if (emailFieldLabel && emailFieldRequired) {
							if (tf2.text == "" || tf2.text == emailFieldLabel + (!all_required?' *':'')) {
								if (emailFieldErrorMsg1 != null) {
									msg_tf.text = emailFieldErrorMsg1;
									msg_tf.setTextFormat(infoMsgTextFormat);
								}
								error = true;
							} else if (validateEmail(tf2.text) == false) {
								if (emailFieldErrorMsg2 != null) {
									msg_tf.text = emailFieldErrorMsg2;
									msg_tf.setTextFormat(infoMsgTextFormat);
								}
								error = true;
							}
						}
						if (nameFieldLabel && nameFieldRequired) {
							if (tf1.text == "" || tf1.text == nameFieldLabel + (!all_required?' *':'')) {
								if (nameFieldErrorMsg != null) {
									msg_tf.text = nameFieldErrorMsg;
									msg_tf.setTextFormat(infoMsgTextFormat);
								}
								error = true;
							}
						}
						if (!error) {
							if (formActivated) {
								if (phpFileURL != null) {
									if (!send_button_blocked) {
										send_button_blocked = true;
										if (warningMsg != null) {
											msg_tf.text = warningMsg;
											msg_tf.setTextFormat(infoMsgTextFormat);
										}
										var date:Date = new Date();
										var timezoneOffset:int = date.timezoneOffset;
										var send_vars:URLVariables = new URLVariables();
										send_vars.timezone_offset = timezoneOffset;
										if (nameFieldLabel) send_vars.name = (!nameFieldRequired && tf1.text == nameFieldLabel ? ' ' : tf1.text);
										if (emailFieldLabel) send_vars.email = (!emailFieldRequired && tf2.text == emailFieldLabel ? ' ' : tf2.text);
										if (phoneFieldLabel) send_vars.phone = (!phoneFieldRequired && tf3.text == phoneFieldLabel ? ' ' : tf3.text);
										if (messageFieldLabel) send_vars.message = (!messageFieldRequired && tf4.text == messageFieldLabel ? ' ' : tf4.text);
										var req:URLRequest = new URLRequest(phpFileURL);
										req.method = URLRequestMethod.POST;
										req.data = send_vars;
										var loader:URLLoader = new URLLoader();
										loader.addEventListener(Event.COMPLETE, sendVarsComplete);
										loader.addEventListener(IOErrorEvent.IO_ERROR, sendVarsError);
										loader.dataFormat = URLLoaderDataFormat.VARIABLES;
										try { loader.load(req); }
										catch (error:Error) { showResult(false); }
										//navigateToURL(req);
									}
								}
							} else {
								showResult(true);
							}
						}
						if (formPosition == "left") msg_tf.x = form_tf_max_width - Math.ceil(msg_tf.width);
					}
				);
			}
		}
		
		private function validateEmail(str:String):Boolean {
			var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			var result:Boolean = pattern.test(str);
			return result;
        }
		
		private function sendVarsComplete(e:Event):void {
			var received_vars:URLVariables = new URLVariables();
			received_vars.decode(e.target.data);
			if (received_vars.status != undefined) {
				if (received_vars.status.substr(0, 1) == "1") {
					showResult(true);
				} else {
					showResult(false);
				}
			} else {
				showResult(false);
			}
		}
		
		private function sendVarsError(event:IOErrorEvent):void { showResult(false); }
		
		private function showResult(success:Boolean):void {
			if (success) {
				if (successMsg != null) msg_tf.text = successMsg;
				if (tf1) {
					tf1.text = nameFieldLabel + (!all_required && nameFieldRequired ? ' *' : '');
					tf1.setTextFormat(fieldTextFormat);
				}
				if (tf2) {
					tf2.text = emailFieldLabel + (!all_required && emailFieldRequired ? ' *' : '');
					tf2.setTextFormat(fieldTextFormat);
				}
				if (tf3) {
					tf3.text = phoneFieldLabel + (!all_required && phoneFieldRequired ? ' *' : '');
					tf3.setTextFormat(fieldTextFormat);
				}
				if (tf4) {
					tf4.text = messageFieldLabel + (!all_required && messageFieldRequired ? ' *' : '');
					tf4.setTextFormat(fieldTextFormat);
				}
			} else {
				if (errorMsg != null) msg_tf.text = errorMsg;
			}
			msg_tf.setTextFormat(infoMsgTextFormat);
			if (formPosition == "left") msg_tf.x = form_tf_max_width - Math.ceil(msg_tf.width);
			send_button_blocked = false;
			if (!mouseIsOverButton) {
				Tweener.removeTweens(send_but);
				Tweener.addTween(send_but, {_color:sendButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
			}
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when a text field of the contact form receives or loses focus.
		
		private function formFieldListener(e:FocusEvent):void {
			if (e.type == "focusIn" && stage.displayState == StageDisplayState.FULL_SCREEN) stage.displayState = StageDisplayState.NORMAL;
			switch (e.currentTarget) {
				case tf1:
					Tweener.removeTweens(tf1_bg);
					Tweener.removeTweens(tf1_border);
					if (e.type == "focusIn") {
						if (tf1.text == nameFieldLabel + (!all_required && nameFieldRequired ? ' *' : '')) {
							tf1.setSelection(tf1.text.length, tf1.text.length);
							tf1.text = "";
							tf1.setTextFormat(fieldTextFormat);
						}
						Tweener.addTween(tf1_bg, {alpha:focusedFieldBgAlpha, _color:focusedFieldBgColor, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
						if (!isNaN(focusedFieldBorderColor)) Tweener.addTween(tf1_border, {alpha:1, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
						msg_tf.text = "";
					} else {
						if (tf1.text == "" || tf1.text == " ") {
							tf1.text = nameFieldLabel + (!all_required && nameFieldRequired ? ' *' : '');
							tf1.setTextFormat(fieldTextFormat);
						}
						Tweener.addTween(tf1_bg, {alpha:fieldBgAlpha, _color:fieldBgColor, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
						if (!isNaN(focusedFieldBorderColor)) Tweener.addTween(tf1_border, {alpha:0, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
					}
				break;
				case tf2:
					Tweener.removeTweens(tf2_bg);
					Tweener.removeTweens(tf2_border);
					if (e.type == "focusIn") {
						if (tf2.text == emailFieldLabel + (!all_required && emailFieldRequired ? ' *' : '')) {
							tf2.setSelection(tf2.text.length, tf2.text.length);
							tf2.text = "";
							tf2.setTextFormat(fieldTextFormat);
						}
						Tweener.addTween(tf2_bg, {alpha:focusedFieldBgAlpha, _color:focusedFieldBgColor, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
						if (!isNaN(focusedFieldBorderColor)) Tweener.addTween(tf2_border, {alpha:1, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
						msg_tf.text = "";
					} else {
						if (tf2.text == "" || tf2.text == " ") {
							tf2.text = emailFieldLabel + (!all_required && emailFieldRequired ? ' *' : '');
							tf2.setTextFormat(fieldTextFormat);
						}
						Tweener.addTween(tf2_bg, {alpha:fieldBgAlpha, _color:fieldBgColor, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
						if (!isNaN(focusedFieldBorderColor)) Tweener.addTween(tf2_border, {alpha:0, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
					}
				break;
				case tf3:
					Tweener.removeTweens(tf3_bg);
					Tweener.removeTweens(tf3_border);
					if (e.type == "focusIn") {
						if (tf3.text == phoneFieldLabel + (!all_required && phoneFieldRequired ? ' *' : '')) {
							tf3.setSelection(tf3.text.length, tf3.text.length);
							tf3.text = "";
							tf3.setTextFormat(fieldTextFormat);
						}
						Tweener.addTween(tf3_bg, {alpha:focusedFieldBgAlpha, _color:focusedFieldBgColor, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
						if (!isNaN(focusedFieldBorderColor)) Tweener.addTween(tf3_border, {alpha:1, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
						msg_tf.text = "";
					} else {
						if (tf3.text == "" || tf3.text == " ") {
							tf3.text = phoneFieldLabel + (!all_required && phoneFieldRequired ? ' *' : '');
							tf3.setTextFormat(fieldTextFormat);
						}
						Tweener.addTween(tf3_bg, {alpha:fieldBgAlpha, _color:fieldBgColor, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
						if (!isNaN(focusedFieldBorderColor)) Tweener.addTween(tf3_border, {alpha:0, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
					}
				break;
				case tf4:
					Tweener.removeTweens(tf4_bg);
					Tweener.removeTweens(tf4_border);
					if (e.type == "focusIn") {
						if (tf4.text == messageFieldLabel + (!all_required && messageFieldRequired ? ' *' : '')) {
							tf4.setSelection(tf4.text.length, tf4.text.length);
							tf4.text = "";
							tf4.setTextFormat(fieldTextFormat);
						}
						Tweener.addTween(tf4_bg, {alpha:focusedFieldBgAlpha, _color:focusedFieldBgColor, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
						if (!isNaN(focusedFieldBorderColor)) Tweener.addTween(tf4_border, {alpha:1, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
						msg_tf.text = "";
					} else {
						if (tf4.text == "" || tf4.text == " ") {
							tf4.text = messageFieldLabel + (!all_required && messageFieldRequired ? ' *' : '');
							tf4.setTextFormat(fieldTextFormat);
						}
						Tweener.addTween(tf4_bg, {alpha:fieldBgAlpha, _color:fieldBgColor, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
						if (!isNaN(focusedFieldBorderColor)) Tweener.addTween(tf4_border, {alpha:0, time:ON_FOCUS_DURATION, transition:"easeOutQuad"});
					}
			}
			if (formPosition == "left") msg_tf.x = form_tf_max_width - Math.ceil(msg_tf.width);
		}
		
	/****************************************************************************************************/
	//	Function. Builds the additional info text.
	
		private function createInfo2(position:String):void {
			var tf_max_width:uint;
			main.addChild(info2 = new Sprite());
			if (position == "right") {
				info2.x = leftColumnWidth + columnSpacing;
				tf_max_width = rightColumnWidth;
			} else {
				tf_max_width = leftColumnWidth;
			}
			tf_max_width -= 10; // increase the spacing between the right edge of a text field and the scroll bar
			info2_yPos = (picture?imageTopMargin+imageHeight:0) + info2TopMargin;
			info2.y = info2_yPos;
			var tf:TextField = new TextField();
			info2.addChild(tf);
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.width = tf_max_width;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.embedFonts = true;
			tf.selectable = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.mouseWheelEnabled = false;
			tf.htmlText = info2Text;
			tf.height += TEXT_LEADING; // disables TextField scrolling on selection (also is a workaround for "jumpy htmlText hyperlinks")
			tf.autoSize = TextFieldAutoSize.NONE;
			attachScroller2(tf_max_width+10); // attach a scroller to the additional info text
		}
		
	/****************************************************************************************************/
	//	Function. Attaches a scroller to the additional info text.
		
		private function attachScroller2(mask_w:uint):void {
			var hitarea:Sprite = new Sprite();
			info2.addChild(hitarea);
			info2.hitArea = hitarea;
			hitarea.mouseEnabled = false;
			Geom.drawRectangle(hitarea, mask_w, info2.height, 0xFF9900, 0);
			var mask_h:uint
			if (__root != null) mask_h = stage.stageHeight - __root.page_content.y - __root.module_container.y - info2.y - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
			else mask_h = 300;
			scrollerObj2 = new Scroller(info2,
										mask_w,
										mask_h,
										scrollBarTrackWidth,
										scrollBarTrackColor,
										scrollBarTrackAlpha,
										scrollBarSliderOverWidth,
										scrollBarSliderColor,
										scrollBarSliderOverColor);
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
				// currentFsImageIndex can be NaN or 0 in the Contact module
				if (imageBmpData != null) {
					media.graphics.clear();
					media.alpha = 0;
					drawFullscreenImage(container, imageBmpData);
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
			if (imageBmpData != null) drawFullscreenImage(container, imageBmpData);
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
			
			if (stage.hasEventListener(Event.RESIZE)) stage.removeEventListener(Event.RESIZE, onStageResized);			
			Utils.removeTweens(main);
			if (scrollerObj1 != null) {
				scrollerObj1.destroyScroller();
				scrollerObj1 = null;
			}
			if (scrollerObj2 != null) {
				scrollerObj2.destroyScroller();
				scrollerObj2 = null;
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