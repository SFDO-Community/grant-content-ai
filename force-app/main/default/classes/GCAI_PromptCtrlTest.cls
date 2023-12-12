/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 * @Author: igor.androsov 
 * @Date: 2023-12-09 16:27:05 
 * @Last Modified by: igor.androsov
 * @Last Modified time: 2023-12-09 18:35:25
 */
@isTest
public class GCAI_PromptCtrlTest {
    @isTest
    static void testGetModels() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockAIModelsResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
                
        List<GCAI_Model> lst = GCAI_PromptCtrl.getModels();

        System.assertEquals(3, lst.size(), 'Returned models missmatch');
        //System.assertEquals(200, res.getStatusCode(), 'Return code not 200');
        //System.assertEquals('application/json', res.getHeader('Content-Type'), 'Type nmot JSON');   
        //System.assertEquals('{"hah":"fooled you"}', res.getBody(), 'Invalid response body');
        
    }

    @isTest
    static void testGetGeneratedContent() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockAITextResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

        GCAI_PromptCtrl ctrl = new GCAI_PromptCtrl();

        Test.startTest();
        List<GCAI_Response.GCAI_Choice> result = GCAI_PromptCtrl.getGeneratedContent('Create executivre summary', 'dummymodel');
        Test.stopTest();

        System.assertEquals(1, result.size(), 'List is not 1');
        System.assertEquals('stop', result[0].finish_reason, 'Invalid finish_reason data');
        System.assertEquals(0, result[0].index, 'Index is not 0');
        System.assertEquals('\n\nThis is a test text response from AI!', result[0].text, 'Text dresponse not valid');

    }
/*
    @isTest
    static void testSendPromptRequest() {
        GCAI_PromptCtrl ctrl = new GCAI_PromptCtrl();

        Test.startTest();
        GCAI_PromptCtrl.sendPromptRequest('test', 'test');
        Test.stopTest();
    }

    @isTest
    static void testCalloutGetService() {
        GCAI_PromptCtrl ctrl = new GCAI_PromptCtrl();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GCAI_PromptCtrlMock());
        GCAI_PromptCtrl.calloutGetService('test');
        Test.stopTest();
    }

    @isTest
    static void testCalloutPostService() {
        GCAI_PromptCtrl ctrl = new GCAI_PromptCtrl();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GCAI_PromptCtrlMock());
        GCAI_PromptCtrl.calloutPostService('test', 'test');
        Test.stopTest();
    }
    */
}
