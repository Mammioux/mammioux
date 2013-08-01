//
//  NumericCell.h
//  Mammioux6
//
//  Created by Teresa Van Dusen on 7/30/13.
//  Copyright (c) 2013 mammioux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumericCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UITextField *entryValue;
@property (nonatomic, retain) IBOutlet UILabel *entrySetValue;

@end
