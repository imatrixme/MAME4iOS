//
//  TVOptionsController.m
//  MAME tvOS
//
//  Created by Yoshi Sugawara on 1/17/19.
//  Copyright © 2019 Seleuco. All rights reserved.
//

#import "TVOptionsController.h"
#import "ListOptionController.h"
#import "TVInputOptionsController.h"
#import "CloudSync.h"
#import "Alert.h"
#import "MAME4iOS-Swift.h"

@implementation TVOptionsController

- (void)viewDidLoad {
    self.title = NSLocalizedString(@"设置", @"");
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuPress)];
    tap.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeMenu]];
    [self.view addGestureRecognizer:tap];
}

-(void)menuPress {
    [self.emuController done:nil];
}
    
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
    
#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( section == kFilterSection ) {
        return 3;
    } else if ( section == kScreenSection ) {
        return 7;
    } else if ( section == kVectorSection ) {
        return 2;
    } else if ( section == kMiscSection ) {
        return 8;
    } else if ( section == kInputSection ) {
        return 1;
    } else if ( section == kImportSection ) {
        if (CloudSync.status == CloudSyncStatusAvailable)
            return 5;
        else if (CloudSync.status == CloudSyncStatusEmpty)
            return 2;
        else
            return 1;
    } else if ( section == kResetSection ) {
        return 1;
    } else if ( section == kBenchmarkSection ) {
        return self.presentingViewController == self.emuController ? 1 : 0;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ( section == kScreenSection ) {
        return @"Display Options";
    }
    if ( section == kVectorSection ) {
        return @"Vector Options";
    }
    if ( section == kMiscSection ) {
        return @"Options";
    }
    if ( section == kFilterSection ) {
        return @"ROM Options";
    }
    if ( section == kResetSection ) {
        return @"Reset";
    }
    if ( section == kImportSection ) {
        return @"Import / Export";
    }
    if ( section == kInputSection ) {
        return @"Input";
    }
    if ( section == kBenchmarkSection ) {
        return @"Benchmark";
    }

    return @"";
}

// helper to get a systemImage to use in the UI
- (UIImage*)systemImageNamed:(NSString*)name withFont:(UIFont*)font {
    return [UIImage systemImageNamed:name withConfiguration:[UIImageSymbolConfiguration configurationWithFont:font]];
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
    cell.textLabel.text = nil;
    cell.textLabel.textColor = nil;
    cell.detailTextLabel.text = nil;
    cell.contentView.backgroundColor = nil;
    
    Options* op = [[Options alloc] init];
    
    UIFont* font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];

    if ( indexPath.section == kFilterSection ) {
        if ( indexPath.row == 0 ) {
            cell.textLabel.text   = @"Hide Clones";
            cell.accessoryView = [self optionSwitchForKey:@"filterClones"];
        } else if ( indexPath.row == 1 ) {
            cell.textLabel.text   = @"Hide Not Working";
            cell.accessoryView = [self optionSwitchForKey:@"filterNotWorking"];
        } else if ( indexPath.row == 2 ) {
            cell.textLabel.text   = @"Hide BIOS";
            cell.accessoryView = [self optionSwitchForKey:@"filterBIOS"];
        }
    } else if ( indexPath.section == kImportSection ) {
        if ( indexPath.row == 0 ) {
            cell.textLabel.text = @"Start Web Server";
            cell.imageView.image = [self systemImageNamed:@"arrow.up.arrow.down.circle" withFont:font];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if ( indexPath.row == 1 ) {
            cell.textLabel.text = @"Export to iCloud";
            cell.imageView.image = [self systemImageNamed:@"icloud.and.arrow.up" withFont:font];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if ( indexPath.row == 2 ) {
            cell.textLabel.text = @"Import from iCloud";
            cell.imageView.image = [self systemImageNamed:@"icloud.and.arrow.down"  withFont:font];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if ( indexPath.row == 3 ) {
            cell.textLabel.text = @"Sync with iCloud";
            cell.imageView.image = [self systemImageNamed:@"arrow.clockwise.icloud"  withFont:font];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if ( indexPath.row == 4 ) {
            cell.textLabel.text = @"Erase iCloud";
            cell.imageView.image = [self systemImageNamed:@"xmark.icloud" withFont:font];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else if ( indexPath.section == kScreenSection ) {
        if ( indexPath.row == 0 ) {
            cell.textLabel.text = @"Filter";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [Options.arrayFilter optionFind:op.filter];
        } else if ( indexPath.row == 1 ) {
            cell.textLabel.text   = @"Skin";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [Options.arraySkin optionFind:op.skin];
        } else if ( indexPath.row == 2 ) {
            cell.textLabel.text   = @"Screen Shader";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [Options.arrayScreenShader optionFind:op.screenShader];
        } else if ( indexPath.row == 3 ) {
            cell.textLabel.text   = @"Vector Shader";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [Options.arrayLineShader optionFind:op.lineShader];
        } else if ( indexPath.row == 4 ) {
            cell.textLabel.text = @"Keep Aspect Ratio";
            cell.accessoryView = [self optionSwitchForKey:@"keepAspectRatio"];
        } else if ( indexPath.row == 5 ) {
            cell.textLabel.text = @"Force Integer Scaling";
            cell.accessoryView = [self optionSwitchForKey:@"integerScalingOnly"];
        } else if ( indexPath.row == 6 ) {
            cell.textLabel.text   = @"Force Pixel Aspect";
            cell.accessoryView = [self optionSwitchForKey:@"forcepxa"];
        }
    } else if ( indexPath.section == kVectorSection ) {
        if ( indexPath.row == 0 ) {
            cell.textLabel.text = @"Beam 2x";
            cell.accessoryView = [self optionSwitchForKey:@"vbean2x"];
        } else if ( indexPath.row == 1 ) {
            cell.textLabel.text = @"Flicker";
            cell.accessoryView = [self optionSwitchForKey:@"vflicker"];
        }
    } else if ( indexPath.section == kMiscSection ) {
        if ( indexPath.row == 0 ) {
            cell.textLabel.text   = @"Show FPS";
            cell.accessoryView = [self optionSwitchForKey:@"showFPS"];
        } else if ( indexPath.row == 1 ) {
            cell.textLabel.text   = @"Show HUD";
            cell.accessoryView = [self optionSwitchForKey:@"showHUD"];
        } else if ( indexPath.row == 2 ) {
            cell.textLabel.text   = @"Show Info/Warnings";
            cell.accessoryView = [self optionSwitchForKey:@"showINFO"];
        } else if ( indexPath.row == 3 ) {
            cell.textLabel.text = @"Cheats";
            cell.accessoryView = [self optionSwitchForKey:@"cheats"];
        } else if ( indexPath.row == 4 ) {
            cell.textLabel.text   = @"Save Hiscores";
            cell.accessoryView = [self optionSwitchForKey:@"hiscore"];
        } else if ( indexPath.row == 5 ) {
            cell.textLabel.text   = @"Use DRC";
            cell.accessoryView = [self optionSwitchForKey:@"useDRC"];
        } else if ( indexPath.row == 6 ) {
            cell.textLabel.text   = @"Emulated Speed";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [Options.arrayEmuSpeed optionAtIndex:op.emuspeed];
        } else if ( indexPath.row == 7 ) {
            cell.textLabel.text   = @"Sound";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [Options.arraySoundValue optionAtIndex:op.soundValue];
        }
    } else if ( indexPath.section == kInputSection ) {
        cell.textLabel.text = @"Game Input";
        cell.imageView.image = [self systemImageNamed:@"gamecontroller" withFont:font];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ( indexPath.section == kResetSection ) {
        cell.textLabel.text = @"Reset to Defaults";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundView = [[UIView alloc] init];
        cell.backgroundView.backgroundColor = [UIColor systemRedColor];
        cell.backgroundView.layer.cornerRadius = 8.0;
    } else if ( indexPath.section == kBenchmarkSection ) {
        cell.textLabel.text = @"Run Benchmark";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundView = [[UIView alloc] init];
        cell.backgroundView.backgroundColor = [UIColor systemBlueColor];
        cell.backgroundView.layer.cornerRadius = 8.0;
    }
    return cell;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self toggleOptionSwitch:cell.accessoryView];
    
    if ( indexPath.section == kFilterSection ) {

    } else if ( indexPath.section == kImportSection ) {
        if ( indexPath.row == 0 ) {
            [self.emuController runServer];
        }
        if ( indexPath.row == 1 ) {
            [CloudSync export];
        }
        if ( indexPath.row == 2 ) {
            [CloudSync import];
        }
        if ( indexPath.row == 3 ) {
            [CloudSync sync];
        }
        if ( indexPath.row == 4 ) {
            [self showAlertWithTitle:@"Erase iCloud?" message:nil buttons:@[@"Erase", @"Cancel"] handler:^(NSUInteger button) {
                if (button == 0)
                    [CloudSync delete];
            }];
        }
    } else if ( indexPath.section == kScreenSection ) {
        if ( indexPath.row == 0 ) {
            ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"filter" list:Options.arrayFilter title:cell.textLabel.text];
            [[self navigationController] pushViewController:listController animated:YES];
        } else if ( indexPath.row == 1 ) {
            ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"skin" list:Options.arraySkin title:cell.textLabel.text];
            [[self navigationController] pushViewController:listController animated:YES];
        } else if ( indexPath.row == 2 ) {
            ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"screenShader" list:Options.arrayScreenShader title:cell.textLabel.text];
            [[self navigationController] pushViewController:listController animated:YES];
        } else if ( indexPath.row == 3 ) {
            ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"lineShader" list:Options.arrayLineShader title:cell.textLabel.text];
            [[self navigationController] pushViewController:listController animated:YES];
        }
    } else if ( indexPath.section == kMiscSection ) {
        if ( indexPath.row == 6 ) {
            ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"emuspeed" list:Options.arrayEmuSpeed title:cell.textLabel.text];
            [[self navigationController] pushViewController:listController animated:YES];
        }
        if ( indexPath.row == 7 ) {
            ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"soundValue" list:Options.arraySoundValue title:cell.textLabel.text];
            [[self navigationController] pushViewController:listController animated:YES];
        }
    } else if ( indexPath.section == kInputSection ) {
        TVInputOptionsController *inputController = [[TVInputOptionsController alloc] initWithEmuController:self.emuController];
        [self.navigationController pushViewController:inputController animated:YES];
    } else if ( indexPath.section == kResetSection ) {
        [self.emuController runReset];
    } else if ( indexPath.section == kBenchmarkSection ) {
        [self.emuController runBenchmark];
    }
}

@end
