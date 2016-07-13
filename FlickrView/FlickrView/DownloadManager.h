//
//  DownloadManager.h
//  FlickrView//
//  Created by Steve Trombley on 9/16/15.
//  Copyright (c) 2015 Steve Trombley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject

@property (strong, nonatomic) NSMutableDictionary *downloadsInProgress;
@property (strong, nonatomic) NSOperationQueue *downloadQueue;

@end
