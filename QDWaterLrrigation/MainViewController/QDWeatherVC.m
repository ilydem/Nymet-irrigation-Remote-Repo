
#import "QDWeatherVC.h"

@interface QDWeatherVC ()
{
    UILabel *title_label;
    UILabel *Current_temperature_laber;
    NSMutableArray *mutab_laber;
    NSMutableArray *mutable_arr_Week;
    UITextField *Code_label;
    UITextField *Temp_field;
    UITextField *temp_higherThan_field;
    UIButton *OFF_BT;
    UIButton *ON_BT;
    QDCellFlowSenorView *click_Weather;
    UILabel *Weather_label;
}



@end

@implementation QDWeatherVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}
-(void)clickWeatherOFFBT
{
    NSMutableDictionary *OFFMu_dic=[[NSMutableDictionary alloc]init];
    [OFFMu_dic setObject:@"1" forKey:@"value"];
    [OFFMu_dic setObject:userID_Int forKey:@"userId"];
    [Weather_request clickWeatherONBT:OFFMu_dic];
    [OFFMu_dic release];
    
    [OFF_BT setImage:[UIImage imageNamed:@"off_active.png"] forState:UIControlStateNormal];
    [ON_BT setImage:[UIImage imageNamed:@"on_normal.png"] forState:UIControlStateNormal];

}
-(void)clickWeatherONBT
{
    NSMutableDictionary *ONMu_dic=[[NSMutableDictionary alloc]init];
    [ONMu_dic setObject:@"0" forKey:@"value"];
    [ONMu_dic setObject:userID_Int forKey:@"userId"];
    [Weather_request clickWeatherONBT:ONMu_dic];
    [ONMu_dic release];
    
    [OFF_BT setImage:[UIImage imageNamed:@"off_normal.png"] forState:UIControlStateNormal];
    [ON_BT setImage:[UIImage imageNamed:@"on_active.png"] forState:UIControlStateNormal];


}
-(void)clickWeatherAccessBT
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://weather.yahoo.com/"]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //注册通知
    NSNotificationCenter *noc = [NSNotificationCenter defaultCenter];
    [noc addObserver:self selector:@selector(gotonetrequstdataWeather) name:@"RefreshNow" object:nil];
    
    mutayy=[[[NSMutableArray alloc]init]retain];
    mutable_Arr =[[[NSMutableArray alloc]init]retain];
     clickArry=[[NSArray arrayWithObjects:@"Not Set",@"Shower", @"Drizzle",@"Rain",@"Heavy rain",@"Rain storm",nil] retain];
    userID_Int =nil;
    //背景图片
    UIImageView *black_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weather.png"]];
    black_Image.frame=CGRectMake(0, 40, 320, 514);
    [self.view addSubview:black_Image];
    [black_Image release];
    //Weather标题背景
    UIImageView *Set_Title_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navgationbar.png"]];
    Set_Title_Image.frame=CGRectMake(0, 0, 320, 40);
    [self.view addSubview:Set_Title_Image];
    [Set_Title_Image release];
    //Weather标题
    title_label=[[UILabel alloc]initWithFrame:CGRectMake(85, 0, 150, 40)];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor=[UIColor whiteColor];
    title_label.textAlignment =NSTextAlignmentCenter;
    title_label.font=[UIFont systemFontOfSize:25];
    [self.view addSubview:title_label];
    [title_label release];
    
    //大的数字温度
    Current_temperature_laber=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, 160, 100)];
    Current_temperature_laber.backgroundColor=[UIColor clearColor];
    Current_temperature_laber.textColor=[UIColor blackColor];
    Current_temperature_laber.textAlignment =NSTextAlignmentCenter;
    Current_temperature_laber.font=[UIFont systemFontOfSize:70];
    [self.view addSubview:Current_temperature_laber];
    [Current_temperature_laber release];
    
    mutab_laber=[[NSMutableArray alloc]init];
    
    for (int i=0; i<3; i++)
    {
        UILabel *Weather_laber=[[UILabel alloc]initWithFrame:CGRectMake(170, 60+i*20, 150, 20)];
        Weather_laber.backgroundColor=[UIColor clearColor];
        Weather_laber.textColor=[UIColor grayColor];
        Weather_laber.numberOfLines=2;
        Weather_laber.textAlignment =NSTextAlignmentLeft;
        [self.view addSubview:Weather_laber];
        [Weather_laber release];
        [mutab_laber addObject:Weather_laber];
  
    }
    mutable_arr_Week=[[[NSMutableArray alloc]initWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat", nil]retain];
    
    Code_label=[[UITextField alloc]initWithFrame:CGRectMake(120, 155, 115, 20)];
    Code_label.delegate=self;
    Code_label.backgroundColor=[UIColor clearColor];
    Code_label.tag=260;
    [self.view addSubview:Code_label];
    [Code_label release];
    
    UIButton *Code_BT=[[UIButton alloc]initWithFrame:CGRectMake(240, 151, 65, 27)];
    [Code_BT setBackgroundImage:[UIImage imageNamed:@"access.png"] forState:UIControlStateNormal];
    [Code_BT addTarget:self action:@selector(clickWeatherAccessBT) forControlEvents:UIControlEventTouchUpInside];
    [Code_BT setTitle:@"Access" forState:UIControlStateNormal];
    [Code_BT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:Code_BT];
    [Code_BT release];
    
    Temp_field=[[UITextField alloc]initWithFrame:CGRectMake(220, 222, 40, 25)];
    Temp_field.delegate=self;
    Temp_field.tag=101;
    Temp_field.textAlignment=NSTextAlignmentCenter;
    [Temp_field setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:Temp_field];
    [Temp_field release];
    
    
    
    click_Weather=[[QDCellFlowSenorView alloc]initWithFrame:CGRectMake(235, 256, 27, 27)];
    click_Weather.delegate=self;
    [click_Weather.SaveButton setImage:[UIImage imageNamed:@"xialaf.png"] forState:UIControlStateNormal];
    [self.view addSubview:click_Weather];
    [click_Weather release];

    
    temp_higherThan_field=[[UITextField alloc]initWithFrame:CGRectMake(220, 332, 40, 25)];
    temp_higherThan_field.delegate=self;
    temp_higherThan_field.tag=102;
    temp_higherThan_field.textAlignment=NSTextAlignmentCenter;
    [temp_higherThan_field setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:temp_higherThan_field];
    [temp_higherThan_field release];
    
    
    OFF_BT=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 38, 31)];
    [OFF_BT setImage:[UIImage imageNamed:@"off_normal.png"] forState:UIControlStateNormal];
    [OFF_BT setImage:[UIImage imageNamed:@"off_active.png"] forState:UIControlStateHighlighted];
    [OFF_BT addTarget:self action:@selector(clickWeatherOFFBT) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OFF_BT];
    [OFF_BT release];
    
    ON_BT=[[UIButton alloc]initWithFrame:CGRectMake(43, 5, 38, 31)];
    [ON_BT setImage:[UIImage imageNamed:@"on_normal.png"] forState:UIControlStateNormal];
    [ON_BT setImage:[UIImage imageNamed:@"on_active.png"] forState:UIControlStateHighlighted];
    [ON_BT addTarget:self action:@selector(clickWeatherONBT) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ON_BT];
    [ON_BT release];
    
    
    Weather_label=[[UILabel alloc]initWithFrame:CGRectMake(120, 260, 110, 20)];
    Weather_label.textAlignment =NSTextAlignmentCenter;
    [Weather_label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:Weather_label];
    [Weather_label release];
    
    Error_label=[[UILabel alloc]initWithFrame:CGRectMake(85, 365, 220, 40)];
    Error_label.numberOfLines=2;
    Error_label.textAlignment=NSTextAlignmentLeft;
    [Error_label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:Error_label];
    [Error_label release];
    
      
    

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
//    return 2;
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    switch (component)
//    {
//        case 0:
//            return 10;
//            break;
//        case 1:
//            return 10;
//            break;
//        default:
//            return 0;
//            break;
//    }
    return 100;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    for (int i=0; i<10; i++)
//    {
//        [mutayy addObject:[NSString stringWithFormat:@"%i",i]];
//    }
//    for (int i=0; i<10; i++)
//    {
//        [mutable_Arr addObject:[NSString stringWithFormat:@"%i",i]];
//    }
//    switch (component)
//    {
//        case 0:
//            return [mutayy objectAtIndex:row];
//            break;
//        case 1:
//            return [mutable_Arr objectAtIndex:row];
//            break;
//        default:
//            return 0;
//            break;
//    }
    if ([mutayy count]==0)
    {
        for (int i=0; i<101; i++)
        {
            [mutayy addObject:[NSString stringWithFormat:@"%i",i]];
        }
    }

    
    return [mutayy objectAtIndex:row];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if (TempBOOL)
//    {
//        
//        switch (component)
//        {
//            case 0:
//                shiwei=[mutayy objectAtIndex:row];
//                break;
//            case 1:
//                gewei=[mutable_Arr objectAtIndex:row];
//                break;
//                
//            default:
//                break;
//        }
//        Temp_field.text =[NSString stringWithFormat:@"%@%@",shiwei,gewei];
//
//    }else
//    {
//        if (HigherThanBOOL)
//        {
//            switch (component)
//            {
//                case 0:
//                    shiwei=[mutayy objectAtIndex:row];
//                    break;
//                case 1:
//                    gewei=[mutable_Arr objectAtIndex:row];
//                    break;
//                    
//                default:
//                    break;
//            }
//            temp_higherThan_field.text =[NSString stringWithFormat:@"%@%@",shiwei,gewei];
//        }
//    }
    if (TempBOOL)
    {
        Temp_field.text =[mutayy objectAtIndex:row];
    }
    else
    {
        if (HigherThanBOOL)
        {
            temp_higherThan_field.text = [mutayy objectAtIndex:row];
        }
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    shiwei=@"0";
    gewei=@"0";
    if ((textField.tag!=260))
    {
        switch (textField.tag)
        {
            case 101:
                TempBOOL=YES;
                break;
            case 102:
                HigherThanBOOL=YES;
                break;
                
            default:
                break;
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        self.view.frame =CGRectMake(0 , -150, self.view.frame.size.width,self.view.frame.size.height);
        [UIView setAnimationDelegate:self.view];
        [UIView commitAnimations];
        
        if (TempBOOL||HigherThanBOOL)
        {
            UIPickerView *_pickerView = [[UIPickerView alloc] init];
            
            [_pickerView sizeToFit];
            
            _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            _pickerView.delegate = self;
            
            //_pickerView.dataSource = self;
            
            _pickerView.showsSelectionIndicator = YES;
            
            textField.inputView = _pickerView;
            
            [_pickerView release];
            
        }

    }


}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    self.view.frame =CGRectMake(0 , 0, self.view.frame.size.width,self.view.frame.size.height);
    [UIView setAnimationDelegate:self.view];
    [UIView commitAnimations];
    if (TempBOOL)
    {
        NSMutableDictionary *mutabDIC=[[NSMutableDictionary alloc]init];
        [mutabDIC setObject:Temp_field.text forKey:@"value"];
        [mutabDIC setObject:userID_Int forKey:@"userId"];
        [Weather_request clickTempTextField:mutabDIC];
        [mutabDIC release];
        TempBOOL=NO;
    }
    if (HigherThanBOOL)
    {
        NSMutableDictionary *mutabDIC=[[NSMutableDictionary alloc]init];
        [mutabDIC setObject:temp_higherThan_field.text forKey:@"value"];
        [mutabDIC setObject:userID_Int forKey:@"userId"];
        [Weather_request clickWeatherHigherThan:mutabDIC];
        HigherThanBOOL=NO;
        [mutabDIC release];
    }
    if (textField.tag==260)
    {
        NSMutableDictionary *cityCodedic=[[NSMutableDictionary alloc]init];
        [cityCodedic setObject:Code_label.text forKey:@"citySelect1"];
        [cityCodedic setObject:Temp_field.text forKey:@"tLow2Close"];
        [cityCodedic setObject:Weather_ID forKey:@"rHigh2Close"];
        [cityCodedic setObject:temp_higherThan_field.text forKey:@"tHigh2Open"];
        [Weather_request cityCodeweather:cityCodedic];
        [cityCodedic release];
    }

}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [Code_label resignFirstResponder];
    [Temp_field resignFirstResponder];
    [temp_higherThan_field resignFirstResponder];
    [self performSelector:@selector(gotonetrequstdataWeather) withObject:nil afterDelay:0.01];
}
-(void)clickBTSelectSensor:(UIButton *)bu viewrow:(int)ro
{
    UIView *view=[self.view viewWithTag:210];
    if (view)
    {
        [view removeFromSuperview];
        return;
    }
    UIView *vi=[[UIView alloc] init];
    [vi setUserInteractionEnabled:YES];
    vi.frame=CGRectMake(120, 280, 110, 120);
    vi.tag=210;
    vi.backgroundColor=[UIColor colorWithRed:.6 green:.6 blue:.6 alpha:1];
    for (int i=0; i<[clickArry count]; i++)
    {
        UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.frame=CGRectMake(0, i*20, 110, 20);
        [bt addTarget:self action:@selector(selectTitleAlread:) forControlEvents:UIControlEventTouchUpInside];
        bt.layer.borderWidth=.5;
        bt.layer.borderColor=[UIColor whiteColor].CGColor;
        [bt setTitle:[clickArry objectAtIndex:i] forState:UIControlStateNormal];
        bt.tag=i+100;
        [vi addSubview:bt];
    }
    [self.view addSubview:vi];
    [vi release];


}
-(void)selectTitleAlread:(UIButton *)bu
{
    NSString *selectValue=nil;
    NSMutableDictionary *select_dic=[NSMutableDictionary dictionary];
//    QDCellFlowSenorView *view=(QDCellFlowSenorView *)[self.view viewWithTag:selfrow];
//    UILabel *bt=(UILabel *)[click_Weather viewWithTag:10];
    Weather_label.text =bu.titleLabel.text;
    
    
    if ([Weather_label.text isEqualToString:@"Shower"])
    {
        selectValue=@"1";
    }
    else
    {
        if ([Weather_label.text isEqualToString:@"Drizzle"])
        {
            selectValue=@"2";
        }
        else
        {
            if ([Weather_label.text isEqualToString:@"Rain"])
            {
                selectValue=@"3";
            }
            else
            {
                if ([Weather_label.text isEqualToString:@"Heavy rain"])
                {
                    selectValue=@"4";
                }
                else
                {
                    if ([Weather_label.text isEqualToString:@"Rain storm"])
                    {
                        selectValue=@"5";
                    }
                    else
                    {
                        if ([Weather_label.text isEqualToString:@"Not Set"])
                        {
                            selectValue=@"6";
                        }
                    }
                }
                
            }
        }
    }
    [select_dic setObject:selectValue forKey:@"value"];
    [select_dic setObject:userID_Int forKey:@"userId"];
    [Weather_request stopIrrigatingAt:select_dic];
    UIView *vi=[self.view viewWithTag:210];
    [vi removeFromSuperview];

}
-(void)gotonetrequstdataWeather
{
    if (self.tabBarController.selectedIndex ==4)
    {
    Weather_request=[[QDNetRequstData alloc]init];
    Weather_request.delegate=self;
    [Weather_request requstWeatherData];
    }

}
#pragma mark//开始旋转的风火轮
-(void)StartActivityIndicatorView
{
    QDActivityIndicatorView*activi=[[QDActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-20, 40, 40)];
    activi.tag=119;
    [self.view addSubview:activi];
    [activi release];
    
}
#pragma mark//停止旋转的风火轮
-(void)StopActivityIndicatorView
{
    QDActivityIndicatorView *act=(QDActivityIndicatorView*)[self.view viewWithTag:119];
    if (act)
    {
        [act removeFromSuperview];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"refreshYN"];
    [self StopActivityIndicatorView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self StartActivityIndicatorView];
    [self performSelector:@selector(gotonetrequstdataWeather) withObject:nil afterDelay:0.01];
}
-(void)viewDidDisappear:(BOOL)animated
{
   
}

-(void)autoLoginRetun:(NSString *)string
{
    [self StartActivityIndicatorView];
    [self gotonetrequstdataWeather];
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
        NSArray *Weather_Arr =[string componentsSeparatedByString:@"#"];
//        [[NSUserDefaults standardUserDefaults]setObject:Weather_Arr forKey:@"select_sensor_set"];
        NSError *error;
        NSMutableDictionary *dic =[NSJSONSerialization JSONObjectWithData: [[Weather_Arr objectAtIndex:0] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"weather:%@",dic);
        
        title_label.text=[dic objectForKey:@"City:"];
        Current_temperature_laber.text=[dic objectForKey:@"TEMP:"];
        ((UILabel *)[mutab_laber objectAtIndex:0]).text=[dic objectForKey:@"Weather:"];
        ((UILabel *)[mutab_laber objectAtIndex:1]).text=[NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"Low:"],[dic objectForKey:@"High:"]];
        
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        int year = [dateComponent year];
        int month = [dateComponent month];
        int day = [dateComponent day];
        int weekday = [dateComponent weekday];
        int hour = [dateComponent hour];
        int minute = [dateComponent minute];
        int second = [dateComponent second];
        NSLog(@"%d,%d,%d,%d,%d,%d,%d",year,month,day,weekday,hour,minute,second);
         ((UILabel *)[mutab_laber objectAtIndex:2]).text=[NSString stringWithFormat:@"%d/%d %@",day,month,[mutable_arr_Week objectAtIndex:weekday-1]];
        
        if ([[Weather_Arr objectAtIndex:1]isEqualToString:@"ON"])
        {
            [OFF_BT setImage:[UIImage imageNamed:@"off_normal.png"] forState:UIControlStateNormal];
            [ON_BT setImage:[UIImage imageNamed:@"on_active.png"] forState:UIControlStateNormal];
        }
        else
        {
            
            [OFF_BT setImage:[UIImage imageNamed:@"off_active.png"] forState:UIControlStateNormal];
            [ON_BT setImage:[UIImage imageNamed:@"on_normal.png"] forState:UIControlStateNormal];
            
        }
        Code_label.text =[Weather_Arr objectAtIndex:2];
        Temp_field.text =[Weather_Arr objectAtIndex:3];
        temp_higherThan_field.text =[Weather_Arr objectAtIndex:4];
        Weather_label.text=[Weather_Arr objectAtIndex:5];
        userID_Int =[[Weather_Arr objectAtIndex:6]retain];
        Weather_ID=[[Weather_Arr objectAtIndex:7]retain];
        Error_label.text=[[Weather_Arr objectAtIndex:8]retain];
    }
    [self StopActivityIndicatorView];
    
    
}
-(void)servernotResponding:(NSString *)msgStr
{
    [self StopActivityIndicatorView];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:msgStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
    [alert release];
}

-(void)dealloc
{
    //移除通知
    NSNotificationCenter *noc = [NSNotificationCenter defaultCenter];
    [noc removeObserver:self name:@"RefreshNow" object:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
