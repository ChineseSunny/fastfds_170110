#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/wait.h>


int main(int argc,char * argv[])
//int myupload_byexec(char *filename,char *file_id)
{
	if(argc < 2 )
	{
			printf("a.out filename");
	}
	
	int pipefd[2];
	
	int ret = pipe(pipefd);
	
	if(-1 == ret)
	{
		perror("pipe error");
		exit(0);
	}
	
	pid_t pid = fork();
	
	if(-1 == pid)
	{
		
		perror("fork error");
		exit(0);
	}
	if( 0 == pid)
	{
		//写，关闭读
		close(pipefd[0]);
		
		dup2(pipefd[1],STDOUT_FILENO);
		
		execlp("./src/fdfs_upload_file","upload","/etc/fdfs/client.conf",argv[1],NULL);
	}
	
	if(pid > 0 )
	{
		sleep(0.3);
		//从管道读数据，关闭写
		close(pipefd[1]);
		
		char buf[1024]={0};
		
		wait(NULL);
		
		int len = read(pipefd[0],buf,sizeof(buf));
		printf("%s\n",buf);
		close(pipefd[0]);
		
	}
	
}