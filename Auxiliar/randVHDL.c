#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <math.h>

#define TAM 256

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

	for(i = 0; i < TAM; i++)
		printf("%d:%d;\n", i, rand()%1200);

	//Impressão do final
	printf("END;\n");

	return 0;
}
