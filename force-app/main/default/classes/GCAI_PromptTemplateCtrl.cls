/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 */

public with sharing class GCAI_PromptTemplateCtrl {
    @AuraEnabled(cacheable=true)
    public static List<GCAI_Prompt_Template__c> getTemplates(){
        List<GCAI_Prompt_Template__c> templateList = GCAI_PromptTemplateSelector.getTemplates();
        return templateList;
    }
}