

#import "QDManualAuroCell.h"

@implementation QDManualAuroCell
@synthesize cellImageView;
@synthesize delegate;
@synthesize ON_OFF_Sw;
@synthesize Mist_cont;
@synthesize largestProgressView;
@synthesize number_label;
@synthesize auto_manual_cell;


-(void)mudifyTimealter
{
    UIAlertView *alerview=[[UIAlertView alloc]initWithTitle:@"Set time?" message:@"Please enter the time you want to set\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 90, 260, 30)];
    myTextField. borderStyle = UITextBorderStyleRoundedRect;
    [myTextField setPlaceholder:@"Set time"];
    myTextField.delegate=self;
    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 0);
    [alerview setTransform:myTransform];
    myTextField.keyboardType =UIKeyboardTypeNumberPad;
    [myTextField setBackgroundColor:[UIColor whiteColor]];
      myTextField.text  =number_label.text;
    [alerview addSubview:myTextField];
    
    [alerview show];
    
    [alerview release];

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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
            if ([string integerValue]<240)
            {
                return YES;
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
    if ([textField.text isEqualToString:@""])
    {
        textField.text=@"2";
        return YES;
    }
    if ([textField.text intValue]>240)
    {
        textField.text=@"240";
    }
    else
    {
        if ([textField.text intValue]<2)
        {
            textField.text=@"2";
        }
    }
    if (numberBOOL)
    {
         number_label.text = textField.text;
    }
    
     return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
        if ([myTextField.text intValue]>240)
        {
            myTextField.text =@"240";
        }
        NSString *timestr=nil;
        NSString *numberstr=nil;
        NSMutableDictionary *mu_dic=[NSMutableDictionary dictionary];
        QDNetRequstData *dataqust=[[[QDNetRequstData alloc]init]autorelease];
        if (buttonIndex==1)
        {
            if (auto_manual_cell)
            {
                timestr=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"manual_timeID"]objectAtIndex:self.tag+14]];
                numberstr =[NSString stringWithFormat:@"%i",self.tag];
                [mu_dic setObject:timestr forKey:@"timingId"];
                [mu_dic setObject:numberstr forKey:@"number"];
                                
                
            }
            else
            {
                
                numberstr =[NSString stringWithFormat:@"%i",self.tag];
                [mu_dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"auto_timeID"]objectAtIndex:self.tag+17] forKey:@"timingId"];
                [mu_dic setObject:numberstr forKey:@"number"];
                
                
            }
            
            if ([myTextField.text intValue]<=2)
            {
                [mu_dic setObject:@"2" forKey:@"value"];
            }
            else
            {
                if ([myTextField.text isEqualToString:@""])
                {
                    [mu_dic setObject:@"2" forKey:@"value"];
                }
                else
                {
                    [mu_dic setObject:myTextField.text forKey:@"value"];
                }

            }
            
            [dataqust autovcsettime:mu_dic];
            
            if ([myTextField.text isEqualToString:@""]||[myTextField.text isEqualToString:@"1"]||[myTextField.text isEqualToString:@"0"])
            {
                myTextField.text=@"2";
            }
            
            [delegate clickalterBT:self text:myTextField.text];
            
            numberBOOL=YES;
        }
    else
    {
        numberBOOL=NO;
    }
    
}

-(void)clickImageViewgotoCamera
{
    UIActionSheet *actionSheetView = [[UIActionSheet alloc] initWithTitle:@"Set Image"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Photograph"
                                                        otherButtonTitles:@"Local Photos",nil];
    [actionSheetView showInView:self];
    [actionSheetView autorelease];

}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
            [delegate clickdifferentcellImage:self];
            break;
        case 1:
            [delegate selectlocationImage:self];
            
        default:
            break;
    }
    
    
}
-(void)clickImageViewgotoCamerachangan
{
    [delegate longclickImageView:cellImageView.image];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self)
        {
            //cell的背景
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
            [imageView setImage:[UIImage imageNamed:@"ID_allstatebar.png"]];
            [self addSubview:imageView];
            [imageView release];
            
            //图片
            cellImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 80, 80)];
            cellImageView.image=[UIImage imageNamed:@"imgview@2x.png"];
            [cellImageView setUserInteractionEnabled:YES];
            cellImageView.layer.cornerRadius = 5;
            cellImageView.layer.masksToBounds = YES;
            [self addSubview:cellImageView];
        
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageViewgotoCamera)];
            [cellImageView addGestureRecognizer:tap];
            [tap release];
            
            
            UILongPressGestureRecognizer *Reco_tap=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageViewgotoCamerachangan)];
            [cellImageView addGestureRecognizer:Reco_tap];
            [Reco_tap release];
            
            
            //on off
            ON_OFF_Sw=[[DCRoundSwitch alloc]initWithFrame:CGRectMake(95, 40, 70, 25)];
            ON_OFF_Sw.tag=3;
            ON_OFF_Sw.onText=@"ON";
            ON_OFF_Sw.offText=@"OFF";
            ON_OFF_Sw.onTintColor=[UIColor colorWithRed:0.41960 green:0.74117 blue:0.22745 alpha:1.0];
            [self addSubview:ON_OFF_Sw];
            [ON_OFF_Sw release];
            
            //mist
            Mist_cont =[[DCRoundSwitch alloc]initWithFrame:CGRectMake(175,40, 70, 25)];
            Mist_cont.tag=4;
            Mist_cont.onText=@"Mist";
            Mist_cont.offText=@"Cont";
            [self addSubview:Mist_cont];
            [Mist_cont release];
            
            
            
            largestProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(260, 33, 40, 40)];
            largestProgressView.tag=5;
            
            [self addSubview:largestProgressView];
            [largestProgressView release];
                    
            number_label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 40, 20)];
            number_label.tag=6;
            number_label.textAlignment=NSTextAlignmentCenter;
            number_label.font=[UIFont systemFontOfSize:15];
            number_label.backgroundColor=[UIColor clearColor];
            [largestProgressView addSubview:number_label];
            [number_label release];
            
            UIButton *butt=[[UIButton alloc]initWithFrame:CGRectMake(260, 5, 40, 40)];
            [butt addTarget:self action:@selector(mudifyTimealter) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:butt];
            [butt release];
            
            
            
            
        }
        return self;
    }
}
-(void)setRound:(float)ff
{
    largestProgressView.progress=ff;
}

-(void)dealloc
{
    [cellImageView release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
