/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 */
public with sharing class GCAI_PromptCtrl {
    private final static String SF_NAMED_CREDENTIAL = 'callout:GCAI_API_KEY';
    private final static String OAI_MODEL_ENDPOINT = '/v1/models';
    // Local convinience wrapper class to parse returned results
    public class GCAI_ResponseWrapper {
        public GCAI_Response data;
        public GCAI_Error error;
        public GCAI_ResponseWrapper(){
            this.data = null;
            this.error = null;
        }
    }
    // Return list of OpenAI Models
    @AuraEnabled
    public static List<GCAI_Model> getModels(){
        List<GCAI_Model> modelList = new List<GCAI_Model>();
        HttpResponse response = calloutGetService(OAI_MODEL_ENDPOINT);
        // Parse the JSON response
        System.debug('GPT Model RESPONSE: ' + response.getStatusCode() + ' Status: ' + response.getStatus());
        String textResult = response.getBody();
        System.debug(response.getBody());
        if (response.getStatusCode() >= 400){
            // Parse error and set error result
            //res.error = GCAI_Error.parse(textResult);
            System.debug('ERROR Models: '+response);
        } else {
            // Parse result data and set to wrapper object
            GCAI_ModelListWrapper res = GCAI_ModelListWrapper.parse(textResult);
            modelList = res.data;
            System.debug('GET Model: ' + textResult);
        }

        return modelList;
    }
    // Send LLM request with user selected model
    @AuraEnabled
    public static List<GCAI_Response.GCAI_Choice> getGeneratedContent(String requestPromtText, String modelURL){
        List<GCAI_Response.GCAI_Choice> response = new List<GCAI_Response.GCAI_Choice>();
        GCAI_ResponseWrapper textResult = sendPromptRequest(requestPromtText);
        System.debug('### '+textResult);
        if(textResult.error != null){
            // handle error here
            //response.error = textResult.error;
            //response.issuccess = false;
            System.debug('ERROR GPT: '+textResult.error);
        }else{
            response = textResult.data.choices;
            /*
            // Covert response to blocks data
            List<GGW_ContentBlockWrapper> cbwResultList = new List<GGW_ContentBlockWrapper>();
            for (GCAI_Response.GCAI_Choice c : textResult.data.choices){
                GGW_ContentBlockWrapper cbw = new GGW_ContentBlockWrapper();
                cbw.isselected = false;
                cbw.title = 'Generated text '+c.index;
                cbw.displaytext = c.text;
                // Add otehr fields 
                cbwResultList.add(cbw);
            }
            response.issuccess = true;
            response.contentblocks = cbwResultList;*/
        }
        return response;
    }

    public static GCAI_ResponseWrapper sendPromptRequest(String str){
        GCAI_ResponseWrapper res = new GCAI_ResponseWrapper();
        GCAI_Request sfgpt = new GCAI_Request(str);
        String payload = sfgpt.getJSONString();
        System.debug('## REQUEST: ' + payload);
        // Call GPT API
        HttpResponse response = calloutPostService(payload, '/v1/completions');

        // Parse the JSON response
        String textResult = response.getBody();
        System.debug(response.getBody());
        if (response.getStatusCode() >= 400){
            // Parse error and set error result
            res.error = GCAI_Error.parse(textResult);
        } else {
            // Parse result data and set to wrapper object
            res.data = GCAI_Response.parse(textResult);
        }
        return res;
    } 
    // Generic method helper to make HTTP request
    // POST method
    // Call OpenAI API in synchronous method with payload
    // Parameters: 
    // payload - String  JSON payload for GPT API HTTP request
    // endpoint -  String URL endpoint in form of /v1/completions example
    private static HttpResponse calloutPostService(String payload, String endpoint){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(SF_NAMED_CREDENTIAL + endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');        

        System.debug('## GPT POST REQUEST: '+payload);
        // Set the body as a JSON object
        request.setBody(payload);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        System.debug('## POST RESPONSE CODE: ' + response.getStatusCode() + ' Status: ' + response.getStatus());
        System.debug('## POST RESPONSE DATA: ' + response.getBody());
        return response;
    }
    // Generic method helper to make HTTP request
    // GET HTTP method
    // Call OpenAI API in synchronous GET method NO payload
    // Parameters: 
    // endpoint -  String URL endpoint in form of /v1/completions example
    private static HttpResponse calloutGetService(String endpoint){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(SF_NAMED_CREDENTIAL + endpoint);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');        

        HttpResponse response = http.send(request);
        // Parse the JSON response
        System.debug('## GET RESPONSE CODE: ' + response.getStatusCode() + ' Status: ' + response.getStatus());
        System.debug('## GET RESPONSE DATA: ' + response.getBody());
        return response;
    }

    /**
     * Update text block selection, wire block to item and copy block text data for display and edits
     * 
     *
    @AuraEnabled
    public static void saveGeneratedSectionTextBlock(String itemid, String sectionid, String gentext){
        // Save new genarated block related to section
        GGW_Content_Block__c cb = new GGW_Content_Block__c();
        cb.name = '[AI Generated Content]';
        cb.Section__c = sectionid;
        cb.Description__c = gentext;
        if(Schema.sObjectType.GGW_Content_Block__c.isCreateable()){
            insert cb;
        }

        // Construct selected Item to update
        GGW_Selected_Item__c item = new GGW_Selected_Item__c();
        item.Id = itemid;
        item.Selected_Block__c = cb.Id;
        item.Text_Block__c = gentext; // Copy rich text from block to item for edits
        if(Schema.sObjectType.GGW_Selected_Item__c.isUpdateable()){
            update item;
        }

    }*/
}