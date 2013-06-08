

#import "QDCellFlowSenorView.h"

@implementation QDCellFlowSenorView
@synthesize delegate;
@synthesize label;
@synthesize SaveButton;
@synthesize im;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        im=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-25, self.frame.size.height)];
        im.image=[UIImage imageNamed:@"xialawhite@2x.png"];
        [self addSubview:im];
        [im release];
        label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-25, self.frame.size.height)];
        label.tag=10;
        label.textAlignment=NSTextAlignmentCenter;
        [label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:label];
        [label release];
        
        SaveButton=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-30, 0, 25, self.frame.size.height)];
        [SaveButton setBackgroundImage:[UIImage imageNamed:@"xiala@2x.png"] forState:UIControlStateNormal];
        SaveButton.showsTouchWhenHighlighted =YES;
        [SaveButton addTarget:self action:@selector(selectWorkPlace:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:SaveButton];
        [SaveButton release];
    }
    return self;
}
-(void)selectWorkPlace:(UIButton *)bu
{
    
    [delegate clickBTSelectSensor:bu viewrow:self.tag];
    
}


@end
