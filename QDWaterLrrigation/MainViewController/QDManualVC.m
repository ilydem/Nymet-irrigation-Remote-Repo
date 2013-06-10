

#import "QDManualVC.h"
#define MANUALSTART 118
#define MANUALSTOP 2
#define STARTBT 3

@interface QDManualVC ()
{
    NSMutableArray *Manual_Arr;
    NSMutableArray *Manual_Data_Image;
    QDManualView *QDmanual;
    QDNetRequstData *summaryRequst;
    BOOL startStop ;
    NSString *stop_start;
    UIView *backview;
    NSMutableArray *Manual_pragramId;
    NSString *prostart;
}

@end

@implementation QDManualVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark//开始旋转的风火轮
-(void)StartActivityIndicatorView
{
    backview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [self.view addSubview:backview];

    QDActivityIndicatorView*activi=[[QDActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-20, 40, 40)];
    activi.tag=MANUALSTART;
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
    QDActivityIndicatorView *act=(QDActivityIndicatorView*)[self.view viewWithTag:MANUALSTART];
    if (act)
    {
        [act removeFromSuperview];
    }
}

-(void)clickManualStartButton
{
    
    NSMutableDictionary *manual_start_stop_dic=[NSMutableDictionary dictionary];
    UIButton *bt=(UIButton *)[self.view viewWithTag:STARTBT];
    if ( [bt.currentTitle isEqualToString:@"Start"])
    {
        startStop=YES;
        prostart=@"2";
        [bt setTitle:@"Stop" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"start_stop"];
    }
    else
    {
        if ([bt.currentTitle isEqualToString:@"Run"])
        {
            [bt setTitle:@"Stop" forState:UIControlStateNormal];
            prostart=@"1";

        }
        else
        {
            startStop=NO;
            prostart=@"0";
            [bt setTitle:@"Start" forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"start_stop"];
        }

    }

    [manual_start_stop_dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"programIdManual"] forKey:@"programId"];
    [manual_start_stop_dic setObject:prostart forKey:@"programIsStart"];
    [summaryRequst manualstartSop:manual_start_stop_dic];
    
}
//加载table表
-(void)ManualloadmanualViewdata
{
    
    if (QDmanual)
    {
        
        QDmanual.ManualVCdic=Manual_Arr;
        QDmanual.mutable_id_manual=Manual_pragramId;
        QDmanual.manual_auto=YES;
        QDmanual.Data_Image_view_cell=Manual_Data_Image;
        [QDmanual.tab reloadData];
    }
    else
    {
        QDmanual=[[QDManualView alloc]initWithFrame:CGRectMake(0, 88, 320, self.view.frame.size.height-88)];
        QDmanual.mutable_id_manual=Manual_pragramId;
        QDmanual.ManualVCdic=Manual_Arr;
        QDmanual.manual_auto=YES;
        QDmanual.delegate=self;
        QDmanual.Data_Image_view_cell=Manual_Data_Image;
        [self.view addSubview:QDmanual];
        [QDmanual release];

    }
    
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

//开线程下载图片
-(void)ManualVCdownloadimage
{
    if ([Manual_Data_Image count]!=0)
    {
        [Manual_Data_Image removeAllObjects];
    }
    if ([Manual_Arr count]!=0)
    {
        for (int i=0; i<[Manual_Arr count]; i++)
        {
            
            NSData *ImageData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[[Manual_Arr objectAtIndex:i]objectForKey:@"zone"]]];
            
            if (ImageData)
            {
                NSMutableDictionary *Manual_image_dic=[[NSMutableDictionary alloc]init];
                [Manual_image_dic setObject:[[Manual_Arr objectAtIndex:i] objectForKey:@"number"] forKey:@"numberImage"];
                [Manual_image_dic setObject:ImageData forKey:@"summary_Image_data"];
                [Manual_image_dic setObject:[[Manual_Arr objectAtIndex:i]objectForKey:@"zone"] forKey:@"image_Name"];
                [Manual_Data_Image addObject:Manual_image_dic];
                [Manual_image_dic release];
            }
            [ImageData release];
            
        }
    }
    
    
            

//        }
//        
//         
//    }
//    [Manual_Data_Image writeToFile:[self dataFilePath] atomically:YES];
    
    [self performSelectorOnMainThread:@selector(ManualloadmanualViewdata) withObject:self waitUntilDone:YES];
    
    
}
-(void)gotoManualview
{
    if (self.tabBarController.selectedIndex ==1)
    {
    summaryRequst=[[QDNetRequstData alloc]init];
    summaryRequst.delegate=self;
    [summaryRequst requstManualData];
    }

}

-(void)autoLoginRetun:(NSString *)string
{
    [self StartActivityIndicatorView];
    [self gotoManualview];
}

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
        //UIButton *bt=(UIButton *)[self.view viewWithTag:STARTBT];
        
        //NSString *astring=@"{\"id\":1,\"age\":\"2\"}";
        NSArray *data_Arr =[string componentsSeparatedByString:@"#"];
        NSError *error;
        if ([[data_Arr objectAtIndex:0]isEqualToString:@"run"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"start_stop"];
        }
        else
        {
            if ([[data_Arr objectAtIndex:0]isEqualToString:@"stop"])
            {
                [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"start_stop"];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"start_stop"];
            }
            
        }
        stop_start =[data_Arr objectAtIndex:0];
        
        Manual_Arr=[NSJSONSerialization JSONObjectWithData: [[data_Arr objectAtIndex:2] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        [Manual_Arr retain];
        
        if (stop_start !=nil)
        {
            //[bt setTitle:stop_start forState:UIControlStateNormal];
            if ([stop_start isEqualToString:@"Stop"])
            {
                [cancel_BT_manual setImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateNormal];
                [start_BT_manual setImage:[UIImage imageNamed:@"btn_startactive.png"] forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"start_stop"];
            }
            else
            {
                [cancel_BT_manual setImage:[UIImage imageNamed:@"btn_stopactive.png"] forState:UIControlStateNormal];
                [start_BT_manual setImage:[UIImage imageNamed:@"btn_start.png"] forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"start_stop"];
            }
        }
        else
        {
            //[bt setTitle:@"" forState:UIControlStateNormal];
        }
        
        if (![[data_Arr objectAtIndex:3] isEqualToString:@"Not connected"])
        {
            connet_Manual_IV.image=[UIImage imageNamed:@"connected.png"];
        }
        else
        {
            connet_Manual_IV.image=[UIImage imageNamed:@"notconnected.png"];
        }
        [[NSUserDefaults standardUserDefaults]setObject:[data_Arr objectAtIndex:4] forKey:@"programIdManual"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if ([Manual_pragramId count]!=0)
        {
            [Manual_pragramId removeAllObjects];
        }
        for (int i=0; i<10; i++)
        {
            [Manual_pragramId addObject:[data_Arr objectAtIndex:i+5]];
        }
        [[NSUserDefaults standardUserDefaults]setObject:data_Arr forKey:@"manual_timeID"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AutoORManual"];
        
        NSThread *ther=[[NSThread alloc]initWithTarget:self selector:@selector(ManualVCdownloadimage) object:nil];
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
-(void)returndatasuccess
{
    [self StopActivityIndicatorView];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"refreshYN"];
    [self StopActivityIndicatorView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ManualAutoBool"];
    [self StartActivityIndicatorView];
    [self performSelector:@selector(gotoManualview) withObject:nil afterDelay:0.01];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [self StopActivityIndicatorView];
}
-(void)clickManualCancelBT
{

    
    
    NSMutableDictionary *manual_start_dic =[[NSMutableDictionary alloc]init];
    [cancel_BT_manual setImage:[UIImage imageNamed:@"btn_stopactive.png"] forState:UIControlStateNormal];
    [start_BT_manual setImage:[UIImage imageNamed:@"btn_start.png"] forState:UIControlStateNormal];
    
    startStop=YES;
    prostart=@"2";
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"start_stop"];
    
    [manual_start_dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"programIdManual"] forKey:@"programId"];
    [manual_start_dic setObject:prostart forKey:@"programIsStart"];
    [summaryRequst manualstartSop:manual_start_dic];
    [manual_start_dic release];

    


    
}
-(void)clickManualStartBT
{
    NSMutableDictionary *manual_start_stop_dic =[[NSMutableDictionary alloc]init];
    
    [start_BT_manual setImage:[UIImage imageNamed:@"btn_startactive.png"] forState:UIControlStateNormal];
    [cancel_BT_manual setImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateNormal];

    
    startStop=NO;
    prostart=@"0";
    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"start_stop"];
    [manual_start_stop_dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"programIdManual"] forKey:@"programId"];
    [manual_start_stop_dic setObject:prostart forKey:@"programIsStart"];
    [summaryRequst manualstartSop:manual_start_stop_dic];
    [manual_start_stop_dic release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //注册通知
    NSNotificationCenter *noc = [NSNotificationCenter defaultCenter];
    [noc addObserver:self selector:@selector(gotoManualview) name:@"RefreshNow" object:nil];
    
//    Manual_Arr=[[NSMutableArray alloc]init];
    Manual_Data_Image=[[NSMutableArray alloc]init];
    Manual_pragramId=[[NSMutableArray alloc]init];
    
    //拍照的类
    camer=[[QDCamera alloc]init];
    camer.cameraDelegate=self;
    camer.isAnimated=YES;
    
    
    //背景图片
    UIImageView *black_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background.png"]];
    black_Image.frame=self.view.bounds;
    [self.view addSubview:black_Image];
    [black_Image release];
    //Manual标题背景
    UIImageView *Manual_Title_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navgationbar.png"]];
    Manual_Title_Image.frame=CGRectMake(0, 0, 320, 40);
    [self.view addSubview:Manual_Title_Image];
    [Manual_Title_Image release];
    //Manual标题
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(120, 0, 110, 40)];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor=[UIColor whiteColor];
    title_label.text=@"Manual";
    title_label.font=[UIFont systemFontOfSize:25];
    [self.view addSubview:title_label];
    [title_label release];
    
    UIImageView *image_View=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ID_manualbar@2x.png"]];
    image_View.frame=CGRectMake(0, 40, 320, 48);
    [self.view addSubview:image_View];
    [image_View release];
    
    
    connet_Manual_IV =[[UIImageView alloc]initWithFrame:CGRectMake(210, 6, 28, 28)];
    connet_Manual_IV.backgroundColor=[UIColor clearColor];
    [self.view addSubview:connet_Manual_IV];
    [connet_Manual_IV release];
    
    //Start按钮
    
//    UIButton *StartButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 60, 32)];
//    StartButton.tag=STARTBT;
//    [StartButton setBackgroundImage:[UIImage imageNamed:@"btn_register.png"] forState:UIControlStateNormal];
//    //[StartButton setTitle:@"Start" forState:UIControlStateNormal];
//    StartButton.showsTouchWhenHighlighted =YES;
//    [StartButton addTarget:self action:@selector(clickManualStartButton) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:StartButton];
//    [StartButton release];
    
    
    cancel_BT_manual=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 38, 31)];
    [cancel_BT_manual setImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateNormal];
    [cancel_BT_manual setImage:[UIImage imageNamed:@"btn_stopactive.png"] forState:UIControlStateHighlighted];
    [cancel_BT_manual addTarget:self action:@selector(clickManualCancelBT) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel_BT_manual];
    [cancel_BT_manual release];

    start_BT_manual=[[UIButton alloc]initWithFrame:CGRectMake(43, 5, 38, 31)];
    [start_BT_manual setImage:[UIImage imageNamed:@"btn_start.png"] forState:UIControlStateNormal];
    [start_BT_manual setImage:[UIImage imageNamed:@"btn_startactive.png"] forState:UIControlStateHighlighted];
    [start_BT_manual addTarget:self action:@selector(clickManualStartBT) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start_BT_manual ];
    [start_BT_manual release];
    
    
	
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
    [post_image_dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"programIdManual"] forKey:@"programId"];
    [post_image_dic setObject:[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"]intValue]+1] forKey:@"number"];
    [post_image_dic setObject:UIImageJPEGRepresentation(curimage,0) forKey:@"file1"];
    
    [summaryRequst autoupdateimagedata:post_image_dic];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"refreshYN"];
    if (came_Photo)
    {
        
        [[QDmanual.cellImageArray objectAtIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"]intValue]] setImage:curimage];
        
    }
    else
    {
//        [QDmanual.Data_Image_view_cell removeObjectAtIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"]intValue]];
        [QDmanual.Data_Image_view_cell insertObject:UIImagePNGRepresentation(curimage) atIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"cell_tag"]intValue]];
    }
}


- (void)viewDidUnload
{
   
}

-(void)dealloc
{
    //移除通知
    NSNotificationCenter *noc = [NSNotificationCenter defaultCenter];
    [noc removeObserver:self name:@"RefreshNow" object:nil];
    [Manual_Arr release];
    [Manual_Data_Image release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
