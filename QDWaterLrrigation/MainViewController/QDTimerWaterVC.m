
#import "QDTimerWaterVC.h"

@interface QDTimerWaterVC ()
{
    UITableView *tab;
    NSArray *arr;
    NSArray *mutarr;
}

@end

@implementation QDTimerWaterVC

-(void)clickBlackButtonwatering
{
    NSMutableDictionary *mub_dic=[[[NSMutableDictionary alloc]init]autorelease];
    NSMutableArray *week_Arr=[[[NSMutableArray alloc]init]autorelease];    
    for (UITableViewCell *cell in tab.visibleCells)
    {
        if (cell.accessoryType==UITableViewCellAccessoryCheckmark)
            {
                [week_Arr addObject:@"true"];
            }
            else
            {
                [week_Arr addObject:@"flse"];
            }
    }
    NSString *str=nil;
    for (int i=0; i<[week_Arr count]; i++)
    {
                    
            NSString *string_xingqi=[week_Arr objectAtIndex:i];
        
            str =[NSString stringWithFormat:@"%@,%@",str,string_xingqi];

    }

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"timerDic"] objectForKey:@"ProgramName"]==nil||[[[[NSUserDefaults standardUserDefaults] objectForKey:@"timerDic"] objectForKey:@"ProgramName"] isEqualToString:@""])
    {
        
    }
    else
    {
       [mub_dic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"timerDic"] objectForKey:@"ProgramName"] forKey:@"ProgramName"]; 
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"timerDic"] objectForKey:@"startTime1"]!=nil||(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"timerDic"] objectForKey:@"startTime1"] isEqualToString:@""]))
    {
      [mub_dic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"timerDic"] objectForKey:@"startTime1"] forKey:@"startTime1"];  
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"timerDic"] objectForKey:@"startTime2"]!=nil||(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"timerDic"] objectForKey:@"startTime2"] isEqualToString:@""]))
    {
        [mub_dic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"timerDic"] objectForKey:@"startTime2"] forKey:@"startTime2"];
    }
    if ([str stringByReplacingOccurrencesOfString:@"(null)," withString:@""]==nil||[[str stringByReplacingOccurrencesOfString:@"(null)," withString:@""] isEqualToString:@""])
    {
        
    }
    else
    {
        [mub_dic setObject:[str stringByReplacingOccurrencesOfString:@"(null)," withString:@""] forKey:@"wateringSchedule"];
 
    }
    [[NSUserDefaults standardUserDefaults]setObject:mub_dic forKey:@"timerDic"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(120, 0, 110, 40)];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor=[UIColor whiteColor];
    title_label.text=@"Watering";
    title_label.font=[UIFont systemFontOfSize:25];
    [self.view addSubview:title_label];
    [title_label release];
    
    
    //返回按钮
    
    UIButton *StartButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 60, 32)];
    [StartButton setBackgroundImage:[UIImage imageNamed:@"btn_signin .png"] forState:UIControlStateNormal];
    [StartButton setTitle:@"Save" forState:UIControlStateNormal];
    StartButton.showsTouchWhenHighlighted =YES;
    [StartButton addTarget:self action:@selector(clickBlackButtonwatering) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:StartButton];
    [StartButton release];
    
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, 320, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    [tab setDataSource:self];
    [tab setDelegate: self];
    tab.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tab];
    [tab release];
    
    arr =[[NSArray alloc]initWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];
    
    mutarr =[[NSArray alloc]initWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thur",@"Fri",@"Sat", nil];
    
    
    


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    
    for (UITableViewCell *cell in tableView.visibleCells)
    {
        if (cell.tag==[indexPath row])
        {
            if (cell.accessoryType==UITableViewCellAccessoryCheckmark)
            {
                cell.accessoryType=UITableViewCellAccessoryNone;
                
                
            }
            else
            {
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
               
            }
           
        }
    }

    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%i",indexPath.row];
    
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        
        cell =[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
        cell.tag=[indexPath row];
        cell.textLabel.text =[arr objectAtIndex:[indexPath row]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        NSMutableArray *muta_Arr= [[NSUserDefaults standardUserDefaults] objectForKey:@"xuanzexingqitianshu"];
        [muta_Arr retain];
        if ([[muta_Arr objectAtIndex:[indexPath row]] isEqualToString:@"true"])
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        [muta_Arr release];
        
    }
    return cell;

}
-(void)dealloc
{
    [arr release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
