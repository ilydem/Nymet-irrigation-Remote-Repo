

#import "QDZoomImVIew.h"

@implementation QDZoomImVIew

-(id)initWithFrame:(CGRect)frame blackImage:(UIImage*)image Titlelaber:(NSString *)titstring
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.image=image;
        UILabel *laber=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-10, self.frame.size.height/2-10, 20, 20)];
        laber.text=titstring;
        laber.textColor=[UIColor whiteColor];
        laber.textAlignment=NSTextAlignmentCenter;
        laber.backgroundColor=[UIColor clearColor];
        [self addSubview:laber];
        [laber release];
    }
    return self;
}



@end
