//
//  IDSelectSensorVC.m
//  QDWaterLrrigation
//
//  Created by Ilya Demin on 21/06/13.
//
//

#import "IDSelectSensorVC.h"
#import "QDNetRequstData.h"
#import "QDSelectSensorVC.h"

@interface IDSelectSensorVC ()
{
    UITableView *tab;
    QDNetRequstData *selectRequest;
}
@end

@implementation IDSelectSensorVC

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
    if (selection_index != -1) {
        QDCellFlowSenorView *view=(QDCellFlowSenorView *)[self.parentVC.view viewWithTag:self.viewrow+100];
        //view.layer.borderColor = [UIColor redColor].CGColor;
        //view.layer.borderWidth = 1;
        UILabel *bt=(UILabel *)[view viewWithTag:10];
        bt.text = [workPlaceArray objectAtIndex:selection_index];
        //bt.textColor = [UIColor redColor];
        [self selectTitleAlread:bt.text];
        
        NSMutableArray *Setup_arr =[[NSMutableArray alloc]init];
        [Setup_arr addObjectsFromArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"flowsensorsetup"]];
        [Setup_arr setObject:bt.text atIndexedSubscript:self.viewrow];
        [[NSUserDefaults standardUserDefaults]setObject:Setup_arr forKey:@"flowsensorsetup"];
    }
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
        
    workPlaceArray=[[NSArray arrayWithObjects:@"None",@"Sensor1", @"Sensor2",@"Sensor3",nil] retain];
    selectRequest=[[QDNetRequstData alloc]init];
    selectRequest.delegate=self;
    
    selection_index = -1;
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selection_index = [indexPath row];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
        
    for (UITableViewCell *cell in tableView.visibleCells)
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    [[tableView.visibleCells objectAtIndex:[indexPath row]] setAccessoryType:UITableViewCellAccessoryCheckmark];
    [self clickBlackBT];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [workPlaceArray count];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
        cell.tag = [indexPath row];
        cell.textLabel.text = [workPlaceArray objectAtIndex:[indexPath row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([[workPlaceArray objectAtIndex:[indexPath row]] isEqualToString:[[[NSUserDefaults standardUserDefaults]objectForKey:@"flowsensorsetup"]objectAtIndex:self.viewrow]])
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }
    return cell;
    
}
-(void)selectTitleAlread:(NSString *)bu
{
    NSString *selectValue=nil;
    NSMutableDictionary *select_dic=[NSMutableDictionary dictionary];
    /*QDCellFlowSenorView *view=(QDCellFlowSenorView *)[self.view viewWithTag:selfrow];
    UILabel *bt=(UILabel *)[view viewWithTag:10];
    bt.text =bu.titleLabel.text;*/
    
    if ([bu isEqualToString:@"None"])
    {
        selectValue=@"0";
    }
    else
    {
        if ([bu isEqualToString:@"Sensor1"])
        {
            selectValue=@"1";
        }
        else
        {
            if ([bu isEqualToString:@"Sensor2"])
            {
                selectValue=@"2";
            }
            else
            {
                if ([bu isEqualToString:@"Sensor3"])
                {
                    selectValue=@"3";
                }
                
            }
        }
    }
    [select_dic setObject:selectValue forKey:@"value"];
    [select_dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"select_sensor_set"]objectAtIndex:self.viewrow-93+100] forKey:@"fettleId"];
    [selectRequest requestselectSensor:select_dic];
}

-(void)dealloc
{
    [selectRequest release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
