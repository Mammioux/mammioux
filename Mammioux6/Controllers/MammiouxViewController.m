//
//  knuzzleViewController.m
//  knuzzle
//
//  Created by Teresa Rios-Van Dusen on 2/24/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MammiouxViewController.h"
#import "TimerController.h"
#import "mammiouxLog.h"
#import "SettingsViewController.h"

@implementation MammiouxViewController

@synthesize lb;
@synthesize rb;
@synthesize ltimer;
@synthesize rtimer;
@synthesize leftAIV;
@synthesize rightAIV;
@synthesize lpv;
@synthesize rpv;
@synthesize lastTimeLabel;


// The designated initializer. Override to perform setup that is required before the view is loaded.
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        // Custom initialization
//        NSLog(@"Init with nib");
//    }
//    return self;
//}


/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 // Custom initialization
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	ltimer.text = @"00:00";
	rtimer.text = @"00:00";
	// load file with settings
	started = NO;
	lstimer = [[NSUserDefaults standardUserDefaults] integerForKey:@"lstimer"]*60;
	rstimer = [[NSUserDefaults standardUserDefaults] integerForKey:@"rstimer"]*60;
	leftActive = [[NSUserDefaults standardUserDefaults] boolForKey:@"leftsidelast"];
	sessionsPerDay = [[NSUserDefaults standardUserDefaults] integerForKey:@"feedingsDay"];
		
	[leftAIV stopAnimating];
	[rightAIV stopAnimating];
	[self nextSide:leftActive];
	
	//[self saveSettings];
	
	//create timer objects
	ltc = [[TimerController alloc] init];
	rtc = [[TimerController alloc] init];

	lpv.progress = 0;
	rpv.progress = 0;
	
	klog = [mammiouxLog sharedMammiouxLog] ;
	NSDate *lastSession = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSession"];
	
	NSLog(@"Last Session: %@",lastSession.description);
	[self updateSessionLabel];
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return ( (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void) selectB: (id)sender {
	
	//NSLog(@"Button Selected: %@",(sender == rb)?@"RIGHT":@"LEFT");
	[self toggleButton: sender];
}

- (void) saveSettings {
	//NSLog(@"synchronize settings");
	[[NSUserDefaults standardUserDefaults] setInteger:lstimer/60 forKey:@"lstimer"];
	[[NSUserDefaults standardUserDefaults] setInteger: rstimer/60 forKey:@"rstimer"];
	[[NSUserDefaults standardUserDefaults] setBool: leftActive forKey:@"leftsidelast"];
	[[NSUserDefaults standardUserDefaults] setInteger:sessionsPerDay forKey:@"feedingsDay"];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
	/*
	 NSString *errorDesc;
	 NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"timers" ofType:@"plist"];
	 NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:settings						 
	 format:NSPropertyListXMLFormat_v1_0
	 errorDescription:&errorDesc];
	 
	 if (plistData) {
	 [plistData writeToFile:bundlePath atomically:YES];
	 }
	 else {
	 NSLog(errorDesc);
	 [errorDesc release];
	 }
	 */
}

- (void) restoreSettings{
    // load file with settings
	started = NO;
	lstimer = [[NSUserDefaults standardUserDefaults] integerForKey:@"lstimer"]*60;
	rstimer = [[NSUserDefaults standardUserDefaults] integerForKey:@"rstimer"]*60;
	leftActive = [[NSUserDefaults standardUserDefaults] boolForKey:@"leftsidelast"];
	sessionsPerDay = [[NSUserDefaults standardUserDefaults] integerForKey:@"feedingsDay"];
}

-(void) toggleButton:(UIButton *) aButton 
{
	if( ((aButton == rb ) && leftActive) || ((aButton ==lb) && !leftActive))
	{
		//NSLog(@"Tapped other button");
		[self toggleSide];
	}
	else 
	{
		//NSLog(@"Tapped same button");
		[self switchTimer:leftActive];
	}
	
	//[self saveSettings];
}

-(void) nextSide:(BOOL) lslast {
	[self activateSide:!lslast];
	[self inactSide:lslast];
	leftActive = !lslast;
	//NSLog(@"leftsidelast: %d",leftActive);
	[[NSUserDefaults standardUserDefaults] setBool:leftActive forKey:@"leftsidelast"];
}

- (void) updateSessionLabel {
	NSDate *ls = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSession"];
	NSTimeInterval gap = [[NSDate date] timeIntervalSinceDate:ls];
	gap = gap > (24*3600) ? 0: gap;
	NSUInteger hours = gap/3600;
	NSUInteger secs = (int) gap%3600;
	NSString *report =  [[NSString alloc] initWithFormat:@"Last Feeding: %2d:%02d:%02d",hours,secs/60, secs%60];
	lastTimeLabel.text= report;
	
}

-(void) toggleSide {
	//NSLog(@"ToggleSide");
	if (started == NO)
	{
		[klog addToLog:@"SF"]; // starting session
		started = YES;
		[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastSession"];
		[self updateSessionLabel];
		//[self saveSettings];
	}
	
	[self stopSide:leftActive];
	[self inactSide:leftActive];
	[self startSide:!leftActive];
	[self activateSide:!leftActive];
	leftActive = !leftActive;
	[klog addToLog:(leftActive?@"SL":@"SR")];
	//[[NSUserDefaults standardUserDefaults] setObject:lastSession forKey:@"lastSession"];
}
-(void) inactSide:(BOOL)lsLast {
	if (lsLast) {
		lb.selected = NO;
		lb.highlighted = NO;
	}
	else
	{
		rb.selected = NO;
		rb.highlighted = NO;
	}
}

-(void) activateSide:(BOOL)lsLast {

	if (lsLast) {
		lb.selected = YES;
		lb.highlighted = YES;
        rb.selected = NO;
        rb.highlighted = NO;
	}
	else
	{
		rb.selected = YES;
		rb.highlighted = YES;
        lb.highlighted = NO;
        lb.selected = NO;
	}
}

- (void) alertMsg:(NSString *)msg {
	//NSLog(msg);
	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mammioux" message:msg
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
}

- (void) updtSecs:(NSUInteger) secs {
	NSString *report = [[NSString alloc] initWithFormat:@"%02d:%02d",secs/60, secs%60];
	if (leftActive) {
		ltimer.text = report;
		lpv.progress = secs > lstimer ? 1: (double)secs/lstimer; 
	}
	else {
		rtimer.text = report;
		rpv.progress = secs > rstimer ? 1: (double)secs/rstimer;
	}
	[self updateSessionLabel];
}

-(void) stopSide:(BOOL)lslast {
	if(lslast) {
		[self stopTimer:ltc];
		[leftAIV stopAnimating];
	}
	else
	{
		[self stopTimer:rtc];
		[rightAIV stopAnimating];
	}
}

-(void) startSide:(BOOL)lslast {
	if(lslast) {
		[self startTimer:ltc];
		[leftAIV startAnimating];
	}
	else
	{
		[self startTimer:rtc];
		[rightAIV startAnimating];
	}
}

-(void) stopTimer:(TimerController *)tc {
	// stop timers
	[tc stopTargetTimer:NULL];
	[tc stopSecondsTimer:NULL];	
}

-(void) startTimer:(TimerController *) tc {
    int targetTime = tc == ltc? lstimer:rstimer;
	[tc createTargetTimer:self withTargetTime:targetTime];
	[tc startTargetTimer:self];
	[tc startSecondsTimer:self];
}

-(void)switchTimer:(BOOL) lsLast {
	if (started == NO)
	{
		started = YES; // indicates session starting
        [klog addToLog:@"SF"]; // starting session
		[[NSUserDefaults standardUserDefaults] setObject: [NSDate date] forKey:@"lastSession"];
		[self updateSessionLabel];
		//[self saveSettings];
	}
	
	if (lsLast) {
		if(	[ltc.secondsTimer isValid]) {
			//NSLog(@"Stopping Left side");
			[self stopTimer:ltc];
			[klog addToLog:@"TL"];
			[leftAIV stopAnimating];
		}
		else {
			//NSLog(@"Start Left Side");
			[self startTimer:ltc];
			[klog addToLog:@"SL"];
			[leftAIV startAnimating];
		}
	}
	else 
	{
		if(	[rtc.secondsTimer isValid]) {
			//NSLog(@"Stop Right Side");
			[self stopTimer:rtc];
			[klog addToLog:@"TR"];
			[rightAIV stopAnimating];
		}
		else {
			//NSLog(@"Start Right Side");
			[self startTimer:rtc];
			[klog addToLog:@"SR"];
			[rightAIV startAnimating];
		}
	}
}

- (void)MyTableViewControllerDidFinish:(SettingsViewController *)controller {
    
	[self  dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showSettings {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
	
	// gain access to the delegate and send a message to switch to a particular view.
    [self performSegueWithIdentifier:@"SettingsSegue" sender:self];
}
- (IBAction)showInfo {   
    [self.navigationController setNavigationBarHidden:NO animated:YES];
	// gain access to the delegate and send a message to switch to a particular view.
    [self performSegueWithIdentifier:@"InfoSegue" sender:self];
}

-(void) singleTap {
	//NSLog(@"single tap on screen, ignore");
}

-(void) doubleTap {
	//NSLog(@"double tap on screen, go to settings");
	[self showSettings];
}
-(void) tripleTap {
	//NSLog(@"triple tap on screen, ignore");
}
-(void) quadrupleTap {
	//NSLog(@"quadruple tap on screen, ignore");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = [touch tapCount];
	
	switch (tapCount) {
		case 1:
			[self performSelector:@selector(singleTap) withObject:nil afterDelay:.4];
			break;
		case 2:
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapMethod) object:nil];
			[self performSelector:@selector(doubleTap) withObject:nil afterDelay:.4];
			break;
		case 3:
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doubleTapMethod) object:nil];
			[self performSelector:@selector(tripleTap) withObject:nil afterDelay:.4];
			break;
		case 4:
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tripleTap) object:nil];
			[self quadrupleTap];
			break;
		default:
			break;
	}
	
}

-(void) targetReached:(id)sender {
    if (sender == rtc) {
        // make right button green
        _rightBGImage.highlighted= YES;
     } else {
        _leftBGImage.highlighted = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
	NSLog(@"Saving current state");	
	//[klog addToLog:@"TF"];
	[klog flush];
	
	[self saveSettings];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// gain access to the delegate and send a message to switch to a particular view.
	[self.navigationController setNavigationBarHidden:YES animated:NO];
    [self restoreSettings];
	
}


@end
