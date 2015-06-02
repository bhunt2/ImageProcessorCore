#include "tbxbindings.h"
#include "svdpi.h"
#include "stdio.h"
#include <inttypes.h>
#include <stdlib.h>

//#define RUN_LOCAL
#define PRINT_CELLA
//#define PRINT_CELLB

#define IMAGE_PIXEL_WIDTH 6
#define BYTES_PER_PIXEL 3
#define CELLS_PER_WIDTH IMAGE_PIXEL_WIDTH - 2
#define CELLS_PER_IMAGE CELLS_PER_WIDTH * CELLS_PER_WIDTH	//The height is the same as the width
#define PIXELS_PER_RESULT CELLS_PER_IMAGE	//They are the same value

FILE* image1;
FILE* image2;
char* image1_name = "Full.bin";
char* image2_name = "B1.bin";
uint8_t* image1_buffer;
uint8_t* image2_buffer;
uint8_t* result_buffer = malloc(PIXELS_PER_RESULT * BYTES_PER_PIXEL * sizeof(uint8_t));
int image1_size;
int image2_size;
uint32_t* cellA_buffers[CELLS_PER_IMAGE];
uint32_t* cellB_buffers[CELLS_PER_IMAGE];

//Function prototypes
int load_images();
int send_3x3_pixels(svBitVecVal*,svBitVecVal*);
void fill_hdl_cell(svBitVecVal*, uint32_t*, const uint8_t);
void print_3x3_cell(uint32_t*, const uint8_t);
void fill_cell_buffer(uint32_t*, uint8_t*, uint32_t, const uint8_t, const uint8_t, const uint8_t);  
int recieve_result_pixel(svBitVecVal*, svBitVecVal*);
int shutdown_hvl();
int file_size(FILE*);
void print_mem_buffer();

/********************************************************************
** Load the two images into memory buffers
********************************************************************/
int load_images() {
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

	bytes_read = fread(i3mage2_buffer, 1, image2_size, image2);
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
	const uint32_t down_pixel = IMAGE_PIXEL_WIDTH * bytes_per_pixel;

	static uint32_t cell_buffer_number = 0;
	static uint32_t anchor_pixelA = 0;
	static uint32_t anchor_pixelB = 0;
	static uint32_t cells_across = 0;

	//Malloc the buffers before sending the pointers off
	cellA_buffers[cell_buffer_number] = malloc(pixels_in_3x3 * sizeof(uint32_t));
	cellB_buffers[cell_buffer_number] = malloc(pixels_in_3x3 * sizeof(uint32_t));

	if(cellA_buffers[cell_buffer_number] == NULL) {
		printf("CellA buffer failed to malloc\n");
		exit(-7);
	}
	if(cellB_buffers[cell_buffer_number] == NULL) {
		printf("CellB buffer failed to malloc\n");
		exit(-8);
	}

	fill_cell_buffer(cellA_buffers[cell_buffer_number], image1_buffer, anchor_pixelA, pixel_width_3x3, pixel_height_3x3, bytes_per_pixel);
	fill_cell_buffer(cellB_buffers[cell_buffer_number], image2_buffer, anchor_pixelB, pixel_width_3x3, pixel_height_3x3, bytes_per_pixel);
	
	cells_across++;

	//Becuase of how the image is laid out in the full image file, we need to move down
	//two pixels when we reach the end of the width of the row. This is done by adding
	//down pixel to the current anchor pixel position.
	anchor_pixelA += bytes_per_pixel;	
	anchor_pixelB += bytes_per_pixel;
	if(cells_across == CELLS_PER_WIDTH) {
		anchor_pixelA += down_pixel;
		anchor_pixelB += down_pixel;
		cells_across = 0;
	}

	#ifdef PRINT_CELLA
	print_3x3_cell(cellA_buffers[cell_buffer_number], pixels_in_3x3);
	#endif

	#ifdef PRINT_CELLB
	print_3x3_cell(cellB_buffers[cell_buffer_number], pixels_in_3x3);
	#endif

	//Finally, fill the 216 bit vector input for the HDL side
	fill_hdl_cell(cellA, cellA_buffers[cell_buffer_number], pixels_in_3x3);
	fill_hdl_cell(cellB, cellB_buffers[cell_buffer_number], pixels_in_3x3);

	cell_buffer_number++;

	return 0;
}

/********************************************************************
** Convert the 9 pixels held in the uin32_t into a 216 bit vector
** for the hdl side
********************************************************************/
void fill_hdl_cell(svBitVecVal* input_cell, uint32_t* cell_buffer, const uint8_t pixels_in_cell) {
	const uint32_t RGB_bitmask = 0xFFFFFF;	//We only want 24 bits out of the cell_buffer values
	const uint8_t shift_adder = 24;
	int counter;
	int shift_amount = 0;
	
	*input_cell = 0;

	for(counter = 0; counter < pixels_in_cells; counter++) {
		*input_cell |= (cell_buffer[counter] & RGB_mask) << shift_amount;
		shift_amount += shift_adder;
	}
}

/********************************************************************
** This function prints out the hex values of the 3x3 cell being sent
** to the hdl side of the veloce
********************************************************************/
void print_3x3_cell(uint32_t* cell_to_print, const uint8_t pixels_in_cell) {
	int counter = 0;
	uint32_t t, t2, t3;

	for(counter = 0; counter < pixels_in_cell; counter+= 3) {
		t = cell_to_print[counter];
		t2 = cell_to_print[counter + 1];
		t3 = cell_to_print[counter + 2];
		printf("%02X %02X %02X ",t & 0xFF, (t & 0xFF00) >> 8, (t & 0xFF0000) >> 16);
		printf("%02X %02X %02X ",t2 & 0xFF, (t2 & 0xFF00) >> 8, (t2 & 0xFF0000) >> 16);
		printf("%02X %02X %02X\n",t3 & 0xFF, (t3 & 0xFF00) >> 8, (t3 & 0xFF0000) >> 16);
	}

	printf("\n");
}

/********************************************************************
** Fills up a memory buffer that contains the RGB data for a 3x3 cell
********************************************************************/
void fill_cell_buffer(uint32_t* cell_buffer, uint8_t* image_buffer, uint32_t anchor_pixel, 
							const uint8_t pixel_width, const uint8_t pixel_height, 
							const uint8_t bytes_per_pixel) {
	const uint8_t shift_green = 8;
	const uint8_t shift_blue = 16;
	const uint32_t down_pixel = IMAGE_PIXEL_WIDTH * bytes_per_pixel;

	uint32_t height, width, current_pixel, anchor_offset;

	for(height = 0; height < pixel_height; height++) {
		for(width = 0; width < pixel_width; width++) {
			current_pixel = (pixel_width * height) + width;	//Calc the current pixel in the 3x3 cell
			anchor_offset = anchor_pixel + (down_pixel * height) + (bytes_per_pixel * width);

			cell_buffer[current_pixel] = image_buffer[anchor_offset] | (image_buffer[anchor_offset + 1] << shift_green) |
										  		  (image_buffer[anchor_offset + 2] << shift_blue);
		}
	}
}

/********************************************************************
** Recieves the resulting pixel from the hdl
********************************************************************/
int recieve_result_pixel(svBitVecVal* result, svBitVecVal* done) {
	const uint32_t bytes_in_result = PIXELS_PER_RESULT * BYTES_PER_PIXEL;
	static uint32_t result_image_position = 0;
	
	result_buffer[result_image_position] = *result & 0xFF;
	result_buffer[result_image_position + 1] = (*result & 0xFF00) >> 8;
	result_buffer[result_image_position + 2] = (*result & 0xFF0000) >> 16;

	result_image_position += 3;	//Move to the next pixel

	if(result_image_position > bytes_in_result) *done = 1;
	else *done = 0;

	return 0;
}

/********************************************************************
** Final function to call before the end of the simulation
********************************************************************/
int shutdown_hvl() {
	int free_count;

	free(image1_buffer);
	free(image2_buffer);
	free(result_buffer);

	for(free_count = 0; free_count < CELLS_PER_IMAGE; free_count++) {
		free(cellA_buffers[free_count]);
		free(cellB_buffers[free_count]);
	}

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

	rewind(input_file);

	return file_size;
}


#ifdef RUN_LOCAL
int main() {
	load_images();

	//Print out the whole image
	send_3x3_pixels();
	send_3x3_pixels();
	send_3x3_pixels();
	send_3x3_pixels();

	shutdown_hvl();

	return 0;
}
#endif

