import 'dart:html';
import '../lib/hqx_dart.dart';

void main() {

  CanvasElement canvas = querySelector("#canvas");
  CanvasRenderingContext2D context = canvas.getContext("2d");
  context.setFillColorRgb(200, 200, 200, 255);
  context.fillRect(0, 0, canvas.width, canvas.height);
  context.setFillColorRgb(0, 0, 0, 255);
  context.font = "20px Arial";
  
  ImageElement image = new ImageElement(src: "mushroom.png");
  image.onLoad.listen((Event e){
    
    Hqx.init();
    
    context.drawImage(image, 10, 10);
    context.drawImage(Hqx.defaultHq2x(image), 30,  10);
    context.drawImage(Hqx.defaultHq3x(image), 70,  10);
    context.drawImage(Hqx.defaultHq4x(image), 130, 10);
    context.fillText("Transparent PNG scaled with HQX", 250, 50);
    
    image = new ImageElement(src: "mushroom.gif");
    image.onLoad.listen((Event e){
      
      context.drawImage(image, 10, 80);
      context.drawImage(Hqx.defaultHq2x(image), 30,  80);
      context.drawImage(Hqx.defaultHq3x(image), 70,  80);
      context.drawImage(Hqx.defaultHq4x(image), 130, 80);
      context.fillText("Transparent GIF scaled with HQX", 250, 120);
      
      image = new ImageElement(src: "mushroom.jpg");
      image.onLoad.listen((Event e){
        
        context.drawImage(image, 10, 150);
        context.drawImage(Hqx.defaultHq2x(image), 30,  150);
        context.drawImage(Hqx.defaultHq3x(image), 70,  150);
        context.drawImage(Hqx.defaultHq4x(image), 130, 150);
        context.fillText("Opaque JPG scaled with HQX", 250, 190);
        
        Hqx.deinit();
        
      });
    });
  });
}