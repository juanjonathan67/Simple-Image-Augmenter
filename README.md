# Simple Image Augmenter

The goal of this project is to use VHDL to create a Simple Image Augmenter that can be implemented on an FPGA. Because FPGAs can be customized for specific tasks, they can often perform those tasks more efficiently than a general-purpose computer. This makes them well-suited for performing simple, concurrent operations, like those involved in image augmentation.

The Simple Image Augmenter is a tool for performing basic image transformations, such as flipping, rotating, and adjusting brightness. It uses a finite state machine to define the different augmentation states, which can be triggered by user input (e.g. pressing a button). The FPGA reads in an image from a text file, applies the desired transformations, and then writes the augmented image back out to a text file. A Python script is used to convert the text file to an image format that can be viewed by the user.

## Installation

Clone the repository

For scripts, use pip to install argparse and PIL

On terminal :
```bash
pip install argparse Pillow
```

## Usage

Convert image to txt

On terminal (Path to Simple Image Augmenter):
```bash
python .\scripts\image2txt.py --img .\images\yourimage --txt .\images\textfile
```

Example :
![alt text](https://github.com/juanjonathan67/Simple-Image-Augmenter/blob/main/ReadMe/image2txtex.png?raw=true)


Convert txt to image

On terminal (Path to Simple Image Augmenter):
```bash
python .\scripts\txt2image.py --aug .\images\augmentedimage --txt .\images\textfile 
```

Example :
![alt text](https://github.com/juanjonathan67/Simple-Image-Augmenter/blob/main/ReadMe/txt2imageex.png?raw=true)

For VHDL (Simulation) :
Add the .vhd files on the VHDL folder to a ModelSim project
Compile in order :
TypeDeclarations.vhd -> SimpleImageAugmenter_functions.vhd -> SimpleImageAugmenter.vhd (top level) -> SimpleImageAugmenter_tb.vhd (testbench, optional)

Compile Steps (ModelSim) :
![alt text](https://github.com/juanjonathan67/Simple-Image-Augmenter/blob/main/ReadMe/CompileSteps.png?raw=true)


## Test Results



## Contributing
