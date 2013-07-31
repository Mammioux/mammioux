/*
 File: MyTableViewController.m
 Abstract: based on Apple's demo application.
 Version: 1.0
 
 */

#import "SettingsViewController.h"

#define kTextFieldWidth	       50.0
#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			10.0

#define kTextFieldHeight		30.0

#define kViewTag			1		// for tagging our embedded controls for removal at cell recycle time

@implementation SettingsViewController

@synthesize datePicker, doneButton, dataArray, dateFormatter, textField2,urlButton, resetButton;
@synthesize myPickerView;

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
	
	
	[self.urlButton addTarget:self action:@selector(jumpToKnuzzleSite:) forControlEvents:UIControlEventTouchUpInside];
	
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
	if (pickerView == myPickerView)	// don't show selection for the custom picker
	{
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		// report the selection to the UI label
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",
									 [pickerView selectedRowInComponent:0]];
		NSString *side = indexPath.row == 2?@"lstimer":@"rstimer";
		[[NSUserDefaults standardUserDefaults] setInteger:[pickerView selectedRowInComponent:0] forKey:side];
	}
}


#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *returnStr = @"";
	
	// note: custom picker doesn't care about titles, it uses custom views
	if (pickerView == myPickerView)
	{
		returnStr = [[NSNumber numberWithInt:row] stringValue];
	}
	
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
		case 1:
			if (![self.datePicker isHidden]) [self.datePicker removeFromSuperview]; 
			if (![self.myPickerView isHidden]) [self.myPickerView removeFromSuperview];
			
			NSLog(@"case number");
			
			textField2 = [[UITextField alloc] init];
			
			textField2.borderStyle = UITextBorderStyleNone;
			textField2.textColor = [UIColor blackColor];
			textField2.font = [UIFont systemFontOfSize:17.0];
			textField2.text =  targetCell.detailTextLabel.text;
			[[NSUserDefaults standardUserDefaults] setInteger:[targetCell.detailTextLabel.text intValue] forKey:@"feedingsDay"];
			
			
			textField2.backgroundColor = [UIColor whiteColor];
			textField2.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
			
			textField2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
			textField2.returnKeyType = UIReturnKeyDone;
			
			textField2.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
			
			textField2.tag = 1;		// tag this control so we can remove it later for recycled cells
			
			textField2.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
			
			[targetCell.contentView addSubview:textField2];
			
			break;
			
		case 0:
			[self displayDatePicker:targetCell];
			break;
			
		case 2:
		case 3:
			[self displayNumPicker:targetCell];
			break;
			
		default:
			break;
	}
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCustomCellID = @"CustomCellID";
	
	 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCustomCellID] ;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	else
	{
		// the cell is being recycled, remove old embedded controls
		UIView *viewToRemove = nil;
		viewToRemove = [cell.contentView viewWithTag:kViewTag];
		if (viewToRemove)
			[viewToRemove removeFromSuperview];
	}
	
	
	cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
	switch (indexPath.row) {
		case 1:
			cell.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"feedingsDay"] stringValue];
			break;
		case 0:
			cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSession"]];
			break;
		case 2:
			cell.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lstimer"] stringValue];
			break;
		case 3:
			cell.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"rstimer"] stringValue];
			break;
		default:
			break;
	}
//	UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//	[cell.contentView addSubview:button];
	
	return cell;
}

#pragma Actions
- (void)slideDownDidStop
{
	// the date picker has finished sliding downwards, so remove it
	[self.datePicker removeFromSuperview];
	[self.myPickerView removeFromSuperview];
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
	[textField2 removeFromSuperview];
}

- (IBAction)resetAction:(id)sender
{
	NSLog(@"reset to default");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	if (textField == textField2 && indexPath.row == 1){
		// the user pressed the "Done" button, so dismiss the keyboard
		
		NSLog(@"Row :%d",indexPath.row);
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		cell.detailTextLabel.text = textField2.text;
		[[NSUserDefaults standardUserDefaults] setInteger:[cell.detailTextLabel.text intValue] forKey:@"feedingsDay"];
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	[self.textField2 removeFromSuperview];
	[textField resignFirstResponder];
	return YES;
	
}

- (void)jumpToKnuzzleSite:(id)sender {
	// gain access to the delegate and send a message to switch to a particular view.
}

-(void)displayDatePicker:(UITableViewCell *)targetCell  {
	self.datePicker.date = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];
	self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
	// check if other picker is visible
	if (![self.myPickerView isHidden]) [self.myPickerView removeFromSuperview]; 
	[self.textField2 removeFromSuperview];
	// check if our date picker is already on screen
	if (self.datePicker.superview == nil){
		[self.view.superview insertSubview: self.datePicker belowSubview: self.tableView];
		NSLog(@"View Controller Orientation %d",self.interfaceOrientation);
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

-(void)displayNumPicker:(UITableViewCell *)targetCell  {
	NSLog(@"showing picker view for fields 2 and 3");
	[self.myPickerView selectRow: [targetCell.detailTextLabel.text intValue] inComponent:0 animated:NO];
	// check if other picker is visible
	if (![self.datePicker isHidden]) [self.datePicker removeFromSuperview]; 
	[self.textField2 removeFromSuperview];
	// check if our picker is already on screen
	if (self.myPickerView.superview == nil){
		
		[self.view.superview insertSubview: self.myPickerView belowSubview: self.tableView];
		
		// size up the picker view to our screen and compute the start/end frame origin for our slide up animation
		//
		// compute the start frame
		CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
		CGSize  pickerSize = [self.myPickerView sizeThatFits:CGSizeZero];
		CGRect startRect = CGRectMake(0.0,
									  screenRect.origin.y + screenRect.size.width,
									  pickerSize.width/2, pickerSize.height-80);
		self.myPickerView.frame = startRect;
		
		// compute the end frame
		CGRect pickerRect = CGRectMake(0.0,
									   screenRect.origin.y + screenRect.size.width - pickerSize.height+80,
									   pickerSize.width/2,
									   pickerSize.height-80);
		// start the slide up animation
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		
		// we need to perform some post operations after the animation is complete
		[UIView setAnimationDelegate:self];
		
		self.myPickerView.frame = pickerRect;
		
		// shrink the table vertical size to make room for the date picker
		CGRect newFrame = self.tableView.frame;
		if (newFrame.size.height >= screenRect.size.width - 32) { 
			newFrame.size.height -= self.myPickerView.frame.size.height;
			self.tableView.frame = newFrame;
		}
		[UIView commitAnimations];
		
		// add the "Done" button to the nav bar
		self.navigationItem.rightBarButtonItem = self.doneButton;
	}
}

@end

