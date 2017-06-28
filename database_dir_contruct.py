import os
import errno
import glob
import shutil
import scipy.io as io
import cv2
import numpy as np
import matplotlib.pyplot as plt
import sys
import re

# import location for specific functions
path_to_face_front_utilyties = '/home/gonzalo/M9/Methods/face-frontalization'
sys.path.append(path_to_face_front_utilyties)
import check_resources as check
import frontalize
import facial_feature_detector as feature_detection
import camera_calibration as calib

# Identify OS platform 
import platform
working_platform = platform.system()
working_release = platform.release()

##########################################################################################################
# Subssidiary functions #
##########################################################################################################

def make_sure_path_exists(directory):
    if not os.path.exists(directory):
        try:
            os.makedirs(directory)
        except OSError as error:
            if error.errno != errno.EEXIST:
                raise

#

def load_face_frontal_elements(path_to_face_front_utilyties):
    '''
    Routine to prepare elements for face-frontalization module by dougsouza in:
    https://github.com/dougsouza/face-frontalization
    Tal Hassner, Shai Harel, Eran Paz and Roee Enbar, Effective Face Frontalization in Unconstrained Images,
    IEEE Conf. on Computer Vision and Pattern Recognition (CVPR), Boston, June 2015
    '''    
    
    # check for dlib saved weights for face landmark detection 
    # if it fails, dowload and extract it manually from
    # http://sourceforge.net/projects/dclib/files/dlib/v18.10/shape_predictor_68_face_landmarks.dat.bz2
    check.check_dlib_landmark_weights()

    # load detections performed by dlib library on 3D model and Reference Image
    model3D = frontalize.ThreeD_Model(path_to_face_front_utilyties + '/frontalization_models/model3Ddlib.mat', 'model_dlib')
    
    # load mask to exclude eyes from symmetry
    eyemask = np.asarray(io.loadmat(path_to_face_front_utilyties +'/frontalization_models/eyemask.mat')['eyemask'])
    
    return model3D, eyemask    

#

def front_database_build(name, data_path, work_path, eyemask):
    ''' 
    Given the name of the subject in the variable -name-, the path from where to obtain the images, 
    the path to the destiny folder in which to save the database and the eyemask parameter used for
    frontalization of the faces, this routine takes the images from data_path and saves the 
    frontalized face obtained in the work_path separating pictures in folders for each individual. 
    '''
    for x in name[:]:
        pathdir = os.path.join(work_path,x)
    
        #print pathdir #for debug purposes
        make_sure_path_exists(pathdir)
        search_filename = x + "*.pgm"
        search_location = os.path.join(data_path,search_filename)
        #print search_location #for debug purposes
    
        for filepath in glob.glob(search_location):
            
            # Extract filename from the filepath found at search location
            tail = os.path.basename(filepath) #os.path.split(search_location)
            #print tail #for debug purposes
            out_name = tail + 'fr.pgm'
            
            # For MIT-CBCL dataset file naming, break name into the image data provided in filename
            # 'subject' - 'face rotation' - etc
            file_data = re.split(r"[_]", tail)
            #print file_data #for debug purposes
            
            # angular limit for rotated face frontalization
            face_rot = -26
            
            #Copy only the images that have less than face_rot rotation angle
            if os.path.isfile(filepath) and face_rot<float(file_data[1]):
    
                img = cv2.imread(filepath, 1)
                # extract landmarks from the query image
                # list containing a 2D array with points (x, y) for each face detected in the query image
                lmarks = feature_detection.get_landmarks(img)
                # perform camera calibration according to the first face detected
                proj_matrix, camera_matrix, rmat, tvec = calib.estimate_camera(model3D, lmarks[0])

                # perform frontalization
                frontal_raw, frontal_sym = frontalize.frontalize(img, proj_matrix, model3D.ref_U, eyemask)
                #shutil.copy(filepath, pathdir)
                #write frontal_sym to image file in pathdir location
                cv2.imwrite(os.path.join(pathdir,out_name) ,frontal_sym)

##########################################################################################################

if __name__ == "__main__":
    '''
    The goal of this algorithm is to prepare a database with faces frontalized distributed in such away 
    that every individual has its own folder with all of its captions frontalized.
    '''
    #####################################
    # Directories definition section #
    #####################################

    #Directory to build processed dataset
    work_path = "/home/gonzalo/dev/post_data"
    make_sure_path_exists(work_path)
    
    #Directory to from where to extract data
    root_dir = "/home/gonzalo"
    make_sure_path_exists(root_dir)
    data_path = os.path.join(root_dir,"M9","Datasets","MIT-CBCL","training-synthetic")

    #####################################
    # Face-frontalization preparations #
    #####################################
    
    model3D, eyemask = load_face_frontal_elements(path_to_face_front_utilyties)
    
    #####################################
    # Frontalized Database construction #
    #####################################

    # List of subjects numbers for folder creation
    name =["%04d" % x for x in range(10)]
    
    # Launch frontalized faces dataset creation
    front_database_build(name, data_path, work_path, eyemask)
    
