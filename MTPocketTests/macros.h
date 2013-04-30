//
//  macros.h
//  MTPocket
//
//  Created by Adam Kirk on 12/19/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#define STALL(c)    while (c) { [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.5]]; }
#define MAKE_URL(p) @"http://button.herokuapp.com" p