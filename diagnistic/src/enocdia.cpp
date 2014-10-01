#include "EnOcean.h"
#include <iostream>
#include <fstream>
#define DEVICE "/dev/ttyUSB0"
#define SPEED B57600

bool existFile(const std::string& name)
{
    std::ifstream ttyfile(name.c_str(),std::ios::binary);

    if(!ttyfile)            // If the file was not found, then file is 0, i.e. !file=1 or true.
        return false;    // The file was not found.
    else                 // If the file was found, then file is non-0.
        return true;     // The file was found.
}

int main(int argc, char *argv[])
{
	std::string port;

	if(argc == 1) {
		port = DEVICE;
	}
	if(argc == 2) {
		port = argv[1];
	}
	if(argc > 2) {
		printf("Zu viele Parameter.\n");
		printf("Default Serial Port is /dev/ttyUSB0.\n");
		printf("Starten sie das Programm mit einem Parameter um eine anderes device zu benutzen.\n");
		printf("Aufrufbeispiel: enocedia /dev/ttyUSB0\n");
	}

	if (!existFile(port.c_str()))
	{
		printf("Die Datei %s scheint nicht zu existieren.\n", port.c_str());
		printf("Default Serial Port is /dev/ttyUSB0.\n");
		printf("Starten sie das Programm mit einem Parameter um eine anderes device zu benutzen.\n");
		printf("Aufrufbeispiel: enocedia /dev/ttyUSB0\n");
		return (1);
	}


	EnOcean TheOcean;

	if (TheOcean.addSensor("008281C9", 0, 40) != 0)
	{
		printf("Error can not add Sensor ID, ID %s is not a valid ID", "008281C9");
	}
	printf("Start programm on serial device %s.\n", port.c_str());
	TheOcean.start(port.c_str());

	while (1);
}



