@isTest
public class Test_BLN_ResetPasswordCon{
    static testmethod void Test_BLN_ResetPasswordCon(){
    BLN_ResetPasswordCon sb =  new BLN_ResetPasswordCon();
      sb.oldPassword = 'hello';
     sb.newPassword = 'hii';
     sb.verifyNewPassword = 'hii';   
    sb.booleanforDisplayBoothadminTab = true;
    sb.EventId = 'test';
    sb.changePassword();
    sb.checkUserId();
    
    }
 }