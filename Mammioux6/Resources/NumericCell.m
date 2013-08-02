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


//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//   if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        // Custom initialization
//        // initializes label with setting variable name
//        // initializes text field with value and protected
//       NSLog(@"Initialize Numeric Cell");
//       self.entryValue.text = self.detailTextLabel.text;
//       self.detail.text = self.detailTextLabel.text;
//       _entryValue.textColor = [UIColor yellowColor];
//       _entryValue.backgroundColor = [UIColor redColor];
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"Initializing cell with Coder");
    if (self = [super initWithCoder:aDecoder]) {
        // custom code here
    }
    
    return self;

}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        NSLog(@"Entering Edit mode for numeric cells");
        _entryValue.hidden = NO;                
        self.detail.hidden = YES;
    } else {
        NSLog(@"Leaving Editing mode");
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
        
        NSLog(@"Save value entered");
		
        self.detail.text = self.entryValue.text;
		[[NSUserDefaults standardUserDefaults] setInteger:[self.detail.text intValue] forKey:self.settingKey];
	}
	[textField resignFirstResponder];
    _entryValue.hidden = YES;
    self.detail.hidden = NO;
	return YES;
}

@end
