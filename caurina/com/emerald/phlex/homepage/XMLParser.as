/**
	XMLParser class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.homepage {

	public class XMLParser {
		
		private var __root:*;
		private var teasersArray:Array, blocksArray:Array;
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function XMLParser(obj:*):void {
			__root = obj; // a reference to the object of the main class
		}
		
	/****************************************************************************************************/
	//	Function. Parses the attributes and the text of the "slogan" node.
	
		public function sloganNodeParser(node:XMLList):void {
			if (Number(node.@width) > 0) __root.sloganWidth = node.@width;
			if (Number(node.@topMargin) >= 0) __root.sloganTopMargin = node.@topMargin;
			if (Number(node.@leftMargin) >= 0) __root.sloganLeftMargin = node.@leftMargin;
			if (node.text() != "" && node.text() != undefined) __root.sloganText = node.text();
		}
		
	/****************************************************************************************************/
	//	Function. Parses the attributes of the "teasers" -> "settings" node.
	
		public function teasersSettingsNodeParser(node:XMLList):void {
			
			var attr_name:String;
			for each (var attr:* in node.@*) {
				attr_name = attr.name();
				
				switch (attr_name) {
					case "teasersType":
						if (attr == "1" || attr == "2") __root.teasersType = attr;
					break;
					case "teasersVisible":
						if (Number(attr) >= 0 && attr != "") __root.teasersVisible = attr;
					break;
					case "teaserWidth":
						if (Number(attr) > 0) __root.teaserWidth = attr;
					break;
					case "teaserHeight":
						if (Number(attr) > 0) __root.teaserHeight = attr;
					break;
					case "teaserSpacing":
						if (Number(attr) >= 0 && attr != "") __root.teaserSpacing = attr;
					break;
					case "imageBgColor":
						if (attr != "") __root.imageBgColor = Number("0x" + attr);
					break;
					case "imageBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.imageBgAlpha = attr;
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
						if (attr != "") __root.imagePreloaderColor = Number("0x" + attr);
					break;
					case "imagePreloaderAlpha":
						if (Number(attr) >= 0 && attr != "") __root.imagePreloaderAlpha = attr;
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
					case "imageLinkIconAlpha":
						if (Number(attr) >= 0 && attr != "") __root.imageLinkIconAlpha = attr;
					break;
					case "imageLinkIconOverAlpha":
						if (Number(attr) >= 0 && attr != "") __root.imageLinkIconOverAlpha = attr;
					break;
					case "imageBottomMargin":
						if (Number(attr) >= 0 && attr != "") __root.imageBottomMargin = attr;
					break;
					case "titleBottomPadding":
						if (Number(attr) >= 0 && attr != "") __root.titleBottomPadding = attr;
					break;
					case "leftNavButtonURL":
						if (attr != "") __root.leftNavButtonURL = attr;
					break;
					case "rightNavButtonURL":
						if (attr != "") __root.rightNavButtonURL = attr;
					break;
					case "navButtonColor":
						if (attr != "") __root.navButtonColor = Number("0x" + attr);
					break;
					case "navButtonOverColor":
						if (attr != "") __root.navButtonOverColor = Number("0x" + attr);
					break;
					case "navButtonPadding":
						if (Number(attr) >= 0 && attr != "") __root.navButtonPadding = attr;
					break;
				}
				if (__root.teasersType == 2) {
					switch (attr_name) {
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
					}
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Parses the elements of the "teasers" node.
	
		public function teasersNodeParser(node:XMLList):Array {
			teasersArray = new Array();
			for each (var aChild:XML in node.*) {
				if (aChild.hasComplexContent()) {
					if (aChild.name() == "teaser") {
						var teaserObject:Object = new Object();
						if (aChild.image.@src != "" && aChild.image.@src != undefined) teaserObject.imgSrc = aChild.image.@src;
						if (aChild.image.@clickLink != "" && aChild.image.@clickLink != undefined) teaserObject.clickLink = aChild.image.@clickLink;
						if (aChild.image.@clickTarget != "" && aChild.image.@clickTarget != undefined) teaserObject.clickTarget = aChild.image.@clickTarget;
						if (aChild.title.text() != "" && aChild.title.text() != undefined) teaserObject.title = aChild.title.text();
						if (aChild.caption.text() != "" && aChild.caption.text() != undefined) teaserObject.caption = aChild.caption.text();
						if (aChild.link != undefined) {
							blocksArray = new Array();
							linkParser(XML(aChild.link));
							teaserObject.blocks = blocksArray;
						}
						if (teaserObject.imgSrc != undefined || teaserObject.caption != undefined) teasersArray.push(teaserObject);
					}
				}
			}
			if (Number(node.@topMargin) >= 0) __root.teasersTopMargin = node.@topMargin;
			return teasersArray;
		}
		
	/****************************************************************************************************/
	//	Function. Parses the attributes of the "bottomSeparator" node.
	
		public function bottomSeparatorNodeParser(node:XMLList):void {
			if (Number(node.@width) > 0) __root.bottomSeparatorWidth = node.@width;
			if (Number(node.@height) > 0) __root.bottomSeparatorHeight = node.@height;
			if (Number(node.@topMargin) >= 0) __root.bottomSeparatorTopMargin = node.@topMargin;
			if (Number(node.@leftMargin) >= 0) __root.bottomSeparatorLeftMargin = node.@leftMargin;
			if (node.@color != "") __root.bottomSeparatorColor = Number("0x" + node.@color);
			if (node.@iconURL != "" && node.@iconURL != undefined) __root.bottomSeparatorIconURL = node.@iconURL;
		}

	/****************************************************************************************************/
	//	Function. Parses the attributes of the "bottomContent" -> "settings" node.
	
		public function bottomContentSettingsNodeParser(node:XMLList):void {
			
			var attr_name:String;
			for each (var attr:* in node.@*) {
				attr_name = attr.name();
				
				switch (attr_name) {
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
				}
			}
		}

	/****************************************************************************************************/
	//	Function. Parses the elements of the "bottomContent" node.
	
		public function bottomContentNodeParser(node:XMLList):Array {
			blocksArray = new Array();
			var a:uint = 0;
			var b:uint;
			for each (var aChild:XML in node.*) {
				if (aChild.name() == "textblock") textBlockParser(aChild);
				if (aChild.name() == "list") listParser(aChild);
				if (aChild.name() == "link") linkParser(aChild);
				if (aChild.name() == "separator") separatorParser(aChild);
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
										if (cChild.name() == "list") listParser(cChild, a, b);
										if (cChild.name() == "link") linkParser(cChild, a, b);
										if (cChild.name() == "separator") separatorParser(cChild, a, b);
									}
								}
							}
						}
					}
				}
			}
			if (Number(node.@topMargin) >= 0) __root.bottomContentTopMargin = node.@topMargin;
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
	//	Function. Transforms "true" or "false" values from String to Boolean type.
	
		private function stringToBoolean(str:String):Boolean {
			var result:Boolean;
			if (str == "false") result = false;
			if (str == "true") result = true;
			return result;
		}
	}
}