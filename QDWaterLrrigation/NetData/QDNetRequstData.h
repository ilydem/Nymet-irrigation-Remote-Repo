//网络数据接口


@protocol QDDatadelegate <NSObject>

-(void)returnData:(NSString *)string;//返回值的代理方法
-(void)servernotResponding:(NSString *)msgStr;//服务器无响应的时候返回的方法
@optional
-(void)returndatasuccess;
-(void)autoLoginRetun:(NSString *)string;//自动登录返回

@end
#import <Foundation/Foundation.h>
#import "QDPublicWebView.h"
#import "QDManualAuroCell.h"
#import "QDCellFlowSenorView.h"
#define REGISTRATION 1
#define LOGIN 2
#define SUMMARY 3
#define MANUAL 4
#define AUTO 5
#define SETTING 6
#define WEATHER 7
#define ADMIN 8

@interface QDNetRequstData : NSObject<UIWebViewDelegate>
{
    QDPublicWebView *web_view;
    NSString *string;
    
    
    
}
@property (nonatomic,assign)int GlobalVariables;
@property (nonatomic,assign)BOOL isAutoLogin;//是否是自动登录
//注册接口
-(void)registrationInterfaceName:(NSString*)name Password:(NSString *)password RepeatPassword:(NSString *)rePassword LicenseNumber:(NSString *)licensenumber;
//登陆接口
-(void)loginrequstName:(NSString *)name Password:(NSString *)password;
//管理员界面接口
-(void)requstadminViewData;
//summary界面数据接口
-(void)requstSummaryData;
//Manual界面数据接口
-(void)requstManualData;
//auto界面数据接口
-(void)requstAutoData;
//点击manual保存按钮
-(void)clickSaveBT:(NSMutableArray*)arr;
//点击auto界面的save按钮
-(void)clicksaveauto:(NSMutableArray *)arr autodic:(NSMutableDictionary *)dic;
//设置界面的获取数据接口
-(void)requstSettingData;
//auto界面上传Program数据
//-(void)autodatarequestimage:(NSMutableArray *)arr;
//setting界面发送数据
-(void)settingSaverequest:(NSMutableDictionary *)dic;
//点summay的警告按钮
-(void)clicksummaryBT:(NSString *)str;
-(void)clickautobutton:(NSString *)str;
//点击selectsensor界面保存按钮
-(void)selectsensor:(NSMutableArray*)arr;
//auto界面星期的发送接口
-(void)autoweeksendrequest:(NSMutableDictionary*)dic;
//auto界面时间发送接口
-(void)autotimesendrequest:(NSMutableDictionary *)dic;
//auto界面onoff数据发送
-(void)autotabrequestonoff:(NSMutableDictionary *)dic;
//auto界面发送mist数据
-(void)automistswrequest:(NSMutableDictionary *)dic;
//auto发送界面设备的时间接口
-(void)autovcsettime:(NSMutableDictionary*)dic;
//manual界面发送数据onoff
-(void)manualonoffrequestdata:(NSMutableDictionary *)dic;
//manual界面发送数据
-(void)manualmistcontrequest:(NSMutableDictionary *)dic;
//manual界面Start/stop按钮发送数据界面
-(void)manualstartSop:(NSMutableDictionary *)dic;
//auto界面上传图片的接口
-(void)autoupdateimagedata:(NSMutableDictionary *)dic;
//setting界面calibrateFlow按钮数据发送接口
-(void)settingflowreBTquest:(NSMutableDictionary *)dic;
//setting界面duty cycle的数据发送
-(void)settingrequestcycle:(NSString *)str;
//setting界面duty cycle
-(void)settingrequestcycleTwo:(NSString *)str;
//setting Reset Tolal Flow 发送数据几口
-(void)settingrequesresetolalFlow:(NSString *)str;
//setting 24Var or Pulse/Dc 发送接口
-(void)requestsetting24VacPulse:(NSString *)str;
//setting Master Valve DelayTime 发送接口
-(void)requestMasterValveDelay:(NSString *)str;
//setting Zone Delay Time 发送数据
-(void)requestzoneDelayTime:(NSString *)str;
//setting flow Sensor Calibration 发送数据
-(void)requestFlowSensorCalibration:(NSString *)str;
//setting flow rate Tolerance 发送数据
-(void)requestFlowRateTolerance:(NSString *)str;
//setting input2
-(void)sendInput2:(NSString *)str;
//setting input3
-(void)sendInput3:(NSString *)str;
//setting select sensor数据发送接口
-(void)requestselectSensor:(NSMutableDictionary*)dic;
//点击cancelwatring按钮
-(void)requestsummarycancelwating:(NSString *)str;
-(void)clickzhufamensummaryBT:(NSString *)str;
//点击天气界面
-(void)requstWeatherData;
-(void)clickWeatherONBT:(NSMutableDictionary *)dic;//点击Weather界面的ONOFF
-(void)clickTempTextField:(NSMutableDictionary *)dic;//点击Weather界面的Temp
-(void)clickWeatherHigherThan:(NSMutableDictionary*)dic;
-(void)stopIrrigatingAt:(NSMutableDictionary*)dic;
-(void)cityCodeweather:(NSMutableDictionary*)dic;

-(void)aotuLogin;
@property (nonatomic,assign)id<QDDatadelegate>delegate;
@end
