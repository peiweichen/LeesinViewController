//
//  ViewController.m
//  newInput
//
//  Created by chenpeiwei on 1/4/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import "LeesinViewController.h"

#import <Photos/Photos.h>
#import "Masonry.h"
#import "SwipeView.h"
#import "LeesinTextInputBar.h"
#import "LeesinBottomBar.h"
#import "LeesinAssetCell.h"
#import "LeesinMissionCell.h"
#import "PHAsset+Addition.h"
#import "LeesinPreviewBar.h"
typedef NS_ENUM(NSUInteger, PIESwipeViewResueViewType) {
    PIESwipeViewResueViewTypeMission,
    PIESwipeViewResueViewTypePhoto,
};
@interface LeesinViewController ()

@property (nonatomic, strong) LeesinBottomBar *toolBar;
@property (nonatomic, strong) LeesinPreviewBar *previewBar;
@property (nonatomic, strong) MASConstraint *previewBarMarginBC;
@property (nonatomic, assign) BOOL photosIsReady;

@end

@interface LeesinViewController ()
@property (nonatomic, strong) LeesinTextInputBar* bar;
@property (nonatomic, strong) MASConstraint *inputBarHC;
@property (nonatomic, strong) MASConstraint *inputbarBottomMarginHC;
@end

@interface LeesinViewController ()<SwipeViewDataSource,SwipeViewDelegate>
@property (nonatomic, strong) SwipeView *swipeView;
//@property (nonatomic, assign) BOOL allowMultipleSelection;
@property (nonatomic, strong) NSMutableOrderedSet *sourceMissions;
@property (nonatomic, strong) NSMutableOrderedSet *sourceAssets;
@property (nonatomic, strong) NSMutableOrderedSet *selectedAssets;
@property (nonatomic, assign) NSInteger selectedIndexOfMission;
@end


@implementation LeesinViewController

#pragma mark - Initilization

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setModalPresentationStyle:UIModalPresentationOverFullScreen];
    }
    return self;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupViews];
    [self setupTapEvents];
    [self registerObservers];
    
}

-(void)dealloc {
    [self unRegisterObervers];
}


#pragma mark - Setups

- (void)setupData {
    _selectedAssets = [NSMutableOrderedSet orderedSet];
    _sourceAssets   = [NSMutableOrderedSet orderedSet];
    _sourceMissions = [NSMutableOrderedSet orderedSet];
    _selectedIndexOfMission = NSNotFound;
    [self setupPhotoSourceData];
}

- (void)setupViews {
    [self.view addSubview:self.bar];
    [self.view addSubview:self.swipeView];
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.previewBar];
    [self.view sendSubviewToBack:self.previewBar];
    [self setupViewContraints];
}


- (void)setupTapEvents {
    [self.bar.leftButton1 addTarget:self action:@selector(textInputBar_TapOnleftButton1:) forControlEvents:UIControlEventTouchDown];
    [self.bar.leftButton2 addTarget:self action:@selector(textInputBar_TapOnleftButton2:) forControlEvents:UIControlEventTouchDown];
    [self.bar.rightButton addTarget:self action:@selector(textInputBar_TapOnRightButton:) forControlEvents:UIControlEventTouchDown];
    
    [self.toolBar.button_confirm addTarget:self action:@selector(bottomToolBar_tapOnConfirmButton:) forControlEvents:UIControlEventTouchDown];
    UITapGestureRecognizer* tapGesure1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnView:)];
    [self.view addGestureRecognizer:tapGesure1];
}
- (void)setupViewContraints {
    
    [self.previewBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@38);
        self.previewBarMarginBC =  make.bottom.equalTo(self.bar.mas_top).with.offset(38);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
    }];

    [self.bar mas_makeConstraints:^(MASConstraintMaker *make) {
        _inputBarHC  = make.height.equalTo(@(self.bar.appropriateHeight));
        _inputbarBottomMarginHC = make.bottom.equalTo(self.view).with.offset(-230);
        make.leading.equalTo(self.view).with.offset(0);
        make.trailing.equalTo(self.view);
        
    }];
    
    [self.swipeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bar.mas_bottom).with.priorityHigh();
//        make.height.equalTo(@200);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.toolBar.mas_top);
    }];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).with.offset(0);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@45);
        make.top.equalTo(self.swipeView.mas_bottom);
        make.bottom.equalTo(self.view).with.priorityHigh();
    }];
}

- (void)setupPhotoSourceData {
    // Fetch user albums and smart albums
    PHFetchResult *smartAlbum =    [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    
    [smartAlbum enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
        [fetchResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            [_sourceAssets addObject:asset];
        }];
    }];
}

#pragma mark - NSNotificationCenter register/unregister

- (void)registerObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tupai_didChangeTextViewText:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pie_willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pie_willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pie_didShowOrHideKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pie_didShowOrHideKeyboard:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)unRegisterObervers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:NULL];
}




#pragma mark - Tap Actions

- (void) tapOnView:(UIGestureRecognizer*)sender {
    
    if ([self.view hitTest:[sender locationInView:self.view] withEvent:nil] == self.view )  {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)textInputBar_TapOnleftButton1:(id)sender {
    if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
        return;
    }
    self.bar.buttonType = LeesinTextInputBarButtonTypeMission;
    self.toolBar.type = LeeSinBottomBarTypeMission;
    [self.swipeView reloadData];
}

- (void)textInputBar_TapOnleftButton2:(id)sender {
    
    if (self.bar.buttonType == LeesinTextInputBarButtonTypePhoto) {
        return;
    }
    
    if (self.type == LeesinViewControllerTypeAsk) {
        self.toolBar.type = LeeSinBottomBarTypeAsk;
    } else if (self.type == LeesinViewControllerTypeReply) {
        self.toolBar.type = LeeSinBottomBarTypeReply;
    }
    self.bar.buttonType = LeesinTextInputBarButtonTypePhoto;
    
    [self.swipeView reloadData];
}

- (void)textInputBar_TapOnRightButton:(id)sender {
    
    
}

- (void)bottomToolBar_tapOnConfirmButton:(id)sender {
    self.photosIsReady = YES;
    [self.toolBar.button_confirm setTitle:@"取消" forState:UIControlStateNormal];
    self.toolBar.button_confirm.alpha = 0.5;
    [self togglePreviewBar];
}

#pragma mark - Get and Set

-(LeesinTextInputBar *)bar {
    if (!_bar) {
        _bar = [LeesinTextInputBar new];
    }
    return _bar;
}
-(LeesinPreviewBar *)previewBar {
    if (!_previewBar) {
        _previewBar = [LeesinPreviewBar new];
    }
    return _previewBar;
}
-(void)setType:(LeesinViewControllerType)type {
    _type = type;
    
    if (type == LeesinViewControllerTypeAsk) {
        self.bar.type = LeesinTextInputBarTypeAsk;
        self.toolBar.type = LeeSinBottomBarTypeAsk;
        self.bar.buttonType = LeesinTextInputBarButtonTypePhoto;
    } else if (type == LeesinViewControllerTypeReply) {
        self.bar.type = LeesinTextInputBarTypeReply;
        if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
            self.toolBar.type = LeeSinBottomBarTypeMission;
        } else if (self.bar.buttonType == LeesinTextInputBarButtonTypePhoto) {
            self.toolBar.type = LeeSinBottomBarTypeReply;
        }
    }
}

-(SwipeView *)swipeView {
    if (!_swipeView) {
        _swipeView = [SwipeView new];
        _swipeView.dataSource = self;
        _swipeView.delegate  = self;
        _swipeView.backgroundColor = [UIColor groupTableViewBackgroundColor];//EEEEEE
        _swipeView.scrollEnabled = YES;
        _swipeView.alignment = SwipeViewAlignmentEdge;
        _swipeView.pagingEnabled = NO;
    }
    return _swipeView;
}
-(LeesinBottomBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [LeesinBottomBar new];
    }
    return _toolBar;
}


#pragma mark - Notification Events

- (void)tupai_didChangeTextViewText:(id)sender {

    if (![[sender object] isEqual: self.bar.textView]) {
        return;
    }
    if (self.bar.frame.size.height != self.bar.appropriateHeight) {
        [self.inputBarHC setOffset:self.bar.appropriateHeight];
    }
}

- (void) pie_willShowKeyboard:(NSNotification*)notification {
    [_inputbarBottomMarginHC setOffset:-[self pie_appropriateKeyboardHeightFromNotification:notification]];
}
- (void) pie_willHideKeyboard:(NSNotification*)notification {
    [_inputbarBottomMarginHC setOffset:-230];
}

- (void) pie_didShowOrHideKeyboard:(NSNotification*)notification {
    
}


#pragma mark - Custom Functions


- (CGFloat)pie_appropriateKeyboardHeightFromNotification:(NSNotification *)notification
{
    
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    return [self pie_appropriateKeyboardHeightFromRect:keyboardRect];
}
- (CGFloat)pie_appropriateKeyboardHeightFromRect:(CGRect)rect
{
    CGRect keyboardRect = [self.view convertRect:rect fromView:nil];
    
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat keyboardMinY = CGRectGetMinY(keyboardRect);
    
    CGFloat keyboardHeight = MAX(0.0, viewHeight - keyboardMinY);
    
    return keyboardHeight;
}

- (id)pie_getSubviewAsClass:(Class)class fromView:(UIView*)view {
    for (UIView* subview in view.subviews) {
        if ([subview isKindOfClass:class]) {
            return subview;
        }
    }
    return nil;
}

#pragma mark - SwipeView Datasource and Delete


-(NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
        _sourceMissions = _sourceAssets;
        return _sourceMissions.count;
    }
    else if (self.bar.buttonType == LeesinTextInputBarButtonTypePhoto)
    {
        return _sourceAssets.count;
    }
    return 0;
}

-(UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    
    if (self.bar.buttonType == LeesinTextInputBarButtonTypePhoto) {
        CGFloat ratio = 270.0/405.0;
        CGFloat height = swipeView.frame.size.height;
        CGFloat width = height*ratio;
        
        if (!view || view.tag != PIESwipeViewResueViewTypePhoto ) {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width+5, height)];
            view.tag = PIESwipeViewResueViewTypePhoto;
            LeesinAssetCell* cell = [[LeesinAssetCell alloc]initWithFrame:view.bounds];
            [view addSubview:cell];
        }
        
        LeesinAssetCell *cell = [self pie_getSubviewAsClass:[LeesinAssetCell class] fromView:view];;
        CGFloat height_image    = cell.imageView.frame.size.height * [[UIScreen mainScreen] scale];
        CGFloat width_image     = cell.imageView.frame.size.width  * [[UIScreen mainScreen] scale];
        
        PHImageManager *imageManager = [PHImageManager defaultManager];
        PHAsset *currentAsset = [_sourceAssets objectAtIndex:index];
        cell.selected = currentAsset.selected;
        [imageManager requestImageForAsset:currentAsset
                                targetSize:CGSizeMake(width_image,height_image)
                               contentMode:PHImageContentModeDefault
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 cell.image = result;
                             }];
    } else  if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
        CGFloat ratio = 270.0/405.0;
        CGFloat height = swipeView.frame.size.height;
        CGFloat width = height*ratio;
        
        if (!view || view.tag != PIESwipeViewResueViewTypeMission ) {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width+5, height)];
            view.tag = PIESwipeViewResueViewTypeMission;
            LeesinMissionCell* cell = [[LeesinMissionCell alloc]initWithFrame:view.bounds];
            [view addSubview:cell];
        }

        LeesinMissionCell *cell = [self pie_getSubviewAsClass:[LeesinMissionCell class] fromView:view];;
        PHImageManager *imageManager = [PHImageManager defaultManager];
        PHAsset *currentAsset = [_sourceMissions objectAtIndex:index];
        cell.selected = currentAsset.selected;
        [imageManager requestImageForAsset:currentAsset
                                targetSize:CGSizeMake(100,200)
                               contentMode:PHImageContentModeDefault
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 cell.imageView.image = result;
                             }];
    }
    
    
    
    return view;
}



-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    if (_photosIsReady) {
        return;
    }
    UIView* view = [swipeView itemViewAtIndex:index];
    
    if (self.bar.buttonType == LeesinTextInputBarButtonTypePhoto) {
        LeesinAssetCell *cell = [self pie_getSubviewAsClass:[LeesinAssetCell class] fromView:view];;
        PHAsset *currentAsset = [_sourceAssets objectAtIndex:index];
        if (cell.selected) {
            cell.selected = NO;
            currentAsset.selected = NO;
            [self.selectedAssets removeObject:currentAsset];
        } else {
            if ((self.selectedAssets.count <= 0) || (self.type == LeesinViewControllerTypeAsk && self.selectedAssets.count < 2 )) {
                cell.selected = YES;
                currentAsset.selected = YES;

                [self.selectedAssets addObject:currentAsset];
            }
        }
    } else     if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
        
        LeesinMissionCell *cell = [self pie_getSubviewAsClass:[LeesinMissionCell class] fromView:view];;
        PHAsset *currentAsset = [_sourceMissions objectAtIndex:index];
        if (cell.selected) {
            cell.selected = NO;
            currentAsset.selected = NO;
            _selectedIndexOfMission = NSNotFound;
        } else {
            if (_selectedIndexOfMission == NSNotFound) {
                cell.selected = YES;
                currentAsset.selected = YES;
                _selectedIndexOfMission = index;
            }
        }
    }
    
    [self updateToolBarInfo];

}
- (void)togglePreviewBar {
    
    if (self.previewBar.frame.origin.y >= self.bar.frame.origin.y) {
        [self.previewBarMarginBC setOffset:0];
    } else {
        [self.previewBarMarginBC setOffset:38];
    }
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.previewBar layoutIfNeeded];
    } completion:nil];
}
- (void)updateToolBarInfo {
    if (!self.toolBar.label_confirmedCount.hidden) {
        self.toolBar.label_confirmedCount.text = [NSString stringWithFormat:@"%zd",self.selectedAssets.count];
    }
    
    if (self.type == LeesinViewControllerTypeAsk) {
        self.toolBar.button_confirm.enabled = self.selectedAssets.count > 0 ? YES:NO;
        self.toolBar.button_confirm.alpha   = self.selectedAssets.count > 0 ? 1.0:0.3;
    }
}


@end
