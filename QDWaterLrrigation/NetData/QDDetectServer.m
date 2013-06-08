

#import "QDDetectServer.h"
#import <sys/socket.h>
#import <sys/fcntl.h>
#import <netdb.h>
#import <arpa/inet.h>

#define DefaultPort 80
#define DefaultTime 10

#define _Time @"Time"
#define _Port @"Port"
#define _Host @"Host"

@interface QDDetectServer (QDDetectServerPrivate)

- (void) detectHostWithDictionary:(NSDictionary *)serverInfo;

@end

@implementation QDDetectServer

@synthesize delegate;

static int connect_nonb(int sockfd, const struct sockaddr *saptr, socklen_t salen, int nsec);

//根据主机名返回IP
static NSString *getIPAddressForHost(NSString *theHost);


//同步判断服务器是否可达
+ (BOOL) synchronousDetectHost:(NSString *)host portNumber:(short)port timeOut:(int)time
{
    NSString *ipAddress = getIPAddressForHost(host);
    
    if(!ipAddress || ![ipAddress length])
        return NO;
    
    if(port<1 || port > 65535)
        port = DefaultPort;
    
    if(time<2 || time>75)
        time = DefaultTime;
    
    struct sockaddr_in serverAddress;
    bzero(&serverAddress, sizeof(serverAddress));
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_addr.s_addr = inet_addr([ipAddress UTF8String]);
    serverAddress.sin_port = htons(port);
    
    int socketfd = socket(AF_INET, SOCK_STREAM, 0);
    
    if(connect_nonb(socketfd, (struct sockaddr *)&serverAddress, sizeof(serverAddress), time) < 0)
    {
        close(socketfd);
        return NO;
    }
    
    close(socketfd);
    return YES;
}

- (void) detectHostWithDictionary:(NSDictionary *)serverInfo
{
    const char *ipAddress = [[serverInfo objectForKey:_Host] UTF8String];
    const short port = [[serverInfo objectForKey:_Port] unsignedShortValue];
    const int time = [[serverInfo objectForKey:_Time] intValue];
    
    struct sockaddr_in serverAddress;
    bzero(&serverAddress, sizeof(serverAddress));
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_addr.s_addr = inet_addr(ipAddress);
    serverAddress.sin_port = htons(port);
    
    int socketfd = socket(AF_INET, SOCK_STREAM, 0);
    
    BOOL isRech = YES;
    if(connect_nonb(socketfd, (struct sockaddr *)&serverAddress, sizeof(serverAddress), time) < 0)
    {
        isRech = NO;
    }
    close(socketfd);
        
    [(NSObject *)delegate performSelectorOnMainThread:@selector(serverIsReachable:) withObject:[NSNumber numberWithBool:isRech] waitUntilDone:NO];
}


//异步判断服务器是否可达
//初始化方法
- (id) initWithHost:(NSString *)host portNumber:(short)port timeOut:(int)time andDelegete:(id<QDDetectServerDelegate>)theDelegate
{
    self = [super init];
    delegate = theDelegate;
    
    NSString *ipAddress = getIPAddressForHost(host);

    if(!ipAddress || ![ipAddress length])
    {
        [delegate serverIsReachable:NO];
        return self;
    }
    
    if(port<1 || port > 65535)
        port = DefaultPort;
    
    if(time<2 || time>75)
        time = DefaultTime;
    
    NSDictionary *serverInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithString:ipAddress],_Host, [NSNumber numberWithUnsignedShort:port],_Port, [NSNumber numberWithInt:time],_Time, nil];
    [NSThread detachNewThreadSelector:@selector(detectHostWithDictionary:) toTarget:self withObject:serverInfoDic];
    
    return self;
}


static NSString *getIPAddressForHost(NSString *theHost)
{
    struct hostent *host = gethostbyname([theHost UTF8String]);
	if (!host) 
    {
		return nil;
	}
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
}

static int connect_nonb(int sockfd, const struct sockaddr *saptr, socklen_t salen, int nsec)
{
	int				flags, n, error;
	socklen_t		len;
	fd_set			rset, wset;
	struct timeval	tval;
    
	flags = fcntl(sockfd, F_GETFL, 0);
	fcntl(sockfd, F_SETFL, flags | O_NONBLOCK);
    
	error = 0;
	if ( (n = connect(sockfd, saptr, salen)) < 0)
		if (errno != EINPROGRESS)
			return(-1);
    
	/* Do whatever we want while the connect is taking place. */
    
	if (n == 0)
		goto done;	/* connect completed immediately */
    
	FD_ZERO(&rset);
	FD_SET(sockfd, &rset);
	wset = rset;
	tval.tv_sec = nsec;
	tval.tv_usec = 0;
    
	if ( (n = select(sockfd+1, &rset, &wset, NULL,
					 nsec ? &tval : NULL)) == 0)
    {
		close(sockfd);		/* timeout */
		errno = ETIMEDOUT;
		return(-1);
	}
    
	if (FD_ISSET(sockfd, &rset) || FD_ISSET(sockfd, &wset)) 
    {
		len = sizeof(error);
		if (getsockopt(sockfd, SOL_SOCKET, SO_ERROR, &error, &len) < 0)
			return(-1);			/* Solaris pending error */
	} else
		printf("select error: sockfd not set");
    
done:
	fcntl(sockfd, F_SETFL, flags);	/* restore file status flags */
    
	if (error) {
		close(sockfd);		/* just in case */
		errno = error;
		return(-1);
	}
	return(0);
}

@end
