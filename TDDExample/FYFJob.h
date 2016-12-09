//
//  FYFJob.h
//  TDDExample
//
//  Created by fuyoufang on 2016/12/8.
//  Copyright © 2016年 fyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYFJob : NSObject

@property (nonatomic, strong) NSDate *beginDate;

- (NSComparisonResult)compare:(FYFJob *)otherJob;

@end
