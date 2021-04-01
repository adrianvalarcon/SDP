// image_generator.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <algorithm>


void fourbyte(unsigned int, char[]);
void twobyte(unsigned short, char[]);
void onebyte(unsigned short, char[]);
void pixel(int, int, int, char[]);
void createHeader(unsigned int, unsigned int, char[]);

long long loadp = 2;


int main()
{
	const unsigned int height = 40;
	const unsigned int width = 40;
	int n;

	unsigned int padlength = 4 - (width * 3) % 4;
	char data2[54];
	const char writedata = 0;
	createHeader(width, height, data2);
	//onebyte(50, data2);
	std::ofstream image2("image2.bmp", std::ios::out | std::ios::binary);

	image2.write(data2, 54);
	image2.close();

	char * memblock;
	std::streampos size;


	if (padlength == 4) padlength = 0;
	
	std::ifstream imagesource("image.bit", std::ios::in | std::ios::binary | std::ios::ate);
	if (imagesource.is_open())
	{
		size = imagesource.tellg();
		memblock = new char[size];
		imagesource.seekg(0, std::ios::beg);
		imagesource.read(memblock, size);
		imagesource.close();

		const long long cheat = loadp + (long long)size;

		char* result = new char [cheat];
		for (int i = 0; i < cheat; i++)
		{
			if (i < 54)
			{
				result[i] = data2[i];
			}
			else
			{
				result[i] = memblock[i - 54];
			}
		}
		std::ofstream image("image.bmp", std::ios::out | std::ios::binary);

		image.write(result, loadp + (long long)size);
		image.close();


		std::cout << "the entire file content is in memory";

		//delete[] memblock;
	}
	else std::cout << "Cannot open file";


	/*for (int vert = 0; vert < height; vert++)
	{
		for (int horz = 0; horz < width; horz++)
		{
			pixel(0, 255, 255, data2);
		}
		for (int pad = 0; pad < padlength; pad++)
		{
			onebyte(0, data2);
		}
	}*/
	
	

	/*
	char* buffer = new char[1];


	for (long long i = 0; i < loadp  ; i++)
	{
		buffer = &data2[i];
		image.write(buffer, 1);
	}
	*/






}


void fourbyte(unsigned int value, char data2[])
{

	data2[loadp] = (char)(value & 0xFF);
	loadp++;
	data2[loadp] = (char)((value >> 8) & 0XFF);
	loadp++;
	data2[loadp] = (char)((value >> 16) & 0XFF);
	loadp++;
	data2[loadp] = (char)((value >> 24) & 0XFF);
	loadp++;
}

void twobyte(unsigned short value, char data2[])
{
	data2[loadp] = (char)(value & 0xFF);
	loadp++;
	data2[loadp] = (char)((value >> 8) & 0XFF);
	loadp++;

}

void onebyte(unsigned short value, char data2[])
{
	data2[loadp] = (char)(value & 0xFF);
	loadp++;
}

void pixel(int blue, int green, int red, char data2[])
{
	data2[loadp] = (char)(blue & 0xFF);
	loadp++;
	data2[loadp] = (char)(green & 0xFF);
	loadp++;
	data2[loadp] = (char)(red & 0xFF);
	loadp++;

}

void createHeader(unsigned int width, unsigned int height, char data2[])
{
	unsigned int padlength = 4 - (width * 3) % 4;
	if (padlength == 4) padlength = 0;
	unsigned int imagesize = (width * 3 + padlength) * height;
	unsigned int filesize = imagesize + 54;



	data2[0] = 'B';
	data2[1] = 'M';


	fourbyte(filesize, data2);      // file size;
	fourbyte(0, data2);
	fourbyte(54, data2);                                         // start of data pointer 54

	fourbyte(40, data2);                                         // header length 40
	fourbyte(width, data2);                                      // width
	fourbyte(height, data2);                                     // height
	twobyte(1, data2);                                           // 1
	twobyte(24, data2);                                          // bits per pixel 24
	fourbyte(0, data2);                                          // compression 0
	fourbyte(imagesize, data2);									// data size
	fourbyte(2835, data2);										// dpi horz
	fourbyte(2835, data2);										// dpi vert
	fourbyte(0, data2);											// 0 = 2^n
	fourbyte(0, data2);                                          // special color 0

}



