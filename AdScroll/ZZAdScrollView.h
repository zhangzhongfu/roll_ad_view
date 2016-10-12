//
//  ZZAdScrollView.h
//  iOSWebApp
//

#import <UIKit/UIKit.h>
#import "ZZAdCirculatePlay.h"

@class ZZAdScrollView;

@protocol ZZAdScrollViewDelegate <NSObject>

- (void)adScrollPlay:(ZZAdScrollView *)adCirculate index:(NSInteger)index;

@end

@interface ZZAdScrollView : UIView

@property (nonatomic,strong) NSArray *adArray;
@property (nonatomic,weak) id<ZZAdScrollViewDelegate> delegate;
@property (nonatomic,assign) PageControlPosition position;

@end
