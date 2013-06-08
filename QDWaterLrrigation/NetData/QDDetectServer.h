/*******************************************************************
 
 File name: QDDetectServer
 
 Description: 
 1、判断服务器是否可达；
 
 History: 历史悠久。
 
 Note:
 1.host是IP地址或者主机名，如果是主机名，不能有路径（目录）。比如www.baidu.com是合法host；
 
 2.代理必须实现，代理方法会自动推送到主线程执行；代理的NSNumber存放的是BOOL值，表示是否可达；
 
 3.端口号：1-65535之间，否则默认为80； 超时：2-75，否则默认10；
 
 *******************************************************************/

#import <Foundation/Foundation.h>

@protocol QDDetectServerDelegate;

@interface QDDetectServer : NSObject

@property (nonatomic, assign) id <QDDetectServerDelegate> delegate;

//同步判断服务器是否可达
+ (BOOL) synchronousDetectHost:(NSString *)host portNumber:(short)port timeOut:(int)time;

//异步判断服务器是否可达
- (id) initWithHost:(NSString *)host portNumber:(short)port timeOut:(int)time andDelegete:(id<QDDetectServerDelegate>)theDelegate;

@end

@protocol QDDetectServerDelegate <NSObject>

@required
//回传给主线程，服务器是否可达
- (void) serverIsReachable:(NSNumber *)isReachable;

@end


