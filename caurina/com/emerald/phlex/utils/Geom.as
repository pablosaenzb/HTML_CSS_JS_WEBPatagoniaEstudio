/**
	Geom class
	version 1.0.0
	17/09/2012
*/
	
package com.emerald.phlex.utils {
	
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	
	public class Geom {
		
	/****************************************************************************************************/
	//	Function. Draws a rectangle of specified sizing and background parameters.

		public static function drawRectangle(obj:*, w:uint, h:uint, fill_color:Number, fill_alpha:Number, tl_radius:uint = 0, tr_radius:uint = 0, bl_radius:uint = 0, br_radius:uint = 0, x0:int = 0, y0:int = 0, border_color:uint = 0, border_alpha:Number = 0, border_thickness:uint = 0):void {
			obj.graphics.beginFill(fill_color, fill_alpha);
			if (border_alpha > 0 && border_thickness > 0) obj.graphics.lineStyle(border_thickness, border_color, border_alpha, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
			if (tl_radius || tr_radius || bl_radius || br_radius) {
				obj.graphics.moveTo(tl_radius+x0, y0);
				obj.graphics.curveTo(x0, y0, x0, tl_radius+y0);
				obj.graphics.lineTo(x0, h-bl_radius+y0);
				obj.graphics.curveTo(x0, h+y0, bl_radius+x0, h+y0);
				obj.graphics.lineTo(w-br_radius+x0, h+y0);
				obj.graphics.curveTo(w+x0, h+y0, w+x0, h-br_radius+y0);
				obj.graphics.lineTo(w+x0, tr_radius+y0);
				obj.graphics.curveTo(w+x0, y0, w-tr_radius+x0, y0);
				obj.graphics.lineTo(tl_radius+x0, y0);
			} else {
				obj.graphics.drawRect(x0, y0, w, h);
			}
			obj.graphics.endFill();
		}

	/****************************************************************************************************/
	//	Function. Draws a border of specified sizing and color parameters.

		public static function drawBorder(obj:*, w:uint, h:uint, fill_color:Number, fill_alpha:Number, thickness:uint = 0, padding:uint = 0):void {
			drawRectangle(obj, thickness, h+2*padding+2*thickness, fill_color, fill_alpha, 0, 0, 0, 0, -padding-thickness, -padding-thickness);
			drawRectangle(obj, w+2*padding+thickness, thickness, fill_color, fill_alpha, 0, 0, 0, 0, -padding, -padding-thickness);
			drawRectangle(obj, thickness, h+2*padding+thickness, fill_color, fill_alpha, 0, 0, 0, 0, w+padding, -padding);
			drawRectangle(obj, w+2*padding, thickness, fill_color, fill_alpha, 0, 0, 0, 0, -padding, h+padding);
		}

	/****************************************************************************************************/
	//	Function. Draws a grid.

		public static function drawGrid(obj:*, w:uint, h:uint, stroke_color:Number, mesh_size:uint, grid_alpha:Number):void {
			var lineX:uint, lineY:uint;
			if (mesh_size > 0) {
				obj.graphics.lineStyle(0, stroke_color);
				for (var i=1; i < h/mesh_size; i++) {
					lineY = mesh_size*i;
					obj.graphics.moveTo(0, lineY);
					obj.graphics.lineTo(w, lineY);
				}
				for (var j=1; j < w/mesh_size; j++) {
					lineX = mesh_size*j;
					obj.graphics.moveTo(lineX, 0);
					obj.graphics.lineTo(lineX, h);
				}
				obj.alpha = grid_alpha;
			}
		}
		
	/****************************************************************************************************/
	}
}