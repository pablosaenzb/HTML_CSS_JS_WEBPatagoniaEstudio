/**
	XMLParser class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.bannerrotator {
	
	import flash.display.Sprite;
	import flash.display.Shape;

	public class XMLParser {
		
		private var __root:*;
		private var imagesArray:Array;
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function XMLParser(obj:*):void {
			__root = obj; // a reference to the object of the main class
		}
		
	/****************************************************************************************************/
	//	Function. Parses the attributes of the "settings" node.
	
		public function settingsNodeParser(node:XMLList):void {
			
			var attr_name:String;
			for each (var attr:* in node.@*) {
				attr_name = attr.name();
				
				switch (attr_name) {
					// *** General properties
					case "bannerWidth":
						if (Number(attr) > 0) __root.bannerWidth = attr;
					break;
					case "bannerHeight":
						if (Number(attr) > 0) __root.bannerHeight = attr;
					break;
					case "bannerBgColor":
						if (attr != "") __root.bannerBgColor = Number("0x" + attr);
					break;
					case "bannerBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.bannerBgAlpha = attr;
					break;
					case "bannerBackground":
						if (attr != "") __root.bannerBackground = attr;
					break;
					case "bannerCornerRadius":
						if (Number(attr) >= 0 && attr != "") __root.bannerCornerRadius = attr;
					break;
					case "bannerBorderColor":
						if (attr != "") __root.bannerBorderColor = Number("0x" + attr);
					break;
					case "bannerBorderThickness":
						if (Number(attr) >= 0 && attr != "") __root.bannerBorderThickness = attr;
					break;
					case "bannerShadowColor":
						if (attr != "") __root.bannerShadowColor = Number("0x" + attr);
					break;
					case "bannerShadowAlpha":
						if (Number(attr) >= 0 && attr != "") __root.bannerShadowAlpha = attr;
					break;
					case "autoPlay":
						if (attr == "true" || attr == "false") __root.autoPlay = stringToBoolean(attr);
					break;
					case "imageShowTime":
						if (Number(attr) >= 0 && attr != "") __root.imageShowTime = Number(attr)<=0?0.001:attr;
					break;
					case "randomImages":
						if (attr == "true" || attr == "false") __root.randomImages = stringToBoolean(attr);
					break;
					case "pauseOnMouseOver":
						if (attr == "true" || attr == "false") __root.pauseOnMouseOver = stringToBoolean(attr);
					break;
					case "repeatMode":
						if (attr == "true" || attr == "false") __root.repeatMode = stringToBoolean(attr);
					break;
					
					// *** Transitions properties
					case "imageTransitionType":
						if (attr != "") __root.imageTransitionType = attr;
					break;
					case "imageTransitionDuration":
						if (Number(attr) >= 0 && attr != "") __root.imageTransitionDuration = attr;
						if (attr > 5) __root.imageTransitionDuration = 5;
					break;
					case "imageExposureDelay":
						if (Number(attr) >= 0 && attr != "") __root.imageExposureDelay = Number(attr)<=0?0.001:attr;
						if (attr > 5) __root.imageExposureDelay = 5;
					break;
					case "imageExposureStrength":
						if (Number(attr) >= 1 && attr != "") {
							__root.imageExposureStrength = attr;
							__root.imgExpStrength = attr;
							if (attr == 1) __root.imageExposureStrength = 1.001;
							if (attr > 5) __root.imageExposureStrength = 5;
						}
					break;
					case "randomImageTransitions":
						if (attr == "true" || attr == "false") __root.randomImageTransitions = stringToBoolean(attr);
					break;
					case "squareSize":
						if (Number(attr) > 0) __root.squareSize = attr;
					break;
					
					// *** Image area properties
					case "imageAreaWidth":
						if (Number(attr) > 0) __root.imageAreaWidth = Number(attr)>__root.bannerWidth?__root.bannerWidth:attr;
					break;
					case "imageAreaHeight":
						if (Number(attr) > 0) __root.imageAreaHeight = Number(attr)>__root.bannerHeight?__root.bannerHeight:attr;
					break;
					case "imageAreaCornerRadius":
						if (Number(attr) >= 0 && attr != "") __root.imageAreaCornerRadius = attr;
					break;
					case "imageAreaXPosition":
						if (Number(attr) >= 0 && attr != "") __root.imageAreaXPosition = attr;
					break;
					case "imageAreaYPosition":
						if (Number(attr) >= 0 && attr != "") __root.imageAreaYPosition = attr;
					break;
					
					// *** Caption text properties
					case "captionTextShadowColor":
						if (attr != "") __root.captionTextShadowColor = Number("0x" + attr);
					break;
					case "captionTextShadowAlpha":
						if (Number(attr) >= 0 && attr != "") __root.captionTextShadowAlpha = attr;
					break;
					
					// *** Controls properties
					case "showControls":
						if (attr == "true" || attr == "false") __root.showControls = stringToBoolean(attr);
					break;
					case "controlsType":
						if (attr == "1" || attr == "2") __root.controlsType = attr;
					break;
					case "controlsPosition":
						if (attr == "left" || attr == "center" || attr == "right") __root.controlsPosition = attr;
					break;
					case "controlsXOffset":
						if (Number(attr) >= 0 && attr != "") __root.controlsXOffset = attr;
					break;
					case "controlsYOffset":
						if (Number(attr) >= 0 && attr != "") __root.controlsYOffset = attr;
					break;
					case "controlsAutoHide":
						if (attr == "true" || attr == "false") __root.controlsAutoHide = stringToBoolean(attr);
					break;
					case "buttonSpacing":
						if (Number(attr) >= 0 && attr != "") __root.buttonSpacing = attr;
					break;
					case "buttonBgColor":
						if (attr != "") __root.buttonBgColor = Number("0x" + attr);
					break;
					case "buttonOverBgColor":
						if (attr != "") __root.buttonOverBgColor = Number("0x" + attr);
					break;
					case "buttonSelectedBgColor":
						if (attr != "") __root.buttonSelectedBgColor = Number("0x" + attr);
					break;
					case "showButtonShadow":
						if (attr == "true" || attr == "false") __root.showButtonShadow = stringToBoolean(attr);
					break;
					case "buttonShadowColor":
						if (attr != "") __root.buttonShadowColor = Number("0x" + attr);
					break;
					case "showPlayPauseButton":
						if (attr == "true" || attr == "false") __root.showPlayPauseButton = stringToBoolean(attr);
					break;
					case "playPauseIconColor":
						if (attr != "") __root.playPauseIconColor = Number("0x" + attr);
					break;
					case "playPauseIconOverColor":
						if (attr != "") __root.playPauseIconOverColor = Number("0x" + attr);
					break;
					
					// *** Timer properties
					case "showTimer":
						if (attr == "true" || attr == "false") __root.showTimer = stringToBoolean(attr);
					break;
					case "timerBarPosition":
						if (attr == "top" || attr == "bottom") __root.timerBarPosition = attr;
					break;
					case "timerBarHeight":
						if (Number(attr) > 0) __root.timerBarHeight = attr;
					break;
					case "timerBarColor":
						if (attr != "") __root.timerBarColor = Number("0x" + attr);
					break;
					case "timerBarAlpha":
						if (Number(attr) >= 0 && attr != "") __root.timerBarAlpha = attr;
					break;
					
					// *** Preloader properties
					case "showPreloader":
						if (attr == "true" || attr == "false") __root.showPreloader = stringToBoolean(attr);
					break;
					case "preloaderColor":
						if (attr != "") __root.preloaderColor = Number("0x" + attr);
					break;
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Parses the elements of the "banners" node.
	
		public function bannersNodeParser(node:XMLList):Array {
			
			imagesArray = new Array();
			var a:uint = 0;
			var b:uint;
			for each (var aChild:XML in node.*) {
				if (aChild.hasComplexContent()) {
					a++; b=0;
					var bannerObject:Object = new Object();
					var captionArray:Array = new Array();
					// *** Processing "banner" node
					for each (var bChild:XML in aChild.*) {
						if (bChild.name() == "image") {
							bannerObject.src = bChild.@src;
							if (bChild.@link != undefined && bChild.@link != "") bannerObject.link = bChild.@link;
							if (bChild.@target != undefined && bChild.@target != "") bannerObject.target = bChild.@target;
							if (bChild.@showTime != undefined && bChild.@showTime != "" && !isNaN(Number(bChild.@showTime))) {
								bannerObject.showTime = Number(bChild.@showTime);
								if (bannerObject.showTime <= 0) bannerObject.showTime = 0.001;
							}
							if (bChild.@transitionType != undefined && bChild.@transitionType != "") {
								if (__root.checkTransition(bChild.@transitionType)) bannerObject.transitionType = bChild.@transitionType;
							}
							if (__root.img.getChildByName("container"+a) == null) {
								var container_mc:Sprite = new Sprite();
								container_mc.name = "container"+a;
								__root.img.addChild(container_mc);
								bannerObject.container_mc = container_mc;
								var mask_mc:Shape = new Shape();
								mask_mc.name = "mask"+a;
								__root.img.addChild(mask_mc);
								bannerObject.mask_mc = mask_mc;
								container_mc.mask = mask_mc;
							}
						}
						if (bChild.name() == "textblock" && bChild.hasComplexContent()) {
							var hasText:Boolean = false;
							var textblockObject:Object = new Object();
							if (!isNaN(Number(bChild.@xPos)) && Number(bChild.@xPos) >= 0) textblockObject.xPos = int(bChild.@xPos);
							else textblockObject.xPos = 0;
							if (!isNaN(Number(bChild.@yPos)) && Number(bChild.@yPos) >= 0) textblockObject.yPos = int(bChild.@yPos);
							else textblockObject.yPos = 0;
							if (!isNaN(Number(bChild.@width)) && Number(bChild.@width) > 0) textblockObject.width = uint(bChild.@width);
							if (!isNaN(Number(bChild.@height)) && Number(bChild.@height) > 0) textblockObject.height = uint(bChild.@height);
							if (!isNaN(Number(bChild.@startDelay)) && Number(bChild.@startDelay) >= 0) textblockObject.startDelay = Number(bChild.@startDelay);
							else textblockObject.startDelay = 0;
							if (!isNaN(Number(bChild.@showTime)) && Number(bChild.@showTime) > 0) textblockObject.showTime = Number(bChild.@showTime);
							if (bChild.@bgColor != undefined && bChild.@bgColor != "") textblockObject.bgColor = Number("0x" + bChild.@bgColor);							
							if (bChild.@bgGradientAngle != undefined && bChild.@bgGradientAngle != "" && !isNaN(Number(bChild.@bgGradientAngle))) textblockObject.bgGradientAngle = Number(bChild.@bgGradientAngle);
							if (!isNaN(Number(bChild.@bgAlpha)) && Number(bChild.@bgAlpha) >= 0) textblockObject.bgAlpha = Number(bChild.@bgAlpha);
							else textblockObject.bgAlpha = 0;
							if (!isNaN(Number(bChild.@bgCornerRadius)) && Number(bChild.@bgCornerRadius) >= 0) textblockObject.bgCornerRadius = uint(bChild.@bgCornerRadius);
							else textblockObject.bgCornerRadius = 0;
							if (!isNaN(Number(bChild.@textPadding)) && Number(bChild.@textPadding) >= 0) textblockObject.textPadding = uint(bChild.@textPadding);
							else textblockObject.textPadding = 0;
							if (bChild.@textAlpha != undefined && bChild.@textAlpha != "" && !isNaN(Number(bChild.@textAlpha))) textblockObject.textAlpha = Number(bChild.@textAlpha);
							if (bChild.@shadow == "true") textblockObject.shadow = true;
							else textblockObject.shadow = false;
							for each (var cChild:XML in bChild.*) {
								if (cChild.name() == "start_animation") {
									if (cChild.@type != undefined && cChild.@type != "") {
										if (__root.checkAnimation(cChild.@type, "start")) textblockObject.startAnimType = cChild.@type;
									}
									if (!isNaN(Number(cChild.@duration)) && Number(cChild.@duration) > 0) textblockObject.startAnimDuration = Number(cChild.@duration);
									else textblockObject.startAnimDuration = 0.001;
									if (!isNaN(Number(cChild.@exposureStrength)) && Number(cChild.@exposureStrength) > 0) {
										textblockObject.startAnimExpStrength = Number(cChild.@exposureStrength);
										if (textblockObject.startAnimExpStrength < 1) textblockObject.startAnimExpStrength = 1;
										if (textblockObject.startAnimExpStrength > 5) textblockObject.startAnimExpStrength = 5;
									}
									if (cChild.@moveFrom == "left" || cChild.@moveFrom == "right" || cChild.@moveFrom == "top" || cChild.@moveFrom == "bottom" || cChild.@moveFrom == "foreground" || cChild.@moveFrom == "background") textblockObject.startAnimDirection = cChild.@moveFrom;
									if (!isNaN(Number(cChild.@moveOffset)) && Number(cChild.@moveOffset) >= 0) textblockObject.startAnimOffset = uint(cChild.@moveOffset);
									else textblockObject.startAnimOffset = 0;
									if (cChild.@blur == "true") textblockObject.startAnimBlur = true;
									else textblockObject.startAnimBlur = false;
								}
								if (cChild.name() == "end_animation") {
									if (cChild.@type != undefined && cChild.@type != "") {
										if (__root.checkAnimation(cChild.@type, "end")) textblockObject.endAnimType = cChild.@type;
									}
									if (!isNaN(Number(cChild.@duration)) && Number(cChild.@duration) > 0) textblockObject.endAnimDuration = Number(cChild.@duration);
									else textblockObject.endAnimDuration = 0.001;
									if (!isNaN(Number(cChild.@exposureStrength)) && Number(cChild.@exposureStrength) > 0) {
										textblockObject.endAnimExpStrength = Number(cChild.@exposureStrength);
										if (textblockObject.endAnimExpStrength < 1) textblockObject.endAnimExpStrength = 1;
										if (textblockObject.endAnimExpStrength > 5) textblockObject.endAnimExpStrength = 5;
									}
									if (cChild.@moveTo == "left" || cChild.@moveTo == "right" || cChild.@moveTo == "top" || cChild.@moveTo == "bottom" || cChild.@moveTo == "foreground" || cChild.@moveTo == "background") textblockObject.endAnimDirection = cChild.@moveTo;
									if (!isNaN(Number(cChild.@moveOffset)) && Number(cChild.@moveOffset) >= 0) textblockObject.endAnimOffset = uint(cChild.@moveOffset);
									else textblockObject.endAnimOffset = 0;
									if (cChild.@blur == "true") textblockObject.endAnimBlur = true;
									else textblockObject.endAnimBlur = false;
								}
								if (cChild.name() == "text" && cChild.text() != "" && cChild.text() != undefined) {
									b++; hasText = true;
									textblockObject.text = cChild.text();
								}
							}
							if (hasText) captionArray.push(textblockObject);
						}
					}
					bannerObject.caption = captionArray;
					bannerObject.imgTweens = new Array();
					imagesArray.push(bannerObject);
				}
			}
			return imagesArray;
		}
		
	/****************************************************************************************************/
	//	Function. Transforms "true" or "false" values from String to Boolean type.
	
		private function stringToBoolean(str:String):Boolean {
			var result:Boolean;
			if (str == "false") result = false;
			if (str == "true") result = true;
			return result;
		}
	}
}