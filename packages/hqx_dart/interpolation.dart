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

/**
 * Helper class to interpolate colors. Nothing to see here, move along...
 */
class Interpolation {
	static int _Mask4  = 0xFF000000;
	static int _Mask2  = 0x0000FF00;
	static int _Mask13 = 0x00FF00FF;

	// return statements:
	//	 1. line: green
	//	 2. line: red and blue
	//	 3. line: alpha

	static int _Mix3To1(int c1, int c2) {
		//return (c1*3+c2) >> 2;
		if (c1 == c2) {
			return c1;
		}
		return ((((c1 & _Mask2) * 3 + (c2 & _Mask2)) >> 2) & _Mask2) |
			((((c1 & _Mask13) * 3 + (c2 & _Mask13)) >> 2) & _Mask13) |
			((((c1 & _Mask4) >> 2) * 3 + ((c2 & _Mask4) >> 2)) & _Mask4);
	}

	static int _Mix2To1To1(int c1, int c2, int c3) {
		//return (c1*2+c2+c3) >> 2;
		return ((((c1 & _Mask2) * 2 + (c2 & _Mask2) + (c3 & _Mask2)) >> 2) & _Mask2) |
			  ((((c1 & _Mask13) * 2 + (c2 & _Mask13) + (c3 & _Mask13)) >> 2) & _Mask13) |
			((((c1 & _Mask4) >> 2) * 2 + ((c2 & _Mask4) >> 2) + ((c3 & _Mask4) >> 2)) & _Mask4);
	}

	static int _Mix7To1(int c1, int c2) {
		//return (c1*7+c2)/8;
		if (c1 == c2) {
			return c1;
		}
		return ((((c1 & _Mask2) * 7 + (c2 & _Mask2)) >> 3) & _Mask2) |
			((((c1 & _Mask13) * 7 + (c2 & _Mask13)) >> 3) & _Mask13) |
			((((c1 & _Mask4) >> 3) * 7 + ((c2 & _Mask4) >> 3)) & _Mask4);
	}

	static int _Mix2To7To7(int c1, int c2, int c3) {
		//return (c1*2+(c2+c3)*7)/16;
		return ((((c1 & _Mask2) * 2 + (c2 & _Mask2) * 7 + (c3 & _Mask2) * 7) >> 4) & _Mask2) |
			  ((((c1 & _Mask13) * 2 + (c2 & _Mask13) * 7 + (c3 & _Mask13) * 7) >> 4) & _Mask13) |
			((((c1 & _Mask4) >> 4) * 2 + ((c2 & _Mask4) >> 4) * 7 + ((c3 & _Mask4) >> 4) * 7) & _Mask4);
	}

	static int _MixEven(int c1, int c2) {
		//return (c1+c2) >> 1;
		if (c1 == c2) {
			return c1;
		}
		return ((((c1 & _Mask2) + (c2 & _Mask2)) >> 1) & _Mask2) |
			((((c1 & _Mask13) + (c2 & _Mask13)) >> 1) & _Mask13) |
			((((c1 & _Mask4) >> 1) + ((c2 & _Mask4) >> 1)) & _Mask4);
	}

	static int _Mix4To2To1(int c1, int c2, int c3) {
		//return (c1*5+c2*2+c3)/8;
		return ((((c1 & _Mask2) * 5 + (c2 & _Mask2) * 2 + (c3 & _Mask2)) >> 3) & _Mask2) |
			  ((((c1 & _Mask13) * 5 + (c2 & _Mask13) * 2 + (c3 & _Mask13)) >> 3) & _Mask13) |
			((((c1 & _Mask4) >> 3) * 5 + ((c2 & _Mask4) >> 3) * 2 + ((c3 & _Mask4) >> 3)) & _Mask4);
	}

	static int _Mix6To1To1(int c1, int c2, int c3) {
		//return (c1*6+c2+c3)/8;
		return ((((c1 & _Mask2) * 6 + (c2 & _Mask2) + (c3 & _Mask2)) >> 3) & _Mask2) |
			  ((((c1 & _Mask13) * 6 + (c2 & _Mask13) + (c3 & _Mask13)) >> 3) & _Mask13) |
			((((c1 & _Mask4) >> 3) * 6 + ((c2 & _Mask4) >> 3) + ((c3 & _Mask4) >> 3)) & _Mask4);
	}

	static int _Mix5To3(int c1, int c2) {
		//return (c1*5+c2*3)/8;
		if (c1 == c2) {
			return c1;
		}
		return ((((c1 & _Mask2) * 5 + (c2 & _Mask2) * 3) >> 3) & _Mask2) |
			  ((((c1 & _Mask13) * 5 + (c2 & _Mask13) * 3) >> 3) & _Mask13) |
			((((c1 & _Mask4) >> 3) * 5 + ((c2 & _Mask4) >> 3) * 3) & _Mask4);
	}

	static int _Mix2To3To3(int c1, int c2, int c3) {
		//return (c1*2+(c2+c3)*3)/8;
		return ((((c1 & _Mask2) * 2 + (c2 & _Mask2) * 3 + (c3 & _Mask2) * 3) >> 3) & _Mask2) |
			  ((((c1 & _Mask13) * 2 + (c2 & _Mask13) * 3 + (c3 & _Mask13) * 3) >> 3) & _Mask13) |
			((((c1 & _Mask4) >> 3) * 2 + ((c2 & _Mask4) >> 3) * 3 + ((c3 & _Mask4) >> 3) * 3) & _Mask4);
	}

	static int _Mix14To1To1(int c1, int c2, int c3) {
		//return (c1*14+c2+c3)/16;
		return ((((c1 & _Mask2) * 14 + (c2 & _Mask2) + (c3 & _Mask2)) >> 4) & _Mask2) |
			  ((((c1 & _Mask13) * 14 + (c2 & _Mask13) + (c3 & _Mask13)) >> 4) & _Mask13) |
			((((c1 & _Mask4) >> 4) * 14 + ((c2 & _Mask4) >> 4) + ((c3 & _Mask4) >> 4)) & _Mask4);
	}
}
