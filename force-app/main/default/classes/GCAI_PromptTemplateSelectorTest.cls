/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 * @Author: igor.androsov 
 * @Date: 2023-12-09 16:08:19 
 * @Last Modified by: igor.androsov
 * @Last Modified time: 2023-12-09 16:57:47
 */
@isTest
public class GCAI_PromptTemplateSelectorTest {
    @isTest
    static void testGetTemplates() {
        List<GCAI_Prompt_Template__c> templates = new List<GCAI_Prompt_Template__c>();
        for (Integer i = 0; i < 10; i++) {
            GCAI_Prompt_Template__c template = new GCAI_Prompt_Template__c();
            template.Name = 'Test Template ' + i;
            template.Sample_Prompt__c = 'What is your name?';
            template.Language__c = 'EN';
            template.Input__c = 'Some input text';
            template.Role__c = 'Developer';
            template.Action_Type__c = 'Analyze';
            template.IsSelected__c = true;
            templates.add(template);
        }
        
        insert templates;

        Test.startTest();

        List<GCAI_Prompt_Template__c> returnedTemplates = GCAI_PromptTemplateSelector.getTemplates();

        Test.stopTest();

        System.assertEquals(10, returnedTemplates.size(), 'Expected 10 prompt templates');
        System.assertEquals('Test Template 0', returnedTemplates[0].Name, 'Template name did not match');
        for (GCAI_Prompt_Template__c template : returnedTemplates) {
            System.assertEquals('Some input text', template.Input__c, 'Template name did not match');
        }
    }
}
