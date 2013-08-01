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

+ (NSString *) identifier { return NSStringFromClass([self class]); }

+ (NSString *) nibName { return NSStringFromClass([self class]); }

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
        self.entryValue = [[UITextField alloc] init];
    }
    
    return self;

}

-(void) awakeFromNib {
    NSLog(@"Awake From Nib");
    self.entryValue.text = self.detailTextLabel.text;
    self.detail.text = self.detailTextLabel.text;
    _entryValue.textColor = [UIColor yellowColor];
    _entryValue.backgroundColor = [UIColor redColor];


    [super awakeFromNib];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        NSLog(@"Entering Edit mode for numeric cells");
        _entryValue.hidden = NO;                
        self.detail.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setInteger:[self.detailTextLabel.text intValue] forKey:@"feedingsDay"];        
    } else {
        NSLog(@"Leaving Editing mode");
        _entryValue.hidden = YES;
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
		
		self.detailTextLabel.text = self.entryValue.text;
        self.detail.text = self.entryValue.text;
		[[NSUserDefaults standardUserDefaults] setInteger:[self.detailTextLabel.text intValue] forKey:@"feedingsDay"];
	}
	[textField resignFirstResponder];
    [self setEditing:NO animated:YES];
    [self setHighlighted:NO];
	return YES;	
}

@end
