//注册界面


@protocol QDRegisterVC <NSObject>

-(void)RegistegotoMainVC;


@end
#import <UIKit/UIKit.h>
#import "QDNetRequstData.h"
#import "QDActivityIndicatorView.h"
@interface QDRegisterVC : UIViewController<UITextFieldDelegate,QDDatadelegate>

@property (nonatomic,assign)id<QDRegisterVC>delegate;
@end
