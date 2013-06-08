

#import "QDManualView.h"

@implementation QDManualView
@synthesize delegate;
@synthesize cellImageArray;
@synthesize ManualVCdic;
@synthesize Data_Image_view_cell;
@synthesize tab;
@synthesize cel;
@synthesize cellArr;
@synthesize manual_auto;
@synthesize mutable_id_manual;
@synthesize auto_id_manual;
-(void)blackImageView
{
    tab =[[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    tab.dataSource=self;
    tab.delegate =self;
    tab.showsVerticalScrollIndicator=NO;
    tab.backgroundColor=[UIColor clearColor];
    [self addSubview:tab];
    [tab release];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        cellImageArray  =  [[NSMutableArray alloc]init];
        cellArr  =  [[NSMutableArray alloc]init];
        [self blackImageView];
        datarequest=[[QDNetRequstData alloc]init];
    }
    return self;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ManualVCdic count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100.0;
    
}
-(void)clickmistcontswBT:(UISwitch *)sw
{
    NSMutableDictionary *sw_dic=[NSMutableDictionary dictionary];
    NSString *onoff=nil;
    NSString *Statusvalue=nil;

    if (manual_auto)
    {
        
        if (sw.on)
        {
            Statusvalue=@"Cont";
            [[ManualVCdic objectAtIndex:sw.tag-100] setObject:@"Mist" forKey:@"mistCont"];
        }
        else
        {
            Statusvalue=@"Mist";
            [[ManualVCdic objectAtIndex:sw.tag-100] setObject:@"Cont" forKey:@"mistCont"];
        }
        onoff =[mutable_id_manual objectAtIndex:sw.tag-100];;
        [sw_dic setObject:Statusvalue forKey:@"value"];
        [sw_dic setObject:onoff forKey:@"timingId"];
        [sw_dic setObject:[NSString stringWithFormat:@"%i",sw.tag-99] forKey:@"number"];
        [datarequest manualmistcontrequest:sw_dic];


    }
    else
    {        
        if (sw.on)
        {
            Statusvalue=@"Mist";
            [[ManualVCdic objectAtIndex:sw.tag-100] setObject:@"Mist" forKey:@"mistCont"];
        }
        else
        {
            Statusvalue=@"Cont";
            [[ManualVCdic objectAtIndex:sw.tag-100] setObject:@"Cont" forKey:@"mistCont"];
        }
        
        onoff=[auto_id_manual objectAtIndex:sw.tag-100];
        [sw_dic setObject:onoff forKey:@"timingId"];
        [sw_dic setObject:Statusvalue forKey:@"value"];
        [datarequest automistswrequest:sw_dic];
 
    }
    
    

}
-(void)clickonoffswBT:(UISwitch *)sw
{
    NSMutableDictionary *sw_dic=[NSMutableDictionary dictionary];
    NSString *onoff=nil;
    NSString *Statusvalue=nil;
    
    if (manual_auto)
    {
        if (sw.on)
        {
            Statusvalue=@"OFF";
            [[ManualVCdic objectAtIndex:sw.tag-200] setObject:@"O N" forKey:@"onOff"];
        }
        else
        {
            Statusvalue=@"O N";
            [[ManualVCdic objectAtIndex:sw.tag-200] setObject:@"OFF" forKey:@"onOff"];
        }
        onoff =[mutable_id_manual objectAtIndex:sw.tag-200];
        [sw_dic setObject:Statusvalue forKey:@"value"];
        [sw_dic setObject:onoff forKey:@"timingId"];
        [sw_dic setObject:[NSString stringWithFormat:@"%i",sw.tag-199] forKey:@"number"];
        [datarequest manualonoffrequestdata:sw_dic];
    }
    else
    {
        if (sw.on)
        {
            Statusvalue=@"1";
            [[ManualVCdic objectAtIndex:sw.tag-200] setObject:@"O N" forKey:@"onOff"];
        }
        else
        {
            Statusvalue=@"0";
            [[ManualVCdic objectAtIndex:sw.tag-200] setObject:@"OFF" forKey:@"onOff"];
        }
        
        onoff=[auto_id_manual objectAtIndex:sw.tag-200];
        [sw_dic setObject:onoff forKey:@"timingId"];
        [sw_dic setObject:Statusvalue forKey:@"value"];
        [datarequest autotabrequestonoff:sw_dic];
       
  
    }

}
-(void)clickalterBT:(UITableViewCell *)cell text:(NSString *)tx
{
    [[ManualVCdic objectAtIndex:cell.tag-1] setObject:tx forKey:@"zoneTimer2"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%i",indexPath.row];
    
    cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cel == nil)
    {
        cel =[[QDManualAuroCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        
        cel.delegate=self;
        [cellImageArray addObject:cel.cellImageView];
        [cellArr addObject:cel];
        
        
        //前面的数字
        UILabel*number_laber=[UILabel alloc];
        if ([indexPath row]+1==10) {
            [number_laber initWithFrame:CGRectMake(10, 15, 21, 20)];
            number_laber.textAlignment = NSTextAlignmentLeft;
        }
        else {
            [number_laber initWithFrame:CGRectMake(10, 15, 20, 20)];
            number_laber.textAlignment = NSTextAlignmentCenter;
        }
        number_laber.backgroundColor=[UIColor whiteColor];
        number_laber.layer.cornerRadius = 5;
        number_laber.layer.masksToBounds = YES;
        number_laber.text=[NSString stringWithFormat:@"%d",[indexPath row]+1];
        number_laber.backgroundColor=[UIColor whiteColor];
        [cel addSubview:number_laber];
        [number_laber release];
        
    }
    
    for (int i=0; i<[Data_Image_view_cell count];i++)
    {
        
        if ([[[Data_Image_view_cell objectAtIndex:i]objectForKey:@"numberImage"]intValue]==[indexPath row]+1)
        {
            cel.cellImageView.image=[UIImage imageWithData:[[Data_Image_view_cell objectAtIndex:i]objectForKey:@"summary_Image_data"]];
        }
    }
    
    if ([[[ManualVCdic objectAtIndex:[indexPath row]]objectForKey:@"onOff"] isEqualToString:@"OFF"])
    {
        [cel.ON_OFF_Sw firstSetOn:NO];
    }
    else
    {
        [cel.ON_OFF_Sw firstSetOn:YES];
    }
    
    if ([[[ManualVCdic objectAtIndex:[indexPath row]]objectForKey:@"mistCont"] isEqualToString:@"Mist"]||[[[ManualVCdic objectAtIndex:[indexPath row]]objectForKey:@"mistCont"] isEqualToString:@"MIST"])
    {
        [cel.Mist_cont firstSetOn:YES];
    }
    else
    {
        [cel.Mist_cont firstSetOn:NO];
    }

    
    
    if ([[[ManualVCdic objectAtIndex:[indexPath row]]objectForKey:@"zoneTimer1"] isEqualToString:@"100%"])
    {
        cel.largestProgressView.progress=1;
    }
    else
    {
        cel.largestProgressView.progress= [[NSString stringWithFormat:@"%.2f",([[[[ManualVCdic objectAtIndex:[indexPath row]]objectForKey:@"zoneTimer1"] stringByReplacingOccurrencesOfString:@"%" withString:@""] intValue]*0.01)]floatValue]+0.001;
    }
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"AutoORManual"])
    {
        if ([[[[NSUserDefaults standardUserDefaults]objectForKey:@"auto_timeID"]objectAtIndex:[indexPath row]+28]isEqualToString:@"30DA39"])
        {
            cel.largestProgressView.progressTintColor=[UIColor colorWithRed:0.2392f green:0.4313f blue:0.7490f alpha:1.0f];
        }
        else
        {
            cel.largestProgressView.progressTintColor=[UIColor grayColor];
        }

    }
    

    cel.number_label.text=[[ManualVCdic objectAtIndex:[indexPath row]]objectForKey:@"zoneTimer2"];

    cel.auto_manual_cell=manual_auto;
    cel.selectionStyle = UITableViewCellSelectionStyleNone;
    cel.tag=[indexPath row]+1;
    cel.ON_OFF_Sw.tag=[indexPath row]+200;
    cel.Mist_cont.tag=[indexPath row]+100;
    [cel.ON_OFF_Sw addTarget:self action:@selector(clickonoffswBT:) forControlEvents:UIControlEventValueChanged];
    [cel.Mist_cont addTarget:self action:@selector(clickmistcontswBT:) forControlEvents:UIControlEventValueChanged];
    
    
    return cel;
}
//点击拍照的代理方法
-(void)clickdifferentcellImage:(QDManualAuroCell *)cell
{
    [delegate cellImage:cell];
}
//选取本地照片的代理方法
-(void)selectlocationImage:(QDManualAuroCell *)cell
{
    [delegate selectcellViewImaga:cell];
}

-(void)clickImageViewgotoCamera
{
    if (blackView)
    {
        [blackView removeFromSuperview];
        blackView=nil;
    }
}
-(void)longclickImageView:(UIImage *)image
{
    if (blackView)
    {
//        [blackView removeFromSuperview];
//        blackView=nil;

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
