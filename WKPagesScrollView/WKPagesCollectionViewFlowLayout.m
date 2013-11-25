//
//  WKPagesCollectionViewFlowLayout.m
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-15.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//


#import "WKPagesCollectionViewFlowLayout.h"
#define RotateDegree -60.0f
@implementation WKPagesCollectionViewFlowLayout{
    
}
-(id)init{
    self=[super init];
    if (self){
        
    }
    return self;
}
-(void)prepareLayout
{
    [super prepareLayout];
    self.itemSize=CGSizeMake(self.collectionView.frame.size.width,self.pageHeight);
    self.minimumLineSpacing=-1*(self.itemSize.height-160.0f);
    //NSLog(@"lineSpacing:%f",self.minimumLineSpacing);
    self.scrollDirection=UICollectionViewScrollDirectionVertical;
}
-(CGFloat)pageHeight{
    return [UIScreen mainScreen].bounds.size.height;
}
-(CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.frame.size.width,
                      (self.pageHeight+self.minimumLineSpacing)*([self.collectionView numberOfItemsInSection:0]+1));
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    NSLog(@"layoutAttributesForItemAtIndexPath:%d",path.row);
    UICollectionViewLayoutAttributes* attributes=[super layoutAttributesForItemAtIndexPath:path];
    return attributes;
}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    //NSLog(@"layoutAttributesForElementsInRect:%@",NSStringFromCGRect(rect));
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    //NSLog(@"visibleRect:%@",NSStringFromCGRect(visibleRect));
    for (UICollectionViewLayoutAttributes* attributes in array) {
        attributes.zIndex=attributes.indexPath.row;///要设置zIndex，否则遮挡顺序会有编号
        CATransform3D rotateTransform=WKFlipCATransform3DPerspectSimpleWithRotate(RotateDegree);
        attributes.transform3D=rotateTransform;
        if (CGRectIntersectsRect(attributes.frame, rect)) {///显示区域内的找出来
            CGFloat distance=attributes.frame.origin.y-self.collectionView.contentOffset.y;
            CGFloat normalizedDistance = distance / self.collectionView.frame.size.height;
            ///角度大的会和角度小的cell交叉，即使设置zIndex也没有用，这里设置底部的cell角度越来越大
            CATransform3D rotateTransform=WKFlipCATransform3DPerspectSimpleWithRotate(RotateDegree+15.0f*(normalizedDistance));
            attributes.transform3D=rotateTransform;
        }
        else{
            CATransform3D rotateTransform=WKFlipCATransform3DPerspectSimpleWithRotate(RotateDegree);
            attributes.transform3D=rotateTransform;
        }
    }
    return array;
}
@end
