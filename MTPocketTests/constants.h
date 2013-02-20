//
//  constants.h
//  MTPocket
//
//  Created by Adam Kirk on 12/14/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#ifndef MTPocket_constants_h
#define MTPocket_constants_h

#define UN @"username"
#define PW @"password"
#define BASE_URL            @"http://button.herokuapp.com"
#define BAD_PATH            @"notfound"
#define DOWNLOAD_FILE_URL   [NSURL URLWithString:@"http://download.thinkbroadband.com/5MB.zip"]
#define UPLOAD_FILE_URL     [NSURL URLWithString:@"http://jquery-file-upload.appspot.com/"]
#define MANAGER             [NSFileManager defaultManager]
#define DOCS_DIR            [[[MANAGER URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path]

#endif
