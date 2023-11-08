/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 */
public with sharing class GCAI_PromptTemplateSelector {
    
    public static List<GCAI_Prompt_Template__c> getTemplates(){
        return [SELECT Id, Name, Action_Type__c, Input__c, IsSelected__c, Language__c, Role__c, Sample_Prompt__c 
                FROM GCAI_Prompt_Template__c WITH SECURITY_ENFORCED];
    }
}