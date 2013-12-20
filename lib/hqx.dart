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

class Hqx {
	static int _Ymask = 0x00FF0000;
	static int _Umask = 0x0000FF00;
	static int _Vmask = 0x000000FF;

  /**
   * Returns an image that is exactly twice as large as the input image.
   * 
   * The Y, U, V, A parameters will be set as 48, 7, 6 and 0, respectively. Also, wrapping will be false.
   */
  static ImageElement defaultHq2x(ImageElement source){
    
    ImageData dSource = _getPixels(source);
    ImageData dDestination = _getPixelsForBounds(source.width * 2, source.height * 2);
    _internal_hq2x_32_rb_default(dSource, dDestination);
    return _getImage(dDestination);
  }

  /**
   * Returns an image that is exactly three times as large as the input image.
   * 
   * The Y, U, V, A parameters will be set as 48, 7, 6 and 0, respectively. Also, wrapping will be false.
   */
  static ImageElement defaultHq3x(ImageElement source){
    
    ImageData dSource = _getPixels(source);
    ImageData dDestination = _getPixelsForBounds(source.width * 3, source.height * 3);
    _internal_hq3x_32_rb_default(dSource, dDestination);
    return _getImage(dDestination);
  }

  /**
   * Returns an image that is exactly four times as large as the input image.
   * 
   * The Y, U, V, A parameters will be set as 48, 7, 6 and 0, respectively. Also, wrapping will be false.
   */
  static ImageElement defaultHq4x(ImageElement source){
    
    ImageData dSource = _getPixels(source);
    ImageData dDestination = _getPixelsForBounds(source.width * 4, source.height * 4);
    _internal_hq4x_32_rb_default(dSource, dDestination);
    return _getImage(dDestination);
  }
  
  /**
   * Returns an image that is exactly twice as large as the input image.
   * 
   * trY the Y (luminance) threshold, trU the U (chrominance) threshold
   * trV the V (chrominance) threshold, trA the A (transparency) threshold
   * wrapX used for images that can be seamlessly repeated horizontally, wrapY used for images that can be seamlessly repeated vertically
   */
  static ImageElement hq2x(ImageElement source,
                           int trY, int trU, int trV, int trA,
                           bool wrapX, bool wrapY){
    
    ImageData dSource = _getPixels(source);
    ImageData dDestination = _getPixelsForBounds(source.width * 2, source.height * 2);
    _internal_hq2x_32_rb( dSource, dDestination, trY, trU, trV, trA, wrapX, wrapY);
    return _getImage(dDestination);
  }

  /**
   * Returns an image that is exactly three times as large as the input image.
   * 
   * trY the Y (luminance) threshold, trU the U (chrominance) threshold, 
   * trV the V (chrominance) threshold, trA the A (transparency) threshold, 
   * wrapX used for images that can be seamlessly repeated horizontally, 
   * wrapY used for images that can be seamlessly repeated vertically
   */
  static ImageElement hq3x(ImageElement source,
                           int trY, int trU, int trV, int trA,
                           bool wrapX, bool wrapY){
    
    ImageData dSource = _getPixels(source);
    ImageData dDestination = _getPixelsForBounds(source.width * 3, source.height * 3);
    _internal_hq3x_32_rb( dSource, dDestination, trY, trU, trV, trA, wrapX, wrapY);
    return _getImage(dDestination);
  }


  /**
   * Returns an image that is exactly four times as large as the input image.
   *  
   * trY the Y (luminance) threshold, trU the U (chrominance) threshold, 
   * trV the V (chrominance) threshold, trA the A (transparency) threshold, 
   * wrapX used for images that can be seamlessly repeated horizontally, 
   * wrapY used for images that can be seamlessly repeated vertically
   */
  static ImageElement hq4x(ImageElement source,
                           int trY, int trU, int trV, int trA,
                           bool wrapX, bool wrapY){
    
    ImageData dSource = _getPixels(source);
    ImageData dDestination = _getPixelsForBounds(source.width * 4, source.height * 4);
    _internal_hq4x_32_rb( dSource, dDestination, trY, trU, trV, trA, wrapX, wrapY);
    return _getImage(dDestination);
  }

  /**
   * Compares two ARGB colors according to the provided Y, U, V and A thresholds.
   * 
   * c1 an ARGB color, c2 a second ARGB color
   * trY the Y (luminance) threshold, trU the U (chrominance) threshold
   * trV the V (chrominance) threshold, trA the A (transparency) threshold
   * 
   * Returns true if colors differ more than the thresholds permit, false otherwise
   */
  static bool _diff(final int c1, final int c2, final int trY, final int trU, final int trV, final int trA) {
    final int YUV1 = RgbYuv._getYuv(c1);
    final int YUV2 = RgbYuv._getYuv(c2);

    return (
        (((YUV1 & _Ymask) - (YUV2 & _Ymask)).abs() > trY) ||
        (((YUV1 & _Umask) - (YUV2 & _Umask)).abs() > trU) ||
        (((YUV1 & _Vmask) - (YUV2 & _Vmask)).abs() > trV) ||
        ((((c1 >> 24) - (c2 >> 24))).abs() > trA)
        );
  }
  
  /**
   * Reads the RGBA pixels from the given ImageData object and converts them into an
   * integer array of ARGB format.
   */
  static List<int> _readPixels(ImageData source){

    List<int> pixels = new List<int>(source.data.length ~/ 4);
    
    for (int i=0; i<source.data.length; i+=4){
      
      int val = source.data[i+3];
      val    |= source.data[i+0] << 8;
      val    |= source.data[i+1] << 16;
      val    |= source.data[i+2] << 24;
      pixels[i ~/ 4] = val;
   }
   return pixels;
  }

  /**
   * Writes the pixels from the given array of ARGB format to the given ImageData object (RGBA).
   */
  static void _writePixels(ImageData destination, List<int> source){

    int idx = 0;
    for (int i=0; i<source.length; i++){
      
      destination.data[idx++] = (source[i] >> 8 ) & 0x000000FF;
      destination.data[idx++] = (source[i] >> 16) & 0x000000FF;
      destination.data[idx++] = (source[i] >> 24) & 0x000000FF;
      destination.data[idx++] = (source[i] >> 0 ) & 0x000000FF;
   }
  }

  /**
   * Reads the pixels from the given image.
   */
  static ImageData _getPixels(ImageElement image){
    CanvasElement canvas = new CanvasElement();
    canvas.width = image.width;
    canvas.height = image.height;
    CanvasRenderingContext2D context = canvas.getContext("2d");
    context.drawImage(image, 0, 0);
    return context.getImageData(0, 0, canvas.width, canvas.height);
  }

  /**
   * Creates the pixels for the given size
   */
  static ImageData _getPixelsForBounds(int width, int height){
    CanvasElement canvas = new CanvasElement();
    canvas.width = width;
    canvas.height = height;
    CanvasRenderingContext2D context = canvas.getContext("2d");
    return context.getImageData(0, 0, canvas.width, canvas.height);
  }

  /**
   * Returns an image for the pixels
   */
  static ImageElement _getImage(ImageData pixels){
    ImageElement result = new ImageElement();
    CanvasElement canvas = new CanvasElement();
    canvas.width = pixels.width;
    canvas.height = pixels.height;
    CanvasRenderingContext2D context = canvas.getContext("2d");
    context.putImageData(pixels, 0, 0);
    result.src = canvas.toDataUrl();
    return result;
  }
  

  /**
   * Internal 2x method
   */
  static void _internal_hq2x_32_rb_default(ImageData source, ImageData destination){

      List<int> sPixels = _readPixels(source);
      List<int> dPixels = new List<int>(sPixels.length * 4);
      Hqx_2x._hq2x_32_rb_default(sPixels, dPixels, source.width, source.height);
      _writePixels(destination, dPixels);
  }
  
  /**
   * Internal 2x method
   */
  static void _internal_hq2x_32_rb(ImageData source, ImageData destination,
                    int trY, int trU, int trV, int trA,
                    bool wrapX, bool wrapY) {

    List<int> sPixels = _readPixels(source);
    List<int> dPixels = new List<int>(sPixels.length * 4);
    Hqx_2x._hq2x_32_rb( sPixels, dPixels, source.width, source.height,
                        trY, trU, trV, trA, wrapX, wrapY);
    _writePixels(destination, dPixels);
  }
  
  /**
   * Internal 3x method
   */
  static void _internal_hq3x_32_rb_default(ImageData source, ImageData destination){

      List<int> sPixels = _readPixels(source);
      List<int> dPixels = new List<int>(sPixels.length * 9);
      Hqx_3x._hq3x_32_rb_default(sPixels, dPixels, source.width, source.height);
      _writePixels(destination, dPixels);
  }
  
  /**
   * Internal 3x method
   */
  static void _internal_hq3x_32_rb(ImageData source, ImageData destination,
                    int trY, int trU, int trV, int trA,
                    bool wrapX, bool wrapY) {
    
    List<int> sPixels = _readPixels(source);
    List<int> dPixels = new List<int>(sPixels.length * 9);
    Hqx_3x._hq3x_32_rb( sPixels, dPixels, source.width, source.height,
                        trY, trU, trV, trA, wrapX, wrapY);
    _writePixels(destination, dPixels);
  }
  
  /**
   * Internal 4x method
   */
  static void _internal_hq4x_32_rb_default(ImageData source, ImageData destination){

      List<int> sPixels = _readPixels(source);
      List<int> dPixels = new List<int>(sPixels.length * 16);
      Hqx_4x._hq4x_32_rb_default(sPixels, dPixels, source.width, source.height);
      _writePixels(destination, dPixels);
  }

  /**
   * Internal 4x method
   */
  static void _internal_hq4x_32_rb(ImageData source, ImageData destination,
                    int trY, int trU, int trV, int trA,
                    bool wrapX, bool wrapY) {

    List<int> sPixels = _readPixels(source);
    List<int> dPixels = new List<int>(sPixels.length * 16);
    Hqx_4x._hq4x_32_rb( sPixels, dPixels, source.width, source.height,
                        trY, trU, trV, trA, wrapX, wrapY);
    _writePixels(destination, dPixels);
  }

  /**
   * Calculates the lookup table. MUST be called (only once) before doing anything else
   */
  static void init() {
    RgbYuv._hqxInit();
  }
  
  /**
   * Releases the reference to the lookup table. 
   * 
   * The table has to be calculated again for the next lookup.
   */
  static void deinit() {
    RgbYuv._hqxDeinit();
  }
}