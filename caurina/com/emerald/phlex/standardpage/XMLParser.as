/**
	XMLParser class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.standardpage {

	public class XMLParser {
		
		private var __root:*;
		private var blocksArray:Array;
	
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
					
					// *** Image properties
					case "imageBgColor":
						if (attr != "") __root.imageBgColor = __root.videoPlayerBgColor = Number("0x" + attr);
					break;
					case "imageBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.imageBgAlpha = __root.videoPlayerBgAlpha = attr;
					break;
					case "imageBorderColor":
						if (attr != "") __root.imageBorderColor = Number("0x" + attr);
					break;
					case "imageBorderThickness":
						if (Number(attr) >= 0 && attr != "") __root.imageBorderThickness = attr;
					break;
					case "imageShadowColor":
						if (attr != "") __root.imageShadowColor = Number("0x" + attr);
					break;
					case "imageShadowAlpha":
						if (Number(attr) >= 0 && attr != "") __root.imageShadowAlpha = attr;
					break;
					case "imagePadding":
						if (Number(attr) >= 0 && attr != "") __root.imagePadding = attr;
					break;
					case "imagePreloaderColor":
						if (attr != "") __root.imagePreloaderColor = __root.videoPlayerPreloaderColor = Number("0x" + attr);
					break;
					case "imagePreloaderAlpha":
						if (Number(attr) >= 0 && attr != "") __root.imagePreloaderAlpha = __root.videoPlayerPreloaderAlpha = attr;
					break;
					case "imageCaptionBgColor":
						if (attr != "") __root.imageCaptionBgColor = Number("0x" + attr);
					break;
					case "imageCaptionBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.imageCaptionBgAlpha = attr;
					break;
					case "imageCaptionBlurredBg":
						if (attr == "true" || attr == "false") __root.imageCaptionBlurredBg = stringToBoolean(attr);
					break;
					case "imageCaptionBgBlurAmount":
						if (Number(attr) >= 0 && attr != "") __root.imageCaptionBgBlurAmount = attr;
					break;
					case "imageCaptionPadding":
						if (Number(attr) >= 0 && attr != "") __root.imageCaptionPadding = attr;
					break;
					case "imageOverBrightness":
						if (!isNaN(attr)) __root.imageOverBrightness = attr;
					break;
					case "imageZoomIconColor":
						if (attr != "") __root.imageZoomIconColor = Number("0x" + attr);
					break;
					case "imageZoomIconAlpha":
						if (Number(attr) >= 0 && attr != "") __root.imageZoomIconAlpha = attr;
					break;
					case "imageZoomIconOverAlpha":
						if (Number(attr) >= 0 && attr != "") __root.imageZoomIconOverAlpha = attr;
					break;
					
					// *** Single item view properties
					case "overlayBgColor":
						if (attr != "") __root.overlayBgColor = Number("0x" + attr);
					break;
					case "overlayBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.overlayBgAlpha = attr;
					break;
					case "controlsBarBgColor":
						if (attr != "") __root.controlsBarBgColor = Number("0x" + attr);
					break;
					case "controlsBarBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.controlsBarBgAlpha = attr;
					break;
					case "buttonIconColor":
						if (attr != "") __root.buttonIconColor = Number("0x" + attr);
					break;
					case "buttonIconOverColor":
						if (attr != "") __root.buttonIconOverColor = Number("0x" + attr);
					break;
					case "buttonBgColor":
						if (attr != "") __root.buttonBgColor = Number("0x" + attr);
					break;
					case "buttonBgOverColor":
						if (attr != "") __root.buttonBgOverColor = Number("0x" + attr);
					break;
					
					// *** Video properties
					case "videoPlayerShadowColor":
						if (attr != "") __root.videoPlayerShadowColor = Number("0x" + attr);
					break;
					case "videoPlayerShadowAlpha":
						if (Number(attr) >= 0 && attr != "") __root.videoPlayerShadowAlpha = attr;
					break;
					case "videoBufferTime":
						if (Number(attr) > 0) __root.videoBufferTime = attr;
					break;
					case "videoSoundVolume":
						if (Number(attr) >= 0 && Number(attr) <= 1 && attr != "") __root.videoSoundVolume = attr;
					break;
					case "showVideoControls":
						if (attr == "true" || attr == "false") __root.showVideoControls = stringToBoolean(attr);
					break;
					case "videoControlsAutoHide":
						if (attr == "true" || attr == "false") __root.videoControlsAutoHide = stringToBoolean(attr);
					break;
					case "videoControlsAutoHideDelay":
						if (Number(attr) >= 0 && attr != "") __root.videoControlsAutoHideDelay = attr;
					break;
					case "videoControlsBgColor":
						if (attr != "") __root.videoControlsBgColor = Number("0x" + attr);
					break;
					case "videoControlsSeparatorColor":
						if (attr != "") __root.videoControlsSeparatorColor = Number("0x" + attr);
					break;
					case "videoControlsButtonColor":
						if (attr != "") __root.videoControlsButtonColor = Number("0x" + attr);
					break;
					case "videoControlsButtonOverColor":
						if (attr != "") __root.videoControlsButtonOverColor = Number("0x" + attr);
					break;
					case "soundVolumeBarFillColor":
						if (attr != "") __root.soundVolumeBarFillColor = Number("0x" + attr);
					break;
					case "soundVolumeBarBgColor":
						if (attr != "") __root.soundVolumeBarBgColor = Number("0x" + attr);
					break;
					case "timelineBgColor":
						if (attr != "") __root.timelineBgColor = Number("0x" + attr);
					break;
					case "timelineSeekBarColor":
						if (attr != "") __root.timelineSeekBarColor = Number("0x" + attr);
					break;
					case "timelinePlayBarColor":
						if (attr != "") __root.timelinePlayBarColor = Number("0x" + attr);
					break;
					case "screenPlayButtonSize":
						if (Number(attr) >= 0 && attr != "") __root.screenPlayButtonSize = attr;
					break;
					case "screenPlayButtonIconColor":
						if (attr != "") __root.screenPlayButtonIconColor = Number("0x" + attr);
					break;
					case "screenPlayButtonBgColor":
						if (attr != "") __root.screenPlayButtonBgColor = Number("0x" + attr);
					break;
					case "screenPlayButtonAlpha":
						if (Number(attr) >= 0 && attr != "") __root.screenPlayButtonAlpha = attr;
					break;
					
					// *** List properties
					case "listItemMarkerURL":
						if (attr != "") __root.listItemMarkerURL = attr;
					break;
					case "listItemMarkerTopPadding":
						if (Number(attr) >= 0 && attr != "") __root.listItemMarkerTopPadding = attr;
					break;
					case "listItemLeftPadding":
						if (Number(attr) >= 0 && attr != "") __root.listItemLeftPadding = attr;
					break;
					case "listItemBottomPadding":
						if (Number(attr) >= 0 && attr != "") __root.listItemBottomPadding = attr;
					break;
					
					// *** Scroll bar properties
					case "scrollBarTrackWidth":
						if (Number(attr) >= 0 && attr != "") __root.scrollBarTrackWidth = attr;
					break;
					case "scrollBarTrackColor":
						if (attr != "") __root.scrollBarTrackColor = Number("0x" + attr);
					break;
					case "scrollBarTrackAlpha":
						if (Number(attr) >= 0 && attr != "") __root.scrollBarTrackAlpha = attr;
						if (__root.scrollBarTrackAlpha == 0) __root.scrollBarTrackAlpha = 0.01;
					break;
					case "scrollBarSliderOverWidth":
						if (Number(attr) >= 0 && attr != "") __root.scrollBarSliderOverWidth = attr;
						if (__root.scrollBarSliderOverWidth == 0 || isNaN(__root.scrollBarSliderOverWidth)) {
							__root.scrollBarSliderOverWidth = __root.scrollBarTrackWidth;
						}
					break;
					case "scrollBarSliderColor":
						if (attr != "") __root.scrollBarSliderColor = Number("0x" + attr);
					break;
					case "scrollBarSliderOverColor":
						if (attr != "") __root.scrollBarSliderOverColor = Number("0x" + attr);
 						if (isNaN(__root.scrollBarSliderOverColor)) __root.scrollBarSliderOverColor = __root.scrollBarSliderColor;
					break;
					
					// *** Slideshow properties
					case "useSlideshow":
						if (attr == "true" || attr == "false") __root.useSlideshow = stringToBoolean(attr);
					break;
					case "slideshowLeftMargin":
						if (Number(attr) >= 0 && attr != "") __root.slideshowLeftMargin = attr;
					break;
					case "slideshowTopMargin":
						if (Number(attr) >= 0 && attr != "") __root.slideshowTopMargin = attr;
					break;
					case "slideshowHeight":
						if (Number(attr) >= 0 && attr != "") __root.slideshowHeight = attr;
					break;
					case "slideshowXML":
						if (attr != "") __root.slideshowXML = attr;
					break;
				}
			}
		}
	/****************************************************************************************************/
	//	Function. Parses the elements of the "content" node.
	
		public function contentNodeParser(node:XMLList):Array {
			blocksArray = new Array();
			var a:uint = 0;
			var b:uint;
			for each (var aChild:XML in node.*) {
				if (aChild.name() == "textblock") textBlockParser(aChild);
				if (aChild.name() == "imageblock") imageBlockParser(aChild);
				if (aChild.name() == "videoblock") videoBlockParser(aChild);
				if (aChild.name() == "list") listParser(aChild);
				if (aChild.name() == "link") linkParser(aChild);
				if (aChild.name() == "separator") separatorParser(aChild);
				if (aChild.name() == "table") tableParser(aChild);
				if (aChild.name() == "cols") {
					if (aChild.hasComplexContent()) {
						a++;
						b = 0;
						for each (var bChild:XML in aChild.*) {
							if (bChild.name() == "col") {
								if (bChild.hasComplexContent()) {
									b++;
									for each (var cChild:XML in bChild.*) {
										if (cChild.name() == "textblock") textBlockParser(cChild, a, b);
										if (cChild.name() == "imageblock") imageBlockParser(cChild, a, b);
										if (cChild.name() == "videoblock") videoBlockParser(cChild, a, b);
										if (cChild.name() == "list") listParser(cChild, a, b);
										if (cChild.name() == "link") linkParser(cChild, a, b);
										if (cChild.name() == "separator") separatorParser(cChild, a, b);
										if (cChild.name() == "table") tableParser(cChild, a, b);
									}
								}
							}
						}
					}
				}
			}
			if (Number(node.@topMargin) >= 0) __root.contentTopMargin = node.@topMargin;
			return blocksArray;
		}
	
	/****************************************************************************************************/
	//	Function. Parses a text block.
	
		private function textBlockParser(node:XML, cols:uint = 0, col:uint = 0):void {
			var blockObject:Object = new Object();
			blockObject.type = "text";
			if (cols) blockObject.cols = cols;
			if (col) blockObject.col = col;
			if (Number(node.@width) > 0) blockObject.width = uint(node.@width);
			if (Number(node.@height) > 0) blockObject.height = uint(node.@height);
			if (Number(node.@topMargin) > 0) blockObject.topMargin = uint(node.@topMargin);
			else blockObject.topMargin = 0;
			if (Number(node.@leftMargin) > 0) blockObject.leftMargin = uint(node.@leftMargin);
			else blockObject.leftMargin = 0;
			if (node.text.text() != "" && node.text.text() != undefined) blockObject.text = node.text.text();
			blocksArray.push(blockObject);
		}
		
	/****************************************************************************************************/
	//	Function. Parses an image block.
	
		private function imageBlockParser(node:XML, cols:uint = 0, col:uint = 0):void {
			var blockObject:Object = new Object();
			blockObject.type = "image";
			if (cols) blockObject.cols = cols;
			if (col) blockObject.col = col;
			if (Number(node.@topMargin) > 0) blockObject.topMargin = uint(node.@topMargin);
			else blockObject.topMargin = 0;
			if (Number(node.@leftMargin) > 0) blockObject.leftMargin = uint(node.@leftMargin);
			else blockObject.leftMargin = 0;
			if (node.caption.text() != "" && node.caption.text() != undefined) blockObject.caption = node.caption.text();
			if (node.image.@src != "" && node.image.@src != undefined) blockObject.imgSrc = node.image.@src;
			if (Number(node.image.@width) > 0) blockObject.imgWidth = uint(node.image.@width);
			else if (node.image.@width == "" || node.image.@width == undefined) blockObject.imgWidth = 150;
			if (Number(node.image.@height) > 0) blockObject.imgHeight = uint(node.image.@height);
			else if (node.image.@height == "" || node.image.@height == undefined) blockObject.imgHeight = 100;
			if (node.image.@clickLink != "" && node.image.@clickLink != undefined) blockObject.clickLink = node.image.@clickLink;
			if (node.image.@clickTarget != "" && node.image.@clickTarget != undefined) blockObject.clickTarget = node.image.@clickTarget;
			if (blockObject.imgWidth != undefined && blockObject.imgHeight != undefined) blocksArray.push(blockObject);
		}
		
	/****************************************************************************************************/
	//	Function. Parses a video block.
	
		private function videoBlockParser(node:XML, cols:uint = 0, col:uint = 0):void {
			var blockObject:Object = new Object();
			if (cols) blockObject.cols = cols;
			if (col) blockObject.col = col;
			if (Number(node.@topMargin) > 0) blockObject.topMargin = uint(node.@topMargin);
			else blockObject.topMargin = 0;
			if (Number(node.@leftMargin) > 0) blockObject.leftMargin = uint(node.@leftMargin);
			else blockObject.leftMargin = 0;
			if (node.video.@youTubeMode == "true") blockObject.type = "youtube";
			else blockObject.type = "video";
			if (node.video.@src != "" && node.video.@src != undefined) blockObject.videoSrc = node.video.@src;
			if (Number(node.video.@width) > 0) blockObject.videoWidth = uint(node.video.@width);
			else if (node.video.@width == "" || node.video.@width == undefined) blockObject.videoWidth = 320;
			if (Number(node.video.@height) > 0) blockObject.videoHeight = uint(node.video.@height);
			else if (node.video.@height == "" || node.video.@height == undefined) blockObject.videoHeight = 180;
			if (node.video.@previewImage != "" && node.video.@previewImage != undefined) blockObject.previewImage = node.video.@previewImage;
			if (node.video.@playbackQuality != "" && node.video.@playbackQuality != undefined) blockObject.playbackQuality = node.video.@playbackQuality;
			else blockObject.playbackQuality = "default";
			if (node.video.@autoPlay == "false") blockObject.autoPlay = false;
			else blockObject.autoPlay = true;
			if (blockObject.videoWidth != undefined && blockObject.videoHeight != undefined) blocksArray.push(blockObject);
		}

	/****************************************************************************************************/
	//	Function. Parses a list block.
	
		private function listParser(node:XML, cols:uint = 0, col:uint = 0):void {
			var blockObject:Object = new Object();
			var itemsArray:Array = new Array();
			blockObject.type = "list";
			if (cols) blockObject.cols = cols;
			if (col) blockObject.col = col;
			if (Number(node.@width) > 0) blockObject.width = uint(node.@width);
			if (Number(node.@topMargin) > 0) blockObject.topMargin = uint(node.@topMargin);
			else blockObject.topMargin = 0;
			if (Number(node.@leftMargin) > 0) blockObject.leftMargin = uint(node.@leftMargin);
			else blockObject.leftMargin = 0;
			if (node.@markerColor != "") blockObject.markerColor = Number("0x" + node.@markerColor);
			for each (var aChild:XML in node.*) {
				if (aChild.name() == "item" && aChild.text() != "" && aChild.text() != undefined) itemsArray.push(aChild.text());
			}
			blockObject.items = itemsArray;
			blocksArray.push(blockObject);
		}
		
	/****************************************************************************************************/
	//	Function. Parses a link block.
	
		private function linkParser(node:XML, cols:uint = 0, col:uint = 0):void {
			var blockObject:Object = new Object();
			blockObject.type = "link";
			if (cols) blockObject.cols = cols;
			if (col) blockObject.col = col;
			if (Number(node.@topMargin) > 0) blockObject.topMargin = uint(node.@topMargin);
			else blockObject.topMargin = 0;
			if (Number(node.@leftMargin) > 0) blockObject.leftMargin = uint(node.@leftMargin);
			else blockObject.leftMargin = 0;
			if (node.@color != "") blockObject.color = Number("0x" + node.@color);
			if (node.@hoverColor != "") blockObject.hoverColor = Number("0x" + node.@hoverColor);
			if (node.@iconURL != "" && node.@iconURL != undefined) blockObject.iconURL = node.@iconURL;
			if (Number(node.@iconTopPadding) > 0) blockObject.iconTopPadding = uint(node.@iconTopPadding);
			else blockObject.iconTopPadding = 0;
			if (Number(node.@leftPadding) > 0) blockObject.leftPadding = uint(node.@leftPadding);
			else blockObject.leftPadding = 0;
			if (Number(node.@rightPadding) > 0) blockObject.rightPadding = uint(node.@rightPadding);
			else blockObject.rightPadding = 0;
			if (blockObject.rightPadding > 0 && blockObject.leftPadding == 0) blockObject.align = "left";
			else blockObject.align = "right";
			if (node.@clickLink != "" && node.@clickLink != undefined) blockObject.clickLink = node.@clickLink;
			if (node.@clickTarget != "" && node.@clickTarget != undefined) blockObject.clickTarget = node.@clickTarget;
			if (node.text() != "" && node.text() != undefined) blockObject.text = node.text();
			blocksArray.push(blockObject);
		}
		
	/****************************************************************************************************/
	//	Function. Parses a separator block.
	
		private function separatorParser(node:XML, cols:uint = 0, col:uint = 0):void {
			var blockObject:Object = new Object();
			blockObject.type = "separator";
			if (cols) blockObject.cols = cols;
			if (col) blockObject.col = col;
			if (Number(node.@width) > 0) blockObject.width = uint(node.@width);
			if (Number(node.@height) > 0) blockObject.height = uint(node.@height);
			else if (node.@height == "" || node.@height == undefined) blockObject.height = 1;
			if (Number(node.@topMargin) > 0) blockObject.topMargin = uint(node.@topMargin);
			else blockObject.topMargin = 0;
			if (Number(node.@leftMargin) > 0) blockObject.leftMargin = uint(node.@leftMargin);
			else blockObject.leftMargin = 0;
			if (node.@color != "") blockObject.color = Number("0x" + node.@color);
			if (node.@iconURL != "" && node.@iconURL != undefined) blockObject.iconURL = node.@iconURL;
			blocksArray.push(blockObject);
		}
		
	/****************************************************************************************************/
	//	Function. Parses a table.
	
		private function tableParser(node:XML, cols:uint = 0, col:uint = 0):void {
			var blockObject:Object = new Object();
			var cellsArray:Array = new Array();
			blockObject.type = "table";
			if (cols) blockObject.cols = cols;
			if (col) blockObject.col = col;
			if (Number(node.@topMargin) > 0) blockObject.topMargin = uint(node.@topMargin);
			else blockObject.topMargin = 0;
			if (Number(node.@leftMargin) > 0) blockObject.leftMargin = uint(node.@leftMargin);
			else blockObject.leftMargin = 0;
			if (node.@borderColor != "") blockObject.borderColor = Number("0x" + node.@borderColor);
			if (Number(node.@borderThickness) > 0) blockObject.borderThickness = uint(node.@borderThickness);
			else blockObject.borderThickness = 0;
			
			var row:uint = 0;
			var col:uint;
			var row_height:uint, col_width:uint;
			var cellObject:Object;
			var wArray:Array = new Array();
			for each (var aChild:XML in node.*) {
				row_height = 40;
				if (aChild.name() == "tr" && aChild.hasComplexContent()) {
					row++;
					col = 0;
					if (Number(aChild.@height) > 0) row_height = uint(aChild.@height);
					for each (var bChild:XML in aChild.*) {
						cellObject = new Object();
						col_width = 200;
						if (bChild.name() == "td" || bChild.name() == "th") {
							col++;
							if (Number(bChild.@width) > 0) col_width = uint(bChild.@width);
							if (row == 1) {
								wArray.push(col_width);
								cellObject.width = col_width;
							} else {
								cellObject.width = wArray[col-1];
							}
							cellObject.row = row;
							cellObject.col = col;
							cellObject.height = row_height;
							if (bChild.@bgcolor != "") cellObject.bgcolor = Number("0x" + bChild.@bgcolor);
							if (bChild.@align == "left") cellObject.align = bChild.@align;
							cellObject.text = bChild.text();
							cellsArray.push(cellObject);
						}
					}
				}
			}
			blockObject.cells = cellsArray;
			blockObject.colsNum = wArray.length;
			blocksArray.push(blockObject);
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