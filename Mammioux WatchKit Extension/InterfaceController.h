//
//  InterfaceController.h
//  Mammioux WatchKit Extension
//
//  Created by Teresa Van Dusen on 5/5/15.
//  Copyright (c) 2015 mammioux. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (readwrite,nonatomic) BOOL leftHand;
@property (strong,nonatomic) NSDate *timeElapsed;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *handPic;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *timeLabel;

@end
