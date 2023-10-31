/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 */
public with sharing class GCAI_Response {
    @AuraEnabled public String id;
    // public String object {get; set;} // This is keyword object in APEX cannot be used commenetd for info only
    @AuraEnabled public Integer created;
    @AuraEnabled public String model;
    @AuraEnabled public List<GCAI_Choice > choices;
    @AuraEnabled public GCAI_Usage usage;

    public GCAI_Response() {}

    public static GCAI_Response parse(String json) {
        return (GCAI_Response) System.JSON.deserialize(json, GCAI_Response.class);
    }

    public class GCAI_Choice {
        @AuraEnabled public String text;
        @AuraEnabled public Integer index;
        @AuraEnabled public Double logprobs;
        @AuraEnabled public String finish_reason;

        public GCAI_Choice(){}
    }

    public class GCAI_Usage {
        @AuraEnabled public Integer prompt_tokens;
        @AuraEnabled public Integer completion_tokens;
        @AuraEnabled public Integer total_tokens;

        public GCAI_Usage(){}
    }    
}