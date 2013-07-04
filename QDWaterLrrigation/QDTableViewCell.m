

#import "QDTableViewCell.h"

@implementation QDTableViewCell
@synthesize cellImageView;
@synthesize cellBgImage;
@synthesize number_laber;
@synthesize imageView;
@synthesize current_laber;
@synthesize average_laber;
@synthesize weather_laber;
@synthesize largestProgressView;
@synthesize number_label;
@synthesize Error_laber;
@synthesize delegate;

-(void)clicksummaryImage
{
    UIActionSheet *actionSheetView = [[UIActionSheet alloc] initWithTitle:@"Set Image"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Photograph"
                                                        otherButtonTitles:@"Local Photos",nil];
    [actionSheetView showInView:self];
    [actionSheetView autorelease];
}
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
            [delegate summaryclickdifferentcellImage:self];
            break;
        case 1:
            [delegate summaryselectlocationImage:self];
            
        default:
            break;
    }
    
    
}
-(void)clickImageViewgotoCamerachanganSummary
{
    [delegate summaryclickimageView:cellImageView.image];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //cell的背景
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
        [self addSubview:imageView];
        [imageView release];
        
        
        //图片
        cellImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 80, 80)];
        cellImageView.image=[UIImage imageNamed:@"imgview@2x.png"];
        [cellImageView setUserInteractionEnabled:YES];
        cellImageView.layer.cornerRadius = 10;
        cellImageView.layer.masksToBounds = YES;
        [self addSubview:cellImageView];
        [cellImageView release];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicksummaryImage)];
        [cellImageView addGestureRecognizer:tap];
        [tap release];
        
        UILongPressGestureRecognizer *summary_tap=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageViewgotoCamerachanganSummary)];
        [cellImageView addGestureRecognizer:summary_tap];
        [summary_tap release];

        
        
        //current
        current_laber=[[UILabel alloc]initWithFrame:CGRectMake(95, 40, 40, 20)];
        current_laber.textAlignment=NSTextAlignmentCenter;
        current_laber.font=[UIFont systemFontOfSize:15];
        current_laber.backgroundColor=[UIColor clearColor];
        [self addSubview:current_laber];
        [current_laber release];
        
        //average
        average_laber=[[UILabel alloc]initWithFrame:CGRectMake(135, 40, 35, 20)];
        average_laber.textAlignment=NSTextAlignmentCenter;
        average_laber.font=[UIFont systemFontOfSize:15];
        average_laber.backgroundColor=[UIColor clearColor];
        [self addSubview:average_laber];
        [average_laber release];
        
        //Weather
        weather_laber=[[UILabel alloc]initWithFrame:CGRectMake(170, 40, 40, 20)];
        weather_laber.textAlignment=NSTextAlignmentCenter;
        weather_laber.font=[UIFont systemFontOfSize:15];
        weather_laber.backgroundColor=[UIColor clearColor];
        [self addSubview:weather_laber];
        [weather_laber release];
        
        
        largestProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(207, 25, 50, 50)];
               
        [self addSubview:largestProgressView];
        [largestProgressView release];
        
        
        
        
        number_label=[[UILabel alloc]initWithFrame:CGRectMake(5, 15, 40, 20)];
        number_label.textAlignment=NSTextAlignmentCenter;
        number_label.font=[UIFont systemFontOfSize:15];
        number_label.backgroundColor=[UIColor clearColor];
        [largestProgressView addSubview:number_label];
        [number_label release];
        
        
        
        //error
        Error_laber=[[UILabel alloc]initWithFrame:CGRectMake(254, 40, 60, 20)];
        Error_laber.textAlignment=NSTextAlignmentCenter;
        Error_laber.font=[UIFont systemFontOfSize:15];
        Error_laber.backgroundColor=[UIColor clearColor];
        [self addSubview:Error_laber];
        [Error_laber release];
        
        
        if (self.tag==10) {
            number_laber=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 21, 20)];
            number_laber.textAlignment = NSTextAlignmentLeft;
        }
        else {
            number_laber=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
            number_laber.textAlignment = NSTextAlignmentCenter;
        }
        number_laber.backgroundColor=[UIColor whiteColor];
        number_laber.layer.cornerRadius = 5;
        number_laber.layer.masksToBounds = YES;
        [self addSubview:number_laber];
        [number_laber release];
        
        
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
