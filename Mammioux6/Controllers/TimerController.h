//
//  TimerController.h
//  knuzzle
//
//  Created by Teresa Rios-Van Dusen on 3/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MammiouxViewController;

@interface TimerController : NSObject {

}

@property (nonatomic, assign) NSTimer *secondsTimer;
@property (nonatomic, retain) NSTimer *targetTimer;
@property (nonatomic) NSUInteger timerCount;
@property (nonatomic, retain) MammiouxViewController *kvc;

- (IBAction)startOneOffTimer:sender;

- (IBAction)startSecondsTimer:sender;
- (IBAction)stopSecondsTimer:sender;

- (IBAction)createTargetTimer:sender withTargetTime:(NSTimeInterval) seconds;
- (IBAction)startTargetTimer:sender;
- (IBAction)stopTargetTimer:sender;

- (IBAction)startFireDateTimer:sender;

- (void)secondsFireMethod:(NSTimer*)theTimer;

- (void)invocationMethod:(NSDate *)date;

- (void)targetFireMethod:(NSTimer*)theTimer;

- (NSDictionary *)userInfo;

@end
