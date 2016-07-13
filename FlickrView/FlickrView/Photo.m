//
//  FlickrPhoto.m
//  Flickr Search
//
//  Created by Brandon Trebitowski on 6/28/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import "Photo.h"

@implementation Photo
@synthesize thumbnail,thumbnailUrl, largeImage, largeImageUrl;

- (BOOL)hasImage {
    return thumbnail != nil;
}

- (BOOL)isFailed {
    return _failed;
}

@end
