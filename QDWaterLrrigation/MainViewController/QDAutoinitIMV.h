

@protocol QDAutoinitIMVdelegate <NSObject>

-(void)clicktableviewcell:(NSString *)str;

@end
#import <UIKit/UIKit.h>

@interface QDAutoinitIMV : UIImageView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tab;
    NSArray *dataArray;
    int selectRow;
}
@property(nonatomic,assign)int selectRow;
@property (nonatomic,assign)id<QDAutoinitIMVdelegate>delegate;
@end
