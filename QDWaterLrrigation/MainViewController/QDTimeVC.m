

#import "QDTimeVC.h"
#define PROTF 1
#define HOURTF 2
#define MINTF 3
@interface QDTimeVC ()
{
    UILabel *Sched_label;
}

@end

@implementation QDTimeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}
-(void)clickblackButton
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"refreshYN"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickDoneButton
{
    NSMutableDictionary *mu_dic=[NSMutableDictionary dictionary];
    UITextField *field1=(UITextField *)[self.view viewWithTag:HOURTF];
    UITextField *field2=(UITextField *)[self.view viewWithTag:MINTF];
    UITextField *field3=(UITextField *)[self.view viewWithTag:PROTF];
    
    [mu_dic setObject:field1.text forKey:@"startTime1"];
    [mu_dic setObject:field2.text forKey:@"startTime2"];
    [mu_dic setObject:field3.text forKey:@"ProgramName"];
    [mu_dic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"timerDic"]objectForKey:@"wateringSchedule"] forKey:@"wateringSchedule"];
    [[NSUserDefaults standardUserDefaults]setObject:mu_dic forKey:@"timerDic"];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"refreshYN"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickScheduleButtton
{
    [self.navigationController pushViewController:[[QDTimerWaterVC new] autorelease] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //背景图片
    UIImageView *black_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background.png"]];
    black_Image.frame=CGRectMake(0, 0, 320, 568);
    [self.view addSubview:black_Image];
    [black_Image release];
    //Setting标题背景
    UIImageView *Timer_Title_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navgationbar.png"]];
    Timer_Title_Image.frame=CGRectMake(0, 0, 320, 40);
    [self.view addSubview:Timer_Title_Image];
    [Timer_Title_Image release];
    //Timer标题
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(120, 0, 110, 40)];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor=[UIColor whiteColor];
    title_label.text=@"Timer";
    title_label.font=[UIFont systemFontOfSize:25];
    [self.view addSubview:title_label];
    [title_label release];
    
    //返回按钮
    UIButton *blackButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 60, 32)];
    [blackButton setBackgroundImage:[UIImage imageNamed:@"btn_signin .png"] forState:UIControlStateNormal];
    [blackButton setTitle:@"Back" forState:UIControlStateNormal];
    blackButton.showsTouchWhenHighlighted =YES;
    [blackButton addTarget:self action:@selector(clickblackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blackButton];
    [blackButton release];
    
    
    
    //Done按钮
    UIButton *DoneButton=[[UIButton alloc]initWithFrame:CGRectMake(250, 5, 60, 32)];
    [DoneButton setBackgroundImage:[UIImage imageNamed:@"btn_signin .png"] forState:UIControlStateNormal];
    [DoneButton setTitle:@"Done" forState:UIControlStateNormal];
    DoneButton.showsTouchWhenHighlighted =YES;
    [DoneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:DoneButton];
    [DoneButton release];
    
    
    //下面背景图片
    UIImageView *Timer_black=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 320, 504)];
    Timer_black.image=[UIImage imageNamed:@"setting timer.png"];
    [self.view addSubview:Timer_black];
    [Timer_black release];
    
    UITextField *pro_TextField=[[UITextField alloc]initWithFrame:CGRectMake(30, 105, 260, 30)];
    pro_TextField.tag=PROTF;
    [pro_TextField setUserInteractionEnabled:NO];
    pro_TextField.text=[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"ProgramName"];
    pro_TextField.backgroundColor=[UIColor clearColor];
    [self.view addSubview:pro_TextField];
    [pro_TextField release];
    
    UITextField *hour_TF=[[UITextField alloc]initWithFrame:CGRectMake(30, 190, 40, 20)];
    hour_TF.backgroundColor=[UIColor clearColor];
    hour_TF.tag=HOURTF;
    hour_TF.delegate=self;
    hour_TF.keyboardType=UIKeyboardTypeNumberPad;
    hour_TF.text=[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"startTime1"];
    hour_TF.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:hour_TF];
    [hour_TF release];
    
    
    
    UITextField *min_TF=[[UITextField alloc]initWithFrame:CGRectMake(90, 190, 40, 20)];
    min_TF.backgroundColor=[UIColor clearColor];
    min_TF.tag=MINTF;
    min_TF.keyboardType=UIKeyboardTypeNumberPad;
    min_TF.delegate=self;
    min_TF.text=[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"startTime2"];
    min_TF.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:min_TF];
    [min_TF release];

    
    Sched_label=[[UILabel alloc]initWithFrame:CGRectMake(20, 265, 260, 32)];
    Sched_label.backgroundColor=[UIColor colorWithRed:0.9882 green:0.9882 blue:0.9882 alpha:1.0];
    [self.view addSubview:Sched_label];
    [Sched_label release];
    
    UIButton *Timer_water_schedule=[[UIButton alloc]initWithFrame:CGRectMake(30, 270, 260, 32)];
    [Timer_water_schedule setTitle:nil forState:UIControlStateNormal];
    [Timer_water_schedule addTarget:self action:@selector(clickScheduleButtton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Timer_water_schedule];
    [Timer_water_schedule release];
    
  
}
-(void)viewWillAppear:(BOOL)animated
{
    
    NSArray *Arr_ay =[[[NSArray alloc]initWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thur",@"Fri",@"Sat", nil]autorelease];
    NSArray *arr=[[[[NSUserDefaults standardUserDefaults]objectForKey:@"timerDic"]objectForKey:@"wateringSchedule"]componentsSeparatedByString:@","];
    [arr retain];
    NSString *str=nil;
    for (int i=0; i<[arr count]; i++)
    {
        if ([[arr objectAtIndex:i]isEqualToString:@"true"])
        {
            
            NSString *string_xingqi=[Arr_ay objectAtIndex:i];
            str =[NSString stringWithFormat:@"%@ %@",str,string_xingqi];
        }
    }
    
    Sched_label.text =[str stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"xuanzexingqitianshu"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [arr release];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField *fieldPRo=(UITextField *)[self.view viewWithTag:PROTF];
    UITextField *houField=(UITextField *)[self.view viewWithTag:HOURTF];
    UITextField *minField=(UITextField *)[self.view viewWithTag:MINTF];
    [fieldPRo resignFirstResponder];
    [houField resignFirstResponder];
    [minField resignFirstResponder];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (textField.tag)
    {
        case HOURTF:
        {
            NSString *theStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
            switch ([theStr length])
            {
                case 1:
                {
                        return YES;
                }
                    break;
                case 2:
                {
                    if ([string integerValue]<24)
                    {
                        return YES;
                    }
                }
                    break;
                default:
                    break;
            }
        
        }
            break;
        case MINTF:
        {
            {
                NSString *theStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
                switch ([theStr length])
                {
                    case 1:
                    {
                        return YES;
                    }
                        break;
                    case 2:
                    {
                        if ([string integerValue]<24)
                        {
                            return YES;
                        }
                    }
                        break;
                    default:
                        break;
                }
                
            }
        }
            break;
        default:
            break;
    }
    return NO;

}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case HOURTF:
            if ([textField.text intValue]>23)
            {
                textField.text=@"23";
                
            }

            break;
        case MINTF:
            if ([textField.text intValue]>59)
            {
                textField.text=@"59";
                
            }

            break;
        default:
            break;
    }
       return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
