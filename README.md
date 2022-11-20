# Simple Image Augmenter

Simple Image Augmenter utilizes VHDL for fast image augmenting algorithms. Images are to be converted to .txt files and vice - versa using python scripts.

## Installation

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
![alt text](https://github.com/juanjonathan67/Simple-Image-Augmenter/blob/main/image2txtex.png?raw=true)


Convert txt to image

On terminal (Path to Simple Image Augmenter):
```bash
python .\scripts\txt2image.py --aug .\images\augmentedimage --txt .\images\textfile 
```

Example :
![alt text](https://github.com/juanjonathan67/Simple-Image-Augmenter/blob/main/txt2imageex.png?raw=true)


## Contributing
