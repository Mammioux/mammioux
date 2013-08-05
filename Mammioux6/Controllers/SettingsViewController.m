/*
 File: MyTableViewController.m
 Abstract: based on Apple's demo application.
 Version: 1.0
 
 */

#import "SettingsViewController.h"
#import "SettingsView.h"
#import "NumericCell.h"

#define kTextFieldWidth	       50.0
#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			10.0

#define kTextFieldHeight		30.0

#define kViewTag			1		// for tagging our embedded controls for removal at cell recycle time

@implementation SettingsViewController

@synthesize doneButton, dataArray, dateFormatter,urlButton, resetButton;


- (void)viewDidLoad
{
	self.dataArray = [NSArray arrayWithObjects:@"Last Session", @"Feeds per day", @"Duration Left Side", @"Duration Right Side",nil];
	
	self.dateFormatter = [[NSDateFormatter alloc] init] ;
	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	
	CGRect frame = CGRectMake(0,0, 40, 40);
	
	self.urlButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.urlButton.frame=frame;
	
	[self.urlButton setTitle:@"Mammioux (c)" forState:UIControlStateNormal];
	self.urlButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
	
	// Center the text on the button, considering the button's shadow
	self.urlButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	self.urlButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[self.urlButton setBackgroundColor:[UIColor clearColor]];
	
	
	[self.urlButton addTarget:self action:@selector(jumpToMammiouxSite:) forControlEvents:UIControlEventTouchUpInside];
	
	self.tableView.tableFooterView=urlButton;
}

- (void)viewDidUnload
{
	self.dataArray = nil;
	self.dateFormatter = nil;
}


- (void)viewWillDisappear:(BOOL)animated
{
	BOOL res = [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@" Synchronizing %@", res?@"worked!":@"failed :(");	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return ( (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}
/* 
 - (id)initWithFrame:(CGRect)frame {
 NSLog(@"Calling initWithFrame: x=%d,y=%d, width=%d, height=%d", frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
 [su	[[NSUserDefaults standardUserDefaults] synchronize];
 per init];
 return self;
 }
 */

#pragma mark -

#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.dataArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];

	switch (indexPath.row) {
		case 1:
        case 2:
		case 3:{
            NumericCell *cell = (NumericCell *)targetCell;
            cell.entryValue.hidden = NO;
            cell.detail.hidden = YES;
        }			
			break;
			
		default:
			break;
	}
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *kCustomCellID;
    //NumericCell *numCell;
    UITableViewCell *cell;

    if (indexPath.row ==0) {
        kCustomCellID = @"DateCellId";
        cell = [self.tableView dequeueReusableCellWithIdentifier:kCustomCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCustomCellID];
        }
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSession"]];
        cell.textLabel.text = [self.dataArray objectAtIndex:0];

    } else {
        kCustomCellID = @"NumericCellId";
        _numCell = (NumericCell *)[tableView dequeueReusableCellWithIdentifier:kCustomCellID];
        if (_numCell == nil) {
            _numCell = [[NumericCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCustomCellID];
        }

            switch (indexPath.row) {
                case 1:
                    _numCell.entryValue.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"feedingsDay"] stringValue];
                    _numCell.settingKey = @"feedingsDay";
                    _numCell.detail.text = _numCell.entryValue.text;
                    break;
                case 2:
                    _numCell.detail.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lstimer"] stringValue];
                    _numCell.entryValue.text = _numCell.detail.text;
                    _numCell.settingKey = @"lstimer";
                    break;
                case 3:
                    _numCell.detail.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"rstimer"] stringValue];
                    _numCell.entryValue.text = _numCell.detail.text;
                    _numCell.settingKey = @"rstimer";
                    break;
                default:
                    break;
            }
        
        _numCell.title.text = [self.dataArray objectAtIndex:indexPath.row];
        return _numCell;
    }
	
	return cell;
}

#pragma Actions


- (IBAction)resetAction:(id)sender
{
	NSLog(@"reset to default");
}

- (void)jumpToMammiouxSite:(id)sender {
	// gain access to the delegate and send a message to switch to a particular view.
    [self.navigationController.viewControllers[0] performSegueWithIdentifier:@"InfoSegue" sender:self];
}


@end

