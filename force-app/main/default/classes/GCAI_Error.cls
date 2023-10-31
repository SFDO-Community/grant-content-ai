/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 * GCAI_Error class support Errors from OpenAI API requests
 * 
 */
public with sharing class GCAI_Error {
	public class Error {
		@AuraEnabled public String message;
		@AuraEnabled public String type;
		@AuraEnabled public String param;
		@AuraEnabled public Integer code;
	}

	@AuraEnabled public Error error;
	
	public static GCAI_Error parse(String json) {
		return (GCAI_Error) System.JSON.deserialize(json, GCAI_Error.class);
	}

}