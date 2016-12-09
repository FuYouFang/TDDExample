//
//  FYFPerson.h
//  TDDExample
//
//  Created by fuyoufang on 2016/12/8.
//  Copyright © 2016年 fyf. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger const FYFPersonJobsMaxNum;
extern NSString * const FYFPersonPostNotificationName;
extern NSString * const FYFPersonGetNotificationName;

@class FYFJob;
@class FYFPerson;

@protocol FYFPersonDelegate <NSObject>

- (void)didFinishWorkOfPerson:(FYFPerson *)person;
- (void)person:(FYFPerson *)person workFailedWithError:(NSError *)error;

@end

@interface FYFPerson : NSObject <NSURLSessionDelegate>
{
@protected
    NSInteger age;
}

@property (readonly) NSString *name;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, weak) id<FYFPersonDelegate> delegate;

- (instancetype)initWithName:(NSString *)name;
+ (instancetype)personWithJSON:(NSString *)JSON error:(NSError *)error;

- (NSArray<FYFJob *> *)recentJobs;
- (void)addJob:(FYFJob *)job;

- (NSComparisonResult)compare:(FYFPerson *)otherPerson;

- (void)beginWork:(NSNotification *)notification;
- (void)finishWork;
- (void)workFailedWithError:(NSError *)error;

- (void)postNotification;


@end
