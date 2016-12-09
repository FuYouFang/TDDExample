//
//  FYFMockPersonDelegate.m
//  TDDExample
//
//  Created by fuyoufang on 2016/12/8.
//  Copyright © 2016年 fyf. All rights reserved.
//

#import "FYFMockPersonDelegate.h"

@implementation FYFMockPersonDelegate

- (void)didFinishWorkOfPerson:(FYFPerson *)person {
    self.person = person;
}

- (void)person:(FYFPerson *)person workFailedWithError:(NSError *)error {
    self.person = person;
    self.workError = error;
}

@end
