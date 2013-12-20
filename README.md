Introduction
========

From [Wikipedia](https://en.wikipedia.org/wiki/Hqx):
hqx ("hq" stands for "high quality" and "x" stands for magnification) is one of the 
pixel art scaling algorithms developed by Maxim Stepin, used in emulators such as 
Nestopia, bsnes, ZSNES, Snes9x, FCE Ultra and many more. There are 3 hqx filters: 
hq2x, hq3x, and hq4x, which magnify by factor of 2, 3, and 4 respectively. hqx-dart 
is a dart port of [hqx-java](https://github.com/Arcnor/hqx-java), which is a port of 
hqxSharp for C#, which itself is a port of the original hqx C project.

Usage
========

```dart
ImageElement image = new ImageElement(src: "mushroom.png");
image.onLoad.listen((Event e){

	Hqx.init();
    
	context.drawImage(image, 10, 10);
	context.drawImage(Hqx.defaultHq2x(image), 30, 10);
	context.drawImage(Hqx.defaultHq3x(image), 70, 10);
	context.drawImage(Hqx.defaultHq4x(image), 130, 10);
    
	Hqx.deinit();
}
```

Example
========
[![Example](https://raw.github.com/prasser/hqx_dart/master/example.png)](https://raw.github.com/prasser/hqx_dart/master/example.png)