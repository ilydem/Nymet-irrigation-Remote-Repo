//
//  QDSelectSensorVC.h
//  QDWaterLrrigation
//
//  Created by Mako on 12-11-9.
//
//

#import <UIKit/UIKit.h>
#import "QDCellFlowSenorView.h"
#import "QDNetRequstData.h"

@interface QDSelectSensorVC : UIViewController<UITableViewDataSource,UITableViewDelegate,QDCellFlowSenorViewdelegate,QDDatadelegate>
{
    NSArray *workPlaceArray;
    QDCellFlowSenorView *cell_flow;
    int selfrow;
}

@end
