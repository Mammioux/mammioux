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

@synthesize datePicker, doneButton, dataArray, dateFormatter,urlButton, resetButton;


- (void)viewDidLoad
{
	self.dataArray = [NSArray arrayWithObjects:@"Last Session", @"Feeds per day", @"Duration Left Side", @"Duration Right Side",nil];
	
	self.dateFormatter = [[NSDateFormatter alloc] init] ;
	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	
	CGRect frame = CGRectMake(kLeftMargin, 0, kTextFieldWidth, kTextFieldHeight);
	frame = CGRectMake(0,0, 40, 40);
	
	self.urlButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.urlButton.frame=frame;
	
	[self.urlButton setTitle:@"Knuzzle (c)" forState:UIControlStateNormal];	
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

#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

}


#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *returnStr = @"";
	
	return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat componentWidth = 0.0;
	
	componentWidth = 40.0;	
	
	return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 60;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}


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
        case 0:
			[self displayDatePicker:targetCell];
			break;
		case 1:
        case 2:
		case 3:{
			if (![self.datePicker isHidden]) [self.datePicker removeFromSuperview];
            
            NumericCell *cell = (NumericCell *)targetCell;
			
			NSLog(@"Clicked on Numeric Cell");
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
	NSString *kCustomCellID = indexPath.row == 0? @"DateCellID":@"NumericCellId";
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
           [self.NumericCellNib instantiateWithOwner:self options:nil];
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
- (void)slideDownDidStop
{
	// the date picker has finished sliding downwards, so remove it
	[self.datePicker removeFromSuperview];
}

- (IBAction)dateAction:(id)sender
{
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	switch (indexPath.row) {
		case 0:
			cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.datePicker.date];
			[[NSUserDefaults standardUserDefaults] setObject:self.datePicker.date forKey:@"lastSession"];
			break;
		case 1:
			break;
		case 2:
		case 3:
			break;
		default:
			break;
	}
}

- (IBAction)doneAction:(id)sender
{
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect endFrame = self.datePicker.frame;
	endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
	
	// start the slide down animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	// we need to perform some post operations after the animation is complete
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
	
	self.datePicker.frame = endFrame;
	[UIView commitAnimations];
	
	// grow the table back again in vertical size to make room for the date picker
	CGRect newFrame = self.tableView.frame;
	newFrame.size.height += self.datePicker.frame.size.height;
	self.tableView.frame = newFrame;
	
	//  to=do replace the "Done" button in the nav bar by resetButton
	self.navigationItem.rightBarButtonItem = nil;
	
	// deselect the current table row
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)resetAction:(id)sender
{
	NSLog(@"reset to default");
}

- (void)jumpToMammiouxSite:(id)sender {
	// gain access to the delegate and send a message to switch to a particular view.
    [self.navigationController.viewControllers[0] performSegueWithIdentifier:@"InfoSegue" sender:self];
}

-(void)displayDatePicker:(UITableViewCell *)targetCell  {
	self.datePicker.date = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];
	self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;

	// check if our date picker is already on screen
	if (self.datePicker.superview == nil){
		[self.view.superview insertSubview: self.datePicker belowSubview: self.tableView];
		NSLog(@"Showing Date Picker");
		// size up the picker view to our screen and compute the start/end frame origin for our slide up animation
		//
		// compute the start frame
		CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
		CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
		CGRect startRect = CGRectMake(0.0,
									  screenRect.origin.y + screenRect.size.width,
									  pickerSize.width, pickerSize.height);
		self.datePicker.frame = startRect;
		
		// compute the end frame
		CGRect pickerRect = CGRectMake(0.0,
									   screenRect.origin.y + screenRect.size.width - pickerSize.height,
									   pickerSize.width,
									   pickerSize.height);
		// start the slide up animation
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		
		// we need to perform some post operations after the animation is complete
		[UIView setAnimationDelegate:self];
		
		self.datePicker.frame = pickerRect;
		
		// shrink the table vertical size to make room for the date picker
		CGRect newFrame = self.tableView.frame;
		if (newFrame.size.height >= screenRect.size.width - 32) { 
			newFrame.size.height -= self.datePicker.frame.size.height;
			self.tableView.frame = newFrame;
		}
		[UIView commitAnimations];
		
		// add the "Done" button to the nav bar
		self.navigationItem.rightBarButtonItem = self.doneButton;
	}
}



#pragma mark UINib

- (UINib *)NumericCellNib
{
    NSLog(@"Loading Numeric Cell Nib only once");
    if (!_NumericCellNib)
    {
        _NumericCellNib = [UINib nibWithNibName:@"NumericCellId" bundle:nil];
    }
    return _NumericCellNib;
}
@end

