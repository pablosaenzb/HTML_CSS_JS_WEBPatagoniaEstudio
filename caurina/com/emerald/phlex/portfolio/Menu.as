/**
	Menu class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex.portfolio {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import com.emerald.phlex.utils.Geom;
	import caurina.transitions.*;
	import caurina.transitions.properties.ColorShortcuts;

	public class Menu {
		
		private var __root:*, wt:*;
		private var menu:Sprite;
		private var textStyleSheet:StyleSheet;
		private static const ON_ROLL_DURATION:Number = 0.2;
		
		ColorShortcuts.init();	// initiates the ColorShortcuts special properties of the Tweener class
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function Menu(obj:*, stylesheet:StyleSheet):void {
			__root = obj; // a reference to the object of the main class
			wt = __root.__root; // a reference to the object of the WebsiteTemplate class
			textStyleSheet = stylesheet;
			menu = __root.menu;
			createMenu(menu);
		}
	
	/****************************************************************************************************/
	//	Function. Builds the main menu.
	
		private function createMenu(menu:Sprite):void {
			var item:Sprite, separator:Sprite;
			var tf:TextField;
			var hitarea:Shape;
			var menu_w:Number = 0;
			
			var menuTextFormat:TextFormat = new TextFormat();
			menuTextFormat.font = __root.categoryFont;
			menuTextFormat.color = __root.categoryFontColor;
			menuTextFormat.size = __root.categoryFontSize;
			if (__root.categoryFontWeight == "bold") menuTextFormat.bold = true;
			
			for (var i=0; i<__root.categoriesArray.length; i++) {
				item = new Sprite();
				item.name = "item"+(i+1);
				item.x = menu_w;
				menu.addChild(item);
				tf = new TextField();
				tf.name = "tf";
				tf.embedFonts = true;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.selectable = false;
				tf.antiAliasType = AntiAliasType.ADVANCED;
				if (__root.categoriesArray[i].title != undefined) tf.text = __root.categoriesArray[i].title;
				tf.setTextFormat(menuTextFormat);
				tf.mouseEnabled = false;
				hitarea = new Shape();
				Geom.drawRectangle(hitarea, Math.ceil(tf.width), Math.ceil(tf.height), 0xFFFFFF, 0);
				item.addChild(hitarea);
				item.addChild(tf);
				menu_w += Math.round(item.width);
				if (i < __root.categoriesArray.length-1) {
					separator = new Sprite();
					menu.addChild(separator);
					tf = new TextField();
					if (textStyleSheet != null) tf.styleSheet = textStyleSheet;
					tf.autoSize = TextFieldAutoSize.LEFT;
					tf.multiline = false;
					tf.wordWrap = false;
					tf.embedFonts = true;
					tf.selectable = false;
					tf.antiAliasType = AntiAliasType.ADVANCED;
					tf.htmlText = "<categoryseparator>/</categoryseparator>";
					separator.addChild(tf);
					separator.x = menu_w + Math.round(__root.categorySpacing/2 - separator.width/2);
					menu_w += __root.categorySpacing;
				}
				item.buttonMode = true;
				item.addEventListener(MouseEvent.ROLL_OVER, menuItemListener);
				item.addEventListener(MouseEvent.ROLL_OUT, menuItemListener);
				item.addEventListener(MouseEvent.CLICK, menuItemListener);
			}
			menu.y = __root.categoryMenuYPosition;
			setSelectedItem(__root.currentCategoryIndex, false);
		}
		
		private function menuItemListener(e:MouseEvent):void {
			var index:uint = e.target.name.substr(4)-1;
			var tf:TextField = e.target.getChildByName("tf");
			switch (e.type) {
				case "rollOver":
					Tweener.removeTweens(tf);
					if (index != __root.currentCategoryIndex) Tweener.addTween(tf, {_color:__root.categoryOverFontColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
				break;
				case "rollOut":
					Tweener.removeTweens(tf);
					if (index != __root.currentCategoryIndex) Tweener.addTween(tf, {_color:__root.categoryFontColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
				break;
				case "click":
					if (index != __root.currentCategoryIndex && !__root.menu_blocked) setSelectedItem(index, true);
			}
		}
		
	/****************************************************************************************************/
	//	Function. Sets the state of the specified menu item to "selected".
	
		private function setSelectedItem(index:uint, change_previews:Boolean):void {
			for (var i=0; i<__root.categoriesArray.length; i++) {
				var item:Sprite = menu.getChildByName("item"+(i+1)) as Sprite;
				var tf:TextField = item.getChildByName("tf") as TextField;
				Tweener.removeTweens(tf);
				if (i != index) Tweener.addTween(tf, {_color:__root.categoryFontColor, time:0, transition:"easeOutQuad"});
				else Tweener.addTween(tf, {_color:__root.categorySelectedFontColor, time:0, transition:"easeOutQuad"});
			}
			__root.currentCategoryIndex = index;
			if (change_previews) {
				__root.createPreviewItems(index);
				if (__root.project.visible == true && __root.project.alpha == 1) {
					__root.controls_blocked = __root.menu_blocked = true;
					__root.applyBlinds("reveal");
				}
			}
		}		
		
	}
}