//
//  MTPocketTestsBugFixes.m
//  MTPocket
//
//  Created by Adam Kirk on 1/4/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTPocketTestsBugFixes.h"
#import "MTPocket.h"
#import "constants.h"
#import "macros.h"


@implementation MTPocketTestsBugFixes

//- (void)testEXC_BAD_ACCESS
//{
//    __block BOOL done = NO;;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        MTPocketResponse *response = [MTPocketRequest requestForURL:STITCHES_URL
//                                                             method:MTPocketMethodGET
//                                                             format:MTPocketFormatJSON
//                                                               body:nil].send;
//        [NSThread sleepForTimeInterval:1];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            STAssertTrue([response.body isKindOfClass:[NSArray class]], nil);
//            done = YES;
//        });
//    });
//
//    STALL(!done);
//}


@end
