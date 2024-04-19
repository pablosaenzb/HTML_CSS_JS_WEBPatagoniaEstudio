/**
	XMLParser class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.showreel {

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
					case "videoPlayerWidth":
						if (Number(attr) > 0) __root.videoPlayerWidth = attr;
					break;
					case "videoPlayerHeight":
						if (Number(attr) > 0) __root.videoPlayerHeight = attr;
					break;
					case "videoPlayerYPosition":
						if (Number(attr) >= -25 && attr != "") __root.videoPlayerYPosition = attr;
					break;
					case "videoPlayerHorizontalAlign":
						if (attr == "left" || attr == "center" || attr == "right") __root.videoPlayerHorizontalAlign = attr;
					break;
					case "videoPlayerVerticalAlign":
						if (attr == "top" || attr == "middle" || attr == "center") __root.videoPlayerVerticalAlign = attr;
					break;
					case "videoPlayerBgColor":
						if (attr != "") __root.videoPlayerBgColor = Number("0x" + attr);
					break;
					case "videoPlayerBgAlpha":
						if (Number(attr) >= 0 && attr != "") __root.videoPlayerBgAlpha = attr;
					break;
					case "videoPlayerShadowColor":
						if (attr != "") __root.videoPlayerShadowColor = Number("0x" + attr);
					break;
					case "videoPlayerShadowAlpha":
						if (Number(attr) >= 0 && attr != "") __root.videoPlayerShadowAlpha = attr;
					break;
					case "videoPlayerPreloaderColor":
						if (attr != "") __root.videoPlayerPreloaderColor = Number("0x" + attr);
					break;
					case "videoPlayerPreloaderAlpha":
						if (Number(attr) >= 0 && attr != "") __root.videoPlayerPreloaderAlpha = attr;
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
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Parses the attributes of the "video" node.
	
		public function videoNodeParser(node:XMLList):void {
			if (node.@youTubeMode == "true" || node.@youTubeMode == "false") __root.youTubeMode = stringToBoolean(node.@youTubeMode);
			if (node.@src != "" && node.@src != undefined) __root.videoURL = node.@src;
			if (node.@previewImage != "" && node.@previewImage != undefined) __root.previewImageURL = node.@previewImage;
			if (node.@playbackQuality != "" && node.@playbackQuality != undefined) __root.playbackQuality = node.@playbackQuality;
			if (node.@autoPlay == "true" || node.@autoPlay == "false") __root.videoAutoPlay = stringToBoolean(node.@autoPlay);
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