//
//  ChatView.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/15/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobChatViewController.h"

@interface JobChatViewController ()

@end

@implementation JobChatViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jobChatTable.delegate =self;
    self.jobChatTable.dataSource =self;
    
    
    //set self as the delegate to textField
    self.messageTextField.delegate =self;
    
    _messagesArray = [[NSMutableArray alloc] init];
    [self.messagesArray addObject:@"test"];
   //  NSLog(@"Array length = %d", _messagesArray.count);
    // Do any additional setup after loading the view from its nib.
    
    
    //detect when the table view is tapped while the text is being edited
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)];
    [self.jobChatTable addGestureRecognizer:tapGesture];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"SimpleTableItem";

    
    // JobCustomTableViewCell *cell = [[JobCustomTableViewCell alloc] init];
    UITableViewCell *cell = [_jobChatTable dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    
   // NSLog(@"Array length = %d", _messagesArray.count);
    cell.textLabel.text = [_messagesArray objectAtIndex:indexPath.row];

    
    return cell;
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   // return 5;
    return _messagesArray.count;
    
}







- (IBAction)sendButtonPressed:(UIButton *)sender {
    
    //done editing
    [self.messageTextField resignFirstResponder];
    

}



//MARK: Textfield delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.25 animations:^{
        _dockViewHightConstraint.constant =350;
        [self.view layoutIfNeeded];
        
        
    } completion:nil];
    
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.25 animations:^{
        _dockViewHightConstraint.constant =50;
        [self.view layoutIfNeeded];
        
        
    } completion:nil];
    
}

- (void) tableViewTapped{
    
    [self.messageTextField resignFirstResponder];
    NSLog(@"table tapppe");
}


@end
