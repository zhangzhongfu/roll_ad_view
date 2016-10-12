//
//  ZZAdCirculatePlay.h
//  iOSWebApp
//

#import <UIKit/UIKit.h>
@class ZZAdCirculatePlay;

typedef NS_ENUM(NSInteger, PageControlPosition) {
    PageControlPositionLeft,
    PageControlPositionCenter,
    PageControlPositionRight
};

@protocol ZZAdCirculatePlayDelegate <NSObject>

@optional
- (void)adCirculatePlay:(ZZAdCirculatePlay *)adCirculate didClickIndex:(NSInteger)index;
- (void)adCirculatePlay:(ZZAdCirculatePlay *)adCirculate didScrollIndex:(NSInteger)index;

@end

@interface ZZAdCirculatePlay : UIView

@property (nonatomic,weak) id<ZZAdCirculatePlayDelegate> delegate;
@property (nonatomic,strong) NSArray *adArray;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,assign) BOOL isPageHiden;
@property (nonatomic,assign) BOOL isScrollEnabled;

@property (nonatomic,assign) PageControlPosition position;

@end
