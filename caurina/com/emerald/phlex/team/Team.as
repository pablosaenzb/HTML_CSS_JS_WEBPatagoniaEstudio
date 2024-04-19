/**
	Team class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.team {
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextLineMetrics;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import com.emerald.phlex.utils.Geom;
	import com.emerald.phlex.utils.Image;
	import com.emerald.phlex.utils.Scroller;
	import com.emerald.phlex.utils.Utils;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import caurina.transitions.*;
	import caurina.transitions.properties.ColorShortcuts;

	public class Team extends Sprite {
		
		public var main:Sprite, controls:Sprite, team:Sprite;
		private var __root:*;
		private var xml_URL:String;
		private var xmlLoader:URLLoader;
		private var dataXML:XML;
		private var XMLParserObj:Object;
		private var teamArray:Array;
		private var imgsLoader:Loader;
		private var imageLoader1:Loader, imageLoader2:Loader, imageLoader3:Loader, imageLoader4:Loader, imageLoader5:Loader, imageLoader6:Loader, imageLoader7:Loader, imageLoader8:Loader;
		private var scrollerObj1:Object, scrollerObj2:Object, scrollerObj3:Object, scrollerObj4:Object, scrollerObj5:Object, scrollerObj6:Object, scrollerObj7:Object, scrollerObj8:Object;
		private var killcache_str:String;
		private var killCachedFiles:Boolean = false;
		private var textStyleSheet:StyleSheet;
		private var currentImgIndex:uint;
		private var current_page:uint = 1;
		private var item_width:uint, item_height:uint;
		private var controls_blocked:Boolean = false;
		private static const FADE_DURATION:Number = 0.7;
		private static const ON_ROLL_DURATION:Number = 0.3;
		private static const BUTTON_SPACING:uint = 5;
		private static const TEXT_LEADING:uint = 6;
		
		public var controlsYPosition:int = 0;
		public var controlsRightMargin:uint = 0;
		public var navButtonColor:uint = 0x888888;
		public var navButtonSelectedColor:uint = 0xE77927;
		
		// Items properties
		public var itemsInRow:uint = 3;
		public var itemsTopMargin:uint = 0;
		public var itemsLeftMargin:uint = 0;
		public var itemWidth:uint = 210;
		public var itemHeight:uint = 210;
		public var itemHSpacing:uint = 40;
		
		// Image properties
		public var imageBgColor:Number;
		public var imageBgAlpha:Number;
		public var imageBorderColor:Number;
		public var imageBorderThickness:uint;
		public var imageShadowColor:Number;
		public var imageShadowAlpha:Number;
		public var imagePadding:uint = 0;
		public var imagePreloaderColor:Number;
		public var imagePreloaderAlpha:Number;
		public var imageOverBrightness:Number = 0;
		public var imageLinkIconAlpha:Number = 0;
		public var imageLinkIconOverAlpha:Number = 0;
		public var imageBottomMargin:uint = 0;
		
		public var personNameBottomPadding:uint = 10;
		public var personPositionBottomPadding:uint = 10;
		
		// List properties
		public var listItemMarkerURL:String;
		public var listItemMarkerTopPadding:uint = 0;
		public var listItemLeftPadding:uint = 0;
		public var listItemBottomPadding:uint = 0;
		
		// Scroll bar properties
		public var scrollBarTrackWidth:uint;
		public var scrollBarTrackColor:Number;
		public var scrollBarTrackAlpha:Number = 1;
		public var scrollBarSliderOverWidth:uint;
		public var scrollBarSliderColor:uint = 0xB5B5B5;
		public var scrollBarSliderOverColor:Number;
		
		// Image Shadow
		private var imageShadowBlur:uint = 16;
		private var imageShadowStrength:uint = 1;
		private var imageShadowQuality:uint = 2;
		
		ColorShortcuts.init();	// initiates the ColorShortcuts special properties of the Tweener class
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function Team():void {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addChild(main = new Sprite());
		}
		
	/****************************************************************************************************/
	//	Function. Dispatched when the Team object is added to the Stage.
	
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
	/****************************************************************************************************/
	//	Function. Initiates a number of actions for preparing and activating the module.
	//	Called from the moduleLoadComplete() function of the WebsiteTemplate class.

		public function initiate(obj:*, xmlURL:String, killcache:Boolean, stylesheet:StyleSheet):void {
			__root = obj; // a reference to the object of the WebsiteTemplate class
			xml_URL = xmlURL;
			killCachedFiles = killcache;
			textStyleSheet = stylesheet;
			if (xml_URL != null) {
				xmlLoader = new URLLoader();
				xmlLoader.addEventListener(Event.COMPLETE, xmlDataProcessing);
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlDataError);
				var date:Date = new Date();
				if (__root != null) killcache_str = __root.generateKillCacheString(date);
				xmlLoader.load(new URLRequest(xml_URL+(killCachedFiles?killcache_str:'')));
			}
		}

	/****************************************************************************************************/
	//	Function. Processes the XML data.
		
		private function xmlDataProcessing(e:Event):void {
			xmlLoader.removeEventListener(Event.COMPLETE, xmlDataProcessing);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlDataError);
			dataXML = new XML(e.currentTarget.data);
			XMLParserObj = new XMLParser(this);
			XMLParserObj.settingsNodeParser(dataXML.settings); // processing "settings" node
			teamArray = XMLParserObj.personNodeParser(dataXML); // processing "person" node
			if (teamArray.length > 0 && itemsInRow > 0) createTeam();
			if (__root != null) __root.openNewPage(); // calls the openNewPage() function of the WebsiteTemplate class
		}
		
		private function xmlDataError(e:IOErrorEvent):void {
			xmlLoader.removeEventListener(Event.COMPLETE, xmlDataProcessing);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlDataError);
		}
		
	/****************************************************************************************************/
	//	Function. Builds team items.
	
		private function createTeam():void {
			
			loadImgs();
			if (teamArray.length > itemsInRow) createControls();
			main.addChild(team = new Sprite());
			team.x = itemsLeftMargin;
			team.y = (controls?controlsYPosition+Math.ceil(controls.height):0) + itemsTopMargin;
			
			var border_thickness:uint = 0;
			if (!isNaN(imageBorderColor) && imageBorderThickness > 0) border_thickness = imageBorderThickness;
			item_width = itemWidth + 2*imagePadding + 2*border_thickness;
			item_height = itemHeight + 2*imagePadding + 2*border_thickness;
			
			var container_xPos:uint = 0;
			var base:Shape, shadow_base:Shape, bg:Shape;
			var container:Sprite, img:Sprite, title:Sprite, position:Sprite, hitarea:Sprite;
			var hover_icon:MovieClip;
			var tf:TextField;
			if (!isNaN(imageShadowColor) && !isNaN(imageShadowAlpha)) {
				var df:DropShadowFilter = new DropShadowFilter();
				df.color = imageShadowColor;
				df.alpha = imageShadowAlpha;
				df.distance = 0;
				df.angle = 0;
				df.quality = imageShadowQuality;
				df.blurX = df.blurY = imageShadowBlur;
				df.strength = imageShadowStrength;
				df.knockout = true;
				var dfArray:Array = new Array();
				dfArray.push(df);
			}
			
			for (var i=1; i<=itemsInRow; i++) {
				container = new Sprite();
				container.name = "container"+i;
				container.x = container_xPos;
				team.addChild(container);
				container.addChild(shadow_base = new Shape());
				shadow_base.name = "shadow_base";
				container.addChild(bg = new Shape());
				bg.name = "bg";
				hitarea = new Sprite();
				container.addChild(hitarea);
				hitarea.mouseEnabled = false;
				container.addChild(img = new Sprite());
				img.name = "img";
				img.hitArea = hitarea;
				hover_icon = new link_mc();
				container.addChild(hover_icon);
				hover_icon.mouseEnabled = false;
				hover_icon.visible = false;
				hover_icon.name = "hover_icon";
				container.addChild(base = new Shape());
				base.name = "base";
				if (!isNaN(imageBgColor) && !isNaN(imageBgAlpha)) {
					Geom.drawRectangle(bg, itemWidth+2*imagePadding, itemHeight+2*imagePadding, imageBgColor, imageBgAlpha);
				}
				if (!isNaN(imageShadowColor) && !isNaN(imageShadowAlpha)) {
					Geom.drawRectangle(shadow_base, item_width, item_height, 0xFFFFFF, 1);
					shadow_base.filters = dfArray;
				}
				if (!isNaN(imageBorderColor) && imageBorderThickness > 0) {
					Geom.drawBorder(base, itemWidth, itemHeight, imageBorderColor, 1, imageBorderThickness, imagePadding);
				}
				Geom.drawRectangle(hitarea, item_width, item_height, 0xFF9900, 0);
				
				bg.x = bg.y = border_thickness;
				img.x = img.y = base.x = base.y = border_thickness + imagePadding;
				
				container.addChild(title = new Sprite());
				title.name = "title";
				title.y = item_height + imageBottomMargin;
				tf = new TextField();
				tf.name = "tf";
				title.addChild(tf);
				if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
				tf.width = item_width;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.multiline = true;
				tf.wordWrap = true;
				tf.embedFonts = true;
				tf.selectable = true;
				tf.antiAliasType = AntiAliasType.ADVANCED;
				
				container.addChild(position = new Sprite());
				position.name = "position";
				tf = new TextField();
				tf.name = "tf";
				position.addChild(tf);
				if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
				tf.width = item_width;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.multiline = true;
				tf.wordWrap = true;
				tf.embedFonts = true;
				tf.selectable = true;
				tf.antiAliasType = AntiAliasType.ADVANCED;
				
				container_xPos += item_width + itemHSpacing;
				this["imageLoader"+i] = new Loader();
			}
			
			changeItems(current_page);
		}
		
	/****************************************************************************************************/
	//	Function. Changes team items (currently visible).
	
		private function changeItems(page:uint):void {
			
			// *** Changing selected buttons
			if (controls) {
				for (var j=1; j<=Math.ceil(teamArray.length/itemsInRow); j++) {
					var nav_but:MovieClip = controls.getChildByName("nav_but"+j) as MovieClip;
					Tweener.removeTweens(nav_but);
					if (j == page) {
						nav_but.stop();
						if (nav_but.currentFrame <= 3 || (nav_but.currentFrame >= 9 && nav_but.currentFrame <=11)) {
							nav_but.gotoAndPlay(12);
						} else if (nav_but.currentFrame >= 4 && nav_but.currentFrame <= 8) {
							nav_but.gotoAndPlay(16);
						}
						Tweener.addTween(nav_but, {_color:navButtonSelectedColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					} else {
						if (nav_but.currentFrame == 16) nav_but.gotoAndPlay(22);
						else if (nav_but.currentFrame == 22) nav_but.play();
						if (nav_but.currentFrame == 16 || nav_but.currentFrame == 22) {
							Tweener.addTween(nav_but, {_color:navButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
						}
					}
				}
				Tweener.addTween(controls, {delay:ON_ROLL_DURATION, onComplete:function(){controls_blocked = false;}});
			}
			
			// *** Changing images and text
			for (var i=1; i<=itemsInRow; i++) {
				var index:uint = (page-1)*itemsInRow + (i-1);
				var container:Sprite = team.getChildByName("container"+i) as Sprite;
				var img:Sprite = container.getChildByName("img") as Sprite;
				var hover_icon:MovieClip = container.getChildByName("hover_icon") as MovieClip;
				var title:Sprite = container.getChildByName("title") as Sprite;
				var position:Sprite = container.getChildByName("position") as Sprite;
				var preloader:MovieClip;
				Tweener.removeTweens(img);
				Tweener.removeTweens(hover_icon);
				Tweener.removeTweens(title);
				Tweener.removeTweens(position);
				img.graphics.clear();
				img.alpha = title.alpha = position.alpha = 0;
				hover_icon.visible = false;
				if (container.getChildByName("preloader")) {
					preloader = container.getChildByName("preloader") as MovieClip;
					Tweener.removeTweens(preloader);
					container.removeChild(preloader);
				}
				var imageLoader:Loader = this["imageLoader"+i];
				imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoadComplete);
				imageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
				try { imageLoader.close(); }
				catch(error:Error){};
				imageLoader.unload();
				
				if (index < teamArray.length) {
					container.visible = true;
					if (teamArray[index].bmpData == undefined) {
						if (teamArray[index].imgSrc != undefined) {
							if (!isNaN(imagePreloaderColor) && !isNaN(imagePreloaderAlpha)) {
								preloader = new img_preloader();
								preloader.name = "preloader";
								container.addChild(preloader);
								preloader.x = Math.round((item_width-preloader.width)/2);
								preloader.y = Math.round((item_height-preloader.height)/2);
								var preloaderColor:ColorTransform = preloader.transform.colorTransform;
								preloaderColor.color = imagePreloaderColor;
								preloader.transform.colorTransform = preloaderColor;
								preloader.alpha = imagePreloaderAlpha;
							}
							imageLoader.name = "imageLoader_"+index+"_"+i;
							imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadComplete);
							imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
							imageLoader.load(new URLRequest(teamArray[index].imgSrc+(killCachedFiles?killcache_str:'')));
						} else {
							teamArray[index].bmpData = "no";
						}
					} else {
						drawImage(container, teamArray[index].bmpData, index);
					}
					drawText(container, index);
				} else {
					container.visible = false;
				}
			}
		}
		
	/****************************************************************************************************/
	//	Functions. Handles events on team item image loading.
		
		private function imageLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, imageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
			var index_arr:Array = e.target.loader.name.split("_");
			var index:uint = index_arr[1];
			var container_index:uint = index_arr[2];
			var container:Sprite = team.getChildByName("container"+container_index) as Sprite;
			if (container.visible == true) {
				var preloader:MovieClip = container.getChildByName("preloader") as MovieClip;
				if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.7*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[container, preloader]});
				var bmp:Bitmap = Bitmap(e.target.content);
				bmp.smoothing = true;
				var bmpData:BitmapData = bmp.bitmapData;
				if (teamArray[index].bmpData == undefined) teamArray[index].bmpData = bmpData;
				drawImage(container, bmpData, index);
			}
		}
		
		private function imageLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, imageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
			var index_arr:Array = e.target.loader.name.split("_");
			var index:uint = index_arr[1];
			var container_index:uint = index_arr[2];
			var container:Sprite = team.getChildByName("container"+container_index) as Sprite;
			if (container.visible == true) {
				var preloader:MovieClip = container.getChildByName("preloader") as MovieClip;
				if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.7*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[container, preloader]});
				if (teamArray[index].bmpData == undefined) teamArray[index].bmpData = "no";
			}
		}
		
		
	/****************************************************************************************************/
	//	Function. Removes an image preloader.
		
		private function removeImagePreloader(container:Sprite, preloader:MovieClip):void {
			container.removeChild(preloader);
			preloader = null;
		}
		
	/****************************************************************************************************/
	//	Function. Draws an image on a specified container.
		
		private function drawImage(container:Sprite, bmpData:*, index:uint):void {
			var img:Sprite = container.getChildByName("img") as Sprite;
			if (bmpData != "no") {
				var bmp_matrix:Matrix = new Matrix();
				if (bmpData.width != itemWidth || bmpData.height != itemHeight) {
					var sx:Number = itemWidth/bmpData.width;
					var sy:Number = itemHeight/bmpData.height;
					bmp_matrix.scale(Math.max(sx,sy), Math.max(sx,sy));
					if (sy > sx) bmp_matrix.tx = -0.5*(bmpData.width*sy-itemWidth);
					if (sx > sy) bmp_matrix.ty = -0.5*(bmpData.height*sx-itemHeight);
				}
				with (img.graphics) {
					beginBitmapFill(bmpData, bmp_matrix, true, true);
					lineTo(itemWidth, 0);
					lineTo(itemWidth, itemHeight);
					lineTo(0, itemHeight);
					lineTo(0, 0);
					endFill();
				}
				Tweener.addTween(img, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
			}
			
			var hover_icon:MovieClip = container.getChildByName("hover_icon") as MovieClip;
			hover_icon.alpha = imageLinkIconAlpha;
			hover_icon.x = Math.round((item_width-hover_icon.width)/2);
			hover_icon.y = Math.round((item_height-hover_icon.height)/2);
			if (imageOverBrightness != 0 || imageLinkIconAlpha != 0 || imageLinkIconOverAlpha != 0) {
				Image.drawCaption(container, 0, 0, null, null, null, NaN, NaN, false, NaN, 0, null, imageOverBrightness, 0.6, "hover_icon", imageLinkIconOverAlpha, imageLinkIconAlpha);
			}
			
			img.buttonMode = false;
			img.removeEventListener(MouseEvent.CLICK, imgClickListener);
			if (teamArray[index].clickLink != undefined) {
				img.buttonMode = true;
				img.addEventListener(MouseEvent.CLICK, imgClickListener);
				hover_icon.visible = true;
			}
		}
		
	/****************************************************************************************************/
	//	Function. Image click listener.
	
		private function imgClickListener(e:MouseEvent):void {
			var container_index:uint = uint(e.target.parent.name.substr(9));
			var index:uint = (current_page-1)*itemsInRow + (container_index-1);
			var link:String = teamArray[index].clickLink;
			var target:String = teamArray[index].clickTarget;
			if (target == null) target = "_blank";
			if (link == "#") SWFAddress.setValue("/");
			else {
				if (link.substr(0, 1) == "#") SWFAddress.setValue(link.substr(1));
				else {
					try { navigateToURL(new URLRequest(link), target); }
					catch (e:Error) { }
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Creates text content on a specified container.
		
		private function drawText(container:Sprite, index:uint):void {
			var title:Sprite = container.getChildByName("title") as Sprite;
			var tf1:TextField = title.getChildByName("tf") as TextField;
			var position:Sprite = container.getChildByName("position") as Sprite;
			var tf2:TextField = position.getChildByName("tf") as TextField;
			if (teamArray[index].title != undefined) tf1.htmlText = teamArray[index].title;
			else tf1.htmlText = "";
			tf2.autoSize = TextFieldAutoSize.LEFT;
			if (teamArray[index].position != undefined) {
				tf2.htmlText = teamArray[index].position;
				tf2.height += TEXT_LEADING; // disables TextField scrolling on selection (also is a workaround for "jumpy htmlText hyperlinks")
				tf2.autoSize = TextFieldAutoSize.NONE;
			}
			else tf2.htmlText = "";
			position.y = title.y + (tf1.htmlText != ""?Math.ceil(title.height)+personNameBottomPadding:0);
			Tweener.addTween(title, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
			Tweener.addTween(position, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
			var blocks:Sprite = createBlocks(container, index);
			Tweener.addTween(blocks, {alpha:1, time:FADE_DURATION, transition:"easeInOutQuad"});
		}
		
	/****************************************************************************************************/
	//	Function. Creates text blocks, lists and links on a specified container.
		
		private function createBlocks(container:Sprite, index:uint):Sprite {
			var container_index:uint = uint(container.name.substr(9));
			var blocks:Sprite;
			if (container.getChildByName("blocks") != null) {
				// Destroy scroller
				if (this["scrollerObj"+container_index]) {
					this["scrollerObj"+container_index].destroyScroller();
					this["scrollerObj"+container_index] = null;
				}
				blocks = container.getChildByName("blocks") as Sprite;
				Tweener.removeTweens(blocks);
				container.removeChild(blocks);
			}
			container.addChild(blocks = new Sprite());
			blocks.name = "blocks";
			blocks.alpha = 0;
			var position:Sprite = container.getChildByName("position") as Sprite;
			var tf:TextField = position.getChildByName("tf") as TextField;
			var blocks_yPos:uint = position.y;
			if (tf.htmlText != "") {
				blocks_yPos += Math.ceil(position.height) + personPositionBottomPadding;
				blocks_yPos -= TEXT_LEADING; // original height of the text field
				var metrics:TextLineMetrics = tf.getLineMetrics(1);
				if (metrics.height == 0) blocks_yPos -= TEXT_LEADING; // fix for a one-line text block
			}
			blocks.y = blocks_yPos;
			var block_yPos:uint = 0;
			var blocksArray:Array = teamArray[index].blocks;
			if (blocksArray != null) {
				for (var i=0; i<blocksArray.length; i++) {
					if (blocksArray[i].type == "text") block_yPos = buildTextBlock(blocks, blocksArray, block_yPos, i);
					if (blocksArray[i].type == "list") block_yPos = buildList(blocks, blocksArray, block_yPos, i);
					if (blocksArray[i].type == "link") block_yPos = buildLink(blocks, blocksArray, block_yPos, i);
				}
			}
			attachScroller(blocks, blocks_yPos, index); // attach a scroller to the blocks content
			return blocks;
		}
	
	/****************************************************************************************************/
	//	Function. Attaches a scroller to the blocks content.
		
		private function attachScroller(blocks:Sprite, blocks_yPos:uint, index:uint):void {
			var container_index:uint = uint(blocks.parent.name.substr(9));
			var hitarea:Sprite = new Sprite();
			blocks.addChild(hitarea);
			blocks.hitArea = hitarea;
			hitarea.mouseEnabled = false;
			var mask_w:uint = item_width;
			if (__root != null) {
				var mask_h:uint = stage.stageHeight - __root.page_content.y - __root.module_container.y - team.y - blocks.y - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
				Geom.drawRectangle(hitarea, mask_w, blocks.height, 0xFF9900, 0);
				this["scrollerObj"+container_index] = new Scroller(blocks,
										  							mask_w,
																	mask_h,
																	scrollBarTrackWidth,
																	scrollBarTrackColor,
																	scrollBarTrackAlpha,
																	scrollBarSliderOverWidth,
																	scrollBarSliderColor,
																	scrollBarSliderOverColor);
				stage.addEventListener(Event.RESIZE,
					function(e:Event) {
						if (main != null) {
							blocks.y = blocks_yPos;
							mask_h = stage.stageHeight - __root.page_content.y - __root.module_container.y - team.y - blocks.y - __root.footerHeight - __root.PAGE_BOTTOM_MARGIN;
							main.parent["scrollerObj"+container_index].onStageResized(mask_h);
						}
					}
				);
			} else {
				Geom.drawRectangle(hitarea, mask_w, blocks.height, 0xFF9900, 0);
				this["scrollerObj"+container_index] = new Scroller(blocks, mask_w, 300, scrollBarTrackWidth, scrollBarTrackColor, scrollBarTrackAlpha, scrollBarSliderOverWidth, scrollBarSliderColor, scrollBarSliderOverColor);
			}
		}		
		
	/****************************************************************************************************/
	//	Function. Builds a text block.
	
		private function buildTextBlock(blocks:Sprite, blocksArray:Array, block_yPos:uint, index:uint):uint {
			var container_index:uint = uint(blocks.parent.name.substr(9));
			var tf_max_width:uint;
			var block:Sprite = new Sprite();
			block.x = blocksArray[index].leftMargin;
			block.y = block_yPos + blocksArray[index].topMargin;
			blocks.addChild(block);
			tf_max_width = item_width - block.x;
			tf_max_width -= 10; // increase the spacing between the right edge of a text field and the scroll bar
			var tf:TextField = new TextField();
			block.addChild(tf);
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.width = tf_max_width;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.embedFonts = true;
			tf.selectable = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.mouseWheelEnabled = false;
			var oneline_fix:uint = 0;
			if (blocksArray[index].text != undefined) {
				tf.htmlText = blocksArray[index].text;
				tf.height += TEXT_LEADING; // disables TextField scrolling on selection (also is a workaround for "jumpy htmlText hyperlinks")
				tf.autoSize = TextFieldAutoSize.NONE;
				var metrics:TextLineMetrics = tf.getLineMetrics(1);
				if (metrics.height == 0) oneline_fix = TEXT_LEADING; // fix for a one-line text block
			}
			var block_height:uint = Math.ceil(block.height) - TEXT_LEADING - oneline_fix; // original height of the block
			block_yPos += blocksArray[index].topMargin + block_height;
			return block_yPos;
		}
		
	/****************************************************************************************************/
	//	Function. Builds a list.
	
		private function buildList(blocks:Sprite, blocksArray:Array, block_yPos:uint, index:uint):uint {
			var container_index:uint = uint(blocks.parent.name.substr(9));
			var tf_max_width:uint;
			var block:Sprite = new Sprite();
			block.x = blocksArray[index].leftMargin;
			block.y = block_yPos + blocksArray[index].topMargin;
			tf_max_width = item_width - block.x - listItemLeftPadding;
			tf_max_width -= 10; // increase the spacing between the right edge of a text field and the scroll bar
			blocks.addChild(block);
			
			var tf:TextField;
			var tf_yPos:uint = 0;;
			var listitem:Sprite, marker:Sprite;
			var oneline_fix:uint = 0;
			for (var i=0; i<blocksArray[index].items.length; i++) {
				listitem = new Sprite();
				block.addChild(listitem);
				tf = new TextField();
				listitem.addChild(tf);
				if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
				tf.width = tf_max_width;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.multiline = true;
				tf.wordWrap = true;
				tf.embedFonts = true;
				tf.selectable = true;
				tf.antiAliasType = AntiAliasType.ADVANCED;
				tf.mouseWheelEnabled = false;
				if (blocksArray[index].items[i] != undefined) {
					tf.htmlText = blocksArray[index].items[i];
					tf.height += TEXT_LEADING; // disables TextField scrolling on selection (also is a workaround for "jumpy htmlText hyperlinks")
					tf.autoSize = TextFieldAutoSize.NONE;
				}
				var metrics:TextLineMetrics = tf.getLineMetrics(1);
				listitem.x = listItemLeftPadding;
				listitem.y = tf_yPos;
				
				// *** List item marker loading
				if (listItemMarkerURL != null) {
					marker = new Sprite();
					block.addChild(marker);
					Geom.drawRectangle(marker, listItemLeftPadding, 0, 0xFFFFFF, 0); // this is only for setting the bounds of a marker sprite
					marker.y = tf_yPos + listItemMarkerTopPadding;
					var markerLoader:Loader = new Loader();
					markerLoader.load(new URLRequest(listItemMarkerURL+(killCachedFiles?killcache_str:'')));
					marker.addChild(markerLoader);
					markerLoader.x = 3;
					if (blocksArray[index].markerColor != undefined) {
						var markerColor:ColorTransform = marker.transform.colorTransform;
						markerColor.color = blocksArray[index].markerColor;
						marker.transform.colorTransform = markerColor;
					}
				}
				// ***
				
				tf_yPos -= TEXT_LEADING; // subtract N px added to a text field height above
				tf_yPos += Math.ceil(tf.height) + listItemBottomPadding;
				if (metrics.height == 0) {
					tf_yPos -= TEXT_LEADING; // fix for a one-line list item
					if (i == blocksArray[index].items.length-1) oneline_fix = TEXT_LEADING;
				}
			}
			
			var block_height:uint = Math.ceil(block.height) - TEXT_LEADING - oneline_fix; // original height of the block
			block_yPos += blocksArray[index].topMargin + block_height;
			return block_yPos;
		}
		
	/****************************************************************************************************/
	//	Function. Builds a link block.
	
		private function buildLink(blocks:Sprite, blocksArray:Array, block_yPos:uint, index:uint):uint {
			var block:Sprite = new Sprite();
			block.x = blocksArray[index].leftMargin;
			block.y = block_yPos + blocksArray[index].topMargin;
			blocks.addChild(block);
			var tf:TextField = new TextField();
			block.addChild(tf);
			if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = false;
			tf.wordWrap = false;
			tf.embedFonts = true;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			if (blocksArray[index].text != undefined) tf.htmlText = blocksArray[index].text;
			if (blocksArray[index].align == "right") tf.x = blocksArray[index].leftPadding;
			
			// *** Link icon loading
			if (blocksArray[index].iconURL != null) {
				var icon:Sprite = new Sprite();
				block.addChild(icon);
				icon.y = blocksArray[index].iconTopPadding;
				var iconLoader:Loader = new Loader();
				iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,
					function(e:Event) {
						if (blocksArray[index].align == "left") iconLoader.x = Math.ceil(tf.width) + blocksArray[index].rightPadding - e.target.content.width;
						Geom.drawRectangle(block, Math.ceil(block.width), Math.ceil(block.height), 0xFFFFFF, 0);
					}
				);
				iconLoader.load(new URLRequest(blocksArray[index].iconURL+(killCachedFiles?killcache_str:'')));
				icon.addChild(iconLoader);
			}
			// ***
				
			if (blocksArray[index].color != undefined) {
				var linkColor:ColorTransform = block.transform.colorTransform;
				linkColor.color = blocksArray[index].color;
				block.transform.colorTransform = linkColor;
			}
			block.buttonMode = true;
			block.addEventListener(MouseEvent.ROLL_OVER,
				function(e:MouseEvent) {
					Tweener.removeTweens(block);
					Tweener.addTween(block, {_color:blocksArray[index].hoverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
				}
			);
			block.addEventListener(MouseEvent.ROLL_OUT,
				function(e:MouseEvent) {
					Tweener.removeTweens(block);
					Tweener.addTween(block, {_color:blocksArray[index].color, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
				}
			);
			if (blocksArray[index].clickLink != undefined) {
				var link:String = blocksArray[index].clickLink;
				var target:String = blocksArray[index].clickTarget;
				if (target == null) target = "_blank";
				block.addEventListener(MouseEvent.CLICK,
					function(e:MouseEvent) {
						if (link == "#") SWFAddress.setValue("/");
						else {
							if (link.substr(0, 1) == "#") SWFAddress.setValue(link.substr(1));
							else {
								try { navigateToURL(new URLRequest(link), target); }
								catch (e:Error) { }
							}
						}
					}
				);
			}
			block_yPos += blocksArray[index].topMargin + Math.ceil(block.height);
			return block_yPos;
		}

	/****************************************************************************************************/
	//	Function. Builds the controls - navigation buttons.
		
		private function createControls():void {
			main.addChild(controls = new Sprite());
			controls.y = controlsYPosition;
			var controls_xPos:uint;
			var button_xPos:uint = 0;
			
			for (var i=1; i<=Math.ceil(teamArray.length/itemsInRow); i++) {
				var nav_but:MovieClip = new nav_button();
				nav_but.name = "nav_but"+i;
				nav_but.x = button_xPos;
				nav_but.buttonMode = true;
				var navButColor:ColorTransform = nav_but.transform.colorTransform;
				navButColor.color = navButtonColor;
				nav_but.transform.colorTransform = navButColor;
				controls.addChild(nav_but);
				button_xPos += Math.ceil(nav_but.width) + BUTTON_SPACING;
				
				nav_but.addEventListener(MouseEvent.ROLL_OVER,
					function(e:MouseEvent) {
						var page:uint = e.target.name.substr(7);
						var nav_but:MovieClip = e.target as MovieClip;
						if (page != current_page && !controls_blocked) {
							nav_but.stop();
							if (nav_but.currentFrame < 6) nav_but.play();
							if (nav_but.currentFrame > 6 && nav_but.currentFrame <= 11) {
								nav_but.gotoAndPlay(12-nav_but.currentFrame);
							}
						}
					}
				);
				nav_but.addEventListener(MouseEvent.ROLL_OUT,
					function(e:MouseEvent) {
						var page:uint = e.target.name.substr(7);
						var nav_but:MovieClip = e.target as MovieClip;
						if (page != current_page && !controls_blocked) {
							nav_but.stop();
							if (nav_but.currentFrame >= 6) nav_but.play();
							if (nav_but.currentFrame < 6) {
								nav_but.gotoAndPlay(12-nav_but.currentFrame);
							}
						}
					}
				);
				nav_but.addEventListener(MouseEvent.CLICK,
					function(e:MouseEvent) {
						var page:uint = e.target.name.substr(7);
						var nav_but:MovieClip = e.target as MovieClip;
						if (page != current_page && !controls_blocked) {
							controls_blocked = true;
							current_page = page;
							changeItems(current_page);
						}
					}
				);
			}
			if (__root != null) controls_xPos = __root.templateWidth - __root.contentPageLeftMargin - __root.contentPageRightMargin - controlsRightMargin - controls.width;
			else controls_xPos = 980 - controlsRightMargin - controls.width;
			controls.x = controls_xPos;
		}
		
	/****************************************************************************************************/
	//	Function. Loads team items images one by one (in background mode).
		
		private function loadImgs():void {
			imgsLoader = new Loader();
			imgsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgsLoadProcessing);
			imgsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgsLoadError);
			for (var i=0; i<teamArray.length; i++) {
				if (teamArray[i].imgSrc != undefined) {
					if (teamArray[i].bmpData == undefined) {
						currentImgIndex = i;
						imgsLoader.load(new URLRequest(teamArray[i].imgSrc+(killCachedFiles?killcache_str:'')));
						break;
					}
				} else teamArray[i].bmpData = "no";
			}
		}
		
		private function imgsLoadProcessing(e:Event):void {
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			var bmpData:BitmapData = bmp.bitmapData;
			if (teamArray[currentImgIndex].bmpData == undefined) teamArray[currentImgIndex].bmpData = bmpData;
			currentImgIndex++;
			for (var i=currentImgIndex; i<teamArray.length; i++) {
				if (teamArray[i].bmpData != undefined) {
					currentImgIndex++;
				} else {
					if (teamArray[i].imgSrc != undefined) {
						imgsLoader.load(new URLRequest(teamArray[i].imgSrc+(killCachedFiles?killcache_str:'')));
						break;
					} else {
						teamArray[i].bmpData = "no";
						currentImgIndex++;
					}
				}
			}
			if (currentImgIndex >= teamArray.length) {
				e.target.removeEventListener(Event.COMPLETE, imgsLoadProcessing);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, imgsLoadError);
			}
		}
		
		private function imgsLoadError(e:IOErrorEvent):void {
			teamArray[currentImgIndex].bmpData = "no";
			currentImgIndex++;
			for (var i=currentImgIndex; i<teamArray.length; i++) {
				if (teamArray[i].bmpData != undefined) {
					currentImgIndex++;
				} else {
					if (teamArray[i].imgSrc != undefined) {
						imgsLoader.load(new URLRequest(teamArray[i].imgSrc+(killCachedFiles?killcache_str:'')));
						break;
					} else {
						teamArray[i].bmpData = "no";
						currentImgIndex++;
					}
				}
			}
			if (currentImgIndex >= teamArray.length) {
				e.target.removeEventListener(Event.COMPLETE, imgsLoadProcessing);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, imgsLoadError);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Performs a number of actions for deactivating the module.
	//	Called from the pageContentClosed() function of the WebsiteTemplate class.

		public function killModule():void {
			
			Utils.removeTweens(main);
			for (var i=1; i<=8; i++) {
				if (this["scrollerObj"+i]) {
					this["scrollerObj"+i].destroyScroller();
					this["scrollerObj"+i] = null;
				}
			}
			if (main != null) {
				removeChild(main);
				main = null;
			}
		}
		
	/****************************************************************************************************/
	
	}
}