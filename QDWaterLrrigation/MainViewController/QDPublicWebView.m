
#import "QDPublicWebView.h"

@implementation QDPublicWebView
@synthesize request_URL;
@synthesize requestwebview;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        request_URL =[[NSMutableURLRequest alloc]init];
        
    }
    return self;
}

static QDPublicWebView *publicProperty = nil;
#pragma mark -生成单例
+ (id) sharePublicProperty;
{
    @synchronized(publicProperty)
    {
        if(!publicProperty)
        {
            publicProperty = [[QDPublicWebView alloc] init];
    
        }
    }
    return publicProperty;
}
-(void)dealloc
{
    [request_URL release];
    [super dealloc];
}

@end
