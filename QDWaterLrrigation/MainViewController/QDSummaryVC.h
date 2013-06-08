//SummaryVC

#import <UIKit/UIKit.h>
#import "QDSummaryView.h"
#import "QDNetRequstData.h"
#import "QDActivityIndicatorView.h"
#import "QDCamera.h"
#import "QDSystem.h"

@interface QDSummaryVC : UIViewController<QDDatadelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,QDSummaryViewdelegate,QDCameraDelegate>
{
    UIImageView *connet_ImageView;
    QDCamera *camer;
    BOOL came_Photo;
    UIImageView *masterimage;
    UIButton *Master_BT;
    NSString *err_str;
    NSArray *pick_zonetime_arr;
    BOOL zhu_zi;
    UIButton *Cancel_BT;
    UIButton *Run_BT;
    BOOL run_cancel;
    BOOL stopPlaySoundShock;
}

@end
