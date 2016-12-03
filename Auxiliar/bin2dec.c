#include <stdio.h>
#include <stdlib.h>



int main (int argc, char *argv[]){
    int i, c = 0;
    int indice, bin;

    for(i = 0; i < 8; i++){
        while(c != '\n')
            c = fgetc(stdin);
    }
    scanf("%d:%d;", &indice, &bin);
    printf("%d:%d;\n", indice, bin2dec(bin));
}
