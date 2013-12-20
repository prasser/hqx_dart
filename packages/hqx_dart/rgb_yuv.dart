/*
 * Copyright © 2003 Maxim Stepin (maxst@hiend3d.com)
 *
 * Copyright © 2010 Cameron Zemek (grom@zeminvaders.net)
 *
 * Copyright © 2011 Tamme Schichler (tamme.schichler@googlemail.com)
 *
 * Copyright © 2012 A. Eduardo García (arcnorj@gmail.com)
 * 
 * Copyright © 2013 Fabian Praßer (fabian.prasser@gmail.com)
 *
 * This file is part of hqx_dart.
 *
 * hqx_dart is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * hqx_dart is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with hqx_dart. If not, see <http://www.gnu.org/licenses/>.
 */

part of hqx_dart;

class RgbYuv {
	static int _rgbMask = 0x00FFFFFF;
	static List<int> _RGBtoYUV = new List<int>(0x1000000);

	/**
	 * Returns the 24bit YUV equivalent of the provided 24bit RGB color.
	 * Any alpha component is dropped
	 *
	 * rgb a 24bit rgb color
	 */
	static int _getYuv(final int rgb) {
		return _RGBtoYUV[rgb & _rgbMask];
	}

	/**
	 * Calculates the lookup table. MUST be called (only once) before doing anything else
	 */
	static void _hqxInit() {
		/* Initalize RGB to YUV lookup table */
		int r, g, b, y, u, v;
		for (int c = 0x1000000 - 1; c >= 0; c--) {
			r = (c & 0xFF0000) >> 16;
			g = (c & 0x00FF00) >> 8;
			b = c & 0x0000FF;
			y = (0.299 * r + 0.587 * g + 0.114 * b).toInt();
			u = (0.169 * r - 0.331 * g + 0.500 * b).toInt() + 128;
			v = (0.500 * r - 0.419 * g - 0.081 * b).toInt() + 128;
			_RGBtoYUV[c] = (y << 16) | (u << 8) | v;
		}
	}

	/**
	 * Releases the reference to the lookup table. 
	 * 
	 * The table has to be calculated again for the next lookup.
	 */
	static void _hqxDeinit() {
        _RGBtoYUV = null;
    }
}
