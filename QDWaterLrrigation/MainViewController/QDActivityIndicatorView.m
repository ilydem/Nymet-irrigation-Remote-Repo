//风火轮旋转

#import "QDActivityIndicatorView.h"

@implementation QDActivityIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self setHidesWhenStopped:YES];
        [self setHidden:NO];
        [self startAnimating];
    }
    return self;
}



@end
