#include "socket_server.h"

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>

static void *
_poll(void * ud) {
	struct socket_server *ss = ud;
	struct socket_message result;
	for (;;) {
		int type = socket_server_poll(ss, &result, NULL);
		// DO NOT use any ctrl command (socket_server_close , etc. ) in this thread.
		switch (type) {
		case SOCKET_EXIT:
			return NULL;
		case SOCKET_DATA:
			printf("message(%lu) [id=%d] size=%d msg:%s",result.opaque,result.id, result.ud, result.data);
			free(result.data);
			break;
		case SOCKET_CLOSE:
			printf("close(%lu) [id=%d]\n",result.opaque,result.id);
			break;
		case SOCKET_OPEN:
			printf("open(%lu) [id=%d] %s\n",result.opaque,result.id,result.data);
			break;
		case SOCKET_ERROR:
			printf("error(%lu) [id=%d]\n",result.opaque,result.id);
			break;
		case SOCKET_ACCEPT:
			printf("accept(%lu) [id=%d %s] from [%d]\n",result.opaque, result.ud, result.data, result.id);
			socket_server_start(ss, 400, result.ud);
			break;
		}
	}
}

static void
test() {
	struct sigaction sa;
	sa.sa_handler = SIG_IGN;
	sigaction(SIGPIPE, &sa, 0);

	struct socket_server * ss = socket_server_create();
	pthread_t pid;
	pthread_create(&pid, NULL, _poll, (void*)ss);

	int conn_id = socket_server_connect(ss,100, "127.0.0.1", 8888);
	printf("connecting %d\n", conn_id);

	char buf[1024] = {0};
	while(fgets(buf, sizeof(buf), stdin) != NULL){
		if (strncmp(buf, "quit", 4) == 0)
			break;
		char *sendbuf = (char*)malloc(strlen(buf)+1);
		memcpy(sendbuf, buf, strlen(buf)+1);
		socket_server_send(ss, conn_id, sendbuf, sizeof(sendbuf));

	}

	socket_server_exit(ss);
	//pthread_join(pid, NULL); 
	socket_server_release(ss);
}

int
main() {
	test();
	return 0;
}
