//
//  PhotoCell.h
//  FlickrView
//
//  Created by Steve Trombley on 9/16/15.
//  Copyright (c) 2015 Steve Trombley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Photo;

@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) Photo *photo;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@end
