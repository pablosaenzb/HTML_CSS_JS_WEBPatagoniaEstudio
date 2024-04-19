/**
	Scroller class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.utils {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.*;
	import flash.geom.Rectangle;
	import caurina.transitions.*;
	import caurina.transitions.properties.ColorShortcuts;
	
	public class Scroller extends Sprite {
		
		private var pane:Sprite, scrollbar:Sprite, track:Sprite, slider:Sprite;
		private var pane_mask:Shape;
		private var mouseIsPressed:Boolean = false;
		private var mouseIsOverSlider:Boolean = false;
		private var pane_yPos:uint;
		private var mask_xOffset:int;
		
		private var scrollBarTrackWidth:uint;
		private var scrollBarTrackColor:Number;
		private var scrollBarTrackAlpha:Number;
		private var scrollBarSliderOverWidth:uint;
		private var scrollBarSliderColor:Number;
		private var scrollBarSliderOverColor:Number;
		
		private static const SCROLLBAR_LEFT_MARGIN:uint = 5;
		private static const PANEMASK_RIGHT_CROPPING:uint = 5;
		private static const SLIDER_MIN_HEIGHT:uint = 20;
		private static const SLIDER_ANIMATION_DURATION:Number = 0.3;
		private static const MOUSE_WHEEL_RATIO:Number = 0.1; // not used in this version
		
		ColorShortcuts.init();	// initiates the ColorShortcuts special properties of the Tweener class
		
	/****************************************************************************************************/
	//	Constructor function.
	
		public function Scroller(src:Sprite, mask_w:uint, mask_h:uint, trackWidth:uint, trackColor:Number, trackAlpha:Number, sliderOverWidth:uint, sliderColor:Number, sliderOverColor:Number, maskXOffset:int = 0):void {
			pane = src;
			pane_yPos = pane.y;
			scrollBarTrackWidth = trackWidth;
			scrollBarTrackColor = trackColor;
			scrollBarTrackAlpha = trackAlpha;
			scrollBarSliderOverWidth = sliderOverWidth;
			scrollBarSliderColor = sliderColor;
			scrollBarSliderOverColor = sliderOverColor;
			mask_xOffset = maskXOffset;
			
			pane_mask = new Shape();
			pane_mask.name = "pane_mask";
			pane_mask.x = pane.x + mask_xOffset;
			pane_mask.y = pane.y;
			Geom.drawRectangle(pane_mask, mask_w-mask_xOffset-PANEMASK_RIGHT_CROPPING, mask_h, 0xFF9900, 0);
			pane.parent.addChild(pane_mask);
			pane.mask = pane_mask;
			
			createScrollBar(mask_w-PANEMASK_RIGHT_CROPPING, mask_h);
			if (pane.height > mask_h) pane.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener);
		}
	
	/****************************************************************************************************/
	//	Function. Draws the scrollbar and defines its behaviour.
	
		private function createScrollBar(mask_w:uint, mask_h:uint):void {
			if (scrollBarTrackWidth > 0) {
				pane.parent.addChild(scrollbar = new Sprite());
				scrollbar.name = "scrollbar";
				scrollbar.x = pane.x + mask_w + SCROLLBAR_LEFT_MARGIN;
				scrollbar.y = pane.y;
				scrollbar.addChild(track = new Sprite());
				
				var hitarea:Sprite;
				var hitarea_width:uint = Math.max(scrollBarSliderOverWidth, 2*SCROLLBAR_LEFT_MARGIN);
				
				Geom.drawRectangle(track, scrollBarTrackWidth, mask_h, !isNaN(scrollBarTrackColor)?scrollBarTrackColor:0xFFFFFF, !isNaN(scrollBarTrackColor)?scrollBarTrackAlpha:0.01);
				track.buttonMode = true;
				hitarea = new Sprite();
				track.addChild(hitarea);
				Geom.drawRectangle(hitarea, hitarea_width, mask_h, 0xFF9900, 0, 0, 0, 0, 0, 0.5*(scrollBarTrackWidth-hitarea_width), 0);
				track.hitArea = hitarea;
				
				scrollbar.addChild(slider = new Sprite());
				var slider_height:uint = Math.ceil((Math.min(pane_mask.height/pane.height, 1))*pane_mask.height);
				if (slider_height < SLIDER_MIN_HEIGHT) slider_height = SLIDER_MIN_HEIGHT;
				var base:Sprite = new Sprite();
				base.name = "base";
				slider.addChild(base);
				Geom.drawRectangle(base, scrollBarTrackWidth, slider_height, scrollBarSliderColor, 1);
				slider.buttonMode = true;
				hitarea = new Sprite();
				hitarea.name = "hitarea";
				slider.addChild(hitarea);
				Geom.drawRectangle(hitarea, hitarea_width, slider_height, 0xFF9900, 0, 0, 0, 0, 0, 0.5*(scrollBarTrackWidth-hitarea_width), 0);
				slider.hitArea = hitarea;
				
				if (pane.height < mask_h) scrollbar.visible = false;
				slider.addEventListener(MouseEvent.ROLL_OVER, sliderListener);
				slider.addEventListener(MouseEvent.ROLL_OUT, sliderListener);
				slider.addEventListener(MouseEvent.MOUSE_DOWN, sliderListener);
				track.addEventListener(MouseEvent.MOUSE_DOWN, trackListener);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Scrollbar slider listener.
		
		private function sliderListener(e:MouseEvent):void {
			if (scrollbar.visible == true) {
				var base:Sprite = slider.getChildByName("base") as Sprite;
				switch (e.type) {
					case "rollOver":
						mouseIsOverSlider = true;
						Tweener.removeTweens(base);
						if (scrollBarSliderColor != scrollBarSliderOverColor) {
							Tweener.addTween(base, {x:-0.5*(scrollBarSliderOverWidth-scrollBarTrackWidth), width:scrollBarSliderOverWidth, _color:scrollBarSliderOverColor, time:SLIDER_ANIMATION_DURATION, transition:"easeOutQuad"});
						} else {
							Tweener.addTween(base, {x:-0.5*(scrollBarSliderOverWidth-scrollBarTrackWidth), width:scrollBarSliderOverWidth, time:SLIDER_ANIMATION_DURATION, transition:"easeOutQuad"});
						}
					break;
					case "rollOut":
						mouseIsOverSlider = false;
						Tweener.removeTweens(base);
						if (scrollBarSliderColor != scrollBarSliderOverColor) {
							if (!mouseIsPressed) Tweener.addTween(base, {x:0, width:scrollBarTrackWidth, _color:scrollBarSliderColor, time:SLIDER_ANIMATION_DURATION, transition:"easeOutQuad"});
						} else {
							if (!mouseIsPressed) Tweener.addTween(base, {x:0, width:scrollBarTrackWidth, time:SLIDER_ANIMATION_DURATION, transition:"easeOutQuad"});
						}
					break;
					case "mouseDown":
						pane.stage.addEventListener(MouseEvent.MOUSE_UP, sliderListener);
						mouseIsPressed = true;
						pane.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
						var bounds:Rectangle = new Rectangle(0, 0, 0, scrollbar.height-slider.height);
						slider.startDrag(false, bounds);
					break;
					case "mouseUp":
						pane.stage.removeEventListener(MouseEvent.MOUSE_UP, sliderListener);
						pane.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
						mouseIsPressed = false;
						if (!mouseIsOverSlider) {
							Tweener.removeTweens(base);
							if (scrollBarSliderColor != scrollBarSliderOverColor) {
								Tweener.addTween(base, {x:0, width:scrollBarTrackWidth, _color:scrollBarSliderColor, time:SLIDER_ANIMATION_DURATION, transition:"easeOutQuad"});
							} else {
								Tweener.addTween(base, {x:0, width:scrollBarTrackWidth, time:SLIDER_ANIMATION_DURATION, transition:"easeOutQuad"});
							}
						}
						slider.stopDrag();
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Scrollbar track listener.
		
		private function trackListener(e:MouseEvent):void {
			if (scrollbar.visible == true) {
				if (e.type == "mouseDown") {
					updateAfterTrackClick(slider.mouseY);
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Updates the pane position and the slider position when clicking the scrollbar track.
	
		private function updateAfterTrackClick(yPos:Number):void {
			var new_ypos1:int;
			var speed_ratio:Number;
			if (yPos > slider.height) {
				new_ypos1 = Math.round(pane.y - Math.min(pane_mask.height, (pane.y+pane.height)-(pane_mask.y+pane_mask.height)));
				speed_ratio = (pane.y-new_ypos1)/pane_mask.height;
			} else if (yPos < 0) {
				new_ypos1 = Math.round(pane.y + Math.min(pane_mask.height, pane_mask.y-pane.y));
				speed_ratio = (new_ypos1-pane.y)/pane_mask.height;
			}
			if (!isNaN(speed_ratio)) {
				Tweener.removeTweens(pane);
				Tweener.addTween(pane, {y:new_ypos1, time:0.3*(1+speed_ratio), transition:"easeOutQuad"});
				var ratio:Number = (pane_mask.y-new_ypos1)/(pane.height - pane_mask.height);
				var scrolling_height:uint = scrollbar.height-slider.height;
				var new_ypos2:uint = Math.round(scrolling_height*ratio);
				Tweener.addTween(slider, {y:new_ypos2, time:0.3, transition:"easeOutQuad"});
			}
		}
		
	/****************************************************************************************************/
	//	Function. Mouse move listener.
	
		private function mouseMoveListener(e:MouseEvent):void {
			updateAfterSliderDrag();
		}
	
	/****************************************************************************************************/
	//	Function. Updates the pane position according to the slider position.
	
		private function updateAfterSliderDrag():void {
			var ratio:Number = slider.y/(scrollbar.height-slider.height);
			var scrolling_height:Number = pane.height - pane_mask.height;
			var shift:uint = Math.round(scrolling_height*ratio);
			Tweener.removeTweens(pane);
			Tweener.addTween(pane, {y:pane_mask.y-shift, time:0.3, transition:"easeOutQuad"});
		}
	
	/****************************************************************************************************/
	//	Function. Mouse wheel listener.

		public function mouseWheelListener(e:MouseEvent):void {
			if (scrollbar) {
				Tweener.removeTweens(slider);
				Tweener.removeTweens(pane);
				var h_factor:Number = Math.sqrt(pane.stage.stageHeight/scrollbar.height);
				var pane_range:Number = Math.max(120/h_factor, 20);
				var new_ypos:int;
				if (e.delta > 0) new_ypos = Math.round(Math.min(pane.y+pane_range, pane_mask.y));
				else new_ypos = Math.round(Math.max(pane.y-pane_range, pane_mask.y+pane_mask.height-pane.height));
				Tweener.addTween(pane, {y:new_ypos, time:0.3, transition:"easeOutQuad"});
				
				var ratio:Number = Math.abs((new_ypos-pane_mask.y)/(pane_mask.height-pane.height));
				var scrolling_height:Number = scrollbar.height - slider.height;
				var shift:uint = Math.round(scrolling_height*ratio);
				Tweener.addTween(slider, {y:shift, time:0.3, transition:"easeOutQuad"});
				
				/* -- previous version --
				
				var h_factor:Number = 0.9*Math.sqrt(pane.stage.stageHeight/scrollbar.height);
				var slider_range:Number = Math.max(MOUSE_WHEEL_RATIO*h_factor*(scrollbar.height-slider.height), 20);
				var new_ypos:uint;
				if (e.delta > 0) new_ypos = Math.round(Math.max(slider.y-slider_range, 0));
				else new_ypos = Math.round(Math.min(slider.y+slider_range, scrollbar.height-slider.height));
				Tweener.addTween(slider, {y:new_ypos, time:0.3, transition:"easeOutQuad"});
				
				var ratio:Number = new_ypos/(scrollbar.height-slider.height);
				var scrolling_height:Number = pane.height - pane_mask.height;
				var shift:uint = Math.round(scrolling_height*ratio);
				Tweener.addTween(pane, {y:pane_mask.y-shift, time:0.3, transition:"easeOutQuad"});
				*/
			}
		}
		
	/****************************************************************************************************/
	//	Function. Changes the pane position and the slider position/height when the SWF file is resized.
	
		public function onStageResized(mask_h:uint, mask_w:uint = 0):void {
			pane_mask.height = mask_h;
			if (mask_w > 0) pane_mask.width = mask_w - mask_xOffset - PANEMASK_RIGHT_CROPPING;
			if (scrollbar) {
				track.height = mask_h;
				slider.y = 0;
				var slider_height = Math.ceil((pane_mask.height/pane.height)*pane_mask.height);
				if (slider_height < SLIDER_MIN_HEIGHT) slider_height = SLIDER_MIN_HEIGHT;
				var base:Sprite = slider.getChildByName("base") as Sprite;
				var hitarea:Sprite = slider.getChildByName("hitarea") as Sprite;
				base.height = hitarea.height = slider_height;
				if (pane.height < mask_h) scrollbar.visible = false;
				else scrollbar.visible = true;
				if (mask_w > 0) scrollbar.x = pane.x + mask_w - PANEMASK_RIGHT_CROPPING + SCROLLBAR_LEFT_MARGIN;
			}
			pane.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener);
			if (pane.height > mask_h) pane.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener);
		}
		
	/****************************************************************************************************/
	//	Function. Destroys the scroller.
	
		public function destroyScroller():void {
			if (scrollbar) {
				slider.removeEventListener(MouseEvent.ROLL_OVER, sliderListener);
				slider.removeEventListener(MouseEvent.ROLL_OUT, sliderListener);
				slider.removeEventListener(MouseEvent.MOUSE_DOWN, sliderListener);
				track.removeEventListener(MouseEvent.MOUSE_DOWN, trackListener);
				pane.stage.removeEventListener(MouseEvent.MOUSE_UP, sliderListener);
				pane.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
				Tweener.removeTweens(slider);
				var base:Sprite = slider.getChildByName("base") as Sprite;
				Tweener.removeTweens(base);
			}
			Tweener.removeTweens(pane);
			pane.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener);
			pane.mask = null;
			pane.y = pane_yPos;
			pane.parent.removeChild(pane_mask);
			pane_mask = null;
			if (scrollbar) {
				pane.parent.removeChild(scrollbar);
				scrollbar = null;
			}
		}
	
	}
}