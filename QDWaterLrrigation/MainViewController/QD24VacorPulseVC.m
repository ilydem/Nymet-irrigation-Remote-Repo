

#import "QD24VacorPulseVC.h"

@interface QD24VacorPulseVC ()
{
    UITableView *tab;
    NSArray *arr;
    QDNetRequstData *setting_Request;
}

@end

@implementation QD24VacorPulseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)clickBlackBT
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    setting_Request=[[QDNetRequstData alloc]init];
    //背景图片
    UIImageView *black_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background.png"]];
    black_Image.frame=self.view.bounds;
    [self.view addSubview:black_Image];
    [black_Image release];
    //Setting标题背景
    UIImageView *Timer_Title_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navgationbar.png"]];
    Timer_Title_Image.frame=CGRectMake(0, 0, 320, 40);
    [self.view addSubview:Timer_Title_Image];
    [Timer_Title_Image release];
    //Timer标题
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(90, 0, 200, 40)];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor=[UIColor whiteColor];
    title_label.text=@"Select Sensor";
    title_label.font=[UIFont systemFontOfSize:25];
    [self.view addSubview:title_label];
    [title_label release];
    
    //Save按钮
    
    UIButton *SaveButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 60, 32)];
    [SaveButton setBackgroundImage:[UIImage imageNamed:@"btn_signin .png"] forState:UIControlStateNormal];
    [SaveButton setTitle:@"Back" forState:UIControlStateNormal];
    SaveButton.showsTouchWhenHighlighted =YES;
    [SaveButton addTarget:self action:@selector(clickBlackBT) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SaveButton];
    [SaveButton release];
    
    
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, 320, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    [tab setDataSource:self];
    [tab setDelegate: self];
    tab.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tab];
    [tab release];
    
    arr =[[NSArray  alloc]initWithObjects:@"Latch",@"24Vac", nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"trun_flast"]isEqualToString:@"true"])
    {
    
    }
    else
    {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
        
        for (UITableViewCell *cell in tableView.visibleCells)
        {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        [[tableView.visibleCells objectAtIndex:[indexPath row]] setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        [setting_Request requestsetting24VacPulse:[NSString stringWithFormat:@"%i",[indexPath row]]];
        if ([indexPath row]==0)
        {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"vacorpulseDClatching"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"vacorpulseDClatching"];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Latch/24Vac" object:nil];

    }
    
    
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr count];
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
        
        if (cell.tag==0)
          {
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"vacorpulseDClatching"])
             {
              cell.accessoryType=UITableViewCellAccessoryNone;
             }
              else
              {
              cell.accessoryType=UITableViewCellAccessoryCheckmark;
              }
              
        }
        else
        {
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"vacorpulseDClatching"])
            {
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
 
        }
    }
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"trun_flast"]isEqualToString:@"true"])
    {
        cell.textLabel.textColor=[UIColor grayColor];
    }
    else
    {
        cell.textLabel.textColor=[UIColor blackColor];
    }
    return cell;
    
}
-(void)dealloc
{
    [setting_Request release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
