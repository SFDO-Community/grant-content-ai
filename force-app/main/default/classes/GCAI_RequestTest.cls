/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 * @Author: igor.androsov 
 * @Date: 2023-12-09 15:49:51 
 * @Last Modified by: igor.androsov
 * @Last Modified time: 2023-12-09 15:56:49
 */
 @IsTest
public class GCAI_RequestTest {
    @isTest
    static void requestTest() {
        GCAI_Request req = new GCAI_Request();
        // Add Messages for testing
        List<GCAI_Request.Message> msgList = new List<GCAI_Request.Message>();
        GCAI_Request.Message msg = new GCAI_Request.Message();
        msg.role = 'dummy-role';
        msg.content = 'dummy test content';
        msgList.add(msg);
        req.messages = msgList;
        
        String str = req.getJSONString();
        System.assertEquals('gpt-3.5-turbo-instruct',req.model,'Invalid model constructor');
        System.assert(str != null, 'Failed to parse request');
    }
    @isTest
    static void requestPromptTest(){
        GCAI_Request req = new GCAI_Request('Generate test code for apex');
        String str = req.getJSONString();
        System.assertEquals('text-davinci-003',req.model,'Invalid model constructor');
        System.assertEquals('Generate test code for apex', req.prompt,'No prompt text');
        System.assert(str != null, 'Failed to parse request');
    }
}