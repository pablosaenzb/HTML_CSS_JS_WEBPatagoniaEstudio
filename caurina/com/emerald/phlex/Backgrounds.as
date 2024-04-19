/**
	Backgrounds class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Loader;
	import flash.display.Bitmap;
    import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import com.emerald.phlex.utils.Geom;
	import caurina.transitions.*;
	import flash.sampler.Sample;

	public class Backgrounds {
		
		private var __root:WebsiteTemplate;
		private var __stage:Stage;
		private var bodyBgImgsLoader:Loader, bodyBgImageLoader:Loader;
		private var currentImgIndex:uint;
		private var bmp_matrix:Matrix;
		public var loading_in_bg_mode:Boolean = true;
		private static const TRANSITION_DURATION:Number = 1.0;
		private static const DELAY_DURATION:Number = 0.5;
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function Backgrounds(obj:WebsiteTemplate):void {
			__root = obj; // a reference to the object of the WebsiteTemplate class
			__stage = __root.stage as Stage; // a reference to the object of the Stage class
			
			// Single background image loader
			bodyBgImageLoader = new Loader();
			bodyBgImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bodyBgImageLoadComplete);
			bodyBgImageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, bodyBgImageLoadProgress);
			bodyBgImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bodyBgImageLoadError);
		}
		
	/****************************************************************************************************/
	//	Function. Builds containers for body background images.

		public function createBodyBgContainers():void {
			var container:Sprite;
			var container_mask:Shape;
			for (var i=0; i<__root.pagesArray.length; i++) {
				container = new Sprite();
				container.name = "container"+(i+1);
				container_mask = new Shape();
				container_mask.name = "mask"+(i+1);
				__root.body_bg.addChild(container_mask);
				__root.body_bg.addChild(container);
				container.alpha = 0;
				//container.mask = container_mask; // mask is not used
			}
		}
	
	/****************************************************************************************************/
	//	Function. Searches the nearest item in the menu hierarchy that has a body background image.

		private function nearestBodyBgImage(index:uint):uint {
			var nearest_index:uint;
			var parentIndex:Number;
			if (__root.pagesArray[index].bodyBgImage != undefined && __root.pagesArray[index].bmpData != "no") {
				nearest_index = index;
			} else {
				if (__root.pagesArray[index].bodyBgImage == undefined) __root.pagesArray[index].bmpData = "no";
				parentIndex = Number(__root.pagesArray[index].parentIndex);
				if (!isNaN(parentIndex)) {
					if (__root.pagesArray[parentIndex].bodyBgImage != undefined && __root.pagesArray[parentIndex].bmpData != "no") {
						nearest_index = parentIndex;
					} else {
						if (__root.pagesArray[parentIndex].bodyBgImage == undefined) __root.pagesArray[parentIndex].bmpData = "no";
						parentIndex = Number(__root.pagesArray[parentIndex].parentIndex);
						if (!isNaN(parentIndex)) {
							if (__root.pagesArray[parentIndex].bodyBgImage != undefined && __root.pagesArray[parentIndex].bmpData != "no") {
								nearest_index = parentIndex;
							} else {
								if (__root.pagesArray[parentIndex].bodyBgImage == undefined) __root.pagesArray[parentIndex].bmpData = "no";
								nearest_index = index;
							}
						} else {
							nearest_index = index;
						}
					}
				} else {
					nearest_index = index;
				}
			}
			return nearest_index;
		}
	
	/****************************************************************************************************/
	//	Function. Loads a single body background image.
	
		public function loadBodyBgImage(index:uint):void {
			try { bodyBgImageLoader.close(); }
			catch(error:Error){};
			bodyBgImageLoader.unload();
			var bg_index:uint = nearestBodyBgImage(index);
			
			// *** This performs only on the first call of the function
			if (!__root.menu_initialized) {
				if (__root.showPreloader && __root.preloaderAlpha > 0) {
					var tf:TextField = new TextField();
					tf.name = "tf";
					__root.preloader.addChild(tf);
					if (__root.textStyleSheet != null) tf.styleSheet = __root.textStyleSheet;
					tf.autoSize = TextFieldAutoSize.LEFT;
					tf.multiline = false;
					tf.wordWrap = false;
					tf.embedFonts = true;
					tf.selectable = false;
					tf.antiAliasType = AntiAliasType.ADVANCED;
					tf.alpha = __root.preloaderAlpha;
				}
			}
			// ***
			
			if (__root.pagesArray[bg_index].bmpData == undefined) {
				// changing a background (with prior loading of an image)
				try {
					bodyBgImageLoader.name = "bodyBgImageLoader_"+index+"_"+bg_index;
					bodyBgImageLoader.load(new URLRequest(__root.pagesArray[bg_index].bodyBgImage+(__root.killCachedFiles?__root.killcache_str:'')));
					if (__root.showPreloader) __root.displayPreloader(true);
				} catch (error:Error) {
					__root.pagesArray[bg_index].bmpData = "no";
					changeBodyBgImage(index, bg_index);
				}
			} else if (__root.pagesArray[bg_index].bmpData == "no") {
				// changing a background (no image data found)
				changeBodyBgImage(index, bg_index);
			} else {
				// changing a background (image is already loaded and processed)
				changeBodyBgImage(index, bg_index);
			}
		}
	
		private function bodyBgImageLoadComplete(e:Event):void {
			var index_arr:Array = e.target.loader.name.split("_");
			var pageIndex:uint = index_arr[1];
			var loadingImageIndex:uint = index_arr[2];
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			var bmpData:BitmapData = bmp.bitmapData;
			if (__root.pagesArray[loadingImageIndex].bmpData == undefined) {
				__root.pagesArray[loadingImageIndex].bmpData = bmpData;
				var container:Sprite = __root.body_bg.getChildByName("container"+(loadingImageIndex+1)) as Sprite;
				container.addChild(bmp);
				var container_mask:Shape = __root.body_bg.getChildByName("mask"+(loadingImageIndex+1)) as Shape;
				Geom.drawRectangle(container_mask, container.width, container.height, 0xFF9900, 0);
				container.alpha = 0;
				//container_mask.height = 0; // mask is not used
				changeBodyBgImage(pageIndex, loadingImageIndex);
			}
		}
		
		private function bodyBgImageLoadProgress(e:ProgressEvent):void {
			if (__root.showPreloader && __root.preloaderAlpha > 0) {
				var tf:TextField = __root.preloader.getChildByName("tf") as TextField;
				tf.htmlText = "<preloader>" + Math.ceil(100*e.bytesLoaded/e.bytesTotal) + "</preloader>";
				tf.x = -Math.round(tf.width/2);
				tf.y = -Math.round(tf.height/2);
			}
		}
		
		private function bodyBgImageLoadError(e:IOErrorEvent):void {
			var index_arr:Array = e.target.loader.name.split("_");
			var pageIndex:uint = index_arr[1];
			var loadingImageIndex:uint = index_arr[2];
			__root.pagesArray[loadingImageIndex].bmpData = "no";
			changeBodyBgImage(pageIndex, loadingImageIndex);
		}
	
	/****************************************************************************************************/
	//	Function. Loads body background images one by one (in background mode).

		public function loadBodyBgImgs():void {
			bodyBgImgsLoader = new Loader();
			bodyBgImgsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bodyBgImgsLoadProcessing);
			bodyBgImgsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bodyBgImgsLoadError);
			for (var i=0; i<__root.pagesArray.length; i++) {
				if (__root.pagesArray[i].bodyBgImage != undefined) {
					if (__root.pagesArray[i].bmpData == undefined) {
						currentImgIndex = i;
						bodyBgImgsLoader.load(new URLRequest(__root.pagesArray[i].bodyBgImage+(__root.killCachedFiles?__root.killcache_str:'')));
						break;
					}
				} else {
					__root.pagesArray[i].bmpData = "no";
				}
			}
		}
		
		private function bodyBgImgsLoadProcessing(e:Event):void {
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			var bmpData:BitmapData = bmp.bitmapData;
			if (__root.pagesArray[currentImgIndex].bmpData == undefined) {
				__root.pagesArray[currentImgIndex].bmpData = bmpData;
				var container:Sprite = __root.body_bg.getChildByName("container"+(currentImgIndex+1)) as Sprite;
				container.addChild(bmp);
				var container_mask:Shape = __root.body_bg.getChildByName("mask"+(currentImgIndex+1)) as Shape;
				Geom.drawRectangle(container_mask, container.width, container.height, 0xFF9900, 0);
				container.alpha = 0;
				//container_mask.height = 0; // mask is not used
			}
			currentImgIndex++;
			for (var i=currentImgIndex; i<__root.pagesArray.length; i++) {
				if (__root.pagesArray[i].bmpData != undefined) {
					currentImgIndex++;
				} else {
					if (__root.pagesArray[i].bodyBgImage != undefined) {
						bodyBgImgsLoader.load(new URLRequest(__root.pagesArray[i].bodyBgImage+(__root.killCachedFiles?__root.killcache_str:'')));
						break;
					} else {
						__root.pagesArray[i].bmpData = "no";
						currentImgIndex++;
					}
				}
			}
			if (currentImgIndex >= __root.pagesArray.length) {
				e.target.removeEventListener(Event.COMPLETE, bodyBgImgsLoadProcessing);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, bodyBgImgsLoadError);
			}
		}
		
		private function bodyBgImgsLoadError(e:IOErrorEvent):void {
			__root.pagesArray[currentImgIndex].bmpData = "no";
			currentImgIndex++;
			for (var i=currentImgIndex; i<__root.pagesArray.length; i++) {
				if (__root.pagesArray[i].bmpData != undefined) {
					currentImgIndex++;
				} else {
					if (__root.pagesArray[i].bodyBgImage != undefined) {
						bodyBgImgsLoader.load(new URLRequest(__root.pagesArray[i].bodyBgImage+(__root.killCachedFiles?__root.killcache_str:'')));
						break;
					} else {
						__root.pagesArray[i].bmpData = "no";
						currentImgIndex++;
					}
				}
			}
			if (currentImgIndex >= __root.pagesArray.length) {
				e.target.removeEventListener(Event.COMPLETE, bodyBgImgsLoadProcessing);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, bodyBgImgsLoadError);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Changes the current body background image (with/without a transition effect).
	
		private function changeBodyBgImage(page_index:uint, bg_index:uint):void {
			
			__root.menu_blocked = true;
			if (__root.showPreloader && __root.preloader.alpha > 0) __root.displayPreloader(false);
			
			// *** This performs only on the first call of the function
			if (!__root.menu_initialized) {
				__root.createHeader();
				__root.createBody();
				__root.createPage();
				__root.footerObj.createFooter();
			}
			// ***
			
			var new_bg_index:uint = bg_index;
			var new_container:Sprite = __root.body_bg.getChildByName("container"+(new_bg_index+1)) as Sprite;
			var old_container:Sprite = __root.body_bg.getChildAt(__root.body_bg.numChildren-1) as Sprite;
			var old_bg_index:uint = Number(old_container.name.substr(9))-1;
			var newBmpData:*, oldBmpData:*, diffBmpData:*;
			newBmpData = __root.pagesArray[new_bg_index].bmpData;
			oldBmpData = __root.pagesArray[old_bg_index].bmpData;
			
			Tweener.removeTweens(new_container);
			Tweener.removeTweens(old_container);
			new_container.alpha = 0;
			__root.body_bg.setChildIndex(new_container, __root.body_bg.numChildren-1);
			fitBodyBgImages();
			
			if (newBmpData != "no" && oldBmpData != "no") {
				if (oldBmpData == undefined) {
					Tweener.addTween(new_container, {alpha:1, time:TRANSITION_DURATION, transition:"easeInSine"});
					// call the loadModule() function of the WebsiteTemplate class
					Tweener.addTween(this, {delay:DELAY_DURATION, onComplete:__root.loadModule, onCompleteParams:[page_index]});
				} else {
					diffBmpData = newBmpData.compare(oldBmpData)
					if (diffBmpData as Number == 0) {
						new_container.alpha = 1;
						__root.loadModule(page_index); // call the loadModule() function of the WebsiteTemplate class
					} else {
						Tweener.addTween(new_container, {alpha:1, time:TRANSITION_DURATION, transition:"easeInSine"});
						// call the loadModule() function of the WebsiteTemplate class
						Tweener.addTween(this, {delay:DELAY_DURATION, onComplete:__root.loadModule, onCompleteParams:[page_index]});
					}
				}
			} else {
				Tweener.addTween(new_container, {alpha:1, time:TRANSITION_DURATION, transition:"easeInSine"});
				// call the loadModule() function of the WebsiteTemplate class
				Tweener.addTween(this, {delay:DELAY_DURATION, onComplete:__root.loadModule, onCompleteParams:[page_index]});
			}
		}

	/****************************************************************************************************/
	//	Function. Fits the body background image to the size of the Stage (the upper image and the one under it).
	
		public function fitBodyBgImages():void {
			var img_num:uint = 0;
			var index:uint;
			var stage_ratio:Number, image_ratio:Number;
			var child:*;
			var container:Sprite;
			var bmpData:BitmapData;
			var stageWidth:uint = __stage.stageWidth;
			var stageHeight:uint = __stage.stageHeight - (__root.bodyBgImageFullStage?0:__root.headerHeight+__root.footerHeight);
			
			for (var i=__root.body_bg.numChildren-1; i>=0; i--) {
				child = __root.body_bg.getChildAt(i);
				if (child.name.substr(0,9) == "container") container = child;
				if (container.width > 0 && container.height > 0) {
					img_num++;
					index = uint(container.name.substr(9))-1;
					bmpData = __root.pagesArray[index].bmpData;
					stage_ratio = stageWidth/stageHeight;
					image_ratio = bmpData.width/bmpData.height;
					if (stage_ratio >= image_ratio) {
						container.width = stageWidth;
						container.height = Math.round(container.width/image_ratio);
					} else {
						container.height = stageHeight;
						container.width = Math.round(container.height*image_ratio);
					}
				}
				if (img_num == 2) break;
			}
		}
		
	}
}