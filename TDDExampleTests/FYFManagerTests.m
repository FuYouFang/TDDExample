//
//  FYFManagerTests.m
//  TDDExample
//
//  Created by fuyoufang on 2016/12/8.
//  Copyright © 2016年 fyf. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FYFPerson.h"
#import "FYFManager.h"
#import <objc/runtime.h>

static const char *FYFManagerTestsBeginWorkKey = "FYFManagerTestsBeginWorkKey";

@interface FYFPerson (TestSuperclassCalled)

@property (nonatomic, readonly) NSNumber *didCallSuperBeginWork;

@end

@implementation FYFPerson (TestSuperclassCalled)

- (void)managerTests_beginWork:(NSNotification *)notification {
    objc_setAssociatedObject(self, FYFManagerTestsBeginWorkKey, [NSNumber numberWithBool:YES],
                             OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)didCallSuperBeginWork {
    return objc_getAssociatedObject(self, FYFManagerTestsBeginWorkKey);
}

@end


@interface FYFManagerTests : XCTestCase

@end

@implementation FYFManagerTests
{
    FYFManager *manager;
}
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    manager = [[FYFManager alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testManagerCallSuperBeginWork {
    // 将类中的方法和分类中的方法对换
    Method testMethod = class_getInstanceMethod([FYFPerson class], @selector(managerTests_beginWork:));
    Method realMethod = class_getInstanceMethod([FYFPerson class], @selector(beginWork:));
    method_exchangeImplementations(realMethod, testMethod);

    [manager beginWork:nil];
    XCTAssertNotNil(manager.didCallSuperBeginWork,
                    @"manager should call super -beginWork:");
    
    // 调整回来
    method_exchangeImplementations(realMethod, testMethod);
}


@end
