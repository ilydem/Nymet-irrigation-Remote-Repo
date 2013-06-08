
@protocol QDCellFlowSenorViewdelegate <NSObject>

-(void)clickBTSelectSensor:(UIButton *)bu viewrow:(int)ro;//返回值的代理方法


@end

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface QDCellFlowSenorView : UIView
{
     NSArray *workPlaceArray;
    UILabel *label;
}
@property(nonatomic,retain)UILabel *label;
@property(nonatomic,retain)UIButton *SaveButton;
@property(nonatomic,retain)UIImageView *im;
@property (nonatomic,assign)id<QDCellFlowSenorViewdelegate>delegate;
@end
