//
//  FYFPersonTests.m
//  TDDExample
//
//  Created by fuyoufang on 2016/12/8.
//  Copyright © 2016年 fyf. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FYFPerson.h"
#import "FYFJob.h"
#import "FYFMockPersonDelegate.h"
#import "FYFInspectablePerson.h"
#import "FYFPerson+Tests.h"
#import <objc/runtime.h>

// 保存的网络数据
// 对于应用程序中需要获取网络数据的情况，采取的方法是复制一份数据，然后保存在本地，
// 而不是每次运行测试都通过 API 来调用。
// 这样就可以避免由于无法联网而带来的测试问题，而且避免了用的测试数据内容发生更改，
// 保证每次运行测试时数据的一致性。
// 测试用例的失败只应该由含有 bug 的代码造成，而不是应该受网络等因素的干扰。
static NSString *personJSON = @"{"
    @"\"name\":\"fuyoufang\""
@"}";

@interface FYFPersonTests : XCTestCase {
    FYFPerson *person;
    NSNotification *receiveNotification;
}

@end

@implementation FYFPersonTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    person = [[FYFPerson alloc] initWithName:@"fuyoufang"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveNotification:)
                                                 name:FYFPersonPostNotificationName
                                               object:nil];
}

- (void)didReceiveNotification:(NSNotification *)notification {
    receiveNotification = notification;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    person = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super tearDown];
}

#pragma mark - 类相关
/**
 测试某个类是否存在
 */
- (void)testPersonExits {
    XCTAssertNotNil(person, @"should be able to create a Person instance.");
}


#pragma merge - 初始化
/**
 1.测试某个类是否存在某个属性（通过初始化方法）
 2.经过初始化，相关属性是否被正确的初始化
 */
- (void)testPersonCanBeNamed {
    XCTAssertEqualObjects(person.name, @"fuyoufang",
                          @"the Model should have the name I gave it");
}

#pragma merge - 属性
/**
 测试某个类是否存在某个属性(通过设置方法)
 */
- (void)testPersonHasBirthday {
    NSDate *birthday = [NSDate date];
    person.birthday = birthday;
    XCTAssertEqualObjects(person.birthday, birthday, @"Person needs to provide its birthday.");
}

/**
 测试某个类的属性可以被设置
 */
- (void)testBirthdayCanBeSeted {
    NSDate *birthday = [NSDate date];
    XCTAssertNoThrow(person.birthday = birthday, @"Person's birthday can be setted.");
}

/**
 测试一个方法的返回的类型
 */
- (void)testForAListOfJobs {
    XCTAssertTrue([[person recentJobs] isKindOfClass:[NSArray class]],
                  @"person should provide a list of recent jobs.");
}


/**
 测试某个类经过初始化之后，相关属性是否正确
 */
- (void)testForInitiallyEmptyJobList {
    XCTAssertEqual([person recentJobs].count, 0,
                   @"No job added yet, count should be zero");
}


/**
 测试一个属性是否接收 nil
 */
- (void)testPersonAcceptsNilAsADelegate {
    XCTAssertNoThrow(person.delegate = nil,
                     @"It should be acceptable to use nil as a person's delegate.");
}

/**
 测试设置属性时是否对检测了有没有符合相关协议
 */
    - (void)testNonConformingObjectCannotBeDelegate {
        XCTAssertThrows(person.delegate = (id <FYFPersonDelegate>)[NSNull null],
                        @"NSNull should not be used as the delegate as doesn't "
                        @"comform to the delegate protocol");
    }

#pragma mark - 方法相关

/**
 方法执行后，数组个数是否变化
 */
- (void)testAddingAJobToTheList {
    FYFJob *job = [[FYFJob alloc] init];
    [person addJob:job];
    XCTAssertEqual([person recentJobs].count, 1,
                   @"Add a job, and the count of jobs should go up.");
}


/**
 方法执行后，数组是否排序
 */
- (void)testJobsAreListedByBeginDate {
    FYFJob *job1 = [[FYFJob alloc] init];
    job1.beginDate = [NSDate distantPast];
    
    FYFJob *job2 = [[FYFJob alloc] init];
    job2.beginDate = [NSDate distantFuture];
    
    [person addJob:job1];
    [person addJob:job2];
    
    NSArray *jobs = [person recentJobs];
    FYFJob *listedFirst = [jobs objectAtIndex:0];
    FYFJob *listedSecond = [jobs objectAtIndex:1];
    
    XCTAssertEqual([listedFirst.beginDate laterDate:listedSecond.beginDate],
                   listedFirst.beginDate,
                   @"The later question should appear first in the list.");
    
}

/**
 方法执行后，数组的个数是否超出限制
 */
- (void)testLimitOfThreeJobs {
    FYFJob *job = [[FYFJob alloc] init];
    for (NSInteger i = 0; i < 10; i++) {
        [person addJob:job];
    }
    
    XCTAssertTrue([person recentJobs].count <= FYFPersonJobsMaxNum,
                  @"there should never be more than three jobs.");
}


/**
 测试某种条件下 -compare 方法的正确性
 注意：要检测 -compare 方法是否具备对称性
 */
- (void)testEarlierBirthdayPersonComesAfterLater {
    person.birthday = [NSDate distantFuture];
    
    FYFPerson *otherPerson = [[FYFPerson alloc] initWithName:@"someOne"];
    otherPerson.birthday = [NSDate distantPast];
    
    XCTAssertEqual([person compare:otherPerson],
                   NSOrderedAscending,
                   @"");
    XCTAssertEqual([otherPerson compare:person],
                   NSOrderedDescending,
                   @"");
}

/**
 测试类在对应的事件发生之后通知了代理
 */
- (void)testErrorReturnedToDelegate {
    FYFMockPersonDelegate *delegate = [[FYFMockPersonDelegate alloc] init];
    person.delegate = delegate;
    NSError *error = [NSError errorWithDomain:@"test domain" code:0 userInfo:nil];
    [person workFailedWithError:error];
    XCTAssertEqual(delegate.workError,
                   error,
                   @"Delegate should get the error");
}


/**
 测试网络数据的相关方法
 将网络数据保存在本地，进行测试。
 */
- (void)testPersonCreatedFromJSON {
    person = [FYFPerson personWithJSON:personJSON error:nil];
    XCTAssertEqualObjects(person.name, @"fuyoufang",
                   @"Person created frome json be setted wrong name.");
}

/**
 测试受保护的属性是否正确
 通过建立一个具有数据探查功能的子类来帮助测试用例。
 */
- (void)testAgeBeSettedFromBirthday {
    FYFInspectablePerson *inspectablePerson = [[FYFInspectablePerson alloc] initWithName:@"fuyoufang"];
    
    NSDate *now = [NSDate date];
    NSDate *birthday = [now dateByAddingTimeInterval:-10 * 365 * 24 * 60 * 60];
    
    inspectablePerson.birthday = birthday;
    XCTAssertEqual(inspectablePerson.age, 10, "person's age be setted wrong after set birthday.");
}

/**
 测试是否发送了消息
 */
- (void)testPersonNotification {
    [person postNotification];
    XCTAssertEqualObjects(receiveNotification.name,
                          FYFPersonPostNotificationName,
                          @"Person should post a notification");
}

/**
 测试某个类在某种情况下是否执行了指定的方法
 */
    - (void)testPersonBeginWorkWhenGetNotifacation {
        objc_removeAssociatedObjects(person);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:FYFPersonGetNotificationName
                                                            object:nil];
        XCTAssertNotNil(person.receiveBeginWorkNotification,
                        @"person should get a notifacation.");
        objc_removeAssociatedObjects(person);
    }

@end
