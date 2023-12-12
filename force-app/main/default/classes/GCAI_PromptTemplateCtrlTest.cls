/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 *
 * @Author: igor.androsov 
 * @Date: 2023-12-09 16:10:37 
 * @Last Modified by: igor.androsov
 * @Last Modified time: 2023-12-09 16:51:41
 */

 @isTest
 public class GCAI_PromptTemplateCtrlTest {
     @isTest
     static void testGetTemplates() {
         // Create test data
         GCAI_Prompt_Template__c template = new GCAI_Prompt_Template__c();
         template.Name = 'Test Template';
         template.Sample_Prompt__c = 'Craetae executive summmary text';
         template.Language__c = 'EN';
         template.Input__c = 'Some input text';
         template.Role__c = 'Developer';
         template.Action_Type__c = 'Create';
         template.IsSelected__c = true;
         insert template;
 
         // Call the method to test
         List<GCAI_Prompt_Template__c> templates = GCAI_PromptTemplateCtrl.getTemplates();
 
         // Assert the result
         System.assertEquals(1, templates.size(), 'Expected 1 prompt template');
         System.assertEquals('Test Template', templates[0].Name, 'Temaplte name did not match');
         System.assertEquals('Craetae executive summmary text', templates[0].Sample_Prompt__c, 'Invalid prompt');
     }
 }
 