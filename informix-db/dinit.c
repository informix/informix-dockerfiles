#include <stdio.h>
#include <signal.h>
#include<unistd.h>


char *garg1;
char *garg2;

void sig_handler (int signo)
{
   if (signo == SIGINT || signo == SIGTERM)
   {
      //printf("Shutdown:\n");
      system(garg2);
   }

printf("Received signal %d\n",signo);
}


int main(int argc, char *argv[])
{ 

garg1=argv[1];
garg2=argv[2];
/*
printf("argv[1]: %s\n", garg1);
printf("argv[2]: %s\n", garg2);
*/
if (signal(SIGINT, sig_handler) == SIG_ERR)
   printf("Can't catch SIGINT\n");
if (signal(SIGTERM, sig_handler) == SIG_ERR)
   printf("Can't catch SIGTERM\n");
if (signal(SIGKILL, sig_handler) == SIG_ERR)
   printf("Can't catch SIGKILL\n");

system(garg1);

while (1)
{
   sleep(10);
}


//pause();


return 0;

}
