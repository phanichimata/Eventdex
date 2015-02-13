/***********************************************************************************************
*   Controller Name : BLN_TicketSalesReportCon_BAL
*   Date            : 10/30/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the Ticket Sales Report
*   Change History  : 10/30/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*    10/30/2014              Manasa Gandham                 To Create Page
*  
**************************************************************************************************/

public without sharing class BLN_TicketSalesReportCon_BAL{

    public BLN_TicketSalesReportCon_BAL(){
        
    }  
    
    public BLN_Order_DAO ordersDAOClass{get; set;}
    public BLN_Item_DAO ticketsDAOClass{get; set;}
    public BLN_OrderItem_DAO orderItemDAOClass{get; set;}
    public BLN_PGateway_Type_DAO payGateWayTypeDAOClass{get; set;}
    
    public LIST<ticketSalesInner> ticketsSalesForEvent(String EventId, Date FromDate, Date ToDate){
        
        ordersDAOClass= new BLN_Order_DAO();
        ticketsDAOClass= new BLN_Item_DAO();
        orderItemDAOClass= new BLN_OrderItem_DAO();
        payGateWayTypeDAOClass= new BLN_PGateway_Type_DAO(); 
        
        LIST<order__c> ordersList= new LIST<order__c>();
        String queryString= '';
        queryString= ' where Events__c = \''+EventId+'\'';
        queryString += ' AND Transaction_Status__c = \''+'Completed'+'\'';
        system.debug('  000000000000  '+queryString);        
        ordersList= ordersDAOClass.orderListForEvent(queryString);
          system.debug(' qqqqq  '+ ordersList); 

        MAP<String, Decimal> itemCountMAP= new MAP<String, Decimal>();          
        MAP<String, Decimal> itemDiscountMAP= new MAP<String, Decimal>();
        MAP<String, Decimal> itemFeeMAP= new MAP<String, Decimal>();
        MAP<String, Decimal> itemAmountMAP= new MAP<String, Decimal>();   
        
        MAP<String, Decimal> TotalItemFeeAmountMAP= new MAP<String, Decimal>();             
        MAP<String, Decimal> itemTotalDiscountMAP= new MAP<String, Decimal>(); 
        MAP<String, Decimal> itemTotalFeeMAP= new MAP<String, Decimal>();    
        MAP<String, Decimal> itemTotalAmountMAP= new MAP<String, Decimal>();
        MAP<String, Decimal> itemTotalCountMAP= new MAP<String, Decimal>();
        
        MAP<String, Decimal> paymentTypeCountMAP= new MAP<String, Decimal>();
        MAP<String, Decimal> paymentTypeDiscountMAP= new MAP<String, Decimal>(); 
        MAP<String, Decimal> paymentTypeFeeMAP= new MAP<String, Decimal>();    
        MAP<String, Decimal> paymentTypeAmountMAP= new MAP<String, Decimal>();

       
        system.debug(ordersList.size()+'  ORDERS SIZE ');  
        
        SET<Id> orderItemIdsSET= new SET<Id>();
        orderItemIdsSET= orderItemDAOClass.validOrderItemList(EventId);   
           
        for(order__c order: ordersList){
            system.debug(' 00000000000000 '+order);        
            LIST<Payment__c> PaymentsList= new LIST<Payment__c>();
            PaymentsList= order.Payments__r;
            String paymentTypeString='';
            if(PaymentsList.size() >0){
                        
            system.debug(' 11111111111111 '+paymentTypeString);        
            LIST<Order_Item__c> orderItemsList= new LIST<Order_Item__c>();
            orderItemsList= order.Order_Items__r;
            for(Order_Item__c orderItem: orderItemsList){
                system.debug(orderItem.Id+'   ORDER ITEM ID '+orderItemIdsSET.contains(orderItem.Id));
                if(orderItemIdsSET.contains(orderItem.Id)){
                    if(orderItem.Status__c == 'Active'){
                        paymentTypeString='';
                        /*
                        if(PaymentsList[0].Payment_Mode__c == 'Check'){
                            paymentTypeString= PaymentsList[0].Payment_Mode__c;            
                        }else if(PaymentsList[0].Payment_Mode__c == 'MasterCard' || PaymentsList[0].Payment_Mode__c == 'Visa' || PaymentsList[0].Payment_Mode__c == 'Discover' || PaymentsList[0].Payment_Mode__c == 'American Express'){
                            paymentTypeString= 'CreditCard';                        
                        }else if(PaymentsList[0].Payment_Mode__c == 'Cash'){
                            paymentTypeString= PaymentsList[0].Payment_Mode__c;            
                        }else if(PaymentsList[0].Payment_Mode__c == 'External Pay Gateway'){
                            paymentTypeString= 'External Pay';            
                        }
                        */
                        if(PaymentsList[0].event_paygateway_id__c != NULL){
                            paymentTypeString= PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name;
                        
                        system.debug(PaymentsList[0].event_paygateway_id__c+' PPPPPPPPPPPPPPPPP   '+paymentTypeString+'  '+PaymentsList[0].Id); 
                        if(! paymentTypeString.contains(orderItem.Item__c)){
                            paymentTypeString= orderItem.Item__c+'-'+paymentTypeString;
                        }                        
                        system.debug(' 22222222222222 '+paymentTypeString); 
                        
                        // Assigning Payment Type Count 
                           if(paymentTypeCountMAP.containsKey(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name)){
                            Decimal typeCount= paymentTypeCountMAP.get(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name);
                            typeCount= typeCount+orderItem.Item_Quantity__c;
                            paymentTypeCountMAP.put(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name, typeCount);
                        }else{
                            paymentTypeCountMAP.put(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name, orderItem.Item_Quantity__c);
                        }
                        
                        // Assigning Payment Type Discount
                           if(paymentTypeDiscountMAP.containsKey(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name)){
                            Decimal typeDiscount= paymentTypeDiscountMAP.get(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name);
                            if(orderItem.Item_Discount__c != NULL){
                                typeDiscount= typeDiscount+orderItem.Item_Discount__c;
                            }
                            paymentTypeDiscountMAP.put(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name, typeDiscount);
                        }else{
                            if(orderItem.Item_Discount__c != NULL){
                                paymentTypeDiscountMAP.put(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name, orderItem.Item_Discount__c);
                            }
                        }
                        
                         // Assigning Payment Type Fee
                         system.debug(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name+'  PAYMENT TYPE '+paymentTypeFeeMAP);
                           if(paymentTypeFeeMAP.containsKey(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name)){
                               Decimal typeFee= 0;
                               if(paymentTypeDiscountMAP.get(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name) != NULL){
                                   typeFee= paymentTypeDiscountMAP.get(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name);
                               }
                            
                            system.debug(typeFee+'  TYPE FEE '+orderItem.Item_Fee__c);
                            if(orderItem.Item_Fee__c != NULL){
                                typeFee= typeFee+orderItem.Item_Fee__c;
                            }
                            paymentTypeFeeMAP.put(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name, typeFee);
                        }else{
                            if(orderItem.Item_Fee__c != NULL){
                                paymentTypeFeeMAP.put(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name, orderItem.Item_Fee__c);
                            }
                        }
                        
                        // Assigning Payment Type Amount
                          if(paymentTypeAmountMAP.containsKey(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name)){
                            Decimal totalAmount= paymentTypeAmountMAP.get(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name);
                            Decimal amountAfterDiscount= 0;
                            Decimal itemFee= 0;
                            if(orderItem.Item_Discount__c != NULL){
                                amountAfterDiscount= orderItem.Item_Total__c- orderItem.Item_Discount__c;
                            }else{
                                amountAfterDiscount= orderItem.Item_Total__c;
                            }
                            if(orderItem.Item_Fee__c != NULL){
                                itemFee= orderItem.Item_Fee__c;
                            }else{
                                itemFee= 0;
                            }
                            system.debug('  ITEM FEE WITH PAYMENT TYPE '+itemFee);
                            totalAmount= totalAmount+amountAfterDiscount+itemFee;
                            paymentTypeAmountMAP.put(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name, totalAmount);
                        }else{
                            Decimal amountAfterDiscount= 0;
                            if(orderItem.Item_Discount__c != NULL){
                                amountAfterDiscount= orderItem.Item_Total__c- orderItem.Item_Discount__c;
                            }else{
                                if(orderItem.Item_Total__c != NULL){
                                    amountAfterDiscount= orderItem.Item_Total__c;
                                }
                            }
                            
                            if(orderItem.Item_Fee__c != NULL){
                                amountAfterDiscount += orderItem.Item_Fee__c;
                            }

                            paymentTypeAmountMAP.put(PaymentsList[0].event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name, amountAfterDiscount);
                        }
                        
                            
                        //Assigning Item Payment type Count to MAP                    
                        if(itemCountMAP.containsKey(paymentTypeString)){
                            Decimal itemCount= itemCountMAP.get(paymentTypeString);
                            itemCount= itemCount+orderItem.Item_Quantity__c;
                            itemCountMAP.put(paymentTypeString, itemCount);
                        }else{
                            itemCountMAP.put(paymentTypeString, orderItem.Item_Quantity__c);
                        }
                        system.debug(itemCountMAP.size()+'  ITEM COUNT MAP WITH PAYMENT TYPE  '+itemCountMAP);
                        system.debug(orderItem.Item_Quantity__c+'  ITEM QUANTITY AND ITEM ID  '+orderItem.Item__c);
                        //Assigning Item Total Count to MAP                    
                        if(itemTotalCountMAP.containsKey(orderItem.Item__c)){
                            Decimal itemCount= 0;
                            if(itemTotalCountMAP.get(orderItem.Item__c) != NULL){
                                itemCount= itemTotalCountMAP.get(orderItem.Item__c);
                            }else{
                                itemCount= 0;
                            }    
                            system.debug(itemCount+'  ORDER ITEM QUANTITY '+orderItem.Item_Quantity__c);                        
                            itemCount= itemCount+orderItem.Item_Quantity__c;
                            itemTotalCountMAP.put(orderItem.Item__c, itemCount);
                        }else{
                            itemTotalCountMAP.put(orderItem.Item__c, orderItem.Item_Quantity__c);
                        }
                        system.debug(itemTotalCountMAP.size()+'  ITEM TOTAL COUNT MAP WITH PAYMENT TYPE '+  itemTotalCountMAP);
                        
                        
                        //Assiging discount with payment type to MAP
                        if(itemDiscountMAP.containsKey(paymentTypeString)){
                            Decimal discountAmount= 0;
                            if(itemDiscountMAP.get(paymentTypeString) != NULL){
                                discountAmount= itemDiscountMAP.get(paymentTypeString);
                            }else{
                                discountAmount= 0;
                            }
                            if(orderItem.Item_Discount__c != NULL){
                                discountAmount= discountAmount+orderItem.Item_Discount__c;
                            }
                            
                            itemDiscountMAP.put(paymentTypeString, discountAmount);
                        }else{
                            itemDiscountMAP.put(paymentTypeString, orderItem.Item_Discount__c);
                        }
                        system.debug(itemDiscountMAP.size()+'  ITEM DISCOUNT MAP WITH PAYMENT TYPE  '+itemDiscountMAP);
                        
                         //Assiging total Tickets discount to MAP
                        if(itemTotalDiscountMAP.containsKey(orderItem.Item__c)){   
                            Decimal discountAmount=0;     
                            if(itemTotalDiscountMAP.get(orderItem.Item__c) != NULL){
                                discountAmount= itemTotalDiscountMAP.get(orderItem.Item__c);
                            }               
                            
                            system.debug(itemTotalDiscountMAP.get(orderItem.Item__c)+'  DISCOUNT AMOUNT  '+discountAmount);
                            if(orderItem.Item_Discount__c != NULL){
                                discountAmount= discountAmount+orderItem.Item_Discount__c;
                            }    
                            itemTotalDiscountMAP.put(orderItem.Item__c, discountAmount);
                        }else{
                            itemTotalDiscountMAP.put(orderItem.Item__c, orderItem.Item_Discount__c);
                        }
                       system.debug(itemTotalDiscountMAP.size()+'  ITEM TOTAL DISCOUNT MAP '+itemTotalDiscountMAP);  
                                 
                                  
                       // <!----------------------------------------------------------------------------------------------------->
                        //Assiging fee values with Payment Type to the MAP 
                        if(itemFeeMAP.containsKey(paymentTypeString)){
                            Decimal feeAmountValue= 0;
                            if(itemFeeMAP.get(paymentTypeString) != NULL){
                                feeAmountValue= itemFeeMAP.get(paymentTypeString);
                            }else{
                                feeAmountValue= 0;
                            }                                 
                                
                            if(orderItem.Item_Fee__c != NULL){
                                feeAmountValue= feeAmountValue+orderItem.Item_Fee__c ;
                            }                            
                            itemFeeMAP.put(paymentTypeString, feeAmountValue);
                        }else{
                            itemFeeMAP.put(paymentTypeString, orderItem.Item_Fee__c );
                        }
                        system.debug(itemFeeMAP.size()+'  ITEM FEE MAP WITH PAYMENT TYPE  '+itemFeeMAP);
                        
                         //Assiging Total fee amount value to MAP
                        if(TotalItemFeeAmountMAP.containsKey(orderItem.Item__c)){   
                            Decimal totalFeeAmountValue=0;     
                            if(TotalItemFeeAmountMAP.get(orderItem.Item__c) != NULL){
                                totalFeeAmountValue= TotalItemFeeAmountMAP.get(orderItem.Item__c);
                            } 
                            if(orderItem.Item_Fee__c != NULL){
                                totalFeeAmountValue= totalFeeAmountValue+orderItem.Item_Fee__c ;
                            }    
                            TotalItemFeeAmountMAP.put(orderItem.Item__c, totalFeeAmountValue);
                        }else{
                            TotalItemFeeAmountMAP.put(orderItem.Item__c, orderItem.Item_Fee__c );
                        }
                        system.debug(TotalItemFeeAmountMAP.size()+'  ITEM TOTAL FEE AMOUNT MAP '+TotalItemFeeAmountMAP); 
                        
                        //Assiging Ticket Amount with payment type to MAP
                        if(itemAmountMAP.containsKey(paymentTypeString)){
                            Decimal totalAmount= itemAmountMAP.get(paymentTypeString);
                            Decimal amountAfterDiscount= 0;
                            Decimal itemFee= 0;
                            if(orderItem.Item_Discount__c != NULL){
                                amountAfterDiscount= orderItem.Item_Total__c- orderItem.Item_Discount__c;
                            }else{
                                amountAfterDiscount= orderItem.Item_Total__c;
                            }
                            if(orderItem.Item_Fee__c != NULL){
                                itemFee= orderItem.Item_Fee__c;
                            }else{
                                itemFee= 0;
                            }
                            system.debug('  ITEM FEE WITH PAYMENT TYPE '+itemFee);
                            totalAmount= totalAmount+amountAfterDiscount+itemFee;
                            itemAmountMAP.put(paymentTypeString, totalAmount);
                        }else{
                            Decimal amountAfterDiscount= 0;
                            if(orderItem.Item_Discount__c != NULL){
                                amountAfterDiscount= orderItem.Item_Total__c- orderItem.Item_Discount__c;
                            }else{
                                if(orderItem.Item_Total__c != NULL){
                                    amountAfterDiscount= orderItem.Item_Total__c;
                                }
                            }
                            
                            if(orderItem.Item_Fee__c != NULL){
                                amountAfterDiscount += orderItem.Item_Fee__c;
                            }

                            itemAmountMAP.put(paymentTypeString, amountAfterDiscount);
                        }
                        system.debug(itemAmountMAP.size()+'  ITEM TOTAL AMOUNT MAP WITH PAYMENT TYPE '+itemAmountMAP);
                        
                        
                        //Assiging Total Tickets Amount to MAP
                        if(itemTotalAmountMAP.containsKey(orderItem.Item__c)){   
                            Decimal totalAmount=0;     
                            if(itemTotalAmountMAP.get(orderItem.Item__c) != NULL){
                                totalAmount= itemTotalAmountMAP.get(orderItem.Item__c);
                            }   
                            Decimal amountAfterDiscount= 0;
                            Decimal itemFee= 0;
                            if(orderItem.Item_Discount__c != NULL){
                                amountAfterDiscount= orderItem.Item_Total__c- orderItem.Item_Discount__c;
                            }else{
                                if(orderItem.Item_Total__c != NULL){
                                    amountAfterDiscount= orderItem.Item_Total__c;
                                }
                            }    
                            if(orderItem.Item_Fee__c != NULL){
                                itemFee= orderItem.Item_Fee__c;
                            }else{
                                itemFee= 0;
                            }
                            totalAmount= totalAmount+amountAfterDiscount+itemFee;                           
                            system.debug(itemTotalAmountMAP.get(orderItem.Item__c)+'  TOTAL AMOUNT  '+totalAmount);                                
                            itemTotalAmountMAP.put(orderItem.Item__c, totalAmount);
                        }else{
                            Decimal amountAfterDiscount= 0;
                            if(orderItem.Item_Discount__c != NULL){
                                amountAfterDiscount= orderItem.Item_Total__c- orderItem.Item_Discount__c;
                            }else{
                                if(orderItem.Item_Total__c != NULL){
                                    amountAfterDiscount= orderItem.Item_Total__c;
                                }
                            }  
                            if(orderItem.Item_Fee__c != NULL){
                                amountAfterDiscount += orderItem.Item_Fee__c;
                            } 
                            itemTotalAmountMAP.put(orderItem.Item__c, amountAfterDiscount);
                        }
                          system.debug(itemTotalAmountMAP.size()+'  ITEM TOTAL AMOUNT MAP '+itemTotalAmountMAP);                       
                        
                                  
                       //stop loop            
                        }
                    }
                }               
                
            }
            }
        
        }        
        system.debug(itemTotalCountMAP.size()+' TOTAL ITEM COUNT MAP!!!!!! '+itemTotalCountMAP);
        system.debug(itemTotalAmountMAP.size()+'  ITEM TOTAL AMOUNT PAYMENT TYPE!!!!!! '+itemTotalAmountMAP);
        // ********************************************
        
        //Building Search Functionality in between From and To Dates
        SET<Id> TicketIds= new SET<Id>();            
            
           
           LIST<LIST<BLN_Item__c>> ListOfItems= new LIST<LIST<BLN_Item__c>>();
            LIST<BLN_Item__c> itemList= new LIST<BLN_Item__c>();
            LIST<BLN_Item__c> itemList999= new LIST<BLN_Item__c>();
            itemList= ticketsDAOClass.itemsListForEvent(EventId, FromDate, ToDate);
        
            //for(BLN_Item__c item : itemList){
                //TicketIds.add(item.items__r);
            //}
        
        
        // *************************************************************************************************** 
       
    
        //Getting Tickets List belongs to Event
                LIST<BLN_Item__c> itemsList= new LIST<BLN_Item__c>();
        
        itemsList= ticketsDAOClass.itemsListForEvent(EventId, FromDate, ToDate);
        
        Decimal TotalTicketCount= 0;
        Decimal TotalAmount= 0;
        Decimal TotalDiscountAmount= 0;
        Decimal TotalFeeAmountValue=0;        
        
        LIST<PGateway_Type__c>  payGateWayTypeList= new LIST<PGateway_Type__c>(); 
        payGateWayTypeList= payGateWayTypeDAOClass.pGateWayTypes();
        LIST<ticketSalesInner> ticketsInnerList= new LIST<ticketSalesInner>();
                  
        for(BLN_Item__c item: itemsList){
        
            system.debug('  ITEM ID '+item.Id);
            
            Decimal usedTicketsCount=0;
            Decimal feePrice=0;
            Decimal discountPrice=0;
            Decimal totalPrice= 0;
            
            // TOTAL ITEM COUNT ALONG WITH ID
            if(itemTotalCountMAP.get(item.Id) != NULL){
                if(itemTotalCountMAP.get(item.Id) != NULL){
                    usedTicketsCount= itemTotalCountMAP.get(item.Id);
                }else{
                    usedTicketsCount=0;
                }
            }else{
                usedTicketsCount=0;
            }
            system.debug(item.Id+'  ITEM IDSSSSSSSSSS  '+usedTicketsCount);
            
            //TOTAL ITEM FEE ALONG WITH ID
            
            if(TotalItemFeeAmountMAP.get(item.Id) != NULL){
                feePrice= TotalItemFeeAmountMAP.get(item.Id);
            }else{
                feePrice=0;
            }
            
            
            //-----------------------------------------------------------------Recalculating total Fee------------------
            
            // TOTAL ITEM DISCOUNT AMOUNT ALONG WITH ID
            
            if(itemTotalDiscountMAP.get(item.Id) != NULL){
                discountPrice= itemTotalDiscountMAP.get(item.Id);
            }else{
                discountPrice=0;
            }
            
            // TOTAL ITEM AMOUNT ALONG WITH ID
            if(itemTotalAmountMAP.get(item.Id) != NULL){
                if(itemTotalAmountMAP.get(item.Id) != NULL){
                    totalPrice= itemTotalAmountMAP.get(item.Id);
                }else{
                    totalPrice=0;
                }
                
            }else{
                totalPrice=0;
            }
            
            //For Payment Type values
            LIST<paymentTypeInner> paymentTypeInnerList= new LIST<paymentTypeInner>();    
            for(PGateway_Type__c gateWayType: payGateWayTypeList){
                
                Decimal paymentTypeCount= 0;
                Decimal paymentTypeDiscountAmount= 0;
                Decimal paymentTypeFeeAmount= 0;
                Decimal paymentTypeTotalAmount= 0;           
           
                // TOTAL ITEM COUNT ALONG WITH PAYMENT TYPE            
                if(itemCountMAP.containsKey(item.Id+'-'+gateWayType.Name)){
                    if(itemCountMAP.get(item.Id+'-'+gateWayType.Name) != NULL){
                        paymentTypeCount= itemCountMAP.get(item.Id+'-'+gateWayType.Name);
                    }else{
                        paymentTypeCount=0;
                    }
                }else{
                    paymentTypeCount=0;
                }
                
                // TOTAL ITEM DISCOUNT AMOUNT ALONG WITH PAYMENT TYPE
                if(itemDiscountMAP.containsKey(item.Id+'-'+gateWayType.Name)){
                    if(itemDiscountMAP.get(item.Id+'-'+gateWayType.Name) != NULL){
                        paymentTypeDiscountAmount= itemDiscountMAP.get(item.Id+'-'+gateWayType.Name);
                    }else{
                        paymentTypeDiscountAmount=0;
                    }    
                }else{
                    paymentTypeDiscountAmount=0;
                }
                
                
                // TOTAL ITEM FEE AMOUNT ALONG WITH PAYMENT TYPE          
            
                if(itemFeeMAP.containsKey(item.Id+'-'+gateWayType.Name)){
                    if(itemFeeMAP.get(item.Id+'-'+gateWayType.Name) != NULL){
                        paymentTypeFeeAmount= itemFeeMAP.get(item.Id+'-'+gateWayType.Name);
                    }else{
                        paymentTypeFeeAmount=0;
                    }
                    
                }else{
                    paymentTypeFeeAmount=0;
                }
                
                
                // TOTAL ITEM AMOUNT ALONG WITH PAYMENT TYPE
                if(itemAmountMAP.containsKey(item.Id+'-'+gateWayType.Name)){
                    if(itemAmountMAP.get(item.Id+'-'+gateWayType.Name) != NULL){
                        paymentTypeTotalAmount= itemAmountMAP.get(item.Id+'-'+gateWayType.Name);
                    }else{
                        paymentTypeTotalAmount=0;
                    }
                    
                }else{
                    paymentTypeTotalAmount=0;
                }
                if(paymentTypeCount != 0){
                    paymentTypeInnerList.add(new paymentTypeInner(gateWayType, paymentTypeCount, paymentTypeDiscountAmount, paymentTypeFeeAmount, paymentTypeTotalAmount));
                }
            }        
            if(paymentTypeInnerList.size() >0){
                ticketsInnerList.add(new ticketSalesInner(item, usedTicketsCount, discountPrice, feePrice, totalPrice, paymentTypeInnerList)); 
            }
            
            TotalTicketCount +=usedTicketsCount; 
            TotalDiscountAmount += discountPrice;
            TotalAmount += totalPrice;
            TotalFeeAmountValue += feePrice; 
          }
            
          LIST<paymentTypeInner> paymentTypeInnerList= new LIST<paymentTypeInner>();    
            for(PGateway_Type__c gateWayType: payGateWayTypeList){
                
                Decimal paymentTypeCount= 0;
                Decimal paymentTypeDiscountAmount= 0;
                Decimal paymentTypeFeeAmount= 0;
                Decimal paymentTypeTotalAmount= 0;           
           
                // TOTAL ITEM COUNT ALONG WITH PAYMENT TYPE            
                if(paymentTypeCountMAP.containsKey(gateWayType.Name)){
                    if(paymentTypeCountMAP.get(gateWayType.Name) != NULL){
                        paymentTypeCount= paymentTypeCountMAP.get(gateWayType.Name);
                    }else{
                        paymentTypeCount=0;
                    }
                }else{
                    paymentTypeCount=0;
                }
                
                // TOTAL ITEM DISCOUNT AMOUNT ALONG WITH PAYMENT TYPE
                if(paymentTypeDiscountMAP.containsKey(gateWayType.Name)){
                    if(paymentTypeDiscountMAP.get(gateWayType.Name) != NULL){
                        paymentTypeDiscountAmount= paymentTypeDiscountMAP.get(gateWayType.Name);
                    }else{
                        paymentTypeDiscountAmount=0;
                    }    
                }else{
                    paymentTypeDiscountAmount=0;
                }
                
                
                // TOTAL ITEM FEE AMOUNT ALONG WITH PAYMENT TYPE          
            
                if(paymentTypeFeeMAP.containsKey(gateWayType.Name)){
                    if(paymentTypeFeeMAP.get(gateWayType.Name) != NULL){
                        paymentTypeFeeAmount= paymentTypeFeeMAP.get(gateWayType.Name);
                    }else{
                        paymentTypeFeeAmount=0;
                    }
                    
                }else{
                    paymentTypeFeeAmount=0;
                }
                
                
                // TOTAL ITEM AMOUNT ALONG WITH PAYMENT TYPE
                if(paymentTypeAmountMAP.containsKey(gateWayType.Name)){
                    if(paymentTypeAmountMAP.get(gateWayType.Name) != NULL){
                        paymentTypeTotalAmount= paymentTypeAmountMAP.get(gateWayType.Name);
                    }else{
                        paymentTypeTotalAmount=0;
                    }
                    
                }else{
                    paymentTypeTotalAmount=0;
                }
                if(paymentTypeCount != 0){
                    paymentTypeInnerList.add(new paymentTypeInner(gateWayType, paymentTypeCount, paymentTypeDiscountAmount, paymentTypeFeeAmount, paymentTypeTotalAmount));
                }
            } 
            ticketsInnerList.add(new ticketSalesInner(new BLN_Item__c(), TotalTicketCount, TotalDiscountAmount, TotalFeeAmountValue, TotalAmount, paymentTypeInnerList));
        return ticketsInnerList;
    }
    
    
    public class ticketSalesInner{
        
        public BLN_Item__c ticketData{get; set;}
        public Decimal usedTickets{get; set;}
        public Decimal totalDiscount{get; set;}
        public Decimal totalFee{get; set;}
        public Decimal totalAmount{get; set;}
        public LIST<paymentTypeInner> paymentTypeInnerList{get; set;}
        
        public ticketSalesInner(BLN_Item__c ticketData, Decimal usedTickets, Decimal totalDiscount, Decimal totalFee, Decimal totalAmount, LIST<paymentTypeInner> paymentTypeInnerList){
            
            this.ticketData= ticketData;
            this.usedTickets= usedTickets;
            this.totalDiscount= totalDiscount;
            this.totalFee= totalFee;
            this.totalAmount= totalAmount;
            this.paymentTypeInnerList= paymentTypeInnerList;
            
        }
    }
    
    
    public class paymentTypeInner{
        
        public PGateway_Type__c paymentType{get; set;}
        public Decimal typeCount{get; set;}
        public Decimal typeDiscount{get; set;}
        public Decimal typeFee{get; set;}
        public Decimal typeAmount{get; set;}
                
        public paymentTypeInner(PGateway_Type__c paymentType, Decimal typeCount, Decimal typeDiscount, Decimal typeFee, Decimal typeAmount){
            
            this.paymentType= paymentType;
            this.typeCount= typeCount;
            this.typeDiscount= typeDiscount;
            this.typeFee= typeFee;
            this.typeAmount= typeAmount;
        }
    
    }
    
    }