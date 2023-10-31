/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 */
public with sharing class GCAI_Model {
        @AuraEnabled public String id;	//text-davinci-001
        // public String object;	// Example data: model  object keyword not allowed in APEX
        @AuraEnabled public Integer created;	//1649364042
        @AuraEnabled public String owned_by;	//openai
        @AuraEnabled public GCAI_permission[] permission;
        @AuraEnabled public String root;	//text-davinci-001
        @AuraEnabled public GCAI_parent parent;

        class GCAI_permission {
            @AuraEnabled public String id;	//modelperm-MVM5NfoRjXkDve3uQW3YZDDt
            //public String object;	//model_permission Identifier name is reserved: object
            @AuraEnabled public Integer created;	//1669066355
            @AuraEnabled public boolean allow_create_engine;
            @AuraEnabled public boolean allow_sampling;
            @AuraEnabled public boolean allow_logprobs;
            @AuraEnabled public boolean allow_search_indices;
            @AuraEnabled public boolean allow_view;
            @AuraEnabled public boolean allow_fine_tuning;
            @AuraEnabled public String organization;	//*
            //public GCAI_group group; // Identifier name is reserved: group                                                            
            @AuraEnabled public boolean is_blocking;
        }
        class GCAI_group {
        }
        class GCAI_parent {
        }

        public static GCAI_Model parse(String json){
            return (GCAI_Model) System.JSON.deserialize(json, GCAI_Model.class);
        }
    
}