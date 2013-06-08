//注册界面
#import "QDRegisterVC.h"
#define NAME 1
#define PASSWORD 2
#define REPWARPASSWORD 3
#define LICENSENUMBER 4

#define REGISTERINFOBT 5
#define ARCHVIEW 6
@interface QDRegisterVC ()
{
    UIScrollView *ScrollView;
    UIButton *Register_Info_Bt;
}

@end

@implementation QDRegisterVC
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}
#pragma mark //返回登陆界面按钮方法
-(void)ReturnLoginVIew 
{
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark //键盘消失
-(void)keyboarddisappearRegisterVC
{
    [self scrstopAm];
    UITextField *NameTF=(UITextField *)[self.view viewWithTag:NAME];
    UITextField *Pass_word=(UITextField *)[self.view viewWithTag:PASSWORD];
    UITextField *Rwpeat_word=(UITextField *)[self.view viewWithTag:REPWARPASSWORD];
    UITextField *License_Number=(UITextField *)[self.view viewWithTag:LICENSENUMBER];
    [NameTF resignFirstResponder];
    [Pass_word resignFirstResponder];
    [Rwpeat_word resignFirstResponder];
    [License_Number resignFirstResponder];

}

#pragma mark //点击手势
-(void)tapView
{
    [self keyboarddisappearRegisterVC];
}
#pragma mark//开始旋转的风火轮
-(void)StartActivityIndicatorView
{
    QDActivityIndicatorView*activi=[[QDActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-20, 40, 40)];
    activi.tag=ARCHVIEW;
    [self.view addSubview:activi];
    [activi release];
    
}
#pragma mark//停止旋转的风火轮
-(void)StopActivityIndicatorView
{
    QDActivityIndicatorView *act=(QDActivityIndicatorView*)[self.view viewWithTag:ARCHVIEW];
    [act removeFromSuperview];
}
#pragma mark //提交注册数据
-(void)submitregistrationdata
{
    UITextField *Name_Field=(UITextField*)[self.view viewWithTag:NAME];
    UITextField *Pssword_Field=(UITextField*)[self.view viewWithTag:PASSWORD];
    UITextField *Repeat_Field=(UITextField*)[self.view viewWithTag:REPWARPASSWORD];
    UITextField *License_Field=(UITextField*)[self.view viewWithTag:LICENSENUMBER];
    QDNetRequstData *registertData=[[QDNetRequstData alloc]init];
    registertData.delegate=self;
    [registertData registrationInterfaceName:Name_Field.text Password:Pssword_Field.text RepeatPassword:Repeat_Field.text LicenseNumber:License_Field.text];
}
#pragma mark //提交注册信息按钮方法
-(void)clickRegisterInfoBt
{
    UITextField *Name_Field=(UITextField*)[self.view viewWithTag:NAME];
    UITextField *Pssword_Field=(UITextField*)[self.view viewWithTag:PASSWORD];
    UITextField *Repeat_Field=(UITextField*)[self.view viewWithTag:REPWARPASSWORD];
    UITextField *License_Field=(UITextField*)[self.view viewWithTag:LICENSENUMBER];
    if (Name_Field.text==nil||[Name_Field.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please Enter Name " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
        return;
    }

    if (Pssword_Field.text==nil||[Pssword_Field.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please Enter Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
        return;
    }

    if (Repeat_Field.text==nil||[Repeat_Field.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please Enter Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
        return;
    }

    if (License_Field.text==nil||[License_Field.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please Enter License Number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
        return;
    }
    if (![Pssword_Field.text isEqualToString:Repeat_Field.text])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Twice Password Different" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
        return;

    }

    [self StartActivityIndicatorView];
    [self performSelector:@selector(submitregistrationdata) withObject:nil afterDelay:0.01];
}
-(void)returnData:(NSString *)string
{
    
    if (string==nil||[string isEqualToString:@""])
    {
        [self StopActivityIndicatorView];
        [delegate RegistegotoMainVC];
        [self dismissModalViewControllerAnimated:NO];
//        [self dismissViewControllerAnimated:NO completion:nil];
        
    }
    else
    {
        [self StopActivityIndicatorView];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
    }
    
    
}
-(void)servernotResponding:(NSString *)msgStr
{
    [self StopActivityIndicatorView];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:msgStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
    [alert release];
}
#pragma mark //初始化方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //注册底图的scrollView
    ScrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    ScrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:ScrollView];
    //点击手势
    UITapGestureRecognizer *tapViewRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [ScrollView addGestureRecognizer:tapViewRecognizer];
    [tapViewRecognizer release];

    
    //注册标题背景
    UIImageView *Register_Title_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navgationbar.png"]];
    Register_Title_Image.frame=CGRectMake(0, 0, 320, 40);
    [self.view addSubview:Register_Title_Image];
    [Register_Title_Image release];
    //注册标题
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(110, 0, 100, 40)];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor=[UIColor whiteColor];
    title_label.text=@"Register";
    title_label.font=[UIFont systemFontOfSize:25];
    [self.view addSubview:title_label];
    
    //返回按钮
    UIButton *Register_Return=[[UIButton alloc]initWithFrame:CGRectMake(240, 0, 72, 37)];
    [Register_Return setBackgroundImage:[UIImage imageNamed:@"res_cancel.png"] forState:UIControlStateNormal];
    [Register_Return setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Register_Return.showsTouchWhenHighlighted =YES;
    [Register_Return setTitle:@"Cancel" forState:UIControlStateNormal];
    [Register_Return addTarget:self action:@selector(ReturnLoginVIew) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Register_Return];
    [Register_Return release];
    
    //背景图片
    UIImageView *black_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background.png"]];
    black_Image.frame=ScrollView.bounds;
    [ScrollView addSubview:black_Image];
    
    for (int i=0; i<4; i++)
    {
        //TextField背景
        UIImageView *Name_Image_View=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"注册登录输入框.png"]];
        Name_Image_View.frame = CGRectMake(20, 60+70*i, 280, 55);
        [ScrollView addSubview:Name_Image_View];
        [Name_Image_View release];
        //TextField
        UITextField *Name_TF=[[UITextField alloc]initWithFrame:CGRectMake(40, 72+70*i, 260, 40)];
        Name_TF.delegate=self;
        Name_TF.tag=i+1;
        switch (i+1)
        {
            case NAME:
            Name_TF.placeholder=@"Name";
                break;
            case PASSWORD:
            Name_TF.placeholder=@"Password";
            Name_TF.secureTextEntry=YES;
                break;
            case REPWARPASSWORD:
            Name_TF.placeholder=@"Repeat Password";
            Name_TF.secureTextEntry=YES;
                break;
            case LICENSENUMBER:
            Name_TF.placeholder=@"License Number";
                break;

                
            default:
                break;
        }
        Name_TF.font=[UIFont systemFontOfSize:25];
        [ScrollView addSubview:Name_TF];
        [Name_TF release];
 
    }
    
    //提交注册信息按钮
    Register_Info_Bt=[[UIButton alloc]initWithFrame:CGRectMake(80, 340, 130, 50)];
    Register_Info_Bt.tag=REGISTERINFOBT;
    [Register_Info_Bt setBackgroundImage:[UIImage imageNamed:@"btn_register.png"] forState:UIControlStateNormal];
    [Register_Info_Bt setTitle:@"Sign up" forState:UIControlStateNormal];
    Register_Info_Bt.showsTouchWhenHighlighted =YES;
    [Register_Info_Bt addTarget:self action:@selector(clickRegisterInfoBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Register_Info_Bt];
    

}
#pragma mark //Scro开始动画
-(void)scrostartAm
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    ScrollView.frame=CGRectMake(0, -150,320, 586);
    Register_Info_Bt.frame=CGRectMake(80, 190, 130, 50);
    [UIView commitAnimations];

}
#pragma mark //scro结束动画
-(void)scrstopAm
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    ScrollView.frame=self.view.bounds;
    Register_Info_Bt.frame=CGRectMake(80, 340, 130, 50);
    [UIView commitAnimations];
}

#pragma mark//UITextField的代理
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==3||textField.tag==4)
    {
       
        [self scrostartAm];
    
    }
    else
    {
        [self scrstopAm];
    }
}
#pragma mark//UITextField的代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITextField *filedText1 = (UITextField*)[self.view viewWithTag:1];
    UITextField *filedText2 = (UITextField*)[self.view viewWithTag:2];
    
    UITextField *filedText3 = (UITextField*)[self.view viewWithTag:3];
    UITextField *filedText4 = (UITextField*)[self.view viewWithTag:4];
    NSMutableArray *textFArr = [[NSMutableArray alloc] initWithObjects:filedText1, filedText2, filedText3,filedText4, nil];
    
    
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
    [Register_Info_Bt release];
    [ScrollView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
