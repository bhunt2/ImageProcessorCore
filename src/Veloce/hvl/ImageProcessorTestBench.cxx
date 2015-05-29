#include "tbxbindings.h"
#include "svdpi.h"
#include "stdio.h"
#include <inttypes.h>

#define IMAGE_PIXEL_WIDTH 300

FILE* image1, image2;
char* image1_name, image2_name;
uint8_t* image1_buffer, image2_buffer;

//Function prototypes
int load_images();
int send_3x3_pixels(svBitVecVal*, svBitVecVal*);
int shutdown_hvl();
int file_size(FILE*);

/********************************************************************
** Load the two images into memory buffers
********************************************************************/
int load_images() {
	int image1_size, image2_size;
	int bytes_read;

	image1 = fopen(image1_name, "rb");
	image2 = fopen(image2_name, "rb");

	if(image1 == NULL) {
		printf("Image %s failed to open\n", image1_name);
		exit(-1);
	}
	if(image2 == NULL) {
		printf("Image %s failed to open\n", image2_name);
		exit(-2);
	}

	//Read the first image into memory
	image1_size = file_size(image1);
	image1_buffer = (uint8_t*) malloc(image1_size * sizeof(uint8_t));
	if(image1_buffer == NULL) exit(-3);

	bytes_read = fread(image1_buffer, 1, image1_size, image1);
	if(bytes_read != image1_size) {printf("Error reading first file\n"); exit(-4);}

	//Read the second image into memory
	image2_size = file_size(image2);
	image2_buffer = (uint8_t*) malloc(image2_size * sizeof(uint8_t));
	if(image2_buffer == NULL) exit(-5);

	bytes_read = fread(image2_buffer, 1, image2_size, image2);
	if(bytes_read != image2_size) {printf("Error readin second file\n"); exit(-6);}

	return 0;
}

/********************************************************************
** Send a 3x3 set of pixels to the image procesor core
********************************************************************/
int send_3x3_pixels(svBitVecVal* cellA, svBitVecVal* cellB) {
	const uint8_t bytes_per_pixel = 3;	//One byte for R, G and B
	const uint8_t pixel_width_3x3 = 3;
	const uint8_t pixel_height_3x3 = 3;
	const uint8_t pixels_in_3x3 = pixel_height_3x3 * pixel_width_3x3;

	uint32_t cellA_buffer[pixels_in_3x3];	//3x3 cell with 3 bytes per pixel
	uint32_t cellB_buffer[pixels_in_3x3];	//3x3 cell with 3 bytes per pixel
	static uint32_t anchor_pixelA = 0;
	static uint32_t anchor_pixelB = 0;

	fill_cell_buffer(&cellA_buffer, anchor_pixelA, pixel_width_3x3, pixel_height_3x3, bytes_per_pixel);
	anchor_pixelA += bytes_per_pixel * pixel_width_3x3;	//Move to next 3x3 cell

	fill_cell_buffer(&cellB_buffer, anchor_pixelB, pixel_width_3x3, pixel_height_3x3, bytes_per_pixel);
	anchor_pixelB += bytes_per_pixel * pixel_width_3x3;	//Move to next 3x3 cell

	cellA = (svBitVecVal*)&cellA_buffer;
	cellB = (svBitVecVal*)&cellB_buffer;

	return 0;
}

/********************************************************************
** Fills up a memory buffer that contains the RGB data for a 3x3 cell
********************************************************************/
void fill_cell_buffer(uint32_t* cell_buffer, uint32_t anchor_pixel, const uint8_t pixel_width, 
							 const uint8_t pixel_height, const uint8_t bytes_per_pixel) {
	const uint8_t shift_green = 8;
	const uint8_t shift_blue = 16;
	const uint32_t down_pixel = IMAGE_PIXEL_WIDTH * bytes_per_pixel;

	uint32_t height, width, current_pixel, anchor_offset;

	for(height = 0; height < pixel_height; height++) {
		for(width = 0; width < pixel_width; width++) {
			current_pixel = (pixel_width * height) + width;	//Calc the current pixel in the 3x3 cell
			anchor_offset = anchor_pixel + (down_pixel * height) + (bytes_per_pixel * width);

			cell_buffer[current_pixel] = image1_buffer[anchor_offset] | (image1_buffer[anchor_offset + 1] << shift_green) |
										  (image1_buffer[anchor_offset + 2] << shift_blue);
		}
	}

/********************************************************************
** Final function to call before the end of the simulation
********************************************************************/
int shutdown_hvl() {
	free(image1_buffer);
	free(image2_buffer);

	return 0;
}

/********************************************************************
** Returns the size of the image file
********************************************************************/
int file_size(FILE* input_file) {
	int seek_return, file_size;

	seek_return = fseek(input_file, 0L, SEEK_END);
	if(seek_return) printf("Seek to end of file failed\n");

	file_size = ftell(input_file);
	if(file_size == -1L) printf("ftell failed\n");

	rewind(file_size);

	return file_size;
}
	
