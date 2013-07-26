//
//  InfoViewController.h
//  knuzzle
//
//  Created by Teresa Rios-Van Dusen on 1/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoViewController : UIViewController <UIWebViewDelegate> {
	UIWebView *knuzzleSite;

}

@property (nonatomic,retain) IBOutlet UIWebView *knuzzleSite;
@end
