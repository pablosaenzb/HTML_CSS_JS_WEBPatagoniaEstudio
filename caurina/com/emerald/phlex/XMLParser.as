/**
	XMLParser class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex {

	public class XMLParser {
		
		private var __root:*;
		private var playList:Array, networksArray:Array;
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function XMLParser(obj:*):void {
			__root = obj; // a reference to the object of the main class
		}
		
	/****************************************************************************************************/
	//	Function. Parses the attributes of the "general" node.
	
		public function generalNodeParser(node:XMLList):void {
			
			var attr_name:String;
			for each (var attr:* in node.@*) {
				attr_name = attr.name();
				
				switch (attr_name) {
					case "websiteTitle":
						if (attr != "") __root.websiteTitle = attr;
					break;
					case "templateWidth":
						if (Number(attr) > 0) __root.templateWidth = attr;
					break;
					
					// *** Header properties
					case "headerHeight":
						if (Number(attr) > 0) __root.headerHeight = attr;
					break;
					case "headerPattern":
						if (attr != "") __root.headerPattern = attr;
					break;
					case "headerBgImage":
						if (attr != "") __root.headerBgImage = attr;
					break;
					case "headerBgColor":
						if (attr != "") __root.headerBgColor = Number("0x" + attr);
					break;
					case "headerShadow":
						if (attr != "") __root.headerShadow = attr;
					break;
					
					// *** Logo properties
					case "logoURL":
						if (attr != "") __root.logoURL = attr;
					break;
					case "logoXOffset":
						if (!isNaN(attr)) __root.logoXOffset = attr;
					break;
					case "logoYPosition":
						if (Number(attr) >= 0 && attr != "") __root.logoYPosition = attr;
					break;
					
					// *** Menu properties
					case "menuXML":
						if (attr != "") __root.menuXML_URL = attr;
					break;
					case "menuAlign":
						if (attr == "left" || attr == "right") __root.menuAlign = attr;
					break;
					case "menuXOffset":
						if (!isNaN(attr)) __root.menuXOffset = attr;
					break;
					case "menuYPosition":
						if (Number(attr) >= 0 && attr != "") __root.menuYPosition = attr;
					break;
					case "menuSpacing":
						if (Number(attr) >= 0 && attr != "") __root.menuSpacing = attr;
					break;
					case "menuFont":
						if (attr != "") __root.menuFont = attr;
					break;
					case "menuFontSize":
						if (Number(attr) > 0) __root.menuFontSize = attr;
					break;
					case "menuFontWeight":
						if (attr == "normal" || attr == "bold") __root.menuFontWeight = attr;
					break;
					case "menuFontColor":
						if (attr != "") __root.menuFontColor = Number("0x" + attr);
					break;
					case "menuOverFontColor":
						if (attr != "") __root.menuOverFontColor = Number("0x" + attr);
					break;
					case "menuSelectedFontColor":
						if (attr != "") __root.menuSelectedFontColor = Number("0x" + attr);
					break;
					case "menuOverBgColor":
						if (attr != "") __root.menuOverBgColor = Number("0x" + attr);
					break;
					case "menuOverBgAlphaTop":
						if (Number(attr) >= 0 && attr != "") __root.menuOverBgAlphaTop = attr;
					break;
					case "menuOverBgAlphaBottom":
						if (Number(attr) >= 0 && attr != "") __root.menuOverBgAlphaBottom = attr;
					break;
					
					// *** Submenu properties
					case "submenuItemHeight":
						if (Number(attr) > 0) __root.submenuItemHeight = attr;
					break;
					case "submenuFont":
						if (attr != "") __root.submenuFont = attr;
					break;
					case "submenuFontSize":
						if (Number(attr) > 0) __root.submenuFontSize = attr;
					break;
					case "submenuFontWeight":
						if (attr == "normal" || attr == "bold") __root.submenuFontWeight = attr;
					break;
					case "submenuFontColor":
						if (attr != "") __root.submenuFontColor = Number("0x" + attr);
					break;
					case "submenuOverFontColor":
						if (attr != "") __root.submenuOverFontColor = Number("0x" + attr);
					break;
					case "submenuSelectedFontColor":
						if (attr != "") __root.submenuSelectedFontColor = Number("0x" + attr);
					break;
					case "submenuBgColor":
						if (attr != "") __root.submenuBgColor = Number("0x" + attr);
					break;
					case "submenuBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.submenuBgAlpha = attr;
					break;
					case "submenuOverBgColor":
						if (attr != "") __root.submenuOverBgColor = Number("0x" + attr);
					break;
					case "submenuOverBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.submenuOverBgAlpha = attr;
					break;
					case "submenuTopTrimHeight":
						if (Number(attr) >= 0 && attr != "") __root.submenuTopTrimHeight = attr;
						if (__root.submenuTopTrimHeight > 3) __root.submenuTopTrimHeight = 3;
					break;
					case "submenuTopTrimColor":
						if (attr != "") __root.submenuTopTrimColor = Number("0x" + attr);
					break;
					case "submenuTopTrimAlpha":
						if (Number(attr) >= 0 && attr != "") __root.submenuTopTrimAlpha = attr;
					break;
					case "submenuShadowColor":
						if (attr != "") __root.submenuShadowColor = Number("0x" + attr);
					break;
					case "submenuShadowAlpha":
						if (Number(attr) >= 0 && attr != "") __root.submenuShadowAlpha = attr;
					break;
					case "submenuShadowStrength":
						if (Number(attr) >= 0 && attr != "") __root.submenuShadowStrength = attr;
					break;
					case "submenuShadowDistance":
						if (Number(attr) >= 0 && attr != "") __root.submenuShadowDistance = attr;
					break;
					
					// *** Body properties
					case "bodyPattern":
						if (attr != "") __root.bodyPattern = attr;
					break;
					case "bodyPatternFullStage":
						if (attr == "true" || attr == "false") __root.bodyPatternFullStage = stringToBoolean(attr);
					break;
					case "bodyBgImage":
						if (attr != "") __root.bodyBgImage = attr;
					break;
					case "bodyBgImageFullStage":
						if (attr == "true" || attr == "false") __root.bodyBgImageFullStage = stringToBoolean(attr);
					break;
					case "bodyBgColor":
						if (attr != "") __root.bodyBgColor = Number("0x" + attr);
					break;
					
					// *** Content page properties
					case "contentPageMinTopMargin":
						if (Number(attr) > 0) __root.contentPageMinTopMargin = attr;
					break;
					case "contentPageMaxTopMargin":
						if (Number(attr) > 0) __root.contentPageMaxTopMargin = attr;
					break;
					case "contentPageBgColor":
						if (attr != "") __root.contentPageBgColor = Number("0x" + attr);
					break;
					case "contentPageBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.contentPageBgAlpha = attr;
					break;
					case "contentPageLeftMargin":
						if (Number(attr) >= 0 && attr != "") __root.contentPageLeftMargin = attr;
					break;
					case "contentPageRightMargin":
						if (Number(attr) >= 0 && attr != "") __root.contentPageRightMargin = attr;
					break;
					case "styleSheetURL":
						if (attr != "") __root.styleSheetURL = attr;
					break;
					
					// *** Breadcrumb navigation properties
					case "breadcrumbsTopMargin":
						if (Number(attr) >= 0 && attr != "") __root.breadcrumbsTopMargin = attr;
					break;
					case "breadcrumbIconURL":
						if (attr != "") __root.breadcrumbIconURL = attr;
					break;
					case "breadcrumbIconTopPadding":
						if (Number(attr) >= 0 && attr != "") __root.breadcrumbIconTopPadding = attr;
					break;
					case "breadcrumbIconColor":
						if (attr != "") __root.breadcrumbIconColor = Number("0x" + attr);
					break;
					case "breadcrumbSpacing":
						if (Number(attr) >= 0 && attr != "") __root.breadcrumbSpacing = attr;
					break;
					case "breadcrumbFont":
						if (attr != "") __root.breadcrumbFont = attr;
					break;
					case "breadcrumbFontSize":
						if (Number(attr) > 0) __root.breadcrumbFontSize = attr;
					break;
					case "breadcrumbFontColor":
						if (attr != "") __root.breadcrumbFontColor = Number("0x" + attr);
					break;
					case "breadcrumbOverFontColor":
						if (attr != "") __root.breadcrumbOverFontColor = Number("0x" + attr);
					break;
					case "breadcrumbSelectedFontColor":
						if (attr != "") __root.breadcrumbSelectedFontColor = Number("0x" + attr);
					break;
					
					// *** Footer properties
					case "footerHeight":
						if (Number(attr) > 0) __root.footerHeight = attr;
					break;
					case "footerLeftMargin":
						if (Number(attr) >= 0 && attr != "") __root.footerLeftMargin = attr;
					break;
					case "footerRightMargin":
						if (Number(attr) >= 0 && attr != "") __root.footerRightMargin = attr;
					break;
					case "footerPattern":
						if (attr != "") __root.footerPattern = attr;
					break;
					case "footerBgImage":
						if (attr != "") __root.footerBgImage = attr;
					break;
					case "footerBgColor":
						if (attr != "") __root.footerBgColor = Number("0x" + attr);
					break;
					case "showMusicIcon":
						if (attr == "true" || attr == "false") __root.showMusicIcon = stringToBoolean(attr);
					break;
					case "showFullScreenIcon":
						if (attr == "true" || attr == "false") __root.showFullScreenIcon = stringToBoolean(attr);
					break;
					case "musicAndScreenIconsTopPadding":
						if (Number(attr) >= 0 && attr != "") __root.musicAndScreenIconsTopPadding = attr;
					break;
					case "musicAndScreenIconsSpacing":
						if (Number(attr) >= 0 && attr != "") __root.musicAndScreenIconsSpacing = attr;
					break;
					case "musicAndScreenIconsColor":
						if (attr != "") __root.musicAndScreenIconsColor = uint("0xFF" + attr);
					break;
					case "musicAndScreenIconsOverBrightness":
						if (!isNaN(attr)) __root.musicAndScreenIconsOverBrightness = attr;
					break;
					case "socialIconsTopPadding":
						if (Number(attr) >= 0 && attr != "") __root.socialIconsTopPadding = attr;
					break;
					case "socialIconsSpacing":
						if (Number(attr) >= 0 && attr != "") __root.socialIconsSpacing = attr;
					break;
					case "socialIconsOverBrightness":
						if (!isNaN(attr)) __root.socialIconsOverBrightness = attr;
					break;
					
					// *** Preloader properties
					case "showPreloader":
						if (attr == "true" || attr == "false") __root.showPreloader = stringToBoolean(attr);
					break;
					case "preloaderColor":
						if (attr != "") __root.preloaderColor = Number("0x" + attr);
					break;
					case "preloaderAlpha":
						if (Number(attr) >= 0 && attr != "") __root.preloaderAlpha = attr;
					break;
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Parses the elements of the "music" node.
	
		public function musicNodeParser(node:XMLList):Array {
			playList = new Array();
			if (node.@enabled == "true" || node.@enabled == "false") __root.musicEnabled = stringToBoolean(node.@enabled);
			if (Number(node.@bufferTime) >= 0 && node.@bufferTime != "" && node.@bufferTime != undefined) __root.musicBufferTime = node.@bufferTime;
			if (Number(node.@volume) >= 0  && Number(node.@volume) <= 1 && node.@volume != "" && node.@volume != undefined) __root.musicVolume = node.@volume;
			for each (var aChild:XML in node.*) {
				if (aChild.name() == "track") {
					if (aChild.@src != "" && aChild.@src != undefined) playList.push(aChild.@src);
				}
			}
			return playList;
		}
		
	/****************************************************************************************************/
	//	Function. Parses the elements of the "socialnetworks" node.
	
		public function networksNodeParser(node:XMLList):Array {
			networksArray = new Array();
			for each (var aChild:XML in node.*) {
				if (aChild.name() == "icon") {
					var iconObject:Object = new Object();
					if (aChild.@src != "" && aChild.@src != undefined) iconObject.iconSrc = aChild.@src;
					if (aChild.@clickLink != "" && aChild.@clickLink != undefined) iconObject.clickLink = aChild.@clickLink;
					if (aChild.@clickTarget != "" && aChild.@clickTarget != undefined) iconObject.clickTarget = aChild.@clickTarget;
					if (iconObject.iconSrc != undefined) networksArray.push(iconObject);
				}
			}
			return networksArray;
		}
		
	/****************************************************************************************************/
	//	Function. Parses the attributes and the text of the "footertext" node.
	
		public function footertextNodeParser(node:XMLList):void {
			if (Number(node.@topPadding) >= 0) __root.footerTextTopPadding = node.@topPadding;
			if (Number(node.@leftPadding) >= 0) __root.footerTextLeftPadding = node.@leftPadding;
			if (node.text() != "" && node.text() != undefined) __root.footerText = node.text();
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