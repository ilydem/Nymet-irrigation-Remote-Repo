
@protocol QDManualViewdelegate <NSObject>

-(void)cellImage:(UITableViewCell*)cell;
-(void)selectcellViewImaga:(UITableViewCell*)cell;
@end
#import <UIKit/UIKit.h>
#import "QDManualAuroCell.h"
#import "QDNetRequstData.h"
#import "DACircularProgressView.h"
@interface QDManualView : UIView<UITableViewDataSource,UITableViewDelegate,QDManualAuroCelldelegate>
{
    UITableView *tab;
    NSMutableArray *cellImageArray;
    NSMutableArray* ManualVCdic;
    NSMutableArray* Data_Image_view_cell;
    QDManualAuroCell *cel;
    NSMutableArray *cellArr;
    QDNetRequstData *datarequest;
    BOOL manual_auto;
    NSMutableArray *mutable_id_manual;
    NSMutableArray *auto_id_manual;
    UIImageView *imageview;
    UIView *blackView;
    //DACircularProgressView*largestProgressView;
}
@property (nonatomic,assign)id<QDManualViewdelegate>delegate;
@property (nonatomic,retain)NSMutableArray *cellImageArray;
@property(nonatomic,retain)NSMutableArray* ManualVCdic;
@property(nonatomic,retain)NSMutableArray* Data_Image_view_cell;
@property(nonatomic,retain)UITableView *tab;
@property(nonatomic,retain)QDManualAuroCell *cel;
@property(nonatomic,retain)NSMutableArray *cellArr;
@property(nonatomic,retain)NSMutableArray *mutable_id_manual;
@property(nonatomic,retain)NSMutableArray *auto_id_manual;
@property(nonatomic,assign)BOOL manual_auto;
@end
