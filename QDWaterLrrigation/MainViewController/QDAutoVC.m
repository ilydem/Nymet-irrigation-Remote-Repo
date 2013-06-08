

#import "QDAutoVC.h"
#define AUTOACTI 1
@interface QDAutoVC ()
{
    QDCamera *camer;
    BOOL came_Photo;
    QDManualView *manualView_auto;
    UILabel*program_label_auto;
    UILabel*program_label_Time;
    NSArray *dataArray;
    NSMutableArray *auto_Mutab_Arr;
    NSMutableArray *auto_Data_arr;
    NSString *Programstr;
    NSMutableDictionary *mutableDic;
    UILabel*program_miao_Time;
    UIView *pick_View;
    UIView *backview;
    int pickrow;
    QDNetRequstData *saveBT;
    QDAutoinitIMV *auto_Init_view;
    BOOL sunbool;
    BOOL monbool;
    BOOL tuebool;
    BOOL wedbool;
    BOOL thubool;
    BOOL fribool;
    BOOL satbool;
    NSString *autoProgramIdweek;
    UILabel *am_pm_label;
    NSString *valStr;
    NSString *weekStr;
    NSMutableArray *auto_pragramId;
    
}

@end

@implementation QDAutoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

-(void)servernotResponding:(NSString *)msgStr
{
    [self StopActivityIndicatorView];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:msgStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
    [alert release];
}
-(void)clickSetting
{
    
    NSMutableDictionary *programDic=[NSMutableDictionary dictionary];
    [programDic setObject:program_label_auto.text forKey:@"ProgramName"];
    [programDic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"startTime1"] forKey:@"startTime1"];
    [programDic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"startTime2"] forKey:@"startTime2"];
    [programDic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"wateringSchedule"] forKey:@"wateringSchedule"];
    [[NSUserDefaults standardUserDefaults]setObject:programDic forKey:@"timerDic"];
    
    [self.tabBarController.navigationController pushViewController:[[QDTimeVC new] autorelease] animated:YES];
}
-(void)clickPickview
{
    if (pick_View)
    {
        [pick_View removeFromSuperview];
    }

}
-(void)autodefineBTpickView
{
    auto_Init_view.hidden=YES;
    QDNetRequstData *requst= [[QDNetRequstData alloc]init];
    requst.delegate =self;
    [requst clickautobutton:[dataArray objectAtIndex:auto_Init_view.selectRow]];
    [self clickPickview];
    
}
-(void)autocancellBTPickView
{
    [self clickPickview];
}


#pragma mark//开始旋转的风火轮
-(void)StartActivityIndicatorView
{
    backview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [self.view addSubview:backview];
    
    QDActivityIndicatorView*activi=[[QDActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-20, 40, 40)];
    activi.tag=AUTOACTI;
    [self.view addSubview:activi];
    [activi release];
    
}
#pragma mark//停止旋转的风火轮
-(void)StopActivityIndicatorView
{
    if (backview)
    {
        [backview removeFromSuperview];
    }
    QDActivityIndicatorView *act=(QDActivityIndicatorView*)[self.view viewWithTag:AUTOACTI];
    if (act)
    {
        [act removeFromSuperview];
    }
}
-(void)gotoAutoManualview
{
    if (self.tabBarController.selectedIndex ==2)
    {
        QDNetRequstData *autorequst=[[QDNetRequstData alloc]init];
        autorequst.delegate=self;
        [autorequst requstAutoData];
    }
}
-(void)autoloadmanualViewdata
{

    if (manualView_auto)
    {
        NSArray *arr=[[mutableDic objectForKey:@"wateringSchedule"]componentsSeparatedByString:@","];
        [arr retain];
        manualView_auto.auto_id_manual=auto_pragramId;
        manualView_auto.manual_auto=NO;
        for (int i =0; i<[arr count]; i++)
        {
            UIButton *bt=(UIButton*)[self.view viewWithTag:i+2];
            if ([[arr objectAtIndex:i] isEqualToString:@"true"])
            {
//                [bt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                switch (bt.tag)
                 {
                     case 2:
                          sunbool=YES;
                         [bt setImage:[UIImage imageNamed:@" btn_1q.png"] forState:UIControlStateNormal];
                         break;
                     case 3:
                          monbool=YES;
                         [bt setImage:[UIImage imageNamed:@" btn_6q.png"] forState:UIControlStateNormal];
                         break;
                     case 4:
                         tuebool =YES;
                         [bt setImage:[UIImage imageNamed:@" btn_2q.png"] forState:UIControlStateNormal];                         
                         break;
                     case 5:
                         wedbool =YES;
                         [bt setImage:[UIImage imageNamed:@" btn_3q.png"] forState:UIControlStateNormal];
                         break;
                     case 6:
                         thubool =YES;
                         [bt setImage:[UIImage imageNamed:@" btn_4q.png"] forState:UIControlStateNormal];
                         break;
                     case 7:
                         fribool =YES;
                         [bt setImage:[UIImage imageNamed:@" btn_5q.png"] forState:UIControlStateNormal];
                         break;
                     case 8:
                          satbool =YES;
                         [bt setImage:[UIImage imageNamed:@" btn_7q.png"] forState:UIControlStateNormal];
                        break;
                         
                     default:
                         break;
                 }

            }
            else
            {
                switch (bt.tag)
                {
                    case 2:
                        sunbool=NO;
                        [bt setImage:[UIImage imageNamed:@" btn_1.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        monbool=NO;
                        [bt setImage:[UIImage imageNamed:@" btn_6.png"] forState:UIControlStateNormal];
                        break;
                    case 4:
                        tuebool =NO;
                        [bt setImage:[UIImage imageNamed:@" btn_2.png"] forState:UIControlStateNormal];
                        break;
                    case 5:
                        wedbool =NO;
                        [bt setImage:[UIImage imageNamed:@" btn_3.png"] forState:UIControlStateNormal];
                        break;
                    case 6:
                        thubool =NO;
                        [bt setImage:[UIImage imageNamed:@" btn_4.png"] forState:UIControlStateNormal];
                        break;
                    case 7:
                        fribool =NO;
                        [bt setImage:[UIImage imageNamed:@" btn_5.png"] forState:UIControlStateNormal];
                        break;
                    case 8:
                        satbool =NO;
                        [bt setImage:[UIImage imageNamed:@" btn_7.png"] forState:UIControlStateNormal];
                        break;
                        
                    default:
                        break;
                }

//                [bt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }

        [arr release];
        program_label_Time.text =[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"startTime1"];
        program_miao_Time.text=[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"startTime2"];
        program_label_auto.text=[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"ProgramName"];
        manualView_auto.ManualVCdic=auto_Mutab_Arr;
        manualView_auto.Data_Image_view_cell=auto_Data_arr;
        [manualView_auto.tab reloadData];
    }
    else
    {
        
        NSArray *arr=[[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"wateringSchedule"]componentsSeparatedByString:@","];
        [arr retain];
        for (int i =0; i<[arr count]; i++)
        {
            UIButton *bt=(UIButton*)[self.view viewWithTag:i+2];
            if ([[arr objectAtIndex:i] isEqualToString:@"true"])
            {
                //                [bt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                switch (bt.tag)
                {
                    case 2:
                        sunbool=YES;
                        [bt setImage:[UIImage imageNamed:@" btn_1q.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        monbool=YES;
                        [bt setImage:[UIImage imageNamed:@" btn_6q.png"] forState:UIControlStateNormal];
                        break;
                    case 4:
                        tuebool =YES;
                        [bt setImage:[UIImage imageNamed:@" btn_2q.png"] forState:UIControlStateNormal];
                        break;
                    case 5:
                        wedbool =YES;
                        [bt setImage:[UIImage imageNamed:@" btn_3q.png"] forState:UIControlStateNormal];
                        break;
                    case 6:
                        thubool =YES;
                        [bt setImage:[UIImage imageNamed:@" btn_4q.png"] forState:UIControlStateNormal];
                        break;
                    case 7:
                        fribool =YES;
                        [bt setImage:[UIImage imageNamed:@" btn_5q.png"] forState:UIControlStateNormal];
                        break;
                    case 8:
                        satbool =YES;
                        [bt setImage:[UIImage imageNamed:@" btn_7q.png"] forState:UIControlStateNormal];
                        break;
                        
                    default:
                        break;
                }
                
            }
            else
            {
                switch (bt.tag)
                {
                    case 2:
                        sunbool=NO;
                        [bt setImage:[UIImage imageNamed:@" btn_1.png"] forState:UIControlStateNormal];
                        break;
                    case 3:
                        monbool=NO;
                        [bt setImage:[UIImage imageNamed:@" btn_6.png"] forState:UIControlStateNormal];
                        break;
                    case 4:
                        tuebool =NO;
                        [bt setImage:[UIImage imageNamed:@" btn_2.png"] forState:UIControlStateNormal];
                        break;
                    case 5:
                        wedbool =NO;
                        [bt setImage:[UIImage imageNamed:@" btn_3.png"] forState:UIControlStateNormal];
                        break;
                    case 6:
                        thubool =NO;
                        [bt setImage:[UIImage imageNamed:@" btn_4.png"] forState:UIControlStateNormal];
                        break;
                    case 7:
                        fribool =NO;
                        [bt setImage:[UIImage imageNamed:@" btn_5.png"] forState:UIControlStateNormal];
                        break;
                    case 8:
                        satbool =NO;
                        [bt setImage:[UIImage imageNamed:@" btn_7.png"] forState:UIControlStateNormal];
                        break;
                        
                    default:
                        break;
                }
                
                //                [bt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
        [arr release];
        program_label_Time.text =[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"startTime1"];
        program_miao_Time.text=[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"startTime2"];
        program_label_auto.text=[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"ProgramName"];
        manualView_auto=[[QDManualView alloc]initWithFrame:CGRectMake(0, 196, 320, self.view.frame.size.height-196)];
        manualView_auto.delegate=self;
        manualView_auto.auto_id_manual=auto_pragramId;
        manualView_auto.manual_auto=NO;
        manualView_auto.ManualVCdic=auto_Mutab_Arr;
        manualView_auto.Data_Image_view_cell=auto_Data_arr;
        [self.view addSubview:manualView_auto];
        
        
        
    }
    if (auto_Init_view.hidden)
    {
        manualView_auto.hidden=NO;
    }
    else
    {
        manualView_auto.hidden=YES;
    }
    //[auto_pragramId release];
    [self StopActivityIndicatorView];

}
//保存文件
-(NSString *)dataFilePath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSLog(@"%@",path);
    NSString *filePath = [path stringByAppendingPathComponent:@"manual_imageName"];
    return filePath;
}

-(void)AutoVCdownloadimage
{
    if ([auto_Data_arr count]!=0)
    {
        [auto_Data_arr removeAllObjects];
    }
    
//    auto_Data_arr =[NSMutableArray arrayWithContentsOfFile:[self dataFilePath]];
//    
    for (int i=0; i<[auto_Mutab_Arr count]; i++)
    {
//        for (int b=0; b<[auto_Data_arr count]; b++)
//        {
//            if ([[[auto_Data_arr objectAtIndex:b]objectForKey:@"image_Name"]isEqualToString:[[auto_Mutab_Arr objectAtIndex:i]objectForKey:@"zone"]])
//            {
//                
//            }
//            else
//            {
//                [auto_Data_arr removeObjectAtIndex:b];
                NSData *ImageData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[[auto_Mutab_Arr objectAtIndex:i]objectForKey:@"zone"]]];
                
                if (ImageData)
                {
                    NSMutableDictionary *Manual_image_dic=[[NSMutableDictionary alloc]init];
                    [Manual_image_dic setObject:[NSString stringWithFormat:@"%i",i+1] forKey:@"numberImage"];
                    [Manual_image_dic setObject:ImageData forKey:@"summary_Image_data"];
                    [Manual_image_dic setObject:[[auto_Mutab_Arr objectAtIndex:i]objectForKey:@"zone"] forKey:@"image_Name"];
                    [auto_Data_arr addObject:Manual_image_dic];
                    [Manual_image_dic release];
                }
                [ImageData release];
            }

//        }
//        
//    }
//     [auto_Data_arr writeToFile:[self dataFilePath] atomically:YES];
    //[auto_Data_arr retain];
    [self performSelectorOnMainThread:@selector(autoloadmanualViewdata) withObject:self waitUntilDone:YES];
}
-(void)autoLoginRetun:(NSString *)string
{
    [self StartActivityIndicatorView];
    [self autoloadmanualViewdata];
}


-(void)returnData:(NSString *)string
{
    [self StopActivityIndicatorView];
    if (string==nil||[string isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Server is unreachable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
    }
    else
    {
        UITextView *thetext = (UITextView *)[self.view viewWithTag:10000];
        [thetext removeFromSuperview];
        //NSString *astring=@"{\"id\":1,\"age\":\"2\"}";
        NSArray *data_Arr =[string componentsSeparatedByString:@"#"];
        NSError *error;
        
        auto_Mutab_Arr=[NSJSONSerialization JSONObjectWithData: [[data_Arr objectAtIndex:0] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        [auto_Mutab_Arr retain];
        
        Programstr=[[data_Arr objectAtIndex:1]stringByReplacingOccurrencesOfString:@"Program Type:" withString:@""];;
        [Programstr retain];
        
        mutableDic=[NSJSONSerialization JSONObjectWithData: [[data_Arr objectAtIndex:2] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        [[NSUserDefaults standardUserDefaults]setObject:mutableDic forKey:@"timerDic"];
        [mutableDic retain];
        NSLog(@"mutableDicmutableDicmutableDic=%@",mutableDic);
        
        if (![[data_Arr objectAtIndex:4] isEqualToString:@"Not connected"])
        {
            connet_auto_IV.image=[UIImage imageNamed:@"connected.png"];
        }
        else
        {
            connet_auto_IV.image=[UIImage imageNamed:@"notconnected.png"];
        }

        if ([data_Arr objectAtIndex:5]!=nil)
        {
            [[NSUserDefaults standardUserDefaults]setObject:[data_Arr objectAtIndex:5] forKey:@"autoprogramId"];
            autoProgramIdweek=[data_Arr objectAtIndex:5];
        }
        else
        {
            autoProgramIdweek=nil;
        }
        
        am_pm_label.text=[data_Arr objectAtIndex:6];
        
        if ([auto_pragramId count]!=0)
        {
            [auto_pragramId removeAllObjects];
        }
        for (int i=0; i<10; i++)
        {
            [auto_pragramId addObject:[data_Arr objectAtIndex:i+7]];
        }

        [[NSUserDefaults standardUserDefaults]setObject:data_Arr forKey:@"auto_timeID"];
        [[NSUserDefaults standardUserDefaults]setObject:[data_Arr objectAtIndex:17] forKey:@"auto_image_ID"];
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"AutoORManual"];
        NSThread *ther=[[NSThread alloc]initWithTarget:self selector:@selector(AutoVCdownloadimage) object:nil];
        
        [ther start];
        [ther release];
        
        
    }

}

-(void)clickAutoDataPickerView
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:[datepick date]];
    //NSLog(@"-------------------------%@",destDateString);
    NSArray *date_time_Arr =[destDateString componentsSeparatedByString:@":"];
    if ([[date_time_Arr objectAtIndex:0] intValue]>11)
    {
        if ([[date_time_Arr objectAtIndex:0] intValue]>21)
        {
            program_label_Time.text=[NSString stringWithFormat:@"%i",[[date_time_Arr objectAtIndex:0] intValue]-12];
            
        }
        else
        {
            if ([[date_time_Arr objectAtIndex:0] intValue]==12)
            {
                 program_label_Time.text=[NSString stringWithFormat:@"%i",[[date_time_Arr objectAtIndex:0] intValue]];
            }
            else
            {
                 program_label_Time.text=[NSString stringWithFormat:@"0%i",[[date_time_Arr objectAtIndex:0] intValue]-12];
            }
         
    
        }
        
        am_pm_label.text=@"PM";
    }
    else
    {
        if ([[date_time_Arr objectAtIndex:0]isEqualToString:@"00"])
        {
            program_label_Time.text=@"12";
        }
        else
        {
            program_label_Time.text=[date_time_Arr objectAtIndex:0];
        }
        am_pm_label.text=@"AM";
        
        

    }
    program_miao_Time.text=[date_time_Arr objectAtIndex:1];
    
    

}
//键盘动画
-(void)updatapickviewanimation
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    [self.view insertSubview:datepick atIndex:100];
    [self.view insertSubview:data_Image_View atIndex:100];
    datepick.frame = CGRectMake(0, 250, 320, 50);
    data_Image_View.frame=CGRectMake(0, 200, 320, 50);
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView commitAnimations];
    [datepick setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh-cn"]];

}
-(void)downdatapickviewanimation
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    [self.view insertSubview:datepick atIndex:100];
    [self.view insertSubview:data_Image_View atIndex:100];
    datepick.frame = CGRectMake(0, self.view.frame.size.height+30, 320, 50);
    data_Image_View.frame=CGRectMake(0, self.view.frame.size.height, 320, 20);
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView commitAnimations];
    
    [datepick setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh-cn"]];

}
-(void)tapViewdatapick
{
    [self downdatapickviewanimation];
    
    NSMutableDictionary *time_dic=[NSMutableDictionary dictionary];
    
    [time_dic setObject:program_label_Time.text forKey:@"value"];
    [time_dic setObject:autoProgramIdweek forKey:@"programId"];
    [time_dic setObject:am_pm_label.text forKey:@"timeM"];
    [time_dic setObject:program_miao_Time.text forKey:@"minute"];
    
    [saveBT autotimesendrequest:time_dic];
    
 }
-(void)clickAutoviewtimeButton
{
    
    [self updatapickviewanimation];


}
-(void)clickdatebt:(UIButton *)bu
{
    NSMutableDictionary *auto_dic=[NSMutableDictionary dictionary];
    
    switch (bu.tag)
    {
        case 2:
            if (sunbool)
            {
                valStr=@"0";
                //[bu setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [bu setImage:[UIImage imageNamed:@" btn_1.png"] forState:UIControlStateNormal];
                sunbool=NO;
            }
            else
            {
                valStr=@"1";
                //[bu setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [bu setImage:[UIImage imageNamed:@" btn_1q.png"] forState:UIControlStateNormal];
                sunbool=YES;
            }
            weekStr=@"7";
            break;
        case 3:
            if (monbool)
            {
                valStr=@"0";
//                [bu setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [bu setImage:[UIImage imageNamed:@" btn_6.png"] forState:UIControlStateNormal];
                monbool =NO;
            }
            else
            {
                valStr=@"1";
//                [bu setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [bu setImage:[UIImage imageNamed:@" btn_6q.png"] forState:UIControlStateNormal];
                monbool=YES;
            }
             weekStr=@"1";
            break;
        case 4:
            if (tuebool)
            {
                valStr=@"0";
//                [bu setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [bu setImage:[UIImage imageNamed:@" btn_2.png"] forState:UIControlStateNormal];
                tuebool =NO;
            }
            else
            {
                valStr=@"1";
//                [bu setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [bu setImage:[UIImage imageNamed:@" btn_2q.png"] forState:UIControlStateNormal];
                tuebool =YES;
            }
             weekStr=@"2";

            break;
        case 5:
            if (wedbool)
            {
                valStr=@"0";
//                [bu setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [bu setImage:[UIImage imageNamed:@" btn_3.png"] forState:UIControlStateNormal];
                wedbool =NO;
            }
            else
            {
                valStr=@"1";
//                [bu setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [bu setImage:[UIImage imageNamed:@" btn_3q.png"] forState:UIControlStateNormal];
                wedbool =YES;
            }
             weekStr=@"3";

            break;
        case 6:
            if (thubool)
            {
                valStr=@"0";
//                [bu setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [bu setImage:[UIImage imageNamed:@" btn_4.png"] forState:UIControlStateNormal];
                thubool=NO;
            }
            else
            {
                valStr=@"1";
//                [bu setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [bu setImage:[UIImage imageNamed:@" btn_4q.png"] forState:UIControlStateNormal];
                thubool =YES;
            }
             weekStr=@"4";

            break;
        case 7:
            if (fribool)
            {
                valStr=@"0";
//                [bu setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [bu setImage:[UIImage imageNamed:@" btn_5.png"] forState:UIControlStateNormal];
                fribool =NO;
            }
            else
            {
                valStr=@"1";
//                [bu setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [bu setImage:[UIImage imageNamed:@" btn_5q.png"] forState:UIControlStateNormal];
                fribool =YES;
            }
             weekStr=@"5";

            break;
        case 8:
            if (satbool)
            {
                valStr=@"0";
//                [bu setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [bu setImage:[UIImage imageNamed:@" btn_7.png"] forState:UIControlStateNormal];
                satbool =NO;
            }
            else
            {
                valStr=@"1";
//                [bu setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [bu setImage:[UIImage imageNamed:@" btn_7q.png"] forState:UIControlStateNormal];
                satbool =YES;
            }
             weekStr=@"6";

            break;
            
        default:
            break;
    }
    [auto_dic setObject:valStr forKey:@"value"];
    [auto_dic setObject:weekStr forKey:@"weekId"];
    [auto_dic setObject:autoProgramIdweek forKey:@"programId"];
    
    [saveBT autoweeksendrequest:auto_dic];
    
}
-(void)clickProgramBT
{
    if (!manualView_auto.hidden)
    {
        [Program_BT setHidden:YES];
        manualView_auto.hidden=YES;
        auto_Init_view.hidden=NO;
        
    }

}
-(void)clickcancelBtTime
{
    [self downdatapickviewanimation];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //注册通知
    NSNotificationCenter *noc = [NSNotificationCenter defaultCenter];
    [noc addObserver:self selector:@selector(gotoAutoManualview) name:@"RefreshNow" object:nil];
    
    auto_Data_arr =[[NSMutableArray alloc]init];
    auto_Mutab_Arr =[[NSMutableArray alloc]init];
    mutableDic =[[NSMutableDictionary alloc]init];
    saveBT=[[QDNetRequstData alloc]init];
    dataArray = [[NSArray alloc]initWithObjects:@"Program A",@"Program B",@"Program C",@"Program D", nil];
    
    
    auto_pragramId =[[NSMutableArray alloc]init];
    //背景图片
    UIImageView *black_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background.png"]];
    black_Image.frame=self.view.bounds;
    [self.view addSubview:black_Image];
    [black_Image release];
    //Auto标题背景
    UIImageView *Auto_Title_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navgationbar.png"]];
    Auto_Title_Image.frame=CGRectMake(0, 0, 320, 40);
    [self.view addSubview:Auto_Title_Image];
    [Auto_Title_Image release];
    //Auto标题
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(140, 0, 110, 40)];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor=[UIColor whiteColor];
    title_label.text=@"Auto";
    title_label.font=[UIFont systemFontOfSize:25];
    [self.view addSubview:title_label];
    [title_label release];
    
    UIImageView *image_View=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ID_autobar@2x.png"]];
    image_View.frame=CGRectMake(0, 40, 320, 156);
    [self.view addSubview:image_View];
    [image_View release];
    
    connet_auto_IV =[[UIImageView alloc]initWithFrame:CGRectMake(200, 6, 28, 28)];
    connet_auto_IV.backgroundColor=[UIColor clearColor];
    [self.view addSubview:connet_auto_IV];
    [connet_auto_IV release];
    
    
    UIButton *Set_Button=[[UIButton alloc]initWithFrame:CGRectMake(198, 70, 113, 30)];
    [Set_Button setBackgroundImage:[UIImage imageNamed:@"btn_timesetting.png"] forState:UIControlStateNormal];
    [Set_Button addTarget:self action:@selector(clickAutoviewtimeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Set_Button];
    [Set_Button release];

    
    //program
    program_label_auto=[[UILabel alloc]initWithFrame:CGRectMake(205, 45, 100, 20)];
    program_label_auto.backgroundColor=[UIColor clearColor];
    program_label_auto.textAlignment =NSTextAlignmentLeft;
    [self.view addSubview:program_label_auto];
    [program_label_auto release];

    //AM或是PM
    am_pm_label=[[UILabel alloc]initWithFrame:CGRectMake(205, 76, 30, 20)];
    am_pm_label.backgroundColor=[UIColor clearColor];
    am_pm_label.textAlignment =NSTextAlignmentLeft;
    [self.view addSubview:am_pm_label];
    [am_pm_label release];

    
    //SetTime
    program_label_Time=[[UILabel alloc]initWithFrame:CGRectMake(233, 76, 30, 20)];
    program_label_Time.backgroundColor=[UIColor clearColor];
    program_label_Time.textAlignment =NSTextAlignmentRight;
    [self.view addSubview:program_label_Time];
    [program_label_Time release];
    
    //点
    UILabel*program_dian_Time=[[UILabel alloc]initWithFrame:CGRectMake(268, 75, 5, 20)];
    program_dian_Time.backgroundColor=[UIColor clearColor];
    program_dian_Time.text=@":";
    program_dian_Time.textAlignment =NSTextAlignmentCenter;
    [self.view addSubview:program_dian_Time];
    [program_dian_Time release];

    
    program_miao_Time=[[UILabel alloc]initWithFrame:CGRectMake(278, 76, 30, 20)];
    program_miao_Time.backgroundColor=[UIColor clearColor];
    program_miao_Time.textAlignment =NSTextAlignmentLeft;
    [self.view addSubview:program_miao_Time];
    [program_miao_Time release];
    
    
    
    Program_BT=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 60, 30)];
    [Program_BT setBackgroundImage:[UIImage imageNamed:@"btn_register.png"] forState:UIControlStateNormal];
    [Program_BT setHidden:YES];
    [Program_BT setTitle:@"Back" forState:UIControlStateNormal];
    [Program_BT addTarget:self action:@selector(clickProgramBT) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Program_BT];
    [Program_BT release];

    


//    NSArray* mutarr =[[NSArray alloc]initWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat", nil];
    //xingqi
    for (int i=0; i<7; i++)
    {
        UIButton*program_label_qingqi=[[UIButton alloc]initWithFrame:CGRectMake(3+i*45, 110, 44, 40)];
//        if (i==0)
//        {
//            program_label_qingqi.frame=CGRectMake(134, 95, 25, 20);
//            
//        }
//
//        if (i==3)
//        {
//            program_label_qingqi.frame=CGRectMake(215, 95, 25, 20);
//        }
//        if (i==4)
//        {
//            program_label_qingqi.frame=CGRectMake(243, 95, 25, 20);
//        }
//        if (i==5)
//        {
//            program_label_qingqi.frame=CGRectMake(265, 95, 25, 20);
//        }
//        if (i==6)
//        {
//            program_label_qingqi.frame=CGRectMake(285, 95, 25, 20);
//        }
        switch (i) {
            case 0:
                [program_label_qingqi setImage:[UIImage imageNamed:@" btn_1q.png"] forState:UIControlStateHighlighted];
                break;
            case 1:
                [program_label_qingqi setImage:[UIImage imageNamed:@" btn_6q.png"] forState:UIControlStateHighlighted];
                break;
            case 2:
                [program_label_qingqi setImage:[UIImage imageNamed:@" btn_2q.png"] forState:UIControlStateHighlighted];
                break;
            case 3:
                [program_label_qingqi setImage:[UIImage imageNamed:@" btn_3q.png"] forState:UIControlStateHighlighted];
                break;
            case 4:
                [program_label_qingqi setImage:[UIImage imageNamed:@" btn_4q.png"] forState:UIControlStateHighlighted];
                break;
            case 5:
                [program_label_qingqi setImage:[UIImage imageNamed:@" btn_5q.png"] forState:UIControlStateHighlighted];
                break;
            case 6:
                [program_label_qingqi setImage:[UIImage imageNamed:@" btn_7q.png"] forState:UIControlStateHighlighted];
                break;
                
            default:
                break;
        }
        program_label_qingqi.tag=i+2;
//        [program_label_qingqi setTitle:[mutarr objectAtIndex:i] forState:UIControlStateNormal];
//        program_label_qingqi.titleLabel.font=[UIFont systemFontOfSize:12];
//        [program_label_qingqi setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
//        program_label_qingqi.layer.borderWidth=1;
//        program_label_qingqi.layer.borderColor=[UIColor redColor].CGColor;
        UIEdgeInsets imageInsets = UIEdgeInsetsMake(5.0, 7.0, 5.0, 7.0);
        program_label_qingqi.imageEdgeInsets = imageInsets;
        
        program_label_qingqi.backgroundColor=[UIColor clearColor];
        program_label_qingqi.titleLabel.textAlignment=NSTextAlignmentCenter;
        [program_label_qingqi addTarget:self action:@selector(clickdatebt:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:program_label_qingqi];
        [program_label_qingqi release];
    }
    

    
    //拍照的类
    camer=[[QDCamera alloc]init];
    camer.cameraDelegate=self;
    camer.isAnimated=YES;
    
    
    datepick=[[UIDatePicker alloc]init];
    datepick.frame=CGRectMake(0, self.view.frame.size.height+30, 320, 260);
    datepick.datePickerMode = UIDatePickerModeTime;
//    [datepick setAccessibilityLanguage:@"Chinese"];
    [datepick setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh-cn"]];
//    [datepick setCalendar:[NSCalendar currentCalendar]];
    [datepick setUserInteractionEnabled:YES]; 
    [datepick setDate:[datepick date] animated:YES];
    [datepick addTarget:self action:@selector(clickAutoDataPickerView) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datepick];
    [datepick release];

    
    data_Image_View =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabarpick.png"]];
    [data_Image_View setFrame:CGRectMake(0, self.view.frame.size.height, 320, 20)];
    [data_Image_View setUserInteractionEnabled:YES];
    [self.view addSubview:data_Image_View];
    [data_Image_View release];
    
    UIButton *cancel_Time_BT=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, 50, 30)];
    [cancel_Time_BT setBackgroundImage:[UIImage imageNamed:@"btn_pickercancel@2x.png"] forState:UIControlStateNormal];
    [cancel_Time_BT addTarget:self action:@selector(clickcancelBtTime) forControlEvents:UIControlEventTouchUpInside];
    [data_Image_View addSubview:cancel_Time_BT];
    [cancel_Time_BT release];
    
    UIButton *Ok_Time_BT=[[UIButton alloc]initWithFrame:CGRectMake(270, 10, 50, 30)];
    [Ok_Time_BT setBackgroundImage:[UIImage imageNamed:@"btn_picker@2x.png"] forState:UIControlStateNormal];
    [Ok_Time_BT addTarget:self action:@selector(tapViewdatapick) forControlEvents:UIControlEventTouchUpInside];
    [data_Image_View addSubview:Ok_Time_BT];
    [Ok_Time_BT release];
    
    
    
    
    
    auto_Init_view=[[QDAutoinitIMV alloc]init];
    auto_Init_view.delegate=self;
    [auto_Init_view setUserInteractionEnabled:YES];
    auto_Init_view.frame=CGRectMake(0, 40, 320, self.view.frame.size.height-40);
    [self.view addSubview:auto_Init_view];
    [auto_Init_view release];
    

    
	
}
-(void)clicktableviewcell:(NSString *)str
{
    [self autodefineBTpickView];
    [Program_BT setHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"refreshYN"];
    [self StopActivityIndicatorView];
    [self StopActivityIndicatorView];
}
-(void)viewWillAppear:(BOOL)animated
{ 
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ManualAutoBool"];
    [self StartActivityIndicatorView];
    [self performSelector:@selector(gotoAutoManualview) withObject:nil afterDelay:2];

}
//拍照的代理方法
-(void)cellImage:(UITableViewCell *)cell
{
    came_Photo=YES;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:cell.tag-1] forKey:@"cell_tag"];
    [camer cameraOrSelectImageToViewController:self AndSourceType:UIImagePickerControllerSourceTypeCamera];
  
}
//选取本地照片的代理方法
-(void)selectcellViewImaga:(QDManualAuroCell*)cell
{
    came_Photo=NO;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:cell.tag-1] forKey:@"cell_tag"];
    [camer cameraOrSelectImageToViewController:self AndSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//拍照的代理方法
-(void)returnCameraOrSelectImage:(UIImage *)currentImage
{
    UIImage *curimage=[self imageWithImageSimple:currentImage scaledToSize:CGSizeMake(500.0, 500.0)];

    NSMutableDictionary *post_image_dic=[NSMutableDictionary dictionary];
    [post_image_dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"auto_image_ID"] forKey:@"programId"];
    [post_image_dic setObject:[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"]intValue]+1] forKey:@"number"];
    [post_image_dic setObject:UIImageJPEGRepresentation(curimage,0) forKey:@"file1"];
    
    [saveBT autoupdateimagedata:post_image_dic];
  
   [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"refreshYN"];
    NSMutableDictionary *Auto_dic=[NSMutableDictionary dictionary];
    if (came_Photo)
    {
        
        [[manualView_auto.cellImageArray objectAtIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"]intValue]] setImage:curimage];
        
    }
    else
    {
        if ([manualView_auto.Data_Image_view_cell count]!=0)
        {
            [Auto_dic setObject:[[manualView_auto.Data_Image_view_cell objectAtIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"]intValue]]objectForKey:@"numberImage"] forKey:@"numberImage"];
            
            [manualView_auto.Data_Image_view_cell removeObjectAtIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"]intValue]];
            
            [Auto_dic setObject:UIImagePNGRepresentation(curimage) forKey:@"summary_Image_data"];

           [manualView_auto.Data_Image_view_cell insertObject:Auto_dic atIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"]intValue]];
        }
        else
        {
            [Auto_dic setObject:UIImagePNGRepresentation(curimage) forKey:@"summary_Image_data"];

            [Auto_dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"] forKey:@"numberImage"];
            [manualView_auto.Data_Image_view_cell addObject:Auto_dic];
        }
              
        
    }
}
-(void)dealloc
{
    //移除通知
    NSNotificationCenter *noc = [NSNotificationCenter defaultCenter];
    [noc removeObserver:self name:@"RefreshNow" object:nil];

    [manualView_auto release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
