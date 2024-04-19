/**
	XMLParser class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.gallery {

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
					
					// *** Category properties
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
					case "previewBorderColor":
						if (attr != "") __root.previewBorderColor = Number("0x" + attr);
					break;
					case "previewBorderThickness":
						if (Number(attr) >= 0 && attr != "") __root.previewBorderThickness = attr;
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
					case "previewCaptionBgColor":
						if (attr != "") __root.previewCaptionBgColor = Number("0x" + attr);
					break;
					case "previewCaptionBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.previewCaptionBgAlpha = attr;
					break;
					case "previewCaptionBlurredBg":
						if (attr == "true" || attr == "false") __root.previewCaptionBlurredBg = stringToBoolean(attr);
					break;
					case "previewCaptionBgBlurAmount":
						if (Number(attr) >= 0 && attr != "") __root.previewCaptionBgBlurAmount = attr;
					break;
					case "previewCaptionPadding":
						if (Number(attr) >= 0 && attr != "") __root.previewCaptionPadding = attr;
					break;
					case "previewCaptionAnimationType":
						if (attr == "fade" || attr == "slide") __root.previewCaptionAnimationType = attr;
					break;
					case "previewOverBrightness":
						if (!isNaN(attr)) __root.previewOverBrightness = attr;
					break;
					case "previewVideoIconSize":
						if (Number(attr) >= 0 && attr != "") __root.previewVideoIconSize = attr;
					break;
					case "previewVideoIconColor":
						if (attr != "") __root.previewVideoIconColor = Number("0x" + attr);
					break;
					case "previewVideoIconAlpha":
						if (Number(attr) >= 0 && attr != "") __root.previewVideoIconAlpha = attr;
					break;
					case "previewVideoIconOverAlpha":
						if (Number(attr) >= 0 && attr != "") __root.previewVideoIconOverAlpha = attr;
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
					case "buttonSpacing":
						if (Number(attr) >= 0 && attr != "") __root.buttonSpacing = attr;
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
					case "showInfoButton":
						if (attr == "true" || attr == "false") __root.showInfoButton = stringToBoolean(attr);
					break;
					case "singleItemTextLeftMargin":
						if (Number(attr) >= 0 && attr != "") __root.singleItemTextLeftMargin = attr;
					break;
					case "singleItemTextRightMargin":
						if (Number(attr) >= 0 && attr != "") __root.singleItemTextRightMargin = attr;
					break;
					case "singleItemDescriptionHeight":
						if (Number(attr) >= 0 && attr != "") __root.singleItemDescriptionHeight = attr;
						if (__root.singleItemDescriptionHeight > 400) __root.singleItemDescriptionHeight = 400;
					break;
					case "singleItemDescriptionTopMargin":
						if (Number(attr) >= 0 && attr != "") __root.singleItemDescriptionTopMargin = attr;
					break;
					case "singleItemPreloaderColor":
						if (attr != "") __root.singleItemPreloaderColor = __root.videoPlayerPreloaderColor = Number("0x" + attr);
					break;
					case "singleItemPreloaderAlpha":
						if (Number(attr) >= 0 && attr != "") __root.singleItemPreloaderAlpha = __root.videoPlayerPreloaderAlpha = attr;
					break;
					
					// *** Single item video properties
					case "videoPlayerWidth":
						if (Number(attr) > 0) __root.videoPlayerWidth = attr;
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
					
					// *** Description scroll bar properties
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
				if (aChild.name() == "category" && aChild.hasComplexContent()) {
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
					if (aChild.preview.@clickLink != "" && aChild.preview.@clickLink != undefined) itemObject.previewClickLink = aChild.preview.@clickLink;
					if (aChild.preview.@clickTarget != "" && aChild.preview.@clickTarget != undefined) itemObject.previewClickTarget = aChild.preview.@clickTarget;
					if (aChild.preview.text() != "" && aChild.preview.text() != undefined) itemObject.previewCaption = aChild.preview.text();
					if (aChild.description.text() != "" && aChild.description.text() != undefined) itemObject.description = aChild.description.text();
					if (aChild.media.hasComplexContent()) itemObject.media = mediaNodeParser(aChild.media);
					itemsArray.push(itemObject);
				}
			}
			return itemsArray;
		}
		
	/****************************************************************************************************/
	//	Function. Parses the elements of an "item" -> "media" node.
		
		private function mediaNodeParser(node:XMLList):Array {
			var mediaArray:Array = new Array();
			if (node.children()[0].name() == "image") imageParser(node.children()[0], mediaArray);
			if (node.children()[0].name() == "video") videoParser(node.children()[0], mediaArray);
			return mediaArray;
		}
		
	/****************************************************************************************************/
	//	Function. Parses an image element.
		
		private function imageParser(node:XML, mediaArray:Array):void {
			var mediaObject:Object = new Object();
			mediaObject.type = "image";
			if (node.@src != "" && node.@src != undefined) mediaObject.src = node.@src;
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