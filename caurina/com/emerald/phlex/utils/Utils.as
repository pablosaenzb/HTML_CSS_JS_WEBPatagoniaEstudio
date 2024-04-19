/**
	Utils class
	version 1.0.0
	17/09/2012
*/
	
package com.emerald.phlex.utils {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import caurina.transitions.*;
	
	public class Utils {
		
	/****************************************************************************************************/
	//	Function. Returns the class of an object.

		public static function getClass(obj:Object):Class {
			 return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		
	/****************************************************************************************************/
	//	Function. Returns the super class of an object.

		public static function getSuperClass(obj:Object):Class {
			 return Class(getDefinitionByName(getQualifiedSuperclassName(obj)));
		}
		
	/****************************************************************************************************/
	//	Function. Removes specific tweenings of specific objects.

		public static function removeTweens(obj:*):void {
			var child_obj1:*, child_obj2:*, child_obj3:*, child_obj4:*, child_obj5:*;
			Tweener.removeTweens(obj);
			if (getSuperClass(obj) == DisplayObjectContainer || getSuperClass(obj) == MovieClip) {
				for (var i=0; i<obj.numChildren; i++) {
					child_obj1 = obj.getChildAt(i);
					Tweener.removeTweens(child_obj1);
					if (getSuperClass(child_obj1) == DisplayObjectContainer || getSuperClass(child_obj1) == MovieClip) {
						for (var j=0; j<child_obj1.numChildren; j++) {
							child_obj2 = child_obj1.getChildAt(j);
							Tweener.removeTweens(child_obj2);
							if (getSuperClass(child_obj2) == DisplayObjectContainer || getSuperClass(child_obj2) == MovieClip) {
								for (var k=0; k<child_obj2.numChildren; k++) {
									child_obj3 = child_obj2.getChildAt(k);
									Tweener.removeTweens(child_obj3);
									if (getSuperClass(child_obj3) == DisplayObjectContainer || getSuperClass(child_obj3) == MovieClip) {
										for (var n=0; n<child_obj3.numChildren; n++) {
											child_obj4 = child_obj3.getChildAt(n);
											Tweener.removeTweens(child_obj4);
											if (getSuperClass(child_obj4) == DisplayObjectContainer || getSuperClass(child_obj4) == MovieClip) {
												for (var m=0; m<child_obj4.numChildren; m++) {
													child_obj5 = child_obj4.getChildAt(m);
													Tweener.removeTweens(child_obj5);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
	/****************************************************************************************************/
	}
}