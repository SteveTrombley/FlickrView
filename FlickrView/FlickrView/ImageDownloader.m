//
//  ImageDownloader.m
//  WHOOP
//
//  Created by Steve Trombley on 9/16/15.
//  Copyright (c) 2015 Steve Trombley. All rights reserved.
//

#import "ImageDownloader.h"
#import "Photo.h"


@interface ImageDownloader ()
@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInCollectionView;
@property (nonatomic, readwrite, strong) Photo *photo;

@end

//**************************************************************************************
// NSoperation for downloading photo
//**************************************************************************************


@implementation ImageDownloader

@synthesize delegate = _delegate;
@synthesize indexPathInCollectionView = _indexPathInTableView;
@synthesize photo = _photo;

- (id)initWithPhotoRecord:(Photo *)photo atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>)theDelegate {

    if (self = [super init]) {

        self.delegate = theDelegate;
        self.indexPathInCollectionView = indexPath;
        self.photo = photo;
    }
    return self;
};



- (void)main {


    @autoreleasepool {

        if (self.isCancelled)
            return;
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.photo.thumbnailUrl];
        if (self.isCancelled) {
            imageData = nil;
            return;
        }
        if (imageData) {
             UIImage *thumbnailImage = [UIImage imageWithData:imageData];
            self.photo.thumbnail= thumbnailImage;

        }
        else {
            self.photo.failed = YES;
        }
        imageData = nil;

        if (self.isCancelled)
            return;

        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];

    }
}

@end

