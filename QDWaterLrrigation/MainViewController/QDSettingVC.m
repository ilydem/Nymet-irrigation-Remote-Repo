

#import "QDSettingVC.h"
#define ACTIVIVIEW 1
@interface QDSettingVC ()
{
    UITextField *Mist_Field;
    UITextField *Cycle_Field;
    UISwitch *Flow_Reset;
    UITextField *MasterField;
    UITextField *ZDTField;
    UITextField *flow_Field;
    UITextField *Rate_Field;
    UISwitch *Input2_Switch;
    UISwitch *Input3_Switch;
    UILabel *Latch_Label;
    UISwitch *Flow_Calibrate;
    QDNetRequstData *setrequest;
    NSMutableArray *dataArray;
    NSMutableArray *Mist_sec_arr;
    NSMutableArray *Master_Valve_Arr;
    NSMutableArray *Flow_Sensor_arr;
    int TF_tag;
}

@end

@implementation QDSettingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
      
    }
    return self;
}
-(void)servernotResponding:(NSString *)msgStr
{
    [self StopActivityIndicatorView];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:msgStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
    [alert release];
}
#pragma mark//开始旋转的风火轮
-(void)StartActivityIndicatorView
{
    QDActivityIndicatorView*activi=[[QDActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-20, 40, 40)];
    activi.tag=ACTIVIVIEW;
    [self.view addSubview:activi];
    [activi release];
    
}
#pragma mark//停止旋转的风火轮
-(void)StopActivityIndicatorView
{
    QDActivityIndicatorView *act=(QDActivityIndicatorView*)[self.view viewWithTag:ACTIVIVIEW];
    if (act)
    {
        [act removeFromSuperview];
    }
}
-(void)latech24VacText
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"vacorpulseDClatching"])
    {
        Latch_Label.text=@"24Vac";
    }
    else
    {
        Latch_Label.text=@"Latch";
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    //注册通知
    NSNotificationCenter *noc = [NSNotificationCenter defaultCenter];
    [noc addObserver:self selector:@selector(gotonetrequstdata) name:@"RefreshNow" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(latech24VacText) name:@"Latch/24Vac" object:nil];
    dataArray =[[NSMutableArray alloc]init];
    Mist_sec_arr =[[NSMutableArray alloc]init];
    Master_Valve_Arr =[[NSMutableArray alloc]init];
    Flow_Sensor_arr =[[NSMutableArray alloc]init];
    
    int sum=0;
    for (int i=0; i<99; i++)
    {
        sum=sum +1;
        [dataArray addObject:[NSString stringWithFormat:@"%i",sum]];
    }
    
    int mist=3;
    for (int i=0; i<237; i++)
    {
        mist=mist +1;
        [Mist_sec_arr addObject:[NSString stringWithFormat:@"%i",mist]];
    }
    
    int delayTime=24;
    for (int i=0; i<61; i++)
    {
        delayTime=delayTime +1;
        [Master_Valve_Arr addObject:[NSString stringWithFormat:@"%i",delayTime]];
    }
    
    int flow_Sensor=0;
    for (int i=0; i<450; i++)
    {
        flow_Sensor=flow_Sensor +1;
        [Flow_Sensor_arr addObject:[NSString stringWithFormat:@"%d",flow_Sensor]];
    }



    
    
    setrequest=[[QDNetRequstData alloc]init];
    setrequest.delegate=self;
    //背景图片
    UIImageView *black_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background.png"]];
    black_Image.frame=self.view.bounds;
    [self.view addSubview:black_Image];
    [black_Image release];
    
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, 320, self.view.frame.size.height-89) style:UITableViewStyleGrouped];
    tab.backgroundColor=[UIColor clearColor];
    [tab setDelegate:self];
    [tab setDataSource:self];
    [self.view addSubview:tab];

    //Setting标题背景
    UIImageView *Set_Title_Image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navgationbar.png"]];
    Set_Title_Image.frame=CGRectMake(0, 0, 320, 40);
    [self.view addSubview:Set_Title_Image];
    [Set_Title_Image release];
    //Setting标题
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(120, 0, 110, 40)];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor=[UIColor whiteColor];
    title_label.text=@"Settings";
    title_label.font=[UIFont systemFontOfSize:25];
    [self.view addSubview:title_label];
    [title_label release];
    
    connet_Set_IV =[[UIImageView alloc]initWithFrame:CGRectMake(210, 6, 28, 28)];
    connet_Set_IV.backgroundColor=[UIColor clearColor];
    [self.view addSubview:connet_Set_IV];
    [connet_Set_IV release];
    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [Mist_Field resignFirstResponder];
    [Cycle_Field resignFirstResponder];
    [Flow_Reset resignFirstResponder];
    [MasterField resignFirstResponder];
    [ZDTField resignFirstResponder];
    [flow_Field resignFirstResponder];
    [Rate_Field resignFirstResponder];


    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    if ([indexPath section]==1)
    {
        if ([indexPath row]==1)
        {
            
            [self.tabBarController.navigationController pushViewController:[[QD24VacorPulseVC new] autorelease] animated:YES];
        }
    }
    else
    {
        if ([indexPath section]==3)
        {
            if ([indexPath row]==0)
            {
                [self.tabBarController.navigationController pushViewController:[[QDSelectSensorVC new] autorelease] animated:YES];
            }
        }
    }


}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==1)
    {
        if ([indexPath row]==2)
        {
            return 40.0;
        }
        else
        {
            return 40.0;
        }
    }
    else
    {
        if ([indexPath section]==2||[indexPath section]==4)
        {
            if ([indexPath row]==0)
            {
                return 40.0;
            }
            else
            {
                return 40.0;
            }

        }
        else
        {
          return 40.0;  
        }
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 3;
            break;
        case 4:
            return 2;
            break;
        default:
            return 0;
            break;
    }
    
}
-(void)clickCalibrateFlowSwtich
{
    NSMutableDictionary *set_dic=[NSMutableDictionary dictionary];
    
    NSString *set_value;
    if (Flow_Calibrate.on)
    {
        set_value=@"0";
        str_status=@"1";
    }
    else
    {
        set_value=@"1";
        str_status=@"0";
    }
    [set_dic setObject:set_value forKey:@"value"];
    [set_dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"settingID"] forKey:@"settingId"];
    
    [setrequest settingflowreBTquest:set_dic];
}
-(void)resetTolalFlowSW
{
    NSString *tolal_value;
    if (Flow_Reset.on)
    {
        tolal_value=@"0";
        
    }
    else
    {
        tolal_value=@"1";
    
    }

    [setrequest settingrequesresetolalFlow:tolal_value];
    [Flow_Reset performSelector:@selector(setOn:animated:) withObject:NO afterDelay:1.0f];
    
}
-(void)clickInput2Sw
{
    NSString *input2Value;
    if (Input2_Switch.on)
    {
        input2Value=@"1";
    }
    else
    {
        input2Value=@"0";
    }
    [setrequest sendInput2:input2Value];
    
}
-(void)clickInput3Sw
{
    NSString *input3Value;
    if (Input3_Switch.on)
    {
        input3Value=@"1";
    }
    else
    {
        input3Value=@"0";
    }
    [setrequest sendInput3:input3Value];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *cellID=@"cellID";
    //const NSInteger section = [indexPath section];
    NSString *cellID = [NSString stringWithFormat:@"sention%i cell%i",[indexPath section],indexPath.row];
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell =[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID]autorelease];
        
        switch ([indexPath section])
        {
            case 0:
            switch ([indexPath row])
            {
                case 0:
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    cell.textLabel.text=@"Calibrate Flow";
                    Flow_Calibrate=[[UISwitch alloc]initWithFrame:CGRectMake(225, 7, 20, 20)];
                    Flow_Calibrate.onTintColor=[UIColor redColor];
                    [Flow_Calibrate addTarget:self action:@selector(clickCalibrateFlowSwtich) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:Flow_Calibrate];
                    [Flow_Calibrate release];
  
                    break;
                case 1:
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    cell.textLabel.text=@"Reset Total Flow";
                    Flow_Reset=[[UISwitch alloc]initWithFrame:CGRectMake(225, 6, 20, 20)];
                    [Flow_Reset addTarget:self action:@selector(resetTolalFlowSW) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:Flow_Reset];
                    [Flow_Reset release];

                    break;
                    default:
                        break;
                }
                break;
                
            case 1:
                switch ([indexPath row])
            {
                    case 0:
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        cell.textLabel.text=@"Mist Duty Cycle";
                    Mist_Field=[[UITextField alloc]initWithFrame:CGRectMake(180, 5, 30, 30)];
                    Mist_Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    Mist_Field.layer.borderColor =[[UIColor colorWithWhite:200/255.0 alpha:1.0]CGColor];
                    Mist_Field.keyboardType=UIKeyboardTypeNumberPad;
                    Mist_Field.textAlignment =NSTextAlignmentCenter;
                    Mist_Field.layer.borderWidth = 1.5;
                    Mist_Field.layer.cornerRadius = 5;
                    Mist_Field.delegate=self;
                    Mist_Field.tag=200;
                    Mist_Field.layer.masksToBounds = YES;
                    [cell addSubview:Mist_Field];
                    [Mist_Field release];
                    
                    
                    UILabel *label_BaiFen=[[UILabel alloc]initWithFrame:CGRectMake(218, 3, 35, 35)];
                    label_BaiFen.backgroundColor=[UIColor clearColor];
                    label_BaiFen.text=@"%";
                    label_BaiFen.textColor=[UIColor grayColor];
                    [cell addSubview:label_BaiFen];
                    [label_BaiFen release];
                    
                    Cycle_Field=[[UITextField alloc]initWithFrame:CGRectMake(240, 5, 30, 30)];
                    Cycle_Field.layer.borderColor =[[UIColor colorWithWhite:200/255.0 alpha:1.0]CGColor];
                    Cycle_Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    Cycle_Field.keyboardType=UIKeyboardTypeNumberPad;
                    Cycle_Field.textAlignment =NSTextAlignmentCenter;
                    Cycle_Field.layer.borderWidth = 1.5;
                    Cycle_Field.layer.cornerRadius = 5;
                    Cycle_Field.delegate=self;
                    Cycle_Field.tag=2;
                    Cycle_Field.layer.masksToBounds = YES;
                    [cell addSubview:Cycle_Field];
                    [Cycle_Field release];
                    
                    UILabel *label_Sec=[[UILabel alloc]initWithFrame:CGRectMake(275, 10, 30, 20)];
                    label_Sec.backgroundColor=[UIColor clearColor];
                    label_Sec.text=@"Sec";
                    label_Sec.textColor=[UIColor grayColor];
                    [cell addSubview:label_Sec];
                    [label_Sec release];
                        break;

                    case 1:
                    [cell.textLabel setNumberOfLines:1];
                        cell.textLabel.text=@"24Vac or Pulse/DC Latching            ";
                    cell.textLabel.adjustsFontSizeToFitWidth = YES;
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    Latch_Label=[[UILabel alloc]initWithFrame:CGRectMake(240, 4, 60, 30)];
                    Latch_Label.backgroundColor=[UIColor clearColor];
                    Latch_Label.textColor=[UIColor grayColor];
                    [cell addSubview:Latch_Label];
                    [Latch_Label release];
                    break;
                    default:
                        break;
                }
                break;
            case 2:
                switch ([indexPath row])
            {
                    case 0:
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        [cell.textLabel setNumberOfLines:2];
                        cell.textLabel.text=@"Master Valve Delay";
                    MasterField=[[UITextField alloc]initWithFrame:CGRectMake(240, 6, 30, 30)];
                    [MasterField setUserInteractionEnabled:NO];
                    MasterField.layer.borderColor =[[UIColor colorWithWhite:200/255.0 alpha:1.0]CGColor];
                    MasterField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    MasterField.tag=203;
//                    MasterField.layer.borderWidth = 1.5;
//                    MasterField.layer.cornerRadius = 5;
                    MasterField.keyboardType=UIKeyboardTypeNumberPad;
                    MasterField.textAlignment =NSTextAlignmentCenter;
                    MasterField.layer.masksToBounds = YES;
                    MasterField.delegate=self;
                    [cell addSubview:MasterField];
                    [MasterField release];
                    
                    
                    UILabel *label_master_Sec=[[UILabel alloc]initWithFrame:CGRectMake(275, 12, 30, 20)];
                    label_master_Sec.backgroundColor=[UIColor clearColor];
                    label_master_Sec.text=@"Min";
                    label_master_Sec.textColor=[UIColor grayColor];
                    [cell addSubview:label_master_Sec];
                    [label_master_Sec release];

                        break;
                    case 1:
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        cell.textLabel.text=@"Zone Delay Time";
                    ZDTField=[[UITextField alloc]initWithFrame:CGRectMake(240, 4, 30, 30)];
                    ZDTField.layer.borderColor =[[UIColor colorWithWhite:200/255.0 alpha:1.0]CGColor];
                    ZDTField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    ZDTField.layer.borderWidth = 1.5;
                    ZDTField.layer.cornerRadius = 5;
                    ZDTField.tag=204;
                    ZDTField.keyboardType=UIKeyboardTypeNumberPad;
                    ZDTField.textAlignment =NSTextAlignmentCenter;
                    ZDTField.layer.masksToBounds = YES;
                    ZDTField.delegate=self;
                    [cell addSubview:ZDTField];
                    [ZDTField release];
                    
                    UILabel *bel=[[UILabel alloc]initWithFrame:CGRectMake(275, 4, 30, 30)];
                    bel.text=@"Min";
                    bel.textColor=[UIColor grayColor];
                    bel.backgroundColor=[UIColor clearColor];
                    [cell addSubview:bel];
                    [bel release];
                        break;
                        
                    default:
                        break;
                }
                break;
            case 3:
                switch ([indexPath row])
            {
                case 0:
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text=@"Flow Sensor Setup";
                    break;
                case 1:
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    cell.textLabel.text=@"Flow Sensor Calibration";
                    flow_Field=[[UITextField alloc]initWithFrame:CGRectMake(230, 5, 70, 30)];
                    flow_Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    flow_Field.layer.borderColor =[[UIColor colorWithWhite:200/255.0 alpha:1.0]CGColor];
                    flow_Field.layer.borderWidth = 1.5;
                    flow_Field.layer.cornerRadius = 5;
                    flow_Field.text=[str_dic objectForKey:@"flowSensorCalibration"];
                    flow_Field.keyboardType=UIKeyboardTypeDecimalPad;
                    flow_Field.textAlignment =NSTextAlignmentCenter;
                    flow_Field.layer.masksToBounds = YES;
                    flow_Field.delegate=self;
                    flow_Field.tag=3;
                    [cell addSubview:flow_Field];
                    [flow_Field release];
                    break;
                case 2:
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    cell.textLabel.text=@"Flow Rate Tolerance";
                    Rate_Field=[[UITextField alloc]initWithFrame:CGRectMake(240, 5, 30, 30)];
                    Rate_Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    Rate_Field.layer.borderColor =[[UIColor colorWithWhite:200/255.0 alpha:1.0]CGColor];
                    Rate_Field.text=[[str_dic objectForKey:@"flowRateTolerance"]stringByReplacingOccurrencesOfString:@"%" withString:@""];
                    Rate_Field.layer.borderWidth = 1.5;
                    Rate_Field.layer.cornerRadius = 5;
                    Rate_Field.tag=206;
                    Rate_Field.keyboardType=UIKeyboardTypeNumberPad;
                    Rate_Field.textAlignment =NSTextAlignmentCenter;
                    Rate_Field.layer.masksToBounds = YES;
                    Rate_Field.delegate=self;
                    [cell addSubview:Rate_Field];
                    [Rate_Field release];
                    
                    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(275, 5, 30, 30)];
                    la.text=@"%";
                    la.textColor=[UIColor grayColor];
                    la.backgroundColor=[UIColor clearColor];
                    [cell addSubview:la];
                    [la release];
                    break;
                    
                default:
                    break;
            }
        break;
            case 4:
                switch ([indexPath row])
            {
                case 0:
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    cell.textLabel.text=@"Input 2 (Moisture)";
                    Input2_Switch=[[UISwitch alloc]initWithFrame:CGRectMake(225, 7, 40, 20)];
                    [Input2_Switch addTarget:self action:@selector(clickInput2Sw) forControlEvents:UIControlEventTouchUpInside];
                    if ([[str_dic objectForKey:@"input2"]isEqualToString:@"0"])
                    {
                        Input2_Switch.on=NO;
                    }
                    else
                    {
                        if ([[str_dic objectForKey:@"input2"]isEqualToString:@"1"])
                        {
                            Input2_Switch.on=YES;
                        }
                    }

                    [cell addSubview:Input2_Switch];
                    [Input2_Switch release];

                    break;
                case 1:
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    cell.textLabel.text=@"Input 3 (Rain)";
                    Input3_Switch=[[UISwitch alloc]initWithFrame:CGRectMake(225, 6, 40, 20)];
                    [Input3_Switch addTarget:self action:@selector(clickInput3Sw) forControlEvents:UIControlEventTouchUpInside];
                    
                    if ([[str_dic objectForKey:@"input3"]isEqualToString:@"0"])
                    {
                        Input3_Switch.on=NO;
                    }
                    else
                    {
                        if ([[str_dic objectForKey:@"input3"]isEqualToString:@"1"])
                        {
                            Input3_Switch.on=YES;
                        }
                    }

                    [cell addSubview:Input3_Switch];
                    [Input3_Switch release];
                    
                    break;
                    
                default:
                    break;
            }
               


                
                
            default:
                break;
        }
        
    }


    return cell;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (TF_tag)
    {
        case 200:
            return [dataArray count];
            break;
            
        case 2:
            return [Mist_sec_arr count];
            break;
        case 203:
            return [Master_Valve_Arr count];
            break;
        case 204:
            return [dataArray count];
            break;
        case 3:
            return [Flow_Sensor_arr count];
            break;
        case 206:
            return [dataArray count];
            break;
            
        default:
            return 1;
            break;
    }

}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    switch (TF_tag)
    {
        case 200:
            return [dataArray objectAtIndex:row];
            break;
            
        case 2:
            return [Mist_sec_arr objectAtIndex:row];
            break;
        case 203:
            return [Master_Valve_Arr objectAtIndex:row];
            break;
        case 204:
            return [dataArray objectAtIndex:row];
            break;
        case 3:
            return [Flow_Sensor_arr objectAtIndex:row];
            break;
        case 206:
            return [dataArray objectAtIndex:row];
            break;
            
        default:
            return nil;
            break;
    }

}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString  *result = nil;
    
    switch (TF_tag)
    {
        case 200:
            result = [dataArray objectAtIndex:row];
            Mist_Field.text = result;
            break;
            
        case 2:
            result = [Mist_sec_arr objectAtIndex:row];
            Cycle_Field.text = result;
            break;
        case 203:
            result = [Master_Valve_Arr objectAtIndex:row];
            MasterField.text = result;
            break;
        case 204:
            result = [dataArray objectAtIndex:row];
            ZDTField.text = result;
            break;
        case 3:
            result = [Flow_Sensor_arr objectAtIndex:row];
            flow_Field.text = result;
            break;
        case 206:
            result = [dataArray objectAtIndex:row];
            Rate_Field.text = result;
            break;
            
        default:
            break;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag==2)
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
                return YES;
            }
                break;
            case 3:
            {
                return YES;
            }
                break;
            default:
                break;
        }
        return NO;

    }
    else
    {
        if (textField.tag==3)
        {
            NSString *theStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
            if ([theStr isEqualToString:@"."]) return NO;
            if ([theStr length]==2 && [[theStr substringToIndex:1]isEqualToString:@"0"] && ![[theStr substringFromIndex:1]isEqualToString:@"."]) return NO;
            if ([theStr length]>2 && [[theStr substringWithRange:NSMakeRange(1, 1)]isEqual:@"."] && [[theStr substringFromIndex:[theStr length]-1]isEqualToString:@"."]) return NO;
            switch ([theStr length])
            {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                {
                    return YES;
                }
                    break;
                default:
                    break;
            }
            return NO;

        }
        else
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
                    return YES;
                }
                    break;
                default:
                    break;
            }
            return NO;

        }

    }
}
-(void)tabviewAnimationsBegin
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    tab.frame =CGRectMake(0, -80, 320, self.view.frame.size.height-89);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];

}
-(void)tableviewAnimationEnd
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    tab.frame =CGRectMake(0, 40, 320, self.view.frame.size.height-40);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    TF_tag =textField.tag;
    
    switch (TF_tag)
    {
        case 203:
            [self tabviewAnimationsBegin];
            break;
        case 204:
            [self tabviewAnimationsBegin];
            break;
        case 3:
            
            [tab scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:4] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [self tabviewAnimationsBegin];
            return;
        case 206:
            [tab scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:4] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [self tabviewAnimationsBegin];
            break;
        default:
            break;
    }

    
    UIPickerView *_pickerView = [[UIPickerView alloc] init];
    
    [_pickerView sizeToFit];
    
    _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _pickerView.delegate = self;
    
    //_pickerView.dataSource = self;
    
    _pickerView.showsSelectionIndicator = YES;
    
    textField.inputView = _pickerView;
    
    [_pickerView release];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{

    switch (TF_tag)
    {
        case 200:
            [setrequest settingrequestcycle:textField.text];
            break;
        case 2:
            [setrequest settingrequestcycleTwo:textField.text];
            break;
        case 203:
            [setrequest requestMasterValveDelay:textField.text];
            [self tableviewAnimationEnd];
            break;
        case 204:
            [setrequest requestzoneDelayTime:textField.text];
            [self tableviewAnimationEnd];
            break;
        case 3:
            [setrequest requestFlowSensorCalibration:textField.text];
            [self tableviewAnimationEnd];
            break;
        case 206:
            [setrequest requestFlowRateTolerance:textField.text];
            [self tableviewAnimationEnd];
            break;
        default:
            break;
    }



    
   
    return YES;
}

-(void)gotonetrequstdata
{
    if (self.tabBarController.selectedIndex ==3)
    {
    QDNetRequstData *requst=[[QDNetRequstData alloc]init];
    requst.delegate=self;
    [requst requstSettingData];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"refreshYN"];
    [self StopActivityIndicatorView];
    [self StopActivityIndicatorView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self StartActivityIndicatorView];
    [self performSelector:@selector(gotonetrequstdata) withObject:nil afterDelay:0.01];
}

-(void)autoLoginRetun:(NSString *)string
{
    [self StartActivityIndicatorView];
        [self gotonetrequstdata];
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
        UITextView *thetext = (UITextView *)[self.view viewWithTag:10000];
        [thetext removeFromSuperview];
        NSArray *data_Arr =[string componentsSeparatedByString:@"#"];
        [[NSUserDefaults standardUserDefaults]setObject:data_Arr forKey:@"select_sensor_set"];
        NSError *error;
        NSMutableDictionary *dic =[NSJSONSerialization JSONObjectWithData: [[data_Arr objectAtIndex:0] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        
        
        if (![[data_Arr objectAtIndex:1] isEqualToString:@"Not connected"])
        {
            connet_Set_IV.image=[UIImage imageNamed:@"connected.png"];
        }
        else
        {
            connet_Set_IV.image=[UIImage imageNamed:@"notconnected.png"];
        }
        [[NSUserDefaults standardUserDefaults]setObject:[data_Arr objectAtIndex:3] forKey:@"settingID"];
        [[NSUserDefaults standardUserDefaults]setObject:[data_Arr objectAtIndex:4] forKey:@"autohumidity"];
        NSArray *Setup_arr =[[data_Arr objectAtIndex:5] componentsSeparatedByString:@","];
        [[NSUserDefaults standardUserDefaults]setObject:Setup_arr forKey:@"flowsensorsetup"];
        if ([[data_Arr objectAtIndex:2]isEqualToString:@"yellow"])
        {
            str_status =@"0";
            Flow_Calibrate.on=NO;
        }
        else
        {
            str_status =@"1";
            Flow_Calibrate.on=YES;
        }
        //mistDuty cycle
        NSString *Mist_cycleStr = [[dic objectForKey:@"mistDutyCycle"] substringToIndex:[[dic objectForKey:@"mistDutyCycle"] length]-3];
        NSArray *Mist_cycleArr = [Mist_cycleStr componentsSeparatedByString:@"%"];
        if ([Mist_cycleArr count])
        {
            Mist_Field.text=[Mist_cycleArr objectAtIndex:0];
        
            Cycle_Field.text=[Mist_cycleArr objectAtIndex:1];
        }
                
        if ([[data_Arr objectAtIndex:6]isEqualToString:@"yellow"])
        {
            Flow_Reset.on=NO;
        }
        else
        {
            Flow_Reset.on=YES;
        }
        
        if ([[dic objectForKey:@"vacorPulseDCLatching"]isEqualToString:@"0"])
        {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"vacorpulseDClatching"];
            Latch_Label.text=@"Latch";
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"vacorpulseDClatching"];
            Latch_Label.text=@"24Vac";
        }
        
//        MasterField.text=[[dic objectForKey:@"masterValveDelayTime"]stringByReplacingOccurrencesOfString:@"sec" withString:@""];
        MasterField.text=@"1";
        ZDTField.text=[[dic objectForKey:@"zoneDelayTime"]stringByReplacingOccurrencesOfString:@"min" withString:@""];
        flow_Field.text=[dic objectForKey:@"flowSensorCalibration"];
        Rate_Field.text=[[dic objectForKey:@"flowRateTolerance"]stringByReplacingOccurrencesOfString:@"%" withString:@""];
        if ([[dic objectForKey:@"input2"]isEqualToString:@"0"])
        {
            Input2_Switch.on=NO;
        }
        else
        {
             if ([[dic objectForKey:@"input2"]isEqualToString:@"1"])
             {
                 Input2_Switch.on=YES;
             }
        }
        if ([[dic objectForKey:@"input3"]isEqualToString:@"0"])
        {
            Input3_Switch.on=NO;
        }
        else
        {
            if ([[dic objectForKey:@"input3"]isEqualToString:@"1"])
            {
                Input3_Switch.on=YES;
            }
        }
        [[NSUserDefaults standardUserDefaults]setObject:[data_Arr objectAtIndex:18] forKey:@"trun_flast"];
        str_dic =[dic retain];
        [self StopActivityIndicatorView];
        
    }
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    
}
-(void)dealloc
{
    //移除通知
    NSNotificationCenter *noc = [NSNotificationCenter defaultCenter];
    [noc removeObserver:self name:@"RefreshNow" object:nil];
    [Mist_sec_arr release];
    [Master_Valve_Arr release];
    [Flow_Sensor_arr release];
    [dataArray release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
