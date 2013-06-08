//
//  QDSelectSensorVC.m
//  QDWaterLrrigation
//
//  Created by Mako on 12-11-9.
//
//

#import "QDSelectSensorVC.h"

@interface QDSelectSensorVC ()
{
    UITableView *tab;
    NSArray *arr;
    NSMutableArray *mutabArr;
    QDNetRequstData *selectRequest;
}

@end

@implementation QDSelectSensorVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//-(void)clickSettingVCSaveButton
//{
//    QDNetRequstData *selectRequest=[[QDNetRequstData alloc]init];
//    selectRequest.delegate=self;
//    [selectRequest selectsensor:mutabArr];
//    
//}
-(void)clickSettingVCBackButton
{
    [self returndatasuccess];
}
-(void)returndatasuccess
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)returnData:(NSString *)string
{
    
}
-(void)servernotResponding:(NSString *)msgStr
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    mutabArr =[[NSMutableArray alloc]init];
     workPlaceArray=[[NSArray arrayWithObjects:@"None",@"Sensor1", @"Sensor2",@"Sensor3",nil] retain];
    selectRequest=[[QDNetRequstData alloc]init];
    selectRequest.delegate=self;
    
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
    
    //back按钮
    
    UIButton *BackButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 60, 32)];
    [BackButton setBackgroundImage:[UIImage imageNamed:@"btn_signin .png"] forState:UIControlStateNormal];
    [BackButton setTitle:@"Back" forState:UIControlStateNormal];
    BackButton.showsTouchWhenHighlighted =YES;
    [BackButton addTarget:self action:@selector(clickSettingVCBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BackButton];
    [BackButton release];

    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, 320, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    [tab setDataSource:self];
    [tab setDelegate: self];
    tab.bounces=NO;
    tab.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tab];
    [tab release];
    
    arr =[[NSArray  alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  //  [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    
//    for (UITableViewCell *cell in tableView.visibleCells)
//    {
//        if (cell.tag==[indexPath row])
//        {
//            if (cell.accessoryType==UITableViewCellAccessoryCheckmark)
//            {
//                cell.accessoryType=UITableViewCellAccessoryNone;
//            }
//            else
//            {
//                cell.accessoryType=UITableViewCellAccessoryCheckmark;
//            }
//        }
//    }
    
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40.0;
    
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
        
        cell_flow=[[QDCellFlowSenorView alloc]initWithFrame:CGRectMake(120, 3, 180, 32)];

        cell_flow.label.text=[[[NSUserDefaults standardUserDefaults]objectForKey:@"flowsensorsetup"]objectAtIndex:[indexPath row]];
        cell_flow.delegate=self;
        cell_flow.tag=[indexPath row]+100;
        [cell addSubview:cell_flow];
        [mutabArr addObject:cell_flow];
        [cell_flow release];
        
        
    }
    return cell;
    
}
-(void)selectTitleAlread:(UIButton *)bu
{
    NSString *selectValue=nil;
    NSMutableDictionary *select_dic=[NSMutableDictionary dictionary];
    QDCellFlowSenorView *view=(QDCellFlowSenorView *)[self.view viewWithTag:selfrow];
    UILabel *bt=(UILabel *)[view viewWithTag:10];
    bt.text =bu.titleLabel.text;
    
    if ([bt.text isEqualToString:@"None"])
    {
        selectValue=@"0";
    }
    else
    {
        if ([bt.text isEqualToString:@"Sensor1"])
        {
            selectValue=@"1";
        }
        else
        {
            if ([bt.text isEqualToString:@"Sensor2"])
            {
                selectValue=@"2";
            }
            else
            {
                if ([bt.text isEqualToString:@"Sensor3"])
                {
                    selectValue=@"3";
                }

            }
        }
    }
    [select_dic setObject:selectValue forKey:@"value"];
    [select_dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"select_sensor_set"]objectAtIndex:selfrow-93] forKey:@"fettleId"];
    [selectRequest requestselectSensor:select_dic];
    UIView *vi=[self.view viewWithTag:200];
    [vi removeFromSuperview];
    
}

-(void)clickBTSelectSensor:(UIButton *)bu viewrow:(int)ro
{
    selfrow=ro;
    UIView *view=[self.view viewWithTag:200];
    if (view)
    {
        [view removeFromSuperview];
        return;
    }
    UIView *vi=[[UIView alloc] init];
    [vi setUserInteractionEnabled:YES];
    vi.tag=200;
    vi.backgroundColor=[UIColor colorWithRed:.6 green:.6 blue:.6 alpha:1];
    for (int i=0; i<[workPlaceArray count]; i++)
    {
        UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.frame=CGRectMake(0, i*32, 150, 32);
        [bt addTarget:self action:@selector(selectTitleAlread:) forControlEvents:UIControlEventTouchUpInside];
        bt.layer.borderWidth=.5;
        bt.layer.borderColor=[UIColor whiteColor].CGColor;
        [bt setTitle:[workPlaceArray objectAtIndex:i] forState:UIControlStateNormal];
        bt.tag=i+100;
        [vi addSubview:bt];
    }
    
    if (ro==108)
    {
        vi.frame=CGRectMake(120, 42+(ro-100)*30, 150, 32*[workPlaceArray count]);
    }
    else
    {
        if (ro==109)
        {
            vi.frame=CGRectMake(120, 52+(ro-100)*30, 150, 32*[workPlaceArray count]);
        }
        else
        {
            if (ro==107)
            {
                vi.frame=CGRectMake(120, (ro-100)*40-37, 150, 32*[workPlaceArray count]);
            }
            else
            {
              vi.frame=CGRectMake(120, 83+(ro-100)*40, 150, 32*[workPlaceArray count]);
            }
           
        }
        
    }
    [self.view addSubview:vi];
    [vi release];

}
-(void)dealloc
{
    [selectRequest release];
    [mutabArr release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
