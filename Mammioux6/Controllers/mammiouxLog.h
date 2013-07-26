//
//  knuzzleLog.h
//  knuzzle
//
//  Created by Teresa Rios-Van Dusen on 3/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface mammiouxLog : NSObject {
	NSString *pathToLog;
	NSMutableArray *currentLog;
	NSDate *currentTime;

}
@property(nonatomic, retain) NSString *pathToLog;
@property(nonatomic, retain) NSMutableArray *currentLog;

- (void)addToLog:(NSString *) line; 
- (NSDate *)getLastTime;
- (BOOL)flush;
@end
