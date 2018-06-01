# TFM-face-rec

This is a face-rec project based on VGG_face neural network. It's application is intended for reduced data sets, testing the limits of a deep learning approach under unfavorable conditions. As this is a prototype for a feasible implementation, jupyter notebooks are used:

## Preprocessing

First auxiliary utility is given by notebook 'database_dir_contruct' which is used for setting the dataset for its use on training and testing VGG_face. Dataset is converted to fit network's requirement, then datum is created in 'Resize_datum' notebook. Finally datum is converted to lmbd file in 'create_lmdb' so as to optimize performance.

### The database used for the experiments is a frontalized faces dataset:

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


## Training and testing network

Notebook 'caffe_trainwbatch_face_rec' is used for network training using the image batches assorted for such in a way that we can define what face rotation angles are admitted as training samples and configuring for different sample size per angle.

The 'caffe_test_face_rec' tests the trained VGG_face net on one predefined set of test images returning each image groundtruth, prediction label and time spent on prediction.

The 'caffe_face_rec_implement' is analogous to 'caffe_test_face_rec' but it allows to define the size of the test batch and the face rotation angles admitted, giving a TPR for each rotation angle and amount of training samples per angle.

The goal was to identify the limitations of VGG_face net over an specific dataset covering aspects such as sample size and face orientation with respect to camera.


