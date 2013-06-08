//网络数据接口


#import "QDNetRequstData.h"
#import "QDDetectServer.h"
#import <netinet/in.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "objc/runtime.h"


#define HTTPIP [[NSUserDefaults standardUserDefaults]objectForKey:@"httpIPAddress"]
#define ALLHTTPURL [NSString stringWithFormat:@"http://%@/Watering/",HTTPIP]


#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"
#define STRING_CONTENT @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define MULTIPART @"multipart/form-data; boundary=------------0x0x0x0x0x0x0x0x"



#define NOTIFY_AND_LEAVE(X) {[self cleanup:X]; return;}
#define DATA(X)	[X dataUsingEncoding:NSUTF8StringEncoding]

@interface QDNetRequstData()
{
     Class delegateClass;
}
@end

@implementation QDNetRequstData
@synthesize GlobalVariables;
@synthesize isAutoLogin;
@synthesize delegate;
#pragma mark //初始化方法
-(id)init
{
    if (self)
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aaaaaaaaaaaaaaaaaa) name:@"loginBTName" object:nil];
    
        web_view=[QDPublicWebView sharePublicProperty];
        web_view.delegate=self;
        
    }
    return self;
}

-(void) setDelegate:(id)theDelegate
{
    if (!theDelegate) return;
    
    delegate = theDelegate;
    delegateClass = object_getClass(theDelegate);
    
}

-(Boolean)isDelegate
{
    if (!delegate) return NO;
    
    Class currentClass = object_getClass(delegate);
    
    return (currentClass == delegateClass);
}

#pragma mark  判断本地wifi是否打开
- (BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

//网络判断
-(void)netStateByData:(NSData *)returnData;
{
    
     NSArray *httpIPArr=[HTTPIP componentsSeparatedByString:@":"];
    if ([httpIPArr count])
    {
        NSString *ipStr =[httpIPArr objectAtIndex:0];
        short port = [[httpIPArr objectAtIndex:1] integerValue];
        int timeout = 5;
        //判断服务器是否可达
        if ([QDDetectServer synchronousDetectHost:ipStr portNumber:port timeOut:timeout])
        {
            if ([returnData length]>0)
            {
                //数据获取异常
                if ([self isDelegate])
                {
                    if ([delegate respondsToSelector:@selector(servernotResponding:)])
                    {
                        [delegate servernotResponding:@"Data load failure"];
                    
                    }
                }
            }
        }
        else
        {
            //判断本地wifi是否打开
            if (![self connectedToNetwork])
            {
                //提示用户本地wifi当前处于关闭状态
                if ([self isDelegate])
                {
                    if ([delegate respondsToSelector:@selector(servernotResponding:)])
                    {
                        [delegate servernotResponding:@"Server is unreachable--Your local wifi current is at the off-position"];
                        
                    }
                }
            }
            else
            {
                if ([self isDelegate])
                {
                    if ([delegate respondsToSelector:@selector(servernotResponding:)])
                    {
                        [delegate servernotResponding:@"Server is unreachable"];
                        
                    }
                }
            }

                        
        }
        
    }
    
}

#pragma mark //post 方式
-(NSData *)postDataimage:(NSString *)url imagedata:(NSData *)dataStr
{
    //建立请求
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    //设置超时
    [request setTimeoutInterval:10];
    //设置请求方式
    [request setHTTPMethod:@"POST"];
    //设置HTTPBody
    [request setHTTPBody:dataStr];
    //激活网络
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSError *err=nil;
    //请求数据
    NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:nil error:&err];
    NSLog(@"%@",err);
    //数据判断
    if (!data)
    {
        [self netStateByData:data];
        [request release];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return nil;
    }
    else
        
    {
        [request release];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        //json解析数据并返回
        return data;
    }
}



#pragma mark //post 方式
-(NSData *)postDataWith:(NSString *)url data:(NSString *)dataStr
{
    //建立请求
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    //设置超时
    [request setTimeoutInterval:10];
    //设置请求方式
    [request setHTTPMethod:@"POST"];
    //设置HTTPBody
    [request setHTTPBody:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
    //激活网络
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSError *err=nil;
    //请求数据
    NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:nil error:&err];
    NSLog(@"%@",err);
    //数据判断
    if (!data)
    {
        [request release];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return nil;
    }
    else
        
    {
        [request release];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        //json解析数据并返回
        return data;
    }
}
#pragma mark//  get方式
-(NSData *)getDataFromURL:(NSString *)url
{

    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSError *err=nil;
    NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:nil
                                                       error:&err];
    if (!data)
    {
        [request release];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return nil;
    }
    else
        
    {
        [request release];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return data;
    }
}
#pragma mark //点击auto界面中的Save按钮
-(void)clicksaveauto:(NSMutableArray *)arr autodic:(NSMutableDictionary *)dic
{
    NSString *OFFON;
    NSString *MIST;
    NSString *loginPath;
    NSString *weekstring;
    weekstring =@"";
    NSString *datastring;
    datastring=@"";
    
    for (int i=0; i<[arr count]; i++)
    {
        
        if (((QDManualAuroCell*)[arr objectAtIndex:i]).ON_OFF_Sw.on)
        {
            OFFON=@"ON";
        }
        else
        {
            OFFON=@"OFF";
            
        }
        if (((QDManualAuroCell*)[arr objectAtIndex:i]).Mist_cont.on)
        {
            MIST=@"Mist";
        }
        else
        {
            MIST=@"Cont";
        }
        
        NSString *Manual_str=[NSString stringWithFormat:@"isopen%@=%@&mode%@=%@&alltime%@=%@",[NSString stringWithFormat:@"%i",i+1],OFFON,[NSString stringWithFormat:@"%i",i+1],MIST,[NSString stringWithFormat:@"%i",i+1],((QDManualAuroCell*)[arr objectAtIndex:i]).number_label.text];
        
        if ([datastring isEqualToString:@""])
        {
            datastring =[NSString stringWithFormat:@"%@%@",datastring,Manual_str];
        }
        else
        {
            datastring =[NSString stringWithFormat:@"%@&%@",datastring,Manual_str];
        }
        
    }
    NSArray *Arrtim=[[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"wateringSchedule"]componentsSeparatedByString:@","];
    [Arrtim retain];
    
    for (int i=0; i<[Arrtim count]; i++)
    {
        NSString *str;
        if ([[Arrtim objectAtIndex:i]isEqualToString:@"true"])
        {
             str= [NSString stringWithFormat:@"week%i=%@",i+1,@"1"];
        }
        else
        {
            str= [NSString stringWithFormat:@"week%i=%@",i+1,@"0"];
        }
       
        if ([weekstring isEqualToString:@""])
        {
            weekstring =[NSString stringWithFormat:@"%@%@",weekstring,str];
        }
        else
        {
            weekstring =[NSString stringWithFormat:@"%@&%@",weekstring,str];
        }

    }
    loginPath=[NSString stringWithFormat:@"%@SaveProgram",ALLHTTPURL];
    [Arrtim release];
     NSString *logindataStr =[NSString stringWithFormat:@"%@&%@&hour=%@&minute=%@&programId=%@",datastring,weekstring,[[[NSUserDefaults standardUserDefaults] objectForKey:@"timerDic"] objectForKey:@"startTime1"],[[[NSUserDefaults standardUserDefaults] objectForKey:@"timerDic"] objectForKey:@"startTime2"],[[NSUserDefaults standardUserDefaults] objectForKey:@"autoprogramId"]];
    
    //post请求返回的数据
    NSData *login_Data=[self postDataWith:loginPath data:logindataStr];
      
     if ([login_Data length]!=0)
    {
        if ([self isDelegate])
        {
            if ([delegate respondsToSelector:@selector(returndatasuccess)])
            {
                [delegate returndatasuccess];
            }
        }
        NSLog(@"服务器正常");
    }
    else
    {
        string=nil;
        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }
    

}
#pragma mark //点击ManualView中的Save按钮相应的方法
-(void)clickSaveBT:(NSMutableArray*)arr 
{
    NSString *OFFON;
    NSString *MIST;
    
    NSString *loginPath;
    NSString *logindataStr;
    logindataStr=@"";
    
    for (int i=0; i<[arr count]; i++)
    {

            if (((QDManualAuroCell*)[arr objectAtIndex:i]).ON_OFF_Sw.on)
            {
                OFFON=@"O N";
            }
            else
            {
                OFFON=@"OFF";
                
            }
            if (((QDManualAuroCell*)[arr objectAtIndex:i]).Mist_cont.on)
            {
                MIST=@"Mist";
            }
            else
            {
                MIST=@"Cont";
            }
       
        NSString *Manual_str=[NSString stringWithFormat:@"isopen%@=%@&mode%@=%@&alltime%@=%@",[NSString stringWithFormat:@"%i",i+1],OFFON,[NSString stringWithFormat:@"%i",i+1],MIST,[NSString stringWithFormat:@"%i",i+1],((QDManualAuroCell*)[arr objectAtIndex:i]).number_label.text];
        
        if ([logindataStr isEqualToString:@""])
        {
            logindataStr =[NSString stringWithFormat:@"%@%@",logindataStr,Manual_str];
        }
        else
        {
            logindataStr =[NSString stringWithFormat:@"%@&%@",logindataStr,Manual_str];
        }
    
    }
    loginPath=[NSString stringWithFormat:@"%@UpdateTiming",ALLHTTPURL];
    logindataStr =[NSString stringWithFormat:@"%@&programId=%@&isstart=%@",logindataStr,[[NSUserDefaults standardUserDefaults]objectForKey:@"programIdManual" ],[[NSUserDefaults standardUserDefaults]objectForKey:@"start_stop" ]];
    //post请求返回的数据
     NSData *login_Data=[self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        if ([self isDelegate])
        {
            if ([delegate respondsToSelector:@selector(returndatasuccess)])
            {
                [delegate returndatasuccess];
            }
        }
         NSLog(@"服务器正常");
    }
    else
    {
        string=nil;
        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }
        
 

}
#pragma mark //读取文件的路径
-(void)readFilePath
{
    NSString *bundleString=[[NSBundle mainBundle] pathForResource:@"netdata" ofType:@"js"];
    NSString *requst_js_data=[NSString stringWithContentsOfFile:bundleString encoding:4 error:nil];
    string =requst_js_data;
    
}
#pragma mark //发送数据Setting
-(void)settingSaverequest:(NSMutableDictionary *)dic
{
    //请求的URl
    NSString *loginPath=[NSString stringWithFormat:@"%@SaveSeting",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"setingId=%@&percentage=%@&dutyCycle=%@&allWaterText=%@&mode=%@&tolerance=%@&humidity=%@&LordDelayTime=%@&DelayTime=%@&input1=%@&input2=%@&input3=%@&resetFlowRate=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"settingID"],[dic objectForKey:@"percentage"],[dic objectForKey:@"dutyCycle"],[dic objectForKey:@"allWaterText"],[dic objectForKey:@"mode"],[dic objectForKey:@"tolerance"],[[NSUserDefaults standardUserDefaults]objectForKey:@"autohumidity"],[dic objectForKey:@"LordDelayTime"],[dic objectForKey:@"DelayTime"],[dic objectForKey:@"input1"],[dic objectForKey:@"input2"],[dic objectForKey:@"input3"],[dic objectForKey:@"resetFlowRate"] ];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
        string=nil;
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark  //setting界面calibrate flow 数据发送
-(void)settingflowreBTquest:(NSMutableDictionary *)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveSettingResetFlowRate",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&settingId=%@",[dic objectForKey:@"value"],[dic objectForKey:@"settingId"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        
        NSLog(@"服务器可达");
        
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //setting界面中Mist Duty Cycle
-(void)settingrequestcycle:(NSString *)str
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveSettingPercentage",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&settingId=%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"settingID"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }
 
}
#pragma mark //setting界面中Mist Duty Cycle two
-(void)settingrequestcycleTwo:(NSString *)str
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveSettingDutyCycle",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&settingId=%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"settingID"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //setting reset tolal flow
-(void)settingrequesresetolalFlow:(NSString *)str
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveSettingToZero",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&settingId=%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"settingID"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //setting设置24Vac or pulse
-(void)requestsetting24VacPulse:(NSString *)str
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveSettingMode",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&settingId=%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"settingID"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //setting Master Valve Delay Time 发送数据接口
-(void)requestMasterValveDelay:(NSString *)str
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveSettingLordDelayTime",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&settingId=%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"settingID"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }
 
}
#pragma mark //setting Zone Delay Time 发送数据接口
-(void)requestzoneDelayTime:(NSString *)str
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveSettingDelayTime",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&settingId=%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"settingID"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }
    
}
#pragma mark //setting FlowSensor Calibration 发送数据接口
-(void)requestFlowSensorCalibration:(NSString *)str
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveSettingInput1",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&settingId=%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"settingID"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }
    
}
#pragma mark //setting Flow Rate Tolerance 发送数据接口
-(void)requestFlowRateTolerance:(NSString *)str
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveSettingTolerance",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&settingId=%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"settingID"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }
    
}
#pragma mark //setting Input2 发送数据接口
-(void)sendInput2:(NSString *)str
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveSettingInput2",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&settingId=%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"settingID"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }
    
}

#pragma mark //setting Input3 发送数据接口
-(void)sendInput3:(NSString *)str
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveSettingInput3",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&settingId=%@",str,[[NSUserDefaults standardUserDefaults]objectForKey:@"settingID"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }
    
}
#pragma mark //setting select sensor 数据发送接口
-(void)requestselectSensor:(NSMutableDictionary*)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveFettleSensor",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&fettleId=%@",[dic objectForKey:@"value"],[dic objectForKey:@"fettleId"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}

#pragma mark //Setting设置数据接口
-(void)requstSettingData
{
    GlobalVariables=SETTING;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:SETTING] forKey:@"GlobalVariables"];
    NSURL *url =[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@SetingServlet",ALLHTTPURL]];
    [web_view.request_URL setURL:url];
    [web_view loadRequest:web_view.request_URL];
    [url release];

}

#pragma mark //Weather设置数据接口
-(void)requstWeatherData
{
    GlobalVariables=WEATHER;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:WEATHER] forKey:@"GlobalVariables"];
    NSURL *url =[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@Weather",ALLHTTPURL]];
    [web_view.request_URL setURL:url];
    [web_view loadRequest:web_view.request_URL];
    [url release];
    
}
-(void)stopIrrigatingAt:(NSMutableDictionary*)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveWeatherRain",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&userId=%@",[dic objectForKey:@"value"],[dic objectForKey:@"userId"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
-(void)clickWeatherHigherThan:(NSMutableDictionary*)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveWeatherOpenTEMP",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&userId=%@",[dic objectForKey:@"value"],[dic objectForKey:@"userId"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
-(void)clickTempTextField:(NSMutableDictionary *)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@ajaxSaveWeatherCloseTEMP",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&userId=%@",[dic objectForKey:@"value"],[dic objectForKey:@"userId"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
-(void)cityCodeweather:(NSMutableDictionary*)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@SaveWeather",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"citySelect1=%@&tLow2Close=%@&rHigh2Close=%@&tHigh2Open=%@",[dic objectForKey:@"citySelect1"],[dic objectForKey:@"tLow2Close"],[dic objectForKey:@"rHigh2Close"],[dic objectForKey:@"tHigh2Open"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
-(void)clickWeatherONBT:(NSMutableDictionary *)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveWeatherIsOpen",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&userId=%@",[dic objectForKey:@"value"],[dic objectForKey:@"userId"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}

- (NSData*)generateFormDataFromPostDictionary:(NSDictionary*)dict
{
    id boundary = @"------------0x0x0x0x0x0x0x0x";
    NSArray* keys = [dict allKeys];
    NSMutableData* result = [NSMutableData data];
	
    for (int i = 0; i < [keys count]; i++)
    {
        id value = [dict valueForKey: [keys objectAtIndex:i]];
        [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
		if ([value isKindOfClass:[NSData class]])
		{
			// handle image data
			NSString *formstring = [NSString stringWithFormat:IMAGE_CONTENT, [keys objectAtIndex:i]];
			[result appendData: DATA(formstring)];
			[result appendData:value];
		}
		else
		{
			// all non-image fields assumed to be strings
			NSString *formstring = [NSString stringWithFormat:STRING_CONTENT, [keys objectAtIndex:i]];
			[result appendData: DATA(formstring)];
			[result appendData:DATA(value)];
		}
		
		NSString *formstring = @"\r\n";
        [result appendData:DATA(formstring)];
    }
	
	NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", boundary];
    [result appendData:DATA(formstring)];
    return result;
}



#pragma mark //auto界面上传图片的接口
-(void)autoupdateimagedata:(NSMutableDictionary *)dic
{
    
    NSString *loginPath=[NSString stringWithFormat:@"%@InputImg",ALLHTTPURL];
    //请求传入的参数
    
    NSData *postData = [self generateFormDataFromPostDictionary:dic];

    
    //post请求返回的数据
    NSData *login_Data= [self postDataimage:loginPath imagedata:postData];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
    }
    else
    {
        string=nil;
//       [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //点击selectsensor界面的保存按钮
-(void)selectsensor:(NSMutableArray*)arr
{
    NSString *logindataStr=@"";
    NSString *selectStr=nil;

     for (int i=0; i<[arr count]; i++)
     {
        
         selectStr=[NSString stringWithFormat:@"select%i=%@",i+1,[NSString stringWithFormat:@"%i",([[((QDCellFlowSenorView *)[arr objectAtIndex:i]).label.text stringByReplacingOccurrencesOfString:@"FlowSensor" withString:@""] intValue]-1)]];
         
         if ([logindataStr isEqualToString:@""])
         {
             logindataStr =[NSString stringWithFormat:@"%@%@",logindataStr,selectStr];
         }
         else
         {
             logindataStr =[NSString stringWithFormat:@"%@&%@",logindataStr,selectStr];
         }


     }
    NSString *loginPath=[NSString stringWithFormat:@"%@SaveFlowSensor",ALLHTTPURL];
    
    NSData *login_Data=[self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        if ([self isDelegate])
        {
            if ([delegate respondsToSelector:@selector(returndatasuccess)])
            {
                [delegate returndatasuccess];
            }
        }
        NSLog(@"服务器正常");
    }
    else
    {
        string=nil;
        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

    
       

}
#pragma mark //点击auto界面中的pickview中的确定按钮
-(void)clickautobutton:(NSString *)str
{
    GlobalVariables=AUTO;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:AUTO] forKey:@"GlobalVariables"];
    NSString *loginPath=[NSString stringWithFormat:@"%@Auto",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"programType=%@",str];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        
        [web_view loadData:login_Data MIMEType:nil textEncodingName:nil baseURL:nil];
        //[self requstAutoData];
        NSLog(@"服务器可达");
        
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //Auto界面星期的发送接口
-(void)autoweeksendrequest:(NSMutableDictionary*)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveProgramWeek",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&programId=%@&weekId=%@",[dic objectForKey:@"value"],[dic objectForKey:@"programId"],[dic objectForKey:@"weekId"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {

        NSLog(@"服务器可达");
        
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //Auto界面时间发送数据接口
-(void)autotimesendrequest:(NSMutableDictionary *)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveProgramHour",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&programId=%@&timeM=%@&minute=%@",[dic objectForKey:@"value"],[dic objectForKey:@"programId"],[dic objectForKey:@"timeM"],[dic objectForKey:@"minute"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        
        NSLog(@"服务器可达");
        
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }
 
}
#pragma mark //auto界面数据发送
-(void)autotabrequestonoff:(NSMutableDictionary *)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveProgramIsOpen",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&timingId=%@",[dic objectForKey:@"value"],[dic objectForKey:@"timingId"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        
        NSLog(@"服务器可达");
        
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //auto界面mist发送数据
-(void)automistswrequest:(NSMutableDictionary *)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveProgramMode",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&timingId=%@",[dic objectForKey:@"value"],[dic objectForKey:@"timingId"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        
        NSLog(@"服务器可达");
        
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //auto界面发送设置每个设备的时间接口
-(void)autovcsettime:(NSMutableDictionary*)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveProgramAllTime",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&timingId=%@&number=%@",[dic objectForKey:@"value"],[dic objectForKey:@"timingId"],[dic objectForKey:@"number"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        
        NSLog(@"服务器可达");
        
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //Auto定时界面数据接口
-(void)requstAutoData
{
     GlobalVariables=AUTO;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:AUTO] forKey:@"GlobalVariables"];
    NSURL *url =[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@Auto",ALLHTTPURL]];
    [web_view.request_URL setURL:url];
    [web_view loadRequest:web_view.request_URL];
    [url release];
}
#pragma mark //manualONOff数据发送
-(void)manualonoffrequestdata:(NSMutableDictionary *)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveManualOn",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&timingId=%@&number=%@",[dic objectForKey:@"value"],[dic objectForKey:@"timingId"],[dic objectForKey:@"number"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        
        NSLog(@"服务器可达");
        
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //manualMistCont发送数据
-(void)manualmistcontrequest:(NSMutableDictionary *)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveManualCont",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&timingId=%@&number=%@",[dic objectForKey:@"value"],[dic objectForKey:@"timingId"],[dic objectForKey:@"number"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        
        NSLog(@"服务器可达");
        
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //manual界面中时间数据上传
-(void)manualtimedatarequest:(NSMutableDictionary *)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveManualCont",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"value=%@&timingId=%@&number=%@",[dic objectForKey:@"value"],[dic objectForKey:@"timingId"],[dic objectForKey:@"number"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        
        NSLog(@"服务器可达");
        
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //manual界面手动发送start/stop
-(void)manualstartSop:(NSMutableDictionary *)dic
{
    NSString *loginPath=[NSString stringWithFormat:@"%@AjaxSaveManualStart",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"programIsStart=%@&programId=%@",[dic objectForKey:@"programIsStart"],[dic objectForKey:@"programId"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        
        NSLog(@"服务器可达");
        
    }
    else
    {
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //Manual手动界面数据接口
-(void)requstManualData
{
    
    GlobalVariables=MANUAL;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:MANUAL] forKey:@"GlobalVariables"];
    NSURL *url =[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@Manual",ALLHTTPURL]];
    [web_view.request_URL setURL:url];
    [web_view loadRequest:web_view.request_URL];
    [url release];
    
}
#pragma mark //点击summary的警告按钮
-(void)clicksummaryBT:(NSString *)str
{

    NSString *row_string=[[NSUserDefaults standardUserDefaults]objectForKey:@"summayr_row"];
    NSLog(@"_____________------------____row_string%@",row_string);
    NSString *loginPath=[NSString stringWithFormat:@"%@UpdateAlarm",ALLHTTPURL];
    //请求传入的参数  
    NSString *logindataStr=[NSString stringWithFormat:@"id=%@&data=%@&userId=%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"Summary_error_ID"]objectAtIndex:[row_string intValue]+8],str,[[NSUserDefaults standardUserDefaults] objectForKey:@"summary_useID_error"]];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
        
    }
    else
    {
        string=nil;
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}

#pragma mark //点击summary的警告按钮主阀门
-(void)clickzhufamensummaryBT:(NSString *)str
{

    NSString *loginPath=[NSString stringWithFormat:@"%@UpdateMasterAlarm",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"id=%@&data=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"zhuFaMenID"],str];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
        
    }
    else
    {
        string=nil;
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }
    
}

#pragma mark //点击summary界面CancelWatrng按钮
-(void)requestsummarycancelwating:(NSString *)str
{
    NSString *loginPath=[NSString stringWithFormat:@"%@MasterSwitch",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"data=%@",str];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        NSLog(@"服务器可达");
        
    }
    else
    {
        string=nil;
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //Summary
-(void)requstSummaryData
{
    
    GlobalVariables=SUMMARY;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:SUMMARY] forKey:@"GlobalVariables"];
    NSURL *url =[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@fettel",ALLHTTPURL]];
    [web_view.request_URL setURL:url];
    [web_view loadRequest:web_view.request_URL];
    [url release];

}
#pragma mark //管理员界面搜索接口
-(void)searchNumber:(NSString *)numberStr
{
    //请求的URl
    NSString *loginPath=[NSString stringWithFormat:@"%@Admin",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"number=%@",numberStr];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        [web_view loadData:login_Data MIMEType:nil textEncodingName:nil baseURL:nil];
        
    }
    else
    {
        string=nil;
//        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //管理员界面数据接口
-(void)requstadminViewData
{
    //[self readFilePath];
    string =@"管理员界面";
    GlobalVariables=ADMIN;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:ADMIN] forKey:@"GlobalVariables"];
    NSURL *url =[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@jsp/alluser.jsp",ALLHTTPURL]];
    [web_view.request_URL setURL:url];
    [web_view loadRequest:web_view.request_URL];
    [url release];
}
#pragma mark //登陆接口
-(void)loginrequstName:(NSString *)name Password:(NSString *)password
{
    GlobalVariables=LOGIN;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:LOGIN] forKey:@"GlobalVariables"];
     //请求的URl
    NSString *loginPath=[NSString stringWithFormat:@"%@login",ALLHTTPURL];
    //请求传入的参数
    NSString *logindataStr=[NSString stringWithFormat:@"username=%@&password=%@",name,password ];
    //post请求返回的数据
    NSData *login_Data= [self postDataWith:loginPath data:logindataStr];
    if ([login_Data length]!=0)
    {
        [web_view loadData:login_Data MIMEType:nil textEncodingName:nil baseURL:nil];
        string =@"document.getElementById('error').innerText";
    }
    else
    {
        string=nil;
        [self netStateByData:login_Data];
        NSLog(@"服务器不可达");
    }

}
#pragma mark //注册接口
-(void)registrationInterfaceName:(NSString*)name Password:(NSString *)password RepeatPassword:(NSString *)rePassword LicenseNumber:(NSString *)licensenumber
{
    GlobalVariables = REGISTRATION;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:REGISTRATION] forKey:@"GlobalVariables"];
    //请求的URl
    NSString *RegistrationPath=[NSString stringWithFormat:@"%@LoginUser",ALLHTTPURL];
    //请求传入的参数
    NSString *dataStr=[NSString stringWithFormat:@"userName=%@&password=%@&password2=%@&number=%@",name,password,rePassword,licensenumber ];
    //post请求返回的数据
    NSData *registration_Data= [self postDataWith:RegistrationPath data:dataStr];
    if ([registration_Data length]!=0)
    {
        [web_view loadData:registration_Data MIMEType:nil textEncodingName:nil baseURL:nil];
        string =@"document.getElementById('error').innerText";
    }
    else
    {
        string=nil;
        [self netStateByData:registration_Data];
        NSLog(@"服务器不可达");
    }

}
-(void)aaaaaaaaaaaaaaaaaa
{
    [[NSUserDefaults standardUserDefaults]setObject:@"111111" forKey:@"GlobalVariables"];
}

//修改为后台处理登录
-(void)webViewDidFinishLoad:(UIWebView *)webView
{

    NSLog(@"GlobalVariables:%i",GlobalVariables);
    NSString *return_String=@"";
    switch ([[[NSUserDefaults standardUserDefaults] objectForKey:@"GlobalVariables"]intValue])
    {
        case REGISTRATION:
        {
            [web_view stringByEvaluatingJavaScriptFromString:string];
            return_String=[web_view stringByEvaluatingJavaScriptFromString:string];
            if ([self isDelegate])
            {
                if ([delegate respondsToSelector:@selector(returnData:)])
                {
                    [delegate returnData:return_String];
                }
                else
                {
                    self.isAutoLogin = YES;
                    [self aotuLogin];
                }
            }
            else
            {
                self.isAutoLogin = YES;
                [self aotuLogin];
            }

        }
            break;
        case LOGIN:
        {
            [web_view stringByEvaluatingJavaScriptFromString:string];
            return_String=[web_view stringByEvaluatingJavaScriptFromString:string];
            if (isAutoLogin)
            {
                if ([self isDelegate])
                {
                    if ([delegate respondsToSelector:@selector(autoLoginRetun:)])
                    {
                        [delegate autoLoginRetun:return_String];//自动登录返回
                    }
                }
            }
            else
            {
                if ([self isDelegate])
                {
                    if ([delegate respondsToSelector:@selector(returnData:)])
                    {
                        [delegate returnData:return_String];
                    }
                }
            }
        }
            break;
        case ADMIN:
        {
            [self readFilePath];
            [web_view stringByEvaluatingJavaScriptFromString:string];
            return_String=[web_view stringByEvaluatingJavaScriptFromString:@"getAlluserOfAllState();"];
            if ([return_String length]<50)
            {
                self.isAutoLogin = YES;
                [self aotuLogin];
                return;
            }
            if ([self isDelegate])
            {
                if ([delegate respondsToSelector:@selector(returnData:)])
                {
                    [delegate returnData:return_String];
                }
                else
                {
                    self.isAutoLogin = YES;
                    [self aotuLogin];
                }
            }
            else
            {
                self.isAutoLogin = YES;
                [self aotuLogin];
            }
        }
            break;
        case SUMMARY:
        {
            [self readFilePath];
            [web_view stringByEvaluatingJavaScriptFromString:string];
            return_String =[NSString stringWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@%@#%@#%@#%@#%@#%@",[web_view stringByEvaluatingJavaScriptFromString:@"getSummarying();"],[web_view stringByEvaluatingJavaScriptFromString:@"getSummaryOfSummaryByMasterValve();"],[web_view stringByEvaluatingJavaScriptFromString:@"getSummaryOfSummaryByChildValue();"],[web_view stringByEvaluatingJavaScriptFromString:@"getSummaryByProgramType();"],[web_view stringByEvaluatingJavaScriptFromString:@"getSummaryByConnected();"],[web_view stringByEvaluatingJavaScriptFromString:@"getSummaryingBytag();"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('table')[5].rows[0].cells[1].getElementsByTagName('input')[0].value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('programId').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('fettleBinId1')[0].value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('fettleBinId2')[0].value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('fettleBinId3')[0].value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('fettleBinId4')[0].value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('fettleBinId5')[0].value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('fettleBinId6')[0].value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('fettleBinId7')[0].value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('fettleBinId8')[0].value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('fettleBinId9')[0].value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('fettleBinId10')[0].value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('table')[5].rows[2].getAttribute('bgcolor')==null?'#1':document.getElementsByTagName('table')[5].rows[2].getAttribute('bgcolor')"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('table')[5].rows[2].cells[7].getElementsByTagName('table')[0].rows[0].cells[0].innerText.trim()"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('userID').value"],[web_view stringByEvaluatingJavaScriptFromString:@"getbuttonColor(getSummaryingBytag())"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('userID').value"],[web_view stringByEvaluatingJavaScriptFromString:@"getbuttonColor(2)"]];
            if ([return_String length]<50)
            {
                self.isAutoLogin = YES;
                [self aotuLogin];
                return;
            }
            if ([self isDelegate])
            {
                if ([delegate respondsToSelector:@selector(returnData:)])
                {
                    [delegate returnData:return_String];
                }
                else
                {
                    self.isAutoLogin = YES;
                    [self aotuLogin];
                }
            }
            else
            {
                self.isAutoLogin = YES;
                [self aotuLogin];
            }
            
            }
    
            break;
        case MANUAL:
        {
            [self readFilePath];
            [web_view stringByEvaluatingJavaScriptFromString:string];
            
             return_String =[NSString stringWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@",[web_view stringByEvaluatingJavaScriptFromString:@"getManualByRunningState();"],[web_view stringByEvaluatingJavaScriptFromString:@"getManualOfManualByChildValue();"],[web_view stringByEvaluatingJavaScriptFromString:@"getManual();"],[web_view stringByEvaluatingJavaScriptFromString:@"getManualByConnect();"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('programId').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp1').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp2').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp3').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp4').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp5').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp6').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp7').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp8').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp9').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp10').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp1').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp2').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp3').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp4').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp5').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp6').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp7').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp8').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp9').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('manalIdTemp10').value"]];
            if ([return_String length]<50)
            {
                self.isAutoLogin = YES;
                [self aotuLogin];
                return;
            }
            if ([self isDelegate])
            {
                if ([delegate respondsToSelector:@selector(returnData:)])
                {
                    [delegate returnData:return_String];
                }
                else
                {
                    self.isAutoLogin = YES;
                    [self aotuLogin];
                }
            }
            else
            {
                self.isAutoLogin = YES;
                [self aotuLogin];
            }
        }
            break;
        case AUTO:
        {
            [self readFilePath];
            [web_view stringByEvaluatingJavaScriptFromString:string];
             return_String =[NSString stringWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@%@%@%@%@%@%@%@%@%@%@",[web_view stringByEvaluatingJavaScriptFromString:@"getAtuoOfByAuto();"],[web_view stringByEvaluatingJavaScriptFromString:@"getAutoByProgram();"],[web_view stringByEvaluatingJavaScriptFromString:@"getAutoByProgramOne();"],[web_view stringByEvaluatingJavaScriptFromString:@"getManual();"],[web_view stringByEvaluatingJavaScriptFromString:@"getManualByConnect();"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('programId').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timeM').options[document.getElementById('timeM').selectedIndex].value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp1').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp2').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp3').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp4').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp5').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp6').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp7').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp8').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp9').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp10').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('programId').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp1').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp2').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp3').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp4').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp5').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp6').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp7').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp8').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp9').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('timingIdTemp10').value"],[web_view stringByEvaluatingJavaScriptFromString:@"getAtuoOfByAuto2(2);"],[web_view stringByEvaluatingJavaScriptFromString:@"getAtuoOfByAuto2(3);"],[web_view stringByEvaluatingJavaScriptFromString:@"getAtuoOfByAuto2(4);"],[web_view stringByEvaluatingJavaScriptFromString:@"getAtuoOfByAuto2(5);"],[web_view stringByEvaluatingJavaScriptFromString:@"getAtuoOfByAuto2(6);"],[web_view stringByEvaluatingJavaScriptFromString:@"getAtuoOfByAuto2(7);"],[web_view stringByEvaluatingJavaScriptFromString:@"getAtuoOfByAuto2(8);"],[web_view stringByEvaluatingJavaScriptFromString:@"getAtuoOfByAuto2(9);"],[web_view stringByEvaluatingJavaScriptFromString:@"getAtuoOfByAuto2(10);"],[web_view stringByEvaluatingJavaScriptFromString:@"getAtuoOfByAuto2(11);"]];
            if ([return_String length]<50)
            {
                self.isAutoLogin = YES;
                [self aotuLogin];
                return;
            }
            if ([self isDelegate])
            {
                if ([delegate respondsToSelector:@selector(returnData:)])
                {
                    [delegate returnData:return_String];
                }
                else
                {
                    self.isAutoLogin = YES;
                    [self aotuLogin];
                }
            }
            else
            {
                self.isAutoLogin = YES;
                [self aotuLogin];
            }
        }
            break;
        case SETTING:
        {
            [self readFilePath];
            [web_view stringByEvaluatingJavaScriptFromString:string];
            return_String =[NSString stringWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@#%@",[web_view stringByEvaluatingJavaScriptFromString:@"getSetting();"],[web_view stringByEvaluatingJavaScriptFromString:@"getManualByConnect();"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('resetFlowRateButton').style.background;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('setingId').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('humidity').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"getSettingFlowSensor()"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('allWaterTextButton').style.backgroundColor"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('fettleId1').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('fettleId2').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('fettleId3').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('fettleId4').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('fettleId5').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('fettleId6').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('fettleId7').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('fettleId8').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('fettleId9').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('fettleId10').value"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('mode')[0].disabled"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('mode')[1].disabled"]];
            if ([return_String length]<50)
            {
                self.isAutoLogin = YES;
                [self aotuLogin];
                return;
            }
            if ([self isDelegate])
            {
                if ([delegate respondsToSelector:@selector(returnData:)])
                {
                    [delegate returnData:return_String];
                }
                else
                {
                    self.isAutoLogin = YES;
                    [self aotuLogin];
                }
            }
            else
            {
                self.isAutoLogin = YES;
                [self aotuLogin];
            }
        }
            break;
        case WEATHER:
        {
            [self readFilePath];
            [web_view stringByEvaluatingJavaScriptFromString:string];
            return_String =[NSString stringWithFormat:@"%@#%@#%@#%@#%@#%@#%@#%@#%@",[web_view stringByEvaluatingJavaScriptFromString:@"getWeather();"],[web_view stringByEvaluatingJavaScriptFromString:@"getFunction();"],[web_view stringByEvaluatingJavaScriptFromString:@"getCityCode();"],[web_view stringByEvaluatingJavaScriptFromString:@"getStop();"],[web_view stringByEvaluatingJavaScriptFromString:@"getStart();"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('rHigh2Close').options[document.getElementById('rHigh2Close').selectedIndex].text;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('userId').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('rHigh2Close').value;"],[web_view stringByEvaluatingJavaScriptFromString:@"document.getElementById('lastRun').innerText;"]];
            if ([return_String length]<50)
            {
                self.isAutoLogin = YES;
                [self aotuLogin];
                return;
            }
            if ([self isDelegate])
            {
                if ([delegate respondsToSelector:@selector(returnData:)])
                {
                    [delegate returnData:return_String];
                }
                else
                {
                    self.isAutoLogin = YES;
                    [self aotuLogin];
                }
            }
            else
            {
                self.isAutoLogin = YES;
                [self aotuLogin];
            }
        }
            
            break;
            
        default:
            break;
    }
       

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [self netStateByData:nil];
}

//重新登录
-(void)aotuLogin
{
    //登出执行
    [[NSUserDefaults standardUserDefaults]setObject:@"111111" forKey:@"GlobalVariables"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userNameStr = [userDef objectForKey:@"useName"];
    NSString *userPasswordStr = [userDef objectForKey:@"useName"];
    [self loginrequstName:userNameStr Password:userPasswordStr];
}


@end
