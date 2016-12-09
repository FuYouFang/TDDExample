//
//  FYFJob.m
//  TDDExample
//
//  Created by fuyoufang on 2016/12/8.
//  Copyright © 2016年 fyf. All rights reserved.
//

#import "FYFJob.h"

@implementation FYFJob

- (NSComparisonResult)compare:(FYFJob *)otherJob {
    if (self.beginDate && otherJob.beginDate) {
        NSComparisonResult result = [self.beginDate compare:otherJob.beginDate];
        if (result == NSOrderedSame) {
            return result;
        } else if (result == NSOrderedDescending) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    } else if (self.beginDate) {
        return NSOrderedAscending;
    } else if (otherJob.beginDate) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
    
    
}
@end
