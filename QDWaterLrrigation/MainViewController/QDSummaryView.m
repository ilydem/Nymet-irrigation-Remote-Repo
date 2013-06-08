

#import "QDSummaryView.h"

@implementation QDSummaryView
@synthesize dic;
@synthesize tab;
@synthesize im_Data;
@synthesize cellImageArray;
@synthesize delegate;
-(void)blackImageView
{

    Sys=[[QDSystem alloc]init];   
    tab =[[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    tab.dataSource=self;
    tab.delegate =self;
    tab.showsVerticalScrollIndicator=NO;
    tab.backgroundColor=[UIColor clearColor];
    [self addSubview:tab];
    [tab release];

}
-(void)dealloc
{
   [Sys release];
   [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        cellImageArray = [[NSMutableArray alloc]init];
        array_number =[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
        
        [self blackImageView];
        
    }
    return self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dic count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100.0;
    
}
-(void)clickErrorBTSummary
{
    [delegate summaryclickErrorBT];
    ling_Bool=YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%i",indexPath.row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell=[QDTableViewCell alloc];
        cell.tag=[indexPath row]+1;
        [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cellImageArray addObject:cell.cellImageView];        
    }
    
 

    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"nowrunEquipment"]!=nil)
    {
        if (cell.tag ==([[[NSUserDefaults standardUserDefaults]objectForKey:@"nowrunEquipment"]intValue]-2))
        {
            cell.imageView.image = [UIImage imageNamed:@"runstatus.png"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"ID_allstatebar.png"];
        }
        
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"ID_allstatebar.png"];
    }
    
    NSLog(@"[im_Data count][im_Data count]%d",[im_Data count]);
    for (int i=0; i<[im_Data count];i++)
    {
        
        if ([[[im_Data objectAtIndex:i]objectForKey:@"numberImage"]intValue]==[indexPath row]+1)
        {
            NSLog(@"第%i张,length:%i",i, [[[im_Data objectAtIndex:i]objectForKey:@"summary_Image_data"] length]);
            cell.cellImageView.image=[UIImage imageWithData:[[im_Data objectAtIndex:i]objectForKey:@"summary_Image_data"]];
            
        }
    }
    if ([dic count]!=0)
    {
        NSLog(@"[indexPath row]=%i----[dic count]=%i",[indexPath row],[dic count]);
        cell.current_laber.text=[[dic objectAtIndex:[indexPath row]]objectForKey:@"currentFlow"];//???
        cell.average_laber.text=[[dic objectAtIndex:[indexPath row]]objectForKey:@"averageFlow"];
 
    }
     
    if ([[[dic objectAtIndex:[indexPath row]]objectForKey:@"Flow"]  intValue]>9999)
    {
        if ([[[dic objectAtIndex:[indexPath row]]objectForKey:@"Flow"]  intValue]>999999)
        {
            cell.weather_laber.text =[NSString stringWithFormat:@"%.1f%@",[[[dic objectAtIndex:[indexPath row]]objectForKey:@"Flow"] floatValue]/1000000,@"m"];

        }
        else
        {
            cell.weather_laber.text =[NSString stringWithFormat:@"%.1f%@",[[[dic objectAtIndex:[indexPath row]]objectForKey:@"Flow"] floatValue]/1000,@"k"];

        }
                
    }
    else
    {
        cell.weather_laber.text=[[dic objectAtIndex:[indexPath row]]objectForKey:@"Flow"];
    }

  
    if ([[[dic objectAtIndex:[indexPath row]]objectForKey:@"zoneTimer"] isEqualToString:@"100%"])
    {
        cell.largestProgressView.progress=1;
    }
    else
    {
          cell.largestProgressView.progress= [[NSString stringWithFormat:@"%.2f",([[[[dic objectAtIndex:[indexPath row]]objectForKey:@"zoneTimer"] stringByReplacingOccurrencesOfString:@"%" withString:@""] intValue]*0.01)]floatValue]+0.001;  
        
    }
   
    
    cell.number_label.text=[NSString stringWithFormat:@"%.0f",[[[[dic objectAtIndex:[indexPath row]]objectForKey:@"timer"] stringByReplacingOccurrencesOfString:@"(mins)" withString:@""]intValue]*(1-([[[[dic objectAtIndex:[indexPath row]]objectForKey:@"zoneTimer"] stringByReplacingOccurrencesOfString:@"%" withString:@""] intValue]*0.01))];
    if ([[dic objectAtIndex:[indexPath row]]objectForKey:@"errorCondition"]!=nil)
    {
        if (![[[dic objectAtIndex:[indexPath row]]objectForKey:@"errorCondition"]isEqualToString:@"Normal"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%i",[indexPath row]] forKey:@"summayr_row"];
            [[NSUserDefaults standardUserDefaults]setObject:[[dic objectAtIndex:[indexPath row]]objectForKey:@"errorCondition"] forKey:@"sumarrayEROR"];

            Error_BT=[[UIButton alloc]initWithFrame:CGRectMake(255, 5, 60, 40)];
            Error_BT.tag=[indexPath row]+200;
            [Error_BT setUserInteractionEnabled:YES];
            [Error_BT setBackgroundColor:[UIColor clearColor]];
            [Error_BT addTarget:self action:@selector(clickErrorBTSummary) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:Error_BT];
      
            cell.Error_laber.text=@"error";
            cell.Error_laber.textColor=[UIColor redColor];
            
        }
        else
        {
            cell.Error_laber.textColor=[UIColor blackColor];
            cell.Error_laber.text=[[dic objectAtIndex:[indexPath row]]objectForKey:@"errorCondition"];
            UIView *Viee=[cell viewWithTag:[indexPath row]+200];
            if (Viee)
            {
                [Viee removeFromSuperview];
            }
            
            Error_BT =nil;
        }
    }

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.number_laber.text=[[dic objectAtIndex:[indexPath row]]objectForKey:@"number"];
    cell.delegate=self;


    return cell;
}

//点击拍照的代理方法
-(void)summaryclickdifferentcellImage:(UITableViewCell *)cl
{
    [delegate summarycellImage:cl];
}
//选取本地照片的代理方法
-(void)summaryselectlocationImage:(UITableViewCell *)cl
{
    [delegate summaryselectcellViewImaga:cl];
}
-(void)clickImageViewgotoCamera
{
    if (blackView)
    {
        [blackView removeFromSuperview];
        blackView=nil;
    }
}
-(void)summaryclickimageView:(UIImage *)image
{
    if (blackView)
    {
            
    }
    else
    {
        blackView=[[UIView alloc]initWithFrame:self.bounds];
        [blackView setBackgroundColor:[UIColor blackColor]];
        blackView.alpha=0.8;
        [self addSubview:blackView];
        [blackView release];
        
        imageview=[[UIImageView alloc]initWithImage:image];
        imageview.frame=CGRectMake(0, 0, 40, 40);
        [imageview setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageViewgotoCamera)];
        [imageview addGestureRecognizer:tap];
        [tap release];
        
        [blackView addSubview:imageview];
        [imageview release];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        imageview.frame =CGRectMake(self.frame.size.width/2-150, self.frame.size.height/2-150, 300, 300);
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
        
    }
    
}


@end
