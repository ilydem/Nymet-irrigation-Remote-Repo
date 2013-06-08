

#import "QDAutoinitIMV.h"

@implementation QDAutoinitIMV
@synthesize selectRow;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        selectRow=0;
        dataArray = [[NSArray alloc]initWithObjects:@"Program A",@"Program B",@"Program C",@"Program D", nil];
        
        self.image=[UIImage imageNamed:@"Background.png"];
        
        tab =[[UITableView alloc]initWithFrame:CGRectMake(30, 30, 260, 180) style:UITableViewStyleGrouped];
        tab.backgroundColor=[UIColor clearColor];
        tab.backgroundView=nil;
        [tab setDataSource:self];
        [tab setDelegate:self];
        tab.bounces=NO;
        [self addSubview:tab];
        
        
    }
    return self;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    selectRow = [indexPath row];
    [delegate clicktableviewcell:[NSString stringWithFormat:@"%d",selectRow]];
     
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *cellID = [NSString stringWithFormat:@"sention%i cell%i",[indexPath section],indexPath.row];
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell =[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID]autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        cell.textLabel.text =[dataArray objectAtIndex:[indexPath row]];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        
        
    }
    
    
    return cell;
}

-(void)dealloc
{
    [tab release];
    [super dealloc];
}


@end
