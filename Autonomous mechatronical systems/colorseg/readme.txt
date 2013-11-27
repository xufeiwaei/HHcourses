READ ME :  Colour segmentation    2-3-99   AJB
-------------------------------------------------

Demonstration of two possible colour segmentation algorithms

	a) Colour images normalised with intensity / see msdemo.m
        
        b) Colour images of RGB type /see msdemo2.m

msdemo.m
========

Demonstration of normalised colour segmentation

Choose a reference pixel of the object to be segmented
in the displayed colour image with the mouse and press <return>.
After a while the distance image is displayed in grey-level where
white means very close and black means far away.
The histogram of the distance image is displayed and the
final binary image (a fixed threshold is used).

Input: filename of an RGB picture  (file is of .bmp type)

For example:   msdemo('shandbok.bmp');

uses: colseg.m, getpict.m.

msdemo2.m
=========

Demonstration of colour segmentation RGB

Choose a reference pixel of the object to be segmented
in the displayed colour image with the mouse and press <return>.
After a while the distance image is displayed in grey-level where
white means very close and black means far away.
The histogram of the distance image is displayed and the
final binary image (a fixed threshold is used).

Input: filename of an RGB picture  (file is of .bmp type)

For example:   msdemo('shandbok.bmp');

uses: colseg.m, getpict.m.


colseg.m     
========

Colour segmentation based on two normalised colours.

Input: Two of the three normalised colour images 
       and a reference pixel representing the class mean.



colsegrgb.m
===========

Colour segmentation based on the RGB colours.

Input: The three colour images RGB 
       and a reference pixel representing the class mean.


getpict.m
=========

Reads in an image from file and returns the colour, the
normalised colour as well as the intensity image.
[rgb,r,g,b,i,rn,gn,bn] = getpict(filename);

