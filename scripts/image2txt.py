from PIL import Image
import argparse

def img2txt(imgpath, txtpath) :
    img = Image.open(imgpath)
    file = open(txtpath, "w")
    pixel = img.load()
    row, collumn = img.size
    file.write(str(row) + " " + str(collumn) + "\n")
    for x in range(row):
        for y in range(collumn):
            p = pixel[x, y]
            file.write(" ".join([str(i) for i in p]) + '\n')
    file.close()

def parse():
    parser = argparse.ArgumentParser()

    parser.add_argument("--img", type=str, required=True)
    parser.add_argument("--txt", type=str, required=True)
    args = parser.parse_args()
    return args.img, args.txt

if __name__ == "__main__":
    img, txt = parse()
    img2txt(img, txt)