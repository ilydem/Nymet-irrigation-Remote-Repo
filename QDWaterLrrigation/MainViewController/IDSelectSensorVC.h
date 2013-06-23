//
//  IDSelectSensorVC.h
//  QDWaterLrrigation
//
//  Created by Ilya Demin on 21/06/13.
//
//

#import <UIKit/UIKit.h>
#import "QDNetRequstData.h"


@interface IDSelectSensorVC : UIViewController<UITableViewDataSource,UITableViewDelegate,QDDatadelegate> {
    NSArray *workPlaceArray;
    int selection_index;
}
@property int viewrow;
@property(nonatomic,retain) UIViewController *parentVC;
@end
