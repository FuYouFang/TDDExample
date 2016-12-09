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

@end

@implementation FYFPerson (TestSuperclassCalled)

- (void)managerTests_beginWork:(NSNotification *)notification {
    objc_setAssociatedObject(self, FYFManagerTestsBeginWorkKey, [NSNumber numberWithBool:YES],
                             OBJC_ASSOCIATION_RETAIN);
}

+ (void)load {
    Method testMethod = class_getInstanceMethod([FYFPerson class], @selector(managerTests_beginWork:));
    Method realMethod = class_getInstanceMethod([FYFPerson class], @selector(beginWork:));
    method_exchangeImplementations(realMethod, testMethod);
    
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
    
    FYFPerson *person = [[FYFPerson alloc] init];
    [person beginWork:nil];
    
    [manager beginWork:nil];
    XCTAssertNotNil(objc_getAssociatedObject(manager, FYFManagerTestsBeginWorkKey),
                    @"manager should call super -beginWork:");
    
    
    //method_exchangeImplementations(realMethod, testMethod);
}


@end
