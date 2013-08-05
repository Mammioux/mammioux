//
//  NumericCell.m
//  Mammioux6
//
//  Created by Teresa Van Dusen on 7/30/13.
//  Copyright (c) 2013 mammioux. All rights reserved.
//

#import "NumericCell.h"

@interface NumericCell ()

@end

@implementation NumericCell


- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
        // custom code here
    }
    
    return self;

}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        _entryValue.hidden = NO;                
        self.detail.hidden = YES;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == _entryValue){
		// the user pressed the "Done" button, so dismiss the keyboard
		
        self.detail.text = self.entryValue.text;
		[[NSUserDefaults standardUserDefaults] setInteger:[self.detail.text intValue] forKey:self.settingKey];
	}
	[textField resignFirstResponder];
    _entryValue.hidden = YES;
    self.detail.hidden = NO;
	return YES;
}

@end
