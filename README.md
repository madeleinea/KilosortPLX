# KilosortPLX
Uses Kilosort to sort Plexon (.plx and .pl2) files
Using Kilosort to sort Plexon data
Kilosort is an electrophysiology data sorting program that mostly runs through Matlab. The Python package phy can then be used to display the sorted data and edit it. The files available for download here are taken from Kilosort (https://github.com/cortex-lab/KiloSort) and Plexon’s (OmniPlex and MAP Offline SDK Bundle, http://www.plexon.com/software-downloads?tab=2) files, edited and placed together for Kilosort to work with Plexon data.

# Software Requirements:
•	Matlab (2015b or later, if using GPU)
•	Python miniconda 64-bit
	Follow the instructions from https://github.com/kwikteam/phy to install phy-contrib, which will provide a template GUI to display the data and allow for additional manual sorting
	 
	Environment file: https://raw.githubusercontent.com/kwikteam/phy/master/installer/environment.yml 

# Kilosort Installation:
1.	Download all files, and place them in a kilosort folder together on your computer
2.	Ensure that the file you would like to sort is in the RawData Folder of your Kilosort folder. 
3.	In the PLXMasterFile.m file, edit the PATH variable to be the path to your kilosort folder. Use double slashes rather than single ones. Example: 'C:\\Users\\allema\\Desktop\\KilosortPLX\\'
4.	Ensure that the ops.GPU variable in PLXStandardConfig is equal to 0 if you haven’t set up the GPU.
5.	Run PLXMasterFile.m. This is a file that will call all the scripts necessary to run Kilosort. This will create a folder in your kilosort folder with all the outputs for that file in one folder: “Outputs-[your file name]”
•	If you are running .plx files (not .pl2) you will need to enter the number of channels each time you run Kilosort. You may hard-code this in plx_ad_chanmap.m at line 44 by entering n = [number of channels] if all of your files have the same amount of channels recorded.
•	If you are re-running data through Kilosort, changing line 12 of PLXpreprocessdata.m to “if 0” instead of “if 1” will skip the writing of your file to a raw binary file, which takes a lot of time and is unnecessary if your file has already gone through this step.
•	If you would like to run many files without any user input, you will either need to run .pl2 files or hard-code the number of channels, and then place all of the files you would like to sort in the RawData folder.
i.	If you would rather run single files based on user input, you may comment out or delete the script in lines 5-7 and 62-63 PLXMasterFile.m that loop through the data files in the RawData folder, and un-comment out the user input line at line 10 of PLXMasterFile.m.
6.	Once finished, open the terminal and navigate it to the output folder (type: cd [Kilosort Folder]\[Output folder])
7.	Open the terminal and type: source activate phy (omit the “source” if on windows). This will take a few moments.
8.	Type: phy template-gui params.py
9.	phy should then display your sorted data. Use the following link for instructions on how to navigate phy: http://phy-contrib.readthedocs.io/en/latest/template-gui/ 
10.	If you save from phy, two files will be created and saved into your output folder: spike_clusters.npy and cluster_groups.csv. These will keep a record of your classifications of the units for when you run the template again for that file.
11.	Look over the PLXStandardConfig file. This is where most of your sorting parameters are set, so editing these values may help to improve the accuracy of your sorted data.

# Data Extraction from Kilosort/phy in Matlab
The scripts for extracting spike timestamp, event, and waveform data are located in the Post-KilosortData folder in your Kilosort Folder. Running Kilosort will automatically copy the only file you need to run, which will call all of the files in the Post-KilosortData folder. This will create the cell variables: spiketrain, event_timestamps, and averageWF, and save these variables in a workspace into your Outputs folder (“KilosortData.mat”).
spiketrain gives the timestamps for each spike in a cell variable. Each cell is an array of timestamps for one cluster. The timestamps are in milliseconds, based on our sampling rate of 40,000/sec. If you have a different sampling rate, you will need to change the value of 40 at line 4 of create_spiketrain.m. 
event_timestamps gives the timestamps for each event in a cell variable—each cell is an array of timestamps for each event.
averageWF is a cell variable with each cell giving an array of the average amplitude samples for each waveform. If your sampling rate is different than 40,000, you will need to make some changes in the waveformdata.m file at lines 4, 32, 33, 62, 66, and 78.

# Using a GPU
Most desktop computers have a GPU (graphical processing unit) installed in them. Using a GPU with Kilosort can dramatically decrease the time it takes to run the program. First check to see if you have a GPU (google this, it will be different for every operating system). Here is a link to instructions for how to set up the GPU, provided by Kilosort: https://github.com/cortex-lab/KiloSort/tree/master/Docs. It essentially says that you will need to run mexGPUall.m (in the CUDA folder of your download). To do this, you need CUDA, Visual Studio, and a CUDA-enabled GPU (https://developer.nvidia.com/cuda-gpus). It recommends Visual Studio Community 2012 or 2013, but I had to use Visual Studio Professional 2013 (You only need the free trial version of this, you can access this by creating a free DevEssentials account on Microsoft’s website, then search on their downloads page) with Matlab 2016b and CUDA 7.5 on Windows 7. I think this will be different for every computer and software setup. If you are having trouble, check this page for a list of supported compilers (which Visual Studio, in this case) with your Matlab version: https://www.mathworks.com/support/sysreq/previous_releases.html. Also, here is a link to the different versions of CUDA: https://developer.nvidia.com/cuda-toolkit-archive. Figure out which version of CUDA will work with your version of Matlab (Matlab 2017-CUDA 8.0, Matlab 2016-CUDA 7.5), and download the version you need (You will want to get the local version of the installer). Find the Installation Guide for that version and see which software works with it.
Once you have successfully run mexGPUall.m in the CUDA folder, change the ops.GPU variable to 1 instead of 0 in the PLXStandardConfig.m file.
