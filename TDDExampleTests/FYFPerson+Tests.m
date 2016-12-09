//
//  FYFPerson+Tests.m
//  TDDExample
//
//  Created by fuyoufang on 2016/12/8.
//  Copyright © 2016年 fyf. All rights reserved.
//

#import "FYFPerson+Tests.h"
#import <objc/runtime.h>

static const char *beginWorkNotificationKey = "FYFPersonBeginWorkNotificationKey";

@implementation FYFPerson (Tests)

- (NSNotification *)receiveBeginWorkNotification {
    return objc_getAssociatedObject(self, beginWorkNotificationKey);
}

- (void)beginWork:(NSNotification *)notification {
    objc_setAssociatedObject(self, beginWorkNotificationKey, notification, OBJC_ASSOCIATION_RETAIN);
}

@end
