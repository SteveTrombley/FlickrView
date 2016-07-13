//
//  ViewController.h
//  WHOOP
//
//  Created by Steve Trombley on 9/16/15.
//  Copyright (c) 2015 Steve Trombley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrKit.h"
#import "Downloadmanager.h"
#import "Photo.h"

typedef void (^SearchCompletionBlock)(NSString *searchTerm, NSArray *results, NSError *error);
typedef void (^PhotoCompletionBlock)(UIImage *photoImage, NSError *error);


@interface PhotoViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (nonatomic, strong) DownloadManager *downloadManager;
@property (nonatomic, retain) FKFlickrNetworkOperation *recentPhotosOp;
@property (nonatomic, retain) FKFlickrNetworkOperation *flickrSearchOp;
@property (strong, nonatomic) NSMutableArray *photosToDisplay;
 

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong , nonatomic) Photo *photoToShow;


@end

