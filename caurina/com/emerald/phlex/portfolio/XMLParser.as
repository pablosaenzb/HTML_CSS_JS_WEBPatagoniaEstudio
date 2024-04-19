/**
	XMLParser class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.portfolio {

	public class XMLParser {
		
		private var __root:*;
		private var categoriesArray:Array, itemsArray:Array;
	
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
					
					// *** Category menu properties
					case "showCategoryMenu":
						if (attr == "true" || attr == "false") __root.showCategoryMenu = stringToBoolean(attr);
					break;
					case "categoryMenuYPosition":
						if (Number(attr) >= 0 && attr != "") __root.categoryMenuYPosition = attr;
					break;
					case "categorySpacing":
						if (Number(attr) >= 0 && attr != "") __root.categorySpacing = attr;
					break;
					case "categoryFont":
						if (attr != "") __root.categoryFont = attr;
					break;
					case "categoryFontSize":
						if (Number(attr) > 0) __root.categoryFontSize = attr;
					break;
					case "categoryFontWeight":
						if (attr == "normal" || attr == "bold") __root.categoryFontWeight = attr;
					break;
					case "categoryFontColor":
						if (attr != "") __root.categoryFontColor = Number("0x" + attr);
					break;
					case "categoryOverFontColor":
						if (attr != "") __root.categoryOverFontColor = Number("0x" + attr);
					break;
					case "categorySelectedFontColor":
						if (attr != "") __root.categorySelectedFontColor = Number("0x" + attr);
					break;
					
					// *** Previews properties
					case "previewsControlsYPosition":
						if (Number(attr) >= -15 && attr != "") __root.previewsControlsYPosition = attr;
					break;
					case "previewsControlsRightMargin":
						if (Number(attr) >= 0 && attr != "") __root.previewsControlsRightMargin = attr;
					break;
					case "previewsNavButtonColor":
						if (attr != "") __root.previewsNavButtonColor = Number("0x" + attr);
					break;
					case "previewsNavButtonSelectedColor":
						if (attr != "") __root.previewsNavButtonSelectedColor = Number("0x" + attr);
					break;
					case "previewsInRow":
						if (Number(attr) >= 0 && attr != "") __root.previewsInRow = attr;
						if (__root.previewsInRow > 8) __root.previewsInRow = 8;
					break;
					case "previewsInCol":
						if (Number(attr) >= 0 && attr != "") __root.previewsInCol = attr;
						if (__root.previewsInCol > 5) __root.previewsInCol = 5;
					break;
					case "previewsTopMargin":
						if (Number(attr) >= 0 && attr != "") __root.previewsTopMargin = attr;
					break;
					case "previewWidth":
						if (Number(attr) > 0) __root.previewWidth = attr;
					break;
					case "previewHeight":
						if (Number(attr) > 0) __root.previewHeight = attr;
					break;
					case "previewSpacing":
						if (Number(attr) >= 0 && attr != "") __root.previewSpacing = attr;
					break;
					case "previewBgColor":
						if (attr != "") __root.previewBgColor = Number("0x" + attr);
					break;
					case "previewBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.previewBgAlpha = attr;
					break;
					case "previewOverBgColor":
						if (attr != "") __root.previewOverBgColor = Number("0x" + attr);
					break;
					case "previewBorderColor":
						if (attr != "") __root.previewBorderColor = Number("0x" + attr);
					break;
					case "previewBorderThickness":
						if (Number(attr) >= 0 && attr != "") __root.previewBorderThickness = attr;
					break;
					case "previewOverBorderColor":
						if (attr != "") __root.previewOverBorderColor = Number("0x" + attr);
					break;
					case "previewShadowColor":
						if (attr != "") __root.previewShadowColor = Number("0x" + attr);
					break;
					case "previewShadowAlpha":
						if (Number(attr) >= 0 && attr != "") __root.previewShadowAlpha = attr;
					break;
					case "previewPadding":
						if (Number(attr) >= 0 && attr != "") __root.previewPadding = attr;
					break;
					case "previewPreloaderColor":
						if (attr != "") __root.previewPreloaderColor = Number("0x" + attr);
					break;
					case "previewPreloaderAlpha":
						if (Number(attr) >= 0 && attr != "") __root.previewPreloaderAlpha = attr;
					break;
					case "previewCaptionFontColor":
						if (attr != "") __root.previewCaptionFontColor = Number("0x" + attr);
					break;
					case "previewCaptionOverFontColor":
						if (attr != "") __root.previewCaptionOverFontColor = Number("0x" + attr);
					break;
					case "previewCaptionBgColor":
						if (attr != "") __root.previewCaptionBgColor = Number("0x" + attr);
					break;
					case "previewCaptionBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.previewCaptionBgAlpha = attr;
					break;
					case "previewCaptionOverBgColor":
						if (attr != "") __root.previewCaptionOverBgColor = Number("0x" + attr);
					break;
					case "previewCaptionOverBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.previewCaptionOverBgAlpha = attr;
					break;
					case "previewCaptionBlurredBg":
						if (attr == "true" || attr == "false") __root.previewCaptionBlurredBg = stringToBoolean(attr);
					break;
					case "previewCaptionBgBlurAmount":
						if (Number(attr) >= 0 && attr != "") __root.previewCaptionBgBlurAmount = attr;
					break;
					case "previewCaptionTopBottomPadding":
						if (Number(attr) >= 0 && attr != "") __root.previewCaptionTopBottomPadding = attr;
					break;
					case "previewCaptionLeftRightPadding":
						if (Number(attr) >= 0 && attr != "") __root.previewCaptionLeftRightPadding = attr;
					break;
					case "previewOverBrightness":
						if (!isNaN(attr)) __root.previewOverBrightness = attr;
					break;
					
					// *** Project controls properties
					case "projectAreaYPosition":
						if (Number(attr) >= 0 && attr != "") __root.projectAreaYPosition = attr;
					break;
					case "projectHeaderHeight":
						if (Number(attr) >= 0 && attr != "") __root.projectHeaderHeight = attr;
					break;
					case "projectAlign":
						if (attr == "left" || attr == "center" || attr == "right") __root.projectAlign = attr;
					break;
					case "projectControlsRightMargin":
						if (Number(attr) >= 0 && attr != "") __root.projectControlsRightMargin = attr;
					break;
					case "projectListButtonURL":
						if (attr != "") __root.projectListButtonURL = attr;
					break;
					case "projectLeftNavButtonURL":
						if (attr != "") __root.projectLeftNavButtonURL = attr;
					break;
					case "projectRightNavButtonURL":
						if (attr != "") __root.projectRightNavButtonURL = attr;
					break;
					case "projectNavButtonSpacing":
						if (Number(attr) >= 0 && attr != "") __root.projectNavButtonSpacing = attr;
					break;
					case "projectButtonColor":
						if (attr != "") __root.projectButtonColor = Number("0x" + attr);
					break;
					case "projectButtonOverColor":
						if (attr != "") __root.projectButtonOverColor = Number("0x" + attr);
					break;
					case "projectControlsSeparatorURL":
						if (attr != "") __root.projectControlsSeparatorURL = attr;
					break;
					case "projectControlsSeparatorColor":
						if (attr != "") __root.projectControlsSeparatorColor = Number("0x" + attr);
					break;
					case "projectTitleTopMargin":
						if (Number(attr) >= 0 && attr != "") __root.projectTitleTopMargin = attr;
					break;
					case "projectContentTopMargin":
						if (Number(attr) >= 0 && attr != "") __root.projectContentTopMargin = attr;
					break;
					case "showProjectDescription":
						if (attr == "true" || attr == "false") __root.showProjectDescription = stringToBoolean(attr);
					break;
					
					// *** Project big image properties
					case "bigImageWidth":
						if (Number(attr) > 0) __root.bigImageWidth = attr;
					break;
					case "bigImageHeight":
						if (Number(attr) > 0) __root.bigImageHeight = attr;
					break;
					case "bigImageBgColor":
						if (attr != "") __root.bigImageBgColor = __root.videoPlayerBgColor = Number("0x" + attr);
					break;
					case "bigImageBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.bigImageBgAlpha = __root.videoPlayerBgAlpha = attr;
					break;
					case "bigImageBorderColor":
						if (attr != "") __root.bigImageBorderColor = Number("0x" + attr);
					break;
					case "bigImageBorderThickness":
						if (Number(attr) >= 0 && attr != "") __root.bigImageBorderThickness = attr;
					break;
					case "bigImagePadding":
						if (Number(attr) >= 0 && attr != "") __root.bigImagePadding = attr;
					break;
					case "bigImagePreloaderColor":
						if (attr != "") __root.bigImagePreloaderColor = __root.videoPlayerPreloaderColor = Number("0x" + attr);
					break;
					case "bigImagePreloaderAlpha":
						if (Number(attr) >= 0 && attr != "") __root.bigImagePreloaderAlpha = __root.videoPlayerPreloaderAlpha = attr;
					break;
					case "bigImageCaptionBgColor":
						if (attr != "") __root.bigImageCaptionBgColor = Number("0x" + attr);
					break;
					case "bigImageCaptionBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.bigImageCaptionBgAlpha = attr;
					break;
					case "bigImageCaptionBlurredBg":
						if (attr == "true" || attr == "false") __root.bigImageCaptionBlurredBg = stringToBoolean(attr);
					break;
					case "bigImageCaptionBgBlurAmount":
						if (Number(attr) >= 0 && attr != "") __root.bigImageCaptionBgBlurAmount = attr;
					break;
					case "bigImageCaptionPadding":
						if (Number(attr) >= 0 && attr != "") __root.bigImageCaptionPadding = attr;
					break;
					case "bigImageOverBrightness":
						if (!isNaN(attr)) __root.bigImageOverBrightness = attr;
					break;
					case "bigImageZoomIconColor":
						if (attr != "") __root.bigImageZoomIconColor = Number("0x" + attr);
					break;
					case "bigImageZoomIconAlpha":
						if (Number(attr) >= 0 && attr != "") __root.bigImageZoomIconAlpha = attr;
					break;
					case "bigImageZoomIconOverAlpha":
						if (Number(attr) >= 0 && attr != "") __root.bigImageZoomIconOverAlpha = attr;
					break;
					case "bigImageRightMargin":
						if (Number(attr) >= 0 && attr != "") __root.bigImageRightMargin = attr;
					break;
					
					// *** Project thumbnails properties
					case "thumbnailsVisible":
						if (Number(attr) >= 0 && attr != "") __root.thumbnailsVisible = attr;
					break;
					case "thumbnailsAlign":
						if (attr == "left" || attr == "center" || attr == "right") __root.thumbnailsAlign = attr;
					break;
					case "thumbnailsTopMargin":
						if (Number(attr) >= 0 && attr != "") __root.thumbnailsTopMargin = attr;
					break;
					case "thumbnailWidth":
						if (Number(attr) > 0) __root.thumbnailWidth = attr;
					break;
					case "thumbnailHeight":
						if (Number(attr) > 0) __root.thumbnailHeight = attr;
					break;
					case "thumbnailSpacing":
						if (Number(attr) >= 0 && attr != "") __root.thumbnailSpacing = attr;
					break;
					case "thumbnailBgColor":
						if (attr != "") __root.thumbnailBgColor = Number("0x" + attr);
					break;
					case "thumbnailBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.thumbnailBgAlpha = attr;
					break;
					case "thumbnailBorderColor":
						if (attr != "") __root.thumbnailBorderColor = Number("0x" + attr);
					break;
					case "thumbnailSelectedBorderColor":
						if (attr != "") __root.thumbnailSelectedBorderColor = Number("0x" + attr);
					break;
					case "thumbnailBorderThickness":
						if (Number(attr) >= 0 && attr != "") __root.thumbnailBorderThickness = attr;
					break;
					case "thumbnailShadowColor":
						if (attr != "") __root.thumbnailShadowColor = Number("0x" + attr);
					break;
					case "thumbnailShadowAlpha":
						if (Number(attr) >= 0 && attr != "") __root.thumbnailShadowAlpha = attr;
					break;
					case "thumbnailPreloaderColor":
						if (attr != "") __root.thumbnailPreloaderColor = Number("0x" + attr);
					break;
					case "thumbnailPreloaderAlpha":
						if (Number(attr) >= 0 && attr != "") __root.thumbnailPreloaderAlpha = attr;
					break;
					case "thumbnailOverBrightness":
						if (!isNaN(attr)) __root.thumbnailOverBrightness = attr;
					break;
					case "thumbnailVideoIconSize":
						if (Number(attr) >= 0 && attr != "") __root.thumbnailVideoIconSize = attr;
					break;
					case "thumbnailVideoIconColor":
						if (attr != "") __root.thumbnailVideoIconColor = Number("0x" + attr);
					break;
					case "thumbnailVideoIconAlpha":
						if (Number(attr) >= 0 && attr != "") __root.thumbnailVideoIconAlpha = attr;
					break;
					case "thumbnailVideoIconOverAlpha":
						if (Number(attr) >= 0 && attr != "") __root.thumbnailVideoIconOverAlpha = attr;
					break;
					case "thumbnailsLeftNavButtonURL":
						if (attr != "") __root.thumbnailsLeftNavButtonURL = attr;
					break;
					case "thumbnailsRightNavButtonURL":
						if (attr != "") __root.thumbnailsRightNavButtonURL = attr;
					break;
					case "thumbnailsNavButtonColor":
						if (attr != "") __root.thumbnailsNavButtonColor = Number("0x" + attr);
					break;
					case "thumbnailsNavButtonOverColor":
						if (attr != "") __root.thumbnailsNavButtonOverColor = Number("0x" + attr);
					break;
					case "thumbnailsNavButtonPadding":
						if (Number(attr) >= 0 && attr != "") __root.thumbnailsNavButtonPadding = attr;
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
					
					// *** Project video properties
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
					
					// *** Project description properties
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
	//	Function. Parses the attributes of "category" nodes.
	
		public function categoryNodesParser(node:XML):Array {
			categoriesArray = new Array();
			for each (var aChild:XML in node.*) {
				if (aChild.name() == "category") {
					var categoryObject:Object = new Object();
					if (aChild.@title != "" && aChild.@title != undefined) categoryObject.title = aChild.@title;
					categoriesArray.push(categoryObject);
				}
			}
			return categoriesArray;
		}

	/****************************************************************************************************/
	//	Function. Parses the elements of a "category" node.
	
		public function categoryNodeParser(node:XML):Array {
			itemsArray = new Array();
			for each (var aChild:XML in node.*) {
				if (aChild.name() == "item" && aChild.hasComplexContent()) {
					var itemObject:Object = new Object();
					if (aChild.title.text() != "" && aChild.title.text() != undefined) itemObject.title = aChild.title.text();
					if (aChild.preview.@src != "" && aChild.preview.@src != undefined) itemObject.previewSrc = aChild.preview.@src;
					if (aChild.preview.text() != "" && aChild.preview.text() != undefined) itemObject.previewCaption = aChild.preview.text();
					if (aChild.description.hasComplexContent()) itemObject.descriptionBlocks = descriptionNodeParser(aChild.description);
					if (aChild.media.hasComplexContent()) itemObject.media = mediaNodeParser(aChild.media);
					itemsArray.push(itemObject);
				}
			}
			return itemsArray;
		}

	/****************************************************************************************************/
	//	Function. Parses the elements of an "item" -> "description" node.
	
		private function descriptionNodeParser(node:XMLList):Array {
			var blocksArray:Array = new Array();
			for each (var aChild:XML in node.*) {
				if (aChild.name() == "textblock") textBlockParser(aChild, blocksArray);
				if (aChild.name() == "list") listParser(aChild, blocksArray);
				if (aChild.name() == "link") linkParser(aChild, blocksArray);
				if (aChild.name() == "separator") separatorParser(aChild, blocksArray);
				if (aChild.name() == "table") tableParser(aChild, blocksArray);
			}
			return blocksArray;
		}
		
	/****************************************************************************************************/
	//	Function. Parses the elements of an "item" -> "media" node.
	
		private function mediaNodeParser(node:XMLList):Array {
			var mediaArray:Array = new Array();
			for each (var aChild:XML in node.*) {
				if (aChild.name() == "image") imageParser(aChild, mediaArray);
				if (aChild.name() == "video") videoParser(aChild, mediaArray);
			}
			return mediaArray;
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
	//	Function. Parses a separator block.
	
		private function separatorParser(node:XML, blocksArray:Array):void {
			var blockObject:Object = new Object();
			blockObject.type = "separator";
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
	
		private function tableParser(node:XML, blocksArray:Array):void {
			var blockObject:Object = new Object();
			var cellsArray:Array = new Array();
			blockObject.type = "table";
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
	//	Function. Parses an image element.
	
		private function imageParser(node:XML, mediaArray:Array):void {
			var mediaObject:Object = new Object();
			mediaObject.type = "image";
			if (node.@src != "" && node.@src != undefined) mediaObject.src = node.@src;
			if (node.@tn != "" && node.@tn != undefined) mediaObject.tn = node.@tn;
			if (node.text() != "" && node.text() != undefined) mediaObject.caption = node.text();
			mediaArray.push(mediaObject);
		}
		
	/****************************************************************************************************/
	//	Function. Parses a video element.
	
		private function videoParser(node:XML, mediaArray:Array):void {
			var mediaObject:Object = new Object();
			if (node.@youTubeMode == "true") mediaObject.type = "youtube";
			else mediaObject.type = "video";
			if (node.@src != "" && node.@src != undefined) mediaObject.src = node.@src;
			if (node.@ratio == "16:9") mediaObject.ratio = "16:9";
			else mediaObject.ratio = "4:3";
			if (node.@previewImage != "" && node.@previewImage != undefined) mediaObject.previewImage = node.@previewImage;
			if (node.@tn != "" && node.@tn != undefined) mediaObject.tn = node.@tn;
			if (node.@playbackQuality != "" && node.@playbackQuality != undefined) mediaObject.playbackQuality = node.@playbackQuality;
			else mediaObject.playbackQuality = "default";
			if (node.@autoPlay == "false") mediaObject.autoPlay = false;
			else mediaObject.autoPlay = true;
			mediaArray.push(mediaObject);
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