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

#import "InputOptionController.h"
#import "Globals.h"
#import "Options.h"
#import "OptionsController.h"
#import "ListOptionController.h"
#import "EmulatorController.h"

@implementation InputOptionController

- (id)init {
    if (self = [super init]) {
        
        switchAnimatedButtons=nil;

        arrayTouchType = [[NSArray alloc] initWithObjects:@"数字 DPAD",@"数字摇杆",@"模拟摇杆", nil];
        arrayStickType = [[NSArray alloc] initWithObjects:@"自动",@"2个方向",@"4个方向",@"8个方向", nil];
        arrayStickSizeValue = [[NSArray alloc] initWithObjects:@"更小", @"小", @"正常", @"大", @"更大",nil];
        
        arrayNumbuttons = [[NSArray alloc] initWithObjects:@"自动",@"0 个按钮",@"1 个按钮",@"2 个按钮",@"3 个按钮",@"4 个按钮",@"5 个按钮",@"所有按钮",nil];
        switchAplusB = nil;
        arrayAutofireValue = [[NSArray alloc] initWithObjects:@"禁用", @"速度 1", @"速度 2",@"速度 3",
                              @"速度 4", @"速度 5",@"速度 6",@"速度 7",@"速度 8",@"速度 9",nil];
        arrayButtonSizeValue = [[NSArray alloc] initWithObjects:@"更小", @"小", @"正常", @"大", @"更大",nil];
        
        switchP1aspx = nil;
        
        arrayAnalogDZValue = [[NSArray alloc] initWithObjects:@"1", @"2", @"3",@"4", @"5", @"6", nil];
        
        switchLightgunEnabled = nil;
        switchLightgunBottomScreenReload = nil;
        
        switchTurboAButtonEnabled = nil;
        switchTurboBButtonEnabled = nil;
        switchTurboXButtonEnabled = nil;
        switchTurboYButtonEnabled = nil;
        switchTurboLButtonEnabled = nil;
        switchTurboRButtonEnabled = nil;
        
        switchTouchAnalogEnabled = nil;
        switchTouchAnalogHideTouchButtons = nil;
        switchTouchAnalogHideTouchDirectionalPad = nil;
        sliderTouchAnalogSensitivity = nil;
        
        switchTouchDirectionalEnabled = nil;
        
        sliderTouchControlsOpacity = nil;
        
        self.title = @"输入控制选项";
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 11;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: return 3;
        case 1: return 3;
        case 2: return 5;
        case 3: return 1;
        case 4: return 3;
        case 5: return 1;
        case 6: return 1;
        case 7: return 2;
        case 8: return 6;
        case 9: return 4;
        case 10: return 1;
    }
    return -1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section)
    {
        case 0: return @"";
        case 1: return @"摇杆 & DPAD";
        case 2: return @"按钮";
        case 3: return @"";
        case 4: return @"触控布局";
        case 5: return @"";
        case 6: return @"死区";
        case 7: return @"触摸光枪";
        case 8: return @"加速模式切换";
        case 9: return @"触摸模拟";
        case 10: return @"触摸定向输入";
    }
    return @"错误!";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [NSString stringWithFormat: @"%lu:%lu", (unsigned long)[indexPath indexAtPosition:0], (unsigned long)[indexPath indexAtPosition:1]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        
        UITableViewCellStyle style;
        
        if(indexPath.section==4)
            style = UITableViewCellStyleDefault;
        else
            style = UITableViewCellStyleValue1;
        
        if (indexPath.section == 7 && indexPath.row == 1 )
            style = UITableViewCellStyleSubtitle;
        
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"CellIdentifier"];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    Options *op = [[Options alloc] init];
    
    switch (indexPath.section)
    {
        case 0:
        {
            if ( indexPath.row == 0 ) {
                cell.textLabel.text   = @"动画";
                switchAnimatedButtons  = [[UISwitch alloc] initWithFrame:CGRectZero];
                cell.accessoryView = switchAnimatedButtons ;
                [switchAnimatedButtons setOn:[op animatedButtons] animated:NO];
                [switchAnimatedButtons addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                break;
            } else if (indexPath.row == 1 ) {
                cell.textLabel.text = @"透明度 (全屏)";
                sliderTouchControlsOpacity = [[UISlider alloc] initWithFrame:CGRectZero];
                [sliderTouchControlsOpacity setMinimumValue:0.0];
                [sliderTouchControlsOpacity setMaximumValue:100.0];
                [sliderTouchControlsOpacity setValue:[op touchControlsOpacity]];
                [sliderTouchControlsOpacity addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                sliderTouchControlsOpacity.translatesAutoresizingMaskIntoConstraints = NO;
                [cell.contentView addSubview:sliderTouchControlsOpacity];
                UIView *cellContentView = cell.contentView;
                NSDictionary *viewBindings = NSDictionaryOfVariableBindings(cellContentView,sliderTouchControlsOpacity);
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[sliderTouchControlsOpacity]-8@750-|" options:0 metrics:nil views:viewBindings]];
                [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:sliderTouchControlsOpacity attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
                [sliderTouchControlsOpacity addConstraint:[NSLayoutConstraint constraintWithItem:sliderTouchControlsOpacity attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0]];
                break;
            } else if (indexPath.row == 2 ) {
                cell.textLabel.text = @"振动反馈";
                cell.accessoryView = [self optionSwitchForKey:@"hapticButtonFeedback"];
                break;
            }
        }
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text   = @"触控类型";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [arrayTouchType objectAtIndex:op.touchtype];
                    break;
                }
                    
                case 1:
                {
                    cell.textLabel.text   = @"方向";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [arrayStickType objectAtIndex:op.sticktype];
                    break;
                }
                    
                case 2:
                {
                    cell.textLabel.text   = @"全屏摇杆尺寸";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [arrayStickSizeValue objectAtIndex:op.stickSize];
                    break;
                }
            }
            break;
        }
        case 2:
        {
            switch (indexPath.row)
            {   case 0:
                {
                    cell.textLabel.text   = @"全屏按钮";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [arrayNumbuttons objectAtIndex:op.numbuttons];
                    break;
                }
                    
                case 1:
                {
                    cell.textLabel.text   = @"按钮 A = B + X";
                    switchAplusB  = [[UISwitch alloc] initWithFrame:CGRectZero];
                    cell.accessoryView = switchAplusB ;
                    [switchAplusB setOn:[op aplusb] animated:NO];
                    [switchAplusB addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                    break;
                }
                case 2:
                {
                    
                    cell.textLabel.text   = @"按钮 A 作为自动发射";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [arrayAutofireValue objectAtIndex:op.autofire];
                    break;
                }
                case 3:
                {
                    cell.textLabel.text   = @"按钮尺寸";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [arrayButtonSizeValue objectAtIndex:op.buttonSize];
                    break;
                }
                case 4:
                {
                    cell.textLabel.text   = @"任天堂按钮布局";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    switchBAYX  = [[UISwitch alloc] initWithFrame:CGRectZero];
                    cell.accessoryView = switchBAYX;
                    [switchBAYX setOn:[op nintendoBAYX] animated:NO];
                    [switchBAYX addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                    break;
                }
            }
            break;
        }
        case 3:
        {
            cell.textLabel.text   = @"外部控制器";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [Options.arrayControlType optionAtIndex:op.controltype];
            break;
        }
            break;
        case 4:
        {
            switch (indexPath.row)
            {   case 0:
                {
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.textLabel.text = @"改变当前按钮布局";
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    break;
                }
                case 1:
                {
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.textLabel.text = @"重置当前按钮布局";
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    break;
                }
                case 2:
                {
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.textLabel.text = @"导出皮肤";
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    break;
                }
            }
            break;
        }
        case 5:
        {
            cell.textLabel.text   = @"P1 as P2,P3,P4";
            switchP1aspx  = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchP1aspx ;
            [switchP1aspx setOn:[op p1aspx] animated:NO];
            [switchP1aspx addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
            break;
        }
        case 6:
        {
            switch (indexPath.row)
            {   case 0:
                {
                    cell.textLabel.text   = @"触控摇杆";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [arrayAnalogDZValue objectAtIndex:op.analogDeadZoneValue];
                    break;
                }
            }
            break;
        }
        case 7:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text = @"启用";
                    switchLightgunEnabled = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [switchLightgunEnabled setOn:[op lightgunEnabled]];
                    [switchLightgunEnabled addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = switchLightgunEnabled;
                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"底部屏幕重载";
                    cell.detailTextLabel.text = @"有些游戏需要在屏幕外触发才能重新加载";
                    switchLightgunBottomScreenReload = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [switchLightgunBottomScreenReload setOn:[op lightgunBottomScreenReload]];
                    [switchLightgunBottomScreenReload addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = switchLightgunBottomScreenReload;
                    break;
                }
            }
            break;
        }
        case 8:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text = @"X";
                    switchTurboXButtonEnabled = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [switchTurboXButtonEnabled setOn:[op turboXEnabled]];
                    [switchTurboXButtonEnabled addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = switchTurboXButtonEnabled;
                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"Y";
                    switchTurboYButtonEnabled = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [switchTurboYButtonEnabled setOn:[op turboYEnabled]];
                    [switchTurboYButtonEnabled addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = switchTurboYButtonEnabled;
                    break;
                }
                case 2:
                {
                    cell.textLabel.text = @"A";
                    switchTurboAButtonEnabled = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [switchTurboAButtonEnabled setOn:[op turboAEnabled]];
                    [switchTurboAButtonEnabled addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = switchTurboAButtonEnabled;
                    break;
                }
                case 3:
                {
                    cell.textLabel.text = @"B";
                    switchTurboBButtonEnabled = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [switchTurboBButtonEnabled setOn:[op turboBEnabled]];
                    [switchTurboBButtonEnabled addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = switchTurboBButtonEnabled;
                    break;
                }
                case 4:
                {
                    cell.textLabel.text = @"L";
                    switchTurboLButtonEnabled = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [switchTurboLButtonEnabled setOn:[op turboLEnabled]];
                    [switchTurboLButtonEnabled addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = switchTurboLButtonEnabled;
                    break;
                }
                case 5:
                {
                    cell.textLabel.text = @"R";
                    switchTurboRButtonEnabled = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [switchTurboRButtonEnabled setOn:[op turboREnabled]];
                    [switchTurboRButtonEnabled addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = switchTurboRButtonEnabled;
                    break;
                }
            }
            break;
        }
        case 9:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text = @"启用";
                    switchTouchAnalogEnabled = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [switchTouchAnalogEnabled setOn:[op touchAnalogEnabled]];
                    [switchTouchAnalogEnabled addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = switchTouchAnalogEnabled;
                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"灵敏度";
                    sliderTouchAnalogSensitivity = [[UISlider alloc] initWithFrame:CGRectZero];
                    [sliderTouchAnalogSensitivity setMinimumValue:100.0];
                    [sliderTouchAnalogSensitivity setMaximumValue:1000.0];
                    [sliderTouchAnalogSensitivity setValue:[op touchAnalogSensitivity]];
                    [sliderTouchAnalogSensitivity addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                    sliderTouchAnalogSensitivity.translatesAutoresizingMaskIntoConstraints = NO;
                    [cell.contentView addSubview:sliderTouchAnalogSensitivity];
                    UIView *cellContentView = cell.contentView;
                    NSDictionary *viewBindings = NSDictionaryOfVariableBindings(cellContentView,sliderTouchAnalogSensitivity);
                    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[sliderTouchAnalogSensitivity]-8@750-|" options:0 metrics:nil views:viewBindings]];
                    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:sliderTouchAnalogSensitivity attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
                    [sliderTouchAnalogSensitivity addConstraint:[NSLayoutConstraint constraintWithItem:sliderTouchAnalogSensitivity attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0]];
                    break;
                }
                case 2:
                {
                    cell.textLabel.text = @"隐藏触控 D-Pad";
                    switchTouchAnalogHideTouchDirectionalPad = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [switchTouchAnalogHideTouchDirectionalPad setOn:[op touchAnalogHideTouchDirectionalPad]];
                    [switchTouchAnalogHideTouchDirectionalPad addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = switchTouchAnalogHideTouchDirectionalPad;
                    break;
                }
                case 3:
                {
                    cell.textLabel.text = @"隐藏触控按钮";
                    switchTouchAnalogHideTouchButtons = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [switchTouchAnalogHideTouchButtons setOn:[op touchAnalogHideTouchButtons]];
                    [switchTouchAnalogHideTouchButtons addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = switchTouchAnalogHideTouchButtons;
                    break;
                }
                break;
            }
            break;
        }
        case 10:
        {
            cell.textLabel.text = @"启用";
            switchTouchDirectionalEnabled = [[UISwitch alloc] initWithFrame:CGRectZero];
            [switchTouchDirectionalEnabled setOn:[op touchDirectionalEnabled]];
            [switchTouchDirectionalEnabled addTarget:self action:@selector(optionChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchTouchDirectionalEnabled;
            break;
        }
    }
    
    return cell;
}

- (void)optionChanged:(id)sender
{
    Options *op = [[Options alloc] init];
    
	if(sender == switchAnimatedButtons)
        op.animatedButtons=  [switchAnimatedButtons isOn];
    if(sender == switchAplusB)
        op.aplusb = [switchAplusB isOn];
    if(sender == switchP1aspx)
        op.p1aspx = [switchP1aspx isOn];
    if(sender == switchLightgunEnabled)
        op.lightgunEnabled = [switchLightgunEnabled isOn];
    if(sender == switchLightgunBottomScreenReload)
        op.lightgunBottomScreenReload = [switchLightgunBottomScreenReload isOn];
    if(sender == switchTurboXButtonEnabled)
        op.turboXEnabled = [switchTurboXButtonEnabled isOn];
    if(sender == switchTurboYButtonEnabled)
        op.turboYEnabled = [switchTurboYButtonEnabled isOn];
    if(sender == switchTurboAButtonEnabled)
        op.turboAEnabled = [switchTurboAButtonEnabled isOn];
    if(sender == switchTurboBButtonEnabled)
        op.turboBEnabled = [switchTurboBButtonEnabled isOn];
    if(sender == switchTurboLButtonEnabled)
        op.turboLEnabled = [switchTurboLButtonEnabled isOn];
    if(sender == switchTurboRButtonEnabled)
        op.turboREnabled = [switchTurboRButtonEnabled isOn];
    if (sender == switchTouchAnalogEnabled)
        op.touchAnalogEnabled = [switchTouchAnalogEnabled isOn];
    if(sender == sliderTouchAnalogSensitivity)
        op.touchAnalogSensitivity = [sliderTouchAnalogSensitivity value];
    if (sender == switchTouchAnalogHideTouchButtons)
        op.touchAnalogHideTouchButtons = [switchTouchAnalogHideTouchButtons isOn];
    if (sender == switchTouchAnalogHideTouchDirectionalPad)
        op.touchAnalogHideTouchDirectionalPad = [switchTouchAnalogHideTouchDirectionalPad isOn];
    if (sender == switchTouchDirectionalEnabled)
        op.touchDirectionalEnabled = [switchTouchDirectionalEnabled isOn];
    if ( sender == sliderTouchControlsOpacity )
        op.touchControlsOpacity = [sliderTouchControlsOpacity value];
    if(sender == switchBAYX)
        op.nintendoBAYX = [sender isOn];

    [op saveOptions];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(section==1 && row==0)
    {
        ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"touchtype" list:arrayTouchType title:cell.textLabel.text];
        [[self navigationController] pushViewController:listController animated:YES];
    }
    if(section==1 && row==1)
    {
        ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"sticktype" list:arrayStickType title:cell.textLabel.text];
        [[self navigationController] pushViewController:listController animated:YES];
    }
    if(section==1 && row==2)
    {
        ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"stickSize" list:arrayStickSizeValue title:cell.textLabel.text];
        [[self navigationController] pushViewController:listController animated:YES];
    }
    
    
    if(section==2 && row==0)
    {
        ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"numbuttons" list:arrayNumbuttons title:cell.textLabel.text];
        [[self navigationController] pushViewController:listController animated:YES];
    }
    if(section==2 && row==2)
    {
        ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"autofire" list:arrayAutofireValue title:cell.textLabel.text];
        [[self navigationController] pushViewController:listController animated:YES];
    }
    
    if(section==2 && row==3)
    {
        ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"buttonSize" list:arrayButtonSizeValue title:cell.textLabel.text];
        [[self navigationController] pushViewController:listController animated:YES];
    }

    if(section==3 && row==0)
    {
        ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"controltype" list:Options.arrayControlType title:cell.textLabel.text];
        [[self navigationController] pushViewController:listController animated:YES];
    }
    
    if(section==4 && row==0)
    {
        [self.emuController beginCustomizeCurrentLayout];
    }
    if(section==4 && row==1)
    {
        [self.emuController resetCurrentLayout];
        [tableView reloadData];
    }
    if(section==4 && row==2)
    {
        [self.emuController runExportSkin];
    }

    if(section==6 && row==0)
    {
        ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"analogDeadZoneValue" list:arrayAnalogDZValue title:cell.textLabel.text];
        [[self navigationController] pushViewController:listController animated:YES];
    }

    
}
    

@end
