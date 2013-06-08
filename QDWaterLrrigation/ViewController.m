//登陆界面


#import "ViewController.h"

@interface ViewController ()
{
    QDNetRequstData *loginRequstData;
}

@end

#define NAMETF 1
#define PASSWORDTF 2
#define ACTIVITY 3
@implementation ViewController

#pragma mark//进入管理员界面
-(void)gotoAdministratorVc
{
    QDAdministratorVC *Administrator_VC=[[QDAdministratorVC alloc]init];
    [self presentModalViewController:Administrator_VC animated:YES];
    [Administrator_VC release];
    [self StopActivityIndicatorView];
}
#pragma mark//开始旋转的风火轮
-(void)StartActivityIndicatorView
{
    QDActivityIndicatorView*activi=[[QDActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-20, 40, 40)];
    activi.tag=ACTIVITY;
    [self.view addSubview:activi];
    [activi release];

}
#pragma mark//停止旋转的风火轮
-(void)StopActivityIndicatorView
{
    QDActivityIndicatorView *act=(QDActivityIndicatorView*)[self.view viewWithTag:ACTIVITY];
    [act removeFromSuperview];
}
#pragma mark//用户名和密码验证
-(void)gotoNamePasswordVerification
{
    //[self.navigationController pushViewController:[[QDMainVC new]autorelease] animated:YES];
    UITextField *Name_Field=(UITextField *)[self.view viewWithTag:NAMETF];
    UITextField *Password_Field=(UITextField *)[self.view viewWithTag:PASSWORDTF];
    loginRequstData=[[QDNetRequstData alloc]init];
    loginRequstData.delegate=self;
    [loginRequstData loginrequstName:Name_Field.text Password:Password_Field.text];

}
#pragma mark//进入主界面
-(void)gotoMainVC
{
//    [self.navigationController pushViewController:[[QDMainVC new]autorelease] animated:YES];
//    return;
    UITextField *Name_Field=(UITextField *)[self.view viewWithTag:NAMETF];
    UITextField *Password_Field=(UITextField *)[self.view viewWithTag:PASSWORDTF];
    if (Name_Field.text==nil||[Name_Field.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Pleast Enter Name Or Password" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
        return;
    }
    if (Password_Field.text==nil||[Password_Field.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Pleast Enter Name Or Password" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
        return;
    }

    [self keyboarddisappear];
    [self StartActivityIndicatorView];
    [self performSelector:@selector(gotoNamePasswordVerification) withObject:nil afterDelay:0.01];
   

}
#pragma mark//服务器有返回数据时候的代理方法
-(void)returnData:(NSString *)string
{
    UITextField *Name_Field=(UITextField *)[self.view viewWithTag:NAMETF];
    UITextField *Password_Field=(UITextField *)[self.view viewWithTag:PASSWORDTF];
    [self keyboarddisappear];
    if (string==nil||[string isEqualToString:@""])
    {
        if ([Name_Field.text isEqualToString:@"admin"]&&[Password_Field.text isEqualToString:@"1234"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:Name_Field.text forKey:@"useName"];
            [[NSUserDefaults standardUserDefaults]setObject:Password_Field.text forKey:@"usepassword"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        [self performSelector:@selector(gotoAdministratorVc) withObject:nil afterDelay:0];

        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setObject:Name_Field.text forKey:@"useName"];
            [[NSUserDefaults standardUserDefaults]setObject:Password_Field.text forKey:@"usepassword"];
            [self.navigationController pushViewController:[[QDMainVC new]autorelease] animated:YES];
            [self StopActivityIndicatorView];
        }
        
        
        

    }
    else
    {
        [self StopActivityIndicatorView];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
       
    }
}
#pragma mark//服务器无相应的代理方法
-(void)servernotResponding:(NSString *)msgStr
{
    [self StopActivityIndicatorView];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:msgStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
    [alert release];
}
#pragma mark//进入注册界面
-(void)gotoRegisterView
{
    [self keyboarddisappear];
    QDRegisterVC *Register_VC=[[QDRegisterVC alloc]init];
    Register_VC.delegate=self;
    [self presentModalViewController:Register_VC animated:YES];
    [Register_VC release];
   
    
    
}
-(void)RegistegotoMainVC
{
    [self.navigationController pushViewController:[[QDMainVC new]autorelease] animated:YES];
   

}
#pragma mark //初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
//    UILocalNotification *notification=[[UILocalNotification alloc] init];
//    if (notification!=nil)
//    {
//        NSLog(@">> support local notification");
//        NSDate *now=[NSDate new];
//        notification.fireDate=[now addTimeInterval:10];
//        notification.timeZone=[NSTimeZone defaultTimeZone];
//        notification.alertBody=@"陈树人去吃屎！";
//        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
//    }
     [self.view setFrame:[[UIScreen mainScreen] bounds]];
    //背景图片
    UIImageView *black_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background.png"]];
    black_Image.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:black_Image];
    [black_Image release];
    //登陆标题背景
    UIImageView *Sign_Title_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navgationbar.png"]];
    Sign_Title_Image.frame=CGRectMake(0, 0, 320, 40);
    [self.view addSubview:Sign_Title_Image];
    [Sign_Title_Image release];
    //登陆标题
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(120, 0, 80, 40)];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor=[UIColor whiteColor];
    title_label.text=@"Sign In";
    title_label.font=[UIFont systemFontOfSize:25];
    [self.view addSubview:title_label];
    [title_label release];
    
    //注册按钮
    UIButton *Register_Button=[[UIButton alloc]initWithFrame:CGRectMake(20, 190, 130, 50)];
    [Register_Button setBackgroundImage:[UIImage imageNamed:@"btn_register.png"] forState:UIControlStateNormal];
    [Register_Button setTitle:@"Register" forState:UIControlStateNormal];
     Register_Button.showsTouchWhenHighlighted =YES;
    [Register_Button addTarget:self action:@selector(gotoRegisterView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Register_Button];
    [Register_Button release];
    
    //登陆按钮
    UIButton *Login_Button=[[UIButton alloc]initWithFrame:CGRectMake(160, 190, 130, 50)];
    [Login_Button setBackgroundImage:[UIImage imageNamed:@"btn_signin .png"] forState:UIControlStateNormal];
    [Login_Button setTitle:@"Sign in" forState:UIControlStateNormal];
     Login_Button.showsTouchWhenHighlighted =YES;
    [Login_Button addTarget:self action:@selector(gotoMainVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Login_Button];
    [Login_Button release];
    
    //用户名背景
    UIImageView *Name_Image_View=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"注册登录输入框.png"]];
    Name_Image_View.frame = CGRectMake(20, 60, 280, 55);
    [self.view addSubview:Name_Image_View];
    [Name_Image_View release];
    //输入用户名
    UITextField *Name_TF=[[UITextField alloc]initWithFrame:CGRectMake(40, 72, 260, 40)];
    Name_TF.tag=NAMETF;
    Name_TF.delegate=self;
    Name_TF.placeholder=@"Name";
    Name_TF.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"useName"];
    Name_TF.font=[UIFont systemFontOfSize:25];
    [self.view addSubview:Name_TF];
    [Name_TF release];
    
    //密码背景
    UIImageView *PassWord_Image_View=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"注册登录输入框.png"]];
    PassWord_Image_View.frame = CGRectMake(20, 120, 280, 55);
    [self.view addSubview:PassWord_Image_View];
    [PassWord_Image_View release];
    //输入密码
    UITextField *PassWord_TF=[[UITextField alloc]initWithFrame:CGRectMake(40, 132, 260, 40)];
    PassWord_TF.tag=PASSWORDTF;
    PassWord_TF.delegate=self;
    PassWord_TF.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"usepassword"];
    PassWord_TF.secureTextEntry=YES;
    PassWord_TF.placeholder=@"PassWord";
    PassWord_TF.font=[UIFont systemFontOfSize:25];
    [self.view addSubview:PassWord_TF];
    [PassWord_TF release];


    
}
#pragma mark //键盘消失
-(void)keyboarddisappear
{
    UITextField *NameTF=(UITextField *)[self.view viewWithTag:NAMETF];
    UITextField *Pass_word=(UITextField *)[self.view viewWithTag:PASSWORDTF];
    [NameTF resignFirstResponder];
    [Pass_word resignFirstResponder];
}

#pragma mark //touch事件
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self keyboarddisappear];
    
}
#pragma mark //UITextField的代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITextField *filedText1 = (UITextField*)[self.view viewWithTag:NAMETF];
    UITextField *filedText2 = (UITextField*)[self.view viewWithTag:PASSWORDTF];
    
    NSMutableArray *textFArr = [[NSMutableArray alloc] initWithObjects:filedText1, filedText2, nil];
    
    
    const char *replaceCStr = [string UTF8String];
    
    if(replaceCStr[0] == 10)
    {
        int i = 0;
        for(; i < [textFArr count]; i++)
        {
            if([textFArr objectAtIndex:i] == textField)
                break;
        }
        
        if(i == [textFArr count]-1)
            i = 0;
        else
            i++;
        
        UITextField *theNewTF = [textFArr objectAtIndex:i];
        [theNewTF becomeFirstResponder];
        
    }
    [textFArr release];
    return 1;
    
    
}

-(void)dealloc
{
    [loginRequstData release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
