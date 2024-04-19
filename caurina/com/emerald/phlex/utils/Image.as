/**
	Image class
	version 1.0.0
	17/09/2012
*/
	
package com.emerald.phlex.utils {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.ui.Mouse;
	import caurina.transitions.*;
	import caurina.transitions.properties.ColorShortcuts;
	
	public class Image extends Sprite {
		
		private static const BLUR_FILTER_QUALITY:uint = 2;
		private static const ON_ROLL_FADE_DURATION:Number = 0.6;
		private static const ON_ROLL_SLIDE_DURATION:Number = 0.4;
		private static const ROLLOVER_BRIGHTNESS:Number = 0.4;
		
		ColorShortcuts.init();	// initiates the ColorShortcuts special properties of the Tweener class
		
	/****************************************************************************************************/
	//	Function. Draws an image caption and defines its behaviour on rollover/rollout event.
	//			  Applies brightness to an object on rollover/rollout event.
	//			  (Optionally) Applies alpha transparency to an object's child.

		public static function drawCaption(obj:Sprite, img_w:uint, img_h:uint, imgBmpData:BitmapData, txt:String, stylesheet:StyleSheet, bg_color:Number, bg_alpha:Number, isBlurred:Boolean, blur_amount:Number, padding:uint, anim_type:String = "fade", brightness:Number = ROLLOVER_BRIGHTNESS, duration:Number = ON_ROLL_FADE_DURATION, child_name:String = null, alpha_over:Number = 1, alpha_out:Number = 1):void {
			
			var bg_width:uint = img_w;
			var bg_height:uint;
			var bmp_matrix:Matrix;
			var bmpData:BitmapData;
			var img:Sprite = obj.getChildByName("img") as Sprite;
			if (!img) img = obj.getChildByName("media") as Sprite; // for News and Portfolio modules
			var caption:Sprite = obj.getChildByName("caption") as Sprite;
			if (child_name) var child:* = obj.getChildByName(child_name);
			
			if (txt != null) {
				
				if (isBlurred && blur_amount > 0) {
					
					var blurred_bg:Sprite = obj.getChildByName("blurred_bg") as Sprite;
					var blurred_bg_mask:Shape = obj.getChildByName("blurred_bg_mask") as Shape;
					bmp_matrix = new Matrix();
					var blur_filter:BlurFilter = new BlurFilter();
					blur_filter.blurX = blur_filter.blurY = blur_amount;
					blur_filter.quality = BLUR_FILTER_QUALITY;
					bmpData = imgBmpData.clone();
					bmpData.applyFilter(bmpData, bmpData.rect, new Point(0, 0), blur_filter);
					
					if (bmpData.width != img_w || bmpData.height != img_h) {
						var sx:Number = img_w/bmpData.width;
						var sy:Number = img_h/bmpData.height;
						bmp_matrix.scale(Math.max(sx,sy), Math.max(sx,sy));
						if (sy > sx) bmp_matrix.tx = -0.5*(bmpData.width*sy-img_w);
						if (sx > sy) bmp_matrix.ty = -0.5*(bmpData.height*sx-img_h);
					}
					
					with (blurred_bg.graphics) {
						beginBitmapFill(bmpData, bmp_matrix);
						lineTo(img_w, 0);
						lineTo(img_w, img_h);
						lineTo(0, img_h);
						lineTo(0, 0);
						endFill();
					}
				}
				
				var tf:TextField = caption.getChildByName("tf") as TextField;
				var tf_bmp:Sprite = caption.getChildByName("tf_bmp") as Sprite;
				tf.htmlText = txt;
				
				bmpData = new BitmapData(Math.ceil(tf.width), Math.ceil(tf.height), true, 0);
				bmpData.draw(tf);
				bmp_matrix = new Matrix();
				tf_bmp.graphics.beginBitmapFill(bmpData, bmp_matrix);
				tf_bmp.graphics.drawRect(0, 0, bmpData.width, bmpData.height);
				tf_bmp.graphics.endFill();
				
				bg_height = Math.ceil(tf.height) + 2*padding;
				if (!isNaN(bg_color) && !isNaN(bg_alpha)) Geom.drawRectangle(caption, bg_width, bg_height, bg_color, bg_alpha);
				if (anim_type != "slide") {
					caption.y = img.y + img_h - bg_height;
					caption.alpha = 0;
				} else {
					caption.y = img.y + img_h;
				}
				if (blurred_bg_mask) {
					Geom.drawRectangle(blurred_bg_mask, bg_width, bg_height, 0xFF9900, 1);
					if (anim_type != "slide") {
						blurred_bg.cacheAsBitmap = blurred_bg_mask.cacheAsBitmap = true;
						blurred_bg_mask.alpha = 0;
					}
					blurred_bg_mask.y = caption.y;
				}
			}
			
			img.addEventListener(MouseEvent.ROLL_OVER,
				function(e:MouseEvent){
					Tweener.removeTweens(caption);
					Tweener.removeTweens(img, "_brightness");
					if (txt != null) {
						if (anim_type != "slide") Tweener.addTween(caption, {alpha:1, time:ON_ROLL_FADE_DURATION, transition:"easeOutSine"});
						else Tweener.addTween(caption, {y:img.y+img_h-bg_height, time:ON_ROLL_SLIDE_DURATION, transition:"easeOutQuad"});
					}
					if (img.getChildByName("videoplayer") == null) { // condition for News and Portfolio modules
						Tweener.addTween(img, {_brightness:brightness, time:duration, transition:"easeOutSine"});
					}
					if (blurred_bg_mask && txt != null) {
						Tweener.removeTweens(blurred_bg_mask);
						if (anim_type != "slide") Tweener.addTween(blurred_bg_mask, {alpha:1, time:ON_ROLL_FADE_DURATION, transition:"easeOutSine"});
						else Tweener.addTween(blurred_bg_mask, {y:img.y+img_h-bg_height, time:ON_ROLL_SLIDE_DURATION, transition:"easeOutQuad"});
					}
					if (child_name) {
						Tweener.removeTweens(child, "alpha");
						Tweener.addTween(child, {alpha:alpha_over, time:duration, transition:"easeOutSine"});
					}
					Mouse.show(); // prevent mouse hiding after the videoplayer closed
				}
			);
			img.addEventListener(MouseEvent.ROLL_OUT,
				function(e:MouseEvent){
					Tweener.removeTweens(caption);
					Tweener.removeTweens(img, "_brightness");
					if (txt != null) {
						if (anim_type != "slide") Tweener.addTween(caption, {alpha:0, time:ON_ROLL_FADE_DURATION, transition:"easeOutSine"});
						else Tweener.addTween(caption, {y:img.y+img_h, time:ON_ROLL_SLIDE_DURATION, transition:"easeOutQuad"});
					}
					if (img.getChildByName("videoplayer") == null) { // condition for News and Portfolio modules
						Tweener.addTween(img, {_brightness:0, time:duration, transition:"easeOutSine"});
					}
					if (blurred_bg_mask && txt != null) {
						Tweener.removeTweens(blurred_bg_mask);
						if (anim_type != "slide") Tweener.addTween(blurred_bg_mask, {alpha:0, time:ON_ROLL_FADE_DURATION, transition:"easeOutSine"});
						else Tweener.addTween(blurred_bg_mask, {y:img.y+img_h, time:ON_ROLL_SLIDE_DURATION, transition:"easeOutQuad"});
					}
					if (child_name) {
						Tweener.removeTweens(child, "alpha");
						Tweener.addTween(child, {alpha:alpha_out, time:duration, transition:"easeOutSine"});
					}
					Mouse.show(); // prevent mouse hiding after the videoplayer closed
				}
			);
		}
		
	/****************************************************************************************************/
	//	Function. Draws a preview image caption for portfolio item and defines its behaviour on rollover/rollout event.
	//			  Applies brightness to an object on rollover/rollout event.

		public static function drawPreviewCaption(obj:Sprite, img_w:uint, img_h:uint, imgBmpData:BitmapData, txt:String, stylesheet:StyleSheet, txt_color:Number, over_txt_color:Number, caption_bg_color:Number, caption_bg_alpha:Number, caption_over_bg_color:Number, caption_over_bg_alpha:Number, isBlurred:Boolean, blur_amount:Number, top_padding:uint, brightness:Number = ROLLOVER_BRIGHTNESS, duration:Number = ON_ROLL_FADE_DURATION, bg_color:Number = NaN, over_bg_color:Number = NaN, border_color:Number = NaN, over_border_color:Number = NaN):void {
			
			var caption_bg_width:uint = img_w;
			var caption_bg_height:uint;
			var bmp_matrix:Matrix;
			var bmpData:BitmapData;
			var img:Sprite = obj.getChildByName("img") as Sprite;
			var bg:Shape = obj.getChildByName("bg") as Shape;
			var base:Shape = obj.getChildByName("base") as Shape;
			var caption:Sprite = obj.getChildByName("caption") as Sprite;
			var caption_bg:Shape;
			var tf:TextField;
			var tf_bmp:Sprite;
			
			if (txt != null) {
				
				if (isBlurred && blur_amount > 0) {
					
					var blurred_bg:Sprite = obj.getChildByName("blurred_bg") as Sprite;
					var blurred_bg_mask:Shape = obj.getChildByName("blurred_bg_mask") as Shape;
					bmp_matrix = new Matrix();
					var blur_filter:BlurFilter = new BlurFilter();
					blur_filter.blurX = blur_filter.blurY = blur_amount;
					blur_filter.quality = BLUR_FILTER_QUALITY;
					bmpData = imgBmpData.clone();
					bmpData.applyFilter(bmpData, bmpData.rect, new Point(0, 0), blur_filter);
					
					var img_width:uint, img_height:uint;
					if (bmpData.width > img_w || bmpData.height > img_h) {
						var sx:Number = img_w/bmpData.width;
						var sy:Number = img_h/bmpData.height;
						bmp_matrix.scale(Math.max(sx,sy), Math.max(sx,sy));
						if (sy > sx) bmp_matrix.tx = -0.5*(bmpData.width*sy-img_w);
						if (sx > sy) bmp_matrix.ty = -0.5*(bmpData.height*sx-img_h);
						img_width = img_w;
						img_height = img_h;
					} else {
						img_width = bmpData.width;
						img_height = bmpData.height;
					}
					
					with (blurred_bg.graphics) {
						beginBitmapFill(bmpData, bmp_matrix);
						lineTo(img_width, 0);
						lineTo(img_width, img_height);
						lineTo(0, img_height);
						lineTo(0, 0);
						endFill();
					}
				}
				
				caption_bg = caption.getChildByName("bg") as Shape;
				tf = caption.getChildByName("tf") as TextField;
				tf_bmp = caption.getChildByName("tf_bmp") as Sprite;
				tf.htmlText = txt;
				
				bmpData = new BitmapData(Math.ceil(tf.width), Math.ceil(tf.height), true, 0);
				bmpData.draw(tf);
				bmp_matrix = new Matrix();
				tf_bmp.graphics.beginBitmapFill(bmpData, bmp_matrix);
				tf_bmp.graphics.drawRect(0, 0, bmpData.width, bmpData.height);
				tf_bmp.graphics.endFill();
				if (txt_color) {
					var txtColor:ColorTransform = tf_bmp.transform.colorTransform;
					txtColor.color = txt_color;
					tf_bmp.transform.colorTransform = txtColor;
				}
				
				caption_bg_height = Math.ceil(tf.height) + 2*top_padding;
				Geom.drawRectangle(caption_bg, caption_bg_width, caption_bg_height, 0xFFFFFF, 1);
				var captionBgColor:ColorTransform = caption_bg.transform.colorTransform;
				captionBgColor.color = caption_bg_color;
				caption_bg.transform.colorTransform = captionBgColor;
				caption_bg.alpha = caption_bg_alpha;
				caption.y = img.y + img_h - caption_bg_height;
				if (blurred_bg_mask) {
					Geom.drawRectangle(blurred_bg_mask, caption_bg_width, caption_bg_height, 0xFF9900, 1);
					blurred_bg_mask.y = caption.y;
				}
			}
			
			img.addEventListener(MouseEvent.ROLL_OVER,
				function(e:MouseEvent){
					Tweener.removeTweens(caption_bg);
					Tweener.removeTweens(img, "_brightness");
					if (txt != null && txt_color && over_txt_color) {
						Tweener.removeTweens(tf_bmp);
						Tweener.addTween(tf_bmp, {_color:over_txt_color, time:0.5*duration, transition:"easeOutQuad"});
					}
					Tweener.addTween(caption_bg, {_color:caption_over_bg_color, alpha:caption_over_bg_alpha, time:0.5*ON_ROLL_FADE_DURATION, transition:"easeOutQuad"});
					if (bg_color && over_bg_color) {
						Tweener.removeTweens(bg);
						Tweener.addTween(bg, {_color:over_bg_color, time:0.5*duration, transition:"easeOutQuad"});
					}
					if (border_color && over_border_color) {
						Tweener.removeTweens(base);
						Tweener.addTween(base, {_color:over_border_color, time:0.5*duration, transition:"easeOutQuad"});
					}
					Tweener.addTween(img, {_brightness:brightness, time:duration, transition:"easeOutSine"});
					Mouse.show(); // prevent mouse hiding after the videoplayer closed
				}
			);
			img.addEventListener(MouseEvent.ROLL_OUT,
				function(e:MouseEvent){
					Tweener.removeTweens(caption_bg);
					Tweener.removeTweens(img, "_brightness");
					if (txt != null && txt_color && over_txt_color) {
						Tweener.removeTweens(tf_bmp);
						Tweener.addTween(tf_bmp, {_color:txt_color, time:0.5*duration, transition:"easeOutQuad"});
					}
					Tweener.addTween(caption_bg, {_color:caption_bg_color, alpha:caption_bg_alpha, time:0.5*ON_ROLL_FADE_DURATION, transition:"easeOutQuad"});
					if (bg_color && over_bg_color) {
						Tweener.removeTweens(bg);
						Tweener.addTween(bg, {_color:bg_color, time:0.5*duration, transition:"easeOutQuad"});
					}
					if (border_color && over_border_color) {
						Tweener.removeTweens(base);
						Tweener.addTween(base, {_color:border_color, time:0.5*duration, transition:"easeOutQuad"});
					}
					Tweener.addTween(img, {_brightness:0, time:duration, transition:"easeOutSine"});
					Mouse.show(); // prevent mouse hiding after the videoplayer closed
				}
			);
		}

	/****************************************************************************************************/
	//	Function. Applies brightness to an object on rollover/rollout event.
	//			  (Optionally) Applies alpha transparency to an object's child.

		public static function applyBrightness(obj:Sprite, brightness:Number = ROLLOVER_BRIGHTNESS, duration:Number = ON_ROLL_FADE_DURATION, child_name:String = null, alpha_over:Number = 1, alpha_out:Number = 1):void {
			if (child_name) var child:* = obj.getChildByName(child_name);
			obj.addEventListener(MouseEvent.ROLL_OVER,
				function(e:MouseEvent){
					Tweener.removeTweens(obj, "_brightness");
					Tweener.addTween(obj, {_brightness:brightness, time:duration, transition:"easeOutSine"});
					if (child_name) {
						Tweener.removeTweens(child, "alpha");
						Tweener.addTween(child, {alpha:alpha_over, time:duration, transition:"easeOutSine"});
					}
				}
			);
			obj.addEventListener(MouseEvent.ROLL_OUT,
				function(e:MouseEvent){
					Tweener.removeTweens(obj, "_brightness");
					Tweener.addTween(obj, {_brightness:0, time:duration, transition:"easeOutSine"});
					if (child_name) {
						Tweener.removeTweens(child, "alpha");
						Tweener.addTween(child, {alpha:alpha_out, time:duration, transition:"easeOutSine"});
					}
				}
			);
		}
		
	/****************************************************************************************************/
	//	Function. Applies brightness to an object's parent child (image) on object rollover/rollout event.
	//			  Used in the News module.

		public static function applyBrightnessToChild(obj:Sprite, brightness:Number = ROLLOVER_BRIGHTNESS, duration:Number = ON_ROLL_FADE_DURATION, child_name:String = null):void {
			if (child_name) var child:* = obj.getChildByName(child_name);
			obj.addEventListener(MouseEvent.ROLL_OVER,
				function(e:MouseEvent){
					Tweener.removeTweens(child, "_brightness");
					Tweener.addTween(child, {_brightness:brightness, time:duration, transition:"easeOutSine"});
				}
			);
			obj.addEventListener(MouseEvent.ROLL_OUT,
				function(e:MouseEvent){
					Tweener.removeTweens(child, "_brightness");
					Tweener.addTween(child, {_brightness:0, time:duration, transition:"easeOutSine"});
				}
			);
		}
		
	/****************************************************************************************************/
	}
}