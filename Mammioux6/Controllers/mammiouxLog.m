//
//  knuzzleLog.m
//  knuzzle
//
//  Created by Teresa Rios-Van Dusen on 3/26/09.
//  Copyright 2009 __Mammioux__. All rights reserved.
//

#import "mammiouxLog.h"


@implementation mammiouxLog



+ (mammiouxLog *)sharedMammiouxLog {
    static mammiouxLog  *sharedMammiouxLog = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMammiouxLog = [[self alloc] init];
    });
    return sharedMammiouxLog;
}

- (id)init

{
    if ((self = [super init])) {
		//create array to keep log
		self->currentLog = [[NSMutableArray alloc] init];
		
        /* Check if log file already exists */
		// set logfile and write Start Feeding session entry
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *pathToLog = [documentsDirectory stringByAppendingPathComponent:@"mammioux.log"];
		if ([fileManager fileExistsAtPath:pathToLog] == NO) {
			[fileManager createFileAtPath:pathToLog	contents:nil attributes:nil];
		} else {
			//move current log to array, for browsing
			[self->currentLog addObjectsFromArray:[NSArray arrayWithContentsOfFile:pathToLog]];
		}
    }
	
    return self;
	
}

- (BOOL)flush {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
    if (!documentsDirectory) {
	   NSLog(@"Documents directory not found!");
	   return NO;
	}
	
    NSString *pathToLog = [documentsDirectory stringByAppendingPathComponent:@"mammioux.log"];
	
	return ([self->currentLog writeToFile:pathToLog atomically:YES]);
	
}
-(void) addToLog:(NSString *) line
{
	// format evt,date,time
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyyMMdd-HH:mm:ss"];
	NSDate *now = [NSDate date];
	NSString *formattedDateString = [dateFormatter stringFromDate:now];
	NSString *logLine = [NSString stringWithFormat:@"%@,%@",line,formattedDateString];
	[self->currentLog addObject:logLine];
	NSLog(@"Add Line: %@",logLine);
}


- (NSDate *)getLastTime 
{
	NSDate *formatterDate;
	

	if ([self->currentLog count] >0 )
	{
		NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
		[inputFormatter setDateFormat:@"yyyyMMdd-HH:mm:ss"];

		NSString *lastLine = [self->currentLog objectAtIndex:[self->currentLog count]-1];	
		NSArray *listItems = [lastLine componentsSeparatedByString:@","];
		formatterDate = [inputFormatter dateFromString:[listItems objectAtIndex: 1]];
	}
	else
	{
		formatterDate = [NSDate date];
	}
	return formatterDate;
}

-(BOOL)clean {
    [self->currentLog removeAllObjects];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        return NO;
	}
	
    NSString *pathToLog = [documentsDirectory stringByAppendingPathComponent:@"mammioux.log"];
    
    if ([fileManager fileExistsAtPath:pathToLog] == YES) {
        NSError *error = NULL;
        if ([fileManager removeItemAtPath:pathToLog  error:&error]){
            return YES;
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
            return NO;
        }
    } 
    return NO;
}

- (int)count{
    return self->currentLog.count;
}

- (NSString *)objectAtIndex:(NSUInteger) index{
    return [currentLog objectAtIndex:index];
}

@end
