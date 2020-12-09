#include <stdio.h>
#include <math.h>

unsigned int a[3]={1,2,3};
unsigned int n=3;


int main()
{
   float b=sqrt(a[0]*a[0]+a[1]*a[1]+a[2]*a[2]);
   printf("It is %f", b);
   return 0;

}
