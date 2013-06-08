//注册界面

#import "QDRegisterView.h"

@implementation QDRegisterView







-(void)ReturnLoginVIew
{
    [self removeFromSuperview];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor=[UIColor redColor];
        
        UIButton *Register_Return=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
        
        [Register_Return setTitle:@"返回" forState:UIControlStateNormal];
        [Register_Return setBackgroundColor:[UIColor blueColor]];
        [Register_Return addTarget:self action:@selector(ReturnLoginVIew) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:Register_Return];
        [Register_Return release];
        
    }
    return self;
}



@end
