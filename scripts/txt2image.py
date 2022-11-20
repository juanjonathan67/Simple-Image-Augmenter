import argparse
from PIL import Image

def txt2img(imgpath, txtpath, augpath) :
    ori = Image.open(imgpath)
    txt = open(txtpath, "r")
    row, collumn = ori.size
    gray = Image.new("L", (row, collumn))
    for y in range(collumn):
        for x in range(row):
            color = int(txt.readline())
            gray.putpixel((x, y), color)
    gray.save(augpath, "PNG")
    txt.close()

def parse():
    parser = argparse.ArgumentParser()

    parser.add_argument("--img", type=str, required=True)
    parser.add_argument("--txt", type=str, required=True)
    parser.add_argument("--aug", type=str, required=True)
    args = parser.parse_args()
    return args.img, args.txt, args.aug

if __name__ == "__main__":
    img, txt, aug = parse()
    txt2img(img, txt, aug)