//
//  InterfaceController.m
//  Mammioux WatchKit Extension
//
//  Created by Teresa Van Dusen on 5/5/15.
//  Copyright (c) 2015 mammioux. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    NSLog(@"Watch Interface controller");
    [self.timeLabel setText: [NSDate date].description];
    [self.handPic setImage:[UIImage imageNamed:@"RIght_Hand.png" ]];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



