//
//  QDPublicWebView.h
//  QDWaterLrrigation
//
//  Created by Mako on 12-11-9.
//
//

#import <UIKit/UIKit.h>

@interface QDPublicWebView : UIWebView
{
    NSMutableURLRequest *request_URL;
    int requestwebview;
}
#pragma mark -生成单例
+ (id) sharePublicProperty;
@property(nonatomic,retain)NSMutableURLRequest *request_URL;
@property(nonatomic,assign)int requestwebview;
@end
