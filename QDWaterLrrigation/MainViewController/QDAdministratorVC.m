

#import "QDAdministratorVC.h"
#define ACTIVE  1
@interface QDAdministratorVC ()
{
   
    UITableView *tab;
    NSArray *Arr;
    UIView *TextView;
   
}

@end

@implementation QDAdministratorVC

#pragma mark//返回登陆界面的方法
-(void)AdministratorVC_ReturnLoginVIew
{
    [self dismissModalViewControllerAnimated:YES];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}
#pragma mark //保存文件
-(NSString *)dataFilePath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"Admin_Number"];
    return filePath;
}

#pragma mark//开始旋转的风火轮
-(void)StartActivityIndicatorView
{
    QDActivityIndicatorView*activi=[[QDActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-20, 40, 40)];
    activi.tag=ACTIVE;
    [self.view addSubview:activi];
    [activi release];
    
}
#pragma mark//停止旋转的风火轮
-(void)StopActivityIndicatorView
{
    UIActivityIndicatorView *act=(UIActivityIndicatorView*)[self.view viewWithTag:ACTIVE];
    [act removeFromSuperview];
}

#pragma mark//建UItableview
-(void)establishTableView
{
    //出现风火轮
    [self StartActivityIndicatorView];
    QDNetRequstData *adminData=[[QDNetRequstData alloc]init];
    adminData.delegate=self;
    [adminData requstadminViewData];
    
    
}
-(void)returnData:(NSString *)string
{
    [[NSFileManager defaultManager] removeItemAtPath:[self dataFilePath] error:nil];
   // Arr =[[[NSArray alloc]init]retain];
    NSError *error;
    //NSString *astring=@"{\"id\":1,\"age\":\"2\"}";
    NSData *data=[string dataUsingEncoding:NSUTF8StringEncoding];
    Arr=[NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableContainers error:&error];
    //写文件
    [Arr writeToFile:[self dataFilePath] atomically:YES];
    tab =[[UITableView alloc]initWithFrame:CGRectMake(0, 80, 320, self.view.frame.size.height-140) style:UITableViewStylePlain];
    tab.delegate=self;
    tab.dataSource=self;
    [tab setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tab];
    
    UILabel *sun_Laber=[[UILabel alloc]initWithFrame:CGRectMake(260, 0, 40, 20)];
    sun_Laber.backgroundColor=[UIColor clearColor];
    sun_Laber.textColor=[UIColor whiteColor];
    sun_Laber.textAlignment=NSTextAlignmentCenter;
    sun_Laber.text =@"Sum";
    [self.view addSubview:sun_Laber];
    [sun_Laber release];
    
    UILabel *number_Laber=[[UILabel alloc]initWithFrame:CGRectMake(260, 20, 40, 20)];
    number_Laber.backgroundColor=[UIColor clearColor];
    number_Laber.textColor=[UIColor whiteColor];
    number_Laber.textAlignment=NSTextAlignmentCenter;
    if ([Arr count]!=0)
    {
     number_Laber.text =[NSString stringWithFormat:@"%d",[Arr count]];   
    }
    [self.view addSubview:number_Laber];
    [number_Laber release];
    int sum=0;
    for (int i=0; i<[Arr count]; i++)
    {
        if ([[[Arr objectAtIndex:i] objectForKey:@"state"]isEqualToString:@"Connecting to"])
        {
            sum =sum+1;
        }
    }
    //最下面的图标
    UIImageView *image_View=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabar.png"]];
    image_View.frame=CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60);
    [self.view addSubview:image_View];
    [image_View release];
    
    QDZoomImVIew *connetImage=[[QDZoomImVIew alloc]initWithFrame:CGRectMake(60, 10, 30, 20) blackImage:[UIImage imageNamed:@"greenbutton.png"] Titlelaber:[NSString stringWithFormat:@"%d",sum]];
    [image_View addSubview:connetImage];
    [connetImage release];
    
    UILabel *connetLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 30, 100, 20)];
    connetLabel.text=@"Connected";
    connetLabel.backgroundColor=[UIColor clearColor];
    [image_View addSubview:connetLabel];
    [connetLabel release];
    
    QDZoomImVIew *NotconnetImage=[[QDZoomImVIew alloc]initWithFrame:CGRectMake(230, 10, 30, 20) blackImage:[UIImage imageNamed:@"redbutton.png"] Titlelaber:[NSString stringWithFormat:@"%d",[Arr count]-sum]];
    [image_View addSubview:NotconnetImage];
    [NotconnetImage release];
    
    UILabel *NoconnetLabel=[[UILabel alloc]initWithFrame:CGRectMake(180, 30, 120, 20)];
    NoconnetLabel.text=@"Not Connected";
    NoconnetLabel.backgroundColor=[UIColor clearColor];
    [image_View addSubview:NoconnetLabel];
    [NoconnetLabel release];
    //干掉风火轮
    [self StopActivityIndicatorView];
}
-(void)servernotResponding:(NSString *)msgStr
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:msgStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
    [alert release];

}
#pragma mark//初始化方法
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //背景图片
    UIImageView *Admin_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background.png"]];
    Admin_Image.frame=self.view.bounds;
    [self.view addSubview:Admin_Image];
    [Admin_Image release];
    //登陆标题背景
    UIImageView *Admin_Title_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navgationbar.png"]];
    Admin_Title_Image.frame=CGRectMake(0, 0, 320, 40);
    [self.view addSubview:Admin_Title_Image];
    [Admin_Title_Image release];
    //登陆标题
    UILabel *admin_label=[[UILabel alloc]initWithFrame:CGRectMake(110, 0, 100, 40)];
    admin_label.backgroundColor=[UIColor clearColor];
    admin_label.textColor=[UIColor whiteColor];
    admin_label.text=@"All State";
    admin_label.font=[UIFont systemFontOfSize:25];
    [self.view addSubview:admin_label];
    [admin_label release];
    
    //返回按钮
    UIButton *Administrator_Return=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 64, 34)];
    [Administrator_Return setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [Administrator_Return setTitle:@"Back" forState:UIControlStateNormal];
    Administrator_Return.showsTouchWhenHighlighted =YES;
    [Administrator_Return addTarget:self action:@selector(AdministratorVC_ReturnLoginVIew) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Administrator_Return];
    [Administrator_Return release];
    
    //搜索匡背景
    UIImageView *secrch_ImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbar.png"]];
    secrch_ImageView.frame = CGRectMake(0, 40, 320, 40);
    [self.view addSubview:secrch_ImageView];
    [secrch_ImageView release];
    
    //搜索的TextField
    UITextField *secrch_field=[[UITextField alloc]initWithFrame:CGRectMake(35, 50, 270, 20)];
    secrch_field.backgroundColor=[UIColor clearColor];
    secrch_field.tag=10;
    secrch_field.delegate=self;
    secrch_field.placeholder=@"Lisense Number";
    [self.view addSubview:secrch_field];
    [secrch_field release];
    //最下面显示的是否连接的标志
    //tabview的方法
    [self performSelector:@selector(establishTableView) withObject:nil afterDelay:0];
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Arr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40.0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *cellIdentifier = [NSString stringWithFormat:@"%@%i",@"cell",[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    for (UIView *view in cell.subviews)
    {
        [view removeFromSuperview];
    }
     NSArray *array_number = [[[NSArray alloc]initWithContentsOfFile:[self dataFilePath]]autorelease];
    
    //cell的背景
    UIImage *cellBgImage = [UIImage imageNamed:@"allstatebar.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [imageView setImage:cellBgImage];
    [cell addSubview:imageView];
    [imageView release];
    
     //设备状态
    UIImage *titimage;
    if ([[[array_number objectAtIndex:[indexPath row]] objectForKey:@"state"]isEqualToString:@"Connecting to"])
    {
        titimage=[UIImage imageNamed:@"greenbutton.png"];
    }
    else
    {
        titimage=[UIImage imageNamed:@"redbutton.png"];
    }
    
    QDZoomImVIew *titleImage=[[QDZoomImVIew alloc]initWithFrame:CGRectMake(10, 10, 30, 20) blackImage:titimage Titlelaber:[NSString stringWithFormat:@"%d",[indexPath row]+1]];
    [cell addSubview:titleImage];
    [titleImage release];
    
    //显示的设备号
    UILabel *laber_number=[[UILabel alloc]initWithFrame:CGRectMake(50, 5, 270, 30)];
    laber_number.backgroundColor=[UIColor clearColor];
    laber_number.font=[UIFont systemFontOfSize:16];
    if ([[array_number objectAtIndex:[indexPath row]] objectForKey:@"licenseNumber"]==nil||[[[array_number objectAtIndex:[indexPath row]] objectForKey:@"licenseNumber"] isEqualToString:@""])
    {
        laber_number.text=@"";
    }
    else
    {
        laber_number.text=[[array_number objectAtIndex:[indexPath row]] objectForKey:@"licenseNumber"];
    }
    [cell addSubview:laber_number];
    [laber_number release];
    

    
    
    
    return cell;
}
-(void)clickTextView
{
    
    if (TextView)
    {
        [TextView removeFromSuperview];
    }
    UITextField *field=(UITextField *)[self.view viewWithTag:10];
    [field resignFirstResponder];

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    TextView  =[[UIView alloc] initWithFrame:CGRectMake(0, 80, 320, 280)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTextView)];
    [TextView setUserInteractionEnabled:YES];
    [TextView addGestureRecognizer:tap];
    [tap release];
    [self.view addSubview:TextView];
    //[textField release];
    if ([textField.text isEqualToString:@""])
    {
        Arr = [[[NSArray alloc]initWithContentsOfFile:[self dataFilePath]]autorelease];
        [tab reloadData];
    }
    return YES;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *theStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
//    switch ([theStr length])
//    {
//        case 1:
//        {
//            return YES;
//        }
//            break;
//        default:
//            break;
//    }
//    return NO;
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (TextView)
    {
        [TextView removeFromSuperview];
    }
    NSMutableArray *mutabArray=[[NSMutableArray alloc]init];
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:[self dataFilePath]];
    if ([textField.text isEqualToString:@""]||textField.text==nil)
    {
        Arr = array;
    }
    else
    {
        for (int i=0; i<[array count]; i++)
        {
            
            if ([textField.text isEqualToString:[[array objectAtIndex:i]objectForKey:@"licenseNumber"]])
            {
                [mutabArray addObject:[array objectAtIndex:i]];
            }
        }
        Arr =mutabArray;

    }
    [Arr writeToFile:[self dataFilePath] atomically:YES];
    [tab reloadData];
    [mutabArray release];
    [array release];
    return YES;
}

-(void)dealloc
{
    //[tab release];
    //[Arr release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
