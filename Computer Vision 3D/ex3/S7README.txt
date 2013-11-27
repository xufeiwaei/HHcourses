************************************************************

    SOFA - SEQUENCES FOR OPTICAL FLOW ANALYSIS
    SYNTHETIC TEST SEQUENCES WITH FULL GROUND TRUTH

************************************************************

Emanuele Trucco and Ioannis Lalos
Computer Vision Group and Ocean Systems Laboratory

Dept of Computing and Electrical Engineering
Heriot-Watt University

April 1998


DISCLAIMER. All the data and information in this package are supplied
        "as is". No guarantee is given on their accuracy, completeness,
        or correctness. No responsibility can be accepted for damages,
        losses or any other situation caused directly or indirectly
        by the use of this package.


You can use it and redistribute SOFA at will, but *PLEASE REMEMBER*:

a) IF YOU PUBLISH RESULTS obtained by processing SOFA data,
   please include the acknowledgment "SOFA synthetic sequences courtesy
   of the Computer Vision Group, Heriot-Watt University
      (http://www.cee.hw.ac.uk/~mtc/sofa)".

b) IF YOU REDISTRIBUTE SOFA, please make sure that this README
   file is included AND READ.


For information, problems, etc, contact Emanuele Trucco (mtc@cee.hw.ac.uk)

---------------------------------------------------------------------------


1) FILES
--------

In this directory there are the following files:

  I)   S7README - this text file.

  II)  S7img1.gif
       S7img2.gif
        .
        .
        .
       S7img100.gif - sequence of images in .gif format

  III) S7orth1.gif
       S7orth2.gif
       S7orth3.gif - 3 orthographic projections of the scene indicating the
                     size and the position of the scene in the world reference 
                     frame (.gif format)



2) INTRINSIC PARAMETERS
-----------------------

Image size in pixels = (768 x 512) 
Focal length = 9.000000 (in world units)
Pixels per unit on Y-axis  = 116.279068 
Pixels per unit on X-axis  = 120.481926 
Image centre in pixels = (383.000000 x 255.000000)



3) SCENE & WORLD REFERENCE FRAME
--------------------------------

The scene contains a stair model of 12 steps.
Step height = 10.08 world units
Step width  = 10.08 world inits
Step/Model length = 139 world units
Model width = 122.09 world units
Model height = 120.2 world units
Note that the 12th step (last top) has different height and width from the
rest, i.e. width = 11.21, height = 9.32.   

The World reference frame (Xw,Yw,Zw) is a right-handed system and its origin
(0,0,0) lies in one of the bottom corners of the model.

For more information you may view the images in the following files :
S7orth1.gif, S7orth2.gif, S7orth3.gif



4) CAMERA
---------

A Perspective Camera is used for taking different snapshots of the scene.
The camera is translating parallel to the Zw-axis and always points 
perpendicular to the X-Y plane(world).

The initial rotation matrix of the camera is given with respect to the default
camera reference frame.

The default camera reference frame has the same origin as the world reference
frame but it is rotated 180 degrees around the Yw-axis,i.e.

              Yc = Yw, Xc = -Xw, Zc = -Zw.

(NB: c=camera reference frame, w=world reference frame)



5) LIGHTS
---------

There is one static light in the scene. Its location is (-30, 260, -30)w and it
radiates light equally in all directions.



6) EXTRINSIC PARAMETERS
----------------------- 

Initial position of centre of projection : (-600.000000, 100.000000, 0.000000)w 

Initial camera rotation with respect to the default camera reference frame:
I)
By angle: 1.570796 (in radians)    -     89.999992 (in degrees) 
around the unit vector : (0.000000, -1.000000, 0.000000)w 

II)
Rotation matrix :  0.000000  0.000000  1.000000  0.000000 
                   0.000000  1.000000  0.000000  0.000000 
                  -1.000000  0.000000  0.000000  0.000000 
                   0.000000  0.000000  0.000000  1.000000 



6.1) Motion information
-----------------------

The camera is moving in front of the stationary scene.

-  Camera Translation : | Xw = -600 
                        | Yw = 100 
                        | Zw(i+1) = Zw(i) + dZ

   where dZ = 2

-  Rotational velocity : 0


7) ACKNOWLEDGEMENTS
-------------------

We would like to thank Francesco Isgro` for allowing us to simulate his real
experiment in this sequence.
