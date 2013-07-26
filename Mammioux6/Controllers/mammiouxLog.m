//
//  knuzzleLog.m
//  knuzzle
//
//  Created by Teresa Rios-Van Dusen on 3/26/09.
//  Copyright 2009 __Mammioux__. All rights reserved.
//

#import "mammiouxLog.h"


@implementation mammiouxLog
@synthesize pathToLog;
@synthesize currentLog;

- (id)init

{
	NSLog(@"Initializing Log");
    if ((self = [super init])) {
		//create array to keep log
		currentLog = [[NSMutableArray alloc] init];
		
        /* Check if log file already exists */
		// set logfile and write Start Feeding session entry
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		pathToLog = [documentsDirectory stringByAppendingPathComponent:@"knuzzle.log"];	
		if ([fileManager fileExistsAtPath:pathToLog] == NO) {
			[fileManager createFileAtPath:pathToLog	contents:nil attributes:nil];
		} else {
			//move current log to array, for browsing
			[currentLog addObjectsFromArray:[NSArray arrayWithContentsOfFile:pathToLog]];
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
	
    pathToLog = [documentsDirectory stringByAppendingPathComponent:@"knuzzle.log"];	
	
	return ([currentLog writeToFile:pathToLog atomically:YES]);
	
}
-(void) addToLog:(NSString *) line
{
	// format evt,date,time
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyyMMdd-HH:mm:ss"];
	NSDate *now = [NSDate date];
	NSString *formattedDateString = [dateFormatter stringFromDate:now];
	NSString *logLine = [NSString stringWithFormat:@"%@,%@",line,formattedDateString];
	[currentLog addObject:logLine];
	NSLog(@"Add Line: %@",logLine);
}
- (NSDate *)getLastTime 
{
	NSDate *formatterDate;
	

	if ([currentLog count] >0 )
	{
		NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
		[inputFormatter setDateFormat:@"yyyyMMdd-HH:mm:ss"];

		NSString *lastLine = [currentLog objectAtIndex:[currentLog count]-1];	
		NSArray *listItems = [lastLine componentsSeparatedByString:@","];
		formatterDate = [inputFormatter dateFromString:[listItems objectAtIndex: 1]];
	}
	else
	{
		formatterDate = [NSDate date];
	}
	return formatterDate;
}

-(NSString *) placeHolder 
{	
	currentTime = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *formattedDateString = [dateFormatter stringFromDate:currentTime];
	NSLog(@"formattedDateString: %@", formattedDateString);
	NSLog(@"Testing %@",currentTime.description);
	return formattedDateString;
}
@end
