//
//  TimerController.m
//  knuzzle
//
//  Created by Teresa Rios-Van Dusen on 3/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimerController.h"
#import "MammiouxViewController.h"

@implementation TimerController

//@synthesize secondsTimer;
@synthesize targetTimer;
@synthesize timerCount;
@synthesize kvc;

- (NSDictionary *)userInfo {
    return [NSDictionary dictionaryWithObject:[NSDate date] forKey:@"StartDate"];
}

- (void)targetMethod:(NSTimer*)theTimer {
   // NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
   // NSLog(@"Timer started on %@", startDate);
}

- (void)invocationMethod:(NSDate *)date {
   // NSLog(@"Invocation for timer started on %@", date);
	//[kvc alertMsg:@"Reached Target"];
}

- (IBAction)startOneOffTimer:sender {
    [NSTimer scheduledTimerWithTimeInterval:2.0
									 target:self
								   selector:@selector(targetMethod:)
								   userInfo:[self userInfo]
									repeats:NO];
}

- (IBAction)startSecondsTimer:sender {

		NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
								  target:self selector:@selector(secondsFireMethod:)
								userInfo:[self userInfo] repeats:YES];
		self.secondsTimer = timer;
		//timerCount = 0;
}
- (IBAction)createTargetTimer:sender withTargetTime:(NSTimeInterval) seconds{
	self.kvc = sender;
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:@selector(invocationMethod:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:self];
    [invocation setSelector:@selector(invocationMethod:)];
    NSDate *startDate = [NSDate date];
    [invocation setArgument:&startDate atIndex:2];
    NSTimer *timer = [NSTimer timerWithTimeInterval:seconds invocation:invocation repeats:YES];
    self.targetTimer = timer;
	timerCount = 0;
}

- (IBAction)startTargetTimer:sender {
    if (targetTimer != nil) {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:targetTimer forMode:NSDefaultRunLoopMode];
    }
}

- (IBAction)startFireDateTimer:sender {
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:fireDate
											  interval:0.5
												target:self
											  selector:@selector(targetFireMethod:)
											  userInfo:[self userInfo]
											   repeats:YES];
    timerCount = 1;
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
}
- (IBAction)stopSecondsTimer:sender {
    [_secondsTimer invalidate];
    self.secondsTimer = nil;
}

- (IBAction)stopTargetTimer:sender {
    [targetTimer invalidate];
    self.targetTimer = nil;
}

- (void)targetFireMethod:(NSTimer*)theTimer {
    //NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
 //   NSLog(@"Target Timer started on %@", startDate);
    [theTimer invalidate];
	
}

- (void)secondsFireMethod:(NSTimer*)theTimer {
 //   NSLog(@"Seconds Timer fire count %d", timerCount);
    timerCount++;
	[kvc updtSecs:timerCount];
}

@end
