import argparse
from PIL import Image

def txt2img(txtpath, augpath) :
    txt = open(txtpath, "r")
    row, collumn = txt.readline().split(" ", 1)
    row = int(row)
    collumn = int(collumn)
    gray = Image.new("RGB", (row, collumn))
    for y in range(collumn):
        for x in range(row):
            color = tuple(map(int, txt.readline().split(" ", 2)))
            gray.putpixel((x, y), color)
    gray.save(augpath, "PNG")
    txt.close()

def parse():
    parser = argparse.ArgumentParser()

    parser.add_argument("--txt", type=str, required=True)
    parser.add_argument("--aug", type=str, required=True)
    args = parser.parse_args()
    return args.txt, args.aug

if __name__ == "__main__":
    txt, aug = parse()
    txt2img(txt, aug)