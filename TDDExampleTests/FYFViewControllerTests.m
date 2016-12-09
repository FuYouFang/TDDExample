//
//  FYFViewControllerTests.m
//  TDDExample
//
//  Created by fuyoufang on 2016/12/8.
//  Copyright © 2016年 fyf. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FYFViewController.h"
#import <objc/runtime.h>

@interface FYFViewControllerTests : XCTestCase

@end

@implementation FYFViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - 属性

/**
 测试一个类是否包含相关属性
 */
- (void)testViewControllerHasATableViewProperty {
    objc_property_t tableViewProperty = class_getProperty([FYFViewController class], "tableView");
    XCTAssertTrue(tableViewProperty != NULL,
                  @"FYFViewController need a table view");
}

@end
