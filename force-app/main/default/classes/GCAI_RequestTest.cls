/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 */

 @IsTest
public class GCAI_RequestTest {
    @isTest
    static void requestTest() {
        GCAI_Request req = new GCAI_Request();
        String str = req.getJSONString();
        System.assertEquals('gpt-3.5-turbo-instruct',req.model,'Invalid moel constructor');
        System.assert(str != null, 'Failed to parse request');
    }
    @isTest
    static void requestPromptTest(){
        GCAI_Request req = new GCAI_Request('Generate test code for apex');
        String str = req.getJSONString();
        System.assertEquals('text-davinci-003',req.model,'Invalid moel constructor');
        System.assertEquals('Generate test code for apex', req.prompt,'No prompt text');
        System.assert(str != null, 'Failed to parse request');
    }
}