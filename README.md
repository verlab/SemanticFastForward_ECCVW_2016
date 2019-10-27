
[![Version](https://img.shields.io/badge/version-1.0-brightgreen.svg)](http://www.verlab.dcc.ufmg.br/fast-forward-video-based-on-semantic-extraction/#ECCVW2016)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)

# Project #

This project is based on the paper [Towards Semantic Fast-Forward and Stabilized Egocentric Videos](http://www.verlab.dcc.ufmg.br/semantic-hyperlapse/papers/Final_Draft_ECCVW_2016_Towards_Semantic_Fast_Forward_and_Stabilied_Egocentric_Videos.pdf) on the **First International Workshop on Egocentric Perception, Interaction and Computing** at **European Conference on Computer Vision Workshops** (EPIC@ECCVW 2016). It implements a semantic fast-forward method for First-Person videos with a proper stabilization method.

For more information and visual results, please access the [project page](http://www.verlab.dcc.ufmg.br/fast-forward-video-based-on-semantic-extraction).

## Contact ##

### Authors ###

* Michel Melo da Silva - PhD student - UFMG - michelms@dcc.ufmg.com
* Washington Luis de Souza Ramos - MSc student - UFMG - washington.ramos@outlook.com
* João Pedro Klock Ferreira - Undergraduate Student - UFMG - jpklock@ufmg.br
* Mario Fernando Montenegro Campos - Advisor - UFMG - mario@dcc.ufmg.br
* Erickson Rangel do Nascimento - Advisor - UFMG - erickson@dcc.ufmg.br

### Institution ###

Federal University of Minas Gerais (UFMG)  
Computer Science Department  
Belo Horizonte - Minas Gerais -Brazil 

### Laboratory ###

![VeRLab](https://www.dcc.ufmg.br/dcc/sites/default/files/public/verlab-logo.png)

**VeRLab:** Laboratory of Computer Vison and Robotics   
http://www.verlab.dcc.ufmg.br

## Code ##

This project is a two-fold source code. The first fold¹ is composed of MATLAB code to describe the video semantically and to fast-forward it. A stabilizer proper to fast-forwarded video written in C++ using OpenCV is the second fold². You can run each fold separately. 

### Dependencies ###

* ¹MATLAB 2015a or higher  
* ²OpenCV 2.4 _(Tested with 2.4.9 and 2.4.13)_  
* ²Armadillo 6 _(Tested with 6.600.5 -- Catabolic Amalgamator)_  
* ²Boost 1 _(Tested with 1.54.0 and 1.58.0)_  
* ²Doxygen 1 _(for documentation only - Tested with 1.8.12)_  

### Usage ###

The project processing is decribed by the following flowchart:

![Flowchart](https://user-images.githubusercontent.com/23279754/38369324-cf30af52-38bd-11e8-9314-67144f134f5c.jpg)

1. **Optical Flow Estimator:**

    The first step processing is to estimate the Optical Flow of the Input VIdeo. 

    1. First, you should download the [Poleg et al. 2014](http://www.cs.huji.ac.il/~peleg/papers/cvpr14-egoseg.pdf) Flow Estimator code from the [link](http://www.vision.huji.ac.il/egoseg/EgoSeg1.2.zip).
    2. Navigate to the download folder and unzip the code.
    3. Into the Vid2OpticalFlowCSV\Example folder, run the command:

```bash
Vid2OpticalFlowCSV.exe -v < video_filename > -c < config.xml > -o < output_filename.csv >
```

| Options | Description | Type | Example | 			
|--------:|-------------|------|--------|
| ` < Video_filename > ` | Path and filename of the video. | _String_ | `~/Data/MyVideos/myVideo.mp4` |
| ` < config.xml > ` | Path to the configuration XML file. | _String_ | `../default-config.xml` |
| ` < output_filename.csv > ` | Path to save the output CSV file. | _String_ | `myVideo.csv` |

Save the output file using the same name of the input video with extension `.csv`.

2. **Semantic Extractor:**

    The second step is to extract the semantic information over all frames of the Input video and save it in a CSV file. On the MATLAB console, go to the project folder and run the command:

```matlab![epic eccvw_flowchart](https://user-images.githubusercontent.com/23279754/38369324-cf30af52-38bd-11e8-9314-67144f134f5c.jpg)
>> ExtractAndSave(< Video_filename >, < Semantic_extractor_name >)
```

| Parameters | Description | Type | Example | 			
|--------:|-------------|------|--------|
| ` < Video_filename > ` | Path and filename of the video. | _String_ | `~/Data/MyVideos/Video.mp4` |
| ` < Semantic_extractor_name > ` | Semantic extractor algorithm. | _String_ | `'face'` or `'pedestrian'` |

3. **Calculate Speed-up rates**

    To calculate the speed-up rates for each type of segment, on the MATLAB console, go to the project folder and run the following commands:

```matlab
>> [~, < Num_non_semantic_Frames >, < Num_semantic_frames >] = GetSemanticRanges(< Semantic_Data_MAT_filename >);
```

| Parameters | Description | Type | Example | 			
|--------:|-------------|------|--------|
| `< Semantic_Data_MAT_filename >` | File created by the step 2 | _String_ | `'../example_face_extracted.mat'` |

| Output | Description | Type | Example |			
|--------:|-------------|------|--------|
| `< Num_non_semantic_Frames >` | Number of frames in the Non-Semantic segments. (Will be used below.) | _Integer_ | `Tns` |
| `< Num_semantic_Frames >` | Number of frames in the Semantic segments. (Will be used below.) | _Integer_ | `Ts` |

```matlab
>> SpeedupOptimization( < Num_non_semantic_Frames >, < Num_semantic_frames >, < Desired_speedup >, < Max_speedup >, < lambda_1 >, < lambda_2 >, < show_plot > )
```

| Parameters | Description | Type | Example | 			
|--------:|-------------|------|--------|
| `< Num_non_semantic_Frames >` | Number of frames in the Non-Semantic segments. (Obtained from the previous code) | _Integer_ | `Tns` |
| `< Num_semantic_Frames >` | Number of frames in the Semantic segments. (Obtained from the previous code) | _Integer_ | `Ts` |
| `< Desired_speedup >` | Desired speed-up rate to the whole video. | _Integer_ | `10` |
| `< Max_speedup >` | Maximum allowed jump. | _Integer_ | `100` |
| `< Lambda_1 >` | Value of Lambda 1 in the optimization function. | _Integer_ | `40` |
| `< Lambda_2 >` | Value of Lambda 2 in the optimization function. | _Integer_ | `8` |
| `< show_plot >` | Flag to show the search space create by the optimization function. | _Boolean_ | `false` |

4. **Create Experiment** 

    To run the code, you should create an experiment entry. On a text editor, add a case to the `GetVideoDetails` function in the file `SemanticSequenceLibrary.m`:

```matlab
function [videoFile, startInd, endInd, filename, fps] = GetVideoDetails(video_dir,exp_name)

 ...

 case < Experiment_name >
     filename = < video_filename >;
     startInd = < start_index_frame > ;
     endInd   = < final_index_frame >;
     fps      = < video_frames_per_second >;
					
  ... 
  
```

| Fields | Description | Type | Example | 			
|--------:|-------------|------|--------|
| ` < Experiment_name > ` | Name to identify the experiment. | _String_ | `MyVideo` |
| ` < video_filename > ` | Filename to the video. | _String_ | `myVideo.mp4` |
| ` < start_index_frame > ` | Frame index to start the processing. | _Integer_ | `1` |
| ` < final_index_frame > ` | Frame intex to stop the processing. | _Integer_ | `16987` |
| ` < video_frames_per_second > ` | Frames per second of the video. | _Integer_ | `30` |

5. **Semantic Fast-Forward**

    After the previous steps, you are ready to accelerate the Input Video. On MATLAB console, go to the project folder and run the command:

```matlab
>> SpeedupVideo(< Video_dir >, < Experiment_name >, < Semantic_extractor_name >, < Semantic_speedup >, < Non_semantic_speedup >, < Shakiness_weights >, < Velocity_weights >, < Appearance_weights >, < Semantic_weights > )
```			

| Parameters | Description | Type | Example | 			
|--------:|-------------|------|--------|
| ` < Video_dir > ` | Path to the folder where the video file is. | _String_ | `~/Data/MyVideos` |
| ` < Experiment_name > ` | Name set in the SemanticSequenceLibrary.m file. | _String_ | `My_Video` |
| ` < Semantic_extractor_name > ` | Semantic extractor algorithm used in the Semantic Extractor step. | _String_ | `'face'` or `'pedestrian'` |
| ` < Semantic_speedup > ` | Desired speed-up assign to the semantic segments of the input video. | _Integer_ | `3` |   
| ` < Non_semantic_speedup > ` | Desired speed-up assign to the semantic segments of the input video. | _Integer_ | `14` |   
| ` < Shakiness_weights > ` | Tuple of weights related to the shakiness term in the edge weight formulation. | [_Integer_, _Integer_] | `[10,250]` |
| ` < Velocity_weights > ` | Tuple of weights related to the shakiness term in the edge weight formulation. | [_Integer_, _Integer_] | `[50,3000]` |
| ` < Appearance_weights > ` | Tuple of weights related to the shakiness term in the edge weight formulation. | [_Integer_, _Integer_] | `[0,100]` |
| ` < Semantic_weights > ` | Tuple of weights related to the shakiness term in the edge weight formulation. | [_Integer_, _Integer_] | `[500,8]` |

6. **Configure Video Parameters**

    After the Semantic Fast-Forward step, the accelerated video is create. Now we are going to stabilize the output video. The first stabilization step is to configure the video parameters in the file `acceleratedVideoStabilizer/experiment.xml`. Follow the instructions described into the file.

7. **Accelerate Video Stabilizer**

    Navigate to the `<project_folder>/acceleratedVideoStabilizer/` folder. Follow the instructions described into the `<project_folder>/acceleratedVideoStabilizer/README.md` file to compile and run the code.
    
The output of this step is the stabilized semantic fast-forward video. 

## Acknowledgements ##

1.	__EgoSampling__: Y. Poleg, T. Halperin, C. Arora, S. Peleg, Egosampling: Fast-forward and stereo for egocentric videos, in: IEEE Conference on Computer Vision and Pattern Recognition, 2015, pp. 4768–4776. doi:10.1109/CVPR.2015.7299109.
2.  __LK_Blocked_Optical_Flow__: Y. Poleg, C. Arora, S. Peleg, Temporal segmentation of egocentric videos, in: IEEE Conference on Computer Vision and Pattern Recognition, 2014, pp. 2537–2544. doi:10.1109/CVPR.2014.325.
3.  __NPD_Face_Detector__: S. Liao, A. K. Jain, S. Z. Li, A fast and accurate unconstrained face detector, IEEE Transactions on Pattern Analysis and Machine Intelligence 38 (2) (2016) 211–223. doi:10.1109/TPAMI.2015.2448075.
4.  __PMT_Pedestrian_Detector__: P. Dollar, Piotr’s Computer Vision Matlab Toolbox (PMT), https://github.com/pdollar/toolbox.

## Citation ##

If you are using it for academic purposes, please cite: 

M. M. Silva, W. L. S. Ramos, J. P. K. Ferreira, M. F. M. Campos, E. R. Nascimento, **Towards semantic fast-forward and stabilized egocentric videos**, in: _European Conference on Computer Vision Workshops_, Springer International Publishing, Amsterdam, NL, 2016, pp. 557–571. doi:10.1007/978-3-319-46604-0_40.

### Bibtex entry ###

> @InBook{Silva2016,  
> Title = {Towards Semantic Fast-Forward and Stabilized Egocentric Videos},  
> Author = {Silva, Michel Melo and Ramos, Washington Luis Souza and Ferreira, Joao Pedro Klock and Campos, Mario Fernando Montenegro and Nascimento, Erickson Rangel},  
> Editor = {Hua, Gang and J{\'e}gou, Herv{\'e}},  
> Pages = {557--571},  
> Publisher = {Springer International Publishing},  
> Year = {2016},  
> Address = {Cham},  
> Booktitle = {Computer Vision -- ECCV 2016 Workshops: Amsterdam, The Netherlands, October 8-10 and 15-16, 2016, Proceedings, Part I},  
> Doi = {10.1007/978-3-319-46604-0_40},  
> ISBN = {978-3-319-46604-0},  
> Url = { http://dx.doi.org/10.1007/978-3-319-46604-0_40 }   
> }  

#### Enjoy it. ####
