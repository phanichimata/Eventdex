/***********************************************************************************************
*   Controller Name : BLN_PromoCodeReportCon_BAL
*   Date            : 10/27/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the PromoCode Report
*   Change History  : 10/27/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*    10/27/2014              Manasa Gandham                 To Create Page
*  
**************************************************************************************************/

public without sharing class BLN_PromoCodeReportCon_BAL{

    public BLN_PromoCodeReportCon_BAL(){
    
    }  
    
    public BLN_Promotion_DAO promotionsDAOClass{get; set;}
    
    public LIST<promoCodeInner> promotionsListForEvent(String EventId, Date FromDate, Date ToDate, String SearchString){
        
        promotionsDAOClass= new BLN_Promotion_DAO();
        LIST<Promotion__c> promosList= new LIST<Promotion__c>();
        String queryString= '';
        queryString= ' Event__c = \''+EventId+'\'';
        queryString += ' AND Status__c != \''+'inActive'+'\'';
        system.debug('  000000000000  '+queryString);
        if(FromDate != NULL){
            FromDate= FromDate.addDays(1);            
            dateTime d1 = FromDate;
            string FromDateStr= d1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            queryString += ' AND CreatedDate >= '+FromDateStr;
        } 
        system.debug('  111111111  '+queryString);
        if(ToDate != NULL){
            ToDate= ToDate.addDays(1);
            dateTime d1 = ToDate;
            string ToDateStr= d1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');

            queryString += ' AND CreatedDate <='+ToDateStr;            
        }
        if(SearchString != NULL){
            queryString += ' AND (Name Like \'%'+SearchString+'%\''+' OR Promo_Code__c Like \'%'+SearchString+'%\''+' OR Promotion_Type__c Like \'%'+SearchString+'%\''+' OR Discount_Type__c Like \'%'+SearchString+'%\''+')'; 
          /*  if(SearchString.isNumeric()){
                queryString += ' OR Discount_Value__c = \''+Decimal.valueOf(SearchString)+'%\''+')';
            }else{
                queryString += ')';
            }
            */
        }
        promosList= promotionsDAOClass.promotionslist(queryString);
        system.debug(promosList.size()+'  PROMO CODES SIZE '+promosList);
        LIST<promoCodeInner> promoCodeInnerList= new LIST<promoCodeInner>();
        for(Promotion__c promotion: promosList){
            LIST<itemPromotionInner> itemPromotionInnerList= new LIST<itemPromotionInner>();
            for(Item_Promotion__c itemPromotion: promotion.Item_Promotions__r){
                Decimal discountAmount=0;
                Decimal TotalPrice= 0;
                try{
                    if(itemPromotion.Buy_Item_Quantity__c != NULL && itemPromotion.Buy_Item__r.price__c != NULL){
                        TotalPrice = itemPromotion.Buy_Item_Quantity__c*itemPromotion.Buy_Item__r.price__c;
                        System.debug('@@@@  BBBBB  '+TotalPrice);
                    }
                     if(itemPromotion.Free_Item_Quantity__c != NULL && itemPromotion.Free_Item__r.price__c != NULL){
                        TotalPrice = itemPromotion.Free_Item_Quantity__c*itemPromotion.Free_Item__r.price__c;
                        System.debug('@@@@ FFFFFF  '+TotalPrice);
                    }
                    /*else if(itemPromotion.Buy_Item_Quantity__c != NULL && itemPromotion.Free_Item_Quantity__c != NULL && itemPromotion.Free_Item_Quantity__c != NULL && itemPromotion.Free_Item__r.price__c != NULL){
                        TotalPrice = itemPromotion.Free_Item_Quantity__c*itemPromotion.Free_Item__r.price__c;
                        System.debug('####'+TotalPrice);
                    }*/
                }Catch(Exception e){ }
                if(itemPromotion.Item_Discount_Type__c == 'Percent'){  
                    if(itemPromotion.Item_Discount_Value__c != NULL){                  
                        discountAmount= (TotalPrice*itemPromotion.Item_Discount_Value__c)/100;
                    }
                }
                if(itemPromotion.Item_Discount_Type__c == 'Amount'){
                    if(itemPromotion.Item_Discount_Value__c != NULL){                  
                        discountAmount= itemPromotion.Item_Discount_Value__c;
                    }
                }
                itemPromotionInnerList.add(new itemPromotionInner(itemPromotion, discountAmount));
                system.debug(itemPromotionInnerList.size()+'  ITEM LIST INNER  '+itemPromotionInnerList);
            }
            promoCodeInnerList.add(new promoCodeInner(promotion, itemPromotionInnerList));
            system.debug(itemPromotionInnerList.size()+'  PROMO CODES INNER  '+itemPromotionInnerList);
        }
        return promoCodeInnerList;
    }
    

    public class promoCodeInner{
        
        public Promotion__c promotionData{get; set;}
        public LIST<itemPromotionInner> itemPromotionList{get; set;}
        
        public promoCodeInner(Promotion__c promotionData, LIST<itemPromotionInner> itemPromotionList){
            this.promotionData= promotionData;
            this.itemPromotionList= itemPromotionList;
        }
    }
    
    public class itemPromotionInner{
        
        public Item_Promotion__c itemPromotionData{get; set;}
        public Decimal discountedPrice{get; set;}
        
        public itemPromotionInner(Item_Promotion__c itemPromotionData, Decimal discountedPrice){
            
            this.itemPromotionData= itemPromotionData;
            this.discountedPrice= discountedPrice;
        }
    
    }
    
    
}