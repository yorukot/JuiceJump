from PIL import Image

# Define box size
BOX_SIZE = 32

# Create white box
white_img = Image.new('RGB', (BOX_SIZE, BOX_SIZE), color='white')
white_img.save('white_box.png')

# Create blue box
blue_img = Image.new('RGB', (BOX_SIZE, BOX_SIZE), color='blue')
blue_img.save('blue_box.png')

# Create black box
black_img = Image.new('RGB', (BOX_SIZE, BOX_SIZE), color='black')
black_img.save('black_box.png')

# Create red box
red_img = Image.new('RGB', (BOX_SIZE, BOX_SIZE), color='red')
red_img.save('red_box.png')

# Create green box
green_img = Image.new('RGB', (BOX_SIZE, BOX_SIZE), color='green')
green_img.save('green_box.png')

# Create yellow box
yellow_img = Image.new('RGB', (BOX_SIZE, BOX_SIZE), color='yellow')
yellow_img.save('yellow_box.png')

print("Created six separate 32x32 images:")
print("- white_box.png")
print("- blue_box.png")
print("- black_box.png")
print("- red_box.png")
print("- green_box.png")
print("- yellow_box.png")