//
//  QDWeatherVC.h
//  QDWaterLrrigation
//
//  Created by Mako on 12-10-29.
//
//

#import <UIKit/UIKit.h>
#import "QDActivityIndicatorView.h"
#import "QDNetRequstData.h"
#import "QDCellFlowSenorView.h"

@interface QDWeatherVC : UIViewController<QDDatadelegate,QDCellFlowSenorViewdelegate,UITextFieldDelegate,UIPickerViewDelegate>
{
    NSArray*clickArry;
    QDNetRequstData *Weather_request;
    BOOL TempBOOL;
    BOOL HigherThanBOOL;
    NSString * userID_Int;
    NSMutableArray *mutayy;
    NSString *Weather_ID;
    NSMutableArray *mutable_Arr;
    NSString *shiwei;
    NSString *gewei;
    UILabel *Error_label;
}

@end
