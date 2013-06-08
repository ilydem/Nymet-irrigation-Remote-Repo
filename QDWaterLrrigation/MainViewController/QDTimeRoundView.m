

#import "QDTimeRoundView.h"

@implementation QDTimeRoundView
-(void)blackImageView
{
    UIImageView *Round_ImV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    Round_ImV.image=[UIImage imageNamed:@"进度条底部.png"];
    [self addSubview:Round_ImV];
    [Round_ImV release];
    
    [self performSelector:@selector(bbbbbbbbbbbbb) withObject:nil afterDelay:0.01];
     
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        i=0;
        [self blackImageView];
         
    }
    return self;
}
//-(void)bbbbbbbbbbbbb
//{
//    time=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(aaaaaaaaaaaaaaaaaa) userInfo:nil repeats:YES];
//}
//-(void)aaaaaaaaaaaaaaaaaa
//{
//    float radius=70;
//    float angle=(M_PI*2*2)/80.0;
//    
//    UIImageView *im=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1(1).png"]];
//    im.frame=CGRectMake(0, 0, 40, 40);
//    //im.layer.cornerRadius=0;
//    im.tag=20+i;
//    i=i+1;
//    im.center=CGPointMake(100+radius*sinf(angle*i+M_PI/2), 100+radius*cosf(angle*i+M_PI/2));
//    [self addSubview:im];
//    [im release];
//
//}


@end
