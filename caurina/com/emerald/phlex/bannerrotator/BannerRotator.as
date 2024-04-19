/**
	BannerRotator class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.bannerrotator {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.Bitmap;
    import flash.display.BitmapData;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
    import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.text.StyleSheet;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import com.emerald.phlex.bannerrotator.XMLParser;
	import com.emerald.phlex.utils.Geom;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;

	public class BannerRotator extends Sprite {
		
		public var rotator:Sprite, img:Sprite;
		private var mc:Sprite, controls_mc:Sprite, bg:Sprite;
		private var mask_mc:Shape, img_mask:Shape, controls_mask:Shape, timer_mc:Shape, shadow_base:Shape, border_base:Shape;
		private var preloader_mc:MovieClip;
		private var imagesArray:Array;
		private var imgLoader:Loader, imageLoader:Loader;
		private var controlsTween:Tween, controls_maskTween:Tween, bgTween:Tween, shadowTween:Tween;
		private var transitionType_array:Array;
		private var timerActionsControl:Timer, timerCFadeOut1:Timer, timerCFadeOut2:Timer;
		private var dropshadow_filter:DropShadowFilter;
		private var blur_filter:BlurFilter;
		private var dropshadow_filterArray:Array;
		private var captionTextStyleSheet:StyleSheet;
		private var XMLParserObj:Object;							// the variable for creating an object of the XMLParser class
		private var killCachedFiles:Boolean = false;
		
		public var currentIndex:uint = 0;
		private var rollbackIndex:uint;
		private var currentImgIndex:uint = 0;
		private var squares_in_row:uint;
		private var squares_in_col:uint;
		private var loading_flag:Boolean = true;
		private var mouseover_flag:Boolean = false;
		private var imageTimerStartPoint:Number;
		private var timer_mspassed:Number;
		private var transitionIndex:int = -1;
		private var killcache_str:String;
		
		private var controlsAutoHideDelay:Number = 1;				// seconds
		private var controlsAutoHideDuration:Number = 0.6;			// seconds
		private var buttonRollAnimationDuration:Number = 0.15;		// seconds
		public var imgExpStrength:Number = 3;						// 1-5
		
		// General properties
		public var bannerWidth:uint;
		public var bannerHeight:uint;
		public var bannerBgColor:Number;
		public var bannerBgAlpha:Number;
		public var bannerBackground:String;
		public var bannerCornerRadius:uint = 0;
		public var bannerBorderColor:Number;
		public var bannerBorderThickness:uint;
		public var bannerShadowColor:Number;
		public var bannerShadowAlpha:Number;
		public var autoPlay:Boolean = false;
		public var imageShowTime:Number = 5;						// seconds
		public var randomImages:Boolean = false;
		public var pauseOnMouseOver:Boolean = false;
		public var repeatMode:Boolean = true;
		
		// Transitions properties
		public var imageTransitionType:String = "1";
		public var imageTransitionDuration:Number = 1.0;			// seconds
		public var imageExposureDelay:Number = 0.7;					// seconds
		public var imageExposureStrength:Number = 1.001;			// 1-5
		public var randomImageTransitions:Boolean = false;
		public var squareSize:uint = 80;
		
		// Image area properties
		public var imageAreaWidth:uint;
		public var imageAreaHeight:uint;
		public var imageAreaCornerRadius:uint = 0;
		public var imageAreaXPosition:uint = 0;
		public var imageAreaYPosition:uint = 0;
		
		// Caption text properties
		public var captionEmbedFonts:Boolean = true;
		public var captionTextShadowColor:uint = 0x333333;
		public var captionTextShadowAlpha:Number = 0.4;
		
		// Controls properties
		public var showControls:Boolean = true;
		public var controlsType:String = "1";
		public var controlsPosition:String = "right";
		public var controlsXOffset:uint = 30;
		public var controlsYOffset:uint = 10;
		public var controlsAutoHide:Boolean = false;
		public var buttonSpacing:uint = 5;
		public var buttonBgColor:Number;
		public var buttonOverBgColor:Number;
		public var buttonSelectedBgColor:Number;
		public var buttonShadowColor:Number;
		public var showButtonShadow:Boolean = true;
		public var showPlayPauseButton:Boolean = false;
		public var playPauseIconColor:uint = 0x666666;
		public var playPauseIconOverColor:uint = 0x555555;
		
		// Timer properties
		public var showTimer:Boolean = false;
		public var timerBarPosition:String = "bottom";
		public var timerBarHeight:uint = 3;
		public var timerBarColor:uint = 0xFFFFFF;
		public var timerBarAlpha:Number = 0.2;
		
		// Preloader properties
		public var showPreloader:Boolean = true;
		public var preloaderColor:uint = 0xFFFFFF;
		
		// Banner Rotator Shadow
		private var bannerShadowBlur:uint = 16;
		private var bannerShadowStrength:uint = 1;
		private var bannerShadowQuality:uint = 2;
		
	/****************************************************************************************************/
	//	Constructor function.

		public function BannerRotator(dataXML:XMLList, killcache:Boolean, killcache_string:String, stylesheet:StyleSheet):void {
			var date:Date = new Date();
			killCachedFiles = killcache;
			killcache_str = killcache_string;
			captionTextStyleSheet = stylesheet;
			addChild(rotator = new Sprite());
			rotator.addChild(shadow_base = new Shape());
			rotator.addChild(mc = new Sprite());
			rotator.addChild(mask_mc = new Shape());
			mc.mask = mask_mc;
			rotator.addChild(border_base = new Shape());
			preloader_mc = new banner_preloader();
			preloader_mc.visible = false;
			rotator.addChild(preloader_mc);
			mc.addChild(bg = new Sprite());
			mc.addChild(img = new Sprite());
			mc.addChild(img_mask = new Shape());
			img.mask = img_mask;
			XMLParserObj = new XMLParser(this);
			xmlDataProcessing(dataXML);
			
			// *** Image loader
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadListener);
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadListener);
		}
		
	/****************************************************************************************************/
	//	Function. Handles events on a single image loading.
	
		private function imageLoadListener(e:Event):void {
			preloader_mc.visible = false;
			switch (e.type) {
				case "complete":
					var bmpData:BitmapData = Bitmap(e.target.content).bitmapData;
					imagesArray[currentIndex].bmpData = bmpData;
					Geom.drawRectangle(imagesArray[currentIndex].mask_mc, bmpData.width, bmpData.height, 0xFF9900, 0);
				break;
				case "io_error":
					imagesArray[currentIndex].bmpData = "failed";
					changeCurrentIndex(rollbackIndex, false);	// rollback to previous index
			}
		}
		
	/****************************************************************************************************/
	//	Function. Processes the XML data and makes initial settings.
		
		private function xmlDataProcessing(dataXML:XMLList):void {
			imagesArray = new Array();
			
			// Processing "settings" node
			XMLParserObj.settingsNodeParser(dataXML.settings);
			
			if (imageAreaWidth == 0) imageAreaWidth = bannerWidth;
			if (imageAreaHeight == 0) imageAreaHeight = bannerHeight;
			if (imageAreaWidth == bannerWidth && imageAreaHeight == bannerHeight && imageAreaXPosition == 0 && imageAreaYPosition == 0) {
				imageAreaCornerRadius = bannerCornerRadius;
			}
			if (Math.max(imageAreaWidth, imageAreaHeight)/squareSize > 25) {
				squareSize = Math.ceil(Math.max(imageAreaWidth, imageAreaHeight)/25);
			}
			var squares_num:Number = (imageAreaWidth*imageAreaHeight)/(squareSize*squareSize);
			if (squares_num > 170) squareSize = Math.ceil(Math.sqrt(imageAreaWidth*imageAreaHeight/170));
			img.x = img_mask.x = imageAreaXPosition;
			img.y = img_mask.y = imageAreaYPosition;
			bg.alpha = 0;
			if (!isNaN(bannerBgColor) && !isNaN(bannerBgAlpha)) {
				Geom.drawRectangle(bg, bannerWidth, bannerHeight, bannerBgColor, bannerBgAlpha, bannerCornerRadius, bannerCornerRadius, bannerCornerRadius, bannerCornerRadius);
			} else {
				Geom.drawRectangle(bg, bannerWidth, bannerHeight, 0xFFFFFF, 0, bannerCornerRadius, bannerCornerRadius, bannerCornerRadius, bannerCornerRadius);
			}
			Geom.drawRectangle(mask_mc, bannerWidth, bannerHeight, 0xFF9900, 0, bannerCornerRadius, bannerCornerRadius, bannerCornerRadius, bannerCornerRadius);
			Geom.drawRectangle(img_mask, imageAreaWidth, imageAreaHeight, 0xFF9900, 0, imageAreaCornerRadius, imageAreaCornerRadius, imageAreaCornerRadius, imageAreaCornerRadius);
			squares_in_row = Math.ceil(imageAreaWidth/squareSize);
			squares_in_col = Math.ceil(imageAreaHeight/squareSize);
			
			if (!isNaN(bannerShadowColor) && !isNaN(bannerShadowAlpha)) {
				if (!isNaN(bannerBorderColor) && bannerBorderThickness > 0) Geom.drawRectangle(shadow_base, bannerWidth+2*bannerBorderThickness, bannerHeight+2*bannerBorderThickness, 0xFFFFFF, 1, bannerCornerRadius, bannerCornerRadius, bannerCornerRadius, bannerCornerRadius);
				else Geom.drawRectangle(shadow_base, bannerWidth, bannerHeight, 0xFFFFFF, 1, bannerCornerRadius, bannerCornerRadius, bannerCornerRadius, bannerCornerRadius);
				var df:DropShadowFilter = new DropShadowFilter();
				df.color = bannerShadowColor;
				df.alpha = bannerShadowAlpha;
				df.distance = 0;
				df.angle = 0;
				df.quality = bannerShadowQuality;
				df.blurX = df.blurY = bannerShadowBlur;
				df.strength = bannerShadowStrength;
				df.knockout = true;
				var dfArray:Array = new Array();
				dfArray.push(df);
				shadow_base.filters = dfArray;
				shadow_base.alpha = 0;
			}
			if (!isNaN(bannerBorderColor) && bannerBorderThickness > 0) {
				Geom.drawBorder(border_base, bannerWidth, bannerHeight, bannerBorderColor, 1, bannerBorderThickness, 0);
				border_base.x = mc.x = mask_mc.x = bannerBorderThickness;
				border_base.y = mc.y = mask_mc.y = bannerBorderThickness;
			}
			
			// Processing "banners" node
			imagesArray = XMLParserObj.bannersNodeParser(dataXML.banners);
			
			if (randomImages == true) currentIndex = randRange(0, imagesArray.length-1);
			
			// Timer setting
			timer_mc = new Shape();
			timer_mc.name = "timer_mc";
			img.addChild(timer_mc);
			if (showTimer) {
				Geom.drawRectangle(timer_mc, 1, timerBarHeight, timerBarColor, timerBarAlpha);
				if (timerBarPosition == "top") timer_mc.y = 0;
				if (timerBarPosition == "bottom") timer_mc.y = imageAreaHeight - timerBarHeight;
				timer_mc.width = 0;
			}
				
			// Preloader setting
			preloader_mc.x = Math.round(imageAreaWidth/2+imageAreaXPosition);
			preloader_mc.y = Math.round(imageAreaHeight/2+imageAreaYPosition);
			preloader_mc.scaleX = preloader_mc.scaleY = 0.7;
			var prColor:ColorTransform = preloader_mc.transform.colorTransform;
			prColor.color = preloaderColor;
			preloader_mc.transform.colorTransform = prColor;
			
			// Background image loading
			if (bannerBackground != null) {
				var bgLoader:Loader = new Loader();
				bg.addChild(bgLoader);
				bgLoader.load(new URLRequest(bannerBackground+(killCachedFiles?killcache_str:'')));
			}
			
			if (bannerWidth > 0 && bannerHeight > 0) {
				createTransitionTypeArray(imageTransitionType);
				imagesLoading();
				timerActionsControl = new Timer(30, 0);
				timerActionsControl.addEventListener(TimerEvent.TIMER, actionsControl);
				timerActionsControl.start();
			}
			
			// *** Mouse over banner control
			img.buttonMode = true;
			img.useHandCursor = false;
			img.addEventListener(MouseEvent.ROLL_OVER, imgListener);
			img.addEventListener(MouseEvent.ROLL_OUT, imgListener);
			img.addEventListener(MouseEvent.CLICK, imgListener);
			
			bgTween = new Tween(bg, "alpha", Strong.easeOut, bg.alpha, 1, 0.7, true);
			shadowTween = new Tween(shadow_base, "alpha", Strong.easeOut, shadow_base.alpha, 1, 0.7, true);
		}
		
		private function imgListener(e:Event):void {
			switch (e.type) {
				case "rollOver":
					if (controlsAutoHide) controlsFade("in");
					mouseover_flag = true;
					if (imagesArray[currentIndex].link != undefined) imagesArray[currentIndex].container_mc.useHandCursor = true;
					else imagesArray[currentIndex].container_mc.useHandCursor = false;
				break;
				case "rollOut":
					if (controlsAutoHide) {
						timerCFadeOut2.reset();
						timerCFadeOut2.start();
					}
					mouseover_flag = false;
				break;
				case "click":
					if (imagesArray[currentIndex].link != undefined && imagesArray[currentIndex].bmpData != undefined && imagesArray[currentIndex].bmpData != "failed") {
						var link:String = imagesArray[currentIndex].link;
						var target:String = imagesArray[currentIndex].target;
						if (target == null) target = "_blank";
						if (link == "#") SWFAddress.setValue("/");
						else {
							if (link.substr(0, 4) == "http" || link.substr(0, 7) == "mailto:" || link.substr(0, 11) == "javascript:") {
								try { navigateToURL(new URLRequest(link), target); }
								catch (e:Error) { }
							} else if (link.substr(0, 1) == "#") {
								SWFAddress.setValue(link.substr(1));
							}
						}
					}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Loads images one by one in background.

		private function imagesLoading():void {
			imgLoader = new Loader();
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadProcessing);
			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgLoadError);
			imgLoader.load(new URLRequest(imagesArray[currentImgIndex].src+(killCachedFiles?killcache_str:'')));
			if (showPreloader) preloader_mc.visible = true;
		}
		
		private function imgLoadProcessing(e:Event):void {
			var bmpData:BitmapData = Bitmap(e.target.content).bitmapData;
			imagesArray[currentImgIndex].bmpData = bmpData;
			Geom.drawRectangle(imagesArray[currentImgIndex].mask_mc, bmpData.width, bmpData.height, 0xFF9900, 0);
			if (currentImgIndex == 0) {	// on first image loading
				preloader_mc.visible = false;
				controlsBuilding();
				if (controlsAutoHide) {
					timerCFadeOut1 = new Timer(3000, 1);
					timerCFadeOut2 = new Timer(controlsAutoHideDelay*1000, 1);
				}
				setShowControls(showControls);
				if (controlsAutoHide) {
					timerCFadeOut1.addEventListener(TimerEvent.TIMER, controlsFadeListener);
					timerCFadeOut1.start();
					timerCFadeOut2.addEventListener(TimerEvent.TIMER, controlsFadeListener);
				}
			}
			currentImgIndex++;
			for (var i=currentImgIndex; i<imagesArray.length; i++) {
				if (imagesArray[i].bmpData != undefined) {
					currentImgIndex++;
				} else {
					imgLoader.load(new URLRequest(imagesArray[i].src+(killCachedFiles?killcache_str:'')));
					break;
				}
			}
			if (currentImgIndex >= imagesArray.length) {
				e.target.removeEventListener(Event.COMPLETE, imgLoadProcessing);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, imgLoadError);
			}
		}
		
		private function imgLoadError(e:Event):void {
			preloader_mc.visible = false;
			imagesArray[currentImgIndex].bmpData = "failed";
			currentImgIndex++;
			for (var i=currentImgIndex; i<imagesArray.length; i++) {
				if (imagesArray[i].bmpData != undefined) {
					currentImgIndex++;
				} else {
					imgLoader.load(new URLRequest(imagesArray[i].src+(killCachedFiles?killcache_str:'')));
					break;
				}
			}
			if (currentImgIndex >= imagesArray.length) {
				e.target.removeEventListener(Event.COMPLETE, imgLoadProcessing);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, imgLoadError);
			}
		}
		
	/*******************************************************************************************************************************/
	//	Function. Controls timer operating, nextLoadingIndex calculating and starting image transition.

		private function actionsControl(e:TimerEvent):void {
			
			// *** Timer control
			var total_time:Number = imagesArray[currentIndex].showTime?imagesArray[currentIndex].showTime:imageShowTime;
			var played_time:Number = (getTimer()-imageTimerStartPoint)/1000;
			if ((mouseover_flag && pauseOnMouseOver) || !autoPlay) {
				if (isNaN(timer_mspassed) && !isNaN(imageTimerStartPoint)) timer_mspassed = getTimer() - imageTimerStartPoint;
				if (!isNaN(timer_mspassed)) imageTimerStartPoint = getTimer() - timer_mspassed;
			} else {
				timer_mspassed = NaN;
			}
			if (showTimer && autoPlay) {
				if (!mouseover_flag || !pauseOnMouseOver)	timer_mc.width = Math.floor(imageAreaWidth*played_time/total_time);
			}
			
			// *** Calculating the nextLoadingIndex
			if (imagesArray.length > 1) {
				var nextLoadingIndex:Number;
				if (randomImages == true) {
					for (var i=1; i<100; i++) {
						var randomIndex:uint = randRange(0, imagesArray.length-1);
						if (randomIndex != currentIndex) break;
					}
					nextLoadingIndex = randomIndex;
				} else {
					if (repeatMode == false) {
						if (currentIndex == imagesArray.length-1) {
							nextLoadingIndex = NaN;
							autoPlay = false;
							setAutoPlay(autoPlay);
						} else {
							nextLoadingIndex = currentIndex+1;
						}
					}
					else nextLoadingIndex = (currentIndex == imagesArray.length-1)?0:currentIndex+1;
				}
			}
			
			// *** autoPlay
			if (autoPlay == true && !isNaN(imageTimerStartPoint) && (played_time >= total_time)) {
				if (!isNaN(nextLoadingIndex)) changeCurrentIndex(nextLoadingIndex, true);
			}
			
			// *** Changing the order of slides levels, launching the "exposureEffect" function
			if (imagesArray[currentIndex].bmpData != undefined && imagesArray[currentIndex].bmpData != "failed" && loading_flag) {
				loading_flag = false;
				var transition_type:String;
				var interval_time:Number;
				if (imagesArray[currentIndex].transitionType != undefined) {
					transition_type = imagesArray[currentIndex].transitionType;
				} else {
					transitionTypeIndex();	// setting the index of the current transition effect
					transition_type = transitionType_array[transitionIndex];
				}
				removeChilds(imagesArray[currentIndex].container_mc);
				linesBuilding(imagesArray[currentIndex].container_mc, transition_type, squares_in_row, squares_in_col);
				if (transition_type == "1" || transition_type == "3" || transition_type == "5" || transition_type == "7" || transition_type == "9") imagesArray[currentIndex].current_line = 0;
				if (transition_type == "2" || transition_type == "4") imagesArray[currentIndex].current_line = squares_in_col+squares_in_row;
				if (transition_type == "6") imagesArray[currentIndex].current_line = squares_in_row+1;
				if (transition_type == "8") imagesArray[currentIndex].current_line = squares_in_col+1;
				if (transition_type == "1" || transition_type == "2" || transition_type == "3" || transition_type == "4") {
					interval_time = imageTransitionDuration*1000/(squares_in_col+squares_in_row-1)*0.7;
				}
				if (transition_type == "5" || transition_type == "6") {
					interval_time = imageTransitionDuration*1000/squares_in_row*0.7;
				}
				if (transition_type == "7" || transition_type == "8") {
					interval_time = imageTransitionDuration*1000/squares_in_col*0.7;
				}
				if (transition_type == "9") {
					interval_time = 40;
				}
				img.setChildIndex(imagesArray[currentIndex].container_mc, img.getChildIndex(timer_mc)-1);
				
				// ** The start of TRANSITION
				clearInterval(imagesArray[currentIndex].intID);
				imagesArray[currentIndex].intID = setInterval(exposureEffect, interval_time, currentIndex, transition_type);
				imageTimerStartPoint = getTimer();
				if (imagesArray[currentIndex].link != undefined) imagesArray[currentIndex].container_mc.useHandCursor = true;
				else imagesArray[currentIndex].container_mc.useHandCursor = false;
				captionBuilding(currentIndex);
			}
		}
		
	/*******************************************************************************************************************************/
	//	Function. Changes the current slide index. Launches "imageLoading" function (if loading = true), or rolls back to previous index.

		private function changeCurrentIndex(new_index:uint, loading:Boolean):void {
			loading_flag = false;
			imageTimerStartPoint = NaN;
			timer_mspassed = NaN;
			timer_mc.width = 0;
			if (loading) rollbackIndex = currentIndex;
			else {
				rollbackIndex = 0;
				imageTimerStartPoint = getTimer();
			}
			currentIndex = new_index;
			if (loading) {
				loading_flag = true;
				imageLoading(currentIndex);
			}
			changePushedButton(currentIndex);
		}	
		
	/****************************************************************************************************/
	//	Function. Launches image loading. The function is called from "changeCurrentIndex" function.

		private function imageLoading(index:uint):void {
			if (imagesArray[index].bmpData == undefined) {
				imageLoader.load(new URLRequest(imagesArray[index].src+(killCachedFiles?killcache_str:'')));
				if (showPreloader) preloader_mc.visible = true;
			} else if (imagesArray[index].bmpData == "failed") {
				changeCurrentIndex(rollbackIndex, false);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Builds shapes for transition effects. The function is called from "actionsControl" function.

		private function linesBuilding(container_mc:Sprite, trans_type:String, sq_row:uint, sq_col:uint):void {
			var f:uint;
			switch (trans_type) {
				case "1":
				case "2":
				case "3":
				case "4":
					// diagonals
					f = sq_row+sq_col-1;
				break;
				case "5":
				case "6":
					// vertical lines
					f = sq_row;
				break;
				case "7":
				case "8":
					// horizontal lines
					f = sq_col;
			}
			var line_mc:Shape;
			if (trans_type == "9") { // whole image
				line_mc = new Shape();
				line_mc.name = "line_mc1";
				container_mc.addChild(line_mc);
			} else {
				for (var i=1; i<=f; i++) {
					line_mc = new Shape();
					line_mc.name = "line_mc"+i;
					container_mc.addChild(line_mc);
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Removes nested childs.
	
		private function removeChilds(container:Sprite):void {
			while (container.numChildren > 0) {
				if (container.getChildAt(0).name == "caption_mc") break;
				else container.removeChildAt(0);
			}
		}
	
	/****************************************************************************************************/
	//	Function. Creates an array of elements (squares) for the current diagonal. Used for "Diagonal Fade" transition effect.
	
		private function createSquaresArray(current_line:uint, trans_type:String):Array {
			var squares_array:Array = new Array();
			var row:uint, col:uint;
			var squareObject:Object;
			if (trans_type == "1" || trans_type == "2") {
				if (current_line <= squares_in_col){
					row = squares_in_col-(current_line-1);
					col = 1;
				} else if (current_line > squares_in_col && current_line < (squares_in_col+squares_in_row)) {
					row = 1;
					col = current_line-(squares_in_col-1);
				}
				while (row <= squares_in_col && col <= squares_in_row) {
					squareObject = new Object();
					squareObject.row = row;
					squareObject.col = col;
					squares_array.push(squareObject);
					row++;
					col++;
				}
			}
			if (trans_type == "3" || trans_type == "4") {
				if (current_line <= squares_in_col){
					row = current_line;
					col = 1;
				} else if (current_line > squares_in_col && current_line < (squares_in_col+squares_in_row)) {
					row = squares_in_col;
					col = current_line-(squares_in_col-1);
				}
				while (row >= 1 && col <= squares_in_row) {
					squareObject = new Object();
					squareObject.row = row;
					squareObject.col = col;
					squares_array.push(squareObject);
					row--;
					col++;
				}
			}
			return squares_array;
		}
	
	/****************************************************************************************************/
	//	Function. Generates a transition effect. The function is called from "actionsControl" function.

		private function exposureEffect(index:uint, trans_type:String) {
			var line_mc:Shape;
			var bmp_matrix:Matrix = new Matrix();
			var rectx:uint, recty:uint;
			var transition1:Boolean, transition2:Boolean, transition3:Boolean, transition4:Boolean, transition5:Boolean, transition6:Boolean, transition7:Boolean, transition8:Boolean, transition9:Boolean;
			var imgTweenObject:Object = new Object();
			imgTweenObject.exp = imageExposureStrength;
			if (trans_type == "1" && imagesArray[index].current_line < (squares_in_col+squares_in_row-1)) transition1 = true;
			if (trans_type == "2" && imagesArray[index].current_line > 1) transition2 = true;
			if (trans_type == "3" && imagesArray[index].current_line < (squares_in_col+squares_in_row-1)) transition3 = true;
			if (trans_type == "4" && imagesArray[index].current_line > 1) transition4 = true;
			if (trans_type == "5" && imagesArray[index].current_line < squares_in_row) transition5 = true;
			if (trans_type == "6" && imagesArray[index].current_line > 1) transition6 = true;
			if (trans_type == "7" && imagesArray[index].current_line < squares_in_col) transition7 = true;
			if (trans_type == "8" && imagesArray[index].current_line > 1) transition8 = true;
			if (trans_type == "9" && imagesArray[index].current_line < 1) transition9 = true;
			if (transition1 || transition3 || transition5 || transition7 || transition9) {
				imagesArray[index].current_line++;
			} else if (transition2 || transition4 || transition6 || transition8) {
				imagesArray[index].current_line--;
			}
			if (transition1 || transition2 || transition3 || transition4) {
				line_mc = imagesArray[index].container_mc.getChildByName("line_mc"+imagesArray[index].current_line);
				var squaresArray:Array = createSquaresArray(imagesArray[index].current_line, trans_type);
				if (line_mc) {
					line_mc.alpha = 0.2;
					with (line_mc.graphics) {
						clear();
						var sqx:uint, sqy:uint;
						beginBitmapFill(imagesArray[index].bmpData, bmp_matrix);
						for (var i=0; i<squaresArray.length; i++) {
							sqx = (squaresArray[i].col-1)*squareSize;
							sqy = (squaresArray[i].row-1)*squareSize;
							if (i==0) moveTo(sqx, sqy);
							if (trans_type == "1" || trans_type == "2") {
								lineTo(sqx+squareSize, sqy);
								lineTo(sqx+squareSize, sqy+squareSize);
							}
							if (trans_type == "3" || trans_type == "4") {
								lineTo(sqx, sqy);
								lineTo(sqx+squareSize, sqy);
							}
						}
						for (var j=squaresArray.length-1; j>=0; j--) {
							sqx = (squaresArray[j].col-1)*squareSize;
							sqy = (squaresArray[j].row-1)*squareSize;
							if (trans_type == "1" || trans_type == "2") {
								lineTo(sqx, sqy+squareSize);
								lineTo(sqx, sqy);
							}
							if (trans_type == "3" || trans_type == "4") {
								lineTo(sqx+squareSize, sqy+squareSize);
								lineTo(sqx, sqy+squareSize);
							}
						}
						endFill();
					}
					imgTweenObject.line_mc = line_mc;
					imgTweenObject.start_alpha = 0.2;
					imagesArray[index].imgTweens[imagesArray[index].current_line-1] = new Tween(imgTweenObject, "exp", Regular.easeOut, imageExposureStrength, 1, imageExposureDelay, true);
					imagesArray[index].imgTweens[imagesArray[index].current_line-1].addEventListener(TweenEvent.MOTION_CHANGE, imageTweenListener);
				}
			} else if (transition5 || transition6 || transition7 || transition8) {
				line_mc = imagesArray[index].container_mc.getChildByName("line_mc"+imagesArray[index].current_line);
				if (line_mc) {
					line_mc.alpha = 0;
					with (line_mc.graphics) {
						clear();
						beginBitmapFill(imagesArray[index].bmpData, bmp_matrix);
						if (trans_type == "5" || trans_type == "6") {
							rectx = (imagesArray[index].current_line-1)*squareSize;
							recty = 0;
							moveTo(rectx, recty);
							lineTo(rectx+squareSize, recty);
							lineTo(rectx+squareSize, recty+imageAreaHeight);
							lineTo(rectx, recty+imageAreaHeight);
							lineTo(rectx, recty);
						}
						if (trans_type == "7" || trans_type == "8") {
							rectx = 0;
							recty = (imagesArray[index].current_line-1)*squareSize;
							moveTo(rectx, recty);
							lineTo(rectx+imageAreaWidth, recty);
							lineTo(rectx+imageAreaWidth, recty+squareSize);
							lineTo(rectx, recty+squareSize);
							lineTo(rectx, recty);
						}
						endFill();
					}
					imgTweenObject.line_mc = line_mc;
					imgTweenObject.start_alpha = 0;
					imagesArray[index].imgTweens[imagesArray[index].current_line-1] = new Tween(imgTweenObject, "exp", Regular.easeOut, imageExposureStrength, 1, imageExposureDelay, true);
					imagesArray[index].imgTweens[imagesArray[index].current_line-1].addEventListener(TweenEvent.MOTION_CHANGE, imageTweenListener);
				}
			} else if (transition9) {
				line_mc = imagesArray[index].container_mc.getChildByName("line_mc"+imagesArray[index].current_line);
				if (line_mc) {
					line_mc.alpha = 0;
					with (line_mc.graphics) {
						clear();
						beginBitmapFill(imagesArray[index].bmpData, bmp_matrix);
						rectx = recty = 0;
						lineTo(rectx+imageAreaWidth, recty);
						lineTo(rectx+imageAreaWidth, recty+imageAreaHeight);
						lineTo(rectx, recty+imageAreaHeight);
						lineTo(rectx, recty);
						endFill();
					}
					imgTweenObject.line_mc = line_mc;
					imgTweenObject.start_alpha = 0;
					imagesArray[index].imgTweens[imagesArray[index].current_line-1] = new Tween(imgTweenObject, "exp", Regular.easeOut, imageExposureStrength, 1, imageTransitionDuration, true);
					imagesArray[index].imgTweens[imagesArray[index].current_line-1].addEventListener(TweenEvent.MOTION_CHANGE, imageTweenListener);
				}
			}
			else {
				imagesArray[index].current_line = undefined;
				clearInterval(imagesArray[index].intID);
			}
		}
		
		private function imageTweenListener(e:TweenEvent):void {
			colorMatrix(e.currentTarget.obj.line_mc, e.position, e.currentTarget.obj.start_alpha);
		}
	
	/****************************************************************************************************/
	//	Function. Creates the "Exposure" and "Fade" effects for an image transition.

		private function colorMatrix(mc:*, val:Number, start_alpha:Number = NaN) {
			if (mc.name.substr(0, 7) != "line_mc" || imgExpStrength != 1) {
				var matrix:Array = new Array();
				matrix = matrix.concat([val, 0, 0, 0, 0]); // red
				matrix = matrix.concat([0, val, 0, 0, 0]); // green
				matrix = matrix.concat([0, 0, val, 0, 0]); // blue
				matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
				var filter:BitmapFilter = new ColorMatrixFilter(matrix);
				mc.filters = new Array(filter);
			}
			if (!isNaN(start_alpha)) mc.alpha = start_alpha + (imageExposureStrength-val)*(1-start_alpha)/(imageExposureStrength-1);
		}
	
	/****************************************************************************************************/
	//	Function. Builds the caption for the selected slide.

		private function captionBuilding(index:uint):void {
			var caption_mc:Sprite, textblock:Sprite, text_area:Sprite;
			var text_bg:Shape, text_bmp:Shape;
			var caption_tf:TextField;
			var matrix:Matrix, bmp_matrix:Matrix;
			var hasBg:Boolean, hasHyperlink:Boolean;
			if (imagesArray[index].container_mc.getChildByName("caption_mc")) {
				caption_mc = imagesArray[index].container_mc.getChildByName("caption_mc");
				imagesArray[index].container_mc.setChildIndex(caption_mc, imagesArray[index].container_mc.numChildren-1);
			} else {
				caption_mc = new Sprite();
				caption_mc.name = "caption_mc";
				imagesArray[index].container_mc.addChild(caption_mc);
				caption_mc.mouseEnabled = false;
			}
			
			for (var i=0; i<imagesArray[index].caption.length; i++) {
				clearInterval(imagesArray[index].caption[i].intIDstart);
				clearInterval(imagesArray[index].caption[i].intIDend);
				delete imagesArray[index].caption[i].blur_filterArray;
				if (imagesArray[index].caption[i].textblockTweenFade) imagesArray[index].caption[i].textblockTweenFade.stop();
				if (imagesArray[index].caption[i].textblockTweenMove) imagesArray[index].caption[i].textblockTweenMove.stop();
				if (imagesArray[index].caption[i].textblockTweenExposure) imagesArray[index].caption[i].textblockTweenExposure.stop();
				if (imagesArray[index].caption[i].textblockTweenGradientMask) imagesArray[index].caption[i].textblockTweenGradientMask.stop();
				if (imagesArray[index].caption[i].textblockTweenStripMask) imagesArray[index].caption[i].textblockTweenStripMask.stop();
				if (imagesArray[index].caption[i].textblockTweenBlindMask) imagesArray[index].caption[i].textblockTweenBlindMask.stop();
				if (imagesArray[index].caption[i].textblockTweenXZoom) imagesArray[index].caption[i].textblockTweenXZoom.stop();
				if (imagesArray[index].caption[i].textblockTweenYZoom) imagesArray[index].caption[i].textblockTweenYZoom.stop();
				if (imagesArray[index].caption[i].textblockTweenXMove) imagesArray[index].caption[i].textblockTweenXMove.stop();
				if (imagesArray[index].caption[i].textblockTweenYMove) imagesArray[index].caption[i].textblockTweenYMove.stop();
				if (imagesArray[index].caption[i].textblockTweenBlur) imagesArray[index].caption[i].textblockTweenBlur.stop();
				
				if (caption_mc.getChildByName("textblock"+(i+1))) {
					textblock = caption_mc.getChildByName("textblock"+(i+1)) as Sprite;
				} else {
					textblock = new Sprite();
					textblock.name = "textblock"+(i+1);
					caption_mc.addChild(textblock);
					textblock.mouseEnabled = false;
				}
				textblock.x = imagesArray[index].caption[i].xPos;
				textblock.y = imagesArray[index].caption[i].yPos;
				textblock.alpha = 0;
				textblock.scaleX = textblock.scaleY = 1;
				if (textblock.getChildByName("text_bg")) {
					text_bg = textblock.getChildByName("text_bg") as Shape;
				} else {
					text_bg = new Shape();
					text_bg.name = "text_bg";
					textblock.addChild(text_bg);
				}
				if (textblock.getChildByName("text_area")) {
					text_area = textblock.getChildByName("text_area") as Sprite;
					caption_tf = text_area.getChildByName("caption_tf") as TextField;
				} else {
					text_area = new Sprite();
					text_area.name = "text_area";
					textblock.addChild(text_area);
					caption_tf = new TextField();
					caption_tf.selectable = false;
					caption_tf.antiAliasType = AntiAliasType.ADVANCED;
					caption_tf.name = "caption_tf";
					text_area.addChild(caption_tf);
				}
				if (textblock.getChildByName("text_bmp")) {
					text_bmp = textblock.getChildByName("text_bmp") as Shape;
					text_bmp.graphics.clear();
					text_bmp.filters = null;
				} else {
					text_bmp = new Shape();
					text_bmp.name = "text_bmp";
					textblock.addChild(text_bmp);
				}
				if (textblock.getChildByName("text_bmp2")) textblock.removeChild(textblock.getChildByName("text_bmp2"));
				if (textblock.getChildByName("gradient_mask")) textblock.removeChild(textblock.getChildByName("gradient_mask"));
				if (textblock.getChildByName("strip_mask")) textblock.removeChild(textblock.getChildByName("strip_mask"));
				if (textblock.getChildByName("blind_maskL")) textblock.removeChild(textblock.getChildByName("blind_maskL"));
				if (textblock.getChildByName("blind_maskR")) textblock.removeChild(textblock.getChildByName("blind_maskR"));
				if (imagesArray[index].caption[i].bgColor != undefined && imagesArray[index].caption[i].bgAlpha > 0) hasBg = true;
				if (captionTextStyleSheet != null && (imagesArray[index].caption[i].text.indexOf("<a") >= 0 || imagesArray[index].caption[i].text.indexOf("href") >= 0 || imagesArray[index].caption[i].text.indexOf("<img") >= 0)) {
					hasHyperlink = true;
				}
				
				// *** Formating the caption text and drawing a bitmap for the current textblock
				if (imagesArray[index].caption[i].bmpData == undefined) {
					if (captionTextStyleSheet != null) caption_tf.styleSheet = captionTextStyleSheet;
					if (imagesArray[index].caption[i].width != undefined) {
						caption_tf.width = imagesArray[index].caption[i].width;
						caption_tf.multiline = true;
						caption_tf.wordWrap = true;
					} else {
						caption_tf.multiline = false;
						caption_tf.wordWrap = false;
					}
					if (imagesArray[index].caption[i].height != undefined) {
						caption_tf.height = imagesArray[index].caption[i].height - 2*imagesArray[index].caption[i].textPadding;
						caption_tf.autoSize = TextFieldAutoSize.NONE;
					} else {
						caption_tf.autoSize = TextFieldAutoSize.LEFT;
					}
					caption_tf.embedFonts = captionEmbedFonts;
					caption_tf.htmlText = imagesArray[index].caption[i].text;
					if (imagesArray[index].caption[i].textAlpha != undefined) caption_tf.alpha = imagesArray[index].caption[i].textAlpha;
					var tf_width:uint = Math.floor(caption_tf.width) + imagesArray[index].caption[i].textPadding*2
					var tf_height:uint = Math.floor(caption_tf.height) + imagesArray[index].caption[i].textPadding*2;
					if (imagesArray[index].caption[i].bgGradientAngle != undefined) {
						matrix = new Matrix();
						matrix.createGradientBox(tf_width, tf_height, imagesArray[index].caption[i].bgGradientAngle*Math.PI/180, 0, 0);
						with (text_bg.graphics) {
							beginGradientFill("linear", [imagesArray[index].caption[i].bgColor, imagesArray[index].caption[i].bgColor], [0, imagesArray[index].caption[i].bgAlpha], [0, 255], matrix, "pad", "RGB", 0);
							lineTo(tf_width, 0);
							lineTo(tf_width, tf_height);
							lineTo(0, tf_height);
							lineTo(0, 0);
							endFill();
						}
					} else {
						Geom.drawRectangle(text_bg, tf_width, tf_height, imagesArray[index].caption[i].bgColor, imagesArray[index].caption[i].bgAlpha, imagesArray[index].caption[i].bgCornerRadius, imagesArray[index].caption[i].bgCornerRadius, imagesArray[index].caption[i].bgCornerRadius, imagesArray[index].caption[i].bgCornerRadius);
					}
					caption_tf.x = caption_tf.y = imagesArray[index].caption[i].textPadding;
					var textblock_width:uint = Math.floor(textblock.width);
					var textblock_height:uint = Math.floor(textblock.height);
					var bmpData:BitmapData = new BitmapData(textblock_width, textblock_height, true, 0);
					if (imagesArray[index].caption[i].shadow == true) {
						dropshadow_filter = new DropShadowFilter();
						dropshadow_filter.color = captionTextShadowColor;
						dropshadow_filter.distance = 2;
						dropshadow_filter.angle = 45;
						dropshadow_filter.quality = 3;
						dropshadow_filter.blurX = dropshadow_filter.blurY = 4;
						dropshadow_filter.strength = 1;
						dropshadow_filter.alpha = captionTextShadowAlpha;
						dropshadow_filterArray = new Array();
						dropshadow_filterArray.push(dropshadow_filter);
						if (hasBg == true) {
							text_bg.filters = dropshadow_filterArray;
						} else {
							text_area.filters = dropshadow_filterArray;
						}
						bmpData = new BitmapData(textblock_width+5, textblock_height+5, true, 0);
					}
					bmpData.draw(textblock);
					imagesArray[index].caption[i].bmpData = bmpData;
					text_area.visible = false;
					text_bg.visible = false;
				}
				// ***
				
				with (text_bmp.graphics) {
					bmp_matrix = new Matrix();
					beginBitmapFill(imagesArray[index].caption[i].bmpData, bmp_matrix);
					lineTo(imagesArray[index].caption[i].bmpData.width, 0);
					lineTo(imagesArray[index].caption[i].bmpData.width, imagesArray[index].caption[i].bmpData.height);
					lineTo(0, imagesArray[index].caption[i].bmpData.height);
					lineTo(0, 0);
					endFill();
				}
				
				var prop:String;
				var start_point:int, finish_point:int;
				var start_duration:Number, end_duration:Number, start_delay:Number, end_delay:Number, start_strength:Number, end_strength:Number;
				start_duration = imagesArray[index].caption[i].startAnimDuration;
				start_delay = imagesArray[index].caption[i].startDelay*1000
				start_strength = imagesArray[index].caption[i].startAnimExpStrength;
				end_duration = imagesArray[index].caption[i].endAnimDuration;
				end_delay = start_delay + imagesArray[index].caption[i].showTime*1000;
				end_strength = imagesArray[index].caption[i].endAnimExpStrength;
				switch (String(imagesArray[index].caption[i].startAnimDirection)) {
					case "left":
						prop = "x";
						finish_point = imagesArray[index].caption[i].xPos;
						start_point = finish_point - imagesArray[index].caption[i].startAnimOffset;
					break;
					case "right":
						prop = "x";
						finish_point = imagesArray[index].caption[i].xPos;
						start_point = finish_point + imagesArray[index].caption[i].startAnimOffset;
					break;
					case "top":
						prop = "y";
						finish_point = imagesArray[index].caption[i].yPos;
						start_point = finish_point - imagesArray[index].caption[i].startAnimOffset;
					break;
					case "bottom":
						prop = "y";
						finish_point = imagesArray[index].caption[i].yPos;
						start_point = finish_point + imagesArray[index].caption[i].startAnimOffset;
				}
				
				// *** Building the masks for the "Glitter" effect
				if (imagesArray[index].caption[i].startAnimType == "Glitter" || imagesArray[index].caption[i].endAnimType == "Glitter") {
					var gradient_mask:Sprite = new Sprite();
					gradient_mask.name = "gradient_mask";
					textblock.addChild(gradient_mask);
					Geom.drawRectangle(gradient_mask, text_bmp.width-20, text_bmp.height, 0xFF9900, 1);
					var gradient:MovieClip = new grad_mask();
					gradient.x = text_bmp.width + 90;
					gradient.y = text_bmp.height/2;
					gradient.height = text_bmp.height;
					gradient_mask.addChild(gradient);
					gradient_mask.x = -gradient_mask.width;
					gradient_mask.visible = false;
					gradient_mask.cacheAsBitmap = true;
					text_bmp.cacheAsBitmap = true;
					if ((!isNaN(start_strength) && start_strength > 1) || (!isNaN(end_strength) && end_strength > 1)) {
						var strip_mask:Shape = new Shape();
						strip_mask.name = "strip_mask";
						textblock.addChild(strip_mask);
						matrix = new Matrix();
						matrix.createGradientBox(50, text_bmp.height, Math.PI/10, 0, 0);
						with (strip_mask.graphics) {
							beginGradientFill("linear", [0xFF9900, 0xFF9900, 0xFF9900, 0xFF9900], [0, 100, 100, 0], [0, 100, 155, 255], matrix, "pad", "RGB", 0);
							lineTo(200, 0);
							lineTo(200, text_bmp.height);
							lineTo(0, text_bmp.height);
							lineTo(0, 0);
							endFill();
						}
						strip_mask.x = -strip_mask.width;
						strip_mask.height = text_bmp.height;
						strip_mask.cacheAsBitmap = true;
						var text_bmp2:Shape = new Shape();
						text_bmp2.name = "text_bmp2";
						textblock.addChild(text_bmp2);
						bmp_matrix = new Matrix();
						if (hasBg == true) {
							var bmpData2:BitmapData = new BitmapData(text_bmp.width, text_bmp.height, true, 0);
							bmpData2.draw(text_area);
							with (text_bmp2.graphics) {
								beginBitmapFill(bmpData2, bmp_matrix);
								lineTo(bmpData2.width, 0);
								lineTo(bmpData2.width, bmpData2.height);
								lineTo(0, bmpData2.height);
								lineTo(0, 0);
								endFill();
							}
						} else {
							with (text_bmp2.graphics) {
								beginBitmapFill(imagesArray[index].caption[i].bmpData, bmp_matrix);
								lineTo(imagesArray[index].caption[i].bmpData.width, 0);
								lineTo(imagesArray[index].caption[i].bmpData.width, imagesArray[index].caption[i].bmpData.height);
								lineTo(0, imagesArray[index].caption[i].bmpData.height);
								lineTo(0, 0);
								endFill();
							}
						}
						text_bmp2.cacheAsBitmap = true;
						text_bmp2.mask = strip_mask;
					}
				}
				// ***
				
				// *** Building the mask for the "Blind" effect
				if (imagesArray[index].caption[i].startAnimType == "Blind" || imagesArray[index].caption[i].endAnimType == "Blind") {
					var blind_maskL:Shape = new Shape();
					blind_maskL.name = "blind_maskL";
					textblock.addChild(blind_maskL);
					matrix = new Matrix();
					matrix.createGradientBox(50, text_bmp.height, Math.PI, text_bmp.width, 0);
					with (blind_maskL.graphics) {
						beginGradientFill("linear", [0xFF9900, 0xFF9900], [0, 100], [0, 255], matrix, "pad", "RGB", 0);
						lineTo(text_bmp.width+50, 0);
						lineTo(text_bmp.width+50, text_bmp.height);
						lineTo(0, text_bmp.height);
						lineTo(0, 0);
						endFill();
					}
					blind_maskL.x = -(blind_maskL.width+10);
					blind_maskL.visible = false;
					blind_maskL.cacheAsBitmap = true;
					var blind_maskR:Shape = new Shape();
					blind_maskR.name = "blind_maskR";
					textblock.addChild(blind_maskR);
					matrix = new Matrix();
					matrix.createGradientBox(50, text_bmp.height, 0, 0, 0);
					with (blind_maskR.graphics) {
						beginGradientFill("linear", [0xFF9900, 0xFF9900], [0, 100], [0, 255], matrix, "pad", "RGB", 0);
						lineTo(text_bmp.width+50, 0);
						lineTo(text_bmp.width+50, text_bmp.height);
						lineTo(0, text_bmp.height);
						lineTo(0, 0);
						endFill();
					}
					blind_maskR.x = text_bmp.width + 10;
					blind_maskR.visible = false;
					blind_maskR.cacheAsBitmap = true;
					text_bmp.cacheAsBitmap = true;
				}
				// ***

				switch (String(imagesArray[index].caption[i].startAnimType)) {
					case "Fade":
						imagesArray[index].caption[i].intIDstart = setInterval(captionFadeIn, start_delay, textblock, index, i, prop, start_point, finish_point, start_duration, start_strength, hasHyperlink);
					break;
					case "Blind":
						imagesArray[index].caption[i].intIDstart = setInterval(captionBlindIn, start_delay, textblock, index, i, start_duration, start_strength, hasHyperlink);
					break;
					case "Zoom":
						imagesArray[index].caption[i].intIDstart = setInterval(captionZoomIn, start_delay, textblock, index, i, start_duration, start_strength, hasHyperlink);
					break;
					case "Glitter":
						if (text_bmp2) colorMatrix(text_bmp2, start_strength);
						imagesArray[index].caption[i].intIDstart = setInterval(captionGlitterIn, start_delay, textblock, index, i, start_duration, start_strength, hasHyperlink);
					break;
					case "Motion":
					default:
						imagesArray[index].caption[i].intIDstart = setInterval(captionMotionIn, start_delay, textblock, index, i, prop, start_point, finish_point, start_duration, start_strength, hasHyperlink);
				}
				
				start_point = finish_point = 0;
				prop = null;
				if (imagesArray[index].caption[i].showTime != undefined) {
					switch (String(imagesArray[index].caption[i].endAnimDirection)) {
						case "left":
							prop = "x";
							start_point = textblock.x;
							finish_point = imagesArray[index].caption[i].xPos - imagesArray[index].caption[i].endAnimOffset;
						break;
						case "right":
							prop = "x";
							start_point = textblock.x;
							finish_point = imagesArray[index].caption[i].xPos + imagesArray[index].caption[i].endAnimOffset;
						break;
						case "top":
							prop = "y";
							start_point = textblock.y;
							finish_point = imagesArray[index].caption[i].yPos - imagesArray[index].caption[i].endAnimOffset;
						break;
						case "bottom":
							prop = "y";
							start_point = textblock.y;
							finish_point = imagesArray[index].caption[i].yPos + imagesArray[index].caption[i].endAnimOffset;
					}
					switch (String(imagesArray[index].caption[i].endAnimType)) {
						case "Fade":
							imagesArray[index].caption[i].intIDend = setInterval(captionFadeOut, end_delay, textblock, index, i, prop, start_point, finish_point, end_duration, end_strength, hasHyperlink);
						break;
						case "Blind":
							imagesArray[index].caption[i].intIDend = setInterval(captionBlindOut, end_delay, textblock, index, i, end_duration, hasHyperlink);
						break;
						case "Zoom":
							imagesArray[index].caption[i].intIDend = setInterval(captionZoomOut, end_delay, textblock, index, i, end_duration, hasHyperlink);
						break;
						case "Glitter":
							if (text_bmp2) colorMatrix(text_bmp2, end_strength);
							imagesArray[index].caption[i].intIDend = setInterval(captionGlitterOut, end_delay, textblock, index, i, end_duration, end_strength, hasHyperlink);
						break;
						case "Motion":
							imagesArray[index].caption[i].intIDend = setInterval(captionMotionOut, end_delay, textblock, index, i, prop, start_point, finish_point, end_duration, end_strength, hasHyperlink);
					}
				}
				text_bmp2 = null;
				hasBg = hasHyperlink = false;
			}
		}
		
	/****************************************************************************************************/
	//	Function. Creates the "Fade" effect.
		
		private function captionFadeIn(textblock:Sprite, img_index:uint, txt_index:uint, prop:String, start_point:int, finish_point:int, duration:Number, strength:Number, hasHyperlink:Boolean) {
			var move_flag:Boolean = false;
			clearInterval(imagesArray[img_index].caption[txt_index].intIDstart);
			if (start_point != finish_point && prop != null) move_flag = true;
			if (move_flag) imagesArray[img_index].caption[txt_index].textblockTweenMove = new Tween(textblock, prop, Strong.easeOut, start_point, finish_point, duration, true);
			imagesArray[img_index].caption[txt_index].textblockTweenFade = new Tween(textblock, "alpha", Regular.easeOut, textblock.alpha, 1, duration, true);
			if (hasHyperlink) imagesArray[img_index].caption[txt_index].textblockTweenFade.addEventListener(TweenEvent.MOTION_FINISH, captionHyperlinkTweenListener);
			// Exposure effect
			if (!isNaN(strength) && strength > 1) {
				var tweenObj:Object = new Object();
				tweenObj.exp = strength;
				tweenObj.textblock = textblock;
				imagesArray[img_index].caption[txt_index].textblockTweenExposure = new Tween(tweenObj, "exp", Strong.easeOut, strength, 1, duration*(1+strength/3), true);
				imagesArray[img_index].caption[txt_index].textblockTweenExposure.addEventListener(TweenEvent.MOTION_CHANGE, captionExposureTweenListener);
			}
			// Blur effect
			if (imagesArray[img_index].caption[txt_index].startAnimBlur) {
				var blurX:uint, blurY:uint, blur_strength:uint;
				if (!move_flag) {blurX = 16; blurY = 8; blur_strength = 2; }
				else if (prop == "y") {blurX = 4; blurY = 32; blur_strength = 2;}
				else {blurX = 128; blurY = 8; blur_strength = 2;}
				if (duration > 0.6) {
					imagesArray[img_index].caption[txt_index].blur_filterArray = new Array();
					blur_filter = new BlurFilter(blurX, blurY, blur_strength);
					imagesArray[img_index].caption[txt_index].blur_filterArray.push(blur_filter);
					textblock.getChildByName("text_bmp").filters = imagesArray[img_index].caption[txt_index].blur_filterArray;
					imagesArray[img_index].caption[txt_index].intIDstart = setInterval(captionBlur, (duration-0.6)*1000, textblock, img_index, txt_index, 0.6, "out", blurX, blurY, blur_strength);
				} else {
					if (move_flag) captionBlur(textblock, img_index, txt_index, duration, "out", blurX, blurY, blur_strength);
					else captionBlur(textblock, img_index, txt_index, 0.6, "out", blurX, blurY, blur_strength);
				}
			}
		}
		
		private function captionFadeOut(textblock:Sprite, img_index:uint, txt_index:uint, prop:String, start_point:int, finish_point:int, duration:Number, strength:Number, hasHyperlink:Boolean) {
			var move_flag:Boolean = false;
			clearInterval(imagesArray[img_index].caption[txt_index].intIDend);
			if (start_point != finish_point && prop != null) move_flag = true;
			if (move_flag) imagesArray[img_index].caption[txt_index].textblockTweenMove = new Tween(textblock, prop, Strong.easeIn, start_point, finish_point, duration, true);
			imagesArray[img_index].caption[txt_index].textblockTweenFade = new Tween(textblock, "alpha", Regular.easeIn, textblock.alpha, 0, duration, true);
			if (hasHyperlink) {
				textblock.getChildByName("text_area").visible = textblock.getChildByName("text_bg").visible = false;
				textblock.getChildByName("text_bmp").visible = true;
			}
			// Blur effect
			if (imagesArray[img_index].caption[txt_index].endAnimBlur) {
				var blurX:uint, blurY:uint, blur_strength:uint;
				if (!move_flag) {blurX = 16; blurY = 8; blur_strength = 2; }
				else if (prop == "_y") {blurX = 4; blurY = 32; blur_strength = 2;}
				else {blurX = 128; blurY = 8; blur_strength = 2;}
				if (duration >= 0.6) {
					imagesArray[img_index].caption[txt_index].intIDend = setInterval(captionBlur, 200, textblock, img_index, txt_index, 0.4, "in", blurX, blurY, blur_strength);
				} else {
					if (duration > 0.4) imagesArray[img_index].caption[txt_index].intIDend = setInterval(captionBlur, (duration-0.4)*1000, textblock, img_index, txt_index, 0.4, "in", blurX, blurY, blur_strength);
					else captionBlur(textblock, img_index, txt_index, duration, "in", blurX, blurY, blur_strength);
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Creates the "Motion" effect.
	
		private function captionMotionIn(textblock:Sprite, img_index:uint, txt_index:uint, prop:String, start_point:int, finish_point:int, duration:Number, strength:Number, hasHyperlink:Boolean) {
			var move_flag:Boolean = false;
			clearInterval(imagesArray[img_index].caption[txt_index].intIDstart);
			if (start_point != finish_point && prop != null) move_flag = true;
			textblock.alpha = 1;
			if (move_flag) {
				imagesArray[img_index].caption[txt_index].textblockTweenMove = new Tween(textblock, prop, Strong.easeOut, start_point, finish_point, duration, true);
				if (hasHyperlink) imagesArray[img_index].caption[txt_index].textblockTweenMove.addEventListener(TweenEvent.MOTION_FINISH, captionHyperlinkTweenListener);
			} else if (hasHyperlink) {
				textblock.getChildByName("text_area").visible = textblock.getChildByName("text_bg").visible = true;
				textblock.getChildByName("text_bmp").visible = false;
			}
			// Exposure effect
			if (!isNaN(strength) && strength > 1) {
				var tweenObj:Object = new Object();
				tweenObj.exp = strength;
				tweenObj.textblock = textblock;
				imagesArray[img_index].caption[txt_index].textblockTweenExposure = new Tween(tweenObj, "exp", Strong.easeOut, strength, 1, duration*(1+strength/3), true);
				imagesArray[img_index].caption[txt_index].textblockTweenExposure.addEventListener(TweenEvent.MOTION_CHANGE, captionExposureTweenListener);
			}
			// Blur effect
			if (imagesArray[img_index].caption[txt_index].startAnimBlur) {
				var blurX:uint, blurY:uint, blur_strength:uint;
				if (!move_flag) {blurX = 8; blurY = 2; blur_strength = 2; }
				else if (prop == "y") {blurX = 4; blurY = 32; blur_strength = 2;}
				else {blurX = 64; blurY = 8; blur_strength = 2;}
				if (duration >= 0.6) {
					imagesArray[img_index].caption[txt_index].blur_filterArray = new Array();
					blur_filter = new BlurFilter(blurX, blurY, blur_strength);
					imagesArray[img_index].caption[txt_index].blur_filterArray.push(blur_filter);
					textblock.getChildByName("text_bmp").filters = imagesArray[img_index].caption[txt_index].blur_filterArray;
					imagesArray[img_index].caption[txt_index].intIDstart = setInterval(captionBlur, (duration-(duration>0.8?0.7:0.6))*1000, textblock, img_index, txt_index, 0.5, "out", blurX, blurY, blur_strength);
				} else {
					captionBlur(textblock, img_index, txt_index, duration, "out", blurX, blurY, blur_strength);
				}
			}
		}
		
		private function captionMotionOut(textblock:Sprite, img_index:uint, txt_index:uint, prop:String, start_point:int, finish_point:int, duration:Number, strength:Number, hasHyperlink:Boolean) {
			var move_flag:Boolean = false;
			clearInterval(imagesArray[img_index].caption[txt_index].intIDend);
			if (start_point != finish_point && prop != null) move_flag = true;
			imagesArray[img_index].caption[txt_index].textblockTweenMove = new Tween(textblock, prop, Strong.easeIn, start_point, finish_point, duration, true);
			imagesArray[img_index].caption[txt_index].textblockTweenMove.addEventListener(TweenEvent.MOTION_FINISH, captionMotionTweenListener);
			if (hasHyperlink) {
				textblock.getChildByName("text_area").visible = textblock.getChildByName("text_bg").visible = false;
				textblock.getChildByName("text_bmp").visible = true;
			}
			// Blur effect
			if (imagesArray[img_index].caption[txt_index].endAnimBlur) {
				var blurX:uint, blurY:uint, blur_strength:uint;
				if (!move_flag) {blurX = 8; blurY = 2; blur_strength = 2; }
				else if (prop == "y") {blurX = 4; blurY = 32; blur_strength = 2;}
				else {blurX = 64; blurY = 8; blur_strength = 2;}
				if (duration >= 0.6) {
					imagesArray[img_index].caption[txt_index].intIDend = setInterval(captionBlur, (duration>0.8?300:200), textblock, img_index, txt_index, 0.4, "in", blurX, blurY, blur_strength);
				} else {
					if (duration > 0.4) imagesArray[img_index].caption[txt_index].intIDend = setInterval(captionBlur, (duration-0.4)*1000, textblock, img_index, txt_index, 0.4, "in", blurX, blurY, blur_strength);
					else captionBlur(textblock, img_index, txt_index, duration, "in", blurX, blurY, blur_strength);
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Creates the "Blind" effect.
	
		private function captionBlindIn(textblock:Sprite, img_index:uint, txt_index:uint, duration:Number, strength:Number, hasHyperlink:Boolean) {
			var blind_mask:Shape;
			var finish_point:int;
			var text_bmp:Shape = textblock.getChildByName("text_bmp") as Shape;
			clearInterval(imagesArray[img_index].caption[txt_index].intIDstart);
			if (imagesArray[img_index].caption[txt_index].startAnimDirection == "right") {
				blind_mask = textblock.getChildByName("blind_maskR") as Shape;
				finish_point = text_bmp.width - blind_mask.width;
			} else {
				blind_mask = textblock.getChildByName("blind_maskL") as Shape;
				finish_point = 0;
			}
			text_bmp.mask = blind_mask;
			textblock.alpha = 1;
			imagesArray[img_index].caption[txt_index].textblockTweenBlindMask = new Tween(blind_mask, "x", Strong.easeOut, blind_mask.x, finish_point, duration, true);
			if (hasHyperlink) imagesArray[img_index].caption[txt_index].textblockTweenBlindMask.addEventListener(TweenEvent.MOTION_FINISH, captionHyperlinkTweenListener);
			// Exposure effect
			if (!isNaN(strength) && strength > 1) {
				var tweenObj:Object = new Object();
				tweenObj.exp = strength;
				tweenObj.textblock = textblock;
				imagesArray[img_index].caption[txt_index].textblockTweenExposure = new Tween(tweenObj, "exp", Strong.easeOut, strength, 1, duration*(1+strength/3), true);
				imagesArray[img_index].caption[txt_index].textblockTweenExposure.addEventListener(TweenEvent.MOTION_CHANGE, captionExposureTweenListener);
			}
			// Blur effect
			if (imagesArray[img_index].caption[txt_index].startAnimBlur) {
				var blurX:uint, blurY:uint, blur_strength:uint;
				blurX = 32; blurY = 8; blur_strength = 2;
				if (duration > 0.6) {
					imagesArray[img_index].caption[txt_index].blur_filterArray = new Array();
					blur_filter = new BlurFilter(blurX, blurY, blur_strength);
					imagesArray[img_index].caption[txt_index].blur_filterArray.push(blur_filter);
					text_bmp.filters = imagesArray[img_index].caption[txt_index].blur_filterArray;
					if (duration > 0.7) imagesArray[img_index].caption[txt_index].intIDstart = setInterval(captionBlur, (duration-0.7)*0.5*1000, textblock, img_index, txt_index, 0.4, "out", blurX, blurY, blur_strength);
					else imagesArray[img_index].caption[txt_index].intIDstart = setInterval(captionBlur, (duration-0.6)*1000, textblock, img_index, txt_index, 0.4, "out", blurX, blurY, blur_strength);
				} else {
					captionBlur(textblock, img_index, txt_index, (duration<0.4?duration:0.4), "out", blurX, blurY, blur_strength);
				}
			}
		}
		
		private function captionBlindOut(textblock:Sprite, img_index:uint, txt_index:uint, duration:Number, hasHyperlink:Boolean) {
			var blind_mask:Shape;
			var start_point:int, finish_point:int;
			var text_bmp:Shape = textblock.getChildByName("text_bmp") as Shape;
			clearInterval(imagesArray[img_index].caption[txt_index].intIDend);
			if (imagesArray[img_index].caption[txt_index].endAnimDirection == "right") {
				blind_mask = textblock.getChildByName("blind_maskR") as Shape;
				start_point = text_bmp.width - blind_mask.width;
				finish_point = text_bmp.width + 10;
			} else {
				blind_mask = textblock.getChildByName("blind_maskL") as Shape;
				start_point = 0;
				finish_point = -(blind_mask.width+10);
			}
			text_bmp.mask = null;
			blind_mask.x = start_point;
			text_bmp.mask = blind_mask;
			imagesArray[img_index].caption[txt_index].textblockTweenBlindMask = new Tween(blind_mask, "x", Strong.easeOut, blind_mask.x, finish_point, duration, true);
			if (hasHyperlink) {
				textblock.getChildByName("text_area").visible = textblock.getChildByName("text_bg").visible = false;
				text_bmp.visible = true;
			}
			// Blur effect
			if (imagesArray[img_index].caption[txt_index].endAnimBlur) {
				var blurX:uint, blurY:uint, blur_strength:uint;
				blurX = 32; blurY = 8; blur_strength = 2;
				captionBlur(textblock, img_index, txt_index, (duration<0.3?duration:0.3), "in", blurX, blurY, blur_strength);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Creates the "Zoom" effect.
	
		private function captionZoomIn(textblock:Sprite, img_index:uint, txt_index:uint, duration:Number, strength:Number, hasHyperlink:Boolean) {
			var text_bmp:Shape = textblock.getChildByName("text_bmp") as Shape;
			clearInterval(imagesArray[img_index].caption[txt_index].intIDstart);
			var xPos:int = imagesArray[img_index].caption[txt_index].xPos;
			var yPos:int = imagesArray[img_index].caption[txt_index].yPos;
			var w:uint = text_bmp.width;
			var h:uint = text_bmp.height;
			var start_xscale:Number, start_yscale:Number, start_xpoint:Number, start_ypoint:Number;
			var ease_func:Function;
			if (imagesArray[img_index].caption[txt_index].startAnimDirection == "foreground") {
				start_xscale = start_yscale = 4;
				start_xpoint = xPos-w*1.5;
				start_ypoint = yPos-h*1.5;
				ease_func = Regular.easeIn;
			} else {
				start_xscale = start_yscale = 0;
				start_xpoint = xPos+w/2;
				start_ypoint = yPos+h/2;
				ease_func = Regular.easeIn;
			}
			imagesArray[img_index].caption[txt_index].textblockTweenFade = new Tween(textblock, "alpha", ease_func, textblock.alpha, 1, duration, true);
			imagesArray[img_index].caption[txt_index].textblockTweenXZoom = new Tween(textblock, "scaleX", Regular.easeOut, start_xscale, 1, duration, true);
			imagesArray[img_index].caption[txt_index].textblockTweenYZoom = new Tween(textblock, "scaleY", Regular.easeOut, start_yscale, 1, duration, true);
			imagesArray[img_index].caption[txt_index].textblockTweenXMove = new Tween(textblock, "x", Regular.easeOut, start_xpoint, xPos, duration, true);
			imagesArray[img_index].caption[txt_index].textblockTweenYMove = new Tween(textblock, "y", Regular.easeOut, start_ypoint, yPos, duration, true);
			if (hasHyperlink) imagesArray[img_index].caption[txt_index].textblockTweenXZoom.addEventListener(TweenEvent.MOTION_FINISH, captionHyperlinkTweenListener);
			// Exposure effect
			if (!isNaN(strength) && strength > 1) {
				var tweenObj:Object = new Object();
				tweenObj.exp = strength;
				tweenObj.textblock = textblock;
				imagesArray[img_index].caption[txt_index].textblockTweenExposure = new Tween(tweenObj, "exp", Regular.easeOut, strength, 1, duration*(1+strength/3), true);
				imagesArray[img_index].caption[txt_index].textblockTweenExposure.addEventListener(TweenEvent.MOTION_CHANGE, captionExposureTweenListener);
			}
			// Blur effect
			if (imagesArray[img_index].caption[txt_index].startAnimBlur) {
				var blurX:uint, blurY:uint, blur_strength:uint;
				blurX = 32; blurY = 4; blur_strength = 2;
				if (duration > 0.2) {
					imagesArray[img_index].caption[txt_index].blur_filterArray = new Array();
					blur_filter = new BlurFilter(blurX, blurY, blur_strength);
					imagesArray[img_index].caption[txt_index].blur_filterArray.push(blur_filter);
					text_bmp.filters = imagesArray[img_index].caption[txt_index].blur_filterArray;
					imagesArray[img_index].caption[txt_index].intIDstart = setInterval(captionBlur, (duration-0.2)*1000, textblock, img_index, txt_index, 0.4, "out", blurX, blurY, blur_strength);
				} else {
					captionBlur(textblock, img_index, txt_index, 0.4, "out", blurX, blurY, blur_strength);
				}
			}
		}
		
		private function captionZoomOut(textblock:Sprite, img_index:uint, txt_index:uint, duration:Number, hasHyperlink:Boolean) {
			var text_bmp:Shape = textblock.getChildByName("text_bmp") as Shape;
			clearInterval(imagesArray[img_index].caption[txt_index].intIDend);
			var xPos:int = imagesArray[img_index].caption[txt_index].xPos;
			var yPos:int = imagesArray[img_index].caption[txt_index].yPos;
			var w:uint = text_bmp.width;
			var h:uint = text_bmp.height;
			var finish_xscale:Number, finish_yscale:Number, finish_xpoint:Number, finish_ypoint:Number;
			var ease_func:Function;
			if (imagesArray[img_index].caption[txt_index].endAnimDirection == "foreground") {
				finish_xscale = finish_yscale = 4;
				finish_xpoint = xPos-w*1.5;
				finish_ypoint = yPos-h*1.5;
				ease_func = Regular.easeOut;
			} else {
				finish_xscale = finish_yscale = 0;
				finish_xpoint = xPos+w/2;
				finish_ypoint = yPos+h/2;
				ease_func = Regular.easeOut;
			}
			imagesArray[img_index].caption[txt_index].textblockTweenFade = new Tween(textblock, "alpha", ease_func, textblock.alpha, 0, duration, true);
			imagesArray[img_index].caption[txt_index].textblockTweenXZoom = new Tween(textblock, "scaleX", Regular.easeIn, textblock.scaleX, finish_xscale, duration, true);
			imagesArray[img_index].caption[txt_index].textblockTweenYZoom = new Tween(textblock, "scaleY", Regular.easeIn, textblock.scaleY, finish_yscale, duration, true);
			imagesArray[img_index].caption[txt_index].textblockTweenXMove = new Tween(textblock, "x", Regular.easeIn, textblock.x, finish_xpoint, duration, true);
			imagesArray[img_index].caption[txt_index].textblockTweenYMove = new Tween(textblock, "y", Regular.easeIn, textblock.y, finish_ypoint, duration, true);
			if (hasHyperlink) {
				textblock.getChildByName("text_area").visible = textblock.getChildByName("text_bg").visible = false;
				text_bmp.visible = true;
			}
			// Blur effect
			if (imagesArray[img_index].caption[txt_index].endAnimBlur) {
				var blurX:uint, blurY:uint, blur_strength:uint;
				blurX = 32; blurY = 4; blur_strength = 2;
				captionBlur(textblock, img_index, txt_index, (duration<0.4?duration:0.4), "in", blurX, blurY, blur_strength);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Creates the "Glitter" effect.
	
		private function captionGlitterIn(textblock:Sprite, img_index:uint, txt_index:uint, duration:Number, strength:Number, hasHyperlink:Boolean) {
			var text_bmp:Shape = textblock.getChildByName("text_bmp") as Shape;
			var gradient_mask:Sprite = textblock.getChildByName("gradient_mask") as Sprite;
			var strip_mask:Shape = textblock.getChildByName("strip_mask") as Shape;
			clearInterval(imagesArray[img_index].caption[txt_index].intIDstart);
			text_bmp.mask = gradient_mask;
			textblock.alpha = 1;
			imagesArray[img_index].caption[txt_index].textblockTweenGradientMask = new Tween(gradient_mask, "x", Regular.easeOut, gradient_mask.x, 0, duration*1.3, true);
			if (hasHyperlink) imagesArray[img_index].caption[txt_index].textblockTweenGradientMask.addEventListener(TweenEvent.MOTION_FINISH, captionHyperlinkTweenListener);
			if (!isNaN(strength) && strength > 1) {
				imagesArray[img_index].caption[txt_index].textblockTweenStripMask = new Tween(strip_mask, "x", Regular.easeOut, strip_mask.x, text_bmp.width, duration*1.3, true);
			}
			// Blur effect
			if (imagesArray[img_index].caption[txt_index].startAnimBlur) {
				var blurX:uint, blurY:uint, blur_strength:uint;
				blurX = 16; blurY = 8; blur_strength = 2;
				if (duration > 0.6) {
					imagesArray[img_index].caption[txt_index].blur_filterArray = new Array();
					blur_filter = new BlurFilter(blurX, blurY, blur_strength);
					imagesArray[img_index].caption[txt_index].blur_filterArray.push(blur_filter);
					text_bmp.filters = imagesArray[img_index].caption[txt_index].blur_filterArray;
					imagesArray[img_index].caption[txt_index].intIDstart = setInterval(captionBlur, (duration-0.6)*1000, textblock, img_index, txt_index, 0.4, "out", blurX, blurY, blur_strength);
				} else {
					captionBlur(textblock, img_index, txt_index, (duration<0.4?duration:0.4), "out", blurX, blurY, blur_strength);
				}
			}
		}
		
		private function captionGlitterOut(textblock:Sprite, img_index:uint, txt_index:uint, duration:Number, strength:Number, hasHyperlink:Boolean) {
			var text_bmp:Shape = textblock.getChildByName("text_bmp") as Shape;
			var gradient_mask:Sprite = textblock.getChildByName("gradient_mask") as Sprite;
			var strip_mask:Shape = textblock.getChildByName("strip_mask") as Shape;
			clearInterval(imagesArray[img_index].caption[txt_index].intIDend);
			text_bmp.mask = null;
			gradient_mask.graphics.clear();
			gradient_mask.getChildAt(0).rotation = 180;
			gradient_mask.getChildAt(0).x = 110;
			Geom.drawRectangle(gradient_mask, text_bmp.width-20, text_bmp.height, 0xFF9900, 1, 0, 0, 0, 0, 220, 0);
			gradient_mask.x = -200;
			text_bmp.mask = gradient_mask;
			imagesArray[img_index].caption[txt_index].textblockTweenGradientMask = new Tween(gradient_mask, "x", Regular.easeIn, gradient_mask.x, text_bmp.width, duration*1.3, true);
			if (hasHyperlink) {
				textblock.getChildByName("text_area").visible = textblock.getChildByName("text_bg").visible = false;
				text_bmp.visible = true;
			}
			if (!isNaN(strength) && strength > 1) {
				imagesArray[img_index].caption[txt_index].textblockTweenStripMask = new Tween(strip_mask, "x", Regular.easeIn, -50, text_bmp.width+150, duration*1.3, true);
			}
			// Blur effect
			if (imagesArray[img_index].caption[txt_index].endAnimBlur) {
				var blurX:uint, blurY:uint, blur_strength:uint;
				blurX = 8; blurY = 2; blur_strength = 2;
				if (duration >= 0.6) {
					imagesArray[img_index].caption[txt_index].intIDend = setInterval(captionBlur, 200, textblock, img_index, txt_index, 0.4, "in", blurX, blurY, blur_strength);
				} else {
					if (duration > 0.4) imagesArray[img_index].caption[txt_index].intIDend = setInterval(captionBlur, (duration-0.4)*1000, textblock, img_index, txt_index, 0.4, "in", blurX, blurY, blur_strength);
					else captionBlur(textblock, img_index, txt_index, (duration<0.4?duration:0.4), "in", blurX, blurY, blur_strength);
				}
			}
		}
	
	/****************************************************************************************************/
		
		private function captionHyperlinkTweenListener(e:TweenEvent):void {
			var textblock = e.currentTarget.obj;
			textblock.getChildByName("text_area").visible = textblock.getChildByName("text_bg").visible = true;
			textblock.getChildByName("text_bmp").visible = false;
		}
		private function captionExposureTweenListener(e:TweenEvent):void {
			colorMatrix(e.currentTarget.obj.textblock, e.position);
		}
		private function captionMotionTweenListener(e:TweenEvent):void {
			e.currentTarget.obj.alpha = 0;
		}
	
	/****************************************************************************************************/
	// Function. Applies the Blur filter to a caption text.
	
		private function captionBlur(textblock:Sprite, img_index:uint, txt_index:uint, duration:Number, dir:String, blurX:uint, blurY:uint, blur_strength:uint) {
			var tweenObj:Object = new Object();
			tweenObj.textblock = textblock;
			tweenObj.img_index = img_index;
			tweenObj.txt_index = txt_index;
			tweenObj.dir = dir;
			tweenObj.blur = undefined;
			tweenObj.blurX = blurX;
			tweenObj.blurY = blurY;
			if (dir == "out") {
				clearInterval(imagesArray[img_index].caption[txt_index].intIDstart);
				if (imagesArray[img_index].caption[txt_index].blur_filterArray == undefined) {
					imagesArray[img_index].caption[txt_index].blur_filterArray = new Array();
					blur_filter = new BlurFilter(blurX, blurY, blur_strength);
					imagesArray[img_index].caption[txt_index].blur_filterArray.push(blur_filter);
				}
				imagesArray[img_index].caption[txt_index].textblockTweenBlur = new Tween(tweenObj, "blur", Regular.easeOut, blurX, 0, duration, true);
				imagesArray[img_index].caption[txt_index].textblockTweenBlur.addEventListener(TweenEvent.MOTION_CHANGE, captionBlurTweenListener);
				imagesArray[img_index].caption[txt_index].textblockTweenBlur.addEventListener(TweenEvent.MOTION_FINISH, captionBlurTweenListener);
			}
			if (dir == "in") {
				clearInterval(imagesArray[img_index].caption[txt_index].intIDend);
				if (imagesArray[img_index].caption[txt_index].blur_filterArray == undefined) {
					imagesArray[img_index].caption[txt_index].blur_filterArray = new Array();
					blur_filter = new BlurFilter(0, 0, blur_strength);
					imagesArray[img_index].caption[txt_index].blur_filterArray.push(blur_filter);
				}
				imagesArray[img_index].caption[txt_index].textblockTweenBlur = new Tween(tweenObj, "blur", Regular.easeIn, 0, blurX, duration, true);
				imagesArray[img_index].caption[txt_index].textblockTweenBlur.addEventListener(TweenEvent.MOTION_CHANGE, captionBlurTweenListener);
			}
		}
		
		private function captionBlurTweenListener(e:TweenEvent):void {
			var val:Number = e.position;
			var textblock:Sprite = e.currentTarget.obj.textblock;
			var img_index:uint = e.currentTarget.obj.img_index;
			var txt_index:uint = e.currentTarget.obj.txt_index;
			var dir:String = e.currentTarget.obj.dir;
			var blurX:uint = e.currentTarget.obj.blurX;
			var blurY:uint = e.currentTarget.obj.blurY;
			if (e.type == "motionChange") {
				if (val > 0.5) {
					imagesArray[img_index].caption[txt_index].blur_filterArray[0].blurX = val;
					imagesArray[img_index].caption[txt_index].blur_filterArray[0].blurY = blurY*(val/blurX);
					textblock.getChildByName("text_bmp").filters = imagesArray[img_index].caption[txt_index].blur_filterArray;
				} else {
					if (dir == "out" && imagesArray[img_index].caption[txt_index].blur_filterArray[0].blurX != 0) {
						imagesArray[img_index].caption[txt_index].blur_filterArray[0].blurX = imagesArray[img_index].caption[txt_index].blur_filterArray[0].blurY = 0;
						textblock.getChildByName("text_bmp").filters = imagesArray[img_index].caption[txt_index].blur_filterArray;
					}
				}
			}
			if (e.type == "motionFinish") {
				textblock.getChildByName("text_bmp").filters = null;
			}
		}
		
	/****************************************************************************************************/
	//	Function. Builds the controls: navigation buttons and play/pause button.
		
		private function controlsBuilding():void {
			controls_mc = new Sprite();
			controls_mc.alpha = 0;
			controls_mc.mouseEnabled = false;
			mc.addChild(controls_mc);
			var button_x:uint = (controlsType=="1")?5:2;
			var button_y:uint = (controlsType=="1")?5:2;
			var butBgColor:ColorTransform, butOverBgColor:ColorTransform, butSelectedBgColor:ColorTransform, playIconColor:ColorTransform, pauseIconColor:ColorTransform;
			
			// *** Play/pause button
			if (showPlayPauseButton && controlsType == "2") {
				var playpause_btn:MovieClip = new pp_button();
				playpause_btn.name = "playpause_btn";
				playpause_btn.x = button_x;
				playpause_btn.y = button_y;
				controls_mc.addChild(playpause_btn);
				button_x = Math.ceil(playpause_btn.width) + buttonSpacing;
				if (!showButtonShadow) playpause_btn.shadow.visible = false;
				if (!isNaN(buttonBgColor)) {
					butBgColor = playpause_btn.bg_up.transform.colorTransform;
					butBgColor.color = buttonBgColor;
					playpause_btn.bg_up.transform.colorTransform = butBgColor;
				}
				playIconColor = playpause_btn.play_icon.transform.colorTransform;
				playIconColor.color = playPauseIconColor;
				playpause_btn.play_icon.transform.colorTransform = playIconColor;
				pauseIconColor = playpause_btn.pause_icon.transform.colorTransform;
				pauseIconColor.color = playPauseIconColor;
				playpause_btn.pause_icon.transform.colorTransform = pauseIconColor;
				playpause_btn.buttonMode = true;
				playpause_btn.addEventListener(MouseEvent.ROLL_OVER, playpauseButtonListener);
				playpause_btn.addEventListener(MouseEvent.ROLL_OUT, playpauseButtonListener);
				playpause_btn.addEventListener(MouseEvent.CLICK, playpauseButtonListener);
			}
			setAutoPlay(autoPlay);
			
			// *** Navigation buttons
			for (var i=1; i<=imagesArray.length; i++) {
				var nav_btn:Sprite = new Sprite();
				nav_btn.name = "nav_btn"+i;
				nav_btn.x = button_x;
				nav_btn.y = button_y;
				controls_mc.addChild(nav_btn);
				var upstate:MovieClip, overstate:MovieClip, selstate:MovieClip;
				if (controlsType == "1") {
					upstate = new nav_button_up1();
					overstate = new nav_button_over1();
					selstate = new nav_button_sel1();
				} else {
					upstate = new nav_button_up2();
					overstate = new nav_button_over2();
					selstate = new nav_button_over2();
				}
				upstate.name = "upstate";
				overstate.name = "overstate";
				selstate.name = "selstate";
				nav_btn.addChild(upstate);
				nav_btn.addChild(overstate);
				nav_btn.addChild(selstate);
				button_x = button_x + Math.ceil(nav_btn.width) + (i<imagesArray.length?buttonSpacing:0);
				if (!showButtonShadow) {
					if (controlsType == "1") upstate.shadow.alpha = overstate.shadow.alpha = selstate.shadow.alpha = 0.01;
					if (controlsType == "2") {
						upstate.shadow.visible = overstate.shadow.visible = selstate.shadow.visible = false;
					}
				}
				if (!isNaN(buttonBgColor)) {
					butBgColor = upstate.bg.transform.colorTransform;
					butBgColor.color = buttonBgColor;
					upstate.bg.transform.colorTransform = butBgColor;
					if (controlsType == "1") {
						butBgColor = upstate.fg.transform.colorTransform;
						butBgColor.color = buttonBgColor;
						upstate.fg.transform.colorTransform = butBgColor;
					}
				}
				if (!isNaN(buttonOverBgColor)) {
					butOverBgColor = overstate.bg.transform.colorTransform;
					butOverBgColor.color = buttonOverBgColor;
					overstate.bg.transform.colorTransform = butOverBgColor;
					if (controlsType == "1") {
						butOverBgColor = overstate.fg.transform.colorTransform;
						butOverBgColor.color = buttonOverBgColor;
						overstate.fg.transform.colorTransform = butOverBgColor;
					}
					if (controlsType == "2") {
						butSelectedBgColor = selstate.bg.transform.colorTransform;
						butSelectedBgColor.color = buttonSelectedBgColor;
						selstate.bg.transform.colorTransform = butSelectedBgColor;
					}
				}
				if (controlsType == "1") {
					if (!isNaN(buttonSelectedBgColor)) {
						butSelectedBgColor = selstate.bg.transform.colorTransform;
						butSelectedBgColor.color = buttonSelectedBgColor;
						selstate.bg.transform.colorTransform = butSelectedBgColor;
						butSelectedBgColor = selstate.fg.transform.colorTransform;
						butSelectedBgColor.color = buttonSelectedBgColor;
						selstate.fg.transform.colorTransform = butSelectedBgColor;
					}
					if (!isNaN(buttonShadowColor)) {
						butBgColor = upstate.shadow.transform.colorTransform;
						butBgColor.color = buttonShadowColor;
						upstate.shadow.transform.colorTransform = butBgColor;
						butOverBgColor = overstate.shadow.transform.colorTransform;
						butOverBgColor.color = buttonShadowColor;
						overstate.shadow.transform.colorTransform = butOverBgColor;
						butSelectedBgColor = selstate.shadow.transform.colorTransform;
						butSelectedBgColor.color = buttonShadowColor;
						selstate.shadow.transform.colorTransform = butSelectedBgColor;
					}
				}
				if (i == currentIndex+1) upstate.visible = false;
				else selstate.visible = false;
				overstate.visible = false;
				nav_btn.buttonMode = true;
				nav_btn.addEventListener(MouseEvent.ROLL_OVER, navButtonListener);
				nav_btn.addEventListener(MouseEvent.ROLL_OUT, navButtonListener);
				nav_btn.addEventListener(MouseEvent.CLICK, navButtonListener);
			}
			if (controlsType == "1") Geom.drawRectangle(controls_mc, controls_mc.width+10,  controls_mc.height+10, 0xFFFFFF, 0);
			if (controlsType == "2") Geom.drawRectangle(controls_mc, controls_mc.width+4,  controls_mc.height+4, 0xFFFFFF, 0);
			
			// *** Controls positioning
			switch (controlsPosition) {
				case "left":
					controls_mc.x = controlsXOffset;
				break;
				case "center":
					controls_mc.x = Math.round((bannerWidth - controls_mc.width)/2);
				break;
				case "right":
					controls_mc.x = Math.floor(bannerWidth - controls_mc.width - controlsXOffset);
			}
			controls_mc.y = Math.floor(bannerHeight - controls_mc.height - controlsYOffset);
			
			// *** Mask building
			controls_mask = new Shape();
			mc.addChild(controls_mask);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(50, controls_mc.height, Math.PI, controls_mc.width, 0);
			with (controls_mask.graphics) {
				beginGradientFill("linear", [0xFF9900, 0xFF9900], [0, 100], [0, 255], matrix, "pad", "RGB", 0);
				lineTo(controls_mc.width+50, 0);
				lineTo(controls_mc.width+50, controls_mc.height);
				lineTo(0, controls_mc.height);
				lineTo(0, 0);
				endFill();
			}
			controls_mask.x = controls_mc.x - controls_mask.width;
			controls_mask.y = controls_mc.y;
			controls_mask.cacheAsBitmap = true;
			controls_mc.cacheAsBitmap = true;
			controls_mc.mask = controls_mask;
		}
		
		private function playpauseButtonListener(e:Event):void {
			var playIconColTrans:ColorTransform = e.currentTarget.play_icon.transform.colorTransform;
			var pauseIconColTrans:ColorTransform = e.currentTarget.pause_icon.transform.colorTransform;
			switch (e.type) {
				case "rollOver":
					if (controlsAutoHide) controlsFade("in");
					mouseover_flag = true;
					playIconColTrans.color = playPauseIconOverColor;
					pauseIconColTrans.color = playPauseIconOverColor;
				break;
				case "rollOut":
					if (controlsAutoHide) {
						timerCFadeOut2.reset();
						timerCFadeOut2.start();
					}
					mouseover_flag = false;
					playIconColTrans.color = playPauseIconColor;
					pauseIconColTrans.color = playPauseIconColor;
				break;
				case "click":
					autoPlay = !autoPlay;
					setAutoPlay(autoPlay);
			}
			e.currentTarget.play_icon.transform.colorTransform = playIconColTrans;
			e.currentTarget.pause_icon.transform.colorTransform = pauseIconColTrans;
		}
		
		private function navButtonListener(e:Event):void {
			var index:uint = e.currentTarget.name.substr(7)-1;
			var upstate_mc:MovieClip = e.currentTarget.getChildByName("upstate");
			var overstate_mc:MovieClip = e.currentTarget.getChildByName("overstate");
			switch (e.type) {
				case "rollOver":
					if (controlsAutoHide) controlsFade("in");
					mouseover_flag = true;
					if (index != currentIndex) {
						if (controlsType == "1") {
							upstate_mc.visible = false;
							overstate_mc.visible = true;
						} else {
							overstate_mc.visible = true;
							if (imagesArray[index].btnTweenOver) imagesArray[index].btnTweenOver.stop();
							imagesArray[index].btnTweenOver = new Tween(overstate_mc, "alpha", None.easeNone, 0, 1, buttonRollAnimationDuration, true);
							if (imagesArray[index].btnTweenUp) imagesArray[index].btnTweenUp.stop();
							imagesArray[index].btnTweenUp = new Tween(upstate_mc, "alpha", None.easeNone, upstate_mc.alpha, 0, buttonRollAnimationDuration, true);
							imagesArray[index].btnTweenUp.addEventListener(TweenEvent.MOTION_FINISH, navButtonTweenListener);
						}
					}
				break;
				case "rollOut":
					if (controlsAutoHide) {
						timerCFadeOut2.reset();
						timerCFadeOut2.start();
					}
					mouseover_flag = false;
					if (index != currentIndex && overstate_mc.visible == true) {
						if (controlsType == "1") {
							upstate_mc.visible = true;
							overstate_mc.visible = false;
						} else {
							upstate_mc.visible = true;
							if (imagesArray[index].btnTweenOver) imagesArray[index].btnTweenOver.stop();
							imagesArray[index].btnTweenOver = new Tween(overstate_mc, "alpha", None.easeNone, overstate_mc.alpha, 0, buttonRollAnimationDuration, true);
							imagesArray[index].btnTweenOver.addEventListener(TweenEvent.MOTION_FINISH, navButtonTweenListener);
							if (imagesArray[index].btnTweenUp) imagesArray[index].btnTweenUp.stop();
							imagesArray[index].btnTweenUp = new Tween(upstate_mc, "alpha", None.easeNone, upstate_mc.alpha, 1, buttonRollAnimationDuration, true);
						}
					}
				break;
				case "click":
					if (index != currentIndex) gotoSlide(index);
			}
		}
		
		private function navButtonTweenListener(e:TweenEvent):void {
			e.currentTarget.obj.visible = false;
		}
		
	/****************************************************************************************************/
	//	Function. Fades in/out the controls
	
		private function controlsFadeListener(e:TimerEvent):void {
			controlsFade("out");
		}

		private function controlsFade(val:String):void {
			if (timerCFadeOut1) {
				timerCFadeOut1.stop();
				timerCFadeOut1.removeEventListener(TimerEvent.TIMER, controlsFadeListener);
			}
			if (timerCFadeOut2) timerCFadeOut2.stop();
			if (controlsTween) controlsTween.stop();
			if (controls_maskTween) controls_maskTween.stop();
			var start_alpha:uint, finish_alpha:uint, start_point:uint, finish_point:uint;
			var easing:Function;
			if (val == "in") {
				start_alpha = controls_mc.alpha;
				finish_alpha = 1;
				start_point = controls_mask.x;
				finish_point = controls_mc.x;
				easing = Regular.easeOut;
			}
			if (val == "out") {
				start_alpha = controls_mc.alpha;
				finish_alpha = 0;
				start_point = controls_mask.x;
				finish_point = controls_mc.x - controls_mask.width;
				easing = Regular.easeIn;
			}
			if (start_point != finish_point) {
				controlsTween = new Tween(controls_mc, "alpha", easing, start_alpha, finish_alpha, controlsAutoHideDuration, true);
				controls_maskTween = new Tween(controls_mask, "x", easing, start_point, finish_point, controlsAutoHideDuration, true);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Changes the state of buttons if one of them is pushed.

		private function changePushedButton(index:uint):void {
			for (var i=0; i<imagesArray.length; i++) {
				var nav_btn:Sprite = controls_mc.getChildByName("nav_btn"+(i+1)) as Sprite;
				var upstate_mc:MovieClip = MovieClip(nav_btn.getChildByName("upstate"));
				var overstate_mc:MovieClip = MovieClip(nav_btn.getChildByName("overstate"));
				var selstate_mc:MovieClip = MovieClip(nav_btn.getChildByName("selstate"));
				if (i == index) {
					upstate_mc.visible = false;
					overstate_mc.visible = false;
					selstate_mc.visible = true;
				} else {
					if (overstate_mc.visible == false) {
						upstate_mc.visible = true;
						selstate_mc.visible = false;
						if (controlsType == "2") upstate_mc.alpha = 1;
					}
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Selects the type of a transition effect for the next image. The function is called from "actionsControl" function.

		private function transitionTypeIndex() {
			if (transitionType_array.length > 1) {
				if (randomImageTransitions == true) {
					for (var i=1; i<100; i++) {
						var randomIndex:uint = randRange(0, transitionType_array.length-1);
						if (randomIndex != transitionIndex) break;
					}
					transitionIndex = randomIndex;
				} else {
					if (transitionIndex == -1) transitionIndex = 0;
					else transitionIndex = (transitionIndex == transitionType_array.length-1)?0:transitionIndex+1;
				}
			} else {
				transitionIndex = 0;
			}
		}
		
	/****************************************************************************************************/
	//	Function. Creates the array of transition types.

		private function createTransitionTypeArray(types_str:String):void {
			transitionType_array = types_str.split(",");
			var array_temp:Array = transitionType_array;
			transitionType_array = new Array();
			for (var i=0; i<array_temp.length; i++) {
				if (checkTransition(array_temp[i])) transitionType_array.push(array_temp[i]);
			}
			if (transitionType_array.length == 0) transitionType_array[0] = "1";
		}
		
	/****************************************************************************************************/
	//	Function. Checks if the value of a transition type is acceptable or not.

		public function checkTransition(type:String):Boolean {
			var types:Array = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];	// acceptable values for transition type
			var result:Boolean = false;
			for (var i=0; i<types.length; i++) {
				if (type == types[i]) {result = true; break;}
			}
			return result;
		}
		
	/****************************************************************************************************/
	//	Function. Checks if the value of an animation type is acceptable or not.

		public function checkAnimation(type:String, period:String):Boolean {
			var types:Array
			if (period == "start") types = ["Fade", "Motion", "Blind", "Zoom", "Glitter"];		// acceptable values for the type of start_animation
			if (period == "end") types = ["Fade", "Motion", "Blind", "Zoom", "Glitter"];		// acceptable values for the type of end_animation
			var result:Boolean = false;
			for (var i=0; i<types.length; i++) {
				if (type == types[i]) {result = true; break;}
			}
			return result;
		}
		
	/****************************************************************************************************/
	//	Function. Returns a random value from the range.

		private function randRange(min:uint, max:uint):uint {
			var randomNum:uint = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}
	
	/****************************************************************************************************/
	// METHODS
	/****************************************************************************************************/
	//	Method. Navigates to the specified index.

		public function gotoSlide(index:uint) {
			if (index >= 0 && index < imagesArray.length && index != currentIndex) {
				changeCurrentIndex(index, true);
			}
		}
	
	/****************************************************************************************************/
	// PROPERTIES
	/****************************************************************************************************/
	//	Property: selectedIndex
	
		public function get selectedIndex():uint {
			return currentIndex;
		}
	
	/****************************************************************************************************/
	
		private function setAutoPlay(val:Boolean) {
			if (showPlayPauseButton && controlsType == "2") {
				var playpause_btn:MovieClip = controls_mc.getChildByName("playpause_btn") as MovieClip;
				if (val == true) playpause_btn.gotoAndStop("play");
				if (val == false) playpause_btn.gotoAndStop("pause");
			}
		}
	
	/****************************************************************************************************/
	
		private function setShowControls(val:Boolean) {
			if (val == true) controlsFade("in");
			if (val == false) controlsFade("out");
		}
		
	/****************************************************************************************************/
	//	Function. Performs a number of actions for deactivating the banner rotator.

		public function killBannerRotator():void {
			if (timerCFadeOut1) {
				timerCFadeOut1.stop();
				timerCFadeOut1.removeEventListener(TimerEvent.TIMER, controlsFadeListener);
			}
			if (timerCFadeOut2) {
				timerCFadeOut2.stop();
				timerCFadeOut2.removeEventListener(TimerEvent.TIMER, controlsFadeListener);
			}
			if (timerActionsControl) {
				timerActionsControl.stop();
				timerActionsControl.removeEventListener(TimerEvent.TIMER, actionsControl);
			}
		}
	}
}