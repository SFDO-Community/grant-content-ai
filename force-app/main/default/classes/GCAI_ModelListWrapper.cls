/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 */
public with sharing class GCAI_ModelListWrapper {
        // public String object; // list  object keyword not allowed in APEX
        @AuraEnabled  public List<GCAI_Model> data;

        public static GCAI_ModelListWrapper parse(String json) {
            return (GCAI_ModelListWrapper) System.JSON.deserialize(json, GCAI_ModelListWrapper.class);
        }
}