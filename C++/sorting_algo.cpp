// cpptest.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <string>
int main()
{
	unsigned char fpga[6] = { 255   , 127   , 66   , 157   , 220   , 191};
	                     //   RG     B //R    GB//   RG     B//R      GB
	
	unsigned char bitmap[12];

	for (int i = 0; i < 6; i++)
	{
		if (i % 3 == 0)
		{
			
			bitmap[i*2 + 2] = 0xF0 & fpga[i];
			bitmap[i *2 + 1] = (0x0F & fpga[i])<<4;

		}
		else if (i % 3 == 1)
		{
			std::cout << (int)fpga[i] << std::endl;
			bitmap[(i-1) * 2] = 0xF0 & fpga[i];
			bitmap[(i-1) * 2 +5] = (0x0F & fpga[i]) << 4;

		}
		else if (i % 3 == 2)
		{
			bitmap[(i - 2) * 2 + 4] = 0xF0 & fpga[i];
			bitmap[(i - 2) * 2 + 3] = (0x0F & fpga[i]) << 4;
		}
	}
	

	for (int i = 0; i < 12; i++)
	{
		std::cout << (unsigned int)bitmap[i] << " ";
	}
	std::cout << std::endl;





	


}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
