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
#define FAVORITE_GAMES_TITLE    @"收藏游戏"
#define RECENT_GAMES_KEY        @"RecentGames"
#define RECENT_GAMES_TITLE      @"最近游玩"

// TODO: find a way to remove these keys, or make them avail from ObjC from Swift.

// keys used in a GameInfo dictionary
#define kGameInfoType           @"type"
#define kGameInfoSystem         @"system"
#define kGameInfoName           @"name"
#define kGameInfoParent         @"parent"
#define kGameInfoYear           @"year"
#define kGameInfoDescription    @"description"
#define kGameInfoManufacturer   @"manufacturer"
#define kGameInfoScreen         @"screen"
#define kGameInfoDriver         @"driver"
#define kGameInfoCategory       @"category"
#define kGameInfoHistory        @"history"
#define kGameInfoMameInfo       @"mameinfo"
#define kGameInfoSoftwareMedia  @"software"         // list of supported software, and media for system
#define kGameInfoSoftwareList   @"softlist"         // this game is *from* a software list
#define kGameInfoFile           @"file"
#define kGameInfoMediaType      @"media"
#define kGameInfoCustomCmdline  @"cmdline"

#define kGameInfoTypeArcade     @"街机"
#define kGameInfoTypeConsole    @"控制器"
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

#define kGameInfoScreenHorizontal   @"Horizontal"
#define kGameInfoScreenVertical     @"Vertical"
#define kGameInfoScreenVector       @"Vector"
#define kGameInfoScreenLCD          @"LCD"

// special "fake" (aka built-in) games
#define kGameInfoNameMameMenu   @"mameui"

NS_ASSUME_NONNULL_BEGIN

@interface GameInfo : NSObject

// create from a NSDictionary
- (instancetype)initWithDictionary:(NSDictionary<NSString*,NSString*>*)dict;

// create from a URL
- (nullable instancetype)initWithURL:(NSURL*)url;

// convert to a NSDictionary
@property (nonatomic, strong, readonly) NSDictionary<NSString*,NSString*>* gameDictionary;

// game properties
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
@property (nonatomic, strong, readonly) NSString* gameCustomCmdline;

@property (nonatomic, strong, readonly) NSString* gameTitle;
@property (nonatomic, strong, readonly) NSURL* gameLocalImageURL;
@property (nonatomic, strong, readonly) NSURL* gamePlayURL;
@property (nonatomic, strong, readonly) NSArray<NSURL*>* gameImageURLs;

@property (nonatomic, readonly) BOOL gameIsMame;
@property (nonatomic, readonly) BOOL gameIsSnapshot;
@property (nonatomic, readonly) BOOL gameIsClone;
@property (nonatomic, readonly) BOOL gameIsConsole;
@property (nonatomic, readonly) BOOL gameIsSoftware;

// game Metadata
@property (nonatomic, strong, readonly) NSString* gameMetadataFile;
-(void)gameSetValue:(NSString*)value forKey:(NSString*)key;
-(void)gameLoadMetadata;

@end

NS_ASSUME_NONNULL_END
