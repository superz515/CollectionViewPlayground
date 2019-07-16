# CollectionViewPlayground
A centralized place that can play many kinds of different UICollectionView custom layouts and learn some related cool stuff.

![Image](https://github.com/superz515/CollectionViewPlayground/blob/master/CollectionViewPlayground/Resources/demo.GIF)

## Background

When I started learning UICollectionView custom layout, I saw so many brilliant open source projects on GitHub. But downloading and running them individually seems not so convenient. Then I had this idea that putting them together and adding more controls, so that everyone could feel and learn them more easily.

In practice, I think there're already lots of custom layouts on GitHub, and I don't think we need to implement our own for most cases. But it's still good to know its essentials.

## A good tutorial here

Please read through this tutorial from [raywenderlich.com](https://www.raywenderlich.com/392-uicollectionview-custom-layout-tutorial-pinterest). Although the custom layout itself is not included in this project, this tutorial will be a good start to learn some essentials for UICollectionView custom layout, e.g. methods that need to be implemented, life cycle etc.

## Source of included custom layouts

Here're some information about included custom layouts and links to original projects that I learnt from. Some codes are modified when I included them in my projects.

#### Carousel and Advanced Carousel

Default UICollectionViewFlowLayout can let you stop scrolling at anywhere. The most common scenario that you will want to customize it is that you want to place the cells at certain place. For example, when the UICollectionView stops scrolling, you want a cell always to be centred. This behavior sounds similar as the "paging" of UIScrollView, but for most cases, enable default "paging" property won't give you expected behavior for a UICollectionView. So we have to implement our own, which is so called a "carousel" layout.

While a normal carousel will always try to center a cell, an advanced carousel could give you more options to emphasize the centered cell, like applying a smaller alpha or scale to other side cells. A good example of advanced carousel will be:

[UPCarouselFlowLayout](https://github.com/ink-spot/UPCarouselFlowLayout)

#### More Advanced Carousel

If you think advanced carousel is fancy enough, then you will be amazed by this one. I don't even know how to name it, in the project, I just name it Titled Carousel. Instead of using given properties from UICollectionViewLayoutAttributes to perform animation, this one let you pass a progress to the cell then you actually perform any kinds of animations!

[CarLensCollectionViewLayout](https://github.com/netguru/CarLensCollectionViewLayout)

#### Cycle

This one may be not that usefull but it's a good example to know how to subclass a base UICollectionViewLayout instead of a UICollectionViewFlowLayout.

[-CollectionViewLayout-CollectionViewFlowLayout-](https://github.com/Tuberose621/-CollectionViewLayout-CollectionViewFlowLayout-)

#### Bouncy

This is actually not about layout but UIDynamics. It lets you achieve similar bouncy behavior like the default Message app. (This one in my project is malfunctioning now probably due to iOS SDK upgrade. Need to fix it later.)

[BouncyLayout](https://github.com/roberthein/BouncyLayout)

#### Animated Appearance

Well, this one is also not about layout, but it's pretty cool. It shows you how to show cells with animations. You can use it anywhere, not just for UICollectionView.

[ViewAnimator](https://github.com/marcosgriselli/ViewAnimator)

#### Overlapping

Somehow I couldn't remember the source project of this one. And actually we could achieve same behavior with UICollectionViewFlowLayout with a negative minimumLineSpacing. But it's a subclass of UICollectionViewLayout, which shows you a different way to implement your own custom layout.

#### Stack and Another Stack

This kind of layout lets you put one cell over another just like real poker cards.

[CardsLayout](https://github.com/filletofish/CardsLayout)

[StickyCollectionView](https://github.com/matbeich/StickyCollectionView)

## Known Issues

1. Some cells will be misplaced when switching between layouts. This probably is an iOS bug and you can bypass it by deleting all cells and adding them back.
2. Some more UI issues. I don't want to take too much time to fix them, since this is just a playground. 😄
3. Bouncy layout is not working.
4. Lack of a fancy icon. 🙂
5. There seems to be some serious issues with iOS 13 beta. Let's wait for GA and see.
