/**
	XMLParser class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.news {

	public class XMLParser {
		
		private var __root:*;
		private var categoriesArray:Array, newsArray:Array;
	
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
					case "previewsTopMargin":
						if (Number(attr) >= 0 && attr != "") __root.previewsTopMargin = attr;
					break;
					case "previewsLeftMargin":
						if (Number(attr) >= 0 && attr != "") __root.previewsLeftMargin = attr;
					break;
					case "previewImageWidth":
						if (Number(attr) > 0) __root.previewImageWidth = attr;
					break;
					case "previewImageHeight":
						if (Number(attr) > 0) __root.previewImageHeight = attr;
					break;
					case "previewSpacing":
						if (Number(attr) >= 0 && attr != "") __root.previewSpacing = attr;
					break;
					case "previewImageBgColor":
						if (attr != "") __root.previewImageBgColor = Number("0x" + attr);
					break;
					case "previewImageBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.previewImageBgAlpha = attr;
					break;
					case "previewImageBorderColor":
						if (attr != "") __root.previewImageBorderColor = Number("0x" + attr);
					break;
					case "previewImageBorderThickness":
						if (Number(attr) >= 0 && attr != "") __root.previewImageBorderThickness = attr;
					break;
					case "previewImageShadowColor":
						if (attr != "") __root.previewImageShadowColor = Number("0x" + attr);
					break;
					case "previewImageShadowAlpha":
						if (Number(attr) >= 0 && attr != "") __root.previewImageShadowAlpha = attr;
					break;
					case "previewImagePadding":
						if (Number(attr) >= 0 && attr != "") __root.previewImagePadding = attr;
					break;
					case "previewImagePreloaderColor":
						if (attr != "") __root.previewImagePreloaderColor = Number("0x" + attr);
					break;
					case "previewImagePreloaderAlpha":
						if (Number(attr) >= 0 && attr != "") __root.previewImagePreloaderAlpha = attr;
					break;
					case "previewImageOverBrightness":
						if (!isNaN(attr)) __root.previewImageOverBrightness = attr;
					break;
					case "previewImageBottomMargin":
						if (Number(attr) >= 0 && attr != "") __root.previewImageBottomMargin = attr;
					break;
					case "previewTitleBottomPadding":
						if (Number(attr) >= 0 && attr != "") __root.previewTitleBottomPadding = attr;
					break;
					case "previewDateBottomPadding":
						if (Number(attr) >= 0 && attr != "") __root.previewDateBottomPadding = attr;
					break;
					case "previewDateBgColor":
						if (attr != "") __root.previewDateBgColor = Number("0x" + attr);
					break;
					case "previewDateBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.previewDateBgAlpha = attr;
					break;
					
					// *** Single article controls properties
					case "showSingleArticle":
						if (attr == "true" || attr == "false") __root.showSingleArticle = stringToBoolean(attr);
					break;
					case "singleArticleYPosition":
						if (Number(attr) >= 0 && attr != "") __root.singleArticleYPosition = attr;
					break;
					case "articleHeaderHeight":
						if (Number(attr) >= 0 && attr != "") __root.articleHeaderHeight = attr;
					break;
					case "articleControlsRightMargin":
						if (Number(attr) >= 0 && attr != "") __root.articleControlsRightMargin = attr;
					break;
					case "articleListButtonURL":
						if (attr != "") __root.articleListButtonURL = attr;
					break;
					case "articleLeftNavButtonURL":
						if (attr != "") __root.articleLeftNavButtonURL = attr;
					break;
					case "articleRightNavButtonURL":
						if (attr != "") __root.articleRightNavButtonURL = attr;
					break;
					case "articleNavButtonSpacing":
						if (Number(attr) >= 0 && attr != "") __root.articleNavButtonSpacing = attr;
					break;
					case "articleButtonColor":
						if (attr != "") __root.articleButtonColor = Number("0x" + attr);
					break;
					case "articleButtonOverColor":
						if (attr != "") __root.articleButtonOverColor = Number("0x" + attr);
					break;
					case "articleControlsSeparatorURL":
						if (attr != "") __root.articleControlsSeparatorURL = attr;
					break;
					case "articleControlsSeparatorColor":
						if (attr != "") __root.articleControlsSeparatorColor = Number("0x" + attr);
					break;
					case "articleTitleTopMargin":
						if (Number(attr) >= 0 && attr != "") __root.articleTitleTopMargin = attr;
					break;
					case "articleDateTopMargin":
						if (Number(attr) >= 0 && attr != "") __root.articleDateTopMargin = attr;
					break;
					case "articleContentTopMargin":
						if (Number(attr) >= 0 && attr != "") __root.articleContentTopMargin = attr;
					break;
					
					// *** Single article big image properties
					case "showArticleMedia":
						if (attr == "true" || attr == "false") __root.showArticleMedia = stringToBoolean(attr);
					break;
					case "bigImageAreaWidth":
						if (Number(attr) >= 0 && attr != "") __root.bigImageAreaWidth = attr;
					break;
					case "bigImageAreaRightMargin":
						if (Number(attr) >= 0 && attr != "") __root.bigImageAreaRightMargin = attr;
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
					
					// *** Single article video properties
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
					
					// *** Single article description properties
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
			newsArray = new Array();
			for each (var aChild:XML in node.*) {
				if (aChild.name() == "item" && aChild.hasComplexContent()) {
					var itemObject:Object = new Object();
					if (aChild.preview.title.text() != "" && aChild.preview.title.text() != undefined) itemObject.previewTitle = aChild.preview.title.text();
					if (aChild.preview.image.@src != "" && aChild.preview.image.@src != undefined) itemObject.previewImgSrc = aChild.preview.image.@src;
					if (aChild.preview.date.text() != "" && aChild.preview.date.text() != undefined) itemObject.previewDate = aChild.preview.date.text();
					if (aChild.preview.text.text() != "" && aChild.preview.text.text() != undefined) itemObject.previewText = aChild.preview.text.text();
					if (aChild.article.title.text() != "" && aChild.article.title.text() != undefined) itemObject.articleTitle = aChild.article.title.text();
					if (aChild.article.media.hasComplexContent()) itemObject.media = mediaNodeParser(aChild.article.media);
					if (aChild.article.date.text() != "" && aChild.article.date.text() != undefined) itemObject.articleDate = aChild.article.date.text();
					if (aChild.article.content.hasComplexContent()) itemObject.articleBlocks = contentNodeParser(aChild.article.content);
					newsArray.push(itemObject);
				}
			}
			return newsArray;
		}

	/****************************************************************************************************/
	//	Function. Parses the elements of a "item" -> "article" -> "content" node.
	
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
	//	Function. Parses the elements of an "item" -> "article"-> "media" node.
	
		private function mediaNodeParser(node:XMLList):Array {
			var mediaArray:Array = new Array();
			if (node.children()[0].name() == "image") imageParser(node.children()[0], mediaArray);
			if (node.children()[0].name() == "video") videoParser(node.children()[0], mediaArray);
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