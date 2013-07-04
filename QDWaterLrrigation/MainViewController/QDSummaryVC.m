

#import "QDSummaryVC.h"
#define QDMRC 118
@interface QDSummaryVC ()
{
    UILabel *program_label;
    UILabel *current_label;
    UILabel *totalused_label;
    UILabel *average_label;
    QDSummaryView *summary_View;
    NSOperationQueue *operationQueue;
    NSMutableArray *mutab_Arr;
    NSMutableArray *list_dic;
    NSMutableDictionary *Master_dic;
    NSMutableDictionary *program_Dic;
    NSString *strProm;
    NSString *Run;
    QDNetRequstData*summaryRequst;
    NSArray *arr_BT;
    NSInteger selectRowInteger;
    UIView *p_v;
    //UIButton *cancel_watring_BT;
    NSString *cancel_Str;
    QDSystem *Sys;
}

@end

@implementation QDSummaryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}
-(void)gotosummaryview
{
    if (self.tabBarController.selectedIndex ==0)
    {
        summaryRequst=[[QDNetRequstData alloc]init];
        summaryRequst.delegate=self;
        [summaryRequst requstSummaryData];
    }
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"refreshYN"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ManualAutoBool"];
    [self StopActivityIndicatorView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self StartActivityIndicatorView];
    [self performSelector:@selector(gotosummaryview) withObject:nil afterDelay:0.01];

}
- (void)viewDidAppear:(BOOL)animated
{
    [self StopActivityIndicatorView];
}
-(void)selecterroralertdview:(NSString *)str
{
    UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"Error" message:str delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Handle", nil];
    [aler show];
    [aler release];

}
-(void)clickerrrorBtvoid
{
    Master_BT.titleLabel.textColor=[UIColor redColor];
    zhu_zi =NO;
    [self selecterroralertdview:err_str];
}
#pragma mark //加载summayrView
-(void)loginDownloadsummaryview
{
    if (summary_View)
    {
        program_label.text =strProm;
        current_label.text =[Master_dic objectForKey:@"totalWaterUsed"];
        average_label.text =[Master_dic objectForKey:@"averageFlow"];
        summary_View.dic=list_dic;
        summary_View.im_Data=mutab_Arr;
        [summary_View.tab reloadData];
    }
    else
        
    {
        program_label.text =strProm;
        current_label.text =[Master_dic objectForKey:@"totalWaterUsed"];
        average_label.text =[Master_dic objectForKey:@"averageFlow"];
        summary_View=[[QDSummaryView alloc]initWithFrame:CGRectMake(0, 174, 320, self.view.frame.size.height-174)];
        summary_View.dic=list_dic;
        summary_View.im_Data=mutab_Arr;
        summary_View.delegate=self;
        summary_View.backgroundColor=[UIColor clearColor];
        [self.view addSubview:summary_View];
        
        
    }
    if ([[Master_dic objectForKey:@"currentFlow"] intValue]>99999&&[[Master_dic objectForKey:@"currentFlow"] intValue]<999999)
    {
        totalused_label.text =[NSString stringWithFormat:@"%.2f%@",[[Master_dic objectForKey:@"currentFlow"] floatValue]/1000,@"k"];
        
    }
    else
    {
        if ([[Master_dic objectForKey:@"currentFlow"] intValue]>999999)
        {
            totalused_label.text =[NSString stringWithFormat:@"%.2f%@",[[Master_dic objectForKey:@"currentFlow"] floatValue]/1000000,@"m"];

        }
        else
        {
            totalused_label.text =[Master_dic objectForKey:@"currentFlow"];
        }
        
    }
    [summary_View.tab reloadData];
    [self StopActivityIndicatorView];
}

-(void)summaryclickErrorBT
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ZhuFaMen"];
    zhu_zi =YES;
    [self selecterroralertdview:[[NSUserDefaults standardUserDefaults] objectForKey:@"sumarrayEROR"]];
}
//点击pickview取消按钮的方法
-(void)cancellBTPickView
{
    if (p_v)
    {
        [p_v removeFromSuperview];
    }

}
//点击pickview确定按钮的方法
-(void)defineBTpickView
{
      NSString *str=nil;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"ZhuFaMen"])
    {

        switch (selectRowInteger)
        {
            case 0:
                str =@"3";
                break;
            case 1:
                str =@"1";
                break;
            case 2:
                str =@"2";
                break;
            case 3:
                str =@"0";
                break;
            default:
                break;
        }
        [summaryRequst clicksummaryBT:str];
    }
    else
    {
        
        switch (selectRowInteger)
        {
            case 0:
                str =@"3";
                break;
            case 1:
                str =@"1";
                break;
            case 2:
                str =@"0";
                break;
            case 3:
                str =@"2";
                break;
            default:
                break;
        }

        [summaryRequst clickzhufamensummaryBT:str];
        
    }
    stopPlaySoundShock=YES;
    [self cancellBTPickView];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==119)
    {
        if (buttonIndex==0)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginBTName" object:nil];
            [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
        }

    }
    else
    {
        if (buttonIndex==0)
        {
            //[summaryRequst clicksummaryBT:@"0"];
        }
        else
        {
            p_v=[[UIView alloc]initWithFrame:CGRectMake(0, 210, 320, 200)];
            [p_v setUserInteractionEnabled:YES];
            [p_v setBackgroundColor:[UIColor redColor]];
            [self.view addSubview:p_v];
            [p_v release];
            
            UIImageView *imv=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
            imv.image=[UIImage imageNamed:@"tabarpick.png"];
            [p_v addSubview:imv];
            [imv release];
            
            
            UIPickerView *pick_View=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, p_v.frame.size.width, 50)];
            [pick_View setDelegate:self];
            [pick_View setDataSource:self];
            [p_v addSubview:pick_View];
            pick_View.showsSelectionIndicator=YES;
            [pick_View release];
            
            UIButton *define_BT=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 50, 30)];
            [define_BT setBackgroundImage:[UIImage imageNamed:@"btn_picker@2x.png"] forState:UIControlStateNormal];
            [define_BT addTarget:self action:@selector(defineBTpickView) forControlEvents:UIControlEventTouchUpInside];
            [p_v addSubview:define_BT];
            [define_BT release];
            
            UIButton *Cal_BT=[[UIButton alloc]initWithFrame:CGRectMake(p_v.frame.size.width-55, 5, 50, 30)];
            [Cal_BT setBackgroundImage:[UIImage imageNamed:@"btn_pickercancel@2x.png"] forState:UIControlStateNormal];
            [Cal_BT addTarget:self action:@selector(cancellBTPickView) forControlEvents:UIControlEventTouchUpInside];
            [p_v addSubview:Cal_BT];
            [Cal_BT release];
        }
 
    }
    

}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (zhu_zi)
    {
        return 4;
    }
    else
    {
       return 3;
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *returnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 25)];
    if (zhu_zi)
    {
        [returnLabel setText:[arr_BT objectAtIndex:row]];
    }
    else
    {
        [returnLabel setText:[pick_zonetime_arr objectAtIndex:row]];
    }
    
    [returnLabel setBackgroundColor:[UIColor clearColor]];
    UIView *imageView = [[UIView alloc]initWithFrame:CGRectMake(120, 0, 40, 25)];
    [imageView setBackgroundColor:[UIColor clearColor]];
    if (selectRowInteger == row)
    {
        [imageView setHidden:NO];
    }
    else
    {
        [imageView setHidden:YES];
    }

    
    UIControl *controlView = [[UIControl alloc]initWithFrame:CGRectMake(60, 0, 160, 25)];
    [controlView addSubview:returnLabel];
    [returnLabel release];
    
    [controlView addSubview:imageView];
    [imageView release];
    UIImageView *imv=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    imv.image=[UIImage imageNamed:@"tick.png"];
    [imageView addSubview:imv];
    [imv release];
    
    return [controlView autorelease];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    selectRowInteger = row;
  
    for (int i = 0; i < pickerView.subviews.count; i++)
    {
        if (i == row)
        {
            UIControl *controlView = (UIControl *)[pickerView viewForRow:i forComponent:component];
            for (id view in controlView.subviews)
            {
                if([view class] == [UIView class])
                {
                    [view setHidden:NO];
                }
            }
        }
        else
        {
            UIControl *controlView = (UIControl *)[pickerView viewForRow:i forComponent:component];
            for (id view in controlView.subviews)
            {
               
                if([view class] == [UIView class])
                {
                
                    [view setHidden:YES];
                }
            }
        }
        
    }


}
#pragma mark //保存文件
-(NSString *)dataFilePath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"manual_imageName"];
    return filePath;
}

#pragma mark //开启线程下载图片
-(void)downloadimage
{
    if ([mutab_Arr count]!=0)
    {
        [mutab_Arr removeAllObjects];
    }

    
    
//    if ([list_dic count]!=0)
//    {

    for (int i=0; i<[list_dic count]; i++)
    {
  
        NSData *ImageData = nil;
        if ([list_dic count])
        {
             ImageData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[[list_dic objectAtIndex:i]objectForKey:@"zone"]]];
        }
       
        
        if ([ImageData length]!=0)
        {
            NSMutableDictionary *ImageData_Dic=[[NSMutableDictionary alloc]init];
            if ([list_dic count])
            {
            [ImageData_Dic setObject:[[list_dic objectAtIndex:i] objectForKey:@"number"] forKey:@"numberImage"];
            [ImageData_Dic setObject:[[list_dic objectAtIndex:i]objectForKey:@"zone"] forKey:@"image_Name"];
            }
            [ImageData_Dic setObject:ImageData forKey:@"summary_Image_data"];
            [mutab_Arr addObject:ImageData_Dic];
            [ImageData_Dic release];
        }
        [ImageData release];
        }
//    }
    
    [self performSelectorOnMainThread:@selector(loginDownloadsummaryview) withObject:self waitUntilDone:YES];
    
}
-(void)clickCancelBt
{
    if (!run_cancel)
    {
        [Cancel_BT setImage:[UIImage imageNamed:@"btn_cancelactive.png"] forState:UIControlStateNormal];
        [Run_BT setImage:[UIImage imageNamed:@"btn_run.png"] forState:UIControlStateNormal];
        cancel_Str =@"0";
        [summaryRequst requestsummarycancelwating:cancel_Str];
        
        run_cancel=YES;
    }
}
-(void)clickRunBt
{
    if (run_cancel)
    {
        [Run_BT setImage:[UIImage imageNamed:@"btn_runactive.png"] forState:UIControlStateNormal];
        [Cancel_BT setImage:[UIImage imageNamed:@"btn_cancel.png"] forState:UIControlStateNormal];
        cancel_Str =@"1";
        [summaryRequst requestsummarycancelwating:cancel_Str];
        run_cancel=NO;

    }

}

-(void)autoLoginRetun:(NSString *)string
{
    [self StartActivityIndicatorView];
    [self gotosummaryview];
}



#pragma mark 返回数据
-(void)returnData:(NSString *)string
{
    
    if (string==nil||[string isEqualToString:@""])
    {
        [self StopActivityIndicatorView];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Server is unreachable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
    }
    else
    {
        //NSString *astring=@"{\"id\":1,\"age\":\"2\"}";
        NSArray *data_Arr =[string componentsSeparatedByString:@"#"];
        [[NSUserDefaults standardUserDefaults]setObject:data_Arr forKey:@"Summary_error_ID"];
        NSError *error;
        Master_dic=[NSJSONSerialization JSONObjectWithData: [[data_Arr objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        [Master_dic retain];
        
        if ([list_dic count])
        {
            [list_dic release];
            list_dic = nil;
        }
        list_dic = [[NSMutableArray alloc]initWithArray:[NSJSONSerialization JSONObjectWithData: [[data_Arr objectAtIndex:2] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error]];
//        list_dic=[NSJSONSerialization JSONObjectWithData: [[data_Arr objectAtIndex:2] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
//        [list_dic retain];
        
        //[list_dic writeToFile:[self dataFilePath] atomically:YES];
        
        [[NSUserDefaults standardUserDefaults]setObject:list_dic forKey:@"selectSensorSetting"];
        
        strProm=[[data_Arr objectAtIndex:3]stringByReplacingOccurrencesOfString:@"Program Type: " withString:@""];
        [strProm retain];
        
        Run=[data_Arr objectAtIndex:5];
        if (Run!=nil&&(![Run isEqualToString:@""]))
        {
            [[NSUserDefaults standardUserDefaults]setObject:Run forKey:@"nowrunEquipment"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"nowrunEquipment"];
        }
        
        
        
        
        NSString *connet_Str=[data_Arr objectAtIndex:4];
        if (![connet_Str isEqualToString:@"Not connected"])
        {
            connet_ImageView.image=[UIImage imageNamed:@"connected.png"];
        }
        else
        {
            connet_ImageView.image=[UIImage imageNamed:@"notconnected.png"];
        }
        if ([[data_Arr objectAtIndex:6] isEqualToString:@"Cancel Watering"])
        {
            cancel_Str=@"0";
        }
        else
        {
            cancel_Str=@"1";
        }
       // [cancel_watring_BT setTitle:[data_Arr objectAtIndex:6] forState:UIControlStateNormal];
        
        if ([[data_Arr objectAtIndex:6] isEqualToString:@"Start Watering"])
        {
            [Cancel_BT setImage:[UIImage imageNamed:@"btn_cancelactive.png"] forState:UIControlStateNormal];
            
            [Run_BT setImage:[UIImage imageNamed:@"btn_run.png"] forState:UIControlStateNormal];
            run_cancel=YES;
        }
        else
        {
            [Cancel_BT setImage:[UIImage imageNamed:@"btn_cancel.png"] forState:UIControlStateNormal];
            
            [Run_BT setImage:[UIImage imageNamed:@"btn_runactive.png"] forState:UIControlStateNormal];
            run_cancel=NO;
        }
            
        
        
        
        if ([[data_Arr objectAtIndex:18]isEqualToString:@"BBffBB"])
        {
            [masterimage setImage:[UIImage imageNamed:@"ID_masterw2"]];
        }
        else
        {
            [masterimage setImage:[UIImage imageNamed:@"ID_masterw1"]];
            

        }
        
        
        
        
        [[NSUserDefaults standardUserDefaults]setObject:[data_Arr objectAtIndex:22] forKey:@"summary_useID_error"];
        NSArray *yunXing =[[data_Arr objectAtIndex:21] componentsSeparatedByString:@";"];
        NSArray *Two_yunXing = nil;
        if ([data_Arr count]==24)
        {
             Two_yunXing =[[data_Arr objectAtIndex:23] componentsSeparatedByString:@";"];
        }
       
        
        
        
        if ([Run isEqualToString:@"2"]||[Run isEqualToString:@""])
        {
            if ([[yunXing objectAtIndex:0]isEqualToString:@"yellow"]&&[[yunXing objectAtIndex:1]isEqualToString:@"yellow"]&&[[yunXing objectAtIndex:2]isEqualToString:@"yellow"])
            {
                [Sys OpenShock];
                [Sys playSound];
                
            }
            else
            {
                if ([[Two_yunXing objectAtIndex:0]isEqualToString:@"yellow"]&&[[Two_yunXing objectAtIndex:1]isEqualToString:@"yellow"]&&[[Two_yunXing objectAtIndex:2]isEqualToString:@"yellow"])
                {
                    [Sys OpenShock];
                    [Sys playSound];
                    
                }
 
            }


        }
        else
        {
            if ([[yunXing objectAtIndex:0]isEqualToString:@"yellow"]&&[[yunXing objectAtIndex:1]isEqualToString:@"yellow"]&&[[yunXing objectAtIndex:2]isEqualToString:@"yellow"]&&[[yunXing objectAtIndex:3]isEqualToString:@"yellow"])
            {
                [Sys OpenShock];
                [Sys playSound];
                UILocalNotification *notification = [UILocalNotification new];
                notification.timeZone  = [NSTimeZone systemTimeZone];
                notification.fireDate  = [[NSDate date] dateByAddingTimeInterval:5.0f];
                notification.alertAction = @"More info";
                notification.alertBody = @"Nymet Irrigation Local Notification";
                notification.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                [notification release];
            }

        }
        
        
        

        if ([[data_Arr objectAtIndex:19]isEqualToString:@"Normal"])
        {
            [Master_BT setTitle:[data_Arr objectAtIndex:19] forState:UIControlStateNormal];
            [Master_BT setUserInteractionEnabled:NO];
            Master_BT.titleLabel.textColor=[UIColor blackColor];
            
        }
        else
        {
            [Master_BT setTitle:@"Error" forState:UIControlStateNormal];
            [Master_BT setUserInteractionEnabled:YES];
            err_str =[data_Arr objectAtIndex:19];
            [Master_BT addTarget:self action:@selector(clickerrrorBtvoid) forControlEvents:UIControlEventTouchUpInside];
            Master_BT.titleLabel.textColor=[UIColor redColor];
            
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ZhuFaMen"];
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:[data_Arr objectAtIndex:7] forKey:@"SummaryImageID"];
        [[NSUserDefaults standardUserDefaults]setObject:[data_Arr objectAtIndex:20] forKey:@"zhuFaMenID"];
        [[NSUserDefaults standardUserDefaults]setObject:strProm forKey:@"Program"];
        NSThread *ther=[[NSThread alloc]initWithTarget:self selector:@selector(downloadimage) object:nil];
    
        [ther start];
        [ther release];
        
        
        
    }
    

}

-(void)servernotResponding:(NSString *)msgStr
{
    [self StopActivityIndicatorView];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:msgStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
    [alert release];
}
#pragma mark//开始旋转的风火轮
-(void)StartActivityIndicatorView
{
    QDActivityIndicatorView*activi=[[QDActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20, 36, 40, 40)];
    activi.tag=QDMRC;
    [self.view addSubview:activi];
    [activi release];
    
}
#pragma mark//停止旋转的风火轮
-(void)StopActivityIndicatorView
{
    QDActivityIndicatorView *act=(QDActivityIndicatorView*)[self.view viewWithTag:QDMRC];
    if (act)
    {
        [act removeFromSuperview];
    }

}

-(void)clickLoginBT
{
    UIAlertView *login_aler_View=[[UIAlertView alloc]initWithTitle:nil message:@"Are you sure to log out?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    login_aler_View.tag=119;
    [login_aler_View show];
    [login_aler_View release];
    
}



#pragma mark //初始化方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    //注册通知
    
    NSNotificationCenter *noc = [NSNotificationCenter defaultCenter];
    [noc addObserver:self selector:@selector(gotosummaryview) name:@"RefreshNow" object:nil];
    
    
    mutab_Arr=[[NSMutableArray alloc]init];
    
    program_Dic=[[NSMutableDictionary alloc]init];
    
    Sys=[[QDSystem alloc]init];
    

    arr_BT =[[NSArray alloc]initWithObjects:@"Continue all",@"Continue zone",@"Stop all",@"Stop zone", nil];
    pick_zonetime_arr =[[NSArray alloc]initWithObjects:@"Continue all",@"Continue zone",@"Stop all", nil];
    //背景图片
    UIImageView *black_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background.png"]];
    black_Image.frame=self.view.bounds;
    [self.view addSubview:black_Image];
    [black_Image release];
    //Summary标题背景
    UIImageView *Summary_Title_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navgationbar.png"]];
    Summary_Title_Image.frame=CGRectMake(0, 0, 320, 40);
    [self.view addSubview:Summary_Title_Image];
    [Summary_Title_Image release];
    //Summary标题
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 110, 40)];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor=[UIColor whiteColor];
    title_label.text=@"Summary";
    title_label.font=[UIFont systemFontOfSize:25];
    [self.view addSubview:title_label];
    [title_label release];
    
    
    Cancel_BT=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 50, 33)];
    //[Cancel_BT setImage:[UIImage imageNamed:@"btn_cancelactive.png"] forState:UIControlStateNormal];
    [Cancel_BT setImage:[UIImage imageNamed:@"btn_cancelactive.png"] forState:UIControlStateHighlighted];
    [Cancel_BT addTarget:self action:@selector(clickCancelBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Cancel_BT];
    [Cancel_BT release];
    
    Run_BT=[[UIButton alloc]initWithFrame:CGRectMake(55, 5, 43, 33)];
    //[Cancel_BT setImage:[UIImage imageNamed:@"btn_cancelactive.png"] forState:UIControlStateNormal];
    [Run_BT setImage:[UIImage imageNamed:@"btn_runactive.png"] forState:UIControlStateHighlighted];
    [Run_BT addTarget:self action:@selector(clickRunBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Run_BT];
    [Run_BT release];
    
    

    
    UIImageView *image_View=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ID_title@2x.png"]];
    image_View.frame=CGRectMake(0, 40, 320, 134);
    [self.view addSubview:image_View];
    [image_View release];
    
    
    
    masterimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ID_masterw1"]];
    masterimage.frame=CGRectMake(0, 130, 320, 44);
    [self.view addSubview:masterimage];
    [masterimage release];
    
    Master_BT=[[UIButton alloc]initWithFrame:CGRectMake(260, 142, 50, 20)];
    Master_BT.titleLabel.font=[UIFont systemFontOfSize:15];
    Master_BT.titleLabel.textColor=[UIColor redColor];
    [Master_BT setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:Master_BT];
    [Master_BT release];
    
    
    

    connet_ImageView =[[UIImageView alloc]initWithFrame:CGRectMake(207, 6, 28, 28)];
    connet_ImageView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:connet_ImageView];
    [connet_ImageView release];
    
    //program
    program_label=[[UILabel alloc]initWithFrame:CGRectMake(210, 45, 100, 20)];
    program_label.backgroundColor=[UIColor clearColor];
    [self.view addSubview:program_label];
    [program_label release];
    
    //Master
    current_label=[[UILabel alloc]initWithFrame:CGRectMake(95, 142, 40, 20)];
    current_label.backgroundColor=[UIColor clearColor];
    current_label.textAlignment =NSTextAlignmentCenter;
    current_label.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:current_label];
    [current_label release];
    
    UILabel *master_label=[[UILabel alloc]initWithFrame:CGRectMake(5, 141, 75, 20)];
    master_label.backgroundColor=[UIColor clearColor];
    master_label.textAlignment = NSTextAlignmentCenter;
    master_label.font=[UIFont boldSystemFontOfSize:15];
    master_label.text = @"Master";
    [self.view addSubview:master_label];
    [master_label release];
    
    //Average flow
    average_label=[[UILabel alloc]initWithFrame:CGRectMake(135, 142, 35, 20)];
    average_label.backgroundColor=[UIColor clearColor];
    average_label.textAlignment =NSTextAlignmentCenter;
    average_label.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:average_label];
    [average_label release];
    
    
    totalused_label=[[UILabel alloc]initWithFrame:CGRectMake(170, 142, 40, 20)];
    totalused_label.backgroundColor=[UIColor clearColor];
    totalused_label.textAlignment =NSTextAlignmentCenter;
    totalused_label.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:totalused_label];
    [totalused_label release];
    operationQueue =[[NSOperationQueue alloc]init];
    
    //拍照的类
    camer=[[QDCamera alloc]init];
    camer.cameraDelegate=self;
    camer.isAnimated=YES;
    
    
    
    UIButton *Canceled_BT=[[UIButton alloc]initWithFrame:CGRectMake(235, 5, 80, 30)];
    [Canceled_BT setBackgroundImage:[UIImage imageNamed:@"btn_register.png"] forState:UIControlStateNormal];
    Canceled_BT.titleLabel.font=[UIFont systemFontOfSize:15];
    [Canceled_BT setTitle:@"Log out" forState:UIControlStateNormal];
    [Canceled_BT addTarget:self action:@selector(clickLoginBT) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Canceled_BT];
    [Canceled_BT release];

	[self StartActivityIndicatorView];
}
- (void)didReceiveMemoryWarning
{
    NSLog(@"----aaaaaaa---");
}

//拍照的代理方法
-(void)summarycellImage:(UITableViewCell *)cell
{
    came_Photo=YES;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:cell.tag-1] forKey:@"cell_tag"];
    [camer cameraOrSelectImageToViewController:self AndSourceType:UIImagePickerControllerSourceTypeCamera];
    
}

//选取本地照片的代理方法
-(void)summaryselectcellViewImaga:(UITableViewCell*)cell
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
    
    UIImage *cuimage=[self imageWithImageSimple:currentImage scaledToSize:CGSizeMake(500.0, 500.0)];
    
    NSMutableDictionary *post_image_dic=[NSMutableDictionary dictionary];
    [post_image_dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"SummaryImageID"] forKey:@"programId"];
    [post_image_dic setObject:[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"]intValue]+1] forKey:@"number"];
    [post_image_dic setObject:UIImageJPEGRepresentation(cuimage,0) forKey:@"file1"];
    
    [summaryRequst autoupdateimagedata:post_image_dic];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"refreshYN"];
    //NSMutableDictionary *im_Data_dic=[NSMutableDictionary dictionary];
    
    if (came_Photo)
    {
        
        [[summary_View.cellImageArray objectAtIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"]intValue]] setImage:cuimage];
        
    }
    else
    {
//        [im_Data_dic setObject:[[summary_View.im_Data objectAtIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"]intValue]]objectForKey:@"numberImage"] forKey:@"numberImage"];
//        
//        [summary_View.im_Data removeObjectAtIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"]intValue]];
//        [im_Data_dic setObject:UIImagePNGRepresentation(currentImage) forKey:@"summary_Image_data"];
//        [summary_View.im_Data insertObject:im_Data_dic atIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"]intValue]];
        
    }

}


-(void)dealloc
{
    //移除通知
    NSNotificationCenter *noc = [NSNotificationCenter defaultCenter];
    [noc removeObserver:self name:@"RefreshNow" object:nil];
    
    [arr_BT release];    
    [mutab_Arr release];
    if (list_dic)
    {
        [list_dic release];
        list_dic = nil;
    }
    [Master_dic release];
    [program_Dic release];
    [summary_View release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
