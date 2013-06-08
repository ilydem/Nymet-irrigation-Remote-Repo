//SettingVC

#import <UIKit/UIKit.h>
#import "QDTimeVC.h"
#import "QDSelectSensorVC.h"
#import "QD24VacorPulseVC.h"
#import <QuartzCore/QuartzCore.h>
#import "QDActivityIndicatorView.h"
#import "QDNetRequstData.h"


@interface QDSettingVC : UIViewController<UITableViewDataSource,UITableViewDelegate,QDDatadelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>
{
    UITableView *tab;
    UIImageView *connet_Set_IV;
    NSString *str_status;
    NSMutableDictionary *str_dic;
}
@end
