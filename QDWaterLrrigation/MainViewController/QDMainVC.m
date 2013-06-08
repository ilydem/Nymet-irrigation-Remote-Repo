//主界面

#import "QDMainVC.h"
#define SUMMARYBAR 1
#define MANUALBAR 2
#define AUTOBAR 3
#define SETTINGBAR 4
#define WEATHERBAR 5

@interface QDMainVC ()

@end

@implementation QDMainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


#pragma mark //初始化方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    UITabBarController *tabBarColler=[[UITabBarController alloc]init];
    tabBarColler.delegate = self;
    QDSummaryVC *Summary_VC=[QDSummaryVC new];
    QDManualVC *Manual_VC=[QDManualVC new];
    QDAutoVC *Auto_VC=[QDAutoVC new];
    QDSettingVC *Setting_VC=[QDSettingVC new];
    QDWeatherVC *Weather_VC=[QDWeatherVC new];
    
    UITabBarItem *item_Summary = [[UITabBarItem alloc] initWithTitle:@"Summary" image:[UIImage imageNamed:@"icon_summary.png"] tag:SUMMARYBAR];
    Summary_VC.tabBarItem = item_Summary; 
    [item_Summary release];
    
    UITabBarItem *item_Manual = [[UITabBarItem alloc] initWithTitle:@"Manual" image:[UIImage imageNamed:@"icon_manual.png"] tag:MANUALBAR];  
    Manual_VC.tabBarItem = item_Manual; 
    [item_Manual release];
    
    UITabBarItem *item_Auto = [[UITabBarItem alloc] initWithTitle:@"Auto" image:[UIImage imageNamed:@"icon_auto.png"] tag:AUTOBAR];  
    Auto_VC.tabBarItem = item_Auto;
    [item_Auto release];
    
    UITabBarItem *item_Setting = [[UITabBarItem alloc] initWithTitle:@"Setting" image:[UIImage imageNamed:@"icon_setting.png"] tag:SETTINGBAR];  
    Setting_VC.tabBarItem = item_Setting;
    [item_Setting release];
    
    UITabBarItem *item_Weather = [[UITabBarItem alloc] initWithTitle:@"Weather" image:[UIImage imageNamed:@"icon_weather.png"] tag:WEATHERBAR];
    Weather_VC.tabBarItem = item_Weather;
    [item_Weather release];

    NSArray *viewControllerArray = [NSArray arrayWithObjects:Summary_VC,Manual_VC,Auto_VC,Setting_VC,Weather_VC,nil];
    tabBarColler.viewControllers = viewControllerArray;  
    tabBarColler.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.navigationController pushViewController:tabBarColler animated:YES];
    [tabBarColler release];  
    [Summary_VC release];
    [Manual_VC release];
    [Auto_VC release];
    [Setting_VC release];
    [Weather_VC release];

}
-(void)dealloc
{
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
