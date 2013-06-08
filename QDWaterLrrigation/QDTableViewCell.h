

@protocol QDTableViewCelldelegate <NSObject>

-(void)summaryclickdifferentcellImage:(UITableViewCell*)cell;//拍照的代理方法
-(void)summaryselectlocationImage:(UITableViewCell*)cell;//选取本地照片的代理方法
-(void)summaryclickimageView:(UIImage *)image;
@optional
//-(void)clickalterBT:(UITableViewCell*)cell text:(NSString *)tx;
@end

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
#import <QuartzCore/QuartzCore.h>

@interface QDTableViewCell : UITableViewCell<UIActionSheetDelegate>
{
    UIImage *cellBgImage;
    UILabel*number_laber;
    UIImageView *imageView;
    UILabel*current_laber;
    UILabel*average_laber;
    UILabel*weather_laber;
    UILabel *number_label;
    UILabel*Error_laber;
    DACircularProgressView*largestProgressView;
}

@property (nonatomic,retain) UIImageView *cellImageView;
@property (nonatomic,retain) UIImage *cellBgImage;
@property (nonatomic,retain) UILabel*number_laber;
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) UILabel*current_laber;
@property (nonatomic,retain) UILabel*average_laber;
@property (nonatomic,retain) UILabel*weather_laber;
@property (nonatomic,retain) UILabel *number_label;
@property (nonatomic,retain) UILabel*Error_laber;
@property (nonatomic,assign) DACircularProgressView*largestProgressView;
@property (nonatomic,assign)id<QDTableViewCelldelegate>delegate;
@end
