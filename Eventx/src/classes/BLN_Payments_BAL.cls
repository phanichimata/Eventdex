public with sharing class BLN_Payments_BAL{

/*********************************************************************************************************************************************
*   Controller Name         : BLN_Payments_BAL
*   Date                    : 19/06/2014 
*   Author                  : Mahesh Sakunala
*   Purpose                 : This class is for routing payments from registrants to the event payment gateways.
**********************************************************************************************************************************************/

// ---------------------------------------------------------------- Variables Declaration Start ----------------------------------------------------------------------------
public string Stripe_API_Key{get;set;}
public string StripePaymentId{get;set;}
public string StripeResponseMessage{get;set;}
public String StripeRefreshToken{get;set;}
// ---------------------------------------------------------------- Variables Declaration Start ----------------------------------------------------------------------------

    
// --------------------------------------------------------------- Stripe Payments Method Start ----------------------------------------------------------------------------    
    public String stripePayments(String EventId,String CreditCardNumber,String CreditCardMonth,String CreditCardYear,String CreditCardCVV,Decimal TotalAmount,Decimal FeeAmount, Boolean BoothleadsFee){
      system.debug('CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC '+EventId+' '+CreditCardNumber +'  '+CreditCardMonth+'  '+CreditCardYear +' '+CreditCardCVV +'  '+TotalAmount);
        //Get Currency
        BLN_Currency_DAO CurDAO =new BLN_Currency_DAO();
        Currency__c cur = CurDAO.getCurrencyDetails('id,name','name=\'USD\' LIMIT 1');
        
        // Get Event Payment Gateways from Event PayGateway DAO 
        BLN_EventPayGateway_DAO EventPayGatewayDAO = new BLN_EventPayGateway_DAO();
        LIST<Event_Pay_Gateway__c> EventPayGateWays = EventPayGatewayDAO.getEventPayGateWays(EventId);
        
          List<Pay_Gateway__c> boothleadspaygate = new List<Pay_Gateway__c>();
          boothleadspaygate = [SELECT id,Company__c,Min_amount_to_accept__c,PGateway_Type__c,PG_Email_Id__c,PG_Pass_Secret__c,PG_Signature__c,PG_User_Key__c,PP_Fee_Payer__c,PP_Payment_Type__c,Service_Fee__c from Pay_Gateway__c where Company__r.Name ='EventdexLive'];
                
        
        for(Event_Pay_Gateway__c epg:EventPayGateWays){
            if(epg.Pay_Gateway__r.PGateway_Type__r.Name == 'Stripe'){
               
                if(boothleadspaygate.size()>0){
                 Stripe_API_Key = boothleadspaygate[0].PG_Pass_Secret__c;
                 // Stripe_API_Key = epg.Pay_Gateway__r.PGateway_Type__r.BoothLeads_Stripe_Secret__c;
               }
                StripeRefreshToken = epg.Pay_Gateway__r.PG_Signature__c; 
                StripePaymentId = epg.Pay_Gateway__r.Id;
            }
        }
        
        Decimal TotalChargeAmount = TotalAmount*100;
        String Amount = String.valueOf(Integer.Valueof(TotalChargeAmount));
        
        Decimal FeeChargeAmount = FeeAmount *100;
        String FeesAmount = String.valueOf(Integer.Valueof(FeeChargeAmount));
        
        // Edit By Phani  
        if(EventId!=null && BoothleadsFee == TRUE){
           Stripe_API_Key='sk_test_SEppbKiXBACmm9tRsJZkpB8l';
          system.debug('DDDDDDDDDD '+Stripe_API_Key);
            Stripe StripeRequest = new Stripe(Stripe_API_Key);
            StripeResponseModel StripeResponse = StripeRequest.createCharge(CreditCardNumber, CreditCardYear, CreditCardMonth, CreditCardCVV, Amount,cur.name,'Testing');

            if(!StripeResponse.isError){
                system.debug('Charge ID: ' + StripeResponse.id);
                StripeResponseMessage = StripeResponse.id;
            }
            else{
                system.debug('Error Message :' + StripeResponse.errorResponse.message);
                StripeResponseMessage = 'Error';
            }
            return StripeResponseMessage;
        }
        else{
            
            // Getting Access Token using Refresh Token
            Http RToken = new Http();
           
            HttpRequest reqRToken = new HttpRequest();
            reqRToken.setEndpoint('https://connect.stripe.com/oauth/token');
            String RBodyParameters = 'grant_type=refresh_token&client_secret='+Stripe_API_Key+'&refresh_token='+StripeRefreshToken; 
            reqRToken.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            reqRToken.setBody(RBodyParameters);
            reqRToken.setMethod('POST');
            
            HttpResponse resRToken;
            resRToken = RToken.send(reqRToken);

            JSONRTokenWrapper RTokenObj = (JSONRTokenWrapper)JSON.deserialize(resRToken.getBody(), JSONRTokenWrapper.class);
            
            
            // Getting Card Token using Access Token
            Http CToken = new Http();
            
            HttpRequest reqCToken = new HttpRequest();
            reqCToken.setEndpoint('https://api.stripe.com/v1/tokens');
            String authorizationHeader = 'BEARER ' + RTokenObj.access_token;
            String TBodyParameters = 'card[number]='+CreditCardNumber+'&card[exp_month]='+CreditCardMonth+'&card[exp_year]='+CreditCardYear+'&card[cvc]='+CreditCardCVV;
            reqCToken.setHeader('Authorization', authorizationHeader);
            reqCToken.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            reqCToken.setBody(TBodyParameters);
            reqCToken.setMethod('POST');
            
            HttpResponse resCToken;
            resCToken = CToken.send(reqCToken);
  
            JSONTokenWrapper CTokenObj = (JSONTokenWrapper)JSON.deserialize(resCToken.getBody(), JSONTokenWrapper.class);
            
            
            // Creating Charge using token
            Http ChargeToken = new Http();
            
            HttpRequest reqChargeToken = new HttpRequest();
            reqChargeToken.setEndpoint('https://api.stripe.com/v1/charges');
            String ChargeAuthorizationHeader = 'BEARER ' + RTokenObj.access_token;
            String ChargeBodyParameters = 'amount='+Amount+'&application_fee='+FeesAmount+'&currency=usd&card='+CTokenObj.id; 
            reqChargeToken.setHeader('Authorization', ChargeAuthorizationHeader);
            reqChargeToken.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            reqChargeToken.setBody(ChargeBodyParameters);
            reqChargeToken.setMethod('POST');
            
            HttpResponse resChargeToken;
            resChargeToken = ChargeToken.send(reqChargeToken);

            JSONChargeWrapper ChargeTokenObj = (JSONChargeWrapper)JSON.deserialize(resChargeToken.getBody(), JSONChargeWrapper.class);

            system.debug('Charge ID: ' + ChargeTokenObj.id);
            StripeResponseMessage = ChargeTokenObj.id;
            
                        
            if(RTokenObj.refresh_token != NULL){
                SET<Id> PaymentIDs = new SET<Id>();
                PaymentIDs.add(StripePaymentId);
                BLN_PayGateway_DAO PayGatewayDAO = new BLN_PayGateway_DAO();
                Pay_Gateway__c PGateway = new Pay_Gateway__c();
                LIST<Pay_Gateway__c> PGatewayList = new LIST<Pay_Gateway__c>();
                PGatewayList = PayGatewayDAO.getPayGateWays(PaymentIDs);
                for(Pay_Gateway__c PG:PGatewayList){
                    PGateway = PG;
                }
                PGateway.PG_Signature__c = RTokenObj.refresh_token;
                BLN_StatusMessage PayMessage = PayGatewayDAO.updatePayGateway(PGateway);
                system.debug('Updated Pay Gateway:'+PayMessage.successId);
            }
            
            
            return StripeResponseMessage;
            
        }

    }
    
    public class JSONRTokenWrapper{    
        public String access_token; 
        public string refresh_token;       
    }
    
    public class JSONTokenWrapper{    
        public String id;     
    }
    
    public class JSONChargeWrapper{    
        public String id;     
    }
    
    
// ---------------------------------------------------------------- Stripe Payments Method End ----------------------------------------------------------------------------- 
    
}