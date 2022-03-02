/*
 * This file is part of MAME4iOS.
 *
 * Copyright (C) 2013 David Valdeita (Seleuco)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses>.
 *
 * Linking MAME4iOS statically or dynamically with other modules is
 * making a combined work based on MAME4iOS. Thus, the terms and
 * conditions of the GNU General Public License cover the whole
 * combination.
 *
 * In addition, as a special exception, the copyright holders of MAME4iOS
 * give you permission to combine MAME4iOS with free software programs
 * or libraries that are released under the GNU LGPL and with code included
 * in the standard release of MAME under the MAME License (or modified
 * versions of such code, with unchanged license). You may copy and
 * distribute such a system following the terms of the GNU GPL for MAME4iOS
 * and the licenses of the other code concerned, provided that you include
 * the source code of that other code when and as the GNU GPL requires
 * distribution of source code.
 *
 * Note that people who make modified versions of MAME4iOS are not
 * obligated to grant this special exception for their modified versions; it
 * is their choice whether to do so. The GNU General Public License
 * gives permission to release a modified version without this exception;
 * this exception also makes it possible to release a modified version
 * which carries forward this exception.
 *
 * MAME4iOS is dual-licensed: Alternatively, you can license MAME4iOS
 * under a MAME license, as set out in http://mamedev.org/
 */

#import "Options.h"
#import "OptionsController.h"
#import "Globals.h"
#import "ListOptionController.h"
#import "InputOptionController.h"
#import "HelpController.h"
#import "EmulatorController.h"
#import "ImageCache.h"
#import "CloudSync.h"
#import "Alert.h"

@implementation OptionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"设置", @"");
    
    UILabel* pad = [[UILabel alloc] init];
    pad.text = @" ";
    
    UIImageView* logo = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"mame_logo"] scaledToSize:CGSizeMake(280, 0)]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* info = [[UILabel alloc] init];
    info.text = [self.applicationVersionInfo stringByAppendingString:@"\n"];
    info.font = [UIFont systemFontOfSize:12];
    info.textAlignment = NSTextAlignmentCenter;
    info.numberOfLines = 0;
    
    UIStackView* stack = [[UIStackView alloc] initWithArrangedSubviews:@[pad, logo, info]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentFill;
    stack.spacing = 8.f;
    stack.distribution = UIStackViewDistributionEqualSpacing;
    
    [stack setNeedsLayout]; [stack layoutIfNeeded];
    CGFloat height = [stack systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    stack.frame =  CGRectMake(0, 0, self.view.bounds.size.width, height);
     
    self.tableView.tableHeaderView = stack;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
   UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
   cell.accessoryType = UITableViewCellAccessoryNone;
   
   Options *op = [[Options alloc] init];
    
   switch (indexPath.section)
   {
           
       case kSupportSection:
       {
           switch (indexPath.row)
           {
               case 0:
               {
                   cell.textLabel.text   = @"帮助";
                   cell.imageView.image = [UIImage systemImageNamed:@"questionmark.circle"];
                   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                   break;
               }
               case 1:
               {
                   cell.textLabel.text   = @"新特性";
                   cell.imageView.image = [UIImage systemImageNamed:@"info.circle"];
                   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                   break;
               }
           }
           break;
       }
        case kVideoSection:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text = @"滤波器";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [Options.arrayFilter optionFind:op.filter];
                    break;
                }
                case 1:
                {
                    cell.textLabel.text   = @"皮肤";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [Options.arraySkin optionFind:op.skin];
                    break;
                }
                case 2:
                {
                    cell.textLabel.text   = @"屏幕着色器";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [Options.arrayScreenShader optionFind:op.screenShader];
                    break;
                }
                case 3:
                {
                    cell.textLabel.text   = @"矢量着色器";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [Options.arrayLineShader optionFind:op.lineShader];
                    break;
                }
               case 4:
               {
                    cell.textLabel.text   = @"保持长宽比";
                    cell.accessoryView = [self optionSwitchForKey:@"keepAspectRatio"];
                   break;
               }
               case 5:
               {
                   cell.textLabel.text   = @"强制整数倍放大";
                   cell.accessoryView = [self optionSwitchForKey:@"integerScalingOnly"];
                   break;
               }
               case 6:
               {
                   cell.textLabel.text   = @"强制像素适配";
                   cell.accessoryView = [self optionSwitchForKey:@"forcepxa"];
                   break;
               }
            }
            break;
        }
       case kVectorSection:
       {
           switch (indexPath.row)
           {
               case 0:
                {
                    cell.textLabel.text = @"光线 2x";
                    cell.accessoryView = [self optionSwitchForKey:@"vbean2x"];
                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"闪烁";
                    cell.accessoryView = [self optionSwitchForKey:@"vflicker"];
                    break;
                }
           }
           break;
       }
       case kFullscreenSection:
        {
           switch (indexPath.row)
           {
               case 0:
               {
                   cell.textLabel.text   = @"全屏 (竖屏)";
                   cell.accessoryView = [self optionSwitchForKey:@"fullscreenPortrait"];
                   break;
               }
               case 1:
               {
                   cell.textLabel.text   = @"全屏 (横屏)";
                   cell.accessoryView = [self optionSwitchForKey:@"fullscreenLandscape"];
                   break;
               }
               case 2:
               {
                   cell.textLabel.text   = @"全屏 (控制器)";
                   cell.accessoryView = [self optionSwitchForKey:@"fullscreenJoystick"];
                   break;
               }
           }
           break;
        }
           
        case kMiscSection:  //Miscellaneous
        {
            switch (indexPath.row) 
            {
                case 0:
                {
                    cell.textLabel.text   = @"显示 FPS";
                    cell.accessoryView = [self optionSwitchForKey:@"showFPS"];
                    break;
                }
                case 1:
                {
                    cell.textLabel.text   = @"显示 HUD";
                    cell.accessoryView = [self optionSwitchForKey:@"showHUD"];
                    break;
                }
                case 2:
                {
                    cell.textLabel.text   = @"显示 信息/警告";
                    cell.accessoryView = [self optionSwitchForKey:@"showINFO"];
                    break;
                }
                case 3:
                {
                     cell.textLabel.text = @"金手指";
                     cell.accessoryView = [self optionSwitchForKey:@"cheats"];
                     break;
                }
                case 4:
                {
                     cell.textLabel.text   = @"保存最高分";
                     cell.accessoryView = [self optionSwitchForKey:@"hiscore"];
                     break;
                }
                case 5:
                {
                     cell.textLabel.text   = @"使用 DRC";
                     cell.accessoryView = [self optionSwitchForKey:@"useDRC"];
                     break;
                }
                case 6:
                {
                     cell.textLabel.text   = @"模拟器速度";
                     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                     cell.detailTextLabel.text = [Options.arrayEmuSpeed optionAtIndex:op.emuspeed];
                     break;
                }
                case 7:
                {
                     cell.textLabel.text   = @"声音";
                     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                     cell.detailTextLabel.text = [Options.arraySoundValue optionAtIndex:op.soundValue];
                     break;
                }
            }
            break;   
        }
       case kFilterSection:
       {
           switch (indexPath.row)
           {
               case 0:
               {
                   cell.textLabel.text   = @"隐藏复刻版游戏";
                   cell.accessoryView = [self optionSwitchForKey:@"filterClones"];
                   break;
               }
               case 1:
               {
                   cell.textLabel.text   = @"隐藏有问题的游戏";
                   cell.accessoryView = [self optionSwitchForKey:@"filterNotWorking"];
                   break;
               }
               case 2:
               {
                   cell.textLabel.text   = @"隐藏 BIOS";
                   cell.accessoryView = [self optionSwitchForKey:@"filterBIOS"];
                   break;
               }
           }
           break;
        }
        case kOtherSection:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text = @"游戏输入控制";
                    cell.imageView.image = [UIImage systemImageNamed:@"gamecontroller"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
            }
            break;
        }
        case kImportSection:
        {
           switch (indexPath.row)
           {
               case 0:
               {
                   cell.textLabel.text = @"导入";
                   cell.imageView.image = [UIImage systemImageNamed:@"square.and.arrow.down.on.square"];
                   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                   break;
               }
               case 1:
               {
                   cell.textLabel.text = @"导出";
                   cell.imageView.image = [UIImage systemImageNamed:@"square.and.arrow.up.on.square"];
                   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                   break;
               }
               case 2:
               {
                   cell.textLabel.text = @"开启文件服务";
                   cell.imageView.image = [UIImage systemImageNamed:@"arrow.up.arrow.down.circle"];
                   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                   break;
               }
               case 3:
               {
                   cell.textLabel.text = @"显示所有文件";
                   cell.imageView.image = [UIImage systemImageNamed:@"folder"];
                   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                   break;
               }
           }
           break;
        }
        case kCloudImportSection:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text = @"导出到 iCloud";
                    cell.imageView.image = [UIImage systemImageNamed:@"icloud.and.arrow.up"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"从 iCloud 导入";
                    cell.imageView.image = [UIImage systemImageNamed:@"icloud.and.arrow.down"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 2:
                {
                    cell.textLabel.text = @"同步至 iCloud";
                    cell.imageView.image = [UIImage systemImageNamed:@"arrow.clockwise.icloud"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 3:
                {
                    cell.textLabel.text = @"从 iCloud 中擦除";
                    cell.imageView.image = [UIImage systemImageNamed:@"xmark.icloud"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
            }
            break;
        }
        case kResetSection:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

                    cell.textLabel.text = @"重置为默认";
                    cell.textLabel.textColor = [UIColor whiteColor];
                    cell.textLabel.shadowColor = [UIColor blackColor];
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
                    cell.backgroundColor = [UIColor systemRedColor];
                    break;
                }
            }
            break;
         }
       case kBenchmarkSection:
       {
           switch (indexPath.row)
           {
               case 0:
               {
                   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

                   cell.textLabel.text = @"性能基准";
                   cell.textLabel.textColor = [UIColor whiteColor];
                   cell.textLabel.shadowColor = [UIColor blackColor];
                   cell.textLabel.textAlignment = NSTextAlignmentCenter;
                   cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
                   cell.backgroundColor = self.view.tintColor; // [UIColor systemBlueColor];
                   break;
               }
           }
           break;
        }

   }

   return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
      return kNumSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
		
    switch (section)
    {
        case kSupportSection: return nil;
        case kFullscreenSection: return @"全屏";
        case kVideoSection: return @"视频选项";
        case kVectorSection: return @"矢量选项";
        case kMiscSection: return @"选项";
        case kFilterSection: return @"游戏滤波器";
        case kOtherSection: return @""; // @"Other";
        case kImportSection: return @"导入/导出";
        case kCloudImportSection: return @"iCloud";
        case kResetSection: return @"";
        case kBenchmarkSection: return @"";
    }
    return @"错误!";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
      switch (section)
      {
          case kSupportSection: return 2;
          case kFullscreenSection: return 3;
          case kOtherSection: return 1;
          case kVideoSection: return 7;
          case kVectorSection: return 2;
          case kMiscSection: return 8;
          case kFilterSection: return 3;
          case kImportSection: return 4;
          case kCloudImportSection:
              if (CloudSync.status == CloudSyncStatusAvailable)
                  return 4;
              else if (CloudSync.status == CloudSyncStatusEmpty)
                  return 1;
              else
                  return 0;
          case kResetSection: return 1;
          case kBenchmarkSection:
              return self.presentingViewController == self.emuController ? 1 : 0;
      }
    return -1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (section)
    {
        case kSupportSection:
        {
            if (row==0){
                HelpController *controller = [[HelpController alloc] init];
                [[self navigationController] pushViewController:controller animated:YES];
            }
            if (row==1){
                HelpController *controller = [[HelpController alloc] initWithName:@"WHATSNEW.html" title:@"新特性"];
                [[self navigationController] pushViewController:controller animated:YES];
            }
            break;
        }
        case kOtherSection:
        {
            if (row==0){
                InputOptionController *inputOptController = [[InputOptionController alloc] initWithEmuController:self.emuController];
                [[self navigationController] pushViewController:inputOptController animated:YES];
                [tableView reloadData];
            }
            break;
        }
        case kVideoSection:
        {
            if (row==0){
                ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"filter" list:Options.arrayFilter title:cell.textLabel.text];
                [[self navigationController] pushViewController:listController animated:YES];
            }
            if (row==1){
                ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"skin" list:Options.arraySkin title:cell.textLabel.text];
                [[self navigationController] pushViewController:listController animated:YES];
            }
            if (row==2){
                ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"screenShader" list:Options.arrayScreenShader title:cell.textLabel.text];
                [[self navigationController] pushViewController:listController animated:YES];
            }
            if (row==3){
                ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"lineShader" list:Options.arrayLineShader title:cell.textLabel.text];
                [[self navigationController] pushViewController:listController animated:YES];
            }
            break;
        }
        case kMiscSection:
        {
            if (row==6) {
                ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"emuspeed" list:Options.arrayEmuSpeed title:cell.textLabel.text];
                [[self navigationController] pushViewController:listController animated:YES];
            }
            if (row==7) {
                ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"soundValue" list:Options.arraySoundValue title:cell.textLabel.text];
                [[self navigationController] pushViewController:listController animated:YES];
            }
            break;
        }
        case kImportSection:
        {
            if (row==0) {
                [self.emuController runImport];
            }
            if (row==1) {
                [self.emuController runExport];
            }
            if (row==2) {
                [self.emuController runServer];
            }
            if (row==3) {
                [self.emuController runShowFiles];
            }
            break;
        }
        case kCloudImportSection:
        {
            if (row==0) {
                [CloudSync export];
            }
            if (row==1) {
                [CloudSync import];
            }
            if (row==2) {
                [CloudSync sync];
            }
            if (row==3) {
                [self showAlertWithTitle:@"从 iCloud 中擦除?" message:nil buttons:@[@"擦除", @"取消"] handler:^(NSUInteger button) {
                    if (button == 0)
                        [CloudSync delete];
                }];
            }
            break;
        }
        case kResetSection:
        {
            if (row==0) {
                [self.emuController runReset];
            }
            break;
        }
        case kBenchmarkSection:
        {
            if (row==0) {
                [self.emuController runBenchmark];
            }
            break;
        }
    }
}

@end
