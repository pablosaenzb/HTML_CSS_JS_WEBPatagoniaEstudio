/**
 * Copyright (c) 2008 Bartek Drozdz (http://www.everydayflash.com)
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

package com.everydayflash.equalizer {

	/**
	  * @author Bartek Drozdz (http://www.everydayflash.com)
	  * @version 1.0
	  */
	public class EqualizerSettings {
		
		/** The number of vertical bars in the Equalizer. Good it if is a power of 2. */
		public var numOfBars:int;
		
		/** The height of a maximal bar in the equalizer. */
		public var height:int;
		
		/** The width (in px) of a single bar. */
		public var barSize:int;
		
		/** Set to true to get a 1px vetical spacing between bars. 
			IMPORTANT! If it is set to true, barSize should be at least 2, otherwise it is ignored. */
		public var vgrid:Boolean;
		
		/** A 1px horizontal spacing will be introduced every "hgrid" pixel. Set to 0 to disable. */
		public var hgrid:int;
		
		/** The color of bars. */
		public var barColor:uint;
		
		public function EqualizerSettings() {
			// DEFAULTS
			numOfBars = 4;
			height = 16;
			barSize = 4;
			vgrid = true; 
			hgrid = 0;
			barColor = 0xffffffff;
		}

		public function getWidth():int {
			return (numOfBars * barSize);
		}
		
	}
}













