/**
	Menu class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.portfolio {
	
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
	import flash.utils.getTimer;
	import com.emerald.phlex.utils.Geom;
	import com.emerald.phlex.utils.Image;
	import com.emerald.phlex.utils.Utils;
	import caurina.transitions.*;
	import caurina.transitions.properties.ColorShortcuts;

	public class ThumbnailBar extends Sprite {
		
		private var __root:*;
		private var projectIndex:uint;
		private var mediaArray:Array
		private var tnbar:Sprite;
		private var tnbar_visarea_width:uint;
		private var tn_width:uint, tn_height:uint;
		private var navBut1Loader:Loader, navBut2Loader:Loader;
		private static const FADE_DURATION:Number = 0.7;
		private static const ON_ROLL_DURATION:Number = 0.2;
		private static const MOVE_DURATION:Number = 0.5;
		private static const NAV_BUTTON_ICON_PADDING:uint = 8;
		
		// Image Shadow
		private var imageShadowBlur:uint = 8;
		private var imageShadowStrength:uint = 1;
		private var imageShadowQuality:uint = 2;
		
		ColorShortcuts.init();	// initiates the ColorShortcuts special properties of the Tweener class
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function ThumbnailBar(obj:*, index:uint, media_array:Array):void {
			__root = obj; // a reference to the object of the main class
			projectIndex = index;
			mediaArray = media_array;
			createThumbnailBar();
		}
	
	/****************************************************************************************************/
	//	Function. Builds the thumbnail bar.
	
		private function createThumbnailBar():void {
			__root.project.addChild(tnbar = new Sprite());
			tnbar.name = "tnbar";
			tnbar.alpha = 0;
			var container_mask:Sprite = new Sprite();
			container_mask.name = "container_mask";
			container_mask.visible = false;
			tnbar.addChild(container_mask);
			var container:Sprite = new Sprite();
			container.name = "container";
			tnbar.addChild(container);
			container.cacheAsBitmap = container_mask.cacheAsBitmap = true;
			
			var border_thickness:uint = 0;
			if (__root.thumbnailBorderThickness > 0) border_thickness = __root.thumbnailBorderThickness;
			tn_width = __root.thumbnailWidth + 2*border_thickness;
			tn_height = __root.thumbnailHeight + 2*border_thickness;
			tnbar_visarea_width = tn_width*Math.min(__root.thumbnailsVisible, mediaArray.length) + __root.thumbnailSpacing*(Math.min(__root.thumbnailsVisible, mediaArray.length)-1);
			tnbar.y = __root.projectHeaderHeight + __root.bigImageHeight + __root.thumbnailsTopMargin;
			
			// Teasers mask
			var mask_y_offset:uint = 20;
			var gradient_left:MovieClip = new grad_mask_left();
			var gradient_right:MovieClip = new grad_mask_right();
			gradient_left.height = gradient_right.height = tn_height + 2*mask_y_offset;
			container_mask.addChild(gradient_left);
			container_mask.addChild(gradient_right);
			var mask_width_add:int = 2*(__root.thumbnailSpacing - gradient_left.width);
			Geom.drawRectangle(container_mask, tnbar_visarea_width+mask_width_add, tn_height+2*mask_y_offset, 0xFF9900, 1, 0, 0, 0, 0, gradient_left.width, 0);
			gradient_right.x = gradient_left.width + tnbar_visarea_width + mask_width_add;
			container_mask.x = -gradient_left.width - 0.5*mask_width_add;
			container_mask.y = -mask_y_offset;
			
			if (mediaArray.length > 1 && __root.thumbnailsVisible > 0) {
				var thumbnail_xPos:uint = 0;
				var shadow_base:Shape, bg:Shape;
				var thumbnail:Sprite, img:Sprite, base:Sprite;
				if (!isNaN(__root.thumbnailShadowColor) && !isNaN(__root.thumbnailShadowAlpha)) {
					var df:DropShadowFilter = new DropShadowFilter();
					df.color = __root.thumbnailShadowColor;
					df.alpha = __root.thumbnailShadowAlpha;
					df.distance = 0;
					df.angle = 0;
					df.quality = imageShadowQuality;
					df.blurX = df.blurY = imageShadowBlur;
					df.strength = imageShadowStrength;
					df.knockout = true;
					var dfArray:Array = new Array();
					dfArray.push(df);
				}
				
				// *** Thumbnails
				for (var i=0; i<mediaArray.length; i++) {
					thumbnail = new Sprite();
					thumbnail.name = "thumbnail"+(i+1);
					thumbnail.x = thumbnail_xPos;
					thumbnail.y = 0;
					container.addChild(thumbnail);
					thumbnail.addChild(shadow_base = new Shape());
					shadow_base.name = "shadow_base";
					thumbnail.addChild(bg = new Shape());
					bg.name = "bg";
					thumbnail.addChild(img = new Sprite());
					img.name = "img";
					thumbnail.addChild(base = new Sprite());
					base.name = "base";
					if (!isNaN(__root.thumbnailBgColor) && !isNaN(__root.thumbnailBgAlpha)) {
						Geom.drawRectangle(bg, __root.thumbnailWidth, __root.thumbnailHeight, __root.thumbnailBgColor, __root.thumbnailBgAlpha);
					}
					if (!isNaN(__root.thumbnailShadowColor) && !isNaN(__root.thumbnailShadowAlpha)) {
						Geom.drawRectangle(shadow_base, __root.thumbnailWidth, __root.thumbnailHeight, 0xFFFFFF, 1);
						shadow_base.filters = dfArray;
					}
					if (__root.thumbnailBorderThickness > 0) {
						Geom.drawBorder(base, __root.thumbnailWidth, __root.thumbnailHeight, 0xFFFFFF, 1, __root.thumbnailBorderThickness, 0);
						if (!isNaN(__root.thumbnailBorderColor)) {
							var borderColor:ColorTransform = base.transform.colorTransform;
							borderColor.color = __root.thumbnailBorderColor;
							base.transform.colorTransform = borderColor;
						} else {
							base.alpha = 0;
						}
					} else { // this is only for setting the bounds of a thumbnail
						Geom.drawRectangle(base, __root.thumbnailWidth, __root.thumbnailHeight, 0xFFFFFF, 0);
					}
					bg.x = bg.y = img.x = img.y = base.x = base.y = border_thickness;
					
					if (mediaArray[i].tn != undefined) {
						base.mouseEnabled = false;
						if (!isNaN(__root.thumbnailPreloaderColor) && !isNaN(__root.thumbnailPreloaderAlpha)) {
							var preloader:MovieClip = new img_preloader();
							preloader.name = "preloader";
							thumbnail.addChild(preloader);
							preloader.x = Math.round((tn_width-preloader.width)/2);
							preloader.y = Math.round((tn_height-preloader.height)/2);
							var preloaderColor:ColorTransform = preloader.transform.colorTransform;
							preloaderColor.color = __root.thumbnailPreloaderColor;
							preloader.transform.colorTransform = preloaderColor;
							preloader.alpha = __root.thumbnailPreloaderAlpha;
						}
						var imageLoader:Loader = new Loader();
						imageLoader.name = "imageLoader"+(i+1);
						imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadComplete);
						imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
						imageLoader.load(new URLRequest(mediaArray[i].tn+(__root.killCachedFiles?__root.killcache_str:'')));
					} else if (mediaArray[i].src != undefined) {
						base.buttonMode = true;
						base.addEventListener(MouseEvent.CLICK,
							function(e:MouseEvent){
								var index:uint = e.target.parent.name.substr(9) - 1;
								if (index != __root.currentMediaIndex) {
									__root.currentMediaIndex = index;
									__root.changeMedia();
									changePushedThumbnail(index);
								}
							}
						);
					}
					thumbnail_xPos += tn_width + __root.thumbnailSpacing;
				}
				// ***
			}
			
			if (__root.thumbnailsLeftNavButtonURL != null && __root.thumbnailsRightNavButtonURL != null && mediaArray.length > __root.thumbnailsVisible && __root.thumbnailsVisible > 0) {
				var nav_but1:Sprite, nav_but2:Sprite;
				tnbar.addChild(nav_but1 = new Sprite());
				nav_but1.name = "nav_but1";
				tnbar.addChild(nav_but2 = new Sprite());
				nav_but2.name = "nav_but2";
				navBut1Loader = new Loader();
				navBut1Loader.name = "L";
				navBut1Loader.contentLoaderInfo.addEventListener(Event.COMPLETE, navButLoadComplete);
				navBut1Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
				navBut1Loader.load(new URLRequest(__root.thumbnailsLeftNavButtonURL+(__root.killCachedFiles?__root.killcache_str:'')));
				navBut2Loader = new Loader();
				navBut2Loader.name = "R";
				navBut2Loader.contentLoaderInfo.addEventListener(Event.COMPLETE, navButLoadComplete);
				navBut2Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
				navBut2Loader.load(new URLRequest(__root.thumbnailsRightNavButtonURL+(__root.killCachedFiles?__root.killcache_str:'')));
				container.mask = container_mask;
				container_mask.visible = true;
			} else {
				switch (__root.thumbnailsAlign) {
					case "left":
						tnbar.x = 0;
					break;
					case "center":
						tnbar.x = Math.round(0.5*(__root.bigImageWidth-tnbar_visarea_width)) + border_thickness;
					break;
					case "right":
						tnbar.x = __root.bigImageWidth + 2*border_thickness - tnbar_visarea_width;
				}
				Tweener.addTween(tnbar, {alpha:1, time:FADE_DURATION, transition:"easeOutQuint"});
			}
		}
		
	/****************************************************************************************************/
	//	Functions. Handles events on teaser image loading.
		
		private function imageLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, imageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
			var index:uint = e.target.loader.name.substr(11)-1;
			var bmp:Bitmap = Bitmap(e.target.content);
			var container:Sprite = tnbar.getChildByName("container") as Sprite;
			var thumbnail:Sprite = container.getChildByName("thumbnail"+(index+1)) as Sprite;
			var preloader:MovieClip = thumbnail.getChildByName("preloader") as MovieClip;
			if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.7*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[thumbnail, preloader]});
			var img:Sprite = thumbnail.getChildByName("img") as Sprite;
			img.alpha = 0;
			var bmpData:BitmapData;
			if (e.target.width != __root.thumbnailWidth || e.target.height != __root.thumbnailHeight) {
				bmp.smoothing = true;
				bmpData = bmp.bitmapData;
				var bmp_matrix:Matrix = new Matrix();
				var sx:Number = __root.thumbnailWidth/e.target.width;
				var sy:Number = __root.thumbnailHeight/e.target.height;
				bmp_matrix.scale(Math.max(sx,sy), Math.max(sx,sy));
				if (sy > sx) bmp_matrix.tx = -0.5*(e.target.width*sy-__root.thumbnailWidth);
				if (sx > sy) bmp_matrix.ty = -0.5*(e.target.height*sx-__root.thumbnailHeight);
				with (img.graphics) {
					beginBitmapFill(bmpData, bmp_matrix, true, true);
					lineTo(__root.thumbnailWidth, 0);
					lineTo(__root.thumbnailWidth, __root.thumbnailHeight);
					lineTo(0, __root.thumbnailHeight);
					lineTo(0, 0);
					endFill();
				}
			} else {
				img.addChild(bmp);
				bmpData = bmp.bitmapData;
			}
			
			// Thumbnail video icon
			if ((mediaArray[index].type == "video" || mediaArray[index].type == "youtube") && __root.thumbnailVideoIconSize > 0) {
				var video_icon:Shape = new Shape();
				img.addChild(video_icon);
				video_icon.name = "video_icon";
				video_icon.x = Math.round((__root.thumbnailWidth-__root.thumbnailVideoIconSize)/2);
				video_icon.y = Math.round((__root.thumbnailHeight-__root.thumbnailVideoIconSize)/2);
				video_icon.graphics.lineStyle(2, __root.thumbnailVideoIconColor, 1, true);
				video_icon.graphics.beginFill(0xFFFFFF, 0);
				video_icon.graphics.drawCircle(Math.round(__root.thumbnailVideoIconSize/2), Math.round(__root.thumbnailVideoIconSize/2), Math.floor(__root.thumbnailVideoIconSize/2));
				video_icon.graphics.endFill();
				var triangle_size:uint = __root.thumbnailVideoIconSize - 14;
				var triangle_height:uint = Math.round(0.5*triangle_size*Math.sqrt(3));
				var triangle_x:uint = Math.round((__root.thumbnailVideoIconSize-triangle_size/Math.sqrt(3))/2);
				var triangle_y:uint = Math.round((__root.thumbnailVideoIconSize-triangle_size)/2);
				video_icon.graphics.lineStyle(NaN, 0);
				video_icon.graphics.beginFill(__root.thumbnailVideoIconColor, 1);
				video_icon.graphics.moveTo(triangle_x, triangle_y);
				video_icon.graphics.lineTo(triangle_x, triangle_y+triangle_size);
				video_icon.graphics.lineTo(triangle_x+triangle_height, triangle_y+0.5*triangle_size);
				video_icon.graphics.lineTo(triangle_x, triangle_y);
				video_icon.graphics.endFill();
				video_icon.alpha = __root.thumbnailVideoIconAlpha;
			}
			Tweener.addTween(img, {alpha:1, time:FADE_DURATION, transition:"easeOutQuint"});
			Image.applyBrightness(img, __root.thumbnailOverBrightness, 0.6, "video_icon", __root.thumbnailVideoIconOverAlpha, __root.thumbnailVideoIconAlpha);
			
			if (mediaArray[index].src != undefined) {
				img.buttonMode = true;
				img.addEventListener(MouseEvent.CLICK,
					function(e:MouseEvent){
						if (index != __root.currentMediaIndex) {
							__root.currentMediaIndex = index;
							__root.changeMedia();
							changePushedThumbnail(index);
						}
					}
				);
			}
		}
		
		private function imageLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, imageLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
			var index:uint = e.target.loader.name.substr(11)-1;
			var container:Sprite = tnbar.getChildByName("container") as Sprite;
			var thumbnail:Sprite = container.getChildByName("thumbnail"+(index+1)) as Sprite;
			var preloader:MovieClip = thumbnail.getChildByName("preloader") as MovieClip;
			if (preloader) Tweener.addTween(preloader, {alpha:0, time:0.7*FADE_DURATION, transition:"easeOutQuint", onComplete:removeImagePreloader, onCompleteParams:[thumbnail, preloader]});
			var base:Sprite = thumbnail.getChildByName("base") as Sprite;
			
			if (mediaArray[index].src != undefined) {
				base.mouseEnabled = true;
				base.buttonMode = true;
				base.addEventListener(MouseEvent.CLICK,
					function(e:MouseEvent){
						if (index != __root.currentMediaIndex) {
							__root.currentMediaIndex = index;
							__root.changeMedia();
							changePushedThumbnail(index);
						}
					}
				);
			}
		}
		
		
	/****************************************************************************************************/
	//	Function. Removes an image preloader.
		
		private function removeImagePreloader(thumbnail:Sprite, preloader:MovieClip):void {
			thumbnail.removeChild(preloader);
		}
		
	/****************************************************************************************************/
	//	Functions. Handles events on navigation button loading.
		
		private function navButLoadComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, navButLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
			var button:String = e.target.loader.name;
			var index:uint = (button=="L"?1:2);
			var container:Sprite = tnbar.getChildByName("container") as Sprite;
			var container_mask:Shape = tnbar.getChildByName("container_mask") as Shape;
			var nav_but:Sprite = tnbar.getChildByName("nav_but"+index) as Sprite;
			var nav_but_other:Sprite = tnbar.getChildByName("nav_but"+(button=="L"?2:1)) as Sprite;
			var bmp:Bitmap = Bitmap(e.target.content);
			var hitarea:Sprite = new Sprite();
			nav_but.addChild(hitarea);
			Geom.drawRectangle(hitarea, bmp.width+2*NAV_BUTTON_ICON_PADDING, bmp.height+2*NAV_BUTTON_ICON_PADDING, 0xFF9900, 0);
			nav_but.hitArea = hitarea;
			nav_but.addChild(bmp);
			bmp.x = bmp.y = NAV_BUTTON_ICON_PADDING;
			if (button == "L") {
				nav_but.x = -(nav_but.width + __root.thumbnailsNavButtonPadding);
				nav_but.buttonMode = false;
			}
			if (button == "R") {
				nav_but.x = tnbar_visarea_width + __root.thumbnailsNavButtonPadding;
				nav_but.buttonMode = true;
			}
			nav_but.y = Math.round(0.5*(tn_height-bmp.height)) - NAV_BUTTON_ICON_PADDING;
			var navButColor:ColorTransform = nav_but.transform.colorTransform;
			navButColor.color = __root.thumbnailsNavButtonColor;
			nav_but.transform.colorTransform = navButColor;
			nav_but.alpha = button=="L"?0.7:1;
			var border_thickness:uint = 0;
			if (__root.thumbnailBorderThickness > 0) border_thickness = __root.thumbnailBorderThickness;
			if (nav_but.width > 0 && nav_but_other.width > 0) {
				switch (__root.thumbnailsAlign) {
					case "left":
						var nav_but_left:Sprite = tnbar.getChildByName("nav_but1") as Sprite;
						tnbar.x = Math.abs(nav_but_left.x);
					break;
					case "center":
						tnbar.x = Math.round(0.5*(__root.bigImageWidth-tnbar_visarea_width)) + border_thickness;
					break;
					case "right":
						var nav_but_right:Sprite = tnbar.getChildByName("nav_but2") as Sprite;
						tnbar.x = __root.bigImageWidth + 2*border_thickness - tnbar_visarea_width - nav_but_right.width - __root.thumbnailsNavButtonPadding;
				}
				Tweener.addTween(tnbar, {alpha:1, time:FADE_DURATION, transition:"easeOutQuint"});
			}
			
			nav_but.addEventListener(MouseEvent.ROLL_OVER,
				function(e:MouseEvent) {
					if (nav_but.alpha == 1) {
						Tweener.removeTweens(nav_but);
						Tweener.addTween(nav_but, {_color:__root.thumbnailsNavButtonOverColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
				}
			);
			nav_but.addEventListener(MouseEvent.ROLL_OUT,
				function(e:MouseEvent) {
					if (nav_but.alpha == 1) {
						Tweener.removeTweens(nav_but);
						Tweener.addTween(nav_but, {_color:__root.thumbnailsNavButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
				}
			);
			nav_but.addEventListener(MouseEvent.CLICK,
				function(e:MouseEvent) {
					var new_x:int;
					var end_point1:int = 0;
					var end_point2:int = Math.round(tnbar_visarea_width-container.width);
					if (button == "L") {
						if (Tweener.isTweening(container) == false) {
							new_x = Math.round(container.x + tn_width + __root.thumbnailSpacing);
							if (new_x <= end_point1) {
								if (new_x == end_point1) {
									nav_but.alpha = 0.7;
									nav_but.buttonMode = false;
									Tweener.addTween(nav_but, {_color:__root.thumbnailsNavButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
								}
								nav_but_other.alpha = 1;
								nav_but_other.buttonMode = true;
								Tweener.addTween(container, {x:new_x, time:MOVE_DURATION, transition:"easeInOutQuint"});
							}
						}
					}
					if (button == "R") {
						if (Tweener.isTweening(container) == false) {
							new_x = Math.round(container.x - tn_width - __root.thumbnailSpacing);
							if (new_x >= end_point2) {
								if (new_x == end_point2) {
									nav_but.alpha = 0.7;
									nav_but.buttonMode = false;
									Tweener.addTween(nav_but, {_color:__root.thumbnailsNavButtonColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
								}
								nav_but_other.alpha = 1;
								nav_but_other.buttonMode = true;
								Tweener.addTween(container, {x:new_x, time:MOVE_DURATION, transition:"easeInOutQuint"});
							}
						}
					}
				}
			);
		}
		
		private function navButLoadError(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, navButLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
			tnbar.x = Math.round(0.5*(__root.bigImageWidth-tnbar_visarea_width));
			Tweener.addTween(tnbar, {alpha:1, time:FADE_DURATION, transition:"easeOutQuint"});
		}
		
	/****************************************************************************************************/
	//	Function. Changes the state of a pushed thumbnail and the images counter.

		public function changePushedThumbnail(index:uint) {
			if (mediaArray.length > 1 && __root.thumbnailsVisible > 0) {
				for (var i=0; i<mediaArray.length; i++) {
					var container:Sprite = tnbar.getChildByName("container") as Sprite;
					var thumbnail:Sprite = container.getChildByName("thumbnail"+(i+1)) as Sprite;
					var base:Sprite = thumbnail.getChildByName("base") as Sprite;
					if (__root.thumbnailBorderThickness > 0) {
						var borderColor:ColorTransform;
						Tweener.removeTweens(base);
						if (i == index) {
							if (!isNaN(__root.thumbnailSelectedBorderColor)) {
								if (!isNaN(__root.thumbnailBorderColor)) {
									Tweener.addTween(base, {_color:__root.thumbnailSelectedBorderColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
								} else {
									borderColor = base.transform.colorTransform;
									borderColor.color = __root.thumbnailSelectedBorderColor;
									base.transform.colorTransform = borderColor;
									Tweener.addTween(base, {alpha:1, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
								}
							}
						} else {
							if (!isNaN(__root.thumbnailBorderColor)) {
								Tweener.addTween(base, {_color:__root.thumbnailBorderColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
							} else {
								Tweener.addTween(base, {alpha:0, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
							}
						}
					}
				}
			}
		}		
		
	/****************************************************************************************************/
	//	Function. Destroys the thumbnail bar.
	
		public function destroyThumbnailBar():void {
			Utils.removeTweens(tnbar);
			if (navBut1Loader) {
				navBut1Loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, navButLoadComplete);
				navBut1Loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
			}
			if (navBut2Loader) {
				navBut2Loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, navButLoadComplete);
				navBut2Loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, navButLoadError);
			}
			__root.project.removeChild(tnbar);
			tnbar = null;
		}
	}
}