
@protocol QDManualAuroCelldelegate <NSObject>

-(void)clickdifferentcellImage:(UITableViewCell*)cell;//拍照的代理方法
-(void)selectlocationImage:(UITableViewCell*)cell;//选取本地照片的代理方法
-(void)longclickImageView:(UIImage *)image;
@optional
-(void)clickalterBT:(UITableViewCell*)cell text:(NSString *)tx;
@end

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
#import <QuartzCore/QuartzCore.h>
#import "QDNetRequstData.h"
#import "DCRoundSwitch.h"

@interface QDManualAuroCell : UITableViewCell<UIActionSheetDelegate,UITextFieldDelegate>
{
    UIImageView*cellImageView;
    DCRoundSwitch *ON_OFF_Sw;
    DCRoundSwitch *Mist_cont;
    DACircularProgressView*largestProgressView;
    UILabel *number_label;
    UITextField *myTextField;
    BOOL auto_manual_cell;
    BOOL numberBOOL;
}
-(void)setRound:(float)ff;
@property (nonatomic,assign)id<QDManualAuroCelldelegate>delegate;
@property (nonatomic, retain)UIImageView*cellImageView;
@property (nonatomic, assign)DCRoundSwitch *ON_OFF_Sw;
@property (nonatomic, retain)DACircularProgressView*largestProgressView;
@property (nonatomic, retain)UILabel *number_label;
@property (nonatomic, assign)BOOL auto_manual_cell;
@property (nonatomic, assign)DCRoundSwitch *Mist_cont;
@end
