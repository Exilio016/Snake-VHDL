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
	printf("WIDTH=16;\nDEPTH=%d;\nADDRESS_RADIX=UNS;\nDATA_RADIX=BIN;\n\nCONTENT BEGIN\n", TAM);

	//Impressão da primeira linha do monitor
	for(i = 0; i < 1200; i++){
		printf("%d:0000", i); //cabeçalho do vec_char
		printf("%04ld", dec2bin(3)); //cor do vec_char
		printf("%08ld;\n", dec2bin('0'+i%10)); //caracter do vec_char		
	}
	
	
	return 0;
}
