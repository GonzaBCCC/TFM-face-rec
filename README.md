# TFM-face-rec

This is a face-rec project including functions such as:

-Frontalized faces database construction.

To build a frontalized database starting form a database such as MIT-CBCL faces dataset, it makes use of face-frontalization module by dougsouza in order to process every caption and build a database for face recognition with frontalization preprocess already performed.

Face-frontalization in python version is property of dougsouza:

https://github.com/dougsouza/face-frontalization

For more information on face-frontalization method applied, refer to:

Tal Hassner, Shai Harel, Eran Paz and Roee Enbar, Effective Face Frontalization in Unconstrained Images, IEEE Conf. on Computer Vision and Pattern Recognition (CVPR), Boston, June 2015 


For MIT-CBCL database refer to:

http://cbcl.mit.edu/software-datasets/heisele/facerecognition-database.html

Credit is hereby given to the Massachusetts Institute of Technology and to the Center for Biological and Computational Learning for providing the database of facial images. 

For more information on the database refer to: 

"B. Weyrauch, J. Huang, B. Heisele, and V. Blanz. Component-based Face Recognition with 3D Morphable Models, First IEEE Workshop on Face Processing in Video, Washington, D.C., 2004."

14/08/2017:
Matlab implementations for experiments have been uploaded. These are mostly the facerec proyect by bytefish (https://github.com/bytefish/facerec) with addition of particular experimentation scripts designed to fit MIT-CBCL database preprocessed with face detection and frontalization.

Face detection is performed by using Haar Cascade object detection implemented by Matlab.
