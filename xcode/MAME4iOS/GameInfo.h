//
//  GameInfo.h
//  MAME4iOS
//
//  Created by ToddLa on 4/5/21.
//  Copyright © 2021 Seleuco. All rights reserved.
//

#import <Foundation/Foundation.h>

// keys used in a NSUserDefaults
#define FAVORITE_GAMES_KEY      @"FavoriteGames"
#define FAVORITE_GAMES_TITLE    @"收藏"
#define RECENT_GAMES_KEY        @"RecentGames"
#define RECENT_GAMES_TITLE      @"最近游玩"

// keys used in a GameInfo dictionary
#define kGameInfoType           @"类型"
#define kGameInfoSystem         @"系统"
#define kGameInfoName           @"名称"
#define kGameInfoParent         @"起源"
#define kGameInfoYear           @"年份"
#define kGameInfoDescription    @"描述"
#define kGameInfoManufacturer   @"厂商"
#define kGameInfoScreen         @"屏幕"
#define kGameInfoDriver         @"驱动"
#define kGameInfoCategory       @"分类"
#define kGameInfoHistory        @"历史"
#define kGameInfoMameInfo       @"信息"
#define kGameInfoSoftwareMedia  @"软件"         // list of supported software for system
#define kGameInfoSoftwareList   @"列表"         // this game is *from* a software list
#define kGameInfoFile           @"文件"
#define kGameInfoMediaType      @"媒体"

#define kGameInfoTypeArcade     @"游戏厅"
#define kGameInfoTypeConsole    @"主机"
#define kGameInfoTypeComputer   @"电脑"
#define kGameInfoTypeBIOS       @"BIOS"
#define kGameInfoTypeSnapshot   @"快照"
#define kGameInfoTypeSoftware   @"软件"

#define kGameInfoMediaCartridge @"cart"
#define kGameInfoMediaMemcard   @"memc"
#define kGameInfoMediaFloppy    @"flop"
#define kGameInfoMediaHard      @"hard"
#define kGameInfoMediaCassette  @"cass"
#define kGameInfoMediaQuick     @"quik"
#define kGameInfoMediaCDROM     @"cdrm"

#define kGameInfoScreenHorizontal   @"横向"
#define kGameInfoScreenVertical     @"竖向"
#define kGameInfoScreenVector       @"向量"
#define kGameInfoScreenLCD          @"LCD"

// special "fake" (aka built-in) games
#define kGameInfoNameSettings   @"设置"
#define kGameInfoNameMameMenu   @"mameui"
#define kGameInfoNameAddROMS    @"settings-add-roms"

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (GameInfo)

@property (nonatomic, strong, readonly) NSString* gameType;
@property (nonatomic, strong, readonly) NSString* gameSystem;
@property (nonatomic, strong, readonly) NSString* gameName;
@property (nonatomic, strong, readonly) NSString* gameParent;
@property (nonatomic, strong, readonly) NSString* gameYear;
@property (nonatomic, strong, readonly) NSString* gameDescription;
@property (nonatomic, strong, readonly) NSString* gameManufacturer;
@property (nonatomic, strong, readonly) NSString* gameDriver;
@property (nonatomic, strong, readonly) NSString* gameScreen;
@property (nonatomic, strong, readonly) NSString* gameCategory;
@property (nonatomic, strong, readonly) NSString* gameSoftwareMedia;
@property (nonatomic, strong, readonly) NSString* gameSoftwareList;
@property (nonatomic, strong, readonly) NSString* gameFile;
@property (nonatomic, strong, readonly) NSString* gameMediaType;

@property (nonatomic, strong, readonly) NSString* gameTitle;
@property (nonatomic, strong, readonly) NSURL* gameImageURL;
@property (nonatomic, strong, readonly) NSURL* gameLocalImageURL;
@property (nonatomic, strong, readonly) NSURL* gamePlayURL;
@property (nonatomic, strong, readonly) NSArray<NSURL*>* gameImageURLs;

@property (nonatomic, readonly) BOOL gameIsFake;
@property (nonatomic, readonly) BOOL gameIsMame;
@property (nonatomic, readonly) BOOL gameIsSnapshot;
@property (nonatomic, readonly) BOOL gameIsClone;
@property (nonatomic, readonly) BOOL gameIsConsole;
@property (nonatomic, readonly) BOOL gameIsSoftware;

@end

NS_ASSUME_NONNULL_END
