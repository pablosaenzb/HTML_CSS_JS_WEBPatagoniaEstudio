/**
	XMLParser class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.team {

	public class XMLParser {
		
		private var __root:*;
		private var teamArray:Array;
	
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
					case "controlsYPosition":
						if (Number(attr) >= -15 && attr != "") __root.controlsYPosition = attr;
					break;
					case "controlsRightMargin":
						if (Number(attr) >= 0 && attr != "") __root.controlsRightMargin = attr;
					break;
					case "navButtonColor":
						if (attr != "") __root.navButtonColor = Number("0x" + attr);
					break;
					case "navButtonSelectedColor":
						if (attr != "") __root.navButtonSelectedColor = Number("0x" + attr);
					break;
					
					// *** Items properties
					case "itemsInRow":
						if (Number(attr) >= 0 && attr != "") __root.itemsInRow = attr;
						if (__root.itemsInRow > 8) __root.itemsInRow = 8;
					break;
					case "itemsTopMargin":
						if (Number(attr) >= 0 && attr != "") __root.itemsTopMargin = attr;
					break;
					case "itemsLeftMargin":
						if (Number(attr) >= 0 && attr != "") __root.itemsLeftMargin = attr;
					break;
					case "itemWidth":
						if (Number(attr) > 0) __root.itemWidth = attr;
					break;
					case "itemHeight":
						if (Number(attr) > 0) __root.itemHeight = attr;
					break;
					case "itemHSpacing":
						if (Number(attr) >= 0 && attr != "") __root.itemHSpacing = attr;
					break;
					
					// *** Image properties
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
					
					case "personNameBottomPadding":
						if (Number(attr) >= 0 && attr != "") __root.personNameBottomPadding = attr;
					break;
					case "personPositionBottomPadding":
						if (Number(attr) >= 0 && attr != "") __root.personPositionBottomPadding = attr;
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
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Parses the elements of the "person" node.
	
		public function personNodeParser(node:XML):Array {
			teamArray = new Array();
			for each (var aChild:XML in node.*) {
				if (aChild.name() == "person" && aChild.hasComplexContent()) {
					var personObject:Object = new Object();
					if (aChild.name.text() != "" && aChild.name.text() != undefined) personObject.title = aChild.name.text();
					if (aChild.position.text() != "" && aChild.position.text() != undefined) personObject.position = aChild.position.text();
					if (aChild.image.@src != "" && aChild.image.@src != undefined) personObject.imgSrc = aChild.image.@src;
					if (aChild.image.@clickLink != "" && aChild.image.@clickLink != undefined) personObject.clickLink = aChild.image.@clickLink;
					if (aChild.image.@clickTarget != "" && aChild.image.@clickTarget != undefined) personObject.clickTarget = aChild.image.@clickTarget;
					if (aChild.content.hasComplexContent()) personObject.blocks = contentNodeParser(aChild.content);
					teamArray.push(personObject);
				}
			}
			return teamArray;
		}

	/****************************************************************************************************/
	//	Function. Parses the elements of a "team" -> "content" node.
	
		private function contentNodeParser(node:XMLList):Array {
			var blocksArray:Array = new Array();
			for each (var aChild:XML in node.*) {
				if (aChild.name() == "textblock") textBlockParser(aChild, blocksArray);
				if (aChild.name() == "list") listParser(aChild, blocksArray);
				if (aChild.name() == "link") linkParser(aChild, blocksArray);
			}
			return blocksArray;
		}
	
	/****************************************************************************************************/
	//	Function. Parses a text block.
	
		private function textBlockParser(node:XML, blocksArray:Array):void {
			var blockObject:Object = new Object();
			blockObject.type = "text";
			if (Number(node.@topMargin) > 0) blockObject.topMargin = uint(node.@topMargin);
			else blockObject.topMargin = 0;
			if (Number(node.@leftMargin) > 0) blockObject.leftMargin = uint(node.@leftMargin);
			else blockObject.leftMargin = 0;
			if (node.text.text() != "" && node.text.text() != undefined) blockObject.text = node.text.text();
			blocksArray.push(blockObject);
		}

	/****************************************************************************************************/
	//	Function. Parses a list block.
	
		private function listParser(node:XML, blocksArray:Array):void {
			var blockObject:Object = new Object();
			var itemsArray:Array = new Array();
			blockObject.type = "list";
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
	
		private function linkParser(node:XML, blocksArray:Array):void {
			var blockObject:Object = new Object();
			blockObject.type = "link";
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
	//	Function. Transforms "true" or "false" values from String to Boolean type.
	
		private function stringToBoolean(str:String):Boolean {
			var result:Boolean;
			if (str == "false") result = false;
			if (str == "true") result = true;
			return result;
		}
	}
}