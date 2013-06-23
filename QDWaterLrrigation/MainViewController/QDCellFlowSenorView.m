

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
        im=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-35, self.frame.size.height)];
        im.image=[UIImage imageNamed:@"xialawhite@2x.png"];
        //[self addSubview:im];
        [im release];
        label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-35, self.frame.size.height)];
        label.tag=10;
        label.textAlignment=NSTextAlignmentCenter;
        [label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:label];
        [label release];
        
        SaveButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [SaveButton setImage:[UIImage imageNamed:@"xiala@2x.png"] forState:UIControlStateNormal];
        //SaveButton.layer.borderWidth=1;
        //SaveButton.layer.borderColor=[UIColor redColor].CGColor;
        UIEdgeInsets imageInsets = UIEdgeInsetsMake(0, self.frame.size.width-45, 0, 10);
        SaveButton.imageEdgeInsets = imageInsets;

        SaveButton.showsTouchWhenHighlighted =YES;
        [SaveButton addTarget:self action:@selector(selectWorkPlace:) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:SaveButton];
        [SaveButton release];
    }
    return self;
}
-(void)selectWorkPlace:(UIButton *)bu
{
    
    [delegate clickBTSelectSensor:bu viewrow:self.tag];
    
}


@end
