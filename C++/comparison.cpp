


// image_generator.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <algorithm>
#include <string.h>



void hextochar(unsigned char hex,  char &lower,  char &upper)
{
	unsigned char lowerin = (hex & 0x0F);
	hex = (hex & 0xF0) >> 4;

	lower = 0;
	upper = 0;

	if (lowerin < 10)
	{
		lower = lowerin + '0';
	}
	else
	{
		lower = 'A' + lowerin - 10;
	}

	if (hex < 10)
	{
		upper = hex + '0';
	}
	else
	{
		upper = 'A' + hex - 10;
	}




}



int main()
{
	unsigned long long size;
	unsigned long long size2;
	unsigned long long position = 0;
	unsigned int positionreal = 0;
	unsigned int skip2 = 0;

	std::ifstream imagesource("test.bit", std::ios::in | std::ios::binary | std::ios::ate);
	if (imagesource.is_open())
	{
		
		size = imagesource.tellg();
		size = 5000;
		char * memblock = new char[size];
		imagesource.seekg(0, std::ios::beg);
		imagesource.read(memblock, size);
		imagesource.close();
		char newfile[20000];
		

		std::cout << "the entire file content is in memory\n";


		for (unsigned long long i = 0; i < size; i++)
		{
			
			unsigned char hex = memblock[i];
			char upper=0;
			char lower=0;
			

			hextochar(hex, lower, upper);
			
			newfile[position] = upper;
			position++;
			newfile[position] = lower;
			position++;


		}

		std::ofstream image("newdata.txt", std::ios::out | std::ios::binary);


		char* buffer = new char[1];
		char endls[2] = { '\r','\n' };
		



		for (int t = 0; t < 500; t++)
		{

			
			if (t == 6 || t == 7)
			{

			}
			else
			{
				
				if ((skip2) % 3 == 0 && skip2!=0)
				{
					image.write(endls, 2);
				}
				skip2++;
				std::cout << newfile[t];
				buffer = &newfile[t];
				image.write(buffer, 1);
				
				
			}



			

		}
		

		


		std::cout << "the entire file content is in memory";



		//delete[] memblock;
	}
	else std::cout << "Cannot open file";

}

