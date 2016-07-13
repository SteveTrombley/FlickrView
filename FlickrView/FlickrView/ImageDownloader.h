//
//  ImageDownloader.h
//  WHOOP
//
//  Created by Steve Trombley on 9/16/15.
//  Copyright (c) 2015 Steve Trombley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"


@protocol ImageDownloaderDelegate;

@interface ImageDownloader : NSOperation

@property (nonatomic, assign) id <ImageDownloaderDelegate> delegate;
@property (nonatomic, readonly, strong) NSIndexPath *indexPathInCollectionView;
@property (nonatomic, readonly, strong) Photo *photo;


- (id)initWithPhotoRecord:(Photo *)photo atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>)theDelegate;
@end


@protocol ImageDownloaderDelegate <NSObject>

- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader;
@end