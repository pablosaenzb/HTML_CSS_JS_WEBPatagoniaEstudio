/**
	XMLParser class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.contact {

	public class XMLParser {
		
		private var __root:*;
	
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
					case "phpFileURL":
						if (attr != "") __root.phpFileURL = attr;
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
					
					// *** Contact form properties
					case "fieldFont":
						if (attr != "") __root.fieldFont = attr;
					break;
					case "filedFontSize":
						if (Number(attr) > 0) __root.filedFontSize = attr;
					break;
					case "fieldFontColor":
						if (attr != "") __root.fieldFontColor = Number("0x" + attr);
					break;
					case "fieldBgColor":
						if (attr != "") __root.fieldBgColor = Number("0x" + attr);
					break;
					case "fieldBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.fieldBgAlpha = attr;
					break;
					case "focusedFieldBgColor":
						if (attr != "") __root.focusedFieldBgColor = Number("0x" + attr);
					break;
					case "focusedFieldBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.focusedFieldBgAlpha = attr;
					break;
					case "focusedFieldBorderColor":
						if (attr != "") __root.focusedFieldBorderColor = Number("0x" + attr);
					break;
					case "sendButtonLabel":
						if (attr != "") __root.sendButtonLabel = attr;
					break;
					case "sendButtonColor":
						if (attr != "") __root.sendButtonColor = Number("0x" + attr);
					break;
					case "sendButtonOverColor":
						if (attr != "") __root.sendButtonOverColor = Number("0x" + attr);
					break;
					case "infoMessageFontColor":
						if (attr != "") __root.infoMessageFontColor = Number("0x" + attr);
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
	//	Function. Parses the attributes and the elements of the "leftColumn" and "rightColumn" nodes.
	
		public function columnNodeParser(node:XMLList):void {
			if (node.name() == "leftColumn" && Number(node.@width) >= 0) __root.leftColumnWidth = node.@width;
			if (node.name() == "rightColumn" && Number(node.@leftMargin) >= 0) __root.columnSpacing = node.@leftMargin;
			
			// "image" node
			var imgURL:String, imgWidth:uint, imgHeight:uint;
			if (node.image.@src != "" && node.image.@src != undefined) __root.imageURL = imgURL = node.image.@src;
			if (Number(node.image.@width) > 0) __root.imageWidth = imgWidth = node.image.@width;
			if (Number(node.image.@height) > 0) __root.imageHeight = imgHeight = node.image.@height;
			if (Number(node.image.@topMargin) > 0) __root.imageTopMargin = node.image.@topMargin;
			if (node.image.text() != "" && node.image.text() != undefined) __root.imageCaptionText = node.image.text();
			if (imgURL != null && imgWidth > 0 && imgHeight > 0) {
				if (node.name() == "leftColumn") __root.imagePosition = "left";
				if (node.name() == "rightColumn") __root.imagePosition = "right";
			}
			
			// "text" node
			if (node.text.text() != "" && node.text.text() != undefined) {
				if (node.name() == "leftColumn") __root.info2Position = "left";
				if (node.name() == "rightColumn") __root.info2Position = "right";
				if (Number(node.text.@topMargin) > 0) __root.info2TopMargin = node.text.@topMargin;
				__root.info2Text = node.text.text();
			}
			
			// "info" node
			if (node.info.text() != "" && node.info.text() != undefined) {
				if (node.name() == "leftColumn") __root.infoPosition = "left";
				if (node.name() == "rightColumn") __root.infoPosition = "right";
				if (Number(node.info.@topMargin) > 0) __root.infoTopMargin = node.info.@topMargin;
				if (Number(node.info.@height) > 0) __root.infoHeight = node.info.@height;
				__root.infoText = node.info.text();
			}
			
			// "form" node
			if (node.form.hasComplexContent()) {
				if (node.name() == "leftColumn") __root.formPosition = "left";
				if (node.name() == "rightColumn") __root.formPosition = "right";
				if (Number(node.form.@topMargin) > 0) __root.formTopMargin = node.form.@topMargin;
				if (node.form.@active == "true" || node.form.@active == "false") __root.formActivated = stringToBoolean(node.form.@active);
				if (node.form.@successMsg != "" && node.form.@successMsg != undefined) __root.successMsg = node.form.@successMsg;
				if (node.form.@warningMsg != "" && node.form.@warningMsg != undefined) __root.warningMsg = node.form.@warningMsg;
				if (node.form.@errorMsg != "" && node.form.@errorMsg != undefined) __root.errorMsg = node.form.@errorMsg;
				if (node.form.name != undefined) {
					if (node.form.name.@label != "" && node.form.name.@label != undefined) __root.nameFieldLabel = node.form.name.@label;
					if (node.form.name.@required == "true" || node.form.name.@required == "false") __root.nameFieldRequired = stringToBoolean(node.form.name.@required);
					if (node.form.name.@errorMsg != "" && node.form.name.@errorMsg != undefined) __root.nameFieldErrorMsg = node.form.name.@errorMsg;
				}
				if (node.form.email != undefined) {
					if (node.form.email.@label != "" && node.form.email.@label != undefined) __root.emailFieldLabel = node.form.email.@label;
					if (node.form.email.@required == "true" || node.form.email.@required == "false") __root.emailFieldRequired = stringToBoolean(node.form.email.@required);
					if (node.form.email.@errorMsg1 != "" && node.form.email.@errorMsg1 != undefined) __root.emailFieldErrorMsg1 = node.form.email.@errorMsg1;
					if (node.form.email.@errorMsg2 != "" && node.form.email.@errorMsg2 != undefined) __root.emailFieldErrorMsg2 = node.form.email.@errorMsg2;
				}
				if (node.form.phone != undefined) {
					if (node.form.phone.@label != "" && node.form.phone.@label != undefined) __root.phoneFieldLabel = node.form.phone.@label;
					if (node.form.phone.@required == "true" || node.form.phone.@required == "false") __root.phoneFieldRequired = stringToBoolean(node.form.phone.@required);
					if (node.form.phone.@errorMsg != "" && node.form.phone.@errorMsg != undefined) __root.phoneFieldErrorMsg = node.form.phone.@errorMsg;
				}
				if (node.form.message != undefined) {
					if (node.form.message.@label != "" && node.form.message.@label != undefined) __root.messageFieldLabel = node.form.message.@label;
					if (node.form.message.@required == "true" || node.form.message.@required == "false") __root.messageFieldRequired = stringToBoolean(node.form.message.@required);
					if (node.form.message.@errorMsg != "" && node.form.message.@errorMsg != undefined) __root.messageFieldErrorMsg = node.form.message.@errorMsg;
				}
			}
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