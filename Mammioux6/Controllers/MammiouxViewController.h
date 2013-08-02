//
//  knuzzleViewController.h
//  knuzzle
//
//  Created by Teresa Rios-Van Dusen on 2/24/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimerController;
@class mammiouxLog;

@interface MammiouxViewController : UIViewController  {
	int lstimer;
	int rstimer;
	int sessionsPerDay;

	TimerController *rtc;
	TimerController *ltc;
	mammiouxLog *klog;
	BOOL leftActive;
	BOOL started;
	
}
@property (nonatomic, retain) IBOutlet UIButton *lb;
@property (nonatomic, retain) IBOutlet UIButton *rb;
@property (nonatomic, retain) IBOutlet UILabel *ltimer;
@property (nonatomic, retain) IBOutlet UILabel *rtimer;
@property (nonatomic, retain) IBOutlet UILabel *lastTimeLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *rightAIV;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *leftAIV;
@property (nonatomic, retain) IBOutlet UIProgressView *lpv;
@property (nonatomic, retain) IBOutlet UIProgressView *rpv;


- (IBAction) selectB:(id)sender;
- (void) saveSettings;
- (void) restoreSettings;
-(void) toggleButton:(UIButton *) aButton;
-(void) alertMsg:(NSString *)msg;
-(void) updtSecs:(NSUInteger) secs;
-(void) stopSide:(BOOL)lslast;
-(void) startSide:(BOOL)lslast;
-(void) stopTimer:(TimerController *)tc;
-(void) startTimer:(TimerController *) tc;
-(void) switchTimer:(BOOL) lsLast;
-(void) activateSide:(BOOL)lsLast;
-(void) inactSide:(BOOL)lsLast;
-(void) toggleSide;
-(void) nextSide:(BOOL) lslast;
-(void) singleTap;
-(void) doubleTap;
-(void) tripleTap;
-(void) quadrupleTap;
-(void) updateSessionLabel;


@end

