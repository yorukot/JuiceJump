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

print("Created three separate 32x32 images:")
print("- white_box.png")
print("- blue_box.png")
print("- black_box.png")