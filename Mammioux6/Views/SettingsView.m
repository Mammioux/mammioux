//
//  SettingsView.m
//  Mammioux6
//
//  Created by Teresa Van Dusen on 8/1/13.
//  Copyright (c) 2013 mammioux. All rights reserved.
//

#import "SettingsView.h"

@implementation SettingsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier {
    NSLog(@"Registering cell of type:%@",identifier);
}

@end
