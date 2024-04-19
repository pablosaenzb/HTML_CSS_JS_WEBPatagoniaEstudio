/**
	Menu class
	version 1.0.0
	17/09/2012
*/

package com.emerald.phlex {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import com.emerald.phlex.utils.Geom;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import caurina.transitions.*;
	import caurina.transitions.properties.ColorShortcuts;

	public class Menu {
		
		private var __root:WebsiteTemplate;
		private var menuTextFormat:TextFormat, submenuTextFormat:TextFormat;
		private var filter:DropShadowFilter;
		private var filterArray:Array;
		private static const ON_ROLL_DURATION:Number = 0.3;
		private static const DROPDOWN_DURATION:Number = 0.3;
		private static const TOPBOTTOM_PADDING:uint = 5;
		private static const ANIMATION_DURATION:Number = 0.5;
		
		ColorShortcuts.init();	// initiates the ColorShortcuts special properties of the Tweener class
	
	/****************************************************************************************************/
	//	Constructor function.
		
		public function Menu(obj:WebsiteTemplate):void {
			__root = obj; // a reference to the object of the WebsiteTemplate class
		}
		
	/****************************************************************************************************/
	//	Function. Parses the nodes of the menu XML file.
	
		public function menuXMLParser(menuXML:XML):void {
			
			var a:uint = 0;
			var b:uint, c:uint, parentIndex:uint, parentIndex2:uint;
			var pageObject:Object;
			for each (var aChild:XML in menuXML.*) {
				a++;
				pageObject = new Object();
				pageObject.menuLevel = 1;
				pageObject.parentIndex = undefined;
				if (aChild.menuTitle != "" && aChild.menuTitle != undefined && aChild.menuTitle != "null") pageObject.menuTitle = aChild.menuTitle;
				if (aChild.pageTitle != "" && aChild.pageTitle != undefined && aChild.pageTitle != "null") pageObject.pageTitle = aChild.pageTitle;
				if (aChild.deepLinkURL != "" && aChild.deepLinkURL != undefined && aChild.deepLinkURL != "null") pageObject.deepLinkURL = correctDeepLink(aChild.deepLinkURL);
				if (aChild.urlTarget != "" && aChild.urlTarget != undefined && aChild.urlTarget != "null") pageObject.urlTarget = aChild.urlTarget;
				if (aChild.bodyBgImage != "" && aChild.bodyBgImage != undefined && aChild.bodyBgImage != "null") {
					pageObject.bodyBgImage = aChild.bodyBgImage;
				} else if (__root.bodyBgImage != null) {
					pageObject.bodyBgImage = __root.bodyBgImage;
				}
				if (aChild.moduleURL != "" && aChild.moduleURL != undefined && aChild.moduleURL != "null") pageObject.moduleURL = aChild.moduleURL;
				if (aChild.moduleXML != "" && aChild.moduleXML != undefined && aChild.moduleXML != "null") pageObject.moduleXML = aChild.moduleXML;
				if (aChild.showInMenu == "false") pageObject.showInMenu = false;
				else pageObject.showInMenu = true;
				if (aChild.subPage != undefined) {
					pageObject.hasChild = true;
					if (aChild.clickable == "true") pageObject.clickable = true;
					else pageObject.clickable = false;
				} else {
					pageObject.hasChild = false;
					if (aChild.clickable == "false") pageObject.clickable = false;
					else pageObject.clickable = true;
				}
				if (aChild.showBreadCrumbs == "true") pageObject.showBreadCrumbs = true;
				else pageObject.showBreadCrumbs = false;
				__root.pagesArray.push(pageObject);
				
				if (aChild.hasComplexContent()) {
					b=0;
					parentIndex = __root.pagesArray.length-1;
					for each (var bChild:XML in aChild.*) {
						if (bChild.name() == "subPage") {
							b++;
							pageObject = new Object();
							pageObject.menuLevel = 2;
							pageObject.parentIndex = parentIndex;
							if (bChild.menuTitle != "" && bChild.menuTitle != undefined && bChild.menuTitle != "null") pageObject.menuTitle = bChild.menuTitle;
							if (bChild.pageTitle != "" && bChild.pageTitle != undefined && bChild.pageTitle != "null") pageObject.pageTitle = bChild.pageTitle;
							if (bChild.deepLinkURL != "" && bChild.deepLinkURL != undefined && bChild.deepLinkURL != "null") pageObject.deepLinkURL = correctDeepLink(bChild.deepLinkURL);
							if (bChild.urlTarget != "" && bChild.urlTarget != undefined && bChild.urlTarget != "null") pageObject.urlTarget = bChild.urlTarget;
							if (bChild.bodyBgImage != "" && bChild.bodyBgImage != undefined && bChild.bodyBgImage != "null") pageObject.bodyBgImage = bChild.bodyBgImage;
							if (bChild.moduleURL != "" && bChild.moduleURL != undefined && bChild.moduleURL != "null") pageObject.moduleURL = bChild.moduleURL;
							if (bChild.moduleXML != "" && bChild.moduleXML != undefined && bChild.moduleXML != "null") pageObject.moduleXML = bChild.moduleXML;
							if (bChild.showInMenu == "false") pageObject.showInMenu = false;
							else pageObject.showInMenu = true;
							if (bChild.showBreadCrumbs == "true") pageObject.showBreadCrumbs = true;
							else pageObject.showBreadCrumbs = false;
							if (bChild.subPage != undefined) pageObject.hasChild = true;
							else pageObject.hasChild = false;
							if (bChild.clickable == "false") pageObject.clickable = false;
							else pageObject.clickable = true;							
							__root.pagesArray.push(pageObject);
							
							if (bChild.hasComplexContent()) {
								c=0;
								parentIndex2 = __root.pagesArray.length-1;
								for each (var cChild:XML in bChild.*) {
									if (cChild.name() == "subPage") {
										c++;
										pageObject = new Object();
										pageObject.menuLevel = 3;
										pageObject.parentIndex = parentIndex2;
										if (cChild.menuTitle != "" && cChild.menuTitle != undefined && cChild.menuTitle != "null") pageObject.menuTitle = cChild.menuTitle;
										if (cChild.pageTitle != "" && cChild.pageTitle != undefined && cChild.pageTitle != "null") pageObject.pageTitle = cChild.pageTitle;
										if (cChild.deepLinkURL != "" && cChild.deepLinkURL != undefined && cChild.deepLinkURL != "null") pageObject.deepLinkURL = correctDeepLink(cChild.deepLinkURL);
										if (cChild.urlTarget != "" && cChild.urlTarget != undefined && cChild.urlTarget != "null") pageObject.urlTarget = cChild.urlTarget;
										if (cChild.bodyBgImage != "" && cChild.bodyBgImage != undefined && cChild.bodyBgImage != "null") pageObject.bodyBgImage = cChild.bodyBgImage;
										if (cChild.moduleURL != "" && cChild.moduleURL != undefined && cChild.moduleURL != "null") pageObject.moduleURL = cChild.moduleURL;
										if (cChild.moduleXML != "" && cChild.moduleXML != undefined && cChild.moduleXML != "null") pageObject.moduleXML = cChild.moduleXML;
										pageObject.showInMenu = false;
										if (cChild.showBreadCrumbs == "true") pageObject.showBreadCrumbs = true;
										else pageObject.showBreadCrumbs = false;
										if (cChild.clickable == "false") pageObject.clickable = false;
										else pageObject.clickable = true;				
										__root.pagesArray.push(pageObject);
									}
								}
							}
						}
					}
				}
			}
		}
	
	/****************************************************************************************************/
	//	Function. Corrects the format of a deep link value.
	
		public function correctDeepLink(str:String):String {
			var deeplink:String;
			deeplink = str.toLowerCase();
    		deeplink = deeplink.replace(/\s/g, "");
			if (deeplink.substr(-1) == "/" && deeplink != "/") deeplink = deeplink.substr(0, deeplink.length-1)
			return deeplink;
		}
		
	/****************************************************************************************************/
	//	Function. Gets the full address for a deep link value.
	
		public function getFullDeepLink(str:String):String {
			var deeplink:String;
			var index:Number;
			for (var i=0; i<__root.pagesArray.length; i++) {
				if (__root.pagesArray[i].deepLinkURL == str) {
					index = i;
					break;
				}
			}
			if (index) {
				var toplevel_index:uint = getTopLevelIndex(index);
				if (toplevel_index == index) deeplink = str;
				else {
					deeplink = __root.pagesArray[toplevel_index].deepLinkURL;
					var secondlevel_index:Number = getSecondLevelIndex(index);
					if (secondlevel_index && secondlevel_index != index) deeplink += "/" + __root.pagesArray[secondlevel_index].deepLinkURL;
					deeplink += "/" + str;
				}
			} else {
				deeplink = str;
			}
			return deeplink;
		}
	
	/****************************************************************************************************/
	//	Function. Builds the main menu.
	
		public function createMenu(menu:Sprite):void {
			menu.visible = false;
			var item:Sprite;
			var tf:TextField;
			var bg:Shape, hitarea:Shape;
			var menu_w:Number = 0;
			var matrix:Matrix;
			
			menuTextFormat = new TextFormat();
			menuTextFormat.font = __root.menuFont;
			menuTextFormat.color = __root.menuFontColor;
			menuTextFormat.size = __root.menuFontSize;
			if (__root.menuFontWeight == "bold") menuTextFormat.bold = true;
			menuTextFormat.leftMargin = menuTextFormat.rightMargin = Math.ceil(__root.menuSpacing/2);
			createSubMenuFormat();
			
			for (var i=0; i<__root.pagesArray.length; i++) {
				if (__root.pagesArray[i].menuLevel == 1 && __root.pagesArray[i].showInMenu == true) {
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
					if (__root.pagesArray[i].menuTitle != undefined) tf.text = __root.pagesArray[i].menuTitle;
					tf.setTextFormat(menuTextFormat);
					tf.mouseEnabled = false;
					bg = new Shape();
					bg.name = "bg";
					if (isNaN(__root.menuOverBgColor)) {
						__root.menuOverBgColor = 0xFFFFFF;
						__root.menuOverBgAlphaTop = __root.menuOverBgAlphaBottom = 0;
					}
					matrix = new Matrix();
					matrix.createGradientBox(Math.ceil(tf.width), __root.headerHeight, Math.PI/2, 0, 0);
					bg.graphics.beginGradientFill("linear", [__root.menuOverBgColor, __root.menuOverBgColor], [__root.menuOverBgAlphaTop, __root.menuOverBgAlphaBottom], [0, 255], matrix, "pad", "RGB", 0);
					bg.graphics.drawRect(0, 0, Math.ceil(tf.width), __root.headerHeight);
					bg.graphics.endFill();
					bg.alpha = 0;
					hitarea = new Shape();
					Geom.drawRectangle(hitarea, Math.ceil(tf.width), __root.headerHeight, 0xFFFFFF, 0);
					item.addChild(hitarea);
					item.addChild(bg);
					item.addChild(tf);
					tf.y = __root.menuYPosition;
					menu_w += item.width;
					item.buttonMode = true;
					item.addEventListener(MouseEvent.ROLL_OVER, menuItemListener);
					item.addEventListener(MouseEvent.ROLL_OUT, menuItemListener);
					item.addEventListener(MouseEvent.CLICK, menuItemListener);
					if (__root.pagesArray[i].hasChild) createSubMenu(item, i);
				}
			}
			
			if (__root.menuAlign == "right") menu.x = __root.templateWidth - menu_w + Math.ceil(__root.menuSpacing/2) - __root.menuXOffset;
			else menu.x = -Math.ceil(__root.menuSpacing/2) + __root.menuXOffset;
			
			for (var j=0; j<menu.numChildren; j++) {
				var child:* = menu.getChildAt(j);
				if (child.name.substr(0,4) == "item") {
					var index:uint = child.name.substr(4)-1;
					if (__root.pagesArray[index].hasChild) {
						var submenu:Sprite = child.getChildByName("submenu");
						var submenu_mask:Shape = child.getChildByName("submenu_mask");
						if (menu.x+child.x+submenu.width > __root.templateWidth+20) {
							submenu.x = child.getChildByName("bg").width - submenu.width;
							submenu_mask.x = submenu.x - 10;
						}
					}
				}
			}
		}
		
		private function menuItemListener(e:MouseEvent):void {
			var index:uint = e.currentTarget.name.substr(4)-1;
			var bg:Shape = e.currentTarget.getChildByName("bg");
			var tf:TextField = e.currentTarget.getChildByName("tf");
			var parent_obj:* = e.currentTarget.parent;
			var submenu:Sprite = e.currentTarget.getChildByName("submenu");
			if (submenu != null) {
				var submenu_bg:Shape = submenu.getChildByName("submenu_bg") as Shape;
				var items_mask:Shape = submenu.getChildByName("items_mask") as Shape;
				var submenu_trim:Shape = submenu.getChildByName("submenu_trim") as Shape;
			}
			
			switch (e.type) {
				case "rollOver":
					parent_obj.setChildIndex(e.currentTarget, parent_obj.numChildren-1);
					Tweener.removeTweens(bg);
					Tweener.removeTweens(tf);
					e.currentTarget.buttonMode = __root.pagesArray[index].clickable;
					Tweener.addTween(bg, {alpha:1, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					if (index != getTopLevelIndex(__root.currentIndex) || __root.pagesArray[index].deepLinkURL == "home") {
						Tweener.addTween(tf, {_color:__root.menuOverFontColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
					if (submenu_bg != null && items_mask != null) {
						Tweener.removeTweens(submenu_bg);
						Tweener.removeTweens(items_mask);
						Tweener.addTween(submenu_bg, {y:0, time:DROPDOWN_DURATION, transition:"easeOutQuart"});
						Tweener.addTween(items_mask, {y:0, time:2*DROPDOWN_DURATION, transition:"easeOutQuart"});
						if (submenu_trim) Tweener.addTween(submenu_trim, {alpha:1, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
				break;
				case "rollOut":
					Tweener.removeTweens(bg);
					Tweener.removeTweens(tf);
					Tweener.addTween(bg, {alpha:0, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					if (index != getTopLevelIndex(__root.currentIndex) || __root.pagesArray[index].deepLinkURL == "home") {
						Tweener.addTween(tf, {_color:__root.menuFontColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
					if (submenu_bg != null && items_mask != null) {
						Tweener.removeTweens(submenu_bg);
						Tweener.removeTweens(items_mask);
						Tweener.addTween(submenu_bg, {y:-submenu_bg.height-10, time:DROPDOWN_DURATION, transition:"easeInQuart"});
						Tweener.addTween(items_mask, {y:-items_mask.height, time:DROPDOWN_DURATION, transition:"easeOutQuad"});
						if (submenu_trim) Tweener.addTween(submenu_trim, {delay:0.1, alpha:0, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
				break;
				case "click":
					var link:String = __root.pagesArray[index].deepLinkURL;
					var target:String = __root.pagesArray[index].urlTarget;
					if (index != __root.currentIndex && e.target.name == e.currentTarget.name && __root.pagesArray[index].clickable && !__root.menu_blocked) {
						if (link == "home") SWFAddress.setValue("/");
						else if (link != null) {
							if (link.substr(0, 4) == "http") {
								if (target == null) target = "_blank";
								try { navigateToURL(new URLRequest(link), target); }
								catch (e:Error) { }
							}
							else SWFAddress.setValue("/" + link);
						}
					}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Initiates the main menu.
	
		public function initiateMenu(menu:Sprite):void {
			menu.alpha = 0;
			menu.visible = true;
			Tweener.addTween(menu, {alpha:1, time:ANIMATION_DURATION, transition:"easeInQuad"});
		}
		
	/****************************************************************************************************/
	//	Function. Creates submenuTextFormat and dropShadowFilter of a submenu item.
	
		private function createSubMenuFormat():void {
			submenuTextFormat = new TextFormat();
			submenuTextFormat.font = __root.submenuFont;
			submenuTextFormat.color = __root.submenuFontColor;
			submenuTextFormat.size = __root.submenuFontSize;
			if (__root.submenuFontWeight == "bold") submenuTextFormat.bold = true;
			submenuTextFormat.leftMargin = submenuTextFormat.rightMargin = Math.ceil(__root.menuSpacing/2);
			if (__root.submenuShadowAlpha > 0) {
				filter = new DropShadowFilter();
				filter.color = __root.submenuShadowColor;
				filter.distance = __root.submenuShadowDistance;
				filter.angle = 45;
				filter.quality = 3;
				filter.blurX = filter.blurY = 4;
				filter.strength = __root.submenuShadowStrength;
				filter.alpha = __root.submenuShadowAlpha;
				filterArray = new Array();
				filterArray.push(filter);
			}
		}
	
	/****************************************************************************************************/
	//	Function. Builds a submenu (drop-down level).
	
		private function createSubMenu(menuitem:Sprite, index:uint):void {
			var submenu:Sprite = new Sprite();
			var submenu_mask:Shape = new Shape();
			var submenu_bg:Shape = new Shape();
			var submenu_trim:Shape = new Shape();
			var items_container:Sprite = new Sprite();
			var items_mask:Shape = new Shape();
			var item:Sprite, tf_bmp:Sprite;
			var tf:TextField;
			var bg:Shape, hitarea:Shape;
			var submenu_w:Number = 0;
			var submenu_h:Number = TOPBOTTOM_PADDING;
			var draw_trim:Boolean = false;
			if (!isNaN(__root.submenuTopTrimColor) && __root.submenuTopTrimAlpha > 0 && __root.submenuTopTrimHeight > 0) draw_trim = true;
			submenu.name = "submenu";
			submenu_bg.name = "submenu_bg";
			submenu_mask.name = "submenu_mask";
			items_mask.name = "items_mask";
			items_container.name = "items_container";
			submenu_trim.name = "submenu_trim";
			submenu.addChild(items_mask);
			submenu.addChild(submenu_bg);
			submenu.addChild(items_container);
			submenu.addChild(submenu_trim);
			
			for (var i=0; i<__root.pagesArray.length; i++) {
				if (__root.pagesArray[i].parentIndex == index && __root.pagesArray[i].menuLevel == 2 && __root.pagesArray[i].showInMenu == true) {
					item = new Sprite();
					item.name = "item"+(i+1);
					item.y = submenu_h;
					items_container.addChild(item);
					
					tf = new TextField();
					tf.name = "tf";
					tf.embedFonts = true;
					tf.autoSize = TextFieldAutoSize.LEFT;
					tf.selectable = false;
					tf.antiAliasType = AntiAliasType.ADVANCED;
					if (__root.pagesArray[i].menuTitle != undefined) tf.text = __root.pagesArray[i].menuTitle;
					tf.setTextFormat(submenuTextFormat);
					var tf_width:uint = Math.ceil(tf.width);
					var tf_height:uint = Math.ceil(tf.height);
					tf.visible = false;
					
					bg = new Shape();
					bg.name = "bg";
					Geom.drawRectangle(bg, tf_width, __root.submenuItemHeight, __root.submenuOverBgColor, __root.submenuOverBgAlpha);
					bg.alpha = 0;
					
					hitarea = new Shape();
					hitarea.name = "hitarea";
					Geom.drawRectangle(hitarea, tf_width, __root.submenuItemHeight, 0xFFFFFF, 0);
					item.addChild(hitarea);
					item.addChild(bg);
					item.addChild(tf);
					submenu_w = Math.max(submenu_w, item.width);
					submenu_h += item.height;
					
					var bmpData:BitmapData = new BitmapData(tf_width, tf_height, true, 0);
					bmpData.draw(tf);
					tf_bmp = new Sprite();
					tf_bmp.name = "tf_bmp";
					item.addChild(tf_bmp);
					var bmp_matrix:Matrix = new Matrix();
					tf_bmp.graphics.beginBitmapFill(bmpData, bmp_matrix);
					tf_bmp.graphics.drawRect(0, 0, bmpData.width, bmpData.height);
					tf_bmp.graphics.endFill();
					tf_bmp.y = Math.round((__root.submenuItemHeight-tf_height)/2);
					
					item.buttonMode = true;
					item.addEventListener(MouseEvent.ROLL_OVER, submenuItemListener);
					item.addEventListener(MouseEvent.ROLL_OUT, submenuItemListener);
					item.addEventListener(MouseEvent.CLICK, submenuItemListener);
				}
			}
			for (var j=0; j<items_container.numChildren; j++) {
				item = Sprite(items_container.getChildAt(j));
				item.getChildByName("bg").width = item.getChildByName("hitarea").width = submenu_w;
			}
			submenu_h += TOPBOTTOM_PADDING;
			if (submenu_h > __root.submenu_max_h) __root.submenu_max_h = submenu_h;
			Geom.drawRectangle(submenu_bg, submenu_w, submenu_h, __root.submenuBgColor, __root.submenuBgAlpha);
			if (draw_trim) Geom.drawRectangle(submenu_trim, submenu_w, __root.submenuTopTrimHeight, __root.submenuTopTrimColor, __root.submenuTopTrimAlpha);
			submenu_trim.alpha = 0;
			submenu_bg.y = -submenu_bg.height-10;
			Geom.drawRectangle(submenu_mask, submenu_w+20, submenu_h+10, 0xFF9900, 0);
			
			Geom.drawRectangle(items_mask, submenu_w, submenu_h, 0xFF9900, 1);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(submenu_w, 200, Math.PI/2, 0, submenu_h);
			items_mask.graphics.beginGradientFill("linear", [0xFF9900, 0xFF9900], [1, 0], [0, 255], matrix, "pad", "RGB", 0);
			items_mask.graphics.drawRect(0, submenu_h, submenu_w, 200);
			items_mask.graphics.endFill();
			items_mask.y = -items_mask.height;
			
			if (filterArray != null) submenu_bg.filters = filterArray;
			menuitem.addChild(submenu_mask);
			menuitem.addChild(submenu);
			submenu.mask = submenu_mask;
			submenu.y = submenu_mask.y = __root.headerHeight;
			submenu_mask.x = -10;
			items_mask.cacheAsBitmap = true;
			items_container.cacheAsBitmap = true;
			items_container.mask = items_mask;
			submenu.useHandCursor = false;
		}
		
		private function submenuItemListener(e:MouseEvent):void {
			var index:uint = e.currentTarget.name.substr(4)-1;
			var current_obj:* = e.currentTarget;
			var bg:Shape = e.currentTarget.getChildByName("bg");
			var tf_bmp:Sprite = e.currentTarget.getChildByName("tf_bmp");
			switch (e.type) {
				case "rollOver":
					Tweener.removeTweens(bg);
					Tweener.removeTweens(tf_bmp);
					Tweener.addTween(bg, {alpha:1, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					if (index != getSecondLevelIndex(__root.currentIndex) || isNaN(__root.submenuSelectedFontColor)) {
						Tweener.addTween(tf_bmp, {_color:__root.submenuOverFontColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
				break;
				case "rollOut":
					Tweener.removeTweens(bg);
					Tweener.removeTweens(tf_bmp);
					Tweener.addTween(bg, {alpha:0, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					if (index != getSecondLevelIndex(__root.currentIndex) || isNaN(__root.submenuSelectedFontColor)) {
						Tweener.addTween(tf_bmp, {_color:__root.submenuFontColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
					}
				break;
				case "click":
					var link:String = __root.pagesArray[index].deepLinkURL;
					var target:String = __root.pagesArray[index].urlTarget;
					if (index != __root.currentIndex && __root.pagesArray[index].clickable && !__root.menu_blocked) {
						if (link == "home") SWFAddress.setValue("/");
						else if (link != null) {
							if (link.substr(0, 4) == "http") {
								if (target == null) target = "_blank";
								try { navigateToURL(new URLRequest(link), target); }
								catch (e:Error) { }
							}
							else SWFAddress.setValue("/" + getFullDeepLink(link));
						}
					}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Sets the state of the specified menu item (or its top level parent item) to "selected".
	
		public function setSelectedItem(menu:Sprite, index:uint):void {
			var indexL1:uint = getTopLevelIndex(index);
			var indexL2:Number = getSecondLevelIndex(index);
			for (var i=0; i<__root.pagesArray.length; i++) {
				if (__root.pagesArray[i].showInMenu == true) {
					var item:Sprite;
					if (__root.pagesArray[i].menuLevel == 1) {
						item = menu.getChildByName("item"+(i+1)) as Sprite;
						var bg:Shape = item.getChildByName("bg") as Shape;
						var tf:TextField = item.getChildByName("tf") as TextField;
						Tweener.removeTweens(bg);
						Tweener.removeTweens(tf);
						if (i != indexL1) {
							Tweener.addTween(tf, {_color:__root.menuFontColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
						} else {
							if (__root.pagesArray[i].deepLinkURL != "home") {
								Tweener.addTween(tf, {_color:__root.menuSelectedFontColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
							}
						}
					} else if (__root.pagesArray[i].menuLevel == 2) {
						var parent_index:uint = __root.pagesArray[i].parentIndex;
						var parent_item:Sprite = menu.getChildByName("item"+(parent_index+1)) as Sprite;
						var submenu:Sprite = parent_item.getChildByName("submenu") as Sprite;
						var items_container:Sprite = submenu.getChildByName("items_container") as Sprite;
						item = items_container.getChildByName("item"+(i+1)) as Sprite;
						var tf_bmp:Sprite = item.getChildByName("tf_bmp") as Sprite;
						Tweener.removeTweens(tf_bmp);
						if (!isNaN(__root.submenuSelectedFontColor)) {
							if (i != indexL2) Tweener.addTween(tf_bmp, {_color:__root.submenuFontColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
							else Tweener.addTween(tf_bmp, {_color:__root.submenuSelectedFontColor, time:ON_ROLL_DURATION, transition:"easeOutQuad"});
						}
					}
				}
			}
		}
		
	/****************************************************************************************************/
	//	Function. Gets the index of the top level item.
	
		private function getTopLevelIndex(index:uint):uint {
			var toplevel_index:uint = index;
			if (__root.pagesArray[index].parentIndex != undefined) {
				var parent_index:uint = __root.pagesArray[index].parentIndex;
				if (__root.pagesArray[parent_index].parentIndex != undefined) toplevel_index = __root.pagesArray[parent_index].parentIndex;
				else toplevel_index = parent_index;
			}
			return toplevel_index;
		}
		
	/****************************************************************************************************/
	//	Function. Gets the index of the second level item.
	
		private function getSecondLevelIndex(index:uint):uint {
			var secondlevel_index:Number;
			if (__root.pagesArray[index].menuLevel == 2) secondlevel_index = index;
			else if (__root.pagesArray[index].menuLevel == 3) secondlevel_index = __root.pagesArray[index].parentIndex;
			return secondlevel_index;
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