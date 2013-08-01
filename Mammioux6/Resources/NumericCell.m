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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Custom initialization
        // initializes label with setting variable name
        // initializes text field with value and protected
       NSLog(@"Initialize Numeric Cell");
       self.entryValue.text = self.detailTextLabel.text;
       _entryValue.textColor = [UIColor yellowColor];
       _entryValue.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        NSLog(@"Entering Edit mode for numeric cells");
        _entryValue.hidden = NO;                
        self.detail.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setInteger:[self.detailTextLabel.text intValue] forKey:@"feedingsDay"];        
    } else {
        _entryValue.hidden = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == _entryValue){
		// the user pressed the "Done" button, so dismiss the keyboard
		
		self.detailTextLabel.text = _entryValue.text;
		[[NSUserDefaults standardUserDefaults] setInteger:[self.detailTextLabel.text intValue] forKey:@"feedingsDay"];
	}
	[textField resignFirstResponder];
	return YES;	
}

@end
