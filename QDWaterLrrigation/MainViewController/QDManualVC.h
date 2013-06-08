//ManualVC

#import <UIKit/UIKit.h>
#import "QDManualView.h"
#import "QDActivityIndicatorView.h"
#import "QDNetRequstData.h"
#import "QDManualAuroCell.h"
#import "QDCamera.h"

@interface QDManualVC : UIViewController<QDDatadelegate,QDCameraDelegate,QDManualViewdelegate>
{
    UIImageView *connet_Manual_IV;
    UIButton *cancel_BT_manual;
    UIButton *start_BT_manual;
    QDCamera *camer;
    BOOL came_Photo;
    
}

@end
