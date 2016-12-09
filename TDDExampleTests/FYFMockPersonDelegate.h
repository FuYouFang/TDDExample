//
//  FYFMockPersonDelegate.h
//  TDDExample
//
//  Created by fuyoufang on 2016/12/8.
//  Copyright © 2016年 fyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYFPerson.h"


/**
 伪造对象
 此类用来观察 Person 类是否在何时的地方通知了 delegate
 */
@interface FYFMockPersonDelegate : NSObject <FYFPersonDelegate>

@property (nonatomic, strong) FYFPerson *person;
@property (nonatomic, strong) NSError *workError;

@end
