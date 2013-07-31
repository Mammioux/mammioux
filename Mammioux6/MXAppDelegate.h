//
//  MXAppDelegate.h
//  Mammioux6
//
//  Created by Teresa Van Dusen on 7/26/13.
//  Copyright (c) 2013 mammioux. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MammiouxViewController;
@class SettingsViewController;
@class InfoViewController;

@interface MXAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;


// this is the MAIN navigation controller for the entire application
// and will hold all of the main page controllers.
@property (strong, nonatomic)NSMutableDictionary *settings;

@property (nonatomic, retain) MammiouxViewController *myVC;
@property (nonatomic, retain) SettingsViewController *settingsVC;
@property (nonatomic, retain) InfoViewController *infoVC;



@end
