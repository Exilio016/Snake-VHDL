#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <math.h>

#define TAM 1200

long int dec2bin (int dec){
	long int i, bin = 0;
	
	for(i = 0; dec >= 2; i++){
		bin += (dec%2 * pow(10, i));
		dec = dec/2;
	}
	bin += (dec * pow(10, i));


	return bin;	

}

int main (int argc, char *argv[]){
	srand(time(NULL));
	int i;

	//Impressão do cabeçalho
	printf("WIDTH=16;\nDEPTH=%d;\nADDRESS_RADIX=UNS;\nDATA_RADIX=UNS;\n\nCONTENT BEGIN\n", TAM);

	//Impressão da primeira linha do monitor
	for(i = 0; i < 40; i++){
		printf("%d:0000", i); //cabeçalho do vec_char
		printf("%04ld", dec2bin(3)); //cor do vec_char
		printf("%08ld;\n", dec2bin('X')); //caracter do vec_char		
	}
	
	for(i = 40; i < 618; i++){
		printf("%d:0000",i); //cabeçalho do vec_char
		printf("%04ld", dec2bin(3)); //cor do vec_char
		if(i%40 == 38 || i%40 == 39)
			printf("%08ld;\n", dec2bin('X')); //caracter do vec_char
		else
			printf("00000000;\n");

	}
	
	//Impressão da cobra
	for(i = 618; i < 621; i++){
		printf("%d:0000",i); //cabeçalho do vec_char
		printf("%04ld", dec2bin(2)); //cor do vec_char
		printf("%08ld;\n", dec2bin(79)); //caracter do vec_char
		
	}
	
	for(i = 621; i < 1160; i++){
		printf("%d:0000",i); //cabeçalho do vec_char
		printf("%04ld", dec2bin(3)); //cor do vec_char
		if(i%40 == 0 || i%40 == 39)
			printf("%08ld;\n", dec2bin('X')); //caracter do vec_char
		else
			printf("00000000;\n");

	}
	
	for(i = 1160; i < 1200; i++){
		printf("%d:0000",i); //cabeçalho do vec_char
		printf("%04ld", dec2bin(3)); //cor do vec_char
		printf("%08ld;\n", dec2bin('X')); //caracter do vec_char		

	}


	//Impressão do final
	printf("END;\n");

	return 0;
}
