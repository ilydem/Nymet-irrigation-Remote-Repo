

@protocol QDSummaryViewdelegate <NSObject>

-(void)summarycellImage:(UITableViewCell*)cell;
-(void)summaryselectcellViewImaga:(UITableViewCell*)cell;
-(void)summaryclickErrorBT;
@end
#import <UIKit/UIKit.h>
#import "QDTableViewCell.h"
#import "QDSystem.h"
@interface QDSummaryView : UIView<UITableViewDataSource,UITableViewDelegate,QDTableViewCelldelegate>
{
    UITableView *tab;
    NSMutableArray* dic;
    NSArray *array_number;
    NSMutableArray *im_Data;
    NSMutableArray *mutab_Arr;
    QDTableViewCell *cell;
    UIButton *Error_BT;
    NSString *error_str;
    UIView *blackView;
    UIImageView *imageview;
    QDSystem *Sys;
    BOOL ling_Bool;
}
@property(nonatomic,retain)UITableView *tab;
@property(nonatomic,retain)NSMutableArray* dic;
@property(nonatomic,retain)NSMutableArray *im_Data;
@property(nonatomic,retain)NSMutableArray *cellImageArray;
@property (nonatomic,assign)id<QDSummaryViewdelegate>delegate;
@end
