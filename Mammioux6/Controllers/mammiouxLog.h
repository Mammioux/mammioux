//
//  knuzzleLog.h
//  knuzzle
//
//  Created by Teresa Rios-Van Dusen on 3/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface mammiouxLog : NSObject {
    NSMutableArray *currentLog;
}


+(mammiouxLog *)sharedMammiouxLog;

- (void)addToLog:(NSString *) line; 
- (NSDate *)getLastTime;
- (NSString *)objectAtIndex:(NSUInteger)index;
- (BOOL)flush;
- (BOOL)clean;
- (int)count;
@end
