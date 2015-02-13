@istest
public class Test_BLN_SignUpCon {
    
    static testmethod void TestBLN_SignUpCon  (){
    
        BLN_SignUpCon scon = new BLN_SignUpCon();
        Account acc = new Account();
        acc.Name='ph';
        insert acc;
        scon.ASUserEmail ='testsds@gmail.com';
        scon.ASLastName='raj';
        scon.ASFirstName ='r';
        scon.ASCompanyName ='global';
        scon.password ='dasd@wqw32';
        
        scon.BLS_SignUpUser();
        scon.signUpLogin();
        //scon.forDisplayError = false;
        //scon.login();
        scon.sendEmail();
    
    
    }
}