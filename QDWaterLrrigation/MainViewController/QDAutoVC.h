
#import <UIKit/UIKit.h>
#import "QDManualView.h"
#import "QDCamera.h"
#import "QDTimeVC.h"
#import "QDActivityIndicatorView.h"
#import "QDNetRequstData.h"
#import "QDAutoinitIMV.h"

@interface QDAutoVC : UIViewController<QDManualViewdelegate,QDCameraDelegate,QDDatadelegate,QDAutoinitIMVdelegate>
{
    UIImageView *connet_auto_IV;
    UIImageView *data_Image_View;
    UIDatePicker*datepick;
    UIButton *Program_BT;
}

@end
