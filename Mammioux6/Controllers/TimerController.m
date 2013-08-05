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

-(TimerController *)init {
    self = [super init];
    if (self) {
        self.timerCount = 0;
    }
    
    return self;
}

- (void)invocationMethod:(NSDate *)date {
   // NSLog(@"Invocation for timer started on %@", date);
	[kvc alertMsg:@"Change Side"];
    [kvc targetReached:self];
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
    if (seconds < self.timerCount) {
        return;
    }
    NSLog(@"Stop timer in: %f seconds",seconds-self.timerCount);
    NSTimer *timer = [NSTimer timerWithTimeInterval:seconds-self.timerCount invocation:invocation repeats:YES];
    self.targetTimer = timer;
	//timerCount = 0;
}

- (IBAction)startTargetTimer:sender {
    if (targetTimer != nil) {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:targetTimer forMode:NSDefaultRunLoopMode];
    }
}

- (IBAction)stopSecondsTimer:sender {
    [_secondsTimer invalidate];
    self.secondsTimer = nil;
}

- (IBAction)stopTargetTimer:sender {
    [targetTimer invalidate];
    self.targetTimer = nil;
}

- (void)secondsFireMethod:(NSTimer*)theTimer {
 //   NSLog(@"Seconds Timer fire count %d", timerCount);
    timerCount++;
	[kvc updtSecs:timerCount];
}

@end
