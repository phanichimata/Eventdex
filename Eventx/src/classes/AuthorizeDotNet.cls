public class AuthorizeDotNet{
  //Changed Phani
  //Set Merchant's Login id and transaction key
    string login = '';
    string transkey = '';
    //sagar change4
    //sagar change5
    //Class level useful variables
    private list<string> results;
    private boolean approved;
    private boolean declined;
    private boolean error;
    private string url;
    private boolean isTest;
    private string fields;
    private string response;
    private map<string, string> params;
    
    public AuthorizeDotNet(boolean isTest, String LoginId, String TransactionKey){
        login = LoginId;
        transkey = TransactionKey;
        results = new list<string>();
        approved = false;
        declined = false;
        error    = true;
        fields = '';
        params = new map<string, string>();
        
        //For setting sandbox or production
        this.isTest = isTest;
        if (this.isTest){
            this.url = 'https://test.authorize.net/gateway/transact.dll';
        }
        else {
            this.url = 'https://secure.authorize.net/gateway/transact.dll';
        }

  
          system.debug('#### ' +login +'@@@@@@@@@ '+transkey );       
        //Some Predefined useful parameters for authorize.net API
        params.put('x_delim_data', 'TRUE');
        params.put('x_delim_char', '|');
        params.put('x_relay_response', 'FALSE');
        params.put('x_url', 'false');
        params.put('x_version', 'false');
        params.put('x_method', 'CC');
        params.put('x_type', 'AUTH_ONLY');
        params.put('x_login', login);
        params.put('x_tran_key', transkey);
        params.put('x_description', 'Sample Transaction');
        params.put('x_description', '0');            
        params.put('x_version','3.1');
        // params.put('x_address ','');
        
    }
 
    
    public void transaction(string cardnum, string expiration, string amount, string cvv, string invoice, string tax){
        params.put('x_card_num', cardnum);
        params.put('x_exp_date', expiration);
        params.put('x_amount', amount);
        params.put('x_po_num', invoice);
        params.put('x_tax', tax);
        params.put('x_card_code', cvv);       
    }
    
    //Calls the Authorize.Net service and fetch the response
    public void process(integer retries){
        retries = 3;
        system.debug('************* '+params);
        this.prepareParameters();
                
        integer count = 0;
        while (count < retries){
            HttpRequest hReq = new HttpRequest();
            hReq.setEndpoint(this.url);
            hReq.setMethod('POST');
            hReq.setBody(this.fields);
            Http con = new Http();
            if(!Test.isRunningTest()){
                HttpResponse res = con.send(hReq);
                this.response = res.getBody();
            }else{
                //Test response filling in case Test class is running
                this.response = '1|1|1|This transaction has been approved.|LDV9JR|Y|2160295577||0|600.00|CC|auth_capture||aslam|bari||dfsdf||wa|5555||||||||||||||||||71AFA2003D02930E47E84F23E14E07C3|P|2|||||||||||XXXX1111|Visa|||||||||||||||||false|1';
            }
            system.debug('#### ' + this.response);
            this.parseResults();
            if (this.getResultResponseFull() == 'Approved'){
                this.approved = true;
                this.declined = false;
                this.error    = false;
                break;
            }
            else if (this.getResultResponseFull() == 'Declined'){
                this.approved = false;
                this.declined = true;
                this.error    = false;
                break;
            }
            count++;
        }
    }

    private void parseResults(){
        this.results = this.response.split('\\|');
    }

    public void setParameter(String param, String value){
       system.debug('XXXXXXXXX '+param+' YYYYYYYYY '+value);
        param                = param.trim();
        value                = value.trim();
        this.params.put(param, value);
    }

    public void setTransactionType(String types){
        this.params.put('x_type', types.toUpperCase().trim());
    }

    private void prepareParameters(){
     system.debug('$$$$$$$$$$ '+params.keyset());
     
        for(String ss: params.keyset()){
            this.fields += ss + '=' +  EncodingUtil.UrlEncode(params.get(ss),'UTF-8') + '&';
        }
        this.fields = this.fields.substring(0,this.fields.length() - 1);
        system.debug('************  '+fields );
    }

    public string getResultResponse(){
        return this.results[0];
    }

    public string getResultResponseFull(){
        list<string> response = new list<string>();
        response.add('');
        response.add('Approved');
        response.add('Declined');
        response.add('Error');
        if(this.results[0] == '1')
            return response[1];
        else if(this.results[0] == '2')
            return response[2];
        else if(this.results[0] == '3')
            return response[3];
        
        return '';
    }

    public boolean isApproved(){
        return this.approved;
    }

    public boolean isDeclined(){
        return this.declined;
    }

    public boolean isError(){
        return this.error;
    }

    public string getResponseText(){
        return this.results[3];
    }

    public string getAuthCode(){
        return this.results[4];
    }

    public string getAVSResponse(){
        return this.results[5];
    }

    public string getTransactionID(){
        return this.results[6];
    }

}