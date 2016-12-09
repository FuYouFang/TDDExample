//
//  FYFPerson.m
//  TDDExample
//
//  Created by fuyoufang on 2016/12/8.
//  Copyright © 2016年 fyf. All rights reserved.
//

#import "FYFPerson.h"
#import "FYFJob.h"
#import <objc/runtime.h>

NSInteger const FYFPersonJobsMaxNum = 3;

NSString * const FYFPersonPostNotificationName = @"FYFPersonPostNotificationName";
NSString * const FYFPersonGetNotificationName = @"FYFPersonGetNotificationName";

@implementation FYFPerson
{
    NSMutableArray<FYFJob *> *jobs;
}

@synthesize name;

- (void)ttt {
    NSLog(@"ttt");
}
- (instancetype)initWithName:(NSString *)newName {
    if (self = [super init]) {
        name = [newName copy];
        jobs = [NSMutableArray array];
        age = NSNotFound;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginWork:) name:FYFPersonGetNotificationName object:nil];
    }
    return self;
}


+ (instancetype)personWithJSON:(NSString *)JSON error:(NSError *)error {
    NSParameterAssert(JSON != nil);
    
    NSData *unicodeNotation = [JSON dataUsingEncoding:NSUTF8StringEncoding];
    NSError *localError;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:unicodeNotation options:0 error:&localError];
    NSDictionary *parsedObject = (id)jsonObject;
    if (parsedObject == nil) {
        if (error != nil) {
            error = [NSError errorWithDomain:@"TDDExample" code:0 userInfo:nil];
        }
        return nil;
    }
    
    NSString *name = [parsedObject objectForKey:@"name"];
    return [[FYFPerson alloc] initWithName:name];
}


- (void)setDelegate:(id<FYFPersonDelegate>)delegate {
    if (delegate && ![delegate conformsToProtocol:@protocol(FYFPersonDelegate)]) {
        [[NSException exceptionWithName:NSInvalidArgumentException
                                 reason:@"Delegate object does not conform to the deletate protocol"
                               userInfo:nil] raise];
    }
    _delegate = delegate;
}

- (void)setBirthday:(NSDate *)birthday {
    _birthday = birthday;
    if (birthday) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger birthdayYear = [calendar component:NSCalendarUnitYear fromDate:birthday];
        
        NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
        
        age = nowYear - birthdayYear;
    } else {
        age = NSNotFound;
    }
}

- (NSArray *)recentJobs {
    return [jobs copy];
}

- (void)addJob:(FYFJob *)job {
    [jobs addObject:job];
        
    [jobs sortUsingSelector:@selector(compare:)];

    while (jobs.count > FYFPersonJobsMaxNum) {
        [jobs removeLastObject];
    }
}

- (NSComparisonResult)compare:(FYFPerson *)otherPerson {
    if (self.birthday && otherPerson.birthday) {
        NSComparisonResult result = [self.birthday compare:otherPerson.birthday];
        if (result == NSOrderedSame) {
            return result;
        } else if (result == NSOrderedDescending) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    } else if (self.birthday) {
        return NSOrderedAscending;
    } else if (otherPerson.birthday) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

- (void)beginWork:(NSNotification *)notification {
    // do something...
    NSLog(@"%@", notification);
}

- (void)workFailedWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(person:workFailedWithError:)]) {
        [self.delegate person:self workFailedWithError:error];
    }
}

- (void)finishWork {
    if ([self.delegate respondsToSelector:@selector(didFinishWorkOfPerson:)]) {
        [self.delegate didFinishWorkOfPerson:self];
    }
}

- (void)postNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:FYFPersonPostNotificationName
                                                        object:nil];
}

@end
